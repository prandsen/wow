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
	encounterID = 3071,
	difficultyID = 8,
	name = "Чаротрон Кутос",
	s = {
		REFUELING_PROTOCOL = 474345,
		REPULSING_SLAM = 474496,
		ETHEREAL_SHACKLES = 1214032,
		ARCANE_EXPULSION = 1214081,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.timers = {
			[45] = self.s.REFUELING_PROTOCOL,
			[22] = self.s.ETHEREAL_SHACKLES,
			[15] = self.s.ARCANE_EXPULSION,
			[5] = self.s.REPULSING_SLAM,
			-- late timers
			[23] = self.s.ARCANE_EXPULSION,
			[22.5] = self.s.REPULSING_SLAM,
		}
	end,
	onEventAdded = function(self, event)
		if event:IsRunning() then
			for time, spellID in pairs(self.timers) do
				if self:IsTimeEqual(event.duration, time) then
					if self:GetStage() == 2 then
						self:SetStage(1)
					end
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
		if event:IsPaused() and self:GetStage() == 1 then
			self:SetStage(2)
		-- elseif event:IsFinished() and spellID == self.s.REPULSING_SLAM and self:GetStageTime() < 10 then
		-- 	if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
		-- 		self:SetSpellID(self.lastAddedEvent, spellID)
		-- 	end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3072,
	difficultyID = 8,
	name = "Селанар Бич Солнца",
	s = {
		RUNIC_MARK = 1225787,
		SUPPRESSION_ZONE = 1224903,
		VOW_OF_SILENCE = 1225193,
		HASTENING_WARD = 1248689,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.timers = {
			[51] = self.s.VOW_OF_SILENCE,
			[26] = self.s.HASTENING_WARD,
			[17] = self.s.SUPPRESSION_ZONE,
			[7] = self.s.RUNIC_MARK,
		}
	end,
	onEventAdded = function(self, event)
		if event:IsRunning() then
			for time, spellID in pairs(self.timers) do
				if self:IsTimeEqual(event.duration, time) then
					if spellID == self.s.VOW_OF_SILENCE then
						self:SetStage(1)
					end
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
		if event:IsFinished() and spellID == self.s.RUNIC_MARK and self:GetStageTime() < 12 then
			if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})


-- timers for this boss are scuffed, it cycles timers listed in self.timers and every 1.5 cycle(~50-60 sec?) it resets everything to cast trippling
TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3073,
	difficultyID = 8,
	name = "Гемелл",
	s = {
		COSMIC_STING = 1223961,
		VOID_SECRETIONS = 1224088,
		ASTRAL_GRASP = 1224129,
		NEURAL_LINK = 1253705,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.timers = {
			[29] = self.s.ASTRAL_GRASP,
			[18] = self.s.VOID_SECRETIONS,
			[7] = self.s.NEURAL_LINK,
			[5] = self.s.COSMIC_STING,
		}
	end,
	onEventAdded = function(self, event)
		for time, spellID in pairs(self.timers) do
			if self:IsTimeEqual(event.duration, time) then
				self:SetSpellID(event, spellID)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 then -- фейк таймеры
			return
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3074,
	difficultyID = 8,
	name = "Дегентрий",
	s = {
		DEVOURING_ENTROPY = 1215893,
		HULKING_FRAGMENT = 1280106,
		UNSTABLE_VOID_ESSENCE = 1215067,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.timers = {
			[15] = self.s.UNSTABLE_VOID_ESSENCE,
			[9] = self.s.DEVOURING_ENTROPY,
			[3] = self.s.HULKING_FRAGMENT,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			for time, spellID in pairs(self.timers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
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
