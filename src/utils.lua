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

return utils
