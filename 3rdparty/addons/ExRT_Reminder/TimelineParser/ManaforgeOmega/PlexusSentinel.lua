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
	encounterID = 3129,
	difficultyID = 16,
	name = "Plexus Sentinel",
	s = {
		OBLITERATION_ARCANOCANNON = 1219263,
		MANIFEST_MATRICES = 1219450,
		ERADICATING_SALVO = 1219532,
		PROTOCOL_PURGE = 1220489,
		STAGE_TWO = 1272966,
		CLEANSE_THE_CHAMBER = 1234733,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[61] = self.s.STAGE_TWO,
			[60] = self.s.PROTOCOL_PURGE,
			[39] = self.s.ERADICATING_SALVO,
			[21] = self.s.OBLITERATION_ARCANOCANNON,
			[8] = self.s.MANIFEST_MATRICES,
		}
		self.stageResetTimers = {
			[91] = self.s.STAGE_TWO,
			[90] = self.s.PROTOCOL_PURGE,
			[24] = self.s.CLEANSE_THE_CHAMBER,
			[11] = self.s.OBLITERATION_ARCANOCANNON,
			[18] = self.s.ERADICATING_SALVO,
			[3] = self.s.MANIFEST_MATRICES,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 2 then
			self:SetStage(1)
		end
		if self:GetStageTime() < 0.5 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:IsPaused() and self:GetStage() == 1 then
			self:SetStage(2)
		end
		if self:GetStage() == 1 then
			local spellID = event:GetSpellID()
			if spellID then
				if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
					self:SetSpellID(self.lastAddedEvent, spellID)
				end
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
