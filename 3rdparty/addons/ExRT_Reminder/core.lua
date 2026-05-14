--[[
project-revision 			1755
project-hash 				33324bd4e649d834ecf0dae69c165fa44def9c65
project-abbreviated-hash 	33324bd
project-author 				m33shoq
project-date-iso 			2026-04-23T15:13:49Z
project-date-integer 		20260423151349
project-timestamp 			1776957229
project-version 			v83
]]

local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

local MRT = GMRT

---@type ELib
local ELib = MRT.lib

-----------------------------------------------------------
-- Upvalues
-----------------------------------------------------------
local format = format
local next = next
local tInsertUnique = tInsertUnique
local tonumber = tonumber
local xpcall = xpcall


local function noop() end
RGLOG = noop
rglog = noop
RGlog = noop
rgLog = noop
if not ddt then ddt = noop end
if not DDT then DDT = noop end
if not ddtD then ddtD = noop end
if not DDTD then DDTD = noop end
AddonDB.noop = noop

-----------------------------------------------------------
-- MRT modules wrapper
-----------------------------------------------------------

local AddonModules = {}

---@param moduleName string
---@param localizedName string?
---@param disableOptions boolean?
---@return MRTmodule|false
function AddonDB:New(moduleName, localizedName, disableOptions)
	local module = MRT:New(moduleName, localizedName, disableOptions)
	if module then
		AddonModules[module] = true
	end
	return module
end

if MRT.A.WAChecker then
	AddonModules[MRT.A.WAChecker] = true -- workaround for ADDON_LOADED in WASync
end

local MRTdev = CreateFrame("Frame")
MRTdev:RegisterEvent("ADDON_LOADED")
MRTdev:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonName = ...
		if addonName ~= GlobalAddonName then
			return
		end

		for module in next, AddonModules do
			if not module.IsLoaded then
				module.main:ADDON_LOADED()
				module.IsLoaded = true

				--for old versions
				if MRT.ModulesLoaded then
					for i = #MRT.Modules, 1, -1 do
						if MRT.Modules[i] == module then
							MRT.ModulesLoaded[i] = true
							break
						end
					end
				end
			end
		end
		self:UnregisterEvent("ADDON_LOADED")
	end
end)

-----------------------------------------------------------
-- Rename and switch modules order
-----------------------------------------------------------

function AddonDB:RenameModule(module, newName)
	if not module or not newName then
		return
	end

	local localizedName = module.options.name
	module.options.name = newName

	for i, lName in next, MRT.Options.Frame.modulesList.L do
		if lName == localizedName then
			MRT.Options.Frame.modulesList.L[i] = newName
		end
	end
end

function AddonDB:SwitchModulesOrder(module1, module2)
	if not module1 or not module2 then
		return
	end
	-- Minimap icon order
	local index1 = nil
	local index2 = nil

	for i, opts in next, MRT.ModulesOptions do
		if opts == module1.options then
			index1 = i
		elseif opts == module2.options then
			index2 = i
		end
	end

	if index1 and index2 then
		MRT.ModulesOptions[index1], MRT.ModulesOptions[index2] = MRT.ModulesOptions[index2], MRT.ModulesOptions[index1]
	end

	-- Change order of frames in Options
	index1 = nil
	index2 = nil
	for i, opts in next, MRT.Options.Frame.Frames do
		if opts == module1.options then
			index1 = i
		elseif opts == module2.options then
			index2 = i
		end
	end

	if index1 and index2 then
		MRT.Options.Frame.Frames[index1], MRT.Options.Frame.Frames[index2] = MRT.Options.Frame.Frames[index2], MRT.Options.Frame.Frames[index1]
	end

	-- Change order of frames in Options.modulesList.L
	index1 = nil
	index2 = nil
	for i, localizedName in next, MRT.Options.Frame.modulesList.L do
		if localizedName == module1.options.name then
			index1 = i
		elseif localizedName == module2.options.name then
			index2 = i
		end
	end

	if index1 and index2 then
		MRT.Options.Frame.modulesList.L[index1], MRT.Options.Frame.modulesList.L[index2] = MRT.Options.Frame.modulesList.L[index2], MRT.Options.Frame.modulesList.L[index1]
	end

	-- Change order of modules in MRT.Modules and MRT.ModulesLoaded
	index1 = nil
	index2 = nil
	for i, module in next, MRT.Modules do
		if module == module1 then
			index1 = i
		elseif module == module2 then
			index2 = i
		end
	end

	if index1 and index2 then
		MRT.Modules[index1], MRT.Modules[index2] = MRT.Modules[index2], MRT.Modules[index1]
		MRT.ModulesLoaded[index1], MRT.ModulesLoaded[index2] = MRT.ModulesLoaded[index2], MRT.ModulesLoaded[index1]
	end
