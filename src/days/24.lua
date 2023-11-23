local u = require 'src/utils'


local input = u.lines_from('inputs/24')
local package_weights = {}
local nr_packages = u.table_length(input)
for i = nr_packages, 1, -1 do
  table.insert(package_weights, nr_packages + 1 - i, tonumber(input[i]))
end
local third_of_total_weights = u.sum_over_table_elements(package_weights) / 3
local quarter_of_total_weights = u.sum_over_table_elements(package_weights) / 4

local function smallest_qe(weight_total_of_packets)
  local all_qe_values = {}

  -- 1 package
  for i1 = 1, nr_packages/3 do
    local sum_of_weights = package_weights[i1]
    if sum_of_weights == weight_total_of_packets then
      table.insert(all_qe_values, package_weights[i1])
    end
  end
  if not all_qe_values[1] == nil then
    return u.smallest_table_element(all_qe_values)
  end
  -- 2 packages
  for i1 = 1, nr_packages do
    for i2 = i1+1, nr_packages do
      local sum_of_weights = package_weights[i1] + package_weights[i2]
      if sum_of_weights == weight_total_of_packets then
        table.insert(all_qe_values, package_weights[i1] * package_weights[i2])
      end
    end
  end
  if not all_qe_values[1] == nil then
    return u.smallest_table_element(all_qe_values)
  end
  -- 3 packages
  for i1 = 1, nr_packages do
    for i2 = i1+1, nr_packages do
      for i3 = i2+1, nr_packages do
        local sum_of_weights = package_weights[i1] + package_weights[i2] + package_weights[i3]
        if sum_of_weights == weight_total_of_packets then
          table.insert(all_qe_values, package_weights[i1] * package_weights[i2] * package_weights[i3])
        end
      end
    end
  end
  if not all_qe_values[1] == nil then
    return u.smallest_table_element(all_qe_values)
  end
  -- 4 packages
  for i1 = 1, nr_packages do
    for i2 = i1+1, nr_packages do
      for i3 = i2+1, nr_packages do
        for i4 = i3+1, nr_packages do
          local sum_of_weights = package_weights[i1] + package_weights[i2] + package_weights[i3] + package_weights[i4]
          if sum_of_weights == weight_total_of_packets then
            table.insert(all_qe_values,
            package_weights[i1] * package_weights[i2] * package_weights[i3]
            * package_weights[i4]
            )
          end
        end
      end
    end
  end
  if not all_qe_values[1] == nil then
    return u.smallest_table_element(all_qe_values)
  end
  -- 5 packages
  for i1 = 1, nr_packages do
    for i2 = i1+1, nr_packages do
      for i3 = i2+1, nr_packages do
        for i4 = i3+1, nr_packages do
          for i5 = i4+1, nr_packages do
            local sum_of_weights = package_weights[i1] + package_weights[i2] + package_weights[i3] + package_weights[i4] + package_weights[i5]
            if sum_of_weights == weight_total_of_packets then
              table.insert(all_qe_values,
              package_weights[i1] * package_weights[i2] * package_weights[i3]
              * package_weights[i4] * package_weights[i5]
            )
            end
          end
        end
      end
    end
  end
  if not all_qe_values[1] == nil then
    return u.smallest_table_element(all_qe_values)
  end
  -- 6 packages
  for i1 = 1, nr_packages do
    for i2 = i1+1, nr_packages do
      for i3 = i2+1, nr_packages do
        for i4 = i3+1, nr_packages do
          for i5 = i4+1, nr_packages do
            for i6 = i5+1, nr_packages do
              local sum_of_weights = package_weights[i1] + package_weights[i2] + package_weights[i3] + package_weights[i4] + package_weights[i5] + package_weights[i6]
              if sum_of_weights == weight_total_of_packets then
                table.insert(all_qe_values,
                package_weights[i1] * package_weights[i2] * package_weights[i3]
                * package_weights[i4] * package_weights[i5] * package_weights[i6]
              )
              end
            end
          end
        end
      end
    end
  end
  if not (all_qe_values[1] == nil) then
    return u.smallest_table_element(all_qe_values)
  end
end

local function a()
  return smallest_qe(third_of_total_weights)
end

local function b()
  return smallest_qe(quarter_of_total_weights)
end

return {a = a, b = b}
