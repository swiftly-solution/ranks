AddEventHandler("OnPluginStart", function(event)
    db = Database("swiftly_ranks")

    db:Query(
        "CREATE TABLE IF NOT EXISTS `ranks` (`steamid` varchar(128) NOT NULL, `points` int(11) NOT NULL DEFAULT 0, `kills` int(11) NOT NULL DEFAULT 0, `name` varchar(128) NOT NULL, `deaths` int(11) NOT NULL DEFAULT 0, `assists` int(11) NOT NULL DEFAULT 0, UNIQUE (`steamid`)) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;")

    config:Create("ranks", {
        prefix = "[{lime}Swiftly{default}]",
        color = "32CD32",
        points = {
            headshot = 7,
            normal = 5,
            noscope = 7,
            assist = 3,
            death = 2
        },
        ranks = {
            Unranked = 0,
            Silver1 = 100,
            Silver2 = 300,
            Silver3 = 500,
            Silver4 = 700,
            Silver5 = 850,
            SEM = 900,
            GN1 = 1000,
            GN2 = 1250,
            GN3 = 1500,
            GN4 = 1650,
            MG1 = 1800,
            MG2 = 2000,
            MGE = 2250,
            DMG = 2500,
            LE = 2750,
            LEM = 3000,
            SMFC = 3250,
            Global = 3500,
        },
        linebreaker = "---"
    })

    Ranks = {
        { 0,  "Unranked", config:Fetch("ranks.ranks.Unranked"), "Unranked" },
        { 1,  "Silver1",  config:Fetch("ranks.ranks.Silver1"),  "Silver I" },
        { 2,  "Silver2",  config:Fetch("ranks.ranks.Silver2"),  "Silver II" },
        { 3,  "Silver3",  config:Fetch("ranks.ranks.Silver3"),  "Silver III" },
        { 4,  "Silver4",  config:Fetch("ranks.ranks.Silver4"),  "Silver IV" },
        { 5,  "Silver5",  config:Fetch("ranks.ranks.Silver5"),  "Silver Elite" },
        { 6,  "SEM",      config:Fetch("ranks.ranks.SEM"),      "Silver Elite Master" },
        { 7,  "GN1",      config:Fetch("ranks.ranks.GN1"),      "Gold Nova I" },
        { 8,  "GN2",      config:Fetch("ranks.ranks.GN2"),      "Gold Nova II" },
        { 9,  "GN3",      config:Fetch("ranks.ranks.GN3"),      "Gold Nova III" },
        { 10, "GN4",      config:Fetch("ranks.ranks.GN4"),      "Gold Nova Master" },
        { 11, "MG1",      config:Fetch("ranks.ranks.MG1"),      "Master Guardian I" },
        { 12, "MG2",      config:Fetch("ranks.ranks.MG2"),      "Master Guardian II" },
        { 13, "MGE",      config:Fetch("ranks.ranks.MGE"),      "Master Guardian Elite" },
        { 14, "DMG",      config:Fetch("ranks.ranks.DMG"),      "Distinguished Master Guardian" },
        { 15, "LE",       config:Fetch("ranks.ranks.LE"),       "Legendary Eagle" },
        { 16, "LEM",      config:Fetch("ranks.ranks.LEM"),      "Legendary Eagle Master" },
        { 17, "SMFC",     config:Fetch("ranks.ranks.SMFC"),     "Supreme" },
        { 18, "Global",   config:Fetch("ranks.ranks.Global"),   "Global Elite" }
    }

    LoadMenus()

    for i = 1, playermanager:GetPlayerCap() do
        local player = GetPlayer(i - 1)
        if player then
            if not player:IsFakeClient() then
                LoadPlayerData(player)
            end
        end
    end
end)

