local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({ -- Any
	version = 1,
	encounterID = 3178,
	name = "Vaelgor and Ezzorak",
	s = {
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetNoteStage(1)
	end,
	onEventAdded = function(self, event)
	end,
	onEventStateChanged = function(self, event, newState)
	end,
	onEventRemoved = function(self, event)
	end,
})

TimelineParser:RegisterBossMod({ -- Mythic
	version = 1,
	encounterID = 3178,
	difficultyID = 16,
	name = "Vaelgor and Ezzorak",
	s = {
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetNoteStage(1)

		self.mythicTimers = {
			[1244221]={9.8,74.8,138.4,150.4,195.6,252.6,321.2,365.3,439.3,472.1,cast=4}, -- Dread Breath
			[1265131]={11.8,39.3,56.3,89.4,106.3,187.1,204.1,237.1,254.6,287.1,351.8,384.8,401.8,441.3,451.8,476.6,cast=1.5}, -- Vaelwing
			[1245645]={16.3,41.3,66.3,87.3,116.4,185,215.1,235.1,264.1,289.1,361.8,382.8,411.8,432.8,cast=1.5}, -- Rakfang
			[1245391]={12.8,62.8,112.8,211.6,260.6,313.1,358.3,408.3,cast=4}, -- Gloom
			[1244917]={36.3,76.3,169.1,204.1,244.1,284.1,305.6,371.8,416.9,451.8,cast=2.5}, -- Void Howl
			[1262623]={32.8,82.8,142.4,180.6,230.6,280.6,378.3,428.3,cast=4}, -- Nullbeam
			[1244672]={38.4,88.4,147.9,186.1,236.1,286.1,383.8,433.8}, -- Nullzone
			[1248847]={127.8,296.5,463,cast=5}, -- Radiant Barrier
		}

		local function scheduleNext(spellID)
			local times = self.mythicTimers[spellID]
			local t = tremove(times, 1)
			if t then
				t = t - self:GetEncounterTime() - (self.mythicTimers[spellID].cast or 0)
				self:AddEvent(spellID, t)
				self:Schedule(t, scheduleNext, spellID)
			end
		end

		for spell in pairs(self.mythicTimers) do
			scheduleNext(spell)
		end
	end,
	onEventAdded = function(self, event)
	end,
	onEventStateChanged = function(self, event, newState)
	end,
	onEventRemoved = function(self, event)
	end,
})
