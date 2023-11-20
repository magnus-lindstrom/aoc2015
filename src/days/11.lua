local u = require 'src/utils'

local input = u.lines_from('inputs/11')[1]

local function password_str(password)
  local output = ""
  for _, char in ipairs(password) do
    output = output..char
  end
  return output
end

local function increment_password(password)
  local i = #password
  while i > 0 do
    if password[i] == 'z' then
      password[i] = 'a'
      i = i - 1
    elseif password[i] == 'h' then
      password[i] = 'j'
      break
    elseif password[i] == 'n' then
      password[i] = 'p'
      break
    elseif password[i] == 'k' then
      password[i] = 'm'
      break
    else
      password[i] = string.char(password[i]:byte() + 1)
      break
    end
  end
  return password
end

local function password_is_valid(password)
  local last_char = 'B'
  local has_streak_of_three = false
  local pair_one = nil
  local pair_two = nil
  local streak
  for i = 1, #password do
    if password[i]:byte() == last_char:byte() + 1 then
      streak = streak + 1
      if streak >= 3 then
        has_streak_of_three = true
      end
    else
      streak = 1
    end

    if password[i] == last_char then
      if pair_one == nil then
        pair_one = password[i]
      elseif pair_two == nil then
        if pair_one ~= password[i] then
          pair_two = password[i]
        end
      end
    end


    last_char = password[i]
  end

  if has_streak_of_three and pair_one ~= nil and pair_two ~= nil then
    return true
  else
    return false
  end
end

local function a()
  local password = {}
  for i = 1, input:len() do
    password[i] = input:sub(i, i)
  end

  local nr_passwords_found = 0
  while(true) do
    password = increment_password(password)
    if password_is_valid(password) then
      nr_passwords_found = nr_passwords_found + 1
      if nr_passwords_found == 1 then
        return password_str(password)
      end
    end
  end
end

local function b()
  local password = {}
  for i = 1, input:len() do
    password[i] = input:sub(i, i)
  end

  local nr_passwords_found = 0
  while(true) do
    password = increment_password(password)
    if password_is_valid(password) then
      nr_passwords_found = nr_passwords_found + 1
      if nr_passwords_found == 2 then
        return password_str(password)
      end
    end
  end
end

return {a = a, b = b}
