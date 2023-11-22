local u = require 'src/utils'


local base_player_stats = {
  ['Hit Points'] = 100,
  ['Damage'] = 0,
  ['Armor'] = 0,
}

local function get_player_stats(weapon, armor, ring1, ring2)
  local player_stats = u.table_copy(base_player_stats)
  player_stats['Damage'] = player_stats['Damage'] + weapon['Damage'] + ring1['Damage'] + ring2['Damage']
  player_stats['Armor'] = player_stats['Armor'] + armor['Armor'] + ring1['Armor'] + ring2['Armor']
  return player_stats
end

local function will_be_victorious(player_stats)
  local boss_stats = {
    ['Hit Points'] = 103,
    ['Damage'] = 9,
    ['Armor'] = 2,
  }

  while true do
    boss_stats['Hit Points'] = (boss_stats['Hit Points']
      - math.max(player_stats['Damage'] - boss_stats['Armor'], 1))
    player_stats['Hit Points'] = (player_stats['Hit Points']
      - math.max(boss_stats['Damage'] - player_stats['Armor'], 1))

    if boss_stats['Hit Points'] <= 0 then
      return true
    elseif player_stats['Hit Points'] <= 0 then
      return false
    end
  end
end

local function get_equipment()
  local weapons = {
    ['dagger'] =      {['Cost'] = 8,  ['Damage'] = 4, ['Armor'] = 0},
    ['shortsword'] =  {['Cost'] = 10, ['Damage'] = 5, ['Armor'] = 0},
    ['warhammer'] =   {['Cost'] = 25, ['Damage'] = 6, ['Armor'] = 0},
    ['longsword'] =   {['Cost'] = 40, ['Damage'] = 7, ['Armor'] = 0},
    ['greataxe'] =    {['Cost'] = 74, ['Damage'] = 8, ['Armor'] = 0},
  }
  local armors = {
    ['nothing'] =     {['Cost'] = 0,   ['Damage'] = 0, ['Armor'] = 0},
    ['leather'] =     {['Cost'] = 13,  ['Damage'] = 0, ['Armor'] = 1},
    ['chainmail'] =   {['Cost'] = 31,  ['Damage'] = 0, ['Armor'] = 2},
    ['splintmail'] =  {['Cost'] = 53,  ['Damage'] = 0, ['Armor'] = 3},
    ['bandedmail'] =  {['Cost'] = 75,  ['Damage'] = 0, ['Armor'] = 4},
    ['platemail'] =   {['Cost'] = 102, ['Damage'] = 0, ['Armor'] = 5},
  }
  local rings = {
    ['nothing'] = {['Cost'] = 0,   ['Damage'] = 0, ['Armor'] = 0},
    ['dmg1'] =    {['Cost'] = 25,  ['Damage'] = 1, ['Armor'] = 0},
    ['dmg2'] =    {['Cost'] = 50,  ['Damage'] = 2, ['Armor'] = 0},
    ['dmg3'] =    {['Cost'] = 100, ['Damage'] = 3, ['Armor'] = 0},
    ['dmg-1'] =   {['Cost'] = 20,  ['Damage'] = 0, ['Armor'] = 1},
    ['dmg-2'] =   {['Cost'] = 40,  ['Damage'] = 0, ['Armor'] = 2},
    ['dmg-3'] =   {['Cost'] = 80,  ['Damage'] = 0, ['Armor'] = 3},
  }
  return weapons, armors, rings
end

local function a()
  local weapons, armors, rings = get_equipment()

  local min_cost = 1000000

  for _, weapon in pairs(weapons) do
    for _, armor in pairs(armors) do
      for ring1_name, ring1 in pairs(rings) do
        for ring2_name, ring2 in pairs(rings) do

          if ring1_name ~= 'nothing' and ring1_name == ring2_name then
            break
          end

          local player_stats = get_player_stats(weapon, armor, ring1, ring2)

          local cost = weapon['Cost'] + armor['Cost'] + ring1['Cost'] + ring2['Cost']
          if will_be_victorious(player_stats) then
            if cost < min_cost then
              min_cost = cost
            end
          end
        end
      end
    end
  end
  return min_cost
end

local function b()
  local weapons, armors, rings = get_equipment()

  local max_cost = 0

  for _, weapon in pairs(weapons) do
    for _, armor in pairs(armors) do
      for ring1_name, ring1 in pairs(rings) do
        for ring2_name, ring2 in pairs(rings) do

          if ring1_name ~= 'nothing' and ring1_name == ring2_name then
            break
          end

          local player_stats = get_player_stats(weapon, armor, ring1, ring2)

          local cost = weapon['Cost'] + armor['Cost'] + ring1['Cost'] + ring2['Cost']
          if not will_be_victorious(player_stats) then
            if cost > max_cost then
              max_cost = cost
            end
          end
        end
      end
    end
  end
  return max_cost
end

return {a = a, b = b}
