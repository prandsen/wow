local _, addon = ...

addon.uiScale = string.format("%.2f", tonumber(GetCVar("uiScale") or 0.00))

if addon.uiScale == "0.53" then
    addon.resolution = "1440p"
elseif addon.uiScale == "0.71" then
    addon.resolution = "1080p"
else
    addon.resolution = "1080p"
end

-- Media
addon.texturePath = [[Interface\AddOns\RaslUI\Media\Textures\]]
addon.fontPath = [[Interface\AddOns\RaslUI\Media\Font\Expressway_Bold.ttf]]

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font", "Expressway_R", [[Interface\Addons\RaslUI\Media\Font\Expressway_Bold.ttf]],
    LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("statusbar", "Blank_R", [[Interface\Addons\RaslUI\Media\Textures\Blank.tga]],
    LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("statusbar", "Clean_R", [[Interface\Addons\RaslUI\Media\Textures\Statusbar_Clean.blp]],
    LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
------------------------------------------------------
-- Profile Versions
------------------------------------------------------
addon.profileVersions = {
    EditMode = "2.1",
    ElvUI = "1.4",
    ElvUIHeal = "1.3",
    Plater = "1.2",
    AyijeCDM = "3.0",
    Details = "1.1",
    BigWigs = "2.1",
    DandersFrames = "3.0",
    UnhaltedUnitFrames = "2.1",
    ActionBarsEnhanced = "1.0",
    NaowhQOL = "1.2"

}

------------------------------------------------------
-- Profile Version Check
------------------------------------------------------
function addon:GetProfileStatus(addonName)
    RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
    local currentVersion = self.profileVersions[addonName]
    local importedVersion = RaslUIDB.importedVersions[addonName]

    if not importedVersion then
        return "none", currentVersion
    elseif importedVersion ~= currentVersion then
        return "outdated", currentVersion, importedVersion
    else
        return "current", currentVersion
    end
end

function addon:CreateProfileStatusText(parent, addonName, x, y, pageNum)
    local L = self.locale.profileStatus

    local statusText = parent:CreateFontString(nil, "OVERLAY")
    statusText:SetPoint("TOP", x, y)
    statusText:SetFont(self.fontPath, 13, "OUTLINE")

    if not self:Loaded(addonName) then
        statusText:SetText("|cffaaaaaa" .. L.notLoaded .. "|r")
    else
        local status, currentVer = self:GetProfileStatus(addonName)
        if status == "none" then
            statusText:SetText("|cffff0000" .. L.none .. "|r|cff00ff00" .. L.version .. currentVer .. "|r")
        elseif status == "outdated" then
            statusText:SetText("|cffff0000" .. L.outdated .. "|r|cff00ff00" .. L.version .. currentVer .. "|r")
        else
            statusText:SetText("|cff00ff00" .. L.current .. currentVer .. "|r")
        end
    end

    -- Save reference for live update
    self.statusTexts = self.statusTexts or {}
    self.statusTexts[addonName] = statusText

    table.insert(self.pageContent[pageNum], statusText)
    return statusText
end

function addon:RefreshProfileStatus(addonName)
    if not self.statusTexts or not self.statusTexts[addonName] then return end

    local statusText = self.statusTexts[addonName]
    local L = self.locale.profileStatus

    if not self:Loaded(addonName) then
        statusText:SetText("|cffaaaaaa" .. L.notLoaded .. "|r")
        return
    end

    local status, currentVer = self:GetProfileStatus(addonName)
    if status == "none" then
        statusText:SetText("|cffff0000" .. L.none .. "|r|cff00ff00" .. L.version .. currentVer .. "|r")
    elseif status == "outdated" then
        statusText:SetText("|cffff0000" .. L.outdated .. "|r|cff00ff00" .. L.version .. currentVer .. "|r")
    else
        statusText:SetText("|cff00ff00" .. L.current .. currentVer .. "|r")
    end
end

-- Pretty print
function addon:Print(msg)
    print("|cff9834ebRasl|r|cffffffffUI|r: " .. msg)
end

-- Confirmation Dialog for Profile Import
StaticPopupDialogs["RASLUI_CONFIRM_IMPORT"] = {
    text = "Are you sure you want to import the %s profile? This will overwrite your current settings.",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function(self, data)
        if data.class then
            addon:Import(data.addonName, {
                class = data.class,
                spec = data.spec,
                profile = data.profile
            })
        else
            addon:Import(data.addonName)
        end
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

function addon:Locale()
    if GetLocale() == "ruRU" then
        self.locale = self.locale["ruRU"]
    else
        self.locale = self.locale["enUS"]
    end
end

function addon:CreateButton(text, width, height, parent)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(width, height)
    btn:SetNormalTexture(self.texturePath .. "Button.png")
    btn:SetHighlightTexture(self.texturePath .. "Button.png", "ADD")

    local btnText = btn:CreateFontString(nil, "OVERLAY")
    btnText:SetFont(self.fontPath, 16, "OUTLINE")
    btnText:SetPoint("CENTER")
    btnText:SetText(text)

    return btn
end

function addon:CreateLargeButton(text, xOffset, yOffset, parent)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(550, 40)
    btn:SetPoint("TOP", xOffset, yOffset)
    btn:SetNormalTexture(self.texturePath .. "LargeButton.png")
    btn:SetHighlightTexture(self.texturePath .. "LargeButton.png", "ADD")

    local btnText = btn:CreateFontString(nil, "OVERLAY")
    btnText:SetFont(self.fontPath, 18, "OUTLINE")
    btnText:SetPoint("CENTER")
    btnText:SetText(text)

    return btn
end

-- Navigation Buttons (Previous / Next)
function addon:CreateNavButton(position)
    local btn = CreateFrame("Button", nil, self.frame)
    btn:SetSize(80, 25)

    local btnText = btn:CreateFontString(nil, "OVERLAY")
    btnText:SetFont(self.fontPath, 16, "OUTLINE")
    btnText:SetPoint("CENTER")
    if position == "next" then
        btnText:SetText("Next")
    else
        btnText:SetText("Back")
    end

    if position == "next" then
        btn:SetPoint("BOTTOMRIGHT", self.contentArea, "BOTTOMRIGHT", -25, 15)
    else
        btn:SetPoint("BOTTOMLEFT", self.contentArea, "BOTTOMLEFT", 15, 15)
    end

    btn:SetNormalTexture(self.texturePath .. "Button.png")
    btn:SetHighlightTexture(self.texturePath .. "Button.png", "ADD")

    btn.btnText = btnText
    return btn
end

-- Import Buttons
function addon:CreateImportButton(parent, addonName, xOffset, yOffset)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(100, 40)
    btn:SetPoint("TOP", xOffset, yOffset)
    btn:SetNormalTexture(self.texturePath .. "Button.png")
    btn:SetHighlightTexture(self.texturePath .. "Button.png", "ADD")

    local btnText = btn:CreateFontString(nil, "OVERLAY")
    btnText:SetFont(self.fontPath, 16, "OUTLINE")
    btnText:SetPoint("CENTER")
    btnText:SetText("Import")

    btn:SetScript("OnClick", function()
        local data = self.specButtons and self.specButtons[btn]

        if addonName == "CooldownManager" and data then
            StaticPopup_Show("RASLUI_CONFIRM_IMPORT", addonName, nil, {
                addonName = addonName,
                class = data.class,
                spec = data.spec,
                profile = data.profile
            })
        elseif addonName == "AyijeCDM" then
            self:Import(addonName)
        else
            StaticPopup_Show("RASLUI_CONFIRM_IMPORT", addonName, nil, {
                addonName = addonName
            })
        end
    end)

    btn.addonName = addonName
    btn.btnText = btnText
    return btn
end

-- Import Labels
function addon:CreateImportLabel(parent, text, xOffset, yOffset, class)
    local label = parent:CreateFontString(nil, "OVERLAY")
    label:SetPoint("TOP", xOffset, yOffset)
    label:SetFont(self.fontPath, 18, "OUTLINE")
    label:SetText(text)

    if class then
        local color = RAID_CLASS_COLORS[class]
        label:SetTextColor(color.r, color.g, color.b, 1)
    else
        label:SetTextColor(1, 1, 1, 1)
    end

    label.underline = parent:CreateTexture(nil, "OVERLAY")
    label.underline:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -2)
    label.underline:SetPoint("TOPRIGHT", label, "BOTTOMRIGHT", 0, -2)
    label.underline:SetHeight(3)
    label.underline:SetTexture(self.texturePath .. "Underline.png")

    return label
end

-- Create FontString
function addon:CreateFontString(parent, text, textSize, yOffset, textColor)
    local fontString = parent:CreateFontString(nil, "OVERLAY")
    fontString:SetPoint("TOP", 0, yOffset)
    fontString:SetFont(self.fontPath, textSize, "OUTLINE")
    fontString:SetText(text)
    if textColor then
        fontString:SetTextColor(unpack(textColor))
    else
        fontString:SetTextColor(1, 1, 1, 1)
    end
    return fontString
end

-- Update Import Buttons based on current resolution
function addon:UpdateImportButtons()
    if not self.importButtons then return end

    local resProfiles = self.resolution and self.profiles[self.resolution]

    for _, btn in pairs(self.importButtons) do
        local addonName = btn.addonName
        local profile

        if addonName == "ElvUI" then
            local elvData = resProfiles and resProfiles["ElvUI"]
            if type(elvData) == "table" and elvData.profile and elvData.profile ~= "" then
                profile = elvData.profile
            else
                profile = nil
            end
        elseif addonName == "ElvUIHeal" then
            local elvData = resProfiles and resProfiles["ElvUIHeal"]
            if type(elvData) == "table" and elvData.profile and elvData.profile ~= "" then
                profile = elvData.profile
            else
                profile = nil
            end
        else
            profile = resProfiles and resProfiles[addonName]
        end

        -- ElvUIHeal использует ElvUI как загруженный аддон
        local loadedName = addonName
        if addonName == "ElvUIHeal" then
            loadedName = "ElvUI"
        end

        if not self:Loaded(loadedName) then
            btn:GetNormalTexture():SetDesaturated(true)
            btn:Disable()
            btn.btnText:SetText("Import")
        elseif profile == "" or profile == nil then
            btn:GetNormalTexture():SetDesaturated(true)
            btn:Disable()
            btn.btnText:SetText("Coming soon")
        else
            btn:GetNormalTexture():SetDesaturated(false)
            btn:Enable()
            btn.btnText:SetText("Import")
        end
    end
end

-- Update Spec Buttons based on current resolution
function addon:UpdateSpecButtons()
    if not self.specButtons then return end

    for btn, data in pairs(self.specButtons) do
        if data.profile == "" or data.profile == nil then
            btn:GetNormalTexture():SetDesaturated(true)
            btn:Disable()
            btn.btnText:SetText("Coming soon")
        else
            btn:GetNormalTexture():SetDesaturated(false)
            btn:Enable()
            btn.btnText:SetText("Import")
        end
    end
end

-- Reset View
function addon:ResetView()
    for _, page in pairs(self.pageContent) do
        for _, element in pairs(page) do
            if element.Hide then
                element:Hide()
            end
        end
    end
end

-- Check if a resolution has been chosen
function addon:IsUIScaleValid()
    return RaslUIDB and RaslUIDB.resolution ~= nil
end

function addon:IsEditModeImported()
    if not RaslUIDB or not RaslUIDB.importedVersions then
        return false
    end

    return RaslUIDB.importedVersions.EditMode ~= nil
end

-- Update navigation menu highlight
function addon:UpdateNavHighlight()
    if not self.navButtons then return end
    for i, btn in ipairs(self.navButtons) do
        if i == self.currentPage then
            btn.text:SetTextColor(0.58, 0.32, 0.93, 1)
        else
            local locked = false

            if i == 3 then
                locked = not self:IsUIScaleValid()
            elseif i > 3 then
                locked = (not self:IsUIScaleValid()) or (not self:IsEditModeImported())
            end

            if locked then
                btn.text:SetTextColor(0.4, 0.4, 0.4, 1)
            else
                btn.text:SetTextColor(0.7, 0.7, 0.7, 1)
            end
        end
    end
end

-- Set View
function addon:SetView(pageNum)
    if pageNum == 3 then
        if not self:IsUIScaleValid() then
            return
        end
    elseif pageNum > 3 then
        if not self:IsUIScaleValid() or not self:IsEditModeImported() then
            return
        end
    end

    self:ResetView()
    self.currentPage = pageNum

    if self.pageContent[pageNum] then
        for _, element in pairs(self.pageContent[pageNum]) do
            if element.Show then
                element:Show()
            end
        end
    end

    self:UpdateNavHighlight()

    if self.backBtn and self.nextBtn then
        if pageNum == 1 then
            self.backBtn:Hide()
        else
            self.backBtn:Show()
        end

        self.nextBtn:Show()

        if pageNum == self.totalPages then
            self.nextBtn.btnText:SetText("Finish")
        else
            self.nextBtn.btnText:SetText("Next")
        end

        if pageNum == 2 then
            if self:IsUIScaleValid() then
                self.nextBtn:Enable()
                self.nextBtn:GetNormalTexture():SetDesaturated(false)
            else
                self.nextBtn:Disable()
                self.nextBtn:GetNormalTexture():SetDesaturated(true)
            end
        elseif pageNum == 3 then
            if self:IsEditModeImported() then
                self.nextBtn:Enable()
                self.nextBtn:GetNormalTexture():SetDesaturated(false)
            else
                self.nextBtn:Disable()
                self.nextBtn:GetNormalTexture():SetDesaturated(true)
            end
        else
            self.nextBtn:Enable()
            self.nextBtn:GetNormalTexture():SetDesaturated(false)
        end
    end
end

function addon:UpdateFrameScale()
    if not self.frame then return end

    local uiParentScale = UIParent:GetScale()
    local baseScale = 0.533333
    local compensatedScale = baseScale / uiParentScale

    self.frame:SetScale(compensatedScale)

    if self.altsFrame then
        self.altsFrame:SetScale(compensatedScale)
    end
end

------------------------------------------------------
-- Create a single addon import page (generic template)
------------------------------------------------------
function addon:CreateAddonPage(pageNum, addonName, localeKey)
    local loc = self.locale[localeKey]

    -- Heading
    local heading = self.contentArea:CreateFontString(nil, "OVERLAY")
    heading:SetPoint("TOP", 0, -60)
    heading:SetFont(self.fontPath, 32, "OUTLINE")
    heading:SetText(loc.heading)
    table.insert(self.pageContent[pageNum], heading)

    -- Description
    local desc = self.contentArea:CreateFontString(nil, "OVERLAY")
    desc:SetPoint("TOP", 0, -120)
    desc:SetFont(self.fontPath, 18, "OUTLINE")
    desc:SetText(loc.desc)
    desc:SetTextColor(0.8, 0.8, 0.8, 1)
    desc:SetJustifyH("CENTER")
    desc:SetWidth(550)
    table.insert(self.pageContent[pageNum], desc)

    -- Profile status text (sits just above the import button)
    self:CreateProfileStatusText(self.contentArea, addonName, 0, -358, pageNum)

    -- Import button (centered)
    local importBtn = self:CreateImportButton(self.contentArea, addonName, 0, -390)
    table.insert(self.pageContent[pageNum], importBtn)

    -- Track import button
    if not self.importButtons then self.importButtons = {} end
    table.insert(self.importButtons, importBtn)
end
------------------------------------------------------
-- Create ElvUI page with two import buttons (DPS/Tank + Healer)
------------------------------------------------------
function addon:CreateElvUIPage(pageNum, localeKey)
    local loc = self.locale[localeKey]

    -- Heading
    local heading = self.contentArea:CreateFontString(nil, "OVERLAY")
    heading:SetPoint("TOP", 0, -60)
    heading:SetFont(self.fontPath, 32, "OUTLINE")
    heading:SetText(loc.heading)
    table.insert(self.pageContent[pageNum], heading)

    -- Description
    local desc = self.contentArea:CreateFontString(nil, "OVERLAY")
    desc:SetPoint("TOP", 0, -120)
    desc:SetFont(self.fontPath, 18, "OUTLINE")
    desc:SetText(loc.desc)
    desc:SetTextColor(0.8, 0.8, 0.8, 1)
    desc:SetJustifyH("CENTER")
    desc:SetWidth(550)
    table.insert(self.pageContent[pageNum], desc)

    -- ===== DPS/Tank Profile =====
    local dpsLabel = self.contentArea:CreateFontString(nil, "OVERLAY")
    dpsLabel:SetPoint("TOP", 0, -300)
    dpsLabel:SetFont(self.fontPath, 18, "OUTLINE")
    dpsLabel:SetText("Main Profile")
    dpsLabel:SetTextColor(1, 1, 1, 1)
    table.insert(self.pageContent[pageNum], dpsLabel)

    -- Profile status for ElvUI (DPS)
    self:CreateProfileStatusText(self.contentArea, "ElvUI", 0, -330, pageNum)

    -- Import button for ElvUI (DPS/Tank)
    local importBtnDPS = self:CreateImportButton(self.contentArea, "ElvUI", 0, -350)
    table.insert(self.pageContent[pageNum], importBtnDPS)

    if not self.importButtons then self.importButtons = {} end
    table.insert(self.importButtons, importBtnDPS)

    -- ===== Healer Profile =====
    local healLabel = self.contentArea:CreateFontString(nil, "OVERLAY")
    healLabel:SetPoint("TOP", 0, -400)
    healLabel:SetFont(self.fontPath, 18, "OUTLINE")
    healLabel:SetText("Healer Profile")
    healLabel:SetTextColor(1, 1, 1, 1)
    table.insert(self.pageContent[pageNum], healLabel)

    -- Profile status for ElvUIHeal
    self:CreateProfileStatusText(self.contentArea, "ElvUIHeal", 0, -430, pageNum)

    -- Import button for ElvUIHeal (Healer)
    local importBtnHeal = CreateFrame("Button", nil, self.contentArea)
    importBtnHeal:SetSize(100, 40)
    importBtnHeal:SetPoint("TOP", 0, -450)
    importBtnHeal:SetNormalTexture(self.texturePath .. "Button.png")
    importBtnHeal:SetHighlightTexture(self.texturePath .. "Button.png", "ADD")

    local btnText = importBtnHeal:CreateFontString(nil, "OVERLAY")
    btnText:SetFont(self.fontPath, 16, "OUTLINE")
    btnText:SetPoint("CENTER")
    btnText:SetText("Import")

    importBtnHeal.addonName = "ElvUIHeal"
    importBtnHeal.btnText = btnText

    importBtnHeal:SetScript("OnClick", function()
        StaticPopup_Show("RASLUI_CONFIRM_IMPORT", "ElvUI Healer", nil, {
            addonName = "ElvUIHeal"
        })
    end)

    table.insert(self.pageContent[pageNum], importBtnHeal)
    table.insert(self.importButtons, importBtnHeal)
end

------------------------------------------------------
-- Create the Cooldown Manager page (page 12)
------------------------------------------------------
function addon:CreateCDMPage()
    local pageNum = 13
    local loc = self.locale.cooldownManager

    -- Description text
    local desc = self.contentArea:CreateFontString(nil, "OVERLAY")
    desc:SetPoint("TOP", 0, -60)
    desc:SetFont(self.fontPath, 16, "OUTLINE")
    desc:SetText(loc.desc)
    desc:SetTextColor(0.8, 0.8, 0.8, 1)
    desc:SetJustifyH("CENTER")
    desc:SetWidth(500)
    table.insert(self.pageContent[pageNum], desc)

    -- Class definitions with their specs
    local classData = {
        -- Left column
        {
            column = "left",
            class = "WARRIOR",
            className = "Warrior",
            yPos = -100,
            specs = {
                { spec = "Arms",       cdmKey = "ARMS" },
                { spec = "Fury",       cdmKey = "FURY" },
                { spec = "Protection", cdmKey = "PROTECTION" },
            }
        },
        {
            column = "left",
            class = "PALADIN",
            className = "Paladin",
            yPos = -160,
            specs = {
                { spec = "Holy",        cdmKey = "HOLY" },
                { spec = "Protection",  cdmKey = "PROTECTION" },
                { spec = "Retribution", cdmKey = "RETRIBUTION" },
            }
        },
        {
            column = "left",
            class = "HUNTER",
            className = "Hunter",
            yPos = -220,
            specs = {
                { spec = "Beast Mastery", cdmKey = "BEASTMASTERY" },
                { spec = "Marksmanship",  cdmKey = "MARKSMANSHIP" },
                { spec = "Survival",      cdmKey = "SURVIVAL" },
            }
        },
        {
            column = "left",
            class = "ROGUE",
            className = "Rogue",
            yPos = -280,
            specs = {
                { spec = "Assassination", cdmKey = "ASSASSINATION" },
                { spec = "Outlaw",        cdmKey = "OUTLAW" },
                { spec = "Subtlety",      cdmKey = "SUBTLETY" },
            }
        },
        {
            column = "left",
            class = "PRIEST",
            className = "Priest",
            yPos = -340,
            specs = {
                { spec = "Discipline", cdmKey = "DISCIPLINE" },
                { spec = "Holy",       cdmKey = "HOLY" },
                { spec = "Shadow",     cdmKey = "SHADOW" },
            }
        },
        {
            column = "left",
            class = "DEATHKNIGHT",
            className = "Death Knight",
            yPos = -400,
            specs = {
                { spec = "Blood",  cdmKey = "BLOOD" },
                { spec = "Frost",  cdmKey = "FROST" },
                { spec = "Unholy", cdmKey = "UNHOLY" },
            }
        },
        {
            column = "left",
            class = "SHAMAN",
            className = "Shaman",
            yPos = -460,
            specs = {
                { spec = "Elemental",   cdmKey = "ELEMENTAL" },
                { spec = "Enhancement", cdmKey = "ENHANCEMENT" },
                { spec = "Restoration", cdmKey = "RESTORATION" },
            }
        },
        -- Right column
        {
            column = "right",
            class = "MAGE",
            className = "Mage",
            yPos = -100,
            specs = {
                { spec = "Arcane", cdmKey = "ARCANE" },
                { spec = "Fire",   cdmKey = "FIRE" },
                { spec = "Frost",  cdmKey = "FROST" },
            }
        },
        {
            column = "right",
            class = "WARLOCK",
            className = "Warlock",
            yPos = -160,
            specs = {
                { spec = "Affliction",  cdmKey = "AFFLICTION" },
                { spec = "Demonology",  cdmKey = "DEMONOLOGY" },
                { spec = "Destruction", cdmKey = "DESTRUCTION" },
            }
        },
        {
            column = "right",
            class = "MONK",
            className = "Monk",
            yPos = -220,
            specs = {
                { spec = "Brewmaster", cdmKey = "BREWMASTER" },
                { spec = "Mistweaver", cdmKey = "MISTWEAVER" },
                { spec = "Windwalker", cdmKey = "WINDWALKER" },
            }
        },
        {
            column = "right",
            class = "DRUID",
            className = "Druid",
            yPos = -280,
            specs = {
                { spec = "Balance",     cdmKey = "BALANCE" },
                { spec = "Feral",       cdmKey = "FERAL" },
                { spec = "Guardian",    cdmKey = "GUARDIAN" },
                { spec = "Restoration", cdmKey = "RESTORATION" },
            }
        },
        {
            column = "right",
            class = "DEMONHUNTER",
            className = "Demon Hunter",
            yPos = -340,
            specs = {
                { spec = "Havoc",     cdmKey = "HAVOC" },
                { spec = "Vengeance", cdmKey = "VENGEANCE" },
                { spec = "Devourer", cdmKey = "DEVOURER" }
            }
        },
        {
            column = "right",
            class = "EVOKER",
            className = "Evoker",
            yPos = -400,
            specs = {
                { spec = "Augmentation", cdmKey = "AUGMENTATION" },
                { spec = "Devastation",  cdmKey = "DEVASTATION" },
                { spec = "Preservation", cdmKey = "PRESERVATION" },
            }
        },
    }

    for _, data in ipairs(classData) do
        local xLabel, xBtn
        if data.column == "left" then
            xLabel = -210
            xBtn = -80
        else
            xLabel = 80
            xBtn = 210
        end

        -- Class label
        local label = self:CreateImportLabel(self.contentArea, data.className, xLabel, data.yPos, data.class)
        table.insert(self.pageContent[pageNum], label)
        table.insert(self.pageContent[pageNum], label.underline)

        -- Spec list under class name
        local specNames = {}
        local specProfiles = {}
        for _, spec in ipairs(data.specs) do
            table.insert(specNames, spec.spec)
            local profile = self.profiles.CDM and self.profiles.CDM[data.class] and
                self.profiles.CDM[data.class][spec.cdmKey]
            table.insert(specProfiles, {
                class = data.className,
                spec = spec.spec,
                profile = profile
            })
        end

        -- Spec names text (two per line)
        local line1 = ""
        local line2 = ""

        if #specNames <= 2 then
            line1 = table.concat(specNames, ", ")
        else
            line1 = specNames[1] .. ", " .. specNames[2]
            for j = 3, #specNames do
                if line2 ~= "" then
                    line2 = line2 .. ", "
                end
                line2 = line2 .. specNames[j]
            end
        end

        local specText = self.contentArea:CreateFontString(nil, "OVERLAY")
                specText:SetPoint("TOP", xLabel, data.yPos - 22)
        specText:SetFont(self.fontPath, 11, "OUTLINE")
        specText:SetTextColor(0.7, 0.7, 0.7, 1)

        if line2 ~= "" then
            specText:SetText(line1 .. "\n" .. line2)
        else
            specText:SetText(line1)
        end

        table.insert(self.pageContent[pageNum], specText)

        -- Import button for the whole class
        local btn = CreateFrame("Button", nil, self.contentArea)
        btn:SetSize(100, 40)
        btn:SetPoint("TOP", xBtn, data.yPos - 8)
        btn:SetNormalTexture(self.texturePath .. "Button.png")
        btn:SetHighlightTexture(self.texturePath .. "Button.png", "ADD")

        local btnText = btn:CreateFontString(nil, "OVERLAY")
        btnText:SetFont(self.fontPath, 16, "OUTLINE")
        btnText:SetPoint("CENTER")
        btnText:SetText("Import")
        btn.btnText = btnText

        -- Check if any profile is available
        local hasProfile = false
        for _, sp in ipairs(specProfiles) do
            if sp.profile and sp.profile ~= "" then
                hasProfile = true
                break
            end
        end

        if not hasProfile then
            btn:GetNormalTexture():SetDesaturated(true)
            btn:Disable()
            btn.btnText:SetText("Coming soon")
        end

        -- Store spec profiles on the button for the click handler
        btn.specProfiles = specProfiles
        btn.className = data.className

        btn:SetScript("OnClick", function()
            addon:ImportCDMClass(btn.specProfiles, btn.className)
        end)

        table.insert(self.pageContent[pageNum], btn)
    end
end

------------------------------------------------------
-- Create Navigation Panel (right side)
------------------------------------------------------
function addon:CreateNavPanel()
    self.navPanel = CreateFrame("Frame", nil, self.frame)
    self.navPanel:SetSize(160, 520)
    self.navPanel:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -10, -50)

    -- Title
    local navTitle = self.navPanel:CreateFontString(nil, "OVERLAY")
    navTitle:SetPoint("TOPLEFT", 10, -10)
    navTitle:SetFont(self.fontPath, 20, "OUTLINE")
    navTitle:SetText("Steps")
    navTitle:SetTextColor(0.58, 0.32, 0.93, 1)

    local navKeys = {
        "introduction", "uiScale", "editMode", "elvui", "plater", "ayijeCDM",
        "details", "bigwigs", "danderFrames", "uuf", "abe", "naowh", "cooldownManager",
    }

    self.navButtons = {}

    for i, key in ipairs(navKeys) do
        local navBtn = CreateFrame("Button", nil, self.navPanel)
        navBtn:SetSize(150, 20)
        navBtn:SetPoint("TOPLEFT", 10, -40 - (i - 1) * 24)

        local navText = navBtn:CreateFontString(nil, "OVERLAY")
        navText:SetFont(self.fontPath, 16, "OUTLINE")
        navText:SetPoint("LEFT", 0, 0)
        navText:SetText(self.locale.nav[key])
        navText:SetTextColor(0.7, 0.7, 0.7, 1)

        navBtn.text = navText
        navBtn.pageIndex = i

        navBtn:SetScript("OnClick", function()
            if i == 3 then
                if not self:IsUIScaleValid() then
                    return
                end
            elseif i > 3 then
                if not self:IsUIScaleValid() or not self:IsEditModeImported() then
                    return
                end
            end
            self:SetView(i)
        end)

        self.navButtons[i] = navBtn
    end
end

------------------------------------------------------
-- Installer GUI
------------------------------------------------------
function addon:CreateInstallerFrame()
    self:Locale()

    -- Create main frame
    self.frame = CreateFrame("Frame", "RaslUIInstallerFrame", UIParent)
    self.frame:SetSize(780, 600)
    self.frame:SetPoint("CENTER")
    self.frame:SetFrameStrata("DIALOG")
    self.frame:Hide()

    self:UpdateFrameScale()

    -- Background texture
    local bg = self.frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(self.texturePath .. "GUI.png")

    -- Make frame draggable
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:SetScript("OnDragStart", self.frame.StartMoving)
    self.frame:SetScript("OnDragStop", self.frame.StopMovingOrSizing)

    -- Close button
    local closeBtn = CreateFrame("Button", nil, self.frame)
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("TOPRIGHT", -10, -30)
    closeBtn:SetNormalTexture(self.texturePath .. "ExitButton.png")
    closeBtn:SetHighlightTexture(self.texturePath .. "ExitButton.png", "ADD")
    closeBtn:SetScript("OnClick", function()
        self.frame:Hide()
    end)

    -- Content area
    self.contentArea = CreateFrame("Frame", nil, self.frame)
    self.contentArea:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 10, -30)
    self.contentArea:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -175, 10)

    -- Create navigation panel
    self:CreateNavPanel()

    -- Navigation buttons
    self.backBtn = self:CreateNavButton("back")
    self.nextBtn = self:CreateNavButton("next")

    -- Store import buttons
    self.importButtons = {}

    ----------------------------
    -- PAGE 1: Introduction
    ----------------------------

    local p1_heading = self.contentArea:CreateFontString(nil, "OVERLAY")
    p1_heading:SetPoint("TOP", 0, -60)
    p1_heading:SetFont(self.fontPath, 30, "OUTLINE")
    p1_heading:SetText(self.locale.page1.heading)
    table.insert(self.pageContent[1], p1_heading)

    local p1_desc1 = self.contentArea:CreateFontString(nil, "OVERLAY")
    p1_desc1:SetPoint("TOP", 0, -110)
    p1_desc1:SetFont(self.fontPath, 18, "OUTLINE")
    p1_desc1:SetWidth(500)
    p1_desc1:SetText(self.locale.page1.desc1)
    p1_desc1:SetJustifyH("LEFT")
    table.insert(self.pageContent[1], p1_desc1)

    local p1_desc2 = self.contentArea:CreateFontString(nil, "OVERLAY")
    p1_desc2:SetPoint("TOP", 0, -190)
    
    p1_desc2:SetFont(self.fontPath, 18, "OUTLINE")
    p1_desc2:SetText(self.locale.page1.desc2)
    table.insert(self.pageContent[1], p1_desc2)

    local p1_desc3 = self.contentArea:CreateFontString(nil, "OVERLAY")
    p1_desc3:SetPoint("TOP", 0, -300)
    p1_desc3:SetFont(self.fontPath, 18, "OUTLINE")
    p1_desc3:SetText(self.locale.page1.desc3)
    table.insert(self.pageContent[1], p1_desc3)

    local p1_addonHeading = self.contentArea:CreateFontString(nil, "OVERLAY")
    p1_addonHeading:SetPoint("TOP", 0, -340)
    p1_addonHeading:SetFont(self.fontPath, 18, "OUTLINE")
    p1_addonHeading:SetText(self.locale.page1.addonListHeading)
    table.insert(self.pageContent[1], p1_addonHeading)

    local p1_addonList = self.contentArea:CreateFontString(nil, "OVERLAY")
    p1_addonList:SetPoint("TOP", 0, -410)
    p1_addonList:SetFont(self.fontPath, 18, "OUTLINE")
    p1_addonList:SetText(self.locale.page1.addonList)
    p1_addonList:SetTextColor(0.9, 0.3, 0.3, 1)
    p1_addonList:SetWidth(550)
    p1_addonList:SetJustifyH("CENTER")
    table.insert(self.pageContent[1], p1_addonList)

    ----------------------------
    -- PAGE 2: UI Scale
    ----------------------------

    local p2_heading = self.contentArea:CreateFontString(nil, "OVERLAY")
    p2_heading:SetPoint("TOP", 0, -60)
    p2_heading:SetFont(self.fontPath, 32, "OUTLINE")
    p2_heading:SetText(self.locale.page2.heading)
    table.insert(self.pageContent[2], p2_heading)

    local p2_desc1 = self.contentArea:CreateFontString(nil, "OVERLAY")
    p2_desc1:SetPoint("TOP", 0, -110)
    p2_desc1:SetWidth(550)
    p2_desc1:SetFont(self.fontPath, 18, "OUTLINE")
    p2_desc1:SetText(self.locale.page2.desc1)
    table.insert(self.pageContent[2], p2_desc1)

    local p2_desc2 = self.contentArea:CreateFontString(nil, "OVERLAY")
    p2_desc2:SetPoint("TOP", 0, -190)
    p2_desc2:SetWidth(550)
    p2_desc2:SetFont(self.fontPath, 18, "OUTLINE")
    p2_desc2:SetText(self.locale.page2.desc2)
    table.insert(self.pageContent[2], p2_desc2)

    local p2_desc3 = self.contentArea:CreateFontString(nil, "OVERLAY")
    p2_desc3:SetPoint("TOP", 0, -280)
    p2_desc3:SetWidth(550)
    p2_desc3:SetFont(self.fontPath, 18, "OUTLINE")
    p2_desc3:SetText(self.locale.page2.desc3)
    p2_desc3:SetTextColor(0.9, 0.3, 0.3, 1)
    table.insert(self.pageContent[2], p2_desc3)

    local p2_desc4 = self.contentArea:CreateFontString(nil, "OVERLAY")
    p2_desc4:SetPoint("TOP", 0, -320)
    p2_desc4:SetFont(self.fontPath, 18, "OUTLINE")
    p2_desc4:SetText(self.locale.page2.desc4)
    p2_desc4:SetTextColor(0.9, 0.3, 0.3, 1)
    table.insert(self.pageContent[2], p2_desc4)

    local p2_scale = self.contentArea:CreateFontString(nil, "OVERLAY")
    p2_scale:SetPoint("TOP", 0, -440)
    p2_scale:SetFont(self.fontPath, 18, "OUTLINE")
    p2_scale:SetText(self.locale.page2.scale .. self.uiScale .. " (" .. self.resolution .. ")")
    table.insert(self.pageContent[2], p2_scale)

    -- Resolution buttons (NO LONGER change UIParent scale, only select resolution for profiles)
    local btn1080p = self:CreateButton("1080p", 130, 40, self.contentArea)
    btn1080p:SetPoint("TOP", -85, -370)
    table.insert(self.pageContent[2], btn1080p)

    local btn1440p = self:CreateButton("1440p", 130, 40, self.contentArea)
    btn1440p:SetPoint("TOP", 85, -370)
    table.insert(self.pageContent[2], btn1440p)

    btn1080p:SetScript("OnClick", function()
        RaslUIDB.resolution = "1080p"
        self.resolution = "1080p"
        self.uiScale = "0.71"
        p2_scale:SetText(self.locale.page2.scale .. "0.71 (1080p)")
        self:UpdateImportButtons()
        self:UpdateSpecButtons()
        self:UpdateNavHighlight()
        if self.nextBtn then
            self.nextBtn:Enable()
            self.nextBtn:GetNormalTexture():SetDesaturated(false)
        end
    end)

    btn1440p:SetScript("OnClick", function()
        RaslUIDB.resolution = "1440p"
        self.resolution = "1440p"
        self.uiScale = "0.53"
        p2_scale:SetText(self.locale.page2.scale .. "0.53 (1440p)")
        self:UpdateImportButtons()
        self:UpdateSpecButtons()
        self:UpdateNavHighlight()
        if self.nextBtn then
            self.nextBtn:Enable()
            self.nextBtn:GetNormalTexture():SetDesaturated(false)
        end
    end)

    ----------------------------
    -- PAGES 3-13: Addon Import Pages
    ----------------------------

    for pageNum = 3, 13 do
    local config = self.pageConfig[pageNum]
    if config and config.type == "addon" then
        self:CreateAddonPage(pageNum, config.addonName, config.localeKey)
    elseif config and config.type == "elvui" then
        self:CreateElvUIPage(pageNum, config.localeKey)
    elseif config and config.type == "cdm" then
        self:CreateCDMPage()
    end
