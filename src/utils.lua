local utils = {}

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

function utils.exit(str)
  print(str)
  os.exit()
end

return utils
