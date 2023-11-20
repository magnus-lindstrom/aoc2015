local u = require 'src/utils'
local input = u.lines_from('inputs/17')

local function get_buckets()
	local buckets = {}
	for _, line in ipairs(input) do
		local size = tonumber(line)
		if size == nil then
			os.exit(1)
		else
			if buckets[size] == nil then
				buckets[size] = 1
			else
				buckets[size] = buckets[size] + 1
			end
		end
	end
	return buckets
end

local function a()
	local buckets = get_buckets()
	u.print_table(buckets)
	print('17a:', 0)
end

local function b()
	print('17b:', 0)
end

a()
b()
