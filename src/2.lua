local utils = require 'src/utils'

local lines = utils.lines_from("inputs/2")

local area = 0
local ribbon_length = 0

for _, line in pairs(lines) do
  local dims = utils.split_string_by_substring(line, 'x')
  local a = dims[1]
  local b = dims[2]
  local c = dims[3]

  local min_dim_1 = math.min(a,b)
  local min_dim_2 = math.min(b,c)
  if min_dim_1 == min_dim_2 then
    min_dim_2 = math.min(a,c)
  end
  local volume = a*b*c
  ribbon_length = ribbon_length + 2*min_dim_1 + 2*min_dim_2 + volume


  local area_1 = a*b
  local area_2 = a*c
  local area_3 = b*c
  area = area + 2*area_1 + 2*area_2 + 2*area_3
  area = area + math.min(area_1, area_2, area_3)
end

print('2a:', area)
print('2b:', ribbon_length)
