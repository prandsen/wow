local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({
	version = 3,
	encounterID = 3133,
	difficultyID = 16,
	name = "Fractillus",
	s = {
		SHOCKWAVE_SLAM = 1231871,
		SHATTERSHELL = 1227367,
		SHATTERING_BACKHAND = 1220394,
		CRYSTALLINE_SHOCKWAVE = 1279371,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[50] = self.s.SHATTERING_BACKHAND,
			[39] = self.s.SHATTERSHELL,
			[18] = self.s.SHOCKWAVE_SLAM,
			[16] = self.s.CRYSTALLINE_SHOCKWAVE,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStageTime() < 4 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID and event:IsFinished() then
			if spellID == self.s.CRYSTALLINE_SHOCKWAVE and self:GetStageTime() < 25 then
				if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
					self:SetSpellID(self.lastAddedEvent, spellID)
				end
			elseif spellID == self.s.SHATTERING_BACKHAND then
				self:SetStage(1) -- cycle events are scheduled 2 seconds after this
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
