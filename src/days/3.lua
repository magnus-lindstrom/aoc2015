local utils = require 'src/utils'

local lines = utils.lines_from("inputs/3")

local function if_nil_visits_make_zero(table, pos, nr_visits)
    if table[pos] == nil then
        table[pos] = {}
    end
    if table[pos][nr_visits] == nil then
        table[pos][nr_visits] = 1
    end
end

local function update_x_y(x, y, instruction)
  if instruction == '^' then
    y = y + 1
  elseif instruction == '>' then
    x = x + 1
  elseif instruction == 'v' then
    y = y - 1
  elseif instruction == '<' then
    x = x - 1
  else
    utils.exit("unrecognized instruction: "..instruction)
  end
  return x, y
end

local function a()
    local x = 0
    local y = 0
    local positions_to_nr_visits = {}

    positions_to_nr_visits[x] = {}
    positions_to_nr_visits[x][y] = 1

    local instructions = lines[1]
    for i = 1, #instructions do
      x, y = update_x_y(x, y, instructions:sub(i,i))

      if_nil_visits_make_zero(positions_to_nr_visits, x, y)
      positions_to_nr_visits[x][y] = positions_to_nr_visits[x][y] + 1
    end
    return utils.matrix_fields(positions_to_nr_visits)

end

local function b()
    local santa_x = 0
    local santa_y = 0
    local robo_x = 0
    local robo_y = 0
    local positions_to_nr_visits = {}

    positions_to_nr_visits[santa_x] = {}
    positions_to_nr_visits[santa_x][santa_y] = 1

    local instructions = lines[1]
    for i = 1, #instructions, 2 do
      santa_x, santa_y = update_x_y(santa_x, santa_y, instructions:sub(i,i))
      robo_x, robo_y = update_x_y(robo_x, robo_y, instructions:sub(i+1,i+1))

      if_nil_visits_make_zero(positions_to_nr_visits, santa_x,santa_y)
      positions_to_nr_visits[santa_x][santa_y] = positions_to_nr_visits[santa_x][santa_y] + 1
      if_nil_visits_make_zero(positions_to_nr_visits, robo_x,robo_y)
      positions_to_nr_visits[robo_x][robo_y] = positions_to_nr_visits[robo_x][robo_y] + 1
    end

    return utils.matrix_fields(positions_to_nr_visits)
end

return {a = a, b = b}
