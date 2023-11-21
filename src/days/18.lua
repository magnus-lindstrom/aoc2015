local u = require 'src/utils'


local input = u.lines_from('inputs/18')
local side_length = #(input[1])

local off_char = '.'
local on_char = '#'

local function get_active_neighbour_counts()
  local active_neighbour_counts = {}
  for i = 1, side_length do
    active_neighbour_counts[i] = {}
    for j = 1, side_length do
      active_neighbour_counts[i][j] = 0
    end
  end
  return active_neighbour_counts
end

local function is_interior_light(i, j)
  if (i > 1 and i < side_length ) then
    if (j > 1 and j < side_length) then
      return true
    end
  end
  return false
end

local function add_active_neighbour_counts(active_neighbour_counts, i_row, j_col)
  -- check if a middle character first, those are done faster
  if is_interior_light(i_row, j_col) then
    for i = i_row - 1, i_row + 1 do
      for j = j_col - 1, j_col + 1 do
        if i ~= i_row or j ~= j_col then -- do not update light itself
          active_neighbour_counts[i][j] = active_neighbour_counts[i][j] + 1
        end
      end
    end
  else -- is on the border, and some neighbours do not exist
    for i = i_row - 1, i_row + 1 do
      for j = j_col - 1, j_col + 1 do
        if (i >= 1 and i <= side_length) and (j >= 1 and j <= side_length) then
          if i ~= i_row or j ~= j_col then -- do not update light itself
            active_neighbour_counts[i][j] = active_neighbour_counts[i][j] + 1
          end
        end
      end
    end
  end
end

local function update_lights(lights, active_neighbour_counts)
  for i_row = 1, side_length do
    for j_col = 1, side_length do
      if lights[i_row][j_col] then -- if light is on
        if active_neighbour_counts[i_row][j_col] < 2 or active_neighbour_counts[i_row][j_col] > 3 then
          lights[i_row][j_col] = false
        end
      else -- if light is off
        if active_neighbour_counts[i_row][j_col] == 3 then
          lights[i_row][j_col] = true
        end
      end
    end
  end
end

local function update_lights_with_corners_always_active(lights, active_neighbour_counts)
  for i_row = 1, side_length do
    for j_col = 1, side_length do
      if ((i_row == 1 and j_col == 1)
        or (i_row == 1 and j_col == side_length)
        or (i_row == side_length and j_col == 1)
        or (i_row == side_length and j_col == side_length)
      ) then -- if corner, should always be on
        lights[i_row][j_col] = true
      elseif lights[i_row][j_col] then -- if light is on
        if active_neighbour_counts[i_row][j_col] < 2 or active_neighbour_counts[i_row][j_col] > 3 then
          lights[i_row][j_col] = false
        end
      else -- if light is off
        if active_neighbour_counts[i_row][j_col] == 3 then
          lights[i_row][j_col] = true
        end
      end
    end
  end
end

local function get_true_false_table_from_input()
  local true_false_table = {}
  for i_row = 1, side_length do
    true_false_table[i_row] = {}
    for j_col = 1, side_length do
      if input[i_row]:sub(j_col, j_col) == on_char then
        true_false_table[i_row][j_col] = true
      else
        true_false_table[i_row][j_col] = false
      end
    end
  end
  return true_false_table
end

local function get_string_table_from_true_false_table(true_false_table)
  local string_table = {}
  for i_row = 1, side_length do
    string_table[i_row] = ""
    for j_col = 1, side_length do
      if true_false_table[i_row][j_col] then
        string_table[i_row] = string_table[i_row] .. on_char
      else
        string_table[i_row] = string_table[i_row] .. off_char
      end
    end
  end
  return string_table
end

local function get_nr_of_active_lights(true_false_table)
  local nr_active_lights = 0
  for i_row = 1, side_length do
    for j_col = 1, side_length do
      if true_false_table[i_row][j_col] then
        nr_active_lights = nr_active_lights + 1
      end
    end
  end
  return nr_active_lights
end

local function a()
  local nr_steps = 100
  local lights_table = get_true_false_table_from_input()

  -- u.print_table(input)
  -- print()
  for _ = 1, nr_steps do
    local active_neighbour_counts = get_active_neighbour_counts()
    for i_row = 1, side_length do
      for j_col = 1, side_length do
        if lights_table[i_row][j_col] then
          add_active_neighbour_counts(active_neighbour_counts, i_row, j_col)
        end
      end
    end
    update_lights(lights_table, active_neighbour_counts)
    -- u.print_table(get_string_table_from_true_false_table(lights_table))
    -- print()
  end
  return get_nr_of_active_lights(lights_table)
end

local function b()
  local nr_steps = 100
  local lights_table = get_true_false_table_from_input()
  lights_table[1][1] = true
  lights_table[1][side_length] = true
  lights_table[side_length][1] = true
  lights_table[side_length][side_length] = true

  -- u.print_table(get_string_table_from_true_false_table(lights_table))
  -- print()
  for _ = 1, nr_steps do
    local active_neighbour_counts = get_active_neighbour_counts()
    for i_row = 1, side_length do
      for j_col = 1, side_length do
        if lights_table[i_row][j_col] then
          add_active_neighbour_counts(active_neighbour_counts, i_row, j_col)
        end
      end
    end
    update_lights_with_corners_always_active(lights_table, active_neighbour_counts)
    -- u.print_table(get_string_table_from_true_false_table(lights_table))
    -- print()
  end
  return get_nr_of_active_lights(lights_table)
end

return {a = a, b = b}
