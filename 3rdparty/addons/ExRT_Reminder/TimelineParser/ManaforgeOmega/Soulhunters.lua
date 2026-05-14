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
	encounterID = 3122,
	difficultyID = 16,
	name = "Soulhunters",
	s = {
		VOIDSTEP = 1227355,
		ERADICATE = 1245743,
		METAMORPHOSIS = 1228381,
		SIGIL_OF_CHAINS = 1240891,
		SPIRIT_BOMB = 1242259,
		THE_HUNT = 1227809,
		BLADE_DANCE = 1241306,
		EYE_BEAM = 1218103,
		FRACTURE = 1241833,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[90.909] = self.s.METAMORPHOSIS,
			[34.09] = self.s.FRACTURE,
			[31.818] = self.s.ERADICATE,
			[25] = self.s.THE_HUNT,
			[24.431] = self.s.SIGIL_OF_CHAINS,
			[17.045] = self.s.SPIRIT_BOMB,
			[14.204] = self.s.BLADE_DANCE,
			[9.09] = self.s.VOIDSTEP,
			[4.545] = self.s.EYE_BEAM,
		}

		self.rescheduleDelays = {
			[self.s.VOIDSTEP] = 2.8,
			[self.s.BLADE_DANCE] = 4,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 16 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time, 0.2) then -- increased margin
					self:SetSpellID(event, spellID)
				end
			end
		end

		if self:GetStage() == 1.5 then
			self:SetStage(1)
		end

		if self:GetStageTime() < 2 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time, 0.2) then -- increased margin
					self:SetSpellID(event, spellID)
				end
			end
		end

	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.METAMORPHOSIS then
				self:SetStage(1.5)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime(), self.rescheduleDelays[spellID]) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