end

-----------------------------------------------------------
-- Callbacks
-----------------------------------------------------------

do
	local callbacks = {}

	function AddonDB:RegisterCallback(name, func)
		if type(func) ~= "function" then
			error(GlobalAddonName..": RegisterCallback: func is not a function", 2)
		end
		if not callbacks[name] then
			callbacks[name] = {}
		end
		tInsertUnique(callbacks[name], func)
	end

	function AddonDB:UnregisterCallback(name, func)
		if not callbacks[name] then
			return
		end
		for i = #callbacks[name], 1, -1 do
			if callbacks[name][i] == func then
				tremove(callbacks[name], i)
				break
			end
		end
	end

	function AddonDB:FireCallback(name, ...)
		if not callbacks[name] then
			return
		end
		for i, func in ipairs(callbacks[name]) do
			if func then
				xpcall(func, geterrorhandler(), ...)
			end
		end
	end
end

-----------------------------------------------------------
-- Global proxy
-----------------------------------------------------------

local privateFields = {
	RGAPI = true,
	Archivist = true,
	WASYNC = true,
}

_G.GREMINDER = setmetatable({}, {
	__index = function(t, k)
		if privateFields[k] then
			return nil
		end
		return AddonDB[k]
	end,
	__newindex = function() end,
	__metatable = false
})

-----------------------------------------------------------
-- Constants
-----------------------------------------------------------

AddonDB.defaultFont = GameFontNormal:GetFont()

AddonDB.VersionHash = "33324bd"
if AddonDB.VersionHash:find("@") then
	AddonDB.VersionHash = "DEV"
	AddonDB.IsDev = true
end

AddonDB.PUBLIC = C_AddOns.GetAddOnMetadata(GlobalAddonName, "X-Release") == "Public"
AddonDB.Version = tonumber(C_AddOns.GetAddOnMetadata(GlobalAddonName, "Version") or "0")
AddonDB.VersionString = "v"..AddonDB.Version .. "-" .. (AddonDB.PUBLIC and "public" or "private")..  "(".. AddonDB.VersionHash .. ") |cff0080ffDiscord for feedback and bug reports: mishoq|r"
AddonDB.VersionStringShort = "v"..AddonDB.Version .. "-" .. (AddonDB.PUBLIC and "public" or "private")..  "(".. AddonDB.VersionHash .. ")"
-- This one is used for the version check in public releases
AddonDB.VersionMajor = tonumber(C_AddOns.GetAddOnMetadata(GlobalAddonName, "X-VersionMajor") or "0")

AddonDB.externalLinks = {
	{
		name = "Discord",
		tooltip = "Download updates, provide feedback,\nreport bugs and request features",
		url = "https://discord.gg/dmqVFvU4qv",
	},
}

AddonDB.MY_REALM = GetRealmName():gsub("[%s%-]","")

-----------------------------------------------------------
-- Useful string matching patterns
-----------------------------------------------------------

AddonDB.STRING_PATTERNS = {}
AddonDB.STRING_PATTERNS.SEP = " ,\n\r:;%{%}%(%)%+%[%]\"%@%!%$%_%#%&"
AddonDB.STRING_PATTERNS.PAT_SEP = "[" .. AddonDB.STRING_PATTERNS.SEP .. "]"
AddonDB.STRING_PATTERNS.PAT_SEP_INVERSE = "[^" .. AddonDB.STRING_PATTERNS.SEP .. "]+"
AddonDB.STRING_PATTERNS.PAT_SEP_CAPTURE = "(" .. AddonDB.STRING_PATTERNS.PAT_SEP .. ")"

-----------------------------------------------------------
-- Slash commands
-----------------------------------------------------------

SLASH_ReminderSlash1 = "/rem"
SLASH_ReminderSlash2 = "/reminder"
SLASH_ReminderSlash3 = "/куь" -- /rem but in russian

SlashCmdList["ReminderSlash"] = function(msg)
	MRT.Options:Open()
	MRT.Options:OpenByModuleName("Reminder")
end

SLASH_WASYNC1 = "/was"
SLASH_WASYNC2 = "/wasync"
SLASH_WASYNC3 = "/цфы" -- /was but in russian

