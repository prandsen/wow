local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({ -- Mythic
	version = 1,
	encounterID = 3177,
	difficultyID = 16,
	name = "Vorasisus",
	s = {
		VOID_BREATH = 1243853,
		SHADOWCLAW_SLAM = 1241836,
		PARASITE_EXPULSION = 1254199,
		PRIMORDIAL_ROAR = 1260046,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.pullTimersQueue = { -- XXX Timeline
			self.s.SHADOWCLAW_SLAM,
			self.s.VOID_BREATH,
			self.s.PARASITE_EXPULSION,
			self.s.SHADOWCLAW_SLAM,
			self.s.PRIMORDIAL_ROAR,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			local spellID = tremove(self.pullTimersQueue, 1)
			if spellID then
				self:SetSpellID(event, spellID)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})


TimelineParser:RegisterBossMod({ -- Any
	version = 1,
	encounterID = 3177,
	name = "Vorasisus",
	s = {
		VOID_BREATH = 1243853,
		SHADOWCLAW_SLAM = 1241836,
		PARASITE_EXPULSION = 1254199,
		PRIMORDIAL_ROAR = 1260046,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.pullTimersQueue = { -- XXX Timeline
			self.s.SHADOWCLAW_SLAM,
			self.s.VOID_BREATH,
			self.s.PARASITE_EXPULSION,
			self.s.SHADOWCLAW_SLAM,
			self.s.PRIMORDIAL_ROAR,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			local spellID = tremove(self.pullTimersQueue, 1)
			if spellID then
				self:SetSpellID(event, spellID)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
