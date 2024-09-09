commands:Register("lvl", function(playerid, args, argc, silent, prefix)
    if playerid == -1 or not db:IsConnected() then return end

    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    player:HideMenu()
    player:ShowMenu("lvlmenu")
end)

commands:Register("lvl_admin", function(playerid, args, argsCount, silent)
    if playerid == -1 or not db:IsConnected() then return end

    local player = GetPlayer(playerid)
    if not player then return end

    if not exports["admins"]:HasFlags(playerid, "z") then
        return ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.no_access"))
    end

    player:HideMenu()
    player:ShowMenu("lvladminmenu")
end)

commands:Register("top", function(playerid, args, argc, silent, prefix)
    if playerid == -1 or not db:IsConnected() then return end

    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    player:HideMenu()
    player:ShowMenu("topmenu")
end)

commands:Register("rank", function(playerid, args, argc, silent)
    if playerid == -1 or not db:IsConnected() then return end

    local player = GetPlayer(playerid)
    if not player then return end

    local points = FetchPlayer(player, "points")
    local rank = GetRankFromPlayer(player)

    if rank <= 18 then
        ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
            FetchTranslation("ranks.ranksmessage"):gsub("{NAME}", player:CBasePlayerController().PlayerName):gsub(
                "{POINTS}", points):gsub("{RANK}", Ranks[rank][4]):gsub("{PLACE}", Ranks[rank][1])
            :gsub("{MAXPLACE}", #Ranks):gsub("{REMAININGPOINTS}", Ranks[rank + 1][3] - points):gsub("{LINEBREAKER}",
                config:Fetch("ranks.linebreaker")))
    else
        ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
            FetchTranslation("ranks.ranksmessage"):gsub("{NAME}", player:CBasePlayerController().PlayerName):gsub(
                "{POINTS}", points):gsub("{RANK}", Ranks[rank][4]):gsub("{PLACE}", Ranks[rank][1])
            :gsub("{MAXPLACE}", #Ranks):gsub("{REMAININGPOINTS}", 0):gsub("{LINEBREAKER}",
                config:Fetch("ranks.linebreaker")))
    end
end)

commands:Register("stats", function(playerid, args, argc, silent)
    if playerid == -1 or not db:IsConnected() then return end

    local player = GetPlayer(playerid)
    if not player then return end

    local kills = FetchPlayer(player, "kills")
    local points = FetchPlayer(player, "points")
    local deaths = FetchPlayer(player, "deaths")
    local assists = FetchPlayer(player, "assists")
    local rank = GetRankFromPlayer(player)

    local ratio = deaths ~= 0 and kills / deaths or 0.0
    ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
        FetchTranslation("ranks.statsmessage"):gsub("{POINTS}", points):gsub("{RANK}", Ranks[rank][4]):gsub("{KILLS}",
            kills):gsub("{DEATHS}", deaths):gsub("{ASSISTS}", assists):gsub("{RATIO}", ratio):gsub("{PREFIX}",
            config:Fetch("ranks.linebreaker")))
    player:HideMenu()
end)

commands:Register("topexp", function(playerid, args, argc, silent)
    if playerid == -1 or not db:IsConnected() then return end

    local player = GetPlayer(playerid)
    if not player then return end

    db:Query(string.format("SELECT name, points FROM `ranks` ORDER BY points DESC LIMIT 10"), function(err, result)
        if #err > 0 then
            print("{RED}: ERROR: " .. err)
            return
        end
        for i = 1, #result do
            if type(result[i]) == "table" then
                local name = result[i]["name"]
                local points = tonumber(result[i]["points"] or 0)
                local rank = CalculateRankByPoints(points)

                ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
                    FetchTranslation("ranks.topexpmessage"):gsub("{POSITION}", i):gsub("{NAME}", name):gsub(
                        "{EXPERIENCE}", points):gsub("{RANK}", Ranks[rank][4]))
            end
        end
        player:HideMenu()
    end)
end)


