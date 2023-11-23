local u = require 'src/utils'


local input = u.lines_from('inputs/24')
local package_weights = {}
local nr_packages = u.table_length(input)
for i = nr_packages, 1, -1 do
  table.insert(package_weights, nr_packages + 1 - i, tonumber(input[i]))
end
local third_of_total_weights = u.sum_over_table_elements(package_weights) / 3
local quarter_of_total_weights = u.sum_over_table_elements(package_weights) / 4
u.print_table(package_weights)
print(u.sum_over_table_elements(package_weights), third_of_total_weights)

--[[
local weights_left_to_distribute = {}
local weight_sum = 0
for i = nr_packages, 1, -1 do
  weight_sum = weight_sum + package_weights[i]
  weights_left_to_distribute[i] = weight_sum
end

local function state_can_lead_to_solution(state)
  local max_weight = math.max(state['grp1_weight'], state['grp2_weight'], state['grp3_weight'])
  -- one of these is zero
  local weight_diff_1 = max_weight - state['grp1_weight']
  local weight_diff_2 = max_weight - state['grp2_weight']
  local weight_diff_3 = max_weight - state['grp3_weight']
  -- print(weight_diff_1, weight_diff_2, weight_diff_3)
  local weight_diff_sum = weight_diff_1 + weight_diff_2 + weight_diff_3
  if weight_diff_sum < weights_left_to_distribute[state['package_nr_to_pack'] ] then
    -- print('true because weight_diff:', weight_diff_sum, 'and weights left:', weights_left_to_distribute[state['package_nr_to_pack'] ])
    return true
  end
    -- print('false because weight_diff:', weight_diff_sum, 'and weights left:', weights_left_to_distribute[state['package_nr_to_pack'] ])
  return false
end
--]]

