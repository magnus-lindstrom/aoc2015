local utils = require 'src/utils'

local key = utils.lines_from("inputs/4")[1]

local hash

local i = 254000
while(true) do
  i = i + 1
  if i % 10000 == 0 then
    print(i)
  end

  local handle = io.popen("echo -n '"..key..i.."' | md5sum --zero")
  if handle ~= nil then
    hash = handle:read("*a")
    handle:close()
  end

  if hash:sub(1,5) == "00000" then
    print("4a:", i)
    break
  end
end

i = 1038000
while(true) do
  i = i + 1
  if i % 10000 == 0 then
    print(i)
  end

  local handle = io.popen("echo -n '"..key..i.."' | md5sum --zero")
  if handle ~= nil then
    hash = handle:read("*a")
    handle:close()
  end

  if hash:sub(1,6) == "000000" then
    print("4b:", i)
    break
  end
end

