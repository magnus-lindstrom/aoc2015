local u = require 'src/utils'

local lines = u.lines_from('inputs/9')

local function get_distances(input_lines)
  local distances = {}
  for _, line in pairs(input_lines) do
    local words = u.split_string_by_substring(line, ' ')

    if distances[words[1]] == nil then
      distances[words[1]] = {}
    end
    if distances[words[1]][words[3]] == nil then
      distances[words[1]][words[3]] = tonumber(words[5])
    end

    if distances[words[3]] == nil then
      distances[words[3]] = {}
    end
    if distances[words[3]][words[1]] == nil then
      distances[words[3]][words[1]] = tonumber(words[5])
    end
  end
  return distances
end

local function get_inv_distances(input_lines, largest_edge)
  local distances = {}
  for _, line in pairs(input_lines) do
    local words = u.split_string_by_substring(line, ' ')

    if distances[words[1]] == nil then
      distances[words[1]] = {}
    end
    if distances[words[1]][words[3]] == nil then
      distances[words[1]][words[3]] = largest_edge + 1 - tonumber(words[5])
    end

    if distances[words[3]] == nil then
      distances[words[3]] = {}
    end
    if distances[words[3]][words[1]] == nil then
      distances[words[3]][words[1]] = largest_edge + 1 - tonumber(words[5])
    end
  end
  return distances
end

local function min_dist_for_starting_point_and_distances(start, distances)

  local starting_node = {["current_point"] = start, ["distance"] = 0, ["have_been"] = {[start] = true}}
  local to_look_at = {starting_node}
  local i_look_at = 2 -- increment whenever a new index is inserted

  while(u.table_length(to_look_at) > 0) do
    local min_i
    local min_dist = math.huge
    for i, v in pairs(to_look_at) do
      if v['distance'] < min_dist then
        min_i = i
        min_dist = v['distance']
      end
    end

    local node = to_look_at[min_i]
    to_look_at[min_i] = nil

    if u.table_length(node["have_been"]) == 8 then
      return node["distance"]
    else
      for next_point, _ in pairs(distances[node["current_point"]]) do
        if node["have_been"][next_point] == nil then
          local new_node = u.table_copy(node)
          new_node["have_been"][next_point] = true
          new_node["distance"] = new_node["distance"] + distances[new_node["current_point"]][next_point]
          new_node["current_point"] = next_point
          to_look_at[i_look_at] = new_node
          i_look_at = i_look_at + 1
        end
      end
    end
  end
end

local function max_dist_for_starting_point_and_distances(start, distances, inv_distances)

  local starting_node = {current_point = start, distance = 0, inv_distance = 0, have_been = {[start] = true}}
  local to_look_at = {starting_node}
  local i_look_at = 2 -- increment whenever a new index is inserted

  while(u.table_length(to_look_at) > 0) do
    local min_i
    local min_dist = math.huge
    for i, v in pairs(to_look_at) do
      if v['inv_distance'] < min_dist then
        min_i = i
        min_dist = v['inv_distance']
      end
    end

    local node = to_look_at[min_i]
    to_look_at[min_i] = nil

    if u.table_length(node["have_been"]) == 8 then
      return node["distance"]
    else
      for next_point, _ in pairs(distances[node["current_point"]]) do
        if node["have_been"][next_point] == nil then
          local new_node = u.table_copy(node)
          new_node["have_been"][next_point] = true
          new_node["inv_distance"] = new_node["inv_distance"] + inv_distances[new_node["current_point"]][next_point]
          new_node["distance"] = new_node["distance"] + distances[new_node["current_point"]][next_point]
          new_node["current_point"] = next_point
          to_look_at[i_look_at] = new_node
          i_look_at = i_look_at + 1
        end
      end
    end
  end
end

local function a()
  -- Normal Dijkstra's
  local min_dist = math.huge
  local distances = get_distances(lines)
  for key in pairs(distances) do
    local distance = min_dist_for_starting_point_and_distances(key, distances)
    if distance < min_dist then
      min_dist = distance
    end
  end

  return min_dist
end

local function b()
  -- Modified Dijkstra's: Given the largest edge value E in the original graph G, modify each edge
  -- e_i into E + 1 - e_i, and run Dijkstra's for the new graph G'. When the shortest path is found
  -- in G', return the corresponding path length in G, which will be the longest path.
  local max_dist = 0
  local distances = get_distances(lines)
  local flattened_table = u.flatten_table(distances)
  local largest_edge = math.max(unpack(flattened_table))

  local inv_distances = get_inv_distances(lines, largest_edge)
  for key in pairs(distances) do
    local distance = max_dist_for_starting_point_and_distances(key, distances, inv_distances)
    if distance > max_dist then
      max_dist = distance
    end
  end

  return max_dist
end

return {a = a, b = b}
