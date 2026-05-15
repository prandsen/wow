local _, addon = ...

addon.currentPage = 1
addon.totalPages = 13

addon.pageContent = {}
for i = 1, addon.totalPages do
    addon.pageContent[i] = {}
end

-- Page definitions: maps page number to data
addon.pageConfig = {
    [1]  = { type = "welcome",    navKey = "introduction" },
    [2]  = { type = "uiscale",    navKey = "uiScale" },
    [3]  = { type = "addon",      navKey = "editMode",        addonName = "EditMode",               localeKey = "editMode" },
    [4]  = { type = "elvui",      navKey = "elvui",           addonName = "ElvUI",                  localeKey = "elvui" },
    [5]  = { type = "addon",      navKey = "plater",          addonName = "Plater",                 localeKey = "plater" },
    [6]  = { type = "addon",      navKey = "AyijeCDM",        addonName = "AyijeCDM",               localeKey = "ayijeCDM" },
    [7]  = { type = "addon",      navKey = "details",         addonName = "Details",                localeKey = "details" },
    [8]  = { type = "addon",      navKey = "bigwigs",         addonName = "BigWigs",                localeKey = "bigwigs" },
    [9]  = { type = "addon",      navKey = "danderFrames",    addonName = "DandersFrames",          localeKey = "danderFrames" },
    [10] = { type = "addon",      navKey = "uuf",             addonName = "UnhaltedUnitFrames",     localeKey = "uuf" },
    [11] = { type = "addon",      navKey = "abe",             addonName = "ActionBarsEnhanced",     localeKey = "abe" },
    [12] = { type = "addon",      navKey = "naowh",           addonName = "NaowhQOL",               localeKey = "naowh" },
    [13] = { type = "cdm",        navKey = "cooldownManager" },
}

-- Initialize AddOn after SavedVariables are loaded
addon.events = CreateFrame("Frame")
addon.events:RegisterEvent("ADDON_LOADED")
addon.events:RegisterEvent("PLAYER_ENTERING_WORLD")
addon.events:SetScript("OnEvent", addon.Init)