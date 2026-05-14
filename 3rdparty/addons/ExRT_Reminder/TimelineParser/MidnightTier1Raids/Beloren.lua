local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({ -- Mythic
	version = 4,
	encounterID = 3182,
	difficultyID = 16,
	overrideStageEvents = true,
	name = "Beloren",
	s = {
		EMBERS_OF_BELOREN = 1241282,
		INFUSED_QUILLS = 1242260,
		GUARDIANS_EDICT = 1260763,
		RADIANT_ECHOES = 1242981,
		ETERNAL_BURNS = 1244344,
		VOIDLIGHT_CONVERGENCE = 1242515,
		REBIRTH = 1241313,
		DEATH_DROP = 1246709,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.stage1Timers = { -- XXX Timeline, confirm intermission handling works?
			-- [6] = self.s.RADIANT_ECHOES,
			[8] = self.s.EMBERS_OF_BELOREN,
			[16] = self.s.GUARDIANS_EDICT,
			[20] = self.s.GUARDIANS_EDICT,
			[30] = self.s.ETERNAL_BURNS,
			[50] = self.s.VOIDLIGHT_CONVERGENCE,
			[10] = self.s.INFUSED_QUILLS,
			[19] = self.s.INFUSED_QUILLS,
		}
		--[[
		20 Guardians Edict 18
		21 Infused Quills 10
		31 Infused Quills 10
		50 Embers of Beloren 10

		]]
		self.p2Finished = nil
		self.p2Pending = nil
	end,
	onStageChanged = function (self, newStage)
		self:ResetDurationCounts()
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 2 and self.p2Finished then
			self.p2Finished = nil
			self:SetStage(1)
		elseif self:GetStage() == 1 and self.p2Pending then
			self.p2Pending = nil
			self:SetStage(2)
			self:SetNoteStage(self:GetNoteStage() + 1)
		end

		if self:GetStage() == 1 then
			local sid = self.stage1Timers[event.duration]
			if sid then
				self:SetSpellID(event, sid, "direct lookup")
			else
				if self:IsTimeEqual(event.duration, 6) then
					self:Schedule(0.2, function()
						if self:EventsAddedInLast(0.4) >= 3 then
							self:SetSpellID(event, self.s.RADIANT_ECHOES, "counter for 6s Death Drop vs 6s Radiant Echoes")
						else
							self:SetSpellID(event, self.s.DEATH_DROP, "counter for 6s Death Drop vs 6s Radiant Echoes")
							self:SetStage(2)
							self:SetNoteStage(self:GetNoteStage() + 1)
						end
					end)
				else
					for time, spellID in pairs(self.stage1Timers) do
						if self:IsTimeEqual(event.duration, time) then
							self:SetSpellID(event, spellID, "fallback loop")
							break
						end
					end
				end
			end
		elseif self:GetStage() == 2 then
			if self:IsTimeEqual(event.duration, 30) then
				self:SetSpellID(event, self.s.REBIRTH, "p2 direct lookup for 30s Rebirth")
			elseif self:IsTimeEqual(event.duration, 6) then
				self:SetSpellID(event, self.s.DEATH_DROP, "p2 direct lookup for 6s Death Drop")
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if self:GetStage() == 1 and self:EventsCanceledInLast(0.1) >= 3 then
			self.p2Pending = true
			return
		end

		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.REBIRTH then
				self.p2Finished = true
			end
		end
	end,
	onEventRemoved = function(self, event)
	end,
})

TimelineParser:RegisterBossMod({ -- Heroic
	version = 2,
	encounterID = 3182,
	difficultyID = 15,
	overrideStageEvents = true,
	name = "Beloren",
	s = {
		EMBERS_OF_BELOREN = 1241282,
		INFUSED_QUILLS = 1242260,
		GUARDIANS_EDICT = 1260763,
		RADIANT_ECHOES = 1242981,
		ETERNAL_BURNS = 1244344,
		VOIDLIGHT_CONVERGENCE = 1242515,
		REBIRTH = 1241313,
		DEATH_DROP = 1246709,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.pullTimers = { -- XXX Timeline, confirm intermission handling works?
			-- [6] = self.s.RADIANT_ECHOES,
			[18] = self.s.GUARDIANS_EDICT,
			[20] = self.s.GUARDIANS_EDICT,
			[21] = self.s.INFUSED_QUILLS,
			[34] = self.s.ETERNAL_BURNS,
			[50] = self.s.VOIDLIGHT_CONVERGENCE,
		}
		--[[
		20 Guardians Edict 18
		21 Infused Quills 10
		31 Infused Quills 10
		50 Embers of Beloren 10

		]]
		self.p2Finished = nil
		self.p2Pending = nil
	end,
	onStageChanged = function (self, newStage)
		self:ResetDurationCounts()
		self.last6SecondSpell = nil
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 2 and self.p2Finished then
			self.p2Finished = nil
			self:SetStage(1)
		elseif self:GetStage() == 1 and self.p2Pending then
			self.p2Pending = nil
			self:SetStage(2)
			self:SetNoteStage(self:GetNoteStage() + 1)
		end

		if self:GetStage() == 1 then
			local sid = self.pullTimers[event.duration]
			if sid then
				self:SetSpellID(event, sid, "direct lookup")
			else
				if self:IsTimeEqual(event.duration, 10) then
					local durationCount = self:IncreaseDurationCount(event.duration)
					if durationCount % 3 == 1 then
						self:SetSpellID(event, self.s.EMBERS_OF_BELOREN, "counter for 20s Guardians Edict vs 10s Infused Quills")
					else
						self:SetSpellID(event, self.s.INFUSED_QUILLS, "counter for 20s Guardians Edict vs 10s Infused Quills")
					end
				elseif self:IsTimeEqual(event.duration, 30) then -- in case we missed p2 trigger with canceled events
					self:SetSpellID(event, self.s.REBIRTH, "p1 check for 30s Rebirth")
					self:SetStage(2)
					self:SetNoteStage(self:GetNoteStage() + 1)
				elseif self:IsTimeEqual(event.duration, 6) then
					if not self.last6SecondSpell or self.last6SecondSpell:SinceAdded() > 49 then
						self:SetSpellID(event, self.s.RADIANT_ECHOES, "counter for 6s Death Drop vs 6s Radiant Echoes")
						self.last6SecondSpell = event
					else
						self:SetStage(2)
						self:SetNoteStage(self:GetNoteStage() + 1)
						self:SetSpellID(event, self.s.DEATH_DROP, "counter for 6s Death Drop vs 6s Radiant Echoes")
					end
				else
					for time, spellID in pairs(self.pullTimers) do
						if self:IsTimeEqual(event.duration, time) then
							self:SetSpellID(event, spellID, "fallback loop")
							break
						end
					end
				end
			end
		elseif self:GetStage() == 2 then
			if self:IsTimeEqual(event.duration, 30) then
				self:SetSpellID(event, self.s.REBIRTH, "p2 direct lookup for 30s Rebirth")
			elseif self:IsTimeEqual(event.duration, 6) then
				self:SetSpellID(event, self.s.DEATH_DROP, "p2 direct lookup for 6s Death Drop")
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if self:GetStage() == 1 and self:EventsCanceledInLast(0.1) >= 3 then
			self.p2Pending = true
			return
		end

		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.REBIRTH then
				self.p2Finished = true
			end
		end
	end,
	onEventRemoved = function(self, event)
	end,
})

TimelineParser:RegisterBossMod({ -- Any
	version = 1,
	encounterID = 3182,
	name = "Beloren",
	s = {
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetNoteStage(1)
	end,
	onEventAdded = function(self, event)
		if self:GetNoteStageTime() > 5 then
			if self:EventsCanceledInLast(0.1) >= 4 then
				self:SetNoteStage(self:GetNoteStage() + 1)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
	end,
	onEventRemoved = function(self, event)
	end,
})
