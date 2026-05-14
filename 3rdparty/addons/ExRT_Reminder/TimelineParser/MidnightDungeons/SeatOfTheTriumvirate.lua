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
	encounterID = 2065,
	difficultyID = 8,
	name = "Зураал Перерожденный",
	s = {
		NULL_PALM = 1268916,
		DECIMATE = 1263282,
		OOZING_SLAM = 1263399,
		VOID_SLASH = 1263440,
		CRASHING_VOID = 1263304,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[47] = self.s.CRASHING_VOID,
			[22] = self.s.OOZING_SLAM,
			[16] = self.s.NULL_PALM,
			[7] = self.s.DECIMATE,
			[4] = self.s.VOID_SLASH,
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
	encounterID = 2066,
	difficultyID = 8,
	name = "Сарпиш",
	s = {
		OVERLOAD = 1263523,
		PHASE_DASH = 1263509,
		VOID_BOMB = 247175,
		SHADOW_POUNCE = 245738,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[32] = self.s.OVERLOAD,
			[20] = self.s.PHASE_DASH,
			[6] = self.s.VOID_BOMB,
			[4] = self.s.SHADOW_POUNCE,
			-- late timers
			[12] = self.s.PHASE_DASH,
			[10] = self.s.VOID_BOMB,
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

	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 2067,
	difficultyID = 8,
	name = "Наместник Незжар",
	s = {
		GATES_OF_THE_ABYSS = 1277358,
		UMBRAL_TENTACLES = 1263538,
		REPULSE = 1263528,
		MIND_BLAST = 244750,
		MASS_VOID_INFUSION = 1263542,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[45] = self.s.REPULSE,
			[26] = self.s.UMBRAL_TENTACLES,
			[12] = self.s.MASS_VOID_INFUSION,
			[6] = self.s.GATES_OF_THE_ABYSS,
			[4] = self.s.MIND_BLAST,
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
		if event:SinceAdded() < 0.5 then -- фейк таймеры
			return
		end

		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.REPULSE then -- repulse takes 20 seconds
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
	encounterID = 2068,
	difficultyID = 8,
	name = "Л'ура",
	s = {
		DIRGE_OF_DESPAIR = 1265421,
		DISCORDANT_BEAM = 1265426,
		DISINTEGRATE = 1264151,
		GRIM_CHORUS = 1265689,
		SYMPHONY_OF_THE_ETERNAL_NIGHT = 1266003,
		BACKLASH = 1266001,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[35] = self.s.GRIM_CHORUS,
			[24] = self.s.DISCORDANT_BEAM,
			[12] = self.s.DISINTEGRATE,
			[1.5] = self.s.DIRGE_OF_DESPAIR,
		}
		self.restTimers = {
			[28] = self.s.GRIM_CHORUS,
			[17] = self.s.DISCORDANT_BEAM,
			[5] = self.s.DISINTEGRATE,
			[1.5] = self.s.SYMPHONY_OF_THE_ETERNAL_NIGHT,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 2 then
			if self:IsTimeEqual(event.duration, 20) then
				self:SetSpellID(event, self.s.BACKLASH)
			end
		elseif self:GetStageTime() < 2 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		else
			for time, spellID in pairs(self.restTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
					if spellID == self.s.SYMPHONY_OF_THE_ETERNAL_NIGHT then
						self:SetStage(2)
					end
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.BACKLASH then
				self:SetStage(1)
			elseif event:IsFinished() and self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
