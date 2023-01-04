-- local input = u.lines_from('inputs/12')[1]
local input = "[5,6,[2,1],-301]"

local function get_sum_of_obj(i_start)
	local sum = 0
	-- TODO
	return sum, input:len()
end

local function get_sum_of_list(i_start)
	local sum = 0
	-- assume that the opening [ char is i_start
	local i = i_start + 1
	while (i <= input:len()) do
		local char = input:sub(i,i)

		if char == '[' then
			local sum_add, i_new = get_sum_of_list(i)
			sum = sum + sum_add
			i = i_new + 1
		elseif char == ']' then
			return sum, i -- return the index of closing bracket
		elseif char:match("[%d-]") ~= nil then -- found start of number
			local nr_start = i
			for j = i+1, input:len() do
				local j_char = input:sub(j,j)
				if j_char:match("[%d-]") == nil then -- no longer a number char
					sum = sum + tonumber(input:sub(nr_start, j-1))
					i = j
					break
				end
			end
		elseif char == '{' then
			local sum_add, i_new = get_sum_of_obj(i)
			sum = sum + sum_add
			i = i_new
		end

		i = i + 1
	end
	return sum, input:len()
end

local function a()
	local sum = 0
	for word in string.gmatch(input, "-?%d+") do
		sum = sum + tonumber(word)
	end
	print('12a:', sum)
end

local function b()
	local sum, _ = get_sum_of_list(1)


	print('12b:', sum)
end

a()
b()
