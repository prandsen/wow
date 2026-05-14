local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

local MRT = GMRT

local Ambiguate = Ambiguate
local GetNumGroupMembers = GetNumGroupMembers
local GetNumSubgroupMembers = GetNumSubgroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local GetServerTime = GetServerTime
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local strsplit = strsplit
local strsub = strsub
local tonumber = tonumber
local sort = sort
local tinsert = tinsert
local next = next
local tostring = tostring
local type = type
local UnitClassBase = UnitClassBase
local UnitExists = UnitExists
local UnitFullName = UnitFullName
local UnitGUID = UnitGUID
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName
local bit_band = bit.band
local bit_rshift = bit.rshift
local bit_lshift = bit.lshift
local string_char = string.char
local table_concat = table.concat
local IsEncounterInProgress = C_InstanceEncounter and C_InstanceEncounter.IsEncounterInProgress or _G.IsEncounterInProgress

local myGUID = UnitGUID("player")

function AddonDB:UnitGUID(unit)
	if UnitExists(unit) then
		return UnitGUID(unit)
	end
end

-----------------------------------------------------------
-- Compability
-----------------------------------------------------------

---@return string name
---@return fileID iconID
---@return fileID originalIconID
---@return number castTime
---@return number minRange
---@return number maxRange
---@return number spellID
AddonDB.GetSpellInfo = C_Spell and C_Spell.GetSpellInfo and function(spellID)
	if not spellID then
		return nil, nil, nil, nil, nil, nil, nil
	end
	local sp = C_Spell.GetSpellInfo(spellID)
	if sp then
		return sp.name, nil, sp.iconID, sp.castTime, sp.minRange, sp.maxRange, sp.spellID, sp.originalIconID
	end
end or _G["GetSpellInfo"]
AddonDB.GetSpellName = C_Spell and C_Spell.GetSpellName or _G["GetSpellInfo"]
AddonDB.GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or _G["GetSpellTexture"]
---@return number startTime
---@return number duration
---@return boolean isEnabled
---@return number modRate
AddonDB.GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown and function(spellID)
	if not spellID then
		return nil, nil, nil, nil
	end
	local cd = C_Spell.GetSpellCooldown(spellID)
	if cd then
		return cd.startTime, cd.duration, cd.isEnabled, cd.modRate
	end
end or GetSpellCooldown


AddonDB.GetSpecialization = C_SpecializationInfo and C_SpecializationInfo.GetSpecialization or GetSpecialization or MRT.NULLfunc
AddonDB.GetSpecializationInfo = C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo or GetSpecializationInfo or MRT.NULLfunc

local issecretvalue = issecretvalue or AddonDB.noop

-----------------------------------------------------------
-- GUID to Unit mapping
-----------------------------------------------------------
do
	local GUIDToUnit = {}
	local needUpdate = true
	local globalGUIDToUnit = setmetatable({}, {
		__index = function(_, k)
			if not needUpdate and GUIDToUnit[k] then
				return GUIDToUnit[k]
			else
				if needUpdate then
					needUpdate = false
					wipe(GUIDToUnit)
				end
				for unit in AddonDB:IterateGroupMembers() do
					local GUID = AddonDB:UnitGUID(unit)
					if GUID and not issecretvalue(GUID) then
						GUIDToUnit[GUID] = unit
					end
				end
			end

			return GUIDToUnit[k]
		end,
		__newindex = function() end
	})

	RG_GUIDToUnit = globalGUIDToUnit
	MT_GUIDToUnit = globalGUIDToUnit
	AddonDB.GUIDToUnit = globalGUIDToUnit

	local f = CreateFrame("Frame")
	f:RegisterEvent("GROUP_ROSTER_UPDATE")

	f:SetScript("OnEvent", function(self, event)
		if event == "GROUP_ROSTER_UPDATE" then
			if IsEncounterInProgress() then
				f:RegisterEvent("ENCOUNTER_END")
			else
				needUpdate = true
				AddonDB:FireCallback("GUID_TO_UNIT_UPDATED")
			end
		elseif event == "ENCOUNTER_END" then
			needUpdate = true
			AddonDB:FireCallback("GUID_TO_UNIT_UPDATED")
			f:UnregisterEvent("ENCOUNTER_END")
		end
	end)