end

    ----------------------------
    -- Initial State
    ----------------------------

    self:SetView(1)

    self.backBtn:SetScript("OnClick", function()
        if self.currentPage > 1 then
            self:SetView(self.currentPage - 1)
        end
    end)

    self.nextBtn:SetScript("OnClick", function()
        if self.currentPage < self.totalPages then
            self:SetView(self.currentPage + 1)
        elseif self.currentPage == self.totalPages then
            self.frame:Hide()
            ReloadUI()
        end
    end)

    self:UpdateImportButtons()
    self:UpdateSpecButtons()

    return self.frame
end

------------------------------------------------------
-- Init
------------------------------------------------------

function addon:Init(event, addonName)
    if event == "ADDON_LOADED" and addonName == "RaslUI" then
        addon.events:UnregisterEvent("ADDON_LOADED")

        SLASH_RASLUI1 = "/rui"
        SLASH_RASLUI2 = "/rasl"
        SLASH_SPELLS1 = "/spells"

        SlashCmdList["RASLUI"] = function(msg)
    local command = msg:match("^(%S*)")
    if command then
        command = command:lower()
    end

    if command == "alts" then
        if not addon.altsFrame then
            addon:CreateAltsFrame()
        end
        if addon.frame then
            addon.frame:Hide()
        end
        addon.altsFrame:Show()

    elseif command == "cdm" then
        if addon.altsFrame then
            addon.altsFrame:Hide()
        end
        if not addon.frame then
            addon:CreateInstallerFrame()
        end
        if addon.frame then
            addon.frame:Show()
            addon:SetView(13)
        end

    else
        if addon.altsFrame then
            addon.altsFrame:Hide()
        end
        if not addon.frame then
            addon:CreateInstallerFrame()
        end
        if addon.frame then
            addon.frame:Show()
            addon:SetView(1)
        end
    end
