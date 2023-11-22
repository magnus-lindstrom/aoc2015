local u = require 'src/utils'

-- local input = u.lines_from('test_inputs/19b')
local input = u.lines_from('inputs/20')

local function a()
  local presents_to_reach = tonumber(input[1])

  local houses_and_presents = {}
  for i = 1, presents_to_reach/10 do
    houses_and_presents[i] = 0
  end

  for elf_nr = 1, presents_to_reach/10 do
    for j = elf_nr, presents_to_reach/10, elf_nr do
      houses_and_presents[j] = houses_and_presents[j] + 10*elf_nr
    end
  end

  for house_nr, presents in ipairs(houses_and_presents) do
    if presents >= presents_to_reach then
      return house_nr
    end
  end
end

local function b()
  local presents_to_reach = tonumber(input[1])

  local houses_and_presents = {}
  -- divided by ten because we will surely have enough presents by then (heuristic)
  for i = 1, presents_to_reach/10 do
    houses_and_presents[i] = 0
  end

  for elf_nr = 1, presents_to_reach/10 do
    local houses_visited = 0
    for j = elf_nr, presents_to_reach/10, elf_nr do
      houses_and_presents[j] = houses_and_presents[j] + 11*elf_nr
      houses_visited = houses_visited + 1
      if houses_visited == 50 then
        break
      end
    end
  end

  for house_nr, presents in ipairs(houses_and_presents) do
    if presents >= presents_to_reach then
      return house_nr
    end
  end
end

return {a = a, b = b}
