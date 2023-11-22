local u = require 'src/utils'


local mm_mana = 53
local mm_dmg = 4
local drain_mana = 73
local drain_dmg = 2
local drain_heal = 2
local shield_mana = 113
local shield_turns = 6
local shield_armor = 7
local poison_mana = 173
local poison_dmg = 3
local poison_turns = 6
local recharge_mana_cost = 229
local recharge_mana_recharged = 101
local recharge_turns = 5
local boss_dmg = 10
local boss_hp_at_start = 71

local function fire_magic_missile(fight_state)
  fight_state['mana'] = fight_state['mana'] - mm_mana
  fight_state['mana_spent'] = fight_state['mana_spent'] + mm_mana
  fight_state['boss_hp'] = fight_state['boss_hp'] - mm_dmg
end

local function cast_drain(fight_state)
  fight_state['mana'] = fight_state['mana'] - drain_mana
  fight_state['mana_spent'] = fight_state['mana_spent'] + drain_mana
  fight_state['boss_hp'] = fight_state['boss_hp'] - drain_dmg
  fight_state['player_hp'] = fight_state['player_hp'] + drain_heal
end

local function cast_shield(fight_state)
  fight_state['mana'] = fight_state['mana'] - shield_mana
  fight_state['mana_spent'] = fight_state['mana_spent'] + shield_mana
  fight_state['shield_turns_left'] = shield_turns
end

local function cast_poison(fight_state)
  fight_state['mana'] = fight_state['mana'] - poison_mana
  fight_state['mana_spent'] = fight_state['mana_spent'] + poison_mana
  fight_state['poison_turns_left'] = poison_turns
end

local function cast_recharge(fight_state)
  fight_state['mana'] = fight_state['mana'] - recharge_mana_cost
  fight_state['mana_spent'] = fight_state['mana_spent'] + recharge_mana_cost
  fight_state['recharge_turns_left'] = recharge_turns
end

local function apply_effects(fight_state)
  if fight_state['shield_turns_left'] > 0 then
    fight_state['shield_turns_left'] = fight_state['shield_turns_left'] - 1
  end
  if fight_state['poison_turns_left'] > 0 then
    fight_state['boss_hp'] = fight_state['boss_hp'] - poison_dmg
    fight_state['poison_turns_left'] = fight_state['poison_turns_left'] - 1
  end
  if fight_state['recharge_turns_left'] > 0 then
    fight_state['mana'] = fight_state['mana'] + recharge_mana_recharged
    fight_state['recharge_turns_left'] = fight_state['recharge_turns_left'] - 1
  end
end

local function take_boss_damage(fight_state)
  fight_state['player_hp'] = fight_state['player_hp'] - boss_dmg
  if fight_state['shield_turns_left'] > 0 then
    fight_state['player_hp'] = fight_state['player_hp'] + shield_armor
  end
end

local function a()
  local fight_states = {}
  table.insert(
    fight_states,
    {
      ['mana_spent'] = 0,
      ['player_hp'] = 50,
      ['mana'] = 500,
      ['boss_hp'] = boss_hp_at_start,
      ['shield_turns_left'] = 0,
      ['poison_turns_left'] = 0,
      ['recharge_turns_left'] = 0,
    }
  )

  local min_mana_spent = 1900
  local min_boss_hp = boss_hp_at_start

  while table.maxn(fight_states) > 0 do

    local fight_state = table.remove(fight_states)
    if fight_state['boss_hp'] < min_boss_hp then
      min_boss_hp = fight_state['boss_hp']
    end

    if fight_state['mana_spent'] < min_mana_spent then
      -- start of player turn
      apply_effects(fight_state)
      if fight_state['boss_hp'] <= 0 then
        if fight_state['mana_spent'] < min_mana_spent then
          min_mana_spent = fight_state['mana_spent']
        end
      end

      -- magic missile cast
      if fight_state['mana'] >= mm_mana then
        local new_state = u.table_copy(fight_state)
        fire_magic_missile(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 0 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end

      -- drain cast
      if fight_state['mana'] >= drain_mana then
        local new_state = u.table_copy(fight_state)
        cast_drain(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 0 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end

      -- shield cast
      if fight_state['mana'] >= shield_mana and fight_state['shield_turns_left'] == 0 then
        local new_state = u.table_copy(fight_state)
        cast_shield(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 0 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end

      -- poison cast
      if fight_state['mana'] >= poison_mana and fight_state['poison_turns_left'] == 0 then
        local new_state = u.table_copy(fight_state)
        cast_poison(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 0 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end

      -- recharge cast
      if fight_state['mana'] >= recharge_mana_cost and fight_state['recharge_turns_left'] == 0 then
        local new_state = u.table_copy(fight_state)
        cast_recharge(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 0 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end
    end
  end
  return min_mana_spent
end

local function b()
  --[[
  same as a() but subtract one hp at start of player turn. Also check that player hp is >1 instead
  of >0 before adding the state to the list of states
  --]]

  local fight_states = {}
  table.insert(
    fight_states,
    {
      ['mana_spent'] = 0,
      ['player_hp'] = 50,
      ['mana'] = 500,
      ['boss_hp'] = boss_hp_at_start,
      ['shield_turns_left'] = 0,
      ['poison_turns_left'] = 0,
      ['recharge_turns_left'] = 0,
    }
  )

  local min_mana_spent = 1000000
  local min_boss_hp = boss_hp_at_start

  while table.maxn(fight_states) > 0 do

    local fight_state = table.remove(fight_states)
    if fight_state['boss_hp'] < min_boss_hp then
      min_boss_hp = fight_state['boss_hp']
    end

    if fight_state['mana_spent'] < min_mana_spent then
      -- start of player turn
      fight_state['player_hp'] = fight_state['player_hp'] - 1
      apply_effects(fight_state)
      if fight_state['boss_hp'] <= 0 then
        if fight_state['mana_spent'] < min_mana_spent then
          min_mana_spent = fight_state['mana_spent']
        end
      end

      -- magic missile cast
      if fight_state['mana'] >= mm_mana then
        local new_state = u.table_copy(fight_state)
        fire_magic_missile(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 1 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end

      -- drain cast
      if fight_state['mana'] >= drain_mana then
        local new_state = u.table_copy(fight_state)
        cast_drain(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 1 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end

      -- shield cast
      if fight_state['mana'] >= shield_mana and fight_state['shield_turns_left'] == 0 then
        local new_state = u.table_copy(fight_state)
        cast_shield(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 1 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end

      -- poison cast
      if fight_state['mana'] >= poison_mana and fight_state['poison_turns_left'] == 0 then
        local new_state = u.table_copy(fight_state)
        cast_poison(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 1 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end

      -- recharge cast
      if fight_state['mana'] >= recharge_mana_cost and fight_state['recharge_turns_left'] == 0 then
        local new_state = u.table_copy(fight_state)
        cast_recharge(new_state)
        -- start of boss turn
        apply_effects(new_state)
        take_boss_damage(new_state)
        if new_state['boss_hp'] <= 0 then
          if new_state['mana_spent'] < min_mana_spent then
            min_mana_spent = new_state['mana_spent']
          end
        elseif new_state['player_hp'] > 1 and new_state['mana_spent'] < min_mana_spent then
          table.insert(fight_states, new_state)
        end
      end
    end
  end
  return min_mana_spent
end

return {a = a, b = b}
