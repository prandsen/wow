local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({
	version = 4,
	encounterID = 3135,
	difficultyID = 16,
	name = "Dimensius",
	sorted_s = function(self)
		return {
			"Phase 1",
			self.s.REVERSE_GRAVITY,
			self.s.DEVOUR,
			self.s.MASSIVE_SMASH,
			self.s.DARK_MATTER,
			self.s.SHATTERED_SPACE,
			"Phase 2",
			self.s.GRAVITATIONAL_DISTORTION,
			self.s.EXTINCTION,
			self.s.GAMMA_BURST,
			self.s.CONQUERORS_CROSS,
			self.s.ECLIPSE,
			self.s.MASS_DESTRUCTION,
			self.s.STARSHARD_NOVA,
			"Phase 3",
			self.s.COSMIC_COLLAPSE,
			self.s.DEVOUR_P3,
			self.s.GRAVITATIONAL_DISTORTION,
			self.s.DARKENED_SKY,
		}
	end,
	s = {
		-- p1
		REVERSE_GRAVITY = 1243577,
		DEVOUR = 1229038,
		MASSIVE_SMASH = 1230087,
		DARK_MATTER = 1230979,
		SHATTERED_SPACE = 1243690,
		-- p2
		GRAVITATIONAL_DISTORTION = 1234242,
		EXTINCTION = 1238765,
		GAMMA_BURST = 1237319,
		CONQUERORS_CROSS = 1239262,
		ECLIPSE = 1237690,
		MASS_DESTRUCTION = 1249423,
		STARSHARD_NOVA = 1249454,
		-- p3
		COSMIC_COLLAPSE = 1234263,
		DEVOUR_P3 = 1233539, -- use p1 spellID
		-- GRAVITATIONAL_DISTORTION = 1234242,
		DARKENED_SKY = 1234052,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[43.157] = self.s.REVERSE_GRAVITY,
			[36.842] = self.s.SHATTERED_SPACE,
			[31.578] = self.s.DARK_MATTER,
			[21.052] = self.s.MASSIVE_SMASH,
			[10.526] = self.s.DEVOUR,
		}

		self.stage2count = 0
		self.stage2_1Timers = {
			[65.263] = self.s.ECLIPSE,
			[24.21] = self.s.GAMMA_BURST,
			[15.789] = self.s.GRAVITATIONAL_DISTORTION,
			[13.684] = self.s.EXTINCTION,
			[6.315] = self.s.MASS_DESTRUCTION,
			[3.157] = self.s.CONQUERORS_CROSS,
		}

		self.stage2_2Timers =  {
			[65.263] = self.s.ECLIPSE,
			[23.157] = self.s.GAMMA_BURST,
			[14.736] = self.s.GRAVITATIONAL_DISTORTION,
			[12.631] = self.s.EXTINCTION,
			[5.263] = self.s.STARSHARD_NOVA,
			[2.105] = self.s.CONQUERORS_CROSS,
		}

		self.p3eventsPending = false
		self.stage3Timers = {
			[32] = self.s.GRAVITATIONAL_DISTORTION,
			[30] = self.s.COSMIC_COLLAPSE,
			[20] = self.s.DEVOUR_P3,
			[2] = self.s.DARKENED_SKY,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time, 2) then -- increased margin
					self:SetSpellID(event, spellID)
				end
			end
		elseif self:GetStage() == 1.5 then
			self.stage2count = self.stage2count + 1
			self:SetStage(2)
		end

		if self:GetStage() == 2 and self:GetStageTime() < 1 then
			local stageTimers = self.stage2count == 1 and self.stage2_1Timers or self.stage2_2Timers
			for time, spellID in pairs(stageTimers) do
				if self:IsTimeEqual(event.duration, time, 1.2) then -- increased margin
					self:SetSpellID(event, spellID)
				end
			end
		end

		if self:GetStage() == 3 and self.p3eventsPending then
			self.p3eventsPending = false
			self.realp3Start = GetTime()
		end

		if GetTime() - (self.realp3Start or 0) < 1 then
			for time, spellID in pairs(self.stage3Timers) do
				if self:IsTimeEqual(event.duration, time, 2) then -- increased margin
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if self:GetStage() == 1 and event:IsCanceled()  then
				self:SetStage(1.5)
				return
			end

			if spellID == self.s.ECLIPSE then
				if self.stage2count == 1 then
					self:SetStage(1.5)
				else
					self:Schedule(2, self.SetStage, self, 3)
					self.p3eventsPending = true
				end
			end

			if self:GetStageTime() > 1.5 then
				if spellID == self.s.DARKENED_SKY then
					self:SetSpellID(self.lastAddedEvent, spellID) -- darkened sky rescheduled with a delay but nothing happens in between

				elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime(), 0.5) then -- increased margin
					self:SetSpellID(self.lastAddedEvent, spellID)
				end
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