end

        SlashCmdList["SPELLS"] = function()
            CooldownViewerSettings:SetShown(not CooldownViewerSettings:IsShown())
        end

        RaslUIDB = RaslUIDB or {}
    end

    if event == "PLAYER_ENTERING_WORLD" then
        -- Restore resolution choice without changing UIParent scale
        if RaslUIDB.resolution then
            addon.resolution = RaslUIDB.resolution
            if RaslUIDB.resolution == "1080p" then
                addon.uiScale = "0.71"
            elseif RaslUIDB.resolution == "1440p" then
                addon.uiScale = "0.53"
            end
        else
            -- Migration: check old RaslUIDB.scale format
            if RaslUIDB.scale then
                if RaslUIDB.scale == 0.711111 then
                    addon.resolution = "1080p"
                    addon.uiScale = "0.71"
                    RaslUIDB.resolution = "1080p"
                elseif RaslUIDB.scale == 0.533333 then
                    addon.resolution = "1440p"
                    addon.uiScale = "0.53"
                    RaslUIDB.resolution = "1440p"
                end
                RaslUIDB.scale = nil -- clean up old key
            else
                addon.uiScale = "N/A"
                addon.resolution = ""
            end
        end

        if not addon.frame then
            addon:CreateInstallerFrame()
        end

        if RaslUIDB.firstTime == nil then
            RaslUIDB.firstTime = true
            addon.frame:Show()
        end

        -- Mute BugSack error sounds automatically
        if C_AddOns.IsAddOnLoaded("BugSack") and type(BugSackDB) == "table" then
            BugSackDB.mute = true
        end
    end
