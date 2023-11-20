local utils = require 'src/utils'

local lines = utils.lines_from('inputs/7')

local function nr_to_16_bit_table_repr(nr)
  local output = {}
  for i = 15, 0, -1 do
    if nr >= 2^i then
      nr = nr - 2^i
      output[i] = true
    else
      output[i] = false
    end
  end
  return output
end

local function bit_table_to_nr(bit_table)
  local sum = 0
  for i, v in pairs(bit_table) do
    if v then
      sum = sum + 2^i
    end
  end
  return sum
end

local function AND(table1, table2)
  local out = {}
  for i = 0, 15 do
    out[i] = table1[i] and table2[i]
  end
  return out
end

local function OR(table1, table2)
  local out = {}
  for i = 0, 15 do
    out[i] = table1[i] or table2[i]
  end
  return out
end

local function NOT(table)
  local out = {}
  for i = 0, 15 do
    out[i] = not table[i]
  end
  return out
end

local function LSHIFT(table, shift)
  local out = {}
  for i = 0, 15 do
    out[i] = table[i-shift]
  end
  return out
end

local function RSHIFT(table, shift)
  local out = {}
  for i = 0, 15 do
    out[i] = table[i+shift]
  end
  return out
end

local function a()
  local vals = {}
  local keep_running = true
  local line_done
  local done_lines = {}
  while(keep_running) do
    keep_running = false
    local i = 1
    while i <= #lines do
      if done_lines[i] == nil then
        line_done = true
        local words = utils.split_string_by_substring(lines[i], ' ')

        if words[2] == "->" and tonumber(words[1]) ~= nil then
          vals[words[3]] = nr_to_16_bit_table_repr(tonumber(words[1]))
        elseif words[2] == "->" and vals[words[1]] ~= nil then
          vals[words[3]] = vals[words[1]]
        elseif words[2] == "AND" and vals[words[1]] ~= nil and vals[words[3]] ~= nil then
          vals[words[5]] = AND(vals[words[1]], vals[words[3]])
        elseif words[2] == "AND" and tonumber(words[1]) ~= nil and vals[words[3]] ~= nil then
          vals[words[5]] = AND(nr_to_16_bit_table_repr(tonumber(words[1])), vals[words[3]])
        elseif words[2] == "OR" and vals[words[1]] ~= nil and vals[words[3]] ~= nil then
          vals[words[5]] = OR(vals[words[1]], vals[words[3]])
        elseif words[1] == "NOT" and vals[words[2]] ~= nil then
          vals[words[4]] = NOT(vals[words[2]])
        elseif words[2] == "LSHIFT" and vals[words[1]] ~= nil then
          vals[words[5]] = LSHIFT(vals[words[1]], tonumber(words[3]))
        elseif words[2] == "RSHIFT" and vals[words[1]] ~= nil then
          vals[words[5]] = RSHIFT(vals[words[1]], tonumber(words[3]))
        else
          line_done = false
          keep_running = true
        end

        if line_done then
          done_lines[i] = true
        end

      end
      i = i + 1
    end
  end

  for key, value in pairs(vals) do
    if key == 'a' then
      return bit_table_to_nr(value)
    end
  end
end

local function b()
  local nr = a()
  local vals = {}
  local keep_running = true
  local line_done
  local done_lines = {}
  while(keep_running) do
    keep_running = false
    local i = 1
    while i <= #lines do
      if done_lines[i] == nil then
        line_done = true
        local words = utils.split_string_by_substring(lines[i], ' ')

        if words[2] == "->" and words[3] == 'b' then
          vals[words[3]] = nr_to_16_bit_table_repr(nr)
        elseif words[2] == "->" and tonumber(words[1]) ~= nil then
          vals[words[3]] = nr_to_16_bit_table_repr(tonumber(words[1]))
        elseif words[2] == "->" and vals[words[1]] ~= nil then
          vals[words[3]] = vals[words[1]]
        elseif words[2] == "AND" and vals[words[1]] ~= nil and vals[words[3]] ~= nil then
          vals[words[5]] = AND(vals[words[1]], vals[words[3]])
        elseif words[2] == "AND" and tonumber(words[1]) ~= nil and vals[words[3]] ~= nil then
          vals[words[5]] = AND(nr_to_16_bit_table_repr(tonumber(words[1])), vals[words[3]])
        elseif words[2] == "OR" and vals[words[1]] ~= nil and vals[words[3]] ~= nil then
          vals[words[5]] = OR(vals[words[1]], vals[words[3]])
        elseif words[1] == "NOT" and vals[words[2]] ~= nil then
          vals[words[4]] = NOT(vals[words[2]])
        elseif words[2] == "LSHIFT" and vals[words[1]] ~= nil then
          vals[words[5]] = LSHIFT(vals[words[1]], tonumber(words[3]))
        elseif words[2] == "RSHIFT" and vals[words[1]] ~= nil then
          vals[words[5]] = RSHIFT(vals[words[1]], tonumber(words[3]))
        else
          line_done = false
          keep_running = true
        end

        if line_done then
          done_lines[i] = true
        end

      end
      i = i + 1
    end
  end

  for key, value in pairs(vals) do
    if key == 'a' then
      return bit_table_to_nr(value)
    end
  end
end

return {a = a, b = b}
