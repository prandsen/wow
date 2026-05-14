local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser


TimelineParser:RegisterBossMod({ -- Mythic
	version = 1,
	encounterID = 3306,
	difficultyID = 16,
	name = "Chimaerus",
	s = {
		RIFT_CATACLYSM = 1260088,
		CONSUME = 1245396,
		CAUSTIC_PHLEGM = 1246621,
		RENDING_TEAR = 1272726,
		CONSUMING_MIASMA = 1257085,
		ALNDUST_UPHEAVAL = 1262289,
		RIFT_EMERGENCE = 1251021,
		RIFT_MADNESS = 1268905,
		-- p2
		CORRUPTED_DEVASTATION = 1245452
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self:Schedule(252, self.SetNoteStage, self, 2) -- TODO make it dynamic

		self.pullTimers = { -- XXX Timeline, intermission?
			[600] = self.s.RIFT_CATACLYSM,
			[120.909] = self.s.CONSUME,
			[36.636] = self.s.RENDING_TEAR,
			[31.818] = self.s.CONSUMING_MIASMA,
			[30] = self.s.RIFT_MADNESS,
			[23.636] = self.s.CAUSTIC_PHLEGM,
			[13.636] = self.s.ALNDUST_UPHEAVAL,
			[6.363] = self.s.RIFT_EMERGENCE,
		}

		self.stage2TimersQueuePrototype = {
			self.s.ALNDUST_UPHEAVAL,
			self.s.CAUSTIC_PHLEGM,
			self.s.CONSUMING_MIASMA,
			self.s.CAUSTIC_PHLEGM,
			self.s.CORRUPTED_DEVASTATION,
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
		elseif self:GetStage() == 2 then
			local spellID = tremove(self.stage2TimersQueue, 1)
			if spellID then
				self:SetSpellID(event, spellID)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.CONSUME then
				self.stage2TimersQueue = CopyTable(self.stage2TimersQueuePrototype)
				self:SetStage(2)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})


TimelineParser:RegisterBossMod({ -- Any
	version = 1,
	encounterID = 3306,
	name = "Chimaerus",
	s = {
		RIFT_CATACLYSM = 1260088,
		CONSUME = 1245396,
		CAUSTIC_PHLEGM = 1246621,
		RENDING_TEAR = 1272726,
		CONSUMING_MIASMA = 1257085,
		ALNDUST_UPHEAVAL = 1262289,
		RIFT_EMERGENCE = 1251021,
		RIFT_MADNESS = 1268905,
		-- p2
		CORRUPTED_DEVASTATION = 1245452
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.pullTimers = { -- XXX Timeline, intermission?
			[600] = self.s.RIFT_CATACLYSM,
			[120.909] = self.s.CONSUME,
			[36.636] = self.s.RENDING_TEAR,
			[31.818] = self.s.CONSUMING_MIASMA,
			[30] = self.s.RIFT_MADNESS,
			[23.636] = self.s.CAUSTIC_PHLEGM,
			[13.636] = self.s.ALNDUST_UPHEAVAL,
			[6.363] = self.s.RIFT_EMERGENCE,
		}

		self.stage2TimersQueuePrototype = {
			self.s.ALNDUST_UPHEAVAL,
			self.s.CAUSTIC_PHLEGM,
			self.s.CONSUMING_MIASMA,
			self.s.CAUSTIC_PHLEGM,
			self.s.CORRUPTED_DEVASTATION,
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
		elseif self:GetStage() == 2 then
			local spellID = tremove(self.stage2TimersQueue, 1)
			if spellID then
				self:SetSpellID(event, spellID)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.CONSUME then
				self.stage2TimersQueue = CopyTable(self.stage2TimersQueuePrototype)
				self:SetStage(2)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
