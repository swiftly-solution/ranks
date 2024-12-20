function LoadMenus()
    menus:Register("lvlmenu", FetchTranslation("ranks.menu.main.title"), config:Fetch("ranks.color"), {
        { FetchTranslation("ranks.menu.showstats.title"),    "sw_stats" },
        { FetchTranslation("ranks.menu.showrank.title"),     "sw_rank" },
        { FetchTranslation("ranks.menu.showallranks.title"), "sw_ranksdisplay" },
        { FetchTranslation("ranks.menu.top.title"),          "sw_top" },
    })

    menus:Register("topmenu", FetchTranslation("ranks.menu.top.title"), config:Fetch("ranks.color"), {
        { FetchTranslation("ranks.menu.topexp.title"),   "sw_topexp" },
        { FetchTranslation("ranks.menu.topkills.title"), "sw_topkills" },
        { FetchTranslation("ranks.menu.goback"),         "sw_lvl" },
    })

    menus:Register("lvladminmenu", FetchTranslation("ranks.menu.admin.title"), config:Fetch("ranks.color"), {
        { FetchTranslation("ranks.menu.resetsettings.title"), "sw_lvl_reload" },
        { FetchTranslation("ranks.menu.reset.title"),         "sw_resetstatsmenu" },
    })

    menus:Register("lvlresetstatsmenu", FetchTranslation("ranks.menu.reset.title"), config:Fetch("ranks.color"), {
        { FetchTranslation("ranks.menu.resetall"), "sw_resetallmenu" },
        { FetchTranslation("ranks.menu.resetexp"), "sw_resetexpconfirm" },
        { FetchTranslation("ranks.menu.resetkda"), "sw_resetstatsconfirm" },
        { FetchTranslation("ranks.menu.goback"),   "sw_lvl_admin" },
    })

    menus:Register("lvlresetallconfirm", FetchTranslation("ranks.menu.resetall.confirm"), config:Fetch("ranks.color"), {
        { FetchTranslation("ranks.menu.yes"), "sw_lvl_reset all" },
        { FetchTranslation("ranks.menu.no"),  "lvlresetstatsmenu" },
    })

    menus:Register("lvlresetexpconfirm", FetchTranslation("ranks.menu.resetexp.confirm"), config:Fetch("ranks.color"), {
        { FetchTranslation("ranks.menu.yes"), "sw_lvl_reset exp" },
        { FetchTranslation("ranks.menu.no"),  "lvlresetstatsmenu" },
    })

    menus:Register("lvlresetstatsconfirm", FetchTranslation("ranks.menu.resetkda.confirm"), config:Fetch("ranks.color"),
        {
            { FetchTranslation("ranks.menu.yes"), "sw_lvl_reset stats" },
            { FetchTranslation("ranks.menu.no"),  "lvlresetstatsmenu" },
        })
end
