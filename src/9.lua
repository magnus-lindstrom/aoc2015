local utils = require 'src/utils'

local lines = utils.lines_from('inputs/9')

local function get_distances(input_lines)
	local distances = {}
	for _, line in pairs(input_lines) do
		local words = utils.split_string_by_substring(line, ' ')
		if distances[words[1]] == nil then
			distances[words[1]] = {}
		end
		if distances[words[1]][words[3]] == nil then
			distances[words[1]][words[3]] = tonumber(words[5])
		end

		if distances[words[3]] == nil then
			distances[words[3]] = {}
		end
		if distances[words[3]][words[1]] == nil then
			distances[words[3]][words[1]] = tonumber(words[5])
		end
	end
	return distances
end

local distances = get_distances(lines)

for start, _ in pairs(distances) do
	local starting_node = {["distance"] = 0, ["have been"] = {start}}
	while(true) do
		local min_i
		local min_dist = math.huge
		for i, v in pairs(distances) do
			if v['distance'] < min_dist then
				min_i = i
				min_dist = v['distance']
			end
		end
	end
end

		--utils.print_table(starting_node)