end

-----------------------------------------------------------
-- Utility functions
-----------------------------------------------------------

function AddonDB:UnitIsUnitSafe(unit1, unit2)
	local r = UnitIsUnit(unit1, unit2)
	if issecretvalue(r) then
		return false
	end
	return r
end

function AddonDB:ClassColorName(unit, useFullName)
	if unit and UnitExists(unit) then
		local name
		if useFullName then
			name = AddonDB:GetFullName(unit)
		else
			name = UnitName(unit)
		end
		local class = UnitClassBase(unit)
		if not class then
		  	return name
		else
			local classData = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
			local coloredName = ("|c%s%s|r"):format(classData.colorStr, name)
			return coloredName
		end
	else
		return "" -- ¯\_(ツ)_/¯
	end
end

---@param GUID string
---@param classColor boolean
---@return string? name # unit name, if classColor is true, returns class colored unit name
function AddonDB:NameFromGUID(GUID, classColor)
	local unit = AddonDB.GUIDToUnit[GUID]
	if unit then
		if classColor then
			return AddonDB:ClassColorName(unit)
		else
			return UnitNameUnmodified(unit)
		end
	end
end

function AddonDB:GetUnitGroup(unit)
	local raidIndex = UnitInRaid(unit)
	if raidIndex then
		local name, rank, subgroup = GetRaidRosterInfo(raidIndex)
		return subgroup
	end
   	return 1
end

function AddonDB:IterateGroupMembers(maxGroup, reversed, forceParty)
	local unit = (not forceParty and IsInRaid()) and 'raid' or 'party'
	local numGroupMembers = unit == 'party' and GetNumSubgroupMembers() or GetNumGroupMembers()
	local i = reversed and numGroupMembers or (unit == 'party' and 0 or 1)

	local f
	f = function()
		local ret
		if i == 0 and unit == 'party' then
			ret = 'player'
		elseif i <= numGroupMembers and i > 0 then
			ret = unit .. i
		end
		i = i + (reversed and -1 or 1)

		if ret and maxGroup and AddonDB:GetUnitGroup(ret) > maxGroup then
			return f()
		end

		return ret
	end
	return f
end

function AddonDB:CreatureInfo(GUID)
	if UnitExists(GUID) then -- If a unit ID was passed instead of GUID, convert it
		GUID = AddonDB:UnitGUID(GUID)
	end
	if not GUID or issecretvalue(GUID) then
		return nil
	end

	local unitType, _, _, _, _, npcID, spawnUID = strsplit("-", GUID)

	if unitType == "Creature" or unitType == "Vehicle" then
		local spawnEpoch = GetServerTime() - (GetServerTime() % 2 ^ 23)
		local spawnEpochOffset = bit_band(tonumber(strsub(spawnUID, 5), 16), 0x7fffff)
		local spawnIndex = bit_rshift(bit_band(tonumber(strsub(spawnUID, 1, 5), 16), 0xffff8), 3)
		local spawnTime = spawnEpoch + spawnEpochOffset

		if spawnTime > GetServerTime() then
			-- This only occurs if the epoch has rolled over since a unit has spawned.
			spawnTime = spawnTime - ((2 ^ 23) - 1)
		end

		return tonumber(npcID), spawnTime, spawnIndex
	end
end

if C_TooltipInfo and C_TooltipInfo.GetHyperlink then
	function AddonDB:NpcNameFromGUID(GUID)
		local tooltipInfo = C_TooltipInfo.GetHyperlink("unit:"..GUID)
		local name = tooltipInfo and tooltipInfo.lines and tooltipInfo.lines[1] and tooltipInfo.lines[1].leftText
		if name and name ~= "" then
			return name
		end
	end
else
	local cache_tooltip = CreateFrame("GameTooltip", "ExRT_Reminder_CacheTooltip", _G.UIParent, "GameTooltipTemplate")
	cache_tooltip:SetOwner(_G.WorldFrame, "ANCHOR_NONE")

	function AddonDB:NpcNameFromGUID(GUID)
		cache_tooltip:ClearLines()
		cache_tooltip:SetHyperlink("unit:"..GUID)
		local text = _G["ExRT_Reminder_CacheTooltipTextLeft1"]:GetText()
		if text and text ~= "" then
			return text
		end
	end