end

function addon:Loaded(addonName)
    if addonName == "EditMode" then return true end
    if addonName == "ElvUIHeal" then return C_AddOns.IsAddOnLoaded("ElvUI") end
    local nameMap = {
        AyijeCDM = "Ayije_CDM",
    }
    return C_AddOns.IsAddOnLoaded(nameMap[addonName] or addonName)
end

------------------------------------------------------
-- BigWigs Instance Profile Import (BWIS1)
------------------------------------------------------

local function RaslUI_CopyTable(tbl)
    local copy = {}
    for key, value in next, tbl do
        if type(value) == "table" then
            copy[key] = RaslUI_CopyTable(value)
        else
            copy[key] = value
        end
    end
    return copy
end

-- Decode a BWIS1 string into a data table
function addon:DecodeBigWigsInstance(importString, index)
    local preFix, importData = importString:match("^(%w+):(.+)$")
    if preFix ~= "BWIS1" then
        self:Print(("[BigWigs Instance #%d] Invalid prefix, skipping."):format(index or 0))
        return nil
    end

    local decode_ok, decoded = pcall(C_EncodingUtil.DecodeBase64, importData)
    if not decode_ok or not decoded then
        self:Print(("[BigWigs Instance #%d] Base64 decode failed."):format(index or 0))
        return nil
    end

    local decomp_ok, decompressed = pcall(C_EncodingUtil.DecompressString, decoded, 0)
    if not decomp_ok or not decompressed then
        self:Print(("[BigWigs Instance #%d] Decompression failed."):format(index or 0))
        return nil
    end

    local deser_ok, data = pcall(C_EncodingUtil.DeserializeCBOR, decompressed)
    if not deser_ok or type(data) ~= "table" then
        self:Print(("[BigWigs Instance #%d] CBOR deserialization failed."):format(index or 0))
        return nil
    end

    if data.version ~= "BWIS1" then
        self:Print(("[BigWigs Instance #%d] Unknown version: %s"):format(index or 0, tostring(data.version)))
        return nil
    end

    return data
