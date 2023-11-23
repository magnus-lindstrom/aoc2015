local function a()
  local start_nr = 20151125
  local factor = 252533
  local divisor = 33554393

  local number = start_nr
  local col = 1
  local row = 1
  local col_target = 1
  -- local rows = {}
  while true do

    if row == 2947 and col == 3029 then
      return number
    end

    number = number * factor % divisor

    if col == col_target then
      col_target = col_target + 1
      row = col_target
      col = 1
    else
      row = row - 1
      col = col + 1
    end

  end
end

local function b()
  return "Merry Christmas!"
end

return {a = a, b = b}
