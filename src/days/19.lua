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

local function get_element_count(molecule)
  local count = 0
  for i = 1, #molecule do
    local char = string.sub(molecule, i, i)
    if char == string.upper(char) then
      count = count + 1
    end
  end
  return count
end

local function get_swap_subtractions(molecule)
  local subtractions = 0
  for i = 1, #molecule do
    local one_char = string.sub(molecule, i, i)
    local two_chars = string.sub(molecule, i, i+1)
    if one_char == 'Y' or two_chars == 'Rn' then
      subtractions = subtractions + 2
    end
  end
  return subtractions
end

local function b()
  --[[
  all transmutations follow the same patterns:
  1: X -> XX
  2: X -> X Rn X Ar
  3: X -> X Rn X Y X Ar
  4: X -> X Rn X Y X Y X Ar
  where X is any element excluding Rn, Y and Ar (X -> XX does not necessarily mean that all X'es are
  the same element)

  The goal is to reduce the molecule to one element (or, an electron). If we converted the whole
  molecule according to rule 1, it would take (nr_elements - 1) swaps. Each time we use rule 2, we
  "save" 2 extra swaps, since 2 elements are removed for free. For each 'Y' introduced, we can see
  that we save an extra 2 swaps.

  So, therefore, the total number of swaps to reduce to an electron should be
  nr_elements - 1 - 2*nr_Rn - 2*nr_Y
  --]]
  local molecule = get_bottom_molecule_from_input()
  local element_count = get_element_count(molecule)
  local swap_count = element_count - 1
  swap_count = swap_count - get_swap_subtractions(molecule)
  return swap_count
end

return {a = a, b = b}
