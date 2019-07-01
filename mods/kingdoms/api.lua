local modstorage = minetest.get_mod_storage()

kingdoms = {}

kingdoms.kingdoms = minetest.deserialize(modstorage:get_string("kingdoms")) or {}
kingdoms.players = minetest.deserialize(modstorage:get_string("players")) or {}
kingdoms.diplomacy = minetest.deserialize(modstorage:get_string("diplomacy")) or {}

kingdoms.create_kingdom = function(name, color)
    local def = {}
    def.color = color
    def.ranks = {}
    def.territories = {}
    def.enemies = {}
    kingdoms.kingdoms[name] = def
end

kingdoms.get_kingdom = function(name)
    return kingdoms.kingdoms[name] or nil
end

kingdoms.set_player_kingdom = function(name, kingdom)
    kingdoms.players[name].kingdom = kingdom
end

kingdoms.set_player_rank = function(name, rank)
    kingdoms.players[name].rank = rank
end

kingdoms.get_player_kingdom = function(name)
    return kingdoms.players[name].kingdom or nil
end

kingdoms.get_player_rank = function(name)
    return kingdoms.players[name].rank or nil
end

kingdoms.add_territory = function(kingdom, pos1, pos2)
    kingdoms.kingdoms[kingdom].territories:insert({pos1, pos2})
end

-- Territory at pos
kingdoms.get_territory_index = function(kingdom, pos)
    for index, positions in pairs(kingdoms.kingdoms[kingdom].territories) do
        local pos1 = positions[1]
        local pos2 = positions[2]
    end
    return nil
end

kingdoms.set_territory_owner = function(old_owner, new_owner, territory_idx)
    local pos_table = kingdoms.kingdoms[old_owner].territories[territory_idx]
    kingdoms.kingdoms[old_owner].territories:remove(territory_idx)
    kingdoms.add_territory(new_owner, pos_table[1], pos_table[2])
end
