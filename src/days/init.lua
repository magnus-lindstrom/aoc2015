local utils = require 'src/utils'
local days = {}

for i = 1, 25 do
  if utils.module_is_available(string.format('src/days/%d', i)) then
    local src = string.format('src/days/%d', i)
    days[i] = require(src)
  end
end

return days
