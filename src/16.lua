local u = require 'src/utils'
local input = u.lines_from('inputs/16')

local function get_all_sues()
	local all_sues = {}
	for _, line in pairs(input) do

		local words = u.split_string_by_substring(line, ' ')
		local sue_nr = tonumber(string.sub(words[2], 1, -2)) -- remove training ':'
		if sue_nr == nil then
			os.exit(1)
		else
			all_sues[sue_nr] = {}
		end

		local i_possession = 3
		while true do
			local break_after_iter = false
			local item = string.sub(words[i_possession], 1, -2)
			local count = words[i_possession + 1]

			if count:sub(-1, -1) ~= ',' then
				break_after_iter = true
			else
				count = count:sub(1, -2) -- remove trailing comma
			end
			count = tonumber(count)

			all_sues[sue_nr][item] = count

			if break_after_iter == true then
				break
			end
			i_possession = i_possession + 2
		end
	end
	return all_sues
end

local function a()
	local sues = get_all_sues()
	local right_sue_nr = 0

	local target_sue = {children = 3, cats = 7, samoyeds = 2, pomeranians = 3, akitas = 0, vizslas = 0, goldfish = 5, trees = 3, cars = 2, perfumes = 1}
	for i, sue in ipairs(sues) do
		local right_sue = true
		for item, count in pairs(sue) do
			if target_sue[item] ~= count then
				right_sue = false
				break
			end
		end
		if right_sue == true then
			right_sue_nr = i
			break
		end
	end


	print('16a:', right_sue_nr)
end

local function b()
	local sues = get_all_sues()
	local right_sue_nr = 0

	local target_sue = {children = 3, cats = 7, samoyeds = 2, pomeranians = 3, akitas = 0, vizslas = 0, goldfish = 5, trees = 3, cars = 2, perfumes = 1}
	for i, sue in ipairs(sues) do
		local right_sue = true
		for item, count in pairs(sue) do
			if item == 'cats' or item == 'trees' then
				-- count should be greater than target sue
				if count <= target_sue[item] then
					right_sue = false
					break
				end
			elseif item == 'pomeranians' or item == 'goldfish' then
				-- count should be smaller than target sue
				if count >= target_sue[item] then
					right_sue = false
					break
				end
			else
				if target_sue[item] ~= count then
					right_sue = false
					break
				end
			end
		end
		if right_sue == true then
			right_sue_nr = i
			break
		end
	end

	print('16b:', right_sue_nr)
end

a()
b()
