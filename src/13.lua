local u = require 'src/utils'
local input = u.lines_from('inputs/13')

local permutations, permute

function permutations(N)
	local level, set, co = -1, {}, nil
	for i = 1, N do set[i] = 0 end
	co = coroutine.create(function () permute(set, level, N, 1) end)
	return function ()
		local _, p = coroutine.resume(co)
		return p
	end
end

function permute(set, level, N, k)
	level = level + 1
	set[k] = level
	if level == N then
		coroutine.yield(set)
	else
		for i = 1, N do
			if set[i] == 0 then
				permute(set, level, N, i)
			end
		end
	end

	level = level - 1
	set[k] = 0
end

local function get_happiness_sum(happiness_table, indexes)
	local sum = 0
	for p in permutations(#happiness_table-1) do
		for i = 1, #happiness_table-2 do
			sum = sum + happiness_table

		end
	end
end

local happiness_table = {}
for _, line in ipairs(input) do
	local words = u.split_string_by_substring(line, ' ')
	local person1 = words[1]
	local person2 = words[11]:sub(1, -2)
	local happiness = tonumber(words[4])
	if happiness_table[person1] == nil then
		happiness_table[person1] = {}
	end

	happiness_table[person1][person2] = happiness
end
print(u.get_table_string(happiness_table))

for p in permutations(#happiness_table - 1) do
	for k, v in pairs(p) do
		print(k, v)
	end
end