end

do
	local sortF = function(GUID1, GUID2) -- either guid or unit
		local _, spawnTime1, spawnIndex1 = AddonDB:CreatureInfo(GUID1)
		local _, spawnTime2, spawnIndex2 = AddonDB:CreatureInfo(GUID2)

		return (spawnTime1 * 1000 + spawnIndex1) < (spawnTime2 * 1000 + spawnIndex2)
	end

	function AddonDB:SortBySpawnIndex(arr)
		sort(arr, sortF)
	end
end

---@param unit string
---@return boolean isRLorOfficer
function AddonDB:IsRLorOfficer(unit)
	unit = Ambiguate(unit, "none")
	if UnitIsGroupLeader(unit) then
		return 2
	elseif UnitIsGroupAssistant(unit) then
		return 1
	end
end


---@param isDebugMode any
---@return boolean isPass
---@return string? reason
function AddonDB:CheckSelfPermissions(isDebugMode)
	if isDebugMode then
		return true, nil
	elseif not IsInGroup() and not IsInRaid() then
		return false, ERR_NOT_IN_GROUP
	elseif AddonDB.RGAPI and AddonDB.RGAPI:IsCustomSender("player") then
		return true, nil
	elseif IsInRaid() and not AddonDB:IsRLorOfficer("player") then
		return false, AddonDB.LR["You are not Raid Leader or Raid Assistant"]
	else
		return true, nil
	end
end

---@param sender string
---@param isDebugMode any
---@param ignoreSelfCheck boolean? # if true, allow self-sending
---@return boolean isPass
---@return string? reason
function AddonDB:CheckSenderPermissions(sender, isDebugMode, ignoreSelfCheck)
	local sender_short = Ambiguate(sender, "none")
	if not ignoreSelfCheck and UnitIsUnit('player', sender_short) then -- self sending
		return isDebugMode, nil -- ignore error msg here
	elseif not UnitInRaid(sender_short) and not UnitInParty(sender_short) then -- sender not in current raid/party
		return false, nil -- ignore error msg here
	elseif AddonDB.RGAPI and AddonDB.RGAPI:IsCustomSender(sender) then
		return true, nil
	elseif IsInRaid() and not AddonDB:IsRLorOfficer(sender) then
		return false, AddonDB.LR["Not Raid Leader or Raid Assistant"]
	else
		return true, nil
	end
end

---@param unit string
---@return string fullName # name-realm, the same format as used in combat log and addon comms
function AddonDB:GetFullName(unit, unitIsName)
	local name, realm = UnitFullName(unit)
	if not name then
		name, realm = UnitFullName(Ambiguate(unit, "none"))
	end
	if not realm or realm == "" then
		realm = AddonDB.MY_REALM
	end
	if not name then
		return unitIsName and unit or nil
	end
	return name .. "-" .. realm
end

do
	local function __genOrderedIndex(t)
		local orderedIndex = {}
		for key in next, t do
			if key ~= "__orderedIndex" then
				tinsert(orderedIndex, key)
			end
		end
		sort(orderedIndex, function(a, b)
			local typeA, typeB = type(a), type(b)
			if typeA ~= typeB then
				return typeA < typeB
			else
				return a < b
			end
		end)
		return orderedIndex
	end

	local function orderedNext(t, state)
		-- Equivalent of the next function, but returns the keys in the alphabetic
		-- order. We use a temporary ordered key table that is stored in the
		-- table being iterated.
		local key = nil
		if state == nil then
			-- the first time, generate the index
			t.__orderedIndex = __genOrderedIndex(t)
			key = t.__orderedIndex[1]
		else
			-- fetch the next value
			for i = 1, table.getn(t.__orderedIndex) do
				if t.__orderedIndex[i] == state then
					key = t.__orderedIndex[i + 1]
				end
			end
		end

		if key then
			return key, t[key]
		end

		-- no more value to return, cleanup
		t.__orderedIndex = nil
	end

	function AddonDB.orderedPairs(t)
		return orderedNext, t, nil
	end
end


function AddonDB:SendChatMessage(msg, chatType, languageID, target)
	if C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown() then return end
	return C_ChatInfo.SendChatMessage(msg, chatType, languageID, target)
