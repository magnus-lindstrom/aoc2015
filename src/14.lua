local u = require 'src/utils'
local input = u.lines_from('inputs/14')

local function get_reindeer()
	local reindeer = {}
	for _, line in ipairs(input) do
		local words = u.split_string_by_substring(line, ' ')
		local name = words[1]
		local speed = words[4]
		local sprint_duration = words[7]
		local rest_duration = words[14]

		reindeer[name] = {}
		reindeer[name]['speed'] = speed
		reindeer[name]['sprint_duration'] = sprint_duration
		reindeer[name]['rest_duration'] = rest_duration
	end
	return reindeer
end

local function a()
	local reindeer = get_reindeer()

	local max_dist = 0

	for _, v in pairs(reindeer) do
		local time = 0
		local state = "ready"
		local flight_left
		local distance = 0
		while time < 2503 do
			if state == "ready" then
				state = "flying"
				flight_left = v['sprint_duration'] - 1
				distance = distance + v['speed']
				time = time + 1
			elseif state == "flying" then
				flight_left = flight_left - 1
				distance = distance + v['speed']
				if flight_left == 0 then
					state = "flight_done"
				end
				time = time + 1
			elseif state == "flight_done" then
				state = "ready"
				time = time + v['rest_duration']
			end
		end
		if distance > max_dist then
			max_dist = distance
		end
	end

	print('14a:', max_dist)
end

local function b()
	local reindeer = get_reindeer()

	local dist_table = {}
	for name, _ in pairs(reindeer) do
		dist_table[name] = {}
	end

	for name, v in pairs(reindeer) do
		local time = 0
		local state = "ready"
		local flight_left
		local distance = 0
		while time < 2503 do
			if state == "ready" then
				state = "flying"
				flight_left = v['sprint_duration'] - 1
				distance = distance + v['speed']
				time = time + 1
				dist_table[name][time] = distance
			elseif state == "flying" then
				flight_left = flight_left - 1
				distance = distance + v['speed']
				if flight_left == 0 then
					state = "flight_done"
				end
				time = time + 1
				dist_table[name][time] = distance
			elseif state == "flight_done" then
				state = "ready"
				for t = time+1, time+v['rest_duration'] do
					dist_table[name][t] = distance
				end
				time = time + v['rest_duration']
			end
		end
	end

	local raindeer_points = {}
	for name, _ in pairs(reindeer) do
		raindeer_points[name] = 0
	end
	for t = 1, 2503 do
		local to_get_points = {}
		local max_dist = 0
		for name, _ in pairs(reindeer) do
			if dist_table[name][t] > max_dist then
				to_get_points = {[1] = name}
				max_dist = dist_table[name][t]
			elseif dist_table[name][t] == max_dist then
				table.insert(to_get_points, name)
			end
		end
		for _, name in pairs(to_get_points) do
			raindeer_points[name] = raindeer_points[name] + 1
		end
	end

	print('14b:', u.table_max(raindeer_points))
end

a()
b()
