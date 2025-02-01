local playerRanks = {}

--- @param player Player|nil
--- @param category string
--- @param pointsToIncrement any
function IncrementPlayerPoints(player, category, pointsToIncrement)
    if not db:IsConnected() then return end
    if not player then return end
    if player:IsFakeClient() then return end
    if not player:IsValid() then return end

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
function SavePlayerData(player)
    if not db:IsConnected() then return end
    if player:IsFakeClient() then return end

    local rank = GetRankFromPlayer(player)
    local params = {}

    if config:Fetch("ranks.UseLevelsRanksStructure") then
        params = {
            steam = tostring(player:GetSteamID()),
            name = player:CBasePlayerController().PlayerName,
            value = player:GetVar("ranks.points"),
            rank = Ranks[rank][1],
            kills = player:GetVar("ranks.kills"),
            deaths = player:GetVar("ranks.deaths"),
            shoots = player:GetVar("ranks.hits"),
            hits = player:GetVar("ranks.hits"),
            headshots = player:GetVar("ranks.headshots"),
            assists = player:GetVar("ranks.assists"),
            round_win = 0, -- wip,
            round_lose = 0, -- wip
            playtime = 0,
            lastconnect = 0,
        }
    else
        params = {
            points = player:GetVar("ranks.points"),
            kills = player:GetVar("ranks.kills"),
            deaths = player:GetVar("ranks.deaths"),
            assists = player:GetVar("ranks.assists"),
            name = player:CBasePlayerController().PlayerName,
            steamid = tostring(player:GetSteamID())
        }
    end

    db:QueryBuilder():Table("ranks"):Insert(params):OnDuplicate(params):Execute(function (err, result)
        if #err > 0 then
            print("ERROR!: " .. err)
        end
    end)
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
            TriggerEvent("OnRankUpdate", player:GetSlot(), i, Ranks[i][1], Ranks[i][2], Ranks[i][3], Ranks[i][4], points)
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

    if config:Fetch("ranks.UseLevelsRanksStructure") then
        db:QueryBuilder():Table("ranks"):Select({}):Where("steam", "=", tostring(player:GetSteamID())):Limit(1):Execute(function (err, result)
            if #err > 0 then
                print("ERROR: ".. err)
                return
            end

            if #result > 0 then
                player:SetVar("ranks.points", result[1].value)
                player:SetVar("ranks.kills", result[1].kills)
                player:SetVar("ranks.deaths", result[1].deaths)
                player:SetVar("ranks.assists", result[1].assists)
                IncrementPlayerPoints(player, "points", 0)
            else
                player:SetVar("ranks.points", 0)
                player:SetVar("ranks.kills", 0)
                player:SetVar("ranks.deaths", 0)
                player:SetVar("ranks.assists", 0)
                IncrementPlayerPoints(player, "points", 0)
            end
            SetupPlayerRank(player)
        end)
    else
        db:QueryBuilder():Table("ranks"):Select({}):Where("steamid", "=", tostring(player:GetSteamID())):Limit(1):Execute(function (err, result)
            if #err > 0 then
                print("ERROR: " .. err)
                return
            end

            if #result > 0 then
                player:SetVar("ranks.points", result[1].points)
                player:SetVar("ranks.kills", result[1].kills)
                player:SetVar("ranks.deaths", result[1].deaths)
                player:SetVar("ranks.assists", result[1].assists)
                IncrementPlayerPoints(player, "points", 0)
            else
                player:SetVar("ranks.points", 0)
                player:SetVar("ranks.kills", 0)
                player:SetVar("ranks.deaths", 0)
                player:SetVar("ranks.assists", 0)
                IncrementPlayerPoints(player, "points", 0)
            end
            SetupPlayerRank(player)
        end)
    end
end