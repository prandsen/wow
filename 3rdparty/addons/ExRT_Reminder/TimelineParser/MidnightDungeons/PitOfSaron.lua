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
	encounterID = 1999,
	difficultyID = 8,
	name = "Начальник кузни Гархлад",
	s = {
		GLACIAL_OVERLOAD = 1262029,
		THROW_SARONITE = 1261299,
		OREBREAKER = 1261546,
		CRYOSTOMP = 1261847,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[37] = self.s.GLACIAL_OVERLOAD,
			[22] = self.s.OREBREAKER,
			[7] = self.s.THROW_SARONITE,
		}
		self.lateTimers = {
			[49] = self.s.GLACIAL_OVERLOAD,
			[34] = self.s.OREBREAKER,
			[19] = self.s.THROW_SARONITE,
			[6] = self.s.CRYOSTOMP,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 2 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		else
			for time, spellID in pairs(self.lateTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)

	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 2001,
	difficultyID = 8,
	name = "Ик и Крик",
	s = {
		GET_EM_ICK = 1264363,
		BLIGHT_SMASH = 1264287,
		PLAGUE_EXPULSION = 1264336,
		SHADE_SHIFT = 1264027,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[50] = self.s.GET_EM_ICK,
			[21] = self.s.PLAGUE_EXPULSION,
			[11] = self.s.BLIGHT_SMASH,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 1 and self:GetStageTime() < 4 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		elseif self:GetStage() == 2 then
			self:SetSpellID(event, self.s.SHADE_SHIFT)
			self:Schedule(27.5, self.SetStage, self, 1)
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 60 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.GET_EM_ICK then
				self:SetStage(2)
			elseif spellID == self.s.SHADE_SHIFT then -- do nothing
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
	encounterID = 2000,
	difficultyID = 8,
	name = "Повелитель Плети Тираний",
	s = {
		RIME_BLAST = 1262745,
		DEATHS_GRASP = 1263756,
		SCOURGELORDS_BRAND = 1262582,
		ARMY_OF_THE_DEAD = 1263406,
		-- stage 2
		ICE_BARRAGE = 1276948,
		BONE_INFUSION = 1276648,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[52] = self.s.ARMY_OF_THE_DEAD,
			[24] = self.s.DEATHS_GRASP,
			[14] = self.s.SCOURGELORDS_BRAND,
			[7] = self.s.RIME_BLAST,
		}
		self.stage2Timers = {
			[12] = self.s.ICE_BARRAGE,
			[28] = self.s.BONE_INFUSION,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 1 and self:GetStageTime() < 6 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		elseif self:GetStage() == 2 then
			for time, spellID in pairs(self.stage2Timers) do
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
			if spellID == self.s.ARMY_OF_THE_DEAD then
				self:SetStage(2)
				self:Schedule(31, self.SetStage, self, 1)
			elseif spellID == self.s.BONE_INFUSION then -- do nothing
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