end

-----------------------------------------------------------
-- Encoding and Decoding wrappers
-----------------------------------------------------------

do
	local LibDeflateAsync = LibStub("LibDeflateAsync-reminder")
	local LibSerializeAsync = LibStub("LibSerializeAsync-reminder")

	local configForLS = { errorOnUnserializableType = false }
	local configForDeflate = { level = 9 }
	---@param table table
	---@param forPrint boolean
	---@return string
	function AddonDB:CompressTable(table, forPrint)
		if not table then
			return nil
		end

		local serialized = LibSerializeAsync:SerializeEx(configForLS, table)
		local compressed = C_EncodingUtil and C_EncodingUtil.CompressString(serialized, Enum.CompressionMethod.Deflate, Enum.CompressionLevel.Default) or LibDeflateAsync:CompressDeflate(serialized, configForDeflate)
		local encoded
		if (forPrint) then
			encoded = LibDeflateAsync:EncodeForPrint(compressed)
		else
			encoded = LibDeflateAsync:EncodeForWoWAddonChannel(compressed)
		end
		return encoded
	end

	---@param encoded string
	---@param forPrint boolean?
	---@return table|string
	function AddonDB:DecompressTable(encoded, forPrint)
		local decoded
		if (forPrint) then
			decoded = LibDeflateAsync:DecodeForPrint(encoded)
		else
			decoded = LibDeflateAsync:DecodeForWoWAddonChannel(encoded)
		end

		if not decoded then
			return nil, "Error decoding"
		end

		local decompressed
		if C_EncodingUtil then
			local success, res = pcall(C_EncodingUtil.DecompressString, decoded, Enum.CompressionMethod.Deflate)
			if not success then
				return nil, res
			else
				decompressed = res
			end
		else
			decompressed = LibDeflateAsync:DecompressDeflate(decoded)
		end

		if not decompressed then
			return nil, "Error decompressing"
		end

		local success, deserialized = LibSerializeAsync:Deserialize(decompressed)
		if not success then
			return nil, "Error deserializing"
		end
		return deserialized
	end

	function AddonDB:CompressString(str, forPrint)
		if not str then
			return nil
		end

		local compressed = C_EncodingUtil and C_EncodingUtil.CompressString(str) or LibDeflateAsync:CompressDeflate(str, configForDeflate)
		local encoded
		if (forPrint) then
			encoded = LibDeflateAsync:EncodeForPrint(compressed)
		else
			encoded = LibDeflateAsync:EncodeForWoWAddonChannel(compressed)
		end
		return encoded
	end

	function AddonDB:DecompressString(encoded, forPrint)
		local decoded
		if (forPrint) then
			decoded = LibDeflateAsync:DecodeForPrint(encoded)
		else
			decoded = LibDeflateAsync:DecodeForWoWAddonChannel(encoded)
		end

		if not decoded then
			return nil, "Error decoding."
		end

		local decompressed
		if C_EncodingUtil then
			local success, res = pcall(C_EncodingUtil.DecompressString, decoded)
			if not success then
				return nil, res
			else
				decompressed = res
			end
		else
			decompressed = LibDeflateAsync:DecompressDeflate(decoded)
		end

		if not decompressed then
			return nil, "Error decompressing"
		end

		return decompressed
	end

	local cborConfig = {
		ignoreSerializationErrors = true,
	}
	-- incompatible with standart `AddonDB:CompressTable()`<br>
	-- b64 is for printable output<br>
	-- still not using CBOR because it inflates output size a lot
	function AddonDB:CompressTableNative(table, b64)
		local serialized = LibSerializeAsync:SerializeEx(cborConfig, table)

		local compressed = C_EncodingUtil.CompressString(serialized, Enum.CompressionMethod.Deflate, Enum.CompressionLevel.OptimizeForSize)

		local encoded
		if b64 then
			encoded = C_EncodingUtil.EncodeBase64(compressed)
		else
			encoded = LibDeflateAsync:EncodeForWoWAddonChannel(compressed)
		end
		return encoded
	end

	function AddonDB:DecompressTableNative(encoded, b64)
		local decoded
		if b64 then
			local ok, res = pcall(C_EncodingUtil.DecodeBase64, encoded)
			if not ok then
				return nil, res
			end
			decoded = res
		else
			decoded = LibDeflateAsync:DecodeForWoWAddonChannel(encoded)
		end

		if not decoded then
			return nil, "Error decoding"
		end

		local ok, decompressed = pcall(C_EncodingUtil.DecompressString, decoded, Enum.CompressionMethod.Deflate)

		if not ok then
			return nil, decompressed
		end

		if not decompressed then
			return nil, "Error decompressing"
		end

		local success, deserialized = LibSerializeAsync:Deserialize(decompressed)
		if not success then
			return nil, "Error deserializing"
		end
		return deserialized
	end
