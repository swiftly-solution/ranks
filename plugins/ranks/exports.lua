export("FetchStatistics", function(playerid)
    if type(playerid) ~= "number" then playerid = tonumber(playerid) end
    local player = GetPlayer(playerid)
    if not player then return 0 end

    return {
        kills = FetchPlayer(player, "kills"),
        deaths = FetchPlayer(player, "deaths"),
        assists = FetchPlayer(player, "assists"),
        points = FetchPlayer(player, "points")
    }
end)

export("FetchPoints", function(playerid)
    if type(playerid) ~= "number" then playerid = tonumber(playerid) end
    local player = GetPlayer(playerid)
    if not player then return 0 end

    return FetchPlayer(player, "points")
end)
