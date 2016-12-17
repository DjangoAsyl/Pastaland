--[[
	
	No balance, no cry, RRRRastafaray! 

]]--

local playermsg = require"std.playermsg"
local crynotice = "\f3######################################################################################\f7\n \f7 Please seek professional help, your obsession with balance is unhealthy!\n\f3######################################################################################\f7"
local function noBalance_noCry (info)
	if info.text:match("^%s*[Bb]alance%s*$") then info.skip = true end
	playermsg(crynotice, info.ci)
end
spaghetti.addhook(server.N_TEXT, noBalance_noCry) 
