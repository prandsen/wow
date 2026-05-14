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
	encounterID = 3179,
	difficultyID = 16,
	name = "Fallen King Salhadaar",
	s = {
		BERSERK = 64238,
		DESPOTIC_COMMAND = 1260823,
		SHATTERING_TWILIGHT = 1253911,
		VOID_CONVERGENCE = 1243453,
		TWISTING_OBSCURITY = 1250686,
		ENTROPIC_UNRAVELING = 1246175,
		FRACTURED_PROJECTION = 1254081,
	},
	recheckEntropicUnraveling = function(self) ---@cast self BossMod
		for event in self:IterateEvents() do
			if event:IsRunning() and event:GetSpellID() == self.s.ENTROPIC_UNRAVELING then
				return
			end
		end

		-- no ENTROPIC_UNRAVELING found, schedule it outselves
		self:AddEvent(self.s.ENTROPIC_UNRAVELING, 98)
		for event in self:IterateEvents() do
			if event:IsRunning() and event:GetSpellID() == self.s.ENTROPIC_UNRAVELING then
				self:Schedule(98, self.onEventStateChanged, self, event)
				return
			end
		end
	end,
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.pullTimers = {
			[370] = self.s.BERSERK,
			[100] = self.s.ENTROPIC_UNRAVELING,
			[44] = self.s.SHATTERING_TWILIGHT,
			[26] = self.s.FRACTURED_PROJECTION,
			[23] = self.s.DESPOTIC_COMMAND,
			[15] = self.s.TWISTING_OBSCURITY,
			[11] = self.s.VOID_CONVERGENCE,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 1.5 then
			self:SetStage(1)
			self:Schedule(2, self.recheckEntropicUnraveling, self)
		end

		if self:GetStageTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.ENTROPIC_UNRAVELING then
				self:SetStage(1.5)
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
	encounterID = 3179,
	name = "Fallen King Salhadaar",
	s = {
		BERSERK = 64238,
		DESPOTIC_COMMAND = 1260823,
		SHATTERING_TWILIGHT = 1253911,
		VOID_CONVERGENCE = 1243453,
		TWISTING_OBSCURITY = 1250686,
		ENTROPIC_UNRAVELING = 1246175,
		FRACTURED_PROJECTION = 1254081,
	},
	recheckEntropicUnraveling = function(self) ---@cast self BossMod
		for event in self:IterateEvents() do
			if event:IsRunning() and event:GetSpellID() == self.s.ENTROPIC_UNRAVELING then
				return
			end
		end

		-- no ENTROPIC_UNRAVELING found, schedule it outselves
		self:AddEvent(self.s.ENTROPIC_UNRAVELING, 98)
		for event in self:IterateEvents() do
			if event:IsRunning() and event:GetSpellID() == self.s.ENTROPIC_UNRAVELING then
				self:Schedule(98, self.onEventStateChanged, self, event)
				return
			end
		end
	end,
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.pullTimers = { -- XXX Timeline
			[370] = self.s.BERSERK,
			[100] = self.s.ENTROPIC_UNRAVELING,
			[44] = self.s.SHATTERING_TWILIGHT,
			[26] = self.s.FRACTURED_PROJECTION,
			[23] = self.s.DESPOTIC_COMMAND,
			[15] = self.s.TWISTING_OBSCURITY,
			[11] = self.s.VOID_CONVERGENCE,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 1.5 then
			self:SetStage(1)
			self:Schedule(2, self.recheckEntropicUnraveling, self)
		end

		if self:GetStageTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.ENTROPIC_UNRAVELING then
				self:SetStage(1.5)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
