--[[

	Spaghettimod anti-lagger module

    to do:  - auto unspec (spectators seem to have a packet delta von about 250, client.cpp:1030)
            - integrate with spectator jail
            - spectator hook ;) oops
]]--

local module = {}

local playermsg, commands, iterators, L = require"std.playermsg", require"std.commands", require"std.iterators", require"utils.lambda"

local obuf = require"std.ringbuf"

--[[ measurement - disable at the end! ]]--
function laglog (logstring) -- only for the measurements
    local f = assert(io.open("var/antilag.log", "a"))
    t = os.date("!*t")
    curtime = string.format("%s.%s.%s - %s:%s:%s", t.day, t.month, t.year, t.hour, t.min, t.sec)
    f:write(curtime, ",", logstring, "\n")
    f:close()
end

function log_lag_measurements() -- only for the measurements
    laglog("# -=-=-=-=-=-= measurement")
    laglog("# players lags")
    for ci in iterators.all() do 
        laglog("_________________")
        local logstring = string.format("cn: %s, name: %s, lags: %s, last_packet: %s, mean pdelta: %s, max pdelta: %s, min pdelta: %s, variation: %s", ci.clientnum, ci.name, ci.extra.lags, ci.extra.last_packet, obuf.mean(ci.extra.pkg_delta), obuf.max(ci.extra.pkg_delta), obuf.min(ci.extra.pkg_delta), obuf.variation(ci.extra.pkg_delta))
        laglog(logstring)
        
        local s = " "
        for k, v in pairs(ci.extra.pkg_delta) do 
            s = s .. tostring(v) .. " " 
        end
        laglog(s)

        laglog("_________________")
    end
    laglog("# -=-=-=-=-=-= end")
end

--[[ 
        constants
]]--


local ANTILAG = true
local pkg_delta_buf_size = 100 -- just needs to be large enough (100 ~ 3s, 304 ~ 10s, 1000 ~ 33s)
local MAXPACKETFLUX = 40
local MAXWARNINGS = 30 -- roughly equal to CHECK_INTERVAL/33
local CHECK_INTERVAL = 2000 -- check every two seconds

--[[
        hooks
]]--

-- clientconnect
local function setup (info) -- setup initial state of the lagvars
    local ci = info.ci or info
    if ci.extra.lagger then return end -- do not setup laggers
    ci.extra.last_packet = engine.totalmillis
    ci.extra.pkg_delta = obuf.new(pkg_delta_buf_size, 33) -- fill with 33, otherwise everyone is fucked
    ci.extra.lags = 0 
end
spaghetti.addhook("clientconnect", setup)

-- clientdisconnect
local lagger_spam = {}
local function lagger_dc (info) -- remove lagger_spam if lagger disconnects
    if info.ci.extra.lagger then 
        if lagger_spam[info.ci.clientnum] then 
            spaghetti.cancel(lagger_spam[info.ci.clientnum])
            lagger_spam[info.ci.clientnum] = nil
        end
    end
end
spaghetti.addhook("clientdisconnect", lagger_dc)

-- enetpacket
local function received_packet (info)
    if info.ci.state.state ~= engine.CS_ALIVE then info.ci.extra.last_packet = -1; return end -- we dont want info of dead people 
    if info.ci.extra.last_packet == -1 then info.ci.extra.last_packet = engine.totalmillis; return end -- player alive now, we take that timestamp
    local d = engine.totalmillis - info.ci.extra.last_packet
    if d >= 33 then obuf.push(info.ci.extra.pkg_delta, d) end -- don't double count simultanious arriving packets
    info.ci.extra.last_packet = engine.totalmillis
end
spaghetti.addhook("enetpacket", received_packet)

-- N_SPECTATOR
local function jail_lagger (info) if info.ci.extra.lagger then info.skip = true end end
spaghetti.addhook(server.N_SPECTATOR, jail_lagger)

--[[
        anti-lag core
]]--

local function spec_lagger (ci)
    server.forcespectator(ci)
    ci.extra.lagger = true
    local lagnotice = "\n\f3[LAG PROTECTION] WARNING:\f7 The server has removed you from the game due to lag.\n        Please fix your connection and reconnect!\n"
    playermsg(lagnotice, ci)
    lagger_spam[ci.clientnum] = spaghetti.later(15000, L"if ci then playermsg(lagnotice, ci) end", true)
    server.sendservmsg(string.format("\f3[LAG PROTECTION]\f7 Moved %s to spec due to lag!", ci.name))
    engine.writelog(string.format("lag protection: Moved %s to spec due to severe lags!", ci.name))
