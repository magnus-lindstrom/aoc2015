local u = require 'src/utils'

-- local input = u.lines_from('test_inputs/19b')
local input = u.lines_from('inputs/19')

local function get_substitutions_from_input()
  local substitutions = {}
  for _, line in ipairs(input) do
    if line == '' then
      break
    end
    local words = u.split_string_by_substring(line, ' => ')
    if substitutions[words[1]] == nil then
      substitutions[words[1]] = {}
    end
    table.insert(substitutions[words[1]], words[2])
  end
  return substitutions
end

local function get_bottom_molecule_from_input()
  local line_break_has_been_passed = false
  for _, line in ipairs(input) do
    if line_break_has_been_passed then
      return line
    elseif line == '' then
      line_break_has_been_passed = true
    end
  end
end

local function get_possible_molecules(molecule, subs)
  local possible_molecules = {}

  for lhs, rhss in pairs(subs) do
    local molecule_length = #lhs
    for i = 1, #molecule do
      if molecule:sub(i, i+molecule_length-1) == lhs then
        local prefix = molecule:sub(1, i-1)
        local suffix = molecule:sub(i+molecule_length, -1)
        for _, rhs in ipairs(rhss) do
          table.insert(possible_molecules, prefix..rhs..suffix)
        end
      end
    end
  end
  return possible_molecules
end

local function a()
  local subs = get_substitutions_from_input()
  local starting_molecule = get_bottom_molecule_from_input()
  local possible_molecules = {}

  for lhs, rhss in pairs(subs) do
    local molecule_length = #lhs
    for i = 1, #starting_molecule do
      if starting_molecule:sub(i, i+molecule_length-1) == lhs then
        local prefix = starting_molecule:sub(1, i-1)
        local suffix = starting_molecule:sub(i+molecule_length, -1)
        for _, rhs in ipairs(rhss) do
          local new_molecule = prefix..rhs..suffix
          possible_molecules[new_molecule] = true
        end
      end
    end
  end
  return u.table_length(possible_molecules)
end

local function b()
  local subs = get_substitutions_from_input()
  local end_molecule = get_bottom_molecule_from_input()
  local molecule_length_cutoff = (#end_molecule) + 20

  local found_states_and_steps_to_reach_them = {}
  found_states_and_steps_to_reach_them['e'] = 0
  local state_queue = {} -- keys are indices, values are tables with (first value: molecule, second value: nr of modifications needed)
  state_queue[1] = {}
  state_queue[1][1] = 'e'
  state_queue[1][2] = 0
  -- print('state queue at start:')
  -- u.print_table(state_queue)
  -- print()

  local i = 1
  while true do
    local state_to_evolve = table.remove(state_queue, 1)
    -- u.print_table(state_to_evolve)
    local current_molecule = state_to_evolve[1]
    if i % 1000 == 0 then
      print('i:', i, 'state_queue length:', u.table_length(state_queue))
      print('current molecule:', current_molecule)
    end
    local current_steps = state_to_evolve[2]
    -- print(current_molecule)
    local new_molecules = get_possible_molecules(current_molecule, subs)
    for _, new_molecule in pairs(new_molecules) do
      -- print(new_molecule)
      if new_molecule == end_molecule then
        return current_steps + 1
      end

      if found_states_and_steps_to_reach_them[new_molecule] == nil then
        if #new_molecule < molecule_length_cutoff then
          found_states_and_steps_to_reach_them[new_molecule] = current_steps + 1
          local state_to_insert = {}
          state_to_insert[1] = new_molecule
          state_to_insert[2] = current_steps + 1
          -- print('inserting below state')
          -- u.print_table(state_to_insert)
          table.insert(state_queue, state_to_insert) -- inserts at the end of the table
        end
      end
    end
    -- print('state queue:')
    -- u.print_table(state_queue)
    -- print()
    i = i + 1
  end
end

print(a())
-- print(b())
