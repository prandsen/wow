local GlobalAddonName = ...
---@class AddonDB
local AddonDB = select(2, ...)
local MRT = GMRT

---@class WAChecker: MRTmodule
local module = MRT.A.WAChecker
if not module then return end
if not AddonDB.WeakAuras then return end

---@class Locale
local LR = AddonDB.LR

---@class MLib
local MLib = AddonDB.MLib

---@class WASyncPrivate
local WASync = AddonDB.WASYNC

local L = AddonDB.WeakAuras.L

-- upvalues
local tinsert = tinsert
local tremove = tremove
local unpack = unpack
local next = next
local CopyTable = CopyTable
local ipairs = ipairs
local coroutine_yield = coroutine.yield
local coroutine_wrap = coroutine.wrap
local type = type
local tonumber = tonumber

local Serializer = LibStub:GetLibrary("AceSerializer-3.0")
local Compresser = LibStub:GetLibrary("LibCompress")
local LibDeflateAsync = LibStub:GetLibrary("LibDeflateAsync-reminder")
local LibSerializeAsync = LibStub:GetLibrary("LibSerializeAsync-reminder")

--------------------------------------------------------------------------------------------------------------------------------
-- A bunch of code from WeakAuras
--------------------------------------------------------------------------------------------------------------------------------
local prettyPrint = module.prettyPrint

local function shouldInclude(data, includeGroups, includeLeafs)
	if data.controlledChildren then
		return includeGroups
	else
		return includeLeafs
	end
end

local function Traverse(data, includeSelf, includeGroups, includeLeafs)
	if includeSelf and shouldInclude(data, includeGroups, includeLeafs) then
		coroutine_yield(data)
	end

	if data.controlledChildren then
		for _, child in ipairs(data.controlledChildren) do
			Traverse(AddonDB.WeakAuras.GetData(child), true, includeGroups, includeLeafs)
		end
	end
end

local function TraverseLeafs(data)
	return Traverse(data, false, false, true)
end

local function TraverseLeafsOrAura(data)
	return Traverse(data, true, false, true)
end

local function TraverseGroups(data)
	return Traverse(data, true, true, false)
end

local function TraverseSubGroups(data)
	return Traverse(data, false, true, false)
end

local function TraverseAllChildren(data)
	return Traverse(data, false, true, true)
end

local function TraverseAll(data)
	return Traverse(data, true, true, true)
end

local function TraverseParents(data)
	while data.parent do
		local parentData = AddonDB.WeakAuras.GetData(data.parent)
		coroutine_yield(parentData)
		data = parentData
	end
end

-- Only non-group auras, not include self
local function pTraverseLeafs(data)
	return coroutine_wrap(TraverseLeafs), data
end

-- The root if it is a non-group, otherwise non-group children
local function pTraverseLeafsOrAura(data)
	return coroutine_wrap(TraverseLeafsOrAura), data
end

-- All groups, includes self
local function pTraverseGroups(data)
	return coroutine_wrap(TraverseGroups), data
end

-- All groups, excludes self
local function pTraverseSubGroups(data)
	return coroutine_wrap(TraverseSubGroups), data
end

-- All Children, excludes self
local function pTraverseAllChildren(data)
	return coroutine_wrap(TraverseAllChildren), data
end

-- All Children and self
local function pTraverseAll(data)
	return coroutine_wrap(TraverseAll), data
end

local function pTraverseParents(data)
	return coroutine_wrap(TraverseParents), data
end
module.pTraverseAllChildren = pTraverseAllChildren
module.pTraverseSubGroups = pTraverseSubGroups
module.pTraverseGroups = pTraverseGroups
module.pTraverseLeafs = pTraverseLeafs
module.pTraverseLeafsOrAura = pTraverseLeafsOrAura
module.pTraverseAll = pTraverseAll
module.pTraverseParents = pTraverseParents


function module.ValidateUniqueDataIds(silent)
	-- ensure that there are no duplicated uids anywhere in the database

	local seenUIDs = {}
	local db = AddonDB.WeakAurasSaved
	for _, data in next, db.displays do
		if type(data.uid) == "string" then
			if seenUIDs[data.uid] then
				if not silent then
					prettyPrint("Duplicate uid \""..data.uid.."\" detected in saved variables between \""..data.id.."\" and \""..seenUIDs[data.uid].id.."\".")
				end
				data.uid = AddonDB.WeakAuras.GenerateUniqueID()
				seenUIDs[data.uid] = data
				else
				seenUIDs[data.uid] = data
			end
		elseif data.uid ~= nil then
			if not silent then
				prettyPrint("Invalid uid detected in saved variables for \""..data.id.."\"")
			end
			data.uid = AddonDB.WeakAuras.GenerateUniqueID()
			seenUIDs[data.uid] = data
		end
	end
end