end

-----------------------------------------------------------
-- Mark flags metatable
-----------------------------------------------------------
do

	local COMBATLOG_OBJECT_RAIDTARGET_MASK = COMBATLOG_OBJECT_RAIDTARGET_MASK or 255
	local markToIndex = {
		[0] = 0,
		[0x1] = 1,
		[0x2] = 2,
		[0x4] = 3,
		[0x8] = 4,
		[0x10] = 5,
		[0x20] = 6,
		[0x40] = 7,
		[0x80] = 8,
	}

	AddonDB.markToIndex = setmetatable({}, {
		__index = function(_, key)
			if type(key) == "number" then
				return markToIndex[ bit_band(key, COMBATLOG_OBJECT_RAIDTARGET_MASK or 255) ]
			else
				return nil
			end
		end,
	})
end

-----------------------------------------------------------
-- Import and Export windows
-----------------------------------------------------------

do
	local importFrame, exportFrame
	local function createImportFrame()
		local MLib = AddonDB.MLib

		local function onFinish(thread)
			-- thread == thread or nil == nil
			if importFrame.awaitedThread == thread then
				importFrame.spinner:Stop()
				importFrame:Hide()
			end
		end
		local function ImportOnUpdate(self, elapsed)
			self.tmr = self.tmr + elapsed
			if self.tmr >= 0.1 then
				self.tmr = 0
				self:SetScript("OnUpdate", nil)
				local str = table.concat(self.buff):trim()

				self:SetMaxBytes(1000)
				self:SetText(str:sub(1, 1000)) -- show start of the text for convenience
				self.parent.Edit:ToTop()

				self.buff = {}
				self.buffPos = 0

				if self.parent.ImportFunc then
					local res = self.parent.ImportFunc(str) -- if importFunc is async thread we show spinner while data is processed
					if AddonDB:IsThread(res) then
						self.parent.awaitedThread = res
						self.parent.spinner:Start()
						res:Finally(onFinish)
					else
						onFinish()
					end
				else
					onFinish()
				end
			end
		end

		local importWindow = MLib:Popup(AddonDB.LR["Import"]):Size(650, 100)
		importWindow.Edit = MLib:MultiEdit(importWindow):Point("TOP", 0, -20):Size(640, 75)
		importWindow:SetScript("OnHide", function(self)
			self.Edit:SetText("")
			self.spinner:Stop()
			self.awaitedThread = nil
			self.Edit.EditBox:SetMaxBytes(1)
		end)
		importWindow:SetScript("OnShow", function(self)
			self.Edit.EditBox.buffPos = 0
			self.Edit.EditBox.tmr = 0
			self.Edit.EditBox.buff = {}
			self.Edit.EditBox:SetFocus()
			self:NewPoint("CENTER", UIParent, "CENTER", 0, 0)
		end)
		importWindow.Edit.EditBox:SetMaxBytes(1)
		importWindow.Edit.EditBox:SetScript("OnChar", function(self, c)
			self.buffPos = self.buffPos + 1
			self.buff[self.buffPos] = c
			self:SetScript("OnUpdate", ImportOnUpdate)
		end)
		importWindow.Edit.EditBox.parent = importWindow
		importWindow:SetFrameStrata("FULLSCREEN_DIALOG")
		importWindow.spinner = MLib:LoadingSpinner(importWindow):Point("CENTER", 0, 0):Size(60, 60)

		return importWindow
	end

	---@param title string?
	---@param onPasteFunc fun(str: string): AsyncThreadData?
	function AddonDB:QuickPaste(title, onPasteFunc)
		assert(type(onPasteFunc) == "function", GlobalAddonName ..": onPasteFunc must be a function, got ".. type(onPasteFunc))
		if not importFrame then
			importFrame = createImportFrame()
		end
		importFrame:Hide() -- trigger OnHide script in case it was shown before

		importFrame.title:SetText(title or AddonDB.LR["Import"])
		importFrame.ImportFunc = onPasteFunc
		importFrame:Show()
	end

	local function createExportFrame()
		local ELib = MRT.lib
		local MLib = AddonDB.MLib

		local exportWindow = MLib:Popup(AddonDB.LR["Export"]):Size(650, 50)
		exportWindow.Edit = ELib:Edit(exportWindow):Point("TOP", 0, -20):Size(640, 25)
		function exportWindow:Update(noText)
			if not noText then
				if self.Edit.fixedText then
					if self.Edit:GetText() ~= self.Edit.fixedText then
						self.Edit:SetText(self.Edit.fixedText)
					end
				else
					self.Edit:SetText("")
				end
			end
			self.Edit:HighlightText()
			self.Edit:SetCursorPosition(0)
		end
		exportWindow:SetScript("OnHide", function(self)
			self.Edit:SetText("")
			self.Edit.fixedText = nil
			self.spinner:Stop()
			if self.awaitedThread then
				self.awaitedThread:Kill()
				self.awaitedThread = nil
			end
		end)
		exportWindow.Edit:SetScript("OnEditFocusGained", function(self)
			exportWindow:Update()
		end)
		exportWindow.Edit:SetScript("OnMouseUp", function(self, button)
			if button == "RightButton" then
				exportWindow:Hide()
			else
				exportWindow:Update()
			end
		end)
		exportWindow.Edit:SetScript("OnKeyUp", function(self, c)
			if (c == "c" or c == "C") and IsControlKeyDown() and not exportWindow.awaitedThread then
				exportWindow:Hide()
			end
		end)
		exportWindow.Edit:OnChange(function(self, isUser)
			if isUser then
				exportWindow:Update()
			else
				exportWindow:Update(true) -- update without text to avoid recursion
			end
		end)
		exportWindow.Edit:SetScript("OnEscapePressed", function(self)
			exportWindow:Hide()
		end)
		function exportWindow:OnShow()
			self.tmr = 0
			self.Edit:SetFocus()

			self:NewPoint("CENTER", UIParent, "CENTER", 0, 0)
		end
		exportWindow:SetFrameStrata("FULLSCREEN_DIALOG")
		exportWindow.spinner = MLib:LoadingSpinner(exportWindow):Point("CENTER", 0, -10):Size(60, 60)

		return exportWindow
	end

	local function onTextReady(text)
		if type(text) ~= "string" then
			error(GlobalAddonName ..": text must be a string, got ".. type(text))
		end

		exportFrame.Edit.fixedText = text
		exportFrame.spinner:Stop()
		exportFrame.awaitedThread = nil

		exportFrame:Update()
	end
	local function onError(err)
		exportFrame:Hide()
		exportFrame.awaitedThread = nil
	end

	---@param text string|AsyncThreadData
	---@param title string?
	function AddonDB:QuickCopy(text, title)
		if type(text) == "number" then
			text = tostring(text)
		end
		assert(type(text) == "string" or AddonDB:IsThread(text), GlobalAddonName ..": text must be a string or AsyncThreadData, got ".. type(text))
		if not exportFrame then
			exportFrame = createExportFrame()
		end
		exportFrame:Hide() -- trigger OnHide script in case it was shown before

		exportFrame.title:SetText(title or AddonDB.LR["Export"])


		if AddonDB:IsThread(text) then
			exportFrame.awaitedThread = text
			exportFrame.spinner:Start()
			text:OnSuccess(onTextReady):Catch(onError)
		else
			onTextReady(text)
		end

		exportFrame:Show()
	end