local function a()
  local state_queue = {}
  table.insert(state_queue, {
    ['package_nr_to_pack'] = 1,
    ['grp1_qe'] = 1,
    ['grp1_count'] = 0,
    ['grp2_count'] = 0,
    ['grp3_count'] = 0,
    ['grp1_weight'] = 0,
    ['grp2_weight'] = 0,
    ['grp3_weight'] = 0,
  })
  local smallest_final_grp1_count =  10000000
  local smallest_final_grp1_qe =     1e+22

  local i = 1
  while u.table_length(state_queue) > 0 do
    if i % 1000000 == 0 then
      print(i, u.table_length(state_queue))
    end

    local current_state = table.remove(state_queue)
    --u.print_table(current_state)
    -- print(current_state['package_nr_to_pack'])

    -- assign to grp1
    local new_grp1_count = current_state['grp1_count'] + 1
    local new_grp1_weight = current_state['grp1_weight'] + package_weights[current_state['package_nr_to_pack']]
    local new_grp1_qe = current_state['grp1_qe'] * package_weights[current_state['package_nr_to_pack']]
    if (
      new_grp1_count < smallest_final_grp1_count
      or (new_grp1_count == smallest_final_grp1_count and new_grp1_qe < smallest_final_grp1_qe)
    ) and new_grp1_weight <= third_of_total_weights then

      local new_state = u.table_copy(current_state)
      new_state['grp1_count'] = new_grp1_count
      new_state['grp1_weight'] = new_grp1_weight
      new_state['grp1_qe'] = new_grp1_qe
      new_state['package_nr_to_pack'] = new_state['package_nr_to_pack'] + 1

      if new_state['package_nr_to_pack'] > nr_packages then
        -- are weights evenly distributed?
        if new_state['grp1_weight'] == new_state['grp2_weight']
          and new_state['grp1_weight'] == new_state['grp3_weight'] then

          -- is this the smallest grp1 count?
          if new_state['grp1_count'] < smallest_final_grp1_count then
            smallest_final_grp1_count = new_state['grp1_count']
            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          elseif new_state['grp1_count'] == smallest_final_grp1_count
            and new_state['grp1_qe'] < smallest_final_grp1_qe then

            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          end

        end
      else
        table.insert(state_queue, new_state)
      end
    end
    -- assign to grp2
    local new_grp2_count = current_state['grp2_count'] + 1
    local new_grp2_weight = current_state['grp2_weight'] + package_weights[current_state['package_nr_to_pack']]
    if current_state['grp1_count'] <= smallest_final_grp1_count
      and new_grp2_weight <= third_of_total_weights then

      local new_state = u.table_copy(current_state)
      new_state['grp2_count'] = new_grp2_count
      new_state['grp2_weight'] = new_grp2_weight
      new_state['package_nr_to_pack'] = new_state['package_nr_to_pack'] + 1

      if new_state['package_nr_to_pack'] > nr_packages then
        -- are weights evenly distributed?
        if new_state['grp1_weight'] == new_state['grp2_weight']
          and new_state['grp1_weight'] == new_state['grp3_weight'] then

          -- is this the smallest grp1 count?
          if new_state['grp1_count'] < smallest_final_grp1_count then
            smallest_final_grp1_count = new_state['grp1_count']
            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          elseif new_state['grp1_count'] == smallest_final_grp1_count
            and new_state['grp1_qe'] < smallest_final_grp1_qe then

            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          end

        end
      else
        table.insert(state_queue, new_state)
      end
    end
    -- assign to grp3
    local new_grp3_count = current_state['grp3_count'] + 1
    local new_grp3_weight = current_state['grp3_weight'] + package_weights[current_state['package_nr_to_pack']]
    if current_state['grp1_count'] <= smallest_final_grp1_count
      and new_grp3_weight <= third_of_total_weights then

      local new_state = u.table_copy(current_state)
      new_state['grp3_count'] = new_grp3_count
      new_state['grp3_weight'] = new_grp3_weight
      new_state['package_nr_to_pack'] = new_state['package_nr_to_pack'] + 1

      if new_state['package_nr_to_pack'] > nr_packages then
        -- are weights evenly distributed?
        if new_state['grp1_weight'] == new_state['grp2_weight']
          and new_state['grp1_weight'] == new_state['grp3_weight'] then

          -- is this the smallest grp1 count?
          if new_state['grp1_count'] < smallest_final_grp1_count then
            smallest_final_grp1_count = new_state['grp1_count']
            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          elseif new_state['grp1_count'] == smallest_final_grp1_count
            and new_state['grp1_qe'] < smallest_final_grp1_qe then

            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          end

        end
      else
        table.insert(state_queue, new_state)
      end
    end
    i = i + 1
  end
  return smallest_final_grp1_qe

end

