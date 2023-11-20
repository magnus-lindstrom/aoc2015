local function a()
  local utils = require 'src/utils'

  local lines = utils.lines_from("inputs/6")

  local lights = {}
  for i = 0, 999 do
    lights[i] = {}
    for j = 0, 999 do
      lights[i][j] = false
    end
  end

  local imin, imax, jmin, jmax
  local toggle, turnon, turnoff

  for _, line in pairs(lines) do
    --print(line)
    toggle, turnon, turnoff = false, false, false
    local words = utils.split_string_by_substring(line, ' ')
    if words[1] == "toggle" then
      toggle = true
      local matches = string.gmatch(words[2], "[^,]+")
      imin = matches()
      jmin = matches()
      matches = string.gmatch(words[4], "[^,]+")
      imax = matches()
      jmax = matches()
      --print(imin, imax, jmin, jmax)
    elseif words[1] == "turn" and words[2] == "on" then
      turnon = true
      local matches = string.gmatch(words[3], "[^,]+")
      imin = matches()
      jmin = matches()
      matches = string.gmatch(words[5], "[^,]+")
      imax = matches()
      jmax = matches()
    elseif words[1] == "turn" and words[2] == "off" then
      turnoff = true
      local matches = string.gmatch(words[3], "[^,]+")
      imin = matches()
      jmin = matches()
      matches = string.gmatch(words[5], "[^,]+")
      imax = matches()
      jmax = matches()
    else
      utils.exit("something wrong again")
    end

    for i = imin, imax do
      for j = jmin, jmax do
        if toggle then
          lights[i][j] = not lights[i][j]
        elseif turnon then
          lights[i][j] = true
        elseif turnoff then
          lights[i][j] = false
        else
          utils.exit("something wrong")
        end
      end
    end
  end

  local lights_on = 0
  for i in pairs(lights) do
    for j in pairs(lights) do
      if lights[i][j] then
        lights_on = lights_on + 1
      end
    end
  end
  return lights_on
end

local function b()
  local utils = require 'src/utils'

  local lines = utils.lines_from("inputs/6")

  local lights = {}
  for i = 0, 999 do
    lights[i] = {}
    for j = 0, 999 do
      lights[i][j] = 0
    end
  end

  local imin, imax, jmin, jmax
  local toggle, turnon, turnoff

  for _, line in pairs(lines) do
    --print(line)
    toggle, turnon, turnoff = false, false, false
    local words = utils.split_string_by_substring(line, ' ')
    if words[1] == "toggle" then
      toggle = true
      local matches = string.gmatch(words[2], "[^,]+")
      imin = matches()
      jmin = matches()
      matches = string.gmatch(words[4], "[^,]+")
      imax = matches()
      jmax = matches()
    elseif words[1] == "turn" and words[2] == "on" then
      turnon = true
      local matches = string.gmatch(words[3], "[^,]+")
      imin = matches()
      jmin = matches()
      matches = string.gmatch(words[5], "[^,]+")
      imax = matches()
      jmax = matches()
    elseif words[1] == "turn" and words[2] == "off" then
      turnoff = true
      local matches = string.gmatch(words[3], "[^,]+")
      imin = matches()
      jmin = matches()
      matches = string.gmatch(words[5], "[^,]+")
      imax = matches()
      jmax = matches()
    else
      utils.exit("something wrong again")
    end

    for i = imin, imax do
      for j = jmin, jmax do
        if toggle then
          lights[i][j] = lights[i][j] + 2
        elseif turnon then
          lights[i][j] = lights[i][j] + 1
        elseif turnoff then
          if lights[i][j] > 0 then
            lights[i][j] = lights[i][j] - 1
          end
        else
          utils.exit("something wrong")
        end
      end
    end
  end

  local total_brightness = 0
  for i in pairs(lights) do
    for j in pairs(lights) do
      if lights[i][j] then
        total_brightness = total_brightness + lights[i][j]
      end
    end
  end
  return total_brightness
end

return {a = a, b = b}
