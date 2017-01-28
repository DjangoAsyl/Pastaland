--[[

	ringbuffer with some utils 

]]--
local module = {}
function module.new (_size, _fill) -- expects a table: this.new{size=1, fill=2}
	local s = _size or nil
	local f = _fill or nil
	local rbuf
	if s then rbuf = {last = 0, size = s } end
	if f then 
		for i = 1, s do 
			rbuf[i] = f
		end
	end
	return rbuf
end

function module.push (list, value)
	local last = list.last + 1
	if last > list.size then last = 1 end 
	list.last = last 
	list[last] = value
end

function module.mean (list)
	if list.size <1 then return nil end
	local counter = 0 -- adding an extra counter, in case the buffer didn't overflow yet.
	local sum = 0
	for i,v in ipairs(list) do
		sum = sum + v 
		counter = counter + 1
	end
	return sum/counter, sum, counter
end

function module.sum (list)
	local mean, sum, counter = module.mean(list)
	return sum
end

function module.counter (list) -- if less elements than .size
	local mean, sum, counter = module.mean(list)
	return counter
end

function module.max (list)
	local max = list[1] or 0
	for i,v in ipairs(list) do 
		if v > max then max = v end
	end
	return max
end

function module.min (list)
	local min = list[1] or 0
	for i,v in ipairs(list) do 
		if v < min then min = v end
	end
	return min
end

function module.variation (list)
	return (module.max(list) - module.min(list)) or 0
end

return module 