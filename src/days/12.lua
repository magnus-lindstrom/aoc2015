local u = require 'src/utils'
local input = u.lines_from('inputs/12')[1]
local get_sum_of_obj, get_sum_of_list

function get_sum_of_obj(i_start)
  local sum = 0
  -- assume that the opening [ char is i_start
  local i = i_start + 1
  local contains_red = false
  while (i <= input:len()) do
    local char = input:sub(i,i)

    if char == '[' then
      local sum_add, i_new = get_sum_of_list(i)
      sum = sum + sum_add
      i = i_new
    elseif char == ']' then
      u.exit('should not find end of list in get_sum_of_obj. i='..i)
    elseif char == '{' then
      local sum_add, i_new = get_sum_of_obj(i)
      sum = sum + sum_add
      i = i_new
    elseif char == '}' then
      if contains_red then
        return 0, i
      else
        return sum, i
      end
    elseif char:match("[%d-]") ~= nil then -- found start of number
      local nr_start = i
      for j = i+1, input:len() do
        local j_char = input:sub(j,j)
        if j_char:match("[%d-]") == nil then -- no longer a number char
          sum = sum + tonumber(input:sub(nr_start, j-1))
          i = j - 1 -- the end of loop addition to i moves past the integer this way
          break
        end
      end
    elseif char == '"' then -- found start of string
      local str_start = i
      for j = i+1, input:len() do
        local j_char = input:sub(j,j)
        if j_char == '"' then -- no longer a number char
          if input:sub(str_start,j) == '"red"' then
            contains_red = true
          end
          i = j
          break
        end
      end
    end
    i = i + 1
  end

  if contains_red then
    return 0, input:len()
  else
    return sum, input:len()
  end
end

function get_sum_of_list(i_start)
  local sum = 0
  -- assume that the opening [ char is i_start
  local i = i_start + 1
  while (i <= input:len()) do
    local char = input:sub(i,i)

    if char == '[' then
      local sum_add, i_new = get_sum_of_list(i)
      sum = sum + sum_add
      i = i_new
    elseif char == ']' then
      return sum, i -- return the index of closing bracket
    elseif char:match("[%d-]") ~= nil then -- found start of number
      local nr_start = i
      for j = i+1, input:len() do
        local j_char = input:sub(j,j)
        if j_char:match("[%d-]") == nil then -- no longer a number char
          sum = sum + tonumber(input:sub(nr_start, j-1))
          i = j - 1
          break
        end
      end
    elseif char == '{' then
      local sum_add, i_new = get_sum_of_obj(i)
      sum = sum + sum_add
      i = i_new
    elseif char == '}' then
      u.exit('should not find end of obj in get_sum_of_list. i='..i)
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
  return sum
end

local function b()
  local sum
  if input:sub(1,1) == '[' then
    sum, _ = get_sum_of_list(1)
  elseif input:sub(1,1) == '{' then
    sum, _ = get_sum_of_obj(1)
  end

  return sum
end

return {a = a, b = b}
