local utils = {}

function utils.table_max(table)
	local max = -math.huge
	for _, value in pairs(table) do
		if value > max then
			max = value
		end
	end
	return max
end

function utils.flatten_table(table)
	local output = {}
	local i = 1
	for _, value in pairs(table) do
		if type(value) == "table" then
			local inner_tbl = utils.flatten_table(value)
			for _, inner_value in pairs(inner_tbl) do
				output[i] = inner_value
				i = i + 1
			end
		else
			output[i] = value
			i = i + 1
		end
	end
	return output
end

function utils.table_copy(table)
	local output = {}
	for key, value in pairs(table) do
		if type(value) == "table" then
			local tbl_cpy = utils.table_copy(value)
			output[key] = tbl_cpy
		else
			output[key] = value
		end
	end
	return output
end

function utils.assert_that_file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	if f == nil then
		print("File "..file.." does not exist. Exiting.")
		os.exit()
	end
end

function utils.lines_from(file)
	utils.assert_that_file_exists(file)
	local lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

function utils.split_string_by_substring(str, substr)
	local output = {}
	for match in string.gmatch(str, "[^"..substr.."]+") do
		output[#output + 1] = match
	end
	return output
end

function utils.table_length(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

function utils.matrix_fields(outer_table)
	local count = 0
	for _,inner_table in pairs(outer_table) do
		if type(inner_table) == "table" then
			for _ in pairs(inner_table) do
				count = count + 1
			end
		end
	end
	return count
end

function utils.get_table_string(table)
	local output = ""
	for key, value in pairs(table) do
		if type(value) == "table" then
			output = output.."\n"..key.."\n"
			local inner_table_string = utils.get_table_string(value)
			for _, line in pairs(utils.split_string_by_substring(inner_table_string, '\n')) do
				output = output..'\t'..line..'\n'
			end
			output = string.sub(output, 1, -2) -- remove the extra \n
		else
			output = output..'\n'..key..'\t'..tostring(value)
		end
	end
	return string.sub(output, 2) -- remove the extra \n
end

function utils.get_string_of_table_keys(table)
	local output = ""
	for key in pairs(table) do
		output = output..key..', '
	end
	return string.sub(output, 1, -3) -- remove the two trailing chars ' ' and ','
end

function utils.print_table(table)
	print(utils.get_table_string(table))
end

function utils.exit(str)
	print(str)
	os.exit()
end

return utils
