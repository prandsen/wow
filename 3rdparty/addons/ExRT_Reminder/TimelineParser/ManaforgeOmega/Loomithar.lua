local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({
	version = 7,
	encounterID = 3131,
	difficultyID = 16,
	name = "Loomithar",
	s = {
		PIERCING_STRAND = 1250388,
		LAIR_WEAVING = 1237272,
		OVERINFUSION_BURST = 1226395,
		INFUSION_TETHER = 1226315,
		PRIMAL_SPELLSTORM = 1226867,
		INFUSION_PYLONS = 1247672,
		-- p2
		ARCANE_OUTRAGE = 1227782,
		WRITHING_WAVE = 1227226,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[76] = self.s.OVERINFUSION_BURST,
			[19.5] = self.s.INFUSION_TETHER,
			[14] = self.s.PRIMAL_SPELLSTORM,
			[9.5] = self.s.PIERCING_STRAND,
			[5] = self.s.INFUSION_PYLONS,
			[0.5] = self.s.LAIR_WEAVING,
		}
		self.stage2Timers = {
			[10] = self.s.ARCANE_OUTRAGE,
			[8] = self.s.PRIMAL_SPELLSTORM,
			[3] = self.s.WRITHING_WAVE,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 0.5 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		elseif self:GetStage() == 2 and self:GetStageTime() < 14 then
			for time, spellID in pairs(self.stage2Timers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:IsFinished() then
			local spellID = event:GetSpellID()
			if spellID == self.s.LAIR_WEAVING and (event.count or -1) % 2 == 0 then
				for time, spellID in pairs(self.stage2Timers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
			elseif spellID then
				if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
					self:SetSpellID(self.lastAddedEvent, spellID)
				end
			end
		elseif self:GetStage() == 1 and event:IsCanceled() and self:EventsCanceledInLast(0.2) >= 4 then
			self:SetStage(2)
			for e in self:IterateEvents() do
				if self:IsTimeEqual(e.addedAt, GetTime()) then
					if self:IsTimeEqual(e.duration, 20) then
						-- ...self:SetSpellID(e, 1280946) -- XXX
					end
				end
			end
		end

	end,
	onEventRemoved = function(self, event)

	end,
})