end

-- Apply decoded BWIS1 data (matches BigWigs InstanceSharing.lua logic exactly)
function addon:ApplyBigWigsInstanceData(data, index)
    if not data or not data.exportData then return false end

    -- Load the zone so boss modules become available
    if data.zone and BigWigsLoader and BigWigsLoader.LoadZone then
        BigWigsLoader:LoadZone(data.zone)
    end

    local includeFlags = data.includeFlags
    local includeSounds = data.includeSounds
    local includeColors = data.includeColors
    local includePrivateAuras = data.includePrivateAuras

    local importCount = 0
    for moduleName, moduleData in next, data.exportData do
        -- moduleName is the full name e.g. "BigWigs_Bosses_BossName"
        -- GetBossModule needs the short name (strip 15-char prefix)
        local shortName = moduleName:sub(16)

        -- Flags: replicate BigWigs ImportFlags()
        if includeFlags ~= false then
            local bossModule = BigWigs:GetBossModule(shortName)
            if bossModule then
                if bossModule.SetupOptions then bossModule:SetupOptions() end
                if bossModule.db and bossModule.db.profile then
                    local flagSettings = moduleData.flags
                    for key, value in pairs(bossModule.db.profile) do
                        if flagSettings and flagSettings[key] then
                            bossModule.db.profile[key] = flagSettings[key]
                        else
                            bossModule.db.profile[key] = nil
                        end
                    end
                end
            end
        end

        -- Sounds: replicate BigWigs ImportSounds()
        -- BigWigs structure: sDB[soundSettingName][moduleName] = value (full name)
        if includeSounds ~= false then
            local soundModule = BigWigs:GetPlugin("Sounds", true)
            if soundModule then
                local sDB = soundModule.db.profile
                local soundSettings = moduleData.sounds
                for soundSettingName, _ in pairs(sDB) do
                    if soundSettingName ~= "privateaura" then
                        if soundSettings and soundSettings[soundSettingName] then
                            sDB[soundSettingName][moduleName] = RaslUI_CopyTable(soundSettings[soundSettingName])
                        else
                            sDB[soundSettingName][moduleName] = nil
                        end
                    end
                end
            end
        end

        -- Private Auras: replicate BigWigs ImportPrivateAuras()
        if includePrivateAuras ~= false then
            local privateAuraSounds = moduleData.sounds and moduleData.sounds.privateaura
            if privateAuraSounds then
                local soundModule = BigWigs:GetPlugin("Sounds", true)
                if soundModule then
                    local sDB = soundModule.db.profile["privateaura"]
                    if sDB then
                        sDB[moduleName] = RaslUI_CopyTable(privateAuraSounds)
                    end
                end
            end
        end

        -- Colors: replicate BigWigs ImportColors()
        -- BigWigs structure: cDB[colorSettingName][moduleName][k] = value (full name)
        if includeColors ~= false then
            local colorModule = BigWigs:GetPlugin("Colors", true)
            if colorModule then
                local cDB = colorModule.db.profile
                local colorSettings = moduleData.colors
                for colorSettingName in next, cDB do
                    if type(cDB[colorSettingName]) == "table" and cDB[colorSettingName][moduleName] then
                        for k in next, cDB[colorSettingName][moduleName] do
                            if colorSettings and colorSettings[colorSettingName] and colorSettings[colorSettingName][k] then
                                cDB[colorSettingName][moduleName][k] = RaslUI_CopyTable(colorSettings[colorSettingName][k])
                            else
                                cDB[colorSettingName][moduleName][k] = nil
                            end
                        end
                    end
                end
            end
        end

        importCount = importCount + 1
    end

    BigWigs:SendMessage("BigWigs_ProfileUpdate")

    -- Re-register private aura sounds if needed
    if includePrivateAuras ~= false then
        for modName in next, data.exportData do
            local bossModule = BigWigs:GetBossModule(modName:sub(16))
            if bossModule and bossModule.RegisterPrivateAuraSounds then
                bossModule:RegisterPrivateAuraSounds()
            end
        end
    end

    local zoneName = "unknown"
    if data.zone then
        if data.zone < 0 then
            local info = C_Map.GetMapInfo(-data.zone)
            if info then zoneName = info.name end
        else
            zoneName = GetRealZoneText(data.zone) or tostring(data.zone)
        end
    end
    self:Print(("[BigWigs Instance #%d] Imported %d module(s) for %s."):format(
        index or 0, importCount, zoneName))
    return true