end

local function check_violation (ci)
    if ci.extra.lags > MAXWARNINGS then 
        spec_lagger(ci) 
    elseif ci.extra.lags > MAXWARNINGS/3 and ci.extra.lags < MAXWARNINGS*(2/3) then 
        playermsg("\f3[LAG PROTECTION]\f7 WARNING: The server has detected \f2lag!\f7 Stop all other internet activity!", ci)
    elseif ci.extra.lags > MAXWARNINGS*(2/3) and ci.extra.lags < MAXWARNINGS then 
        playermsg("\f3[LAG PROTECTION]\f7 WARNING: The server has detected \f3lag!\f7 Please consider spectating yourself!", ci)
    end
end

local function check_players (info)
    if not ANTILAG then return end
    for ci in iterators.players() do 
        lag = obuf.mean(ci.extra.pkg_delta)

        if lag > MAXPACKETFLUX then 
            ci.extra.lags = ci.extra.lags + 1
            check_violation(ci)
        else
            if ci.extra.lags > 0 then ci.extra.lags = ci.extra.lags - 1 end 
        end
    end
end

local function antilag (info)
        if check_lags then -- delete previous later check
            spaghetti.cancel(check_lags) 
            check_lags = nil
        end

        for ci in iterators.all() do -- reset all clients lagvars
            setup(ci)
        end

        check_lags = spaghetti.later(CHECK_INTERVAL, check_players, true)
    end
-- start protection
spaghetti.addhook("changemap", antilag)

--[[
        commands

]]--

-- adjust variables
local function update_vars (info)
    if info.ci.privilege < server.PRIV_ADMIN then return playermsg("Insufficient privilege to change lagvars.", info.ci) end
    local _pkg_delta_buf_size, _MAXPACKETFLUX, _MAXWARNINGS, _CHECK_INTERVAL = info.args:match("^(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s*$")
    
    -- when no argument, don't restart, no no no
    if not _pkg_delta_buf_size or not _MAXWARNINGS or not _MAXWARNINGS or not _CHECK_INTERVAL then 
        local m = string.format("variables are: pkg_delta_buf_size = %s, MAXPACKETFLUX = %s, MAXWARNINGS = %s, CHECK_INTERVAL = %s", pkg_delta_buf_size, MAXPACKETFLUX, MAXWARNINGS, CHECK_INTERVAL)
        playermsg(m, info.ci)
        return
    end

    pkg_delta_buf_size = tonumber(_pkg_delta_buf_size) or pkg_delta_buf_size
    MAXPACKETFLUX = tonumber(_MAXPACKETFLUX) or MAXPACKETFLUX
    MAXWARNINGS = tonumber(_MAXWARNINGS) or MAXWARNINGS
    CHECK_INTERVAL = tonumber(_CHECK_INTERVAL) or CHECK_INTERVAL
    

    local msg = string.format("set variables to: pkg_delta_buf_size = %s, MAXPACKETFLUX = %s, MAXWARNINGS = %s, CHECK_INTERVAL = %s", pkg_delta_buf_size, MAXPACKETFLUX, MAXWARNINGS, CHECK_INTERVAL)
    playermsg(msg, info.ci)
    for ci in iterators.all() do setup(ci) end

    antilag()
    playermsg("Restarted check loop", ci)
end
commands.add("lagvars", update_vars, "#lagprotect [pkg_delta_buf_size] [MAXPACKETFLUX] [MAXWARNINGS] [CHECK_INTERVAL]\nAdjusts the lagprotect parameters - if you don't know, you'd better keep your hands off!")

-- toggle antilag
local function onoff (info) -- only PLAG for now
    if info.ci.privilege < server.PRIV_MASTER then return playermsg("Insufficient privilege to change lagprotection.", info.ci) end
    if ANTILAG then 
        ANTILAG = false 
        playermsg("lagprotect: off", info.ci)
    else 
        ANTILAG = true 
        playermsg("lagprotect: on", info.ci)
    end
end
commands.add("lagprotect", onoff, "#lagprotect\nToggles lagprotection on|off - If you don't know, you'd better keep your hands off!")

--[[ measurement 
spaghetti.later(1000, function (info) 
    if engine.hasnonlocalclients() then log_lag_measurements() end 
end, true)
]]--

return module