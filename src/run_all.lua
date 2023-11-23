local days = require 'src/days/init'

local answers = {
    day1a = 232,          day1b = 1783,
    day2a = 1606483,      day2b = 3842356,
    day3a = 2592,         day3b = 2360,
    day4a = 254575,       day4b = 1038736,
    day5a = 238,          day5b = 69,
    day6a = 569999,       day6b = 17836115,
    day7a = 3176,         day7b = 14710,
    day8a = 1333,         day8b = 2046,
    day9a = 207,          day9b = 804,
    day10a = 492982,      day10b = 6989950,
    day11a = 'vzbxxyzz',  day11b = 'vzcaabcc',
    day12a = 156366,      day12b = 96852,
    day13a = 733,         day13b = 725,
    day14a = 2640,        day14b = 1102,
    day15a = 18965440,    day15b = 15862900,
    day16a = 213,         day16b = 323,
    day17a = 1638,        day17b = 17,
    day18a = 1061,        day18b = 1006,
    day19a = 576,         day19b = 207,
    day20a = 776160,      day20b = 786240,
    day21a = 121,         day21b = 201,
    day22a = 1824,        day22b = 1937,
    day23a = 170,         day23b = 247,
    day24a = 10723906903, day24b = 74850409,
    day25a = 19980801,    day25b = "Merry Christmas!",
}

for number = 1, 25 do

  if days[number] == nil then
    break
  end

  for _, part in ipairs({'a', 'b'}) do

    local question_with_day = string.format('day%d%s', number, part)
    local question = string.format('%d%s', number, part)
    local correct_answer = answers[question_with_day]
    local result = days[number][part]()
    local pass_or_fail_string = ''
    if result ~= correct_answer then
        pass_or_fail_string = 'FALSE'
    end
    print(string.format('%s:\t%s\t%s', question, result, pass_or_fail_string))
  end
end
