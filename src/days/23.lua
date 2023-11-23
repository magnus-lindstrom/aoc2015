local u = require 'src/utils'


local input = u.lines_from('inputs/23')


local function get_instructions()

  local instructions = {}
  for i, line in ipairs(input) do

    local words = u.split_string_by_substring(line, ' ')
    instructions[i] = {words[1]}
    if tonumber(words[2]) ~= nil then
      instructions[i][2] = tonumber(words[2])
    else
      instructions[i][2] = string.sub(words[2], 1, 1) -- skip the trailing comma
    end
    instructions[i][3] = tonumber(words[3])
  end
  return instructions
end

local function program(a_reg_start_value)

  local instructions = get_instructions()
  local regs = {['a'] = a_reg_start_value, ['b'] = 0}
  local i_instr = 1
  while i_instr > 0 and i_instr <= u.table_length(instructions) do
    local offset = 1
    if instructions[i_instr][1] == 'hlf' then
      regs[instructions[i_instr][2]] = regs[instructions[i_instr][2]] / 2
    elseif instructions[i_instr][1] == 'tpl' then
      regs[instructions[i_instr][2]] = regs[instructions[i_instr][2]] * 3
    elseif instructions[i_instr][1] == 'inc' then
      regs[instructions[i_instr][2]] = regs[instructions[i_instr][2]] + 1
    elseif instructions[i_instr][1] == 'jmp' then
      offset = instructions[i_instr][2]
    elseif instructions[i_instr][1] == 'jie' then
      if regs[instructions[i_instr][2]] % 2 == 0 then
        offset = instructions[i_instr][3]
      end
    elseif instructions[i_instr][1] == 'jio' then
      if regs[instructions[i_instr][2]] == 1 then
        offset = instructions[i_instr][3]
      end
    end
    i_instr = i_instr + offset
  end
  return regs['b']
end

local function a()
  return program(0)
end

local function b()
  return program(1)
end

return {a = a, b = b}
