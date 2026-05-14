local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({ -- Any
	version = 1,
	encounterID = 3180,
	name = "Lightblinded Vanguard",
	s = {
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetNoteStage(1)
	end,
	onEventAdded = function(self, event)
	end,
	onEventStateChanged = function(self, event, newState)
	end,
	onEventRemoved = function(self, event)
	end,
})
