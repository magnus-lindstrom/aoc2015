local u = require 'src/utils'
local input = u.lines_from('inputs/13')

local permutations, permute

function permutations(N)
  local level, set, co = -1, {}, nil
  for i = 1, N do set[i] = 0 end
  co = coroutine.create(function () permute(set, level, N, 1) end)
  return function ()
    local _, p = coroutine.resume(co)
    return p
  end
end

function permute(set, level, N, k)
  level = level + 1
  set[k] = level
  if level == N then
    coroutine.yield(set)
  else
    for i = 1, N do
      if set[i] == 0 then
        permute(set, level, N, i)
      end
    end
  end

  level = level - 1
  set[k] = 0
end

local function get_happiness_sum(happiness_table, indexes, nr_to_name)
  local sum = 0
  local person, next_person
  for i = 1, u.table_length(happiness_table)-1 do
    person = nr_to_name[indexes[i]]
    next_person = nr_to_name[indexes[i+1]]
    sum = sum + happiness_table[person][next_person] + happiness_table[next_person][person]
  end
  -- same for person 1 and 8
  person = nr_to_name[indexes[1]]
  next_person = nr_to_name[indexes[u.table_length(indexes)]]
  sum = sum + happiness_table[person][next_person] + happiness_table[next_person][person]

  return sum
end

local function a()
  local happiness_table = {}
  for _, line in ipairs(input) do
    local words = u.split_string_by_substring(line, ' ')
    local person1 = words[1]
    local person2 = words[11]:sub(1, -2)
    local happiness = tonumber(words[4])
    if happiness_table[person1] == nil then
      happiness_table[person1] = {}
    end

    if words[3] == "gain" then
      happiness_table[person1][person2] = happiness
    else
      happiness_table[person1][person2] = -1 * happiness
    end
  end
  local nr_to_name = {}
  local i = 1
  for k, _ in pairs(happiness_table) do
    nr_to_name[i] = k
    i = i + 1
  end

  local max_happiness = 0
  for p in permutations(u.table_length(happiness_table)) do
    local happiness = get_happiness_sum(happiness_table, p, nr_to_name)
    if happiness > max_happiness then
      max_happiness = happiness
    end
  end

  return max_happiness
end

local function b()
  local happiness_table = {}
  happiness_table['me'] = {}

  for _, line in ipairs(input) do
    local words = u.split_string_by_substring(line, ' ')
    local person1 = words[1]
    local person2 = words[11]:sub(1, -2)
    local happiness = tonumber(words[4])
    if happiness_table[person1] == nil then
      happiness_table[person1] = {}
    end

    if words[3] == "gain" then
      happiness_table[person1][person2] = happiness
    else
      happiness_table[person1][person2] = -1 * happiness
    end
    happiness_table[person1]['me'] = 0
    happiness_table['me'][person1] = 0
  end
  local nr_to_name = {}
  local i = 1
  for k, _ in pairs(happiness_table) do
    nr_to_name[i] = k
    i = i + 1
  end

  local max_happiness = 0
  for p in permutations(u.table_length(happiness_table)) do
    local happiness = get_happiness_sum(happiness_table, p, nr_to_name)
    if happiness > max_happiness then
      max_happiness = happiness
    end
  end

  return max_happiness
end

return {a = a, b = b}