AddEventHandler("OnPlayerConnectFull", function(event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end

    LoadPlayerData(player)
end)

AddEventHandler("OnPlayerDeath", function(event)
    local playerid = event:GetInt("userid")
    local attackerid = event:GetInt("attacker")
    local assisterid = event:GetInt("assister")
    local headshot = event:GetBool("headshot")
    local noscope = event:GetBool("noscope")
    local player = GetPlayer(playerid)
    local attacker = GetPlayer(attackerid)
    local assister = GetPlayer(assisterid)

    if not player or not attacker then return EventResult.Continue end
    if attacker == nil or player == nil then return EventResult.Continue end
    if attackerid == playerid then return EventResult.Continue end

    local attackerpoints = FetchPlayer(attacker, "points")
    local playerpoints = FetchPlayer(player, "points")

    if headshot and attacker then
        IncrementPlayerPoints(attacker, "points", config:Fetch("ranks.points.headshot"))
        IncrementPlayerPoints(attacker, "kills", 1)

        attackerpoints = FetchPlayer(attacker, "points")

        ReplyToCommand(attackerid, config:Fetch("ranks.prefix"),
            FetchTranslation("ranks.addpointsmessage"):gsub("{EXP}", attackerpoints):gsub("{POINTS}",
                config:Fetch("ranks.points.headshot")):gsub("{CASE}", FetchTranslation("ranks.headshot")))

        if playerpoints >= config:Fetch("ranks.points.death") then
            IncrementPlayerPoints(player, "points", -config:Fetch("ranks.points.death"))
            IncrementPlayerPoints(player, "deaths", 1)

            playerpoints = FetchPlayer(player, "points")

            ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
                FetchTranslation("ranks.removepointsmessage"):gsub("{EXP}", playerpoints):gsub("{POINTS}",
                    config:Fetch("ranks.points.death")):gsub("{CASE}", FetchTranslation("ranks.death")))
        end
    elseif noscope and attacker then
        IncrementPlayerPoints(attacker, "points", config:Fetch("ranks.points.noscope"))
        IncrementPlayerPoints(attacker, "kills", 1)

        attackerpoints = FetchPlayer(attacker, "points")

        ReplyToCommand(attackerid, config:Fetch("ranks.prefix"),
            FetchTranslation("ranks.addpointsmessage"):gsub("{EXP}", attackerpoints):gsub("{POINTS}",
                config:Fetch("ranks.points.noscope")):gsub("{CASE}", FetchTranslation("ranks.noscope")))

        if playerpoints >= config:Fetch("ranks.points.death") then
            IncrementPlayerPoints(player, "points", -config:Fetch("ranks.points.death"))
            IncrementPlayerPoints(player, "deaths", 1)

            playerpoints = FetchPlayer(player, "points")

            ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
                FetchTranslation("ranks.removepointsmessage"):gsub("{EXP}", playerpoints):gsub("{POINTS}",
                    config:Fetch("ranks.points.death")):gsub("{CASE}", FetchTranslation("ranks.death")))
        end
    elseif attacker then
        IncrementPlayerPoints(attacker, "points", config:Fetch("ranks.points.normal"))
        IncrementPlayerPoints(attacker, "kills", 1)

        attackerpoints = FetchPlayer(attacker, "points")

        ReplyToCommand(attackerid, config:Fetch("ranks.prefix"),
            FetchTranslation("ranks.addpointsmessage"):gsub("{EXP}", attackerpoints):gsub("{POINTS}",
                config:Fetch("ranks.points.normal")):gsub("{CASE}", FetchTranslation("ranks.kill")))

        if playerpoints >= config:Fetch("ranks.points.death") then
            IncrementPlayerPoints(player, "points", -config:Fetch("ranks.points.death"))
            IncrementPlayerPoints(player, "deaths", 1)

            playerpoints = FetchPlayer(player, "points")

            ReplyToCommand(playerid, config:Fetch("ranks.prefix"),
                FetchTranslation("ranks.removepointsmessage"):gsub("{EXP}", playerpoints):gsub("{POINTS}",
                    config:Fetch("ranks.points.death")):gsub("{CASE}", FetchTranslation("ranks.death")))
        end
    end

    if assister then
        IncrementPlayerPoints(assister, "points", config:Fetch("ranks.points.assist"))
        IncrementPlayerPoints(assister, "assists", 1)

        local assisterpoints = FetchPlayer(assister, "points")

        ReplyToCommand(attackerid, config:Fetch("ranks.prefix"),
            FetchTranslation("ranks.addpointsmessage"):gsub("{EXP}", assisterpoints):gsub("{POINTS}",
                config:Fetch("ranks.points.assist")):gsub("{CASE}", FetchTranslation("ranks.assist")))
    end
end)

AddEventHandler("OnAllPluginsLoaded", function(event)
    if GetPluginState("admins") == PluginState_t.Started then
        exports["admins"]:RegisterMenuCategory("ranks.menu.admin.title", "lvladminmenu", "z")
    end

    return EventResult.Continue
end)