end

-----------------------------------------------------------
-- Note parsing(Unused atm)
-----------------------------------------------------------

do
	-- todo: XXX
	-- note caching
	-- support fetching positions in note
	-- support (p1 p2) as players on the same position
	-- support `-` at the start to reverse logic,
	-- write a documentation and then implement everything

	local prevNote = nil
	local cacheSinglePrivate = {} -- <[identifier] = lines>
	local cacheSingle = setmetatable({},
		{
			__index = function(t, k)
				local note = (VMRT and VMRT.Note and VMRT.Note.Text1) or ""
				if note ~= prevNote then
					prevNote = note
					cacheSinglePrivate = {}
				end
				return cacheSinglePrivate[k]
			end,
			__newindex = function(t, k, v)
				cacheSinglePrivate[k] = v
			end
		}
	)
	local cacheBlockPrivate = {} -- <[identifier] = lines>
	local cacheBlock = setmetatable({},
		{
			__index = function(t, k)
				local note = (VMRT and VMRT.Note and VMRT.Note.Text1) or ""
				if note ~= prevNote then
					prevNote = note
					cacheBlockPrivate = {}
				end
				return cacheBlockPrivate[k]
			end,
			__newindex = function(t, k, v)
				cacheBlockPrivate[k] = v
			end
		}
	)


	local function search(p)
		return string.find("", p)
	end

	local function validateSearchPattern(pattern)
		local ok, err = pcall(search, pattern)
		return ok
	end

	-- iterate single lines in note by pattern
	function AddonDB:IterateNoteSingle(pattern, noteOverride)
		pattern = "^" .. pattern:lower()

		local isPatternValid, error = validateSearchPattern(pattern)
		if not isPatternValid then
			geterrorhandler()(GlobalAddonName ..": Invalid pattern: ".. tostring(pattern) .. ". Error: ".. tostring(error))
			return AddonDB.noop
		end

		local note = noteOverride or (VMRT and VMRT.Note and VMRT.Note.Text1)
		local lineCount = 1
		local lines = {}

		local cachedLines = not noteOverride and cacheSingle[pattern] -- check cache if there is no override
		if cachedLines then
			lines = cachedLines
		end

		if note and not cachedLines then
			for line in note:gmatch("[^\r\n]+") do
				if line:find(pattern) then
					tinsert(lines, line)
				end
			end
		end

		if not noteOverride then -- set cache
			cacheSingle[pattern] = lines
		end

		return function()
			local line = lines[lineCount]

			if line then
				lineCount = lineCount + 1

				return lineCount - 1, line
			end
		end
	end


	-- iterate block of lines in note by pattern
	function AddonDB:IterateNoteBlock(pattern, noteOverride)
		local startLine = pattern:lower() .. "start"
		local endLine = pattern:lower() .. "end"

		local note = noteOverride or (VMRT and VMRT.Note and VMRT.Note.Text1)
		local lineCount = 1
		local lines = {}

		local cachedLines = not noteOverride and cacheBlock[pattern] -- check cache if there is no override
		if cachedLines then
			lines = cachedLines
		end


		if note and not cachedLines then
			note = note:gsub("\n","\n ") -- to properly account for empty lines in a block
			local betweenLine = false

			for line in note:gmatch("[^\r\n]+") do
				if line:trim():lower() == endLine then
					betweenLine = false
				end

				if betweenLine then
					tinsert(lines, line)
				end

				if line:trim():lower() == startLine then
					betweenLine = true
				end
			end
		end

		if not noteOverride then -- set cache
			cacheBlock[pattern] = lines
		end

		return function()
			local line = lines[lineCount]

			if line then
				lineCount = lineCount + 1

				return lineCount - 1, line
			end
		end
	end

	-- Returns an array of GUIDs (sorted) of all units in a certain raid subgroup
	local function groupToGUIDArray(groupNumber)
		local GUIDs = {}

		for raidIndex = 1, 40 do
			local _, _, subgroup = GetRaidRosterInfo(raidIndex)

			if subgroup == groupNumber then
				local unit = "raid" .. raidIndex
				local GUID = AddonDB:UnitGUID(unit)

				if GUID then
					tinsert(GUIDs, GUID)
				end
			end
		end

		sort(GUIDs)

		return GUIDs
	end

	local nameToGUID = nil
	AddonDB:RegisterCallback("GUID_TO_UNIT_UPDATED", function()
		nameToGUID = nil
	end)

	-- Transforms a string of (nick)names to a sorted array of GUIDs
	-- Optionally allow for players to be present in the array multiple times
	-- Returns whether the player's GUID is included
	function AddonDB:LineToGUIDArray(line, fillUnfound, allowDuplicates)
		local guidArray = {}

		if not nameToGUID then
			nameToGUID = {}
			for unit in AddonDB:IterateGroupMembers() do
				local GUID = AddonDB:UnitGUID(unit)
				local name = UnitName(unit)
				local nickname = AddonDB.RGAPI and AddonDB.RGAPI:GetNick(unit)

				if name then
					nameToGUID[name:lower()] = GUID
				end

				if nickname then
					nameToGUID[nickname:lower()] = GUID
				end
			end
		end

		line = line:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r",""):gsub(" *$",""):gsub("|",""):gsub(" +"," "):lower()

		for word in line:gmatch("%S+") do
			local subgroup = word:match("^group(%d)$")

			-- If the word is group<number>, add all GUIDs in that subgroup
			-- If not, treat it as a player name
			if subgroup then
				subgroup = tonumber(subgroup)

				local GUIDs = groupToGUIDArray(subgroup)

				for _, GUID in ipairs(GUIDs) do
					if allowDuplicates then
						table.insert(guidArray, GUID)
					else
						tInsertUnique(guidArray, GUID)
					end
				end
			else
				local GUID = nameToGUID[word]

				if GUID then
					if allowDuplicates then
						table.insert(guidArray, GUID)
					else
						tInsertUnique(guidArray, GUID)
					end
				elseif fillUnfound then
					table.insert(guidArray, "NONE")
				end
			end
		end

		return guidArray, tContains(guidArray, myGUID)
	end
