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
	encounterID = 3176,
	difficultyID = 16,
	name = "Averzian",
	s = {
		DARK_UPHEAVAL = 1249251,
		SHADOWS_ADVANCE = 1251361,
		VOID_MARKED = 1280015,
		UMBRAL_COLLAPSE = 1249262,
		OBLIVIONS_WRATH = 1260712,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.pullTimers = { -- XXX Timeline, intermission?
			[4] = self.s.DARK_UPHEAVAL,
			[10] = self.s.SHADOWS_ADVANCE,
			[16] = self.s.VOID_MARKED,
			[23] = self.s.UMBRAL_COLLAPSE,
			[48] = self.s.OBLIVIONS_WRATH,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time, 1.5) then -- increased delay as my data is not precise
					self:SetSpellID(event, spellID)
					break
				end
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


TimelineParser:RegisterBossMod({ -- Heroic
	version = 1,
	encounterID = 3176,
	difficultyID = 15,
	name = "Averzian",
	s = {
		DARK_UPHEAVAL = 1249251,
		SHADOWS_ADVANCE = 1251361,
		VOID_MARKED = 1280015,
		UMBRAL_COLLAPSE = 1249262,
		OBLIVIONS_WRATH = 1260712,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.pullTimers = { -- XXX Timeline, intermission?
			[4] = self.s.DARK_UPHEAVAL,
			[10] = self.s.SHADOWS_ADVANCE,
			[16] = self.s.VOID_MARKED,
			[23] = self.s.UMBRAL_COLLAPSE,
			[48] = self.s.OBLIVIONS_WRATH,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time, 1.5) then -- increased delay as my data is not precise
					self:SetSpellID(event, spellID)
					break
				end
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
	encounterID = 3176,
	name = "Averzian",
	s = {
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
	end,
	onEventAdded = function(self, event)

	end,
	onEventStateChanged = function(self, event, newState)
	end,
	onEventRemoved = function(self, event)
	end,
})