function module.SyncParentChildRelationships(silent)
	-- 1. Find all auras where data.parent ~= nil or data.controlledChildren ~= nil
	--    If an aura has data.parent which doesn't exist, then remove data.parent
	--    If an aura has data.parent which doesn't have data.controlledChildren, then remove data.parent
	-- 2. For each aura with data.controlledChildren, iterate through the list of children and remove entries where:
	--    The child doesn't exist in the database
	--    The child ID is duplicated in data.controlledChildren (only the first will be kept)
	--    The child's data.parent points to a different parent
	--    The parent is a dynamic group and the child is a group/dynamic group
	--    Otherwise, mark the child as having a valid parent relationship
	-- 3. For each aura with data.parent, remove data.parent if it was not marked to have a valid relationship in 2.

	local db = AddonDB.WeakAurasSaved

	local parents = {}
	local children = {}
	local childHasParent = {}

	for ID, data in next, db.displays do
		local id = data.id or ID
		if data.parent then
			if not db.displays[data.parent] then
				if not(silent) then
					prettyPrint("Detected corruption in saved variables: "..id.." has a nonexistent parent.")
				end
				data.parent = nil
			elseif not db.displays[data.parent].controlledChildren then
				if not silent then
					prettyPrint("Detected corruption in saved variables: "..id.." thinks "..data.parent..
					" controls it, but "..data.parent.." is not a group.")
				end
			data.parent = nil
			else
				children[id] = data
			end
		end
		if data.controlledChildren then
			parents[id] = data
		end
	end

	for id, data in next, parents do
		local groupChildren = {}
		local childrenToRemove = {}
		local dynamicGroup = data.regionType == "dynamicgroup"
		for index, childID in ipairs(data.controlledChildren) do
			local child = children[childID]
			if not child then
				if not silent then
					prettyPrint("Detected corruption in saved variables: "..id.." thinks it controls "..childID.." which doesn't exist.")
				end
				childrenToRemove[index] = true
			elseif child.parent ~= id then
				if not silent then
					prettyPrint("Detected corruption in saved variables: "..id.." thinks it controls "..childID.." which it does not.")
				end
				childrenToRemove[index] = true
			elseif dynamicGroup and child.controlledChildren then
				if not silent then
					prettyPrint("Detected corruption in saved variables: "..id.." is a dynamic group and controls "..childID.." which is a group/dynamicgroup.")
				end
				child.parent = nil
				children[child.id] = nil
				childrenToRemove[index] = true
			elseif groupChildren[childID] then
				if not silent then
					prettyPrint("Detected corruption in saved variables: "..id.." has "..childID.." as a child in multiple positions.")
				end
				childrenToRemove[index] = true
			else
				groupChildren[childID] = index
				childHasParent[childID] = true
			end
		end
		if next(childrenToRemove) ~= nil then
			for i = #data.controlledChildren, 1, -1 do
				if childrenToRemove[i] then
					tremove(data.controlledChildren, i)
				end
			end
		end
	end

	for id, data in next, children do
		if not childHasParent[id] then
			if not silent then
				prettyPrint("Detected corruption in saved variables: "..id.." should be controlled by "..data.parent.." but isn't.")
			end
			local parent = parents[data.parent]
			tinsert(parent.controlledChildren, id)
		end
	end
end


--A ton of code from WeakAuras\Transmission.lua

local function ShowTooltip(lines)
	ItemRefTooltip:Show();
	if not ItemRefTooltip:IsVisible() then
		ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
	end
	ItemRefTooltip:ClearLines();
	for i, line in ipairs(lines) do
		local sides, a1, a2, a3, a4, a5, a6, a7, a8 = unpack(line);
		if(sides == 1) then
			ItemRefTooltip:AddLine(a1, a2, a3, a4, a5);
		elseif(sides == 2) then
			ItemRefTooltip:AddDoubleLine(a1, a2, a3, a4, a5, a6, a7, a8);
		end
	end
	ItemRefTooltip:Show()
end
module.ShowTooltip = ShowTooltip

local versionString = AddonDB.WeakAuras.versionString;
-- fields that are not included in exported data
-- these represent information which is only meaningful inside the db,
-- or are represented in other ways in exported
local non_transmissable_fields = {
	controlledChildren = true,
	-- parent = true, -- trnasmit parent info so non nested groups are stayed where they should be
	authorMode = true,
	skipWagoUpdate = true,
	ignoreWagoUpdate = true,
	preferToUpdate = true,
	information = {
		saved = true
	}
}

-- For nested groups, we do transmit parent + controlledChildren
local non_transmissable_fields_v2000 = {
	authorMode = true,
	skipWagoUpdate = true,
	ignoreWagoUpdate = true,
	preferToUpdate = true,
	information = {
		saved = true
	}
}

local function stripNonTransmissableFields(datum, fieldMap)
	for k, v in next, fieldMap do
		if type(v) == "table" and type(datum[k]) == "table" then
			stripNonTransmissableFields(datum[k], v)
		elseif v == true then
			datum[k] = nil
		end
	end
end


