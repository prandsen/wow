local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 1698,
	difficultyID = 8,
	name = "Раннжит",
	s = {
		FAN_OF_BLADES = 153757,
		GALE_SURGE = 1252733,
		CHAKRAM_VORTEX = 156793,
		WIND_CHAKRAM = 1258148,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[35] = self.s.CHAKRAM_VORTEX,
			[18] = self.s.WIND_CHAKRAM,
			[12] = self.s.FAN_OF_BLADES,
			[5] = self.s.GALE_SURGE,
		}
	end,
	onEventAdded = function(self, event)
		for time, spellID in pairs(self.pullTimers) do
			if self:IsTimeEqual(event.duration, time) then
				self:SetSpellID(event, spellID)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 60 then -- фейк таймеры
			return
		end
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


TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 1699,
	difficultyID = 8,
	name = "Аракнат",
	s = {
		ENERGIZE = 154162,
		FIERY_SMASH = 154115,
		SUPERNOVA = 154135,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[46] = self.s.SUPERNOVA,
			[6] = self.s.ENERGIZE,
			[5] = self.s.FIERY_SMASH,
		}
	end,
	onEventAdded = function(self, event)
		for time, spellID in pairs(self.pullTimers) do
			if self:IsTimeEqual(event.duration, time) then
				self:SetSpellID(event, spellID)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 60 then -- фейк таймеры
			return
		end
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

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 1700,
	difficultyID = 8,
	name = "Рухран",
	s = {
		BURNING_CLAWS = 1253519,
		SUNBREAK = 1253510,
		SEARING_QUILLS = 1253527,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[38] = self.s.SEARING_QUILLS,
			[12] = self.s.SUNBREAK,
			[5] = self.s.BURNING_CLAWS,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStageTime() < 3 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 60 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.SEARING_QUILLS then
				self:Schedule(6, self.SetStage, self, 1)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 1701,
	difficultyID = 8,
	name = "Высший мудрец Вирикс",
	s = {
		SOLAR_BLAST = 154396,
		CAST_DOWN = 1253998,
		SCORCHING_RAY = 1253538,
		LENS_FLARE = 1253840,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[30] = self.s.LENS_FLARE,
			[12] = self.s.CAST_DOWN,
			[8] = self.s.SOLAR_BLAST,
			[5] = self.s.SCORCHING_RAY,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 2 then
			self:SetStage(1)
		end
		if self:GetStageTime() < 3 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 60 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.LENS_FLARE then
				self:SetStage(2)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
