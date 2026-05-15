local _, addon = ...

-- Хранилище чекбоксов
addon.Checkboxes = {}

-- ============================================================
-- 1. ДИАЛОГОВОЕ ОКНО РЕЛОАДА
-- ============================================================
StaticPopupDialogs["RASLUI_ALTS_RELOAD"] = {
    text = "Reload Required",
    button1 = "Reload",
    button2 = "Later",
    OnAccept = function() ReloadUI() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

-- ============================================================
-- 2. СОЗДАНИЕ ИНТЕРФЕЙСА
-- ============================================================
function addon:CreateAltsFrame()
    if self.altsFrame then return self.altsFrame end

    -- ЛОГИКА ЛОКАЛИЗАЦИИ
    if addon.Locale and addon.locale and (addon.locale["ruRU"] or addon.locale["enUS"]) then
        addon:Locale()
    end

    local L = (addon.locale and addon.locale.alts) or {}
    local function GetText(key, default)
        return L[key] or default
    end

    -- 1. Фрейм
    self.altsFrame = CreateFrame("Frame", "RaslUIAltsFrame", UIParent)
    self.altsFrame:SetSize(600, 600)
    self.altsFrame:SetPoint("CENTER")
    self.altsFrame:SetFrameStrata("DIALOG")
    self.altsFrame:Hide()
    self:UpdateFrameScale()



    -- 2. Фон
    local bg = self.altsFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(self.texturePath .. "GUI2.png")

    -- 3. Перетаскивание
    self.altsFrame:SetMovable(true)
    self.altsFrame:EnableMouse(true)
    self.altsFrame:RegisterForDrag("LeftButton")
    self.altsFrame:SetScript("OnDragStart", self.altsFrame.StartMoving)
    self.altsFrame:SetScript("OnDragStop", self.altsFrame.StopMovingOrSizing)

    -- 4. Кнопка закрытия
    local closeBtn = CreateFrame("Button", nil, self.altsFrame)
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("TOPRIGHT", -10, -30)
    closeBtn:SetNormalTexture(self.texturePath .. "ExitButton.png")
    closeBtn:SetHighlightTexture(self.texturePath .. "ExitButton.png", "ADD")
    closeBtn:SetScript("OnClick", function()
        self.altsFrame:Hide()
    end)

    -- 5. ТЕКСТЫ
    local heading = self.altsFrame:CreateFontString(nil, "OVERLAY")
    heading:SetPoint("TOP", 0, -110)
    heading:SetFont(self.fontPath, 20)
    heading:SetText(GetText("heading", "Setup Alts"))
    heading:SetTextColor(1, 1, 1, 1)

    local desc = self.altsFrame:CreateFontString(nil, "OVERLAY")
    desc:SetPoint("TOP", 0, -150)
    desc:SetFont(self.fontPath, 16)
    desc:SetText(GetText("desc", "Select addons"))
    desc:SetTextColor(0.8, 0.8, 0.8, 1)

    -- 6. ГЕНЕРАЦИЯ СПИСКА
    local layoutData = {
        -- Левая колонка
        { key = "EditMode",           label = "Edit Mode",      xL = -190, xC = -90, y = -215 },
        { key = "UnhaltedUnitFrames", label = "UUF",            xL = -190, xC = -90, y = -275 },
        { key = "AyijeCDM",           label = "AyijeCDM",       xL = -190, xC = -90, y = -335 },
        { key = "ActionBarsEnhanced", label = "ABE",            xL = -190, xC = -90, y = -395 },
        { key = "BigWigs",            label = "BigWigs",        xL = -190, xC = -90, y = -455 },

        -- Правая колонка
        { key = "DandersFrames",      label = "Danders Frames", xL = 90,   xC = 190, y = -215 },
        { key = "Details",            label = "Details",        xL = 90,   xC = 190, y = -275 },
        { key = "Plater",             label = "Plater",         xL = 90,   xC = 190, y = -335 },
        { key = "ElvUI",              label = "ElvUI",          xL = 90,   xC = 190, y = -395 },
        { key = "NaowhQOL",           label = "Naowh QOL",      xL = 90,   xC = 190, y = -455 },
       -- { key = "EnhanceQoL",         label = "Enhance QoL",    xL = 90,   xC = 190, y = -455 },
    }

    for _, data in ipairs(layoutData) do
        local yPos = data.y
        local xLabel = data.xL
        local xCheck = data.xC

        if yPos then
            addon:CreateImportLabel(self.altsFrame, data.label, xLabel, yPos)
            local cb = CreateFrame("CheckButton", nil, self.altsFrame, "UICheckButtonTemplate")
            cb:SetPoint("TOP", xCheck, yPos + 4)
            cb:SetChecked(true)
            addon.Checkboxes[data.key] = cb
        end
    end

    -- 7. КНОПКА "ПРИМЕНИТЬ"
    local btnApply = addon:CreateButton(GetText("applyBtn", "Apply"), 160, 40, self.altsFrame)
    btnApply:SetPoint("BOTTOM", 0, 40)

    btnApply:SetScript("OnClick", function()
        -- === ПРОВЕРКА: ВЫБРАН ЛИ ХОТЬ ОДИН ЧЕКБОКС? ===
        local anySelected = false
        for _, cb in pairs(addon.Checkboxes) do
            if cb:GetChecked() then
                anySelected = true
                break
            end
        end

        -- Если ничего не выбрано, просто выходим
        if not anySelected then return end
        -- ====================================================

        -- Читаем разрешение напрямую из RaslUIDB.resolution
        if not RaslUIDB or not RaslUIDB.resolution then
            print("|cff9834ebRasl|r|cffffffffUI|r: " ..
                GetText("wrongScale", "Resolution not set. Please select 1080p or 1440p in the installer first."))
            return
        end

        local resolution = RaslUIDB.resolution

        if resolution == "1080p" or resolution == "1440p" then
            addon:SetProfiles(resolution)
        else
            print("|cff9834ebRasl|r|cffffffffUI|r: " ..
                GetText("wrongScale", "Unknown resolution. Please select 1080p or 1440p in the installer first."))
        end
    end)

    return self.altsFrame
end

-- ============================================================
-- 3. ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================================
local function GetExactCharKey()
    return UnitName("player") .. " - " .. GetRealmName()
end

local function NormalizeName(name)
    if not name then return "" end
    name = name:gsub("|c........", ""):gsub("|r", "")
    name = name:gsub("[^%w]", "")
    return name:lower()
end

local function RunCheck(moduleKey, func)
    local cb = addon.Checkboxes[moduleKey]
    if cb and not cb:GetChecked() then return end

    local status, err = pcall(func)
    if not status then
        print("|cffff0000[!] Error (" .. moduleKey .. "): " .. tostring(err) .. "|r")
    end
end

-- ============================================================
-- 4. ОСНОВНАЯ ЛОГИКА (SET PROFILES)
-- ============================================================
function addon:SetProfiles(resolution)
    if addon.Locale and addon.locale and (addon.locale["ruRU"] or addon.locale["enUS"]) then
        addon:Locale()
    end
    local L = (addon.locale and addon.locale.alts) or {}

    local standardProfile = "RaslUI - " .. resolution
    local editModeProfile = "RaslUI - " .. resolution
    local charKey = GetExactCharKey()
    local targetNorm = NormalizeName(editModeProfile)

    if L.applying then
        addon:Print(string.format(L.applying, resolution))
    else
        addon:Print("--- Applying Profiles (" .. resolution .. ") ---")
    end

    local function LogSuccess(name)
        print(string.format(L.success or "[+] %s", name))
    end
    local function LogNotFound(name)
        print(string.format(L.notFound or "[-] %s profile not found", name))
    end
    local function LogNotLoaded(name)
        print(string.format(L.notLoaded or "[-] %s not loaded", name))
    end

    -- 1. Action Bars Enhanced (Mixin)
    RunCheck("ActionBarsEnhanced", function()
        if ActionBarsEnhancedProfilesMixin and ActionBarsEnhancedProfilesMixin.SetProfile then
            ActionBarsEnhancedProfilesMixin:SetProfile(standardProfile, false)
            LogSuccess("Action Bars Enhanced")
        elseif C_AddOns.IsAddOnLoaded("ActionBarsEnhanced") then
            local db = _G["ABDB"]
            if db then
                if not db.profileKeys then db.profileKeys = {} end
                db.profileKeys[charKey] = standardProfile
                LogSuccess("Action Bars Enhanced (DB)")
            else
                LogNotFound("Action Bars Enhanced")
            end
        else
            LogNotLoaded("Action Bars Enhanced")
        end
    end)

    -- 2. Edit Mode
    RunCheck("EditMode", function()
        if C_EditMode and C_EditMode.GetLayouts then
            local layoutInfo = C_EditMode.GetLayouts()
            local foundID = nil
            local success = false

            if layoutInfo and layoutInfo.layouts then
                for index, layout in ipairs(layoutInfo.layouts) do
                    if NormalizeName(layout.layoutName) == targetNorm then
                        foundID = layout.layoutIdentifier or (index + 2)
                        break
                    end
                end
            end

            if foundID then
                local status = pcall(function() C_EditMode.SetActiveLayout(tonumber(foundID)) end)
                if status then success = true end
            else
                local importString = nil
                if addon.profiles and addon.profiles[resolution] then
                    importString = addon.profiles[resolution]["EditMode"]
                end
                if importString and importString ~= "" then
                    local newLayoutInfo = C_EditMode.ConvertStringToLayoutInfo(importString)
                    if newLayoutInfo then
                        EditModeManagerFrame:ImportLayout(newLayoutInfo, Enum.EditModeLayoutType.Account, editModeProfile)
                        if C_EditMode.SaveLayouts then C_EditMode.SaveLayouts() end
                        success = true
                    end
                end
            end

            if success then
                LogSuccess("Edit Mode")
            else
                LogNotFound("Edit Mode")
            end
        end
    end)


    -- 3. ElvUI (Switch Profile + Import Private)
    RunCheck("ElvUI", function()
        if C_AddOns.IsAddOnLoaded("ElvUI") then
            local E = unpack(ElvUI)
            local D = E:GetModule("Distributor")

            if E.data.profiles[standardProfile] then
                E.data:SetProfile(standardProfile)
                LogSuccess("ElvUI Profile")
            else
                LogNotFound("ElvUI Profile (" .. standardProfile .. ")")
            end

            local elvData = addon.profiles and addon.profiles[resolution] and addon.profiles[resolution]["ElvUI"]

            if type(elvData) == "table" and elvData.private and elvData.private ~= "" then
                D:ImportProfile(elvData.private)
                LogSuccess("ElvUI Private Settings Imported")
            end

            E:StaggeredUpdateAll()
        else
            LogNotLoaded("ElvUI Profile")
        end
    end)

    -- 4. Details
    RunCheck("Details", function()
        if C_AddOns.IsAddOnLoaded("Details") then
            local _detalhes = _G._detalhes
            local profileExists = false
            if _detalhes and _detalhes.GetProfile then
                if _detalhes:GetProfile(standardProfile) then profileExists = true end
            end

            if profileExists then
                _detalhes:ApplyProfile(standardProfile)
                LogSuccess("Details")
            else
                LogNotFound("Details")
            end
        else
            LogNotLoaded("Details")
        end
    end)

    -- 5. Plater
    RunCheck("Plater", function()
        if C_AddOns.IsAddOnLoaded("Plater") then
            local db = _G["PlaterDB"]
            if db and db.profiles and db.profiles[standardProfile] then
                db.profileKeys[charKey] = standardProfile
                local Plater = _G.Plater
                if Plater and Plater.RefreshEverything then Plater.RefreshEverything() end
                LogSuccess("Plater")
            else
                LogNotFound("Plater")
            end
        else
            LogNotLoaded("Plater")
        end
    end)

    -- 6. BigWigs
    RunCheck("BigWigs", function()
        if C_AddOns.IsAddOnLoaded("BigWigs") then
            local db = _G["BigWigs3DB"]
            if db and db.profiles and db.profiles[standardProfile] then
                db.profileKeys[charKey] = standardProfile
                LogSuccess("BigWigs")
            else
                LogNotFound("BigWigs")
            end
        else
            LogNotLoaded("BigWigs")
        end
    end)

    -- 7. Unhalted Unit Frames
    RunCheck("UnhaltedUnitFrames", function()
        if C_AddOns.IsAddOnLoaded("UnhaltedUnitFrames") then
            local db = _G["UUFDB"]
            if db and db.profiles and db.profiles[standardProfile] then
                if not db.profileKeys then db.profileKeys = {} end
                db.profileKeys[charKey] = standardProfile
                LogSuccess("UnhaltedUnitFrames")
            else
                LogNotFound("UnhaltedUnitFrames")
            end
        else
            LogNotLoaded("UnhaltedUnitFrames")
        end
    end)

    -- 9. Danders Frames
    RunCheck("DandersFrames", function()
        if C_AddOns.IsAddOnLoaded("DandersFrames") then
            local db = _G["DandersFramesDB_v2"]
            if db and db.profiles and db.profiles[standardProfile] then
                db.currentProfile = standardProfile

                if not DandersFramesCharDB then
                    DandersFramesCharDB = {}
                end
                DandersFramesCharDB.currentProfile = standardProfile

                LogSuccess("Danders Frames")
            else
                LogNotFound("Danders Frames")
            end
        else
            LogNotLoaded("Danders Frames")
        end
    end)

        -- 11. Ayije CDM (delayed to avoid conflict with ElvUI StaggeredUpdateAll)
    RunCheck("AyijeCDM", function()
        if C_AddOns.IsAddOnLoaded("Ayije_CDM") then
            C_Timer.After(0.5, function()
                local db = _G["Ayije_CDMDB"]
                local AyijeCDM = _G["Ayije_CDM"]
                local findProfile = false

                if db and db.profiles then
                    -- Сначала ищем точное совпадение по разрешению
                    local exactName = "RaslUI - " .. resolution
                    if db.profiles[exactName] then
                        AyijeCDM:SetProfile(exactName)
                        findProfile = true
                        LogSuccess("Ayije CDM")
                    else
                        -- Фоллбэк: ищем любой профиль начинающийся с RaslUI
                        for name, _ in pairs(db.profiles) do
                            if name:find("^RaslUI") then
                                AyijeCDM:SetProfile(name)
                                findProfile = true
                                LogSuccess("Ayije CDM")
                                break
                            end
                        end
                    end
                end
                if not findProfile then
                    LogNotFound("Ayije CDM")
                end
            end)
        else
            LogNotLoaded("Ayije CDM")
        end
    end)

    -- 12. Naowh QOL
    RunCheck("NaowhQOL", function()
        if C_AddOns.IsAddOnLoaded("NaowhQOL") then
            if not NaowhQOL_API then
                LogNotLoaded("Naowh QOL")
                return
            end

            local existingProfiles = NaowhQOL_API:GetProfileKeys()
            if existingProfiles[standardProfile] then
                NaowhQOL_API:SetProfile(standardProfile)
                LogSuccess("Naowh QOL")
            else
                LogNotFound("Naowh QOL")
            end
        else
            LogNotLoaded("Naowh QOL")
        end
    end)

    StaticPopupDialogs["RASLUI_ALTS_RELOAD"].text = L.reloadText or "Reload required"
    StaticPopupDialogs["RASLUI_ALTS_RELOAD"].button1 = L.reloadBtn or "Reload"
    StaticPopupDialogs["RASLUI_ALTS_RELOAD"].button2 = L.laterBtn or "Later"

    StaticPopup_Show("RASLUI_ALTS_RELOAD")
end