local function CompressDisplay(data, version)
	-- Clean up custom trigger fields that are unused
	-- Those can contain lots of unnecessary data.
	-- Also we warn about any custom code, so removing unnecessary
	-- custom code prevents unnecessary warnings
	for triggernum, triggerData in ipairs(data.triggers) do
		local trigger, untrigger = triggerData.trigger, triggerData.untrigger

		if (trigger and trigger.type ~= "custom") then
			trigger.custom = nil;
			trigger.customDuration = nil;
			trigger.customName = nil;
			trigger.customIcon = nil;
			trigger.customTexture = nil;
			trigger.customStacks = nil;
			if (untrigger) then
				untrigger.custom = nil;
			end
		end
	end

	local copiedData = CopyTable(data)
	local non_transmissable_fields = version >= 2000 and non_transmissable_fields_v2000
														or non_transmissable_fields
	stripNonTransmissableFields(copiedData, non_transmissable_fields)
	copiedData.tocversion = AddonDB.WeakAuras.BuildInfo
	return copiedData;
end

local configForLS = {
  errorOnUnserializableType = false
}

local configForDeflate = {level = 9}

local function TableToString(inTable, forChat)
	local serialized = LibSerializeAsync:SerializeEx(configForLS, inTable)

	local compressed = C_EncodingUtil and C_EncodingUtil.CompressString(serialized, Enum.CompressionMethod.Deflate, Enum.CompressionLevel.OptimizeForSize) or LibDeflateAsync:CompressDeflate(serialized, configForDeflate)

	local encoded = "!WA:2!"
	if(forChat) then
		encoded = encoded .. LibDeflateAsync:EncodeForPrint(compressed)
	else
		encoded = encoded .. LibDeflateAsync:EncodeForWoWAddonChannel(compressed)
	end
	return encoded
end

local function StringToTable(inString, fromChat)
	-- encoding format:
	-- version 0: simple b64 string, compressed with LC and serialized with AS
	-- version 1: b64 string prepended with "!", compressed with LD and serialized with AS
	-- version 2+: b64 string prepended with !WA:N! (where N is encode version)
	--   compressed with LD and serialized with LS
	local _, _, encodeVersion, encoded = inString:find("^(!WA:%d+!)(.+)$")
	if encodeVersion then
	  	encodeVersion = tonumber(encodeVersion:match("%d+"))
	else
	  	encoded, encodeVersion = inString:gsub("^%!", "")
	end

	local decoded
	if(fromChat) then
	  	if encodeVersion > 0 then
			decoded = LibDeflateAsync:DecodeForPrint(encoded)
	  	else
			decoded = AddonDB:DecodeB64(encoded)
	  	end
	else
	  	decoded = LibDeflateAsync:DecodeForWoWAddonChannel(encoded)
	end

	if not decoded then
	  	return L["Error decoding."]
	end

	local decompressed
	if encodeVersion > 0 then
	  	decompressed = C_EncodingUtil and C_EncodingUtil.DecompressString(decoded) or LibDeflateAsync:DecompressDeflate(decoded)
	  	if not(decompressed) then
			return L["Error decompressing"]
	  	end
	else
	  -- We ignore the error message, since it's more likely not a weakaura.
	  	decompressed = Compresser:Decompress(decoded)
	  	if not(decompressed) then
			return L["Error decompressing. This doesn't look like a WeakAuras import."]
	  	end
	end

	local success, deserialized
	if encodeVersion < 2 then
	  	success, deserialized = Serializer:Deserialize(decompressed)
	else
	  	success, deserialized = LibSerializeAsync:Deserialize(decompressed)
	end
	if not(success) then
	  	return L["Error deserializing"]
	end
	return deserialized
  end

local function DisplayToTransmit(data)
	if not data then return nil end

	data.uid = data.uid or AddonDB:GenerateUniqueID()
	-- Check which transmission version we want to use
	local version = 1421
	for child in pTraverseSubGroups(data) do -- luacheck: ignore
		version = 2000
		break;
	end
	local transmitData = CompressDisplay(data, version);
	local transmit = {
		m = "d",
		d = transmitData,
		v = version,
		s = versionString
	};
	if(data.controlledChildren) then
		transmit.c = {};
		local uids = {}
		local index = 1
		for child in pTraverseAllChildren(data) do
			if child.uid then
				if uids[child.uid] then
					child.uid = AddonDB:GenerateUniqueID()
				else
					uids[child.uid] = true
				end
			else
				child.uid = AddonDB:GenerateUniqueID()
			end
			transmit.c[index] = CompressDisplay(child, version);
			index = index + 1
		end
	end
	return transmit
end

local function DisplayToString(data, forChat)
	local transmit = DisplayToTransmit(data)
	return transmit and TableToString(transmit, forChat) or ""

end
module.TableToString = TableToString
module.StringToTable = StringToTable
module.DisplayToString = DisplayToString
module.CompressDisplay = CompressDisplay
module.DisplayToTransmit = DisplayToTransmit
