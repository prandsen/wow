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
	encounterID = 3132,
	difficultyID = 16,
	name = "Forgeweaver Araz",
	s = {
		ASTRAL_HARVEST = 1231015,
		ARCANE_EXPULSION = 1227631,
		INVOKE_COLLECTOR = 1231720,
		ARCANE_OBLITERATION = 1228215,
		SILENCING_TEMPEST = 1228161,
		OVERWHELMING_POWER = 1228502,

		DEATH_THROES = 1232221,
		VOID_HARVEST = 1243874,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[155] = self.s.ARCANE_EXPULSION,
			[63] = self.s.SILENCING_TEMPEST,
			[31] = self.s.ARCANE_OBLITERATION,
			[20] = self.s.ASTRAL_HARVEST,
			[9] = self.s.INVOKE_COLLECTOR,
			[4] = self.s.OVERWHELMING_POWER,
		}
		self.rescheduleTimers = {
			[self.s.ASTRAL_HARVEST] = 25,
		}

		self.stage3EventsPending = false
		self.stage3Timers = {
			[36] = self.s.SILENCING_TEMPEST,
			[12] = self.s.DEATH_THROES,
			[8] = self.s.VOID_HARVEST,
			[4] = self.s.OVERWHELMING_POWER,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
					break
				end
			end
		elseif self:GetStage() == 3 and self.stage3EventsPending then
			self.realp3Start = GetTime()
			self.stage3EventsPending = false
		end

		if GetTime() - (self.realp3Start or 0) < 1 then
			for time, spellID in pairs(self.stage3Timers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
					break
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.ARCANE_EXPULSION then
				self:SetStage(3) -- assume we will always skip intermissions
				self.stage3EventsPending = true
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime(), self.rescheduleTimers[spellID]) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
