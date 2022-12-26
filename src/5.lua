local utils = require 'src/utils'

local lines = utils.lines_from("inputs/5")

do
  local vowels = {a=true, e=true, i=true, o=true, u=true}
  local naughty_strings = {ab=true, cd=true, pq=true, xy=true}

  local function string_is_nice(str)
    local nr_vowels = 0
    local letter_appears_twice = false
    for i = 1, string.len(str) do
      local this_char = str:sub(i,i)
      local next_char = str:sub(i+1,i+1)

      if vowels[this_char] ~= nil then
        nr_vowels = nr_vowels + 1
      end

      if this_char == next_char then
        letter_appears_twice = true
      end

      if naughty_strings[this_char..next_char] ~= nil then
        return false
      end

    end
    if nr_vowels < 3 or letter_appears_twice == false then
      return false
    end
    return true
  end

  local nice_strings = 0

  for _, line in ipairs(lines) do
    if string_is_nice(line) then
      nice_strings = nice_strings + 1
    end
  end
  print("5a:", nice_strings)
end

do
  local function string_is_nice(str)
    local double_letters = {}
    local letter_repeating = false
    local double_letters_appeared_twice = false

    local one, two, three
    local one_bigram_back = "00"
    local two_bigrams_back = "11"
    for i = 1, string.len(str)-1 do
      one = str:sub(i,i)
      two = str:sub(i+1,i+1)
      three = str:sub(i+2,i+2)

      if one..two ~= one_bigram_back then
        if double_letters[one..two] == nil then
          double_letters[one..two] = 1
        else
          double_letters[one..two] = double_letters[one..two] + 1
        end
      else -- if it is the same bigram in three spots in a row, it should be updated
        if one_bigram_back == two_bigrams_back then
          if double_letters[one..two] == nil then
            double_letters[one..two] = 1
          else
            double_letters[one..two] = double_letters[one..two] + 1
          end
        end
      end

      if three ~= nil and one == three then
        letter_repeating = true
      end

      two_bigrams_back = one_bigram_back
      one_bigram_back = one..two
    end

    for _, v in pairs(double_letters) do
      if v >= 2 then
        double_letters_appeared_twice = true
      end
    end

    if letter_repeating and double_letters_appeared_twice then
      return true
    else
      return false
    end
  end

  local nice_strings = 0

  for _, line in ipairs(lines) do
    if string_is_nice(line) then
      nice_strings = nice_strings + 1
    end
  end
  print("5b:", nice_strings)
end
