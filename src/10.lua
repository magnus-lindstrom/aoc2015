local u = require 'src/utils'

local function tbl_from_str(str)
	local tbl = {}
	local i = 1
	local index = 1
	while i <= str:len() do
		local digit = str:sub(i,i)
		local reps = 1
		for j = i + 1, str:len() do
			if str:sub(j,j) == digit then
				reps = reps + 1
			else
				break
			end
		end
		tbl[index] = {[reps] = tonumber(digit)}
		index = index + 1
		i = i + reps
	end
	return tbl
end

local function evolve_tbl(table)
	local output = {}
	local current_digit
	local reps
	local i = 0 -- start at 0 because first index must be 1 for ipairs to work later

	for _, inner_table in ipairs(table) do
		for k, v in pairs(inner_table) do
			if k == current_digit then
				reps = reps + 1
			else
				if current_digit ~= nil then
					output[i] = {[reps] = current_digit}
				end
				i = i + 1
				current_digit = k
				reps = 1
			end

			if v == current_digit then
				reps = reps + 1
			else
				output[i] = {[reps] = current_digit}
				i = i + 1
				current_digit = v
				reps = 1
			end
		end
	end
	output[i] = {[reps] = current_digit}
	return output
end

local function str_len_from_tbl(table)
	local len = 0
	for _, inner_table in ipairs(table) do
		for k, v in pairs(inner_table) do
			local nr_as_string = tostring(v)
			len = len + k * nr_as_string:len()
		end
	end
	return len
end

local function main(times)
	-- Just keep a table representation of the string, with subtables defining each streak of digits
	-- So, 1121 would be the table
	-- {
	--     {2: 1},
	--     {1: 2},
	--     {1: 1},
	-- }
	--
	-- This is much faster that actually having a string that grows in size
	local str = u.lines_from('inputs/10')[1]
	local tbl = tbl_from_str(str)

	for _ = 1, times do
		tbl = evolve_tbl(tbl)
	end
	return str_len_from_tbl(tbl)
end

local a = main(40)
print('10a:', a)
local b = main(50)
print('10b:', b)