SlashCmdList["WASYNC"] = function(msg)
	MRT.Options:Open()
	MRT.Options:OpenByModuleName("WAChecker")
end

-----------------------------------------------------------
-- Private images API
-----------------------------------------------------------

local rg_logo = "Interface\\Addons\\" .. GlobalAddonName .. "\\Media\\Textures\\rg_logo_white.png"
local path = "Interface\\Addons\\" .. GlobalAddonName .. "\\Media\\Private\\Textures\\%s"
local formatImage = function(fileName, suggestedScale)
	local filePath = format(path, fileName)
	return {
		name = fileName:match("(.+)%.png") or fileName,
		filePath,
		suggestedScale or 1,
	}
end
local privateImages = {
	formatImage("badito5.png"),
	formatImage("badito7.png"),
	formatImage("badito12.png"),
	formatImage("Nercho_pes.png"),
	formatImage("Selfless.png"),
	formatImage("Zmei_mario.png"),
	formatImage("zmey3.png"),
	formatImage("darkless.png"),
	formatImage("mishok.png"),
	formatImage("nimb_mishoq.png"),
	formatImage("UAZb.png", 1.5),
	formatImage("feyta.png"),
	formatImage("feyta2.png"),
	formatImage("badito14.png"),
	formatImage("kroyfell.png"),
	formatImage("murchal.png"),
	formatImage("pauel.png"),
	formatImage("anti_kit.png"),
	formatImage("kroyfel.png"),
	formatImage("HesusPringles.png"),
	formatImage("HesusPringles2.png", 1.8),
	formatImage("HesusPVP.png", 1.8),
	formatImage("HesusTransmog.png"),
	formatImage("Stepan1.png", 1.5),
	formatImage("Stepan2.png"),
	formatImage("Zmey4.png"),
	formatImage("rakgamingtop20.png", 1.5),
	formatImage("broo_dog_lnvll.png"),
	formatImage("selfless_devi.png", 1.5),
	formatImage("nimbseed.png"),
	formatImage("Devi.png", 1.8),
	formatImage("Stepan_glaive.png"),
}
AddonDB.TotalImages = #privateImages

local bxor = bit.bxor
local rshift = bit.rshift
local lshift = bit.lshift

local function hash32(x)
    x = bxor(x, 61)
    x = bxor(x, rshift(x, 16))
    x = (x + lshift(x, 3)) % 4294967296
    x = bxor(x, rshift(x, 4))
    x = (x * 0x27d4eb2d) % 4294967296
    x = bxor(x, rshift(x, 15))
    return x % 4294967296
end

local function syncedRandom(min, max, salt)
    local seed = floor(GetServerTime() / 600)

    if salt then
        seed = (seed + salt) % 4294967296
    end

    local value = hash32(seed)

    if min and max then
        return min + (value % (max - min + 1))
    end

    return value / 4294967296
