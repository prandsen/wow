local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({ -- Any
	version = 3,
	encounterID = 3183,
	name = "Midnight Falls",
	s = {
		-- p1
		-- DEATHS_DIRGE = 1244412,
		-- HEAVENS_GLAIVES = 1253915,
		-- SHATTERED_SKY = 1249796,
		-- SAFEGUARD_PRISM = 1251386,
		-- TOTAL_ECLIPSE = 1260261, -- old name is The Black Aperture

		-- p1.5 ?
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		-- self.pullTimers = {
		-- 	[90] = self.s.TOTAL_ECLIPSE,
		-- 	[34] = self.s.SAFEGUARD_PRISM,
		-- 	[30] = {self.s.HEAVENS_GLAIVES, self.s.SHATTERED_SKY},
		-- 	[7] = self.s.DEATHS_DIRGE,
		-- }
	end,
	onEventAdded = function(self, event)
		if self:GetNoteStageTime() > 5 then
			if self:GetNoteStage() == 1 then
				if self:IsTimeEqual(event.duration, 45) then
					self:SetNoteStage(2)
					self:SetStage(1.5)
				end
			elseif self:GetNoteStage() == 2 then
				if self:IsTimeEqual(event.duration, 96, 2) then
					self:SetNoteStage(3)
					self:SetStage(2)
				end
			elseif self:GetNoteStage() == 3 then
				if self:IsTimeEqual(event.duration, 180, 2) then
					self:SetNoteStage(4)
					self:SetStage(3)
				end
			end
		end

		-- if self:GetEncounterTime() < 1 then
		-- 	for time, spellID in pairs(self.pullTimers) do
		-- 		if self:IsTimeEqual(event.duration, time) then
		-- 			if type(spellID) == "table" then
		-- 				local sID = tremove(spellID, 1)
		-- 				if sID then
		-- 					self:SetSpellID(event, sID)
		-- 				else
		-- 					TimelineParser:Log("TIMER404", "No timer found for", TimelineParser:LogForSpellEvent(event), "duration: " .. event.duration)
		-- 				end
		-- 				break
		-- 			else
		-- 				self:SetSpellID(event, spellID)
		-- 			end
		-- 		end
		-- 	end
		-- end
	end,
	onEventStateChanged = function(self, event, newState)
		-- local spellID = event:GetSpellID()
		-- if spellID then
		-- 	if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
		-- 		self:SetSpellID(self.lastAddedEvent, spellID)
		-- 	end
		-- end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({ -- Heroic
	version = 3,
	encounterID = 3183,
	difficultyID = 15,
	overrideStageEvents = true,
	name = "Midnight Falls",
	s = {
		-- p1
		DARK_QUASAR = 1279420,
		HEAVENS_LANCE = 1267049,
		DEATHS_DIRGE = 1244412,
		HEAVENS_GLAIVES = 1253915,
		SAFEGUARD_PRISM = 1251386,
		TOTAL_ECLIPSE = 1261871,

		-- p1.5 ?
		INTO_THE_DARKWELL = 1282047,

		-- p2
		DARK_MELTDOWN = 1281194,
		CORE_HARVEST = 1282412,
		GALVANIZE = 1284525,
		-- HEAVENS_LANCE = 1267049,

		-- p3
		LIGHT_SIPHON = 1266897,
		DARK_CONSTELLATION = 1266388,
		THE_DARK_ARCHANGEL = 1250898,
		-- HEAVENS_LANCE = 1267049,
		SHATTERED_SKY = 1249796,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.stage1Timers = {
			[40] = self.s.DARK_QUASAR,
			[20] = self.s.HEAVENS_LANCE,
			[10] = self.s.DEATHS_DIRGE,
			[35] = self.s.HEAVENS_GLAIVES,
			[55] = self.s.SAFEGUARD_PRISM,
			[180] = self.s.TOTAL_ECLIPSE,
		}
		self.stage2Timers = {
			[97] = self.s.DARK_MELTDOWN,
			[33] = self.s.CORE_HARVEST,
			[13] = self.s.GALVANIZE,
			[20] = self.s.HEAVENS_LANCE,
		}
		self.stage3Timers = {
			[31] = self.s.LIGHT_SIPHON,
			[33] = self.s.DARK_CONSTELLATION,
			[14] = self.s.THE_DARK_ARCHANGEL,
			[20] = self.s.HEAVENS_LANCE,
			[180] = self.s.SHATTERED_SKY,

			[6] = self.s.DARK_CONSTELLATION,
			[26] = self.s.DARK_CONSTELLATION,
			[23] = self.s.HEAVENS_LANCE,
		}
		--[[
		-- p1
		0:00 Dark Quasar 40
		0:00 Heavens Lance 20
		0:00 Death's Dirge 10
		0:00 Heaven's Glaives 35
		0:00 Safeguard Prism 55
		0:00 Total Eclipse 180
		0:10 Deaths Dirge 70
		0:20 Heavens Lance 20
		0:35 Heavens Glaives 70
		0:40 Heavens Lance 20
		0:40 Dark Quasar 70
		0:55 Safeguard Prism 70
		1:00 Heavens Lance 20
		1:20 Heavens Lance 20
		1:20 Deaths Dirge 70
		1:40 Heavens Lance 20
		1:45 Heavens Glaives 70
		2:00 Heavens Lance 20
		2:20 Heavens Lance 20

		-- p1.5
		3:00 Into the Darkwell 45

		-- p2
		3:45 Dark Meltdown 97
		3:45 Core Harvest 33
		3:45 Galvanize 13
		3:45 Heavens Lance 20
		3:58 Galvanize 30
		4:05 Heavens Lance 20
		4:18 Core Harvest 30
		4:25 Heavens Lance 20
		4:28 Galvanize 30
		4:45 Heavens Lance 20
		4:48 Core Harvest 30

		-- p3
		5:30 Light Siphon 31
		5:30 Dark Constellation 33
		5:30 Dark Archangel 14
		5:30 Heavens Lance 20
		5:30 Shattered Sky 180
		]]
	end,
	onStageChanged = function(self, newStage)
		self:ResetDurationCounts()
	end,
	onEventAdded = function(self, event)
		if self:GetNoteStageTime() > 5 then
			if self:GetNoteStage() == 1 then
				if self:IsTimeEqual(event.duration, 45) then
					self:SetNoteStage(2)
					self:SetStage(1.5)
					self:SetSpellID(event, self.s.INTO_THE_DARKWELL, "p1.5 trigger")
				end
			elseif self:GetNoteStage() == 2 then
				if self:IsTimeEqual(event.duration, 97) then
					self:SetNoteStage(3)
					self:SetStage(2)
					self:SetSpellID(event, self.s.DARK_MELTDOWN, "p2 trigger")
				end
			elseif self:GetNoteStage() == 3 then
				if self:IsTimeEqual(event.duration, 180, 2) then
					self:SetNoteStage(4)
					self:SetStage(3)
					self:SetSpellID(event, self.s.SHATTERED_SKY, "p3 trigger")
					self:Schedule(0.2, function()
						for e in self:IterateEvents() do
							if e:SinceAdded() < 0.5 then
								local sid = self.stage3Timers[e.duration]
								if sid then
									self:SetSpellID(e, sid, "p3 timer fallback")
								else
									for time, spellID in pairs(self.stage3Timers) do
										if self:IsTimeEqual(e.duration, time) then
											self:SetSpellID(e, spellID, "p3 timer fallback loop")
											break
										end
									end
								end
							end
						end
					end)
				end
			end
		end

		if self:GetStage() == 1 then
			local sid = self.stage1Timers[event.duration]
			if sid then
				self:SetSpellID(event, sid, "direct lookup")
			elseif self:IsTimeEqual(event.duration, 70) then
				local durationCount = self:IncreaseDurationCount(event.duration)
				if durationCount % 4 == 1 then
					self:SetSpellID(event, self.s.DEATHS_DIRGE)
				elseif durationCount % 4 == 2 then
					self:SetSpellID(event, self.s.HEAVENS_GLAIVES)
				elseif durationCount % 4 == 3 then
					self:SetSpellID(event, self.s.DARK_QUASAR)
				else
					self:SetSpellID(event, self.s.SAFEGUARD_PRISM)
				end
			end
		elseif self:GetStage() == 2 and self:GetStageTime() < 75 then
			local sid = self.stage2Timers[event.duration]
			if sid then
				self:SetSpellID(event, sid, "direct lookup")
			elseif self:IsTimeEqual(event.duration, 30) then
				local durationCount = self:IncreaseDurationCount(event.duration)
				if durationCount % 2 == 1 then
					self:SetSpellID(event, self.s.GALVANIZE, "counter for 30s Galvanize vs 30s Core Harvest")
				else
					self:SetSpellID(event, self.s.CORE_HARVEST, "counter for 30s Galvanize vs 30s Core Harvest")
				end
			end
		elseif self:GetStage() == 3 and self:GetStageTime() > 1 then
			local sid = self.stage3Timers[event.duration]
			if sid then
				self:SetSpellID(event, sid, "direct lookup")
			elseif self:IsTimeEqual(event.duration, 38) then
				local durationCount = self:IncreaseDurationCount(event.duration)
				if durationCount % 2 == 1 then
					self:SetSpellID(event, self.s.THE_DARK_ARCHANGEL)
				else
					self:SetSpellID(event, self.s.LIGHT_SIPHON)
				end
			else
				for time, spellID in pairs(self.stage3Timers) do
					if self:IsTimeEqual(event.duration, time) then
						self:SetSpellID(event, spellID, "fallback loop")
						break
					end
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)

	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({ -- Mythic
	version = 5,
	encounterID = 3183,
	difficultyID = 16,
	overrideStageEvents = true,
	name = "Midnight Falls",
	s = {
		-- p1
		DARK_QUASAR = 1279420,
		HEAVENS_LANCE = 1267049,
		GRIM_SYMPHONY = 1284980,
		HEAVENS_GLAIVES = 1253915,
		TERMINATION_PRISM = 1284931,
		TOTAL_ECLIPSE = 1261871,

		-- p1.5 ?
		INTO_THE_DARKWELL = 1282047,

		-- p2
		DARK_MELTDOWN = 1281194,
		CORE_HARVEST = 1282412,
		GALVANIZE = 1284525,
		-- HEAVENS_LANCE = 1267049,

		-- p3
		LIGHT_SIPHON = 1266897,
		DARK_CONSTELLATION = 1266388,
		THE_DARK_ARCHANGEL = 1250898,
		-- HEAVENS_LANCE = 1267049,
		SHATTERED_SKY = 1249796,
		DEATHS_REQUIEM = 1273158,

		--p4
		STARSPLINTER = 1282441,
		HEAVEN_AND_HELL= 1276525,
		MIDNIGHT_PERPETUAL = 1287447,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)

		self.stage1Timers = {
			[3] = self.s.TERMINATION_PRISM,
			[26] = self.s.HEAVENS_GLAIVES,
			[31] = self.s.GRIM_SYMPHONY,
			[57] = self.s.DARK_QUASAR,
			[180] = self.s.TOTAL_ECLIPSE,

			[20] = self.s.HEAVENS_LANCE,
		}
		self.stage2Timers = {
			[97] = self.s.DARK_MELTDOWN,
			[33] = self.s.CORE_HARVEST,
			[13] = self.s.GALVANIZE,
			[20] = self.s.HEAVENS_LANCE,
		}
		self.stage3Timers = {
			[40] = self.s.HEAVENS_LANCE,
			[30] = self.s.HEAVENS_LANCE,
			[57] = self.s.THE_DARK_ARCHANGEL,
			[55] = self.s.THE_DARK_ARCHANGEL,

			[23] = self.s.DARK_CONSTELLATION,
			[4] = self.s.DARK_CONSTELLATION,
			[6] = self.s.DARK_CONSTELLATION,
			[7] = self.s.DARK_CONSTELLATION,
		}

		self.awaitingP4 = false
	end,
	onStageChanged = function(self, newStage)
		self:ResetDurationCounts()
	end,
	onEventAdded = function(self, event)
		if self:GetNoteStageTime() > 5 then
			if self:GetNoteStage() == 1 then
				if self:IsTimeEqual(event.duration, 45) then
					self:SetNoteStage(2)
					self:SetStage(1.5)
					self:SetSpellID(event, self.s.INTO_THE_DARKWELL, "p1.5 trigger")
				end
			elseif self:GetNoteStage() == 2 then
				if self:IsTimeEqual(event.duration, 97) then
					self:SetNoteStage(3)
					self:SetStage(2)
					-- self:SetSpellID(event, self.s.DARK_MELTDOWN, "p2 trigger")
				end
			elseif self:GetNoteStage() == 3 then
				if self:IsTimeEqual(event.duration, 180, 2) then
					self:SetNoteStage(4)
				end
			end
		end

		if self:GetStage() == 1 then
			local sid = self.stage1Timers[event.duration]
			if sid then
				self:SetSpellID(event, sid, "direct lookup")
			elseif self:IsTimeEqual(event.duration, 62) then
				local durationCount = self:IncreaseDurationCount(event.duration)
				if durationCount % 4 == 1 then
					self:SetSpellID(event, self.s.TERMINATION_PRISM)
				elseif durationCount % 4 == 2 then
					self:SetSpellID(event, self.s.HEAVENS_GLAIVES)
				elseif durationCount % 4 == 3 then
					self:SetSpellID(event, self.s.GRIM_SYMPHONY)
				else
					self:SetSpellID(event, self.s.DARK_QUASAR)
				end
			else
				for time, spellID in pairs(self.stage1Timers) do
					if self:IsTimeEqual(event.duration, time) then
						self:SetSpellID(event, spellID, "fallback loop")
						break
					end
				end
			end
		elseif self:GetStage() == 2 and self:GetStageTime() < 75 then
			local sid = self.stage2Timers[event.duration]
			if sid then
				self:SetSpellID(event, sid, "direct lookup")
			elseif self:IsTimeEqual(event.duration, 30) then
				local durationCount = self:IncreaseDurationCount(event.duration)
				if durationCount % 2 == 1 then
					self:SetSpellID(event, self.s.GALVANIZE, "counter for 30s Galvanize vs 30s Core Harvest")
				else
					self:SetSpellID(event, self.s.CORE_HARVEST, "counter for 30s Galvanize vs 30s Core Harvest")
				end
			else
				for time, spellID in pairs(self.stage2Timers) do
					if self:IsTimeEqual(event.duration, time) then
						self:SetSpellID(event, spellID, "fallback loop")
						break
					end
				end
			end
		elseif self:GetStage() == 3 then
			local sid = self.stage3Timers[event.duration]
			if sid then
				self:SetSpellID(event, sid, "direct lookup")
			else
				local durationCount = self:IncreaseDurationCount(event.duration)
				if self:IsTimeEqual(event.duration, 18) then
					if durationCount == 1 then
						self:SetSpellID(event, self.s.LIGHT_SIPHON)
					elseif durationCount == 2 then
						self:SetSpellID(event, self.s.DEATHS_REQUIEM)
					end
				elseif self:IsTimeEqual(event.duration, 20) and durationCount == 1 then
					self:SetSpellID(event, self.s.DARK_CONSTELLATION)
				elseif self:IsTimeEqual(event.duration, 20) or self:IsTimeEqual(event.duration, 35) then
					if durationCount % 2 == 0 then
						self:SetSpellID(event, self.s.LIGHT_SIPHON)
					else
						self:SetSpellID(event, self.s.DEATHS_REQUIEM)
					end
				elseif self:IsTimeEqual(event.duration, 180) then
					self:SetSpellID(event, self.s.SHATTERED_SKY)
					self:Schedule(13, function()
						-- start listening for p4
						self.awaitingP4 = true
					end)
				else
					for time, spellID in pairs(self.stage3Timers) do
						if self:IsTimeEqual(event.duration, time) then
							self:SetSpellID(event, spellID, "fallback loop")
							break
						end
					end
				end
			end
		end
	end,
	onUnitEngage = function(self)
		if self.awaitingP4 and self:GetStage() == 3 and UnitExists("boss1") and not UnitExists("boss2") then
			self:SetStage(4)
			self:SetNoteStage(5)
			self.awaitingP4 = false

			self:AddEvent(self.s.MIDNIGHT_PERPETUAL, 79)

			local function StarsplinterRepeater()
				self:AddEvent(self.s.STARSPLINTER, 20)
				self:Schedule(20, StarsplinterRepeater)
			end
			self:AddEvent(self.s.STARSPLINTER, 12.7)
			self:Schedule(12.7, StarsplinterRepeater)

			local function HeavenHellRepeater()
				self:AddEvent(self.s.HEAVEN_AND_HELL, 20)
				self:Schedule(20, HeavenHellRepeater)
			end
			self:AddEvent(self.s.HEAVEN_AND_HELL, 19.9)
			self:Schedule(19.9, HeavenHellRepeater)
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID == self.s.DARK_MELTDOWN and event:IsFinished() then
			self:Schedule(7.8, function()
				self:SetStage(3)
				self:SetNoteStage(4)
			end)
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