end


--- Utility from WeakAuras

local bytetoB64 = {
	[0]="a","b","c","d","e","f","g","h",
	"i","j","k","l","m","n","o","p",
	"q","r","s","t","u","v","w","x",
	"y","z","A","B","C","D","E","F",
	"G","H","I","J","K","L","M","N",
	"O","P","Q","R","S","T","U","V",
	"W","X","Y","Z","0","1","2","3",
	"4","5","6","7","8","9","(",")"
}

local B64tobyte = {
	a =  0,  b =  1,  c =  2,  d =  3,  e =  4,  f =  5,  g =  6,  h =  7,
	i =  8,  j =  9,  k = 10,  l = 11,  m = 12,  n = 13,  o = 14,  p = 15,
	q = 16,  r = 17,  s = 18,  t = 19,  u = 20,  v = 21,  w = 22,  x = 23,
	y = 24,  z = 25,  A = 26,  B = 27,  C = 28,  D = 29,  E = 30,  F = 31,
	G = 32,  H = 33,  I = 34,  J = 35,  K = 36,  L = 37,  M = 38,  N = 39,
	O = 40,  P = 41,  Q = 42,  R = 43,  S = 44,  T = 45,  U = 46,  V = 47,
	W = 48,  X = 49,  Y = 50,  Z = 51,["0"]=52,["1"]=53,["2"]=54,["3"]=55,
	["4"]=56,["5"]=57,["6"]=58,["7"]=59,["8"]=60,["9"]=61,["("]=62,[")"]=63
}

-- This code is based on the Encode7Bit algorithm from LibCompress
-- Credit goes to Galmok (galmok@gmail.com)
local decodeB64Table = {}

function AddonDB:DecodeB64(str)
	local bit8 = decodeB64Table;
	local decoded_size = 0;
	local ch;
	local i = 1;
	local bitfield_len = 0;
	local bitfield = 0;
	local l = #str;
	while true do
		if bitfield_len >= 8 then
			decoded_size = decoded_size + 1;
			bit8[decoded_size] = string_char(bit_band(bitfield, 255));
			bitfield = bit_rshift(bitfield, 8);
			bitfield_len = bitfield_len - 8;
		end
		ch = B64tobyte[str:sub(i, i)];
		bitfield = bitfield + bit_lshift(ch or 0, bitfield_len);
		bitfield_len = bitfield_len + 6;
		if i > l then
			break;
		end
		i = i + 1;
	end
	return table_concat(bit8, "", 1, decoded_size)
end


function AddonDB:GenerateUniqueID()
	-- generates a unique random 11 digit number in base64
	local s = {}
	for i=1,11 do
		tinsert(s, bytetoB64[random(0, 63)])
	end
	return table_concat(s)
end
