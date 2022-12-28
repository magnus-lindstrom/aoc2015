local utils = require 'src/utils'

local lines = utils.lines_from('inputs/8')

local function a()
  local printed_chars = 0
  local in_memory_chars = 0

  for _, line in pairs(lines) do
    local j = 1
    while j <= #line do
      local to_advance = 1
      local c1 = line:sub(j,j)
      local c2 = line:sub(j+1,j+1)
      if c1 == '\\' and c2 == '"' then
        to_advance = 2
      elseif c1 == '\\' and c2 == 'x' then
        to_advance = 4
      elseif c1 == '\\' and c2 == '\\' then
        to_advance = 2
      end
      in_memory_chars = in_memory_chars + 1
      printed_chars = printed_chars + to_advance
      j = j + to_advance
    end
    in_memory_chars = in_memory_chars - 2
  end
  print('8a:', printed_chars - in_memory_chars)
end

local function b()
  local initial_chars = 0
  local after_chars = 0

  for _, line in pairs(lines) do
    for j = 1, #line do
      local c = line:sub(j,j)
      if c == '\\' or c == '"' then
        after_chars = after_chars + 1
      end
      after_chars = after_chars + 1
      initial_chars = initial_chars + 1
    end
    after_chars = after_chars + 2
  end
  print('8b:', after_chars - initial_chars)
end

a()
b()
