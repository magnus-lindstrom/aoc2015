local u = require 'src/utils'
local input = u.lines_from('inputs/17')

local function get_buckets()
  local buckets = {}
  for _, line in ipairs(input) do
    table.insert(buckets, tonumber(line))
  end
  return buckets
end

local function get_nr_of_combinations_a(buckets, i_start, volume_left)

  local combinations = 0
    for i, vol in ipairs(buckets) do
      if i >= i_start then
        if vol <= volume_left then
          local x = volume_left - vol
          if x == 0 then
            combinations = combinations + 1
          else
            combinations = combinations + get_nr_of_combinations_a(buckets, i+1, x)
          end
        end
      end
    end

  return combinations
end

local function get_nr_of_combinations_b(buckets, buckets_in_use, min_buckets_used, combinations, i_start, volume_left)

    for i, vol in ipairs(buckets) do
      if i >= i_start then
        if vol <= volume_left then
          if buckets_in_use + 1 > min_buckets_used then
            break
          end

          local x = volume_left - vol
          if x == 0 then
            if buckets_in_use + 1 < min_buckets_used then
              min_buckets_used = buckets_in_use + 1
              combinations = 1
            else
              combinations = combinations + 1
            end
          else
            combinations, min_buckets_used = get_nr_of_combinations_b(buckets, buckets_in_use+1, min_buckets_used, combinations, i+1, x)
          end
        end
      end
    end

  return combinations, min_buckets_used
end

local function a()
  local buckets = get_buckets()
  local start_i = 1
  local total_volume = 150
  local combinations = get_nr_of_combinations_a(buckets, start_i, total_volume)
  return combinations
end

local function b()
  local buckets = get_buckets()
  local buckets_in_use = 0
  local start_i = 1
  local total_volume = 150
  local min_buckets_used = u.table_length(buckets) + 1
  local combinations_of_min_buckets_used = 0
  combinations_of_min_buckets_used, min_buckets_used = get_nr_of_combinations_b(
    buckets,
    buckets_in_use,
    min_buckets_used,
    combinations_of_min_buckets_used,
    start_i,
    total_volume
  )
  return combinations_of_min_buckets_used
end

return {a = a, b = b}