end
function AddonDB:GetImage(num, depth)
	depth = (depth or 0) + 1

	local allBlacklisted = false
	if depth == 1 and RGDB and RGDB.ImagesBlacklist then
		allBlacklisted = true
		for _, image in ipairs(privateImages) do
			if not RGDB.ImagesBlacklist[image] then
				allBlacklisted = false
				break
			end
		end
	end

	if AddonDB.PUBLIC or allBlacklisted or depth > 500 then
		return rg_logo, 1
	elseif num then
		local image = privateImages[num]
		local imageTexture = image[1]
		if not imageTexture or RGDB and RGDB.ImagesBlacklist and RGDB.ImagesBlacklist[imageTexture] then
			return AddonDB:GetImage(nil, depth)
		end
		return unpack(image)
	else
		local image = privateImages[syncedRandom(1, #privateImages)]
		local imageTexture = image[1]
		if not imageTexture or RGDB and RGDB.ImagesBlacklist and RGDB.ImagesBlacklist[imageTexture] then
			return AddonDB:GetImage(nil, depth)
		end
		return unpack(image)
	end
end

if not AddonDB.PUBLIC then
	local imgFrame
	SLASH_RGIMAGES1 = "/rgimg"
	SlashCmdList["RGIMAGES"] = function(msg)
		if not imgFrame then
			imgFrame = ELib:Popup("RG Images"):Size(220,50)
			imgFrame.DropDown = ELib:DropDown(imgFrame, 200, 10):Size(200):Point("BOTTOM", imgFrame, "BOTTOM", 0, 5):SetText("Settings")
			local function SetValue(self, img)
				RGDB.ImagesBlacklist = RGDB.ImagesBlacklist or {}
				RGDB.ImagesBlacklist[img] = not RGDB.ImagesBlacklist[img] or nil
				imgFrame.DropDown.List[self.id].colorCode = RGDB.ImagesBlacklist and RGDB.ImagesBlacklist[img] and "|cffff0000" or "|cff00ff00"
				ELib.ScrollDropDown:Reload()
			end
			local function hoverFunc(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 15, 0)
				GameTooltip:SetText(format("|T%s:%d:%d|t", self.data.arg1, 200 * (self.data.arg2 or 1), 200 * (self.data.arg2 or 1)))
				GameTooltip:Show()
			end
			function imgFrame.DropDown:PreUpdate()
				for i, imgData in ipairs(privateImages) do
					local img, scale = unpack(imgData)
					if not self.List[i] then
						self.List[i] = {
							text = format("%s (%s)", imgData.name, i),
							arg1 = img,
							arg2 = scale,
							func = SetValue,
							colorCode = RGDB.ImagesBlacklist and RGDB.ImagesBlacklist[img] and "|cffff0000" or "|cff00ff00",
							hoverFunc = hoverFunc,
						}
					else
						self.List[i].colorCode = RGDB.ImagesBlacklist and RGDB.ImagesBlacklist[img] and "|cffff0000" or "|cff00ff00"
					end
				end
			end
		end
		imgFrame:Show()
	end
end


-----------------------------------------------------------
-- Loading events handler
-----------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonName = ...
		if addonName == GlobalAddonName then
			self:UnregisterEvent("ADDON_LOADED")

			ReminderArchive = ReminderArchive or {}
			WASyncArchiveDB = WASyncArchiveDB or {}

			AddonDB:FireCallback("EXRT_REMINDER_ADDON_LOADED")
			AddonDB:FireCallback("EXRT_REMINDER_POST_ADDON_LOADED")
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		local isInitialLogin, isReloadingUi = ...
		if isInitialLogin or isReloadingUi then
			AddonDB:FireCallback("EXRT_REMINDER_PLAYER_ENTERING_WORLD")
		end
	elseif event == "PLAYER_LOGIN" then
		AddonDB:FireCallback("EXRT_REMINDER_PLAYER_LOGIN")
	end
end)

-----------------------------------------------------------
-- Game Version Constants
-----------------------------------------------------------

AddonDB.isRetail = false
do
	local version, buildVersion, buildDate, uiVersion = GetBuildInfo()

	AddonDB.clientBuildVersion = buildVersion
	AddonDB.clientUIinterface = uiVersion
	local expansion,majorPatch,minorPatch = (version or "5.0.0"):match("^(%d+)%.(%d+)%.(%d+)")
	AddonDB.clientVersion = (expansion or 0) * 10000 + (majorPatch or 0) * 100 + (minorPatch or 0)
end
if AddonDB.clientVersion < 20000 then
	AddonDB.isClassic = true
elseif AddonDB.clientVersion < 30000 then
	AddonDB.isClassic = true
	AddonDB.isBC = true
elseif AddonDB.clientVersion < 40000 then
	AddonDB.isClassic = true
	AddonDB.isBC = true
	AddonDB.isLK = true
elseif AddonDB.clientVersion < 50000 then
	AddonDB.isClassic = true
	AddonDB.isBC = true
	AddonDB.isLK = true
	AddonDB.isCata = true
elseif AddonDB.clientVersion < 60000 then
	AddonDB.isClassic = true
	AddonDB.isBC = true
	AddonDB.isLK = true
	AddonDB.isCata = true
	AddonDB.isMoP = true
elseif AddonDB.clientVersion < 70000 then
	AddonDB.isClassic = true
	AddonDB.isBC = true
	AddonDB.isLK = true
	AddonDB.isCata = true
	AddonDB.isMoP = true
	AddonDB.isWoD = true
elseif AddonDB.clientVersion < 120000 then
	AddonDB.isRetail = true
	AddonDB.is11 = true
elseif AddonDB.clientVersion >= 120000 then
	AddonDB.isRetail = true
	AddonDB.is12 = true
end

AddonDB.WeakAuras = M33kAuras or WeakAuras
AddonDB.WeakAurasSaved = M33kAurasSaved or WeakAurasSaved
if AddonDB.WeakAuras == M33kAuras then
	AddonDB.WeakAurasName = "M33kAuras"
	AddonDB.WeakAurasNameLower = "m33kauras"
else
	AddonDB.WeakAurasName = "WeakAuras"
	AddonDB.WeakAurasNameLower = "weakauras"
end
