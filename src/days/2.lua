local utils = require 'src/utils'

local lines = utils.lines_from("inputs/2")

local function a()
    local area = 0

    for _, line in pairs(lines) do
      local dims = utils.split_string_by_substring(line, 'x')
      local x = dims[1]
      local y = dims[2]
      local z = dims[3]

      local min_dim_1 = math.min(x,y)
      local min_dim_2 = math.min(y,z)
      if min_dim_1 == min_dim_2 then
        min_dim_2 = math.min(x,z)
      end

      local area_1 = x*y
      local area_2 = x*z
      local area_3 = y*z
      area = area + 2*area_1 + 2*area_2 + 2*area_3
      area = area + math.min(area_1, area_2, area_3)
    end
    return area
end

local function b()
    local ribbon_length = 0

    for _, line in pairs(lines) do
      local dims = utils.split_string_by_substring(line, 'x')
      local x = dims[1]
      local y = dims[2]
      local z = dims[3]

      local min_dim_1 = math.min(x,y)
      local min_dim_2 = math.min(y,z)
      if min_dim_1 == min_dim_2 then
        min_dim_2 = math.min(x,z)
      end
      local volume = x*y*z
      ribbon_length = ribbon_length + 2*min_dim_1 + 2*min_dim_2 + volume
    end
    return ribbon_length
end

return {a = a, b = b}