local function b()
  local state_queue = {}
  table.insert(state_queue, {
    ['package_nr_to_pack'] = 1,
    ['grp1_qe'] = 1,
    ['grp1_count'] = 0,
    ['grp1_weight'] = 0,
    ['grp2_weight'] = 0,
    ['grp3_weight'] = 0,
    ['grp4_weight'] = 0,
  })
  local smallest_final_grp1_count =  10000000
  local smallest_final_grp1_qe =     1e+22

  local i = 1
  while u.table_length(state_queue) > 0 do
    if i % 1000000 == 0 then
      print(i, u.table_length(state_queue))
    end

    local current_state = table.remove(state_queue)
    --u.print_table(current_state)
    -- print(current_state['package_nr_to_pack'])

    -- assign to grp1
    local new_grp1_count = current_state['grp1_count'] + 1
    local new_grp1_weight = current_state['grp1_weight'] + package_weights[current_state['package_nr_to_pack']]
    local new_grp1_qe = current_state['grp1_qe'] * package_weights[current_state['package_nr_to_pack']]
    if (
      new_grp1_count < smallest_final_grp1_count
      or (new_grp1_count == smallest_final_grp1_count and new_grp1_qe < smallest_final_grp1_qe)
    ) and new_grp1_weight <= quarter_of_total_weights then

      local new_state = u.table_copy(current_state)
      new_state['grp1_count'] = new_grp1_count
      new_state['grp1_weight'] = new_grp1_weight
      new_state['grp1_qe'] = new_grp1_qe
      new_state['package_nr_to_pack'] = new_state['package_nr_to_pack'] + 1

      if new_state['package_nr_to_pack'] > nr_packages then
        -- are weights evenly distributed?
        if new_state['grp1_weight'] == new_state['grp2_weight']
          and new_state['grp1_weight'] == new_state['grp3_weight'] then

          -- is this the smallest grp1 count?
          if new_state['grp1_count'] < smallest_final_grp1_count then
            smallest_final_grp1_count = new_state['grp1_count']
            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          elseif new_state['grp1_count'] == smallest_final_grp1_count
            and new_state['grp1_qe'] < smallest_final_grp1_qe then

            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          end

        end
      else
        table.insert(state_queue, new_state)
      end
    end
    -- assign to grp2
    local new_grp2_weight = current_state['grp2_weight'] + package_weights[current_state['package_nr_to_pack']]
    if current_state['grp1_count'] <= smallest_final_grp1_count
      and new_grp2_weight <= quarter_of_total_weights then

      local new_state = u.table_copy(current_state)
      new_state['grp2_weight'] = new_grp2_weight
      new_state['package_nr_to_pack'] = new_state['package_nr_to_pack'] + 1

      if new_state['package_nr_to_pack'] > nr_packages then
        -- are weights evenly distributed?
        if new_state['grp1_weight'] == new_state['grp2_weight']
          and new_state['grp1_weight'] == new_state['grp3_weight'] then

          -- is this the smallest grp1 count?
          if new_state['grp1_count'] < smallest_final_grp1_count then
            smallest_final_grp1_count = new_state['grp1_count']
            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          elseif new_state['grp1_count'] == smallest_final_grp1_count
            and new_state['grp1_qe'] < smallest_final_grp1_qe then

            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          end

        end
      else
        table.insert(state_queue, new_state)
      end
    end
    -- assign to grp3
    local new_grp3_weight = current_state['grp3_weight'] + package_weights[current_state['package_nr_to_pack']]
    if current_state['grp1_count'] <= smallest_final_grp1_count
      and new_grp3_weight <= quarter_of_total_weights then

      local new_state = u.table_copy(current_state)
      new_state['grp3_weight'] = new_grp3_weight
      new_state['package_nr_to_pack'] = new_state['package_nr_to_pack'] + 1

      if new_state['package_nr_to_pack'] > nr_packages then
        -- are weights evenly distributed?
        if new_state['grp1_weight'] == new_state['grp2_weight']
          and new_state['grp1_weight'] == new_state['grp3_weight'] then

          -- is this the smallest grp1 count?
          if new_state['grp1_count'] < smallest_final_grp1_count then
            smallest_final_grp1_count = new_state['grp1_count']
            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          elseif new_state['grp1_count'] == smallest_final_grp1_count
            and new_state['grp1_qe'] < smallest_final_grp1_qe then

            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          end

        end
      else
        table.insert(state_queue, new_state)
      end
    end
    -- assign to grp4
    local new_grp4_weight = current_state['grp4_weight'] + package_weights[current_state['package_nr_to_pack']]
    if current_state['grp1_count'] <= smallest_final_grp1_count
      and new_grp4_weight <= quarter_of_total_weights then

      local new_state = u.table_copy(current_state)
      new_state['grp4_weight'] = new_grp4_weight
      new_state['package_nr_to_pack'] = new_state['package_nr_to_pack'] + 1

      if new_state['package_nr_to_pack'] > nr_packages then
        -- are weights evenly distributed?
        if new_state['grp1_weight'] == new_state['grp2_weight']
          and new_state['grp1_weight'] == new_state['grp4_weight'] then

          -- is this the smallest grp1 count?
          if new_state['grp1_count'] < smallest_final_grp1_count then
            smallest_final_grp1_count = new_state['grp1_count']
            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          elseif new_state['grp1_count'] == smallest_final_grp1_count
            and new_state['grp1_qe'] < smallest_final_grp1_qe then

            smallest_final_grp1_qe = new_state['grp1_qe']
            u.print_table(new_state)
            print()
          end

        end
      else
        table.insert(state_queue, new_state)
      end
    end
    i = i + 1
  end
  return smallest_final_grp1_qe

end

print(b())
