local utils = require 'src/utils'

local instructions = utils.lines_from("inputs/1")[1]

local floor = 0
local start_of_basement

for i = 1, #instructions do
  if instructions:sub(i,i) == '(' then
    floor = floor + 1
  elseif instructions:sub(i,i) == ')' then
    floor = floor - 1
  else
    utils.exit("unrecognized char: "..instructions:sub(i,i))
  end

  if floor == -1 and start_of_basement == nil then
    start_of_basement = i
  end
end

print('1a: final floor: '..floor)
print('1b: start of basement:', start_of_basement)
