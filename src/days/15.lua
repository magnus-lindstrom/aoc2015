local u = require 'src/utils'
local input = u.lines_from('inputs/15')

local function get_ingredient_qualities()
  local quals = {}
  for _, line in ipairs(input) do
    local words = u.split_string_by_substring(line, ' ')
    local ingredient = string.sub(words[1], 1, -2) -- remove training ':'
    local capacity = tonumber(string.sub(words[3], 1, -2)) -- remove trailing ','
    local durability = tonumber(string.sub(words[5], 1, -2)) -- remove trailing ','
    local flavor = tonumber(string.sub(words[7], 1, -2)) -- remove trailing ','
    local texture = tonumber(string.sub(words[9], 1, -2)) -- remove trailing ','
    local calories = tonumber(words[11])
    quals[ingredient] = {}
    quals[ingredient]['capacity'] = capacity
    quals[ingredient]['durability'] = durability
    quals[ingredient]['flavor'] = flavor
    quals[ingredient]['texture'] = texture
    quals[ingredient]['calories'] = calories
  end
  return quals
end

local function get_score(qualities, nr_frosting, nr_candy, nr_butterscotch, nr_sugar, restrict_calories)
  local durability = qualities['Frosting']['durability'] * nr_frosting +
    qualities['Candy']['durability'] * nr_candy +
    qualities['Butterscotch']['durability'] * nr_butterscotch +
    qualities['Sugar']['durability'] * nr_sugar
  if durability <= 0 then
    return 0
  end
  local capacity = qualities['Frosting']['capacity'] * nr_frosting +
    qualities['Candy']['capacity'] * nr_candy +
    qualities['Butterscotch']['capacity'] * nr_butterscotch +
    qualities['Sugar']['capacity'] * nr_sugar
  if capacity <= 0 then
    return 0
  end
  local texture = qualities['Frosting']['texture'] * nr_frosting +
    qualities['Candy']['texture'] * nr_candy +
    qualities['Butterscotch']['texture'] * nr_butterscotch +
    qualities['Sugar']['texture'] * nr_sugar
  if texture <= 0 then
    return 0
  end
  local flavor = qualities['Frosting']['flavor'] * nr_frosting +
    qualities['Candy']['flavor'] * nr_candy +
    qualities['Butterscotch']['flavor'] * nr_butterscotch +
    qualities['Sugar']['flavor'] * nr_sugar
  if flavor <= 0 then
    return 0
  end

  if restrict_calories == true then
    local calories = qualities['Frosting']['calories'] * nr_frosting +
      qualities['Candy']['calories'] * nr_candy +
      qualities['Butterscotch']['calories'] * nr_butterscotch +
      qualities['Sugar']['calories'] * nr_sugar
    if calories ~= 500 then
      return 0
    end
  end

  return durability * capacity * texture * flavor
end

local function a()
  local qualities = get_ingredient_qualities()

  local max_score = -math.huge

  for nr_frosting = 0, 100 do
    for nr_candy = 0, 100 - nr_frosting do
      for nr_butterscotch = 0, 100 - nr_frosting - nr_candy do
        local nr_sugar = 100 - nr_frosting - nr_candy - nr_butterscotch
        local score = get_score(qualities, nr_frosting, nr_candy, nr_butterscotch, nr_sugar, false)
        if score > max_score then
          max_score = score
        end
      end
    end
  end

  return max_score
end

local function b()
  local qualities = get_ingredient_qualities()

  local max_score = -math.huge

  for nr_frosting = 0, 100 do
    for nr_candy = 0, 100 - nr_frosting do
      for nr_butterscotch = 0, 100 - nr_frosting - nr_candy do
        local nr_sugar = 100 - nr_frosting - nr_candy - nr_butterscotch
        local score = get_score(qualities, nr_frosting, nr_candy, nr_butterscotch, nr_sugar, true)
        if score > max_score then
          max_score = score
        end
      end
    end
  end

  return max_score
end

return {a = a, b = b}
