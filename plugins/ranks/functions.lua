local playerRanks = {}

--- @param player Player|nil
--- @param category string
--- @param pointsToIncrement any
function IncrementPlayerPoints(player, category, pointsToIncrement)
    if not db:IsConnected() then return end
    if not player then return end
    if player:IsFakeClient() then return end
    if not player:IsValid() then return end

    local params = {
        steamid = tostring(player:GetSteamID()),
        name = player:CBasePlayerController().PlayerName,
        points = 0,
        kills = 0,
        deaths = 0,
        assists = 0,
        category = category,
        incrementPoints = pointsToIncrement
    }

    if params[category] then
        params[category] = params[category] + pointsToIncrement
    end

    db:QueryParams("insert ignore into `ranks` (steamid, points, kills, name, deaths, assists) values ('@steamid', 0, 0, '@name', 0, 0)", params)
    db:QueryParams("update `ranks` set @category = @category + @incrementPoints where steamid = '@steamid' limit 1", params)

    player:SetVar("ranks." .. category, FetchPlayer(player, category) + pointsToIncrement)

    if category == "points" then
        local oldrank = playerRanks[player:GetSlot()]
        SetupPlayerRank(player)
        if playerRanks[player:GetSlot()] > oldrank then
            ReplyToCommand(player:GetSlot(), config:Fetch("ranks.prefix"),
                FetchTranslation("ranks.promote"):gsub("{RANK}", Ranks[playerRanks[player:GetSlot()]][4]))
        elseif playerRanks[player:GetSlot()] < oldrank then
            ReplyToCommand(player:GetSlot(), config:Fetch("ranks.prefix"),
                FetchTranslation("ranks.demote"):gsub("{RANK}", Ranks[playerRanks[player:GetSlot()]][4]))
        end
    end
end

--- @param player Player
--- @param bType string
function FetchPlayer(player, bType)
    return (player:GetVar("ranks." .. bType) or 0)
end

--- @param player Player
function SetupPlayerRank(player)
    local points = FetchPlayer(player, "points")

    for i = #Ranks, 1, -1 do
        if points >= Ranks[i][3] then
            playerRanks[player:GetSlot()] = i
            TriggerEvent("OnRankUpdate", player:GetSlot(), i, Ranks[i][1], Ranks[i][2], Ranks[i][3], Ranks[i][4])
            break
        end
    end
end

--- @param points number
function CalculateRankByPoints(points)
    for i = #Ranks, 1, -1 do
        if points >= Ranks[i][3] then
            return i
        end
    end
    return 1
end

--- @param player Player
function GetRankFromPlayer(player)
    return playerRanks[player:GetSlot()]
end

--- @param player Player
function LoadPlayerData(player)
    if not db:IsConnected() then return end

    db:QueryParams("select * from ranks where steamid = '@steamid' limit 1", { steamid = player:GetSteamID() },
        function(err, result)
            if #err > 0 then
                print("ERROR: " .. err)
                return
            end

            if #result > 0 then
                player:SetVar("ranks.points", result[1].points)
                player:SetVar("ranks.kills", result[1].kills)
                player:SetVar("ranks.deaths", result[1].deaths)
                player:SetVar("ranks.assists", result[1].assists)
            else
                player:SetVar("ranks.points", 0)
                player:SetVar("ranks.kills", 0)
                player:SetVar("ranks.deaths", 0)
                player:SetVar("ranks.assists", 0)
            end
            SetupPlayerRank(player)
        end)
end
