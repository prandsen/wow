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
	encounterID = 3212,
	difficultyID = 8,
	name = "Муро'джин и Некракс",
	s = {
		FETID_QUILLSTORM = 1243900,
		CARRION_SWOOP = 1249479,
		INFECTED_PINIONS = 1246666,
		BARRAGE = 1260643,
		FLANKING_SPEAR = 1266480,
		FREEZING_TRAP = 1260731,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[41] = self.s.CARRION_SWOOP,
			[35] = self.s.BARRAGE,
			[28] = self.s.FETID_QUILLSTORM,
			[20] = self.s.FREEZING_TRAP,
			[12] = self.s.INFECTED_PINIONS,
			[5] = self.s.FLANKING_SPEAR,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 3 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		else
			if event.eventNum % 6 == 1 then
				self:SetSpellID(event, self.s.FLANKING_SPEAR)
			elseif event.eventNum % 6 == 2 then
				self:SetSpellID(event, self.s.INFECTED_PINIONS)
			elseif event.eventNum % 6 == 3 then
				self:SetSpellID(event, self.s.FREEZING_TRAP)
			elseif event.eventNum % 6 == 4 then
				self:SetSpellID(event, self.s.FETID_QUILLSTORM)
			elseif event.eventNum % 6 == 5 then
				self:SetSpellID(event, self.s.BARRAGE)
			elseif event.eventNum % 6 == 0 then
				self:SetSpellID(event, self.s.CARRION_SWOOP)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		-- if event:SinceAdded() < 0.5 or event.duration > 60 then -- фейк таймеры
		-- 	return
		-- end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3213,
	difficultyID = 8,
	name = "Вордаза",
	s = {
		UNMAKE = 1252054,
		DRAIN_SOUL = 1251554,
		NECROTIC_CONVERGENCE = 1250708,
		WREST_PHANTOMS = 1251204,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[70] = self.s.NECROTIC_CONVERGENCE,
			[25.333] = self.s.UNMAKE,
			[14.166] = self.s.WREST_PHANTOMS,
			[3] = self.s.DRAIN_SOUL,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 2 then
			self:SetStage(1)
		end

		if self:GetStageTime() < 2 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 80 then -- фейк таймеры
			return
		end

		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.NECROTIC_CONVERGENCE then
				self:SetStage(2)
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
	encounterID = 3214,
	difficultyID = 8,
	name = "Рак'тул",
	s = {
		CRUSH_SOULS = 1252676,
		SOULRENDING_ROAR = 1253788,
		SPIRITBREAKER = 1251023,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[70] = self.s.SOULRENDING_ROAR,
			[17.2] = self.s.CRUSH_SOULS,
			[4] = self.s.SPIRITBREAKER,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 2 then
			self:SetStage(1)
		end

		if self:GetStageTime() < 2 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 80 then -- фейк таймеры
			return
		end

		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.SOULRENDING_ROAR then
				self:SetStage(2)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
