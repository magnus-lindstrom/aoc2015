local utils = require 'src/utils'

local lines = utils.lines_from("inputs/3")

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

do
  -- Part a

  local x = 0
  local y = 0
  local positions_to_nr_visits = {}

  function positions_to_nr_visits:if_nil_add_zero(a, b)
    if self[a] == nil then
      self[a] = {}
    end
    if self[a][b] == nil then
      self[a][b] = 1
    end
  end

  positions_to_nr_visits[x] = {}
  positions_to_nr_visits[x][y] = 1

  local instructions = lines[1]
  for i = 1, #instructions do
    x, y = update_x_y(x, y, instructions:sub(i,i))

    positions_to_nr_visits:if_nil_add_zero(x,y)
    positions_to_nr_visits[x][y] = positions_to_nr_visits[x][y] + 1
  end

  print('2a:', utils.matrix_fields(positions_to_nr_visits))
end

do
  -- Part b

  local santa_x = 0
  local santa_y = 0
  local robo_x = 0
  local robo_y = 0
  local positions_to_nr_visits = {}

  function positions_to_nr_visits:if_nil_add_zero(a, b)
    if self[a] == nil then
      self[a] = {}
    end
    if self[a][b] == nil then
      self[a][b] = 1
    end
  end

  positions_to_nr_visits[santa_x] = {}
  positions_to_nr_visits[santa_x][santa_y] = 1

  local instructions = lines[1]
  for i = 1, #instructions, 2 do
    santa_x, santa_y = update_x_y(santa_x, santa_y, instructions:sub(i,i))
    robo_x, robo_y = update_x_y(robo_x, robo_y, instructions:sub(i+1,i+1))

    positions_to_nr_visits:if_nil_add_zero(santa_x,santa_y)
    positions_to_nr_visits[santa_x][santa_y] = positions_to_nr_visits[santa_x][santa_y] + 1
    positions_to_nr_visits:if_nil_add_zero(robo_x,robo_y)
    positions_to_nr_visits[robo_x][robo_y] = positions_to_nr_visits[robo_x][robo_y] + 1
  end

  print('2b:', utils.matrix_fields(positions_to_nr_visits))
end
