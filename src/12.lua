local u = require 'src/utils'

local input = u.lines_from('inputs/12')[1]

local sum = 0
-- for word in string.gmatch('--12  2434.43 34', "-?%d+") do
for word in string.gmatch(input, "-?%d+") do
	sum = sum + tonumber(word)
	--print(word)
end
print(sum)

--[[
local nr = nil
for i = 1, input:len() do
	prin
end
]]