commands:Register("topkills", function(playerid, args, argc, silent)
    if playerid == -1 or not db:IsConnected() then return end

    local player = GetPlayer(playerid)
    if not player then return end

    db:Query(string.format("SELECT name, kills, points FROM `ranks` ORDER BY kills DESC LIMIT 10"), function(err, result)
        if #err > 0 then
            print("{RED}: ERROR: " .. err)
            return
        end
        for i = 1, #result do
            if type(result[i]) == "table" then
                local name = result[i]["name"]
                local points = result[i]["points"]
                local kills = tonumber(result[i]["kills"] or 0)
                local rank = CalculateRankByPoints(points)

                ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
                    FetchTranslation("ranks.topkillsmessage"):gsub("{POSITION}", i):gsub("{NAME}", name):gsub("{KILLS}",
                        kills):gsub("{RANK}", Ranks[rank][4]))
            end
        end
        player:HideMenu()
    end)
end)

commands:Register("lvl_reload", function(playerid, args, argc, silent)
    if not db:IsConnected() then return end

    if playerid == -1 then
        server:Execute("sw translations reload")
        config:Reload("ranks")
        print("{RED}RANKS {DEFAULT} The configuration and the translations have been reloaded.")
    else
        local player = GetPlayer(playerid)
        if not player then return end

        if not exports["admins"]:HasFlags(playerid, "z") then
            return ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.no_access"))
        end

        server:Execute("sw translations reload")
        config:Reload("ranks")
        ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.reloaded"))
    end
end)


commands:Register("resetallmenu", function(playerid, args, argc, silent)
    if playerid == -1 or not db:IsConnected() then return end

    if not exports["admins"]:HasFlags(playerid, "z") then
        return ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.no_access"))
    end

    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    player:HideMenu()
    player:ShowMenu("lvlresetallconfirm")
end)

commands:Register("resetexpconfirm", function(playerid, args, argc, silent)
    if playerid == -1 or not db:IsConnected() then return end

    if not exports["admins"]:HasFlags(playerid, "z") then
        return ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.no_access"))
    end

    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    player:HideMenu()
    player:ShowMenu("lvlresetexpconfirm")
end)

commands:Register("resetstatsconfirm", function(playerid, args, argc, silent)
    if playerid == -1 or not db:IsConnected() then return end

    if not exports["admins"]:HasFlags(playerid, "z") then
        return ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.no_access"))
    end

    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    player:HideMenu()
    player:ShowMenu("lvlresetstatsconfirm")
end)

local resetFunctions = {
    all = function(playerid)
        db:Query("UPDATE `ranks` SET points = 0, kills = 0, deaths = 0, assists = 0", function(err, result)
            for i = 1, playermanager:GetPlayerCap() do
                local player = GetPlayer(i - 1)
                if player then
                    if not player:IsFakeClient() then
                        player:SetVar("ranks.points", 0)
                        player:SetVar("ranks.kills", 0)
                        player:SetVar("ranks.deaths", 0)
                        player:SetVar("ranks.assists", 0)

                        SetupPlayerRank(player)
                    end
                end
            end
        end)
        ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.reset.all"))
    end,
    exp = function(playerid)
        db:Query("UPDATE `ranks` SET points = 0", function(err, result)
            for i = 1, playermanager:GetPlayerCap() do
                local player = GetPlayer(i - 1)
                if player then
                    if not player:IsFakeClient() then
                        player:SetVar("ranks.points", 0)

                        SetupPlayerRank(player)
                    end
                end
            end
        end)
        ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.reset.exp"))
    end,
    stats = function(playerid)
        db:Query("UPDATE `ranks` SET kills = 0, deaths = 0, assists = 0", function(err, result)
            for i = 1, playermanager:GetPlayerCap() do
                local player = GetPlayer(i - 1)
                if player then
                    if not player:IsFakeClient() then
                        player:SetVar("ranks.kills", 0)
                        player:SetVar("ranks.deaths", 0)
                        player:SetVar("ranks.assists", 0)
                    end
                end
            end
        end)
        ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.reset.stats"))
    end
}

commands:Register("lvl_reset", function(playerid, args, argc, silent, prefix)
    if not db:IsConnected() then return end

    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        if not exports["admins"]:HasFlags(playerid, "z") then
            return ReplyToCommand(playerid, config:Fetch("ranks.prefix"), FetchTranslation("ranks.no_access"))
        end
    end

    if argc < 1 then
        return ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
            ("Syntax: {PREFIX}lvl_reset <all/exp/stats>"):gsub("{PREFIX}", prefix))
    end

    local category = args[1]

    if not resetFunctions[category] then
        return ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
            ("Syntax: {PREFIX}lvl_reset <all/exp/stats>"):gsub("{PREFIX}", prefix))
    end

    resetFunctions[category](playerid)
end)