end

-- Auto-import all instance profiles immediately
function addon:QueueBigWigsInstances()
    local instanceData = self.profiles[self.resolution]["BigWigsInstances"]
    if not instanceData or #instanceData == 0 then return end

    for i, str in ipairs(instanceData) do
        local data = self:DecodeBigWigsInstance(str, i)
        if data then
            self:ApplyBigWigsInstanceData(data, i)
        end
    end
end

------------------------------------------------------
-- Import AddOn Profiles
------------------------------------------------------
function addon:Import(addonName, data)
    if addonName == "Plater" then
        if not self:Loaded("Plater") then
            self:Print("[Plater] AddOn not loaded, aborting profile import.")
            return false
        else
            self:Print("[Plater] Importing profile.")
            Plater.ImportAndSwitchProfile("RaslUI - " .. self.resolution, self.profiles[self.resolution][addonName],
                false, false, false, true)
            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
            self:RefreshProfileStatus(addonName)
            if DetailsFrameworkPromptSimple then
                DetailsFrameworkPromptSimple:Hide()
            end
            return true
        end
    elseif addonName == "ElvUI" then
        if not self:Loaded("ElvUI") then
            self:Print("[ElvUI] AddOn not loaded, aborting profile import.")
            return false
        else
            self:Print("[ElvUI] Processing ElvUI import...")

            local elvData = self.profiles[self.resolution][addonName]

            if type(elvData) ~= "table" then
                self:Print("[ElvUI] Error: Profile data must be a table (profile, global, private).")
                return false
            end

            local E, L, V, P, G = unpack(ElvUI)
            local D = E:GetModule("Distributor")
            local targetProfileName = "RaslUI - " .. self.resolution

            if elvData.global and elvData.global ~= "" then
                self:Print("[ElvUI] Importing Global Settings...")
                D:ImportProfile(elvData.global)
            end

            if elvData.filters and elvData.filters ~= "" then
                self:Print("[ElvUI] Importing Filters...")
                D:ImportProfile(elvData.filters)
            end

            if elvData.private and elvData.private ~= "" then
                self:Print("[ElvUI] Importing Private Settings...")
                D:ImportProfile(elvData.private)
            end

            if elvData.profile and elvData.profile ~= "" then
                self:Print("[ElvUI] Creating & Applying Main Profile...")
                local profileType, profileKey, profileData = D:Decode(elvData.profile)
                if profileType == 'profile' then
                    D:SetImportedProfile(profileType, targetProfileName, profileData)
                    E.data:SetProfile(targetProfileName)
                    E:StaggeredUpdateAll()
                end
            end

            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
            self:RefreshProfileStatus(addonName)

            -- Pass scale to ElvUI based on chosen resolution
            local scaleValue
            if self.resolution == "1080p" then
                scaleValue = 0.711111
            elseif self.resolution == "1440p" then
                scaleValue = 0.533333
            end
            if scaleValue then
                E.global.general.UIScale = scaleValue
                E:PixelScaleChanged()
            end

            if ElvUI_StaticPopup3 then
                ElvUI_StaticPopup3:Hide()
            end
            return true
        end
    elseif addonName == "DandersFrames" then
        if not self:Loaded("DandersFrames") then
            self:Print("[Danders Frames] AddOn not loaded, aborting profile import.")
            return false
        else
            self:Print("[Danders Frames] Importing profile.")
            local profileName = "RaslUI - " .. self.resolution
            local importString = self.profiles[self.resolution][addonName]
            DandersFrames_Import(importString, profileName)
            if DandersFramesDB_v2 then
                DandersFramesDB_v2.currentProfile = profileName
            end
            if not DandersFramesCharDB then
                DandersFramesCharDB = {}
            end
            DandersFramesCharDB.currentProfile = profileName
            self:Print("[Danders Frames] Profile '" .. profileName .. "' activated.")
            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
            self:RefreshProfileStatus(addonName)
            return true
        end
    elseif addonName == "Details" then
        if not self:Loaded("Details") then
            self:Print("[Details] AddOn not loaded, aborting profile import.")
            return false
        else
            self:Print("[Details] Importing profile.")
            local profileName = "RaslUI - " .. self.resolution
            local importString = self.profiles[self.resolution][addonName]

            local currentProfile = Details:GetCurrentProfileName()
            local profileList = Details:GetProfileList()

            local profileExists = false
            for _, name in ipairs(profileList) do
                if name == profileName then
                    profileExists = true
                    break
                end
            end

            if profileExists then
                if currentProfile == profileName then
                    Details:ApplyProfile("Default")
                end
                Details:EraseProfile(profileName)
                self:Print("[Details] Old profile '" .. profileName .. "' removed.")
            end

            Details:ImportProfile(importString, profileName, false, false, true)
            Details:ApplyProfile(profileName)
            self:Print("[Details] Profile '" .. profileName .. "' imported and applied.")
            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
            self:RefreshProfileStatus(addonName)
            return true
        end
    elseif addonName == "BigWigs" then
        if not self:Loaded("BigWigs") then
            self:Print("[BigWigs] AddOn not loaded, aborting profile import.")
            return false
        else
            self:Print("[BigWigs] Importing profile.")
            BigWigsAPI.RegisterProfile("RaslUI", self.profiles[self.resolution][addonName],
                "RaslUI - " .. self.resolution)

            -- Queue instance imports with delay (main profile shows its own confirmation first)
            C_Timer.After(1.0, function()
                self:QueueBigWigsInstances()
            end)

            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
            self:RefreshProfileStatus(addonName)
            return true
        end
    elseif addonName == "UnhaltedUnitFrames" then
        if not self:Loaded("UnhaltedUnitFrames") then
            self:Print("[Unhalted Unit Frames] AddOn not loaded, aborting profile import.")
            return false
        else
            self:Print("[Unhalted Unit Frames] Importing profile.")
            UUFG:ImportUUF(self.profiles[self.resolution][addonName], "RaslUI - " .. self.resolution)
            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
            self:RefreshProfileStatus(addonName)
            return true
        end
    elseif addonName == "ElvUIHeal" then
        if not self:Loaded("ElvUI") then
            self:Print("[ElvUI Healer] AddOn not loaded, aborting profile import.")
            return false
        else
            self:Print("[ElvUI Healer] Processing ElvUI Healer import...")

            local elvData = self.profiles[self.resolution]["ElvUIHeal"]

            if type(elvData) ~= "table" then
                self:Print("[ElvUI Healer] Error: Profile data must be a table (profile, global, private).")
                return false
            end

            local E, L, V, P, G = unpack(ElvUI)
            local D = E:GetModule("Distributor")
            local targetProfileName = "RaslUI Healer - " .. self.resolution

            if elvData.global and elvData.global ~= "" then
                self:Print("[ElvUI Healer] Importing Global Settings...")
                D:ImportProfile(elvData.global)
            end

            if elvData.filters and elvData.filters ~= "" then
                self:Print("[ElvUI Healer] Importing Filters...")
                D:ImportProfile(elvData.filters)
            end

            if elvData.private and elvData.private ~= "" then
                self:Print("[ElvUI Healer] Importing Private Settings...")
                D:ImportProfile(elvData.private)
            end

            if elvData.profile and elvData.profile ~= "" then
                self:Print("[ElvUI Healer] Creating & Applying Healer Profile...")
                local profileType, profileKey, profileData = D:Decode(elvData.profile)
                if profileType == 'profile' then
                    D:SetImportedProfile(profileType, targetProfileName, profileData)
                    E.data:SetProfile(targetProfileName)
                    E:StaggeredUpdateAll()
                end
            end

            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions["ElvUIHeal"] = self.profileVersions["ElvUIHeal"]
            self:RefreshProfileStatus("ElvUIHeal")

            -- Pass scale to ElvUI based on chosen resolution
            local scaleValue
            if self.resolution == "1080p" then
                scaleValue = 0.711111
            elseif self.resolution == "1440p" then
                scaleValue = 0.533333
            end
            if scaleValue then
                E.global.general.UIScale = scaleValue
                E:PixelScaleChanged()
            end

            if ElvUI_StaticPopup3 then
                ElvUI_StaticPopup3:Hide()
            end
            return true
        end
    elseif addonName == "ActionBarsEnhanced" then
        if not self:Loaded("ActionBarsEnhanced") then
            self:Print("[ActionBars Enhanced] AddOn not loaded, aborting profile import.")
            return false
        else
            self:Print("[ActionBars Enhanced] Importing profile.")
            ABE_ImportProfile("RaslUI - " .. self.resolution, self.profiles[self.resolution][addonName], true, true)
            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
            self:RefreshProfileStatus(addonName)

            if StaticPopup2 then
                StaticPopup2:Hide()
            end

            return true
        end
    elseif addonName == "AyijeCDM" then
        if not self:Loaded("Ayije_CDM") then
            self:Print("[Ayije CDM] AddOn not loaded, aborting profile import.")
            return false
        end

        self:Print("[Ayije CDM] Importing profile.")

        local AyijeCDM = _G["Ayije_CDM"]
        if not AyijeCDM or not AyijeCDM.API then
            self:Print("[Ayije CDM] Error: Cannot access addon API.")
            return false
        end

        local API = AyijeCDM.API
        local importString = self.profiles[self.resolution][addonName]

        if not importString or importString == "" then
            self:Print("[Ayije CDM] Error: Profile string is empty!")
            return false
        end

        local version = self.profileVersions[addonName] or "1.0"
        local profileName = "RaslUI - " .. self.resolution

        -- Delete only the profile matching the EXACT target name (same resolution)
        if Ayije_CDMDB and Ayije_CDMDB.profiles then
            if Ayije_CDMDB.profiles[profileName] then
                local currentProfile = API:GetActiveProfileName()
                if currentProfile == profileName then
                    API:SetProfile("Default")
                end
                Ayije_CDMDB.profiles[profileName] = nil
                self:Print("[Ayije CDM] Profile '" .. profileName .. "' already exists, replacing.")
            end
        end

                if not C_AddOns.IsAddOnLoaded("Ayije_CDM_Options") then
            local loaded, reason = C_AddOns.LoadAddOn("Ayije_CDM_Options")
            if not loaded then
                self:Print("[Ayije CDM] Error loading options module: " .. tostring(reason))
                return false
            end
        end
        local success, message = API:ImportProfile(importString)

        if success then
            self:Print("[Ayije CDM] " .. message)

            -- Find and rename the imported profile to our target name
            local profileList = API:GetProfileList()
            for _, name in ipairs(profileList) do
                if name == profileName then
                    API:SetProfile(profileName)
                    break
                elseif name:find("^RaslUI") and name ~= profileName then
                    -- This is a freshly imported profile with a different name (e.g. "RaslUI - 1080p (1)")
                    -- Only rename if it's NOT another resolution's profile that already existed
                    local isOtherResolution = false
                    for _, res in ipairs({"1080p", "1440p"}) do
                        if res ~= self.resolution and name == "RaslUI - " .. res then
                            isOtherResolution = true
                            break
                        end
                    end

                    if not isOtherResolution then
                        API:SetProfile(name)
                        local renameOk = API:RenameProfile(profileName)
                        if renameOk then
                            self:Print("[Ayije CDM] Renamed to: " .. profileName)
                        end
                        break
                    end
                end
            end

            self:Print("[Ayije CDM] Switched to profile: " .. profileName)

            -- Close Ayije CDM config window
            local configFrame = AyijeCDM._OptionsNS.ConfigFrame
            if configFrame and configFrame:IsShown() then
                configFrame:Hide()
            end

            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
            self:RefreshProfileStatus(addonName)
            return true
        else
            self:Print("[Ayije CDM] Import failed: " .. tostring(message))
            return false
        end
    elseif addonName == "NaowhQOL" then
        if not self:Loaded("NaowhQOL") then
            self:Print("[Naowh QOL] AddOn not loaded, aborting profile import.")
            return false
        end

        self:Print("[Naowh QOL] Importing profile.")

        local importString = self.profiles[self.resolution][addonName]

        if not importString or importString == "" then
            self:Print("[Naowh QOL] Error: Profile string is empty!")
            return false
        end

        if not NaowhQOL_API then
            self:Print("[Naowh QOL] Error: NaowhQOL_API is not available.")
            return false
        end

        local profileName = "RaslUI - " .. self.resolution

        local ok, err = NaowhQOL_API.Import(importString, nil, profileName)

        if ok then
            NaowhQOL_API:SetProfile(profileName)
            self:Print("[Naowh QOL] Profile '" .. profileName .. "' imported and activated.")
            NaowhQOL_API:CloseConfig()

            RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
            RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
            self:RefreshProfileStatus(addonName)
            return true
        else
            self:Print("[Naowh QOL] Import failed: " .. tostring(err))
            return false
        end
    elseif addonName == "EditMode" then
        self:Print("[Edit Mode] Importing profile.")

        local layoutName = "RaslUI - " .. self.resolution
        local layoutInfo = C_EditMode.ConvertStringToLayoutInfo(self.profiles[self.resolution][addonName])

        if not layoutInfo then
            self:Print("[Edit Mode] Failed to parse layout string.")
            return false
        end

        local layouts = C_EditMode.GetLayouts()
        local accountLayouts = layouts and layouts.layouts or {}

        for i = #accountLayouts, 1, -1 do
            if accountLayouts[i].layoutName == layoutName then
                self:Print("[Edit Mode] Layout '" .. layoutName .. "' already exists, replacing.")
                table.remove(accountLayouts, i)
                break
            end
        end

        local MAX_LAYOUTS = 5
        if #accountLayouts >= MAX_LAYOUTS then
            local L = self.locale.editMode
            self:Print("|cffff0000" .. string.format(L.maxLayouts, #accountLayouts, MAX_LAYOUTS) .. "|r")
            return false
        end

        layoutInfo.layoutName = layoutName
        layoutInfo.layoutType = Enum.EditModeLayoutType.Account
        table.insert(accountLayouts, layoutInfo)

        C_EditMode.SaveLayouts(layouts)
        EditModeManagerFrame:UpdateLayoutInfo(C_EditMode.GetLayouts())

        local newIndex = Enum.EditModePresetLayoutsMeta.NumValues + #accountLayouts
        EditModeManagerFrame:SelectLayout(newIndex)

        RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
        RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
        self:RefreshProfileStatus(addonName)
        self:UpdateNavHighlight()
        if self.currentPage == 3 and self.nextBtn then
            self.nextBtn:Enable()
            self.nextBtn:GetNormalTexture():SetDesaturated(false)
        end
        return true
    elseif addonName == "CooldownManager" then
        self:Print("[Cooldown Manager] Importing profile - " .. data.spec .. " " .. data.class .. ".")
        local layoutManager = CooldownViewerSettings and CooldownViewerSettings:GetLayoutManager()
        if not layoutManager then
            self:Print("[Cooldown Manager] Error: LayoutManager not found.")
            return false
        end

        local layoutIDs = layoutManager:CreateLayoutsFromSerializedData(data.profile)

        if layoutIDs and layoutIDs[1] then
            local layout = layoutManager:GetLayout(layoutIDs[1])

            if layout then
                local importedLayout, status = layoutManager:ImportLayout("RaslUI - " .. data.spec, layout)

                if status == Enum.CooldownLayoutStatus.Success then
                    self:Print("[Cooldown Manager] Profile imported successfully.")
                    if importedLayout then
                        local importedLayoutID = CooldownManagerLayout_GetID(importedLayout)
                        layoutManager:SetActiveLayoutByID(importedLayoutID)
                    end
                else
                    self:Print("[Cooldown Manager] Import failed with status: " .. tostring(status))
                end

                layoutManager:RemoveLayout(layoutIDs[1])
                if not data.skipSave then
                    layoutManager:SaveLayouts()
                end
            end
        else
            self:Print("[Cooldown Manager] Invalid import string.")
        end

        RaslUIDB.importedVersions = RaslUIDB.importedVersions or {}
        RaslUIDB.importedVersions[addonName] = self.profileVersions[addonName]
        self:RefreshProfileStatus(addonName)
    end
end

function addon:ImportCDMClass(specs, className)
    for _, data in ipairs(specs) do
        if data.profile and data.profile ~= "" then
            self:Import("CooldownManager", {
                class = data.class,
                spec = data.spec,
                profile = data.profile,
                skipSave = true
            })
        end
    end

    local layoutManager = CooldownViewerSettings and CooldownViewerSettings:GetLayoutManager()
    if layoutManager then
        layoutManager:SaveLayouts()
    end

    print("|cff00ff00Spells positions for " .. className .. " added|r")
end