local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({ -- Normal
	version = 1,
	encounterID = 3181,
	difficultyID = 14,
	name = "Crown of the Cosmos",
	s = {
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
		self.pullTimers = {
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStageTime() > 8 then
			if self:GetStage() == 1 and self:IsTimeEqual(event.duration, 1.5) then -- Серебрянный шквал
				self:SetStage(1.5)
				self:SetNoteStage(2)
			elseif self:GetStage() == 1.5 and self:IsTimeEqual(event.duration, 24, 1) then -- Космическая преграда
				self:SetStage(2)
				self:SetNoteStage(3)
			elseif self:GetStage() == 2 and self:IsTimeEqual(event.duration, 1.5) then -- Серебрянный шквал
				self:SetStage(2.5)
				self:SetNoteStage(4)
			elseif self:GetStage() == 2.5 and self:IsTimeEqual(event.duration, 60) then -- Пожирающий космос
				self:SetStage(3)
				self:SetNoteStage(5)
			end
		end

		if self:GetStage() == 2 and self:GetStageTime() < 1 then
			if self:IsTimeEqual(event.duration, 16) then -- Выброс бездны
				self:SetSpellID(event, 1255368)
			end
		elseif self:GetStage() == 3 and self:GetStageTime() < 1 then
			if self:IsTimeEqual(event.duration, 19) then -- Хватка пустоты
				self:SetSpellID(event, 1232467)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID and event:IsFinished() then
			if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({ -- Any
	version = 3,
	encounterID = 3181,
	name = "Crown of the Cosmos",
	s = {
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)
	end,
	onEventAdded = function(self, event)
		if self:GetStageTime() > 8 then
			if self:GetStage() == 1 and self:IsTimeEqual(event.duration, 1.5) then -- Серебрянный шквал
				self:SetStage(1.5)
				self:SetNoteStage(2)
			elseif self:GetStage() == 1.5 and self:IsTimeEqual(event.duration, 24, 1) then -- Космическая преграда
				self:SetStage(2)
				self:SetNoteStage(3)
			elseif self:GetStage() == 2 and self:IsTimeEqual(event.duration, 1.5) then -- Серебрянный шквал
				self:SetStage(2.5)
				self:SetNoteStage(4)
			elseif self:GetStage() == 2.5 and self:IsTimeEqual(event.duration, 60) then -- Пожирающий космос
				self:SetStage(3)
				self:SetNoteStage(5)
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
	end,
	onEventRemoved = function(self, event)
	end,
})

TimelineParser:RegisterBossMod({ -- Mythic
	version = 18,
	encounterID = 3181,
	difficultyID = 16,
	name = "Crown of the Cosmos",
	s = {
		-- p1
		RAVENOUS_ABYSS = 1243753,
		DARK_HAND = 1233787,
		INTERRUPTING_TREMOR = 1243743,
		NULL_CORONA = 1233865,
		VOID_EXPULSION = 1233819,
		SILVERSTRIKE_ARROW = 1233602,
		GRASP_OF_EMPTINESS = 1260026,
		-- GRASP_OF_EMPTINESS = 1232467,

		-- p1.5
		SILVERSTRIKE_BARRAGE = 1234564,

		-- p2
		STAGE_TWO = 1272966,
		-- GRASP_OF_EMPTINESS = 1260026,
		RIFT_SLASH = 1246461,
		RANGER_CAPTAINS_MARK = 1260010,
		-- VOID_EXPULSION = 1233819,
		RIFT_SIMULACRUM = 1261016,
		CALL_OF_THE_VOID = 1237837,
		VOIDSTALKER_STING = 1237035,

		-- p3
		-- GRASP_OF_EMPTINESS = 1260026,
		ASPECT_OF_THE_END = 1239080,
		-- VOID_EXPULSION = 1233819,
		DEVOURING_COSMOS = 1238843,
		COSMIC_PORTAL = 1261339,
		-- NULL_CORONA = 1233865,
		-- RIFT_SIMULACRUM = 1261016,
		-- VOIDSTALKER_STING = 1237035,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:SetNoteStage(1)

		self.p2TimersPending = false
		self.p3Platform = nil
		self.lastSimulacrumTime = 0

		self.pullTimers = {
			[1.666] = self.s.NULL_CORONA,
			-- [4] = { self.s.RAVENOUS_ABYSS, self.s.DARK_HAND, self.s.INTERRUPTING_TREMOR }, -- cba
			[4.166] = self.s.GRASP_OF_EMPTINESS,
			[10] = self.s.VOID_EXPULSION,
			[20] = self.s.SILVERSTRIKE_ARROW,
			[103.75] = self.s.GRASP_OF_EMPTINESS,
		}

		self.stage1TimersResolve = {
			[26] = self.s.DARK_HAND,

			[3.75] = self.s.GRASP_OF_EMPTINESS,
			[4] = self.s.GRASP_OF_EMPTINESS,
			[23] = self.s.GRASP_OF_EMPTINESS,
			[23.333] = self.s.GRASP_OF_EMPTINESS,
			[26.25] = self.s.GRASP_OF_EMPTINESS,
			[26.3] = self.s.GRASP_OF_EMPTINESS,
			[26.666] = self.s.GRASP_OF_EMPTINESS,
			[27] = self.s.GRASP_OF_EMPTINESS,
			[103] = self.s.GRASP_OF_EMPTINESS,
			[103.333] = self.s.GRASP_OF_EMPTINESS,

			[1.25] = self.s.NULL_CORONA,
			[22.5] = self.s.NULL_CORONA,
			[37.083] = self.s.NULL_CORONA,
			[37] = self.s.NULL_CORONA,
			-- [40] = self.s.NULL_CORONA,

			[19.5] = self.s.RAVENOUS_ABYSS,

			[17.5] = self.s.SILVERSTRIKE_ARROW,
			[18] = self.s.SILVERSTRIKE_ARROW,
			[19] = self.s.SILVERSTRIKE_ARROW,
			[19.166] = self.s.SILVERSTRIKE_ARROW,
			[19.583] = self.s.SILVERSTRIKE_ARROW,

			[20] = self.s.INTERRUPTING_TREMOR,

			[9.583] = self.s.VOID_EXPULSION,
			[10] = self.s.VOID_EXPULSION,
			[32] = self.s.VOID_EXPULSION,
			[32.5] = self.s.VOID_EXPULSION,
			-- [40] = self.s.VOID_EXPULSION,
		}
		--[[
		10 Void Expulsion 40
		38 Null Corona 40
		1:49 Void Expulsion 40
		]]

		self.stage2Timers = {
			[1.5] = self.s.RIFT_SIMULACRUM,
			[6] = {self.s.RIFT_SLASH, self.s.CALL_OF_THE_VOID},
			[12] = self.s.VOIDSTALKER_STING,
			[13] = self.s.GRASP_OF_EMPTINESS,
			[27] = self.s.RANGER_CAPTAINS_MARK,
			[20] = self.s.VOID_EXPULSION,
		}

		self.stage2TimersResolve = {
			[18] = self.s.VOID_EXPULSION,
			[20] = self.s.VOID_EXPULSION,

			[12] = self.s.RIFT_SLASH,
			[16] = self.s.RIFT_SLASH,
			-- [4] = self.s.RIFT_SLASH,
			-- [6] = self.s.RIFT_SLASH,

			[50] = self.s.CALL_OF_THE_VOID,
			-- [4] = self.s.CALL_OF_THE_VOID,
			-- [6] = self.s.CALL_OF_THE_VOID,
			-- [25] = self.s.CALL_OF_THE_VOID,

			[11] = self.s.GRASP_OF_EMPTINESS,
			[13] = self.s.GRASP_OF_EMPTINESS,
			-- [25] = self.s.GRASP_OF_EMPTINESS,

			[2] = self.s.VOIDSTALKER_STING,
			[10] = self.s.VOIDSTALKER_STING,
			[23] = self.s.VOIDSTALKER_STING,

			-- [25] = self.s.RANGER_CAPTAINS_MARK,
		}
		--[[
		2:51 Rift slash 6
		2:51 Call of the Void 6
		3:04 Grasp of Emptiness 25
		3:11 Void Expulsion 25
		3:18 Ranger Captain's Mark 25
		3:45 Rift slash 4
		3:45 Ranger Captain's Mark 25
		3:45 Call of the Void 4
		3:56 Grasp of Emptiness 25
		4:03 Void Expulsion 25
		4:10 Ranger Captain's Mark 25


		2:51 Rift slash 6
		2:51 Call of the Void 6
		3:04 Grasp of Emptiness 25
		3:11 Void Expulsion 25
		3:18 Ranger Captain's Mark 25
		3:45 Rift slash 4
		3:45 Ranger Captain's Mark 25
		3:45 Call of the Void 4
		3:56 Grasp of Emptiness 25


		2:55 Rift slash 6
		2:55 Call of the Void 6
		3:08 Grasp of Emptiness 25
		3:15 Void Expulsion 25
		3:22 Ranger Captain's Mark 25
		3:49 Rift slash 4
		3:49 Ranger Captain's Mark 25
		3:49 Call of the Void 4
		4:00 Grasp of Emptiness 25
		4:07 Void Expulsion 25
		4:14 Ranger Captain's Mark 25
		4:41 Rift slash 4
		4:41 Ranger Captain's Mark 25
		4:41 Call of the Void 4
		5:02 Phase 3
		]]

		self.stage3Timers = {
			[7] = self.s.ASPECT_OF_THE_END,
			[10] = self.s.GRASP_OF_EMPTINESS,
			[12] = self.s.RIFT_SIMULACRUM,
			[15] = self.s.COSMIC_PORTAL,
			[16] = self.s.VOIDSTALKER_STING,
			[30] = self.s.NULL_CORONA,
			[37] = self.s.VOID_EXPULSION,
			[60] = self.s.DEVOURING_COSMOS,
		}

		self.stage3TimersResolve = {
			[20] = self.s.DARK_HAND,

			[6] = self.s.ASPECT_OF_THE_END,
			[7] = self.s.ASPECT_OF_THE_END,
			[19] = self.s.ASPECT_OF_THE_END,
			[41] = self.s.ASPECT_OF_THE_END,

			[9] = self.s.GRASP_OF_EMPTINESS,
			[10] = self.s.GRASP_OF_EMPTINESS,
			[16] = self.s.GRASP_OF_EMPTINESS,
			[35] = self.s.GRASP_OF_EMPTINESS,

			[12] = self.s.VOIDSTALKER_STING,
			-- [14] = self.s.VOIDSTALKER_STING,
			[15] = self.s.VOIDSTALKER_STING,
			-- [17] = self.s.VOIDSTALKER_STING,

			[36] = self.s.VOID_EXPULSION,
			[37] = self.s.VOID_EXPULSION,

			[59] = self.s.DEVOURING_COSMOS,
			[60] = self.s.DEVOURING_COSMOS,

			[29] = self.s.NULL_CORONA,
			[30] = self.s.NULL_CORONA,

			[11] = self.s.RIFT_SIMULACRUM,
		}
		--[[
		5:02 Grasp of Emptiness 10
		5:02 Aspect of the End 7
		5:02 Void Expulsion 37
		5:02 Devouring Cosmos 60
		5:02 Cosmic Portal 15
		5:02 Null Corona 30
		5:02 Rift Simulacrum 12
		5:02 Voidstalker Sting 16
		5:09 Aspect of the End 41
		5:12 Grasp of Emptiness 9
		5:18 Ravenous Abyss 8
		5:18 Voidstalker Sting 17
		5:21 Grasp of Emptiness 35
		5:26 Ravenous Abyss 16.5
		5:34 a bunch of EVENT_REMOVED
		5:35 Voidstalker Sting 12
		5:43 Ravenous Abyss 16.5
		5:47 Voidstalker Sting 14
		5:50 Aspect of the End 19



		5:38 Grasp of Emptiness 10
		5:38 Aspect of the End 7
		5:38 Void Expulsion 37
		5:38 Devouring Cosmos 60
		5:38 Cosmic Portal 15
		5:38 Null Corona 30
		5:38 Rift Simulacrum 12
		5:38 Voidstalker Sting 16
		5:45 Aspect of the End 41
		5:48 Grasp of Emptiness 9
		5:54 Voidstalker Sting 17
		5:54 Ravenous Abyss 8
		5:57 Grasp of Emptiness 35
		6:02 Ravenous Abyss 16.5
		6:11 Voidstalker Sting 12
		6:19 Ravenous Abyss 16.5
		6:23 Voidstalker Sting 14
		6:26 Aspect of the End 19
		6:32 Grasp of Emptiness 16
		6:39 Grasp of Emptiness 9
		6:39 Aspect of the End 6
		6:39 Void Expulsion 36
		6:39 Devouring Cosmos 59
		6:39 Cosmic Portal 14
		6:39 Null Corona 29
		6:39 Rift Simulacrum 11
		6:39 Voidstalker Sting 15
		6:45 Aspect of the End 41
		6:48 Grasp of Emptiness 9
		6:54 Voidstalker Sting 17
		6:55 Interrupting Tremor 8
		6:57 Grasp of Emptiness 35


		5:23 Grasp of Emptiness 10
		5:23 Aspect of the End 7
		5:23 Void Expulsion 37
		5:23 Devouring Cosmos 60
		5:23 Cosmic Portal 15
		5:23 Null Corona 30
		5:23 Rift Simulacrum 12
		5:23 Voidstalker Sting 16
		5:30 Aspect of the End 41
		5:33 Grasp of Emptiness 9
		5:39 Voidstalker Sting 17
		5:39 Ravenous Abyss 8
		5:42 Grasp of Emptiness 35
		5:48 Ravenous Abyss 16.5
		5:56 Voidstalker Sting 12
		6:08 Voidstalker Sting 14
		6:11 Aspect of the End 19
		6:17 Grasp of Emptiness 16
		6:24 Grasp of Emptiness 9
		6:24 Aspect of the End 6
		6:24 Void Expulsion 36
		6:24 Devouring Cosmos 59
		6:24 Cosmic Portal 14
		6:24 Null Corona 29
		6:24 Rift Simulacrum 11
		6:24 Voidstalker Sting 15
		6:30 Aspect of the End 41
		6:33 Grasp of Emptiness 9
		6:39 Voidstalker Sting 17
		6:39 Interrupting Tremor 8
		6:42 Grasp of Emptiness 35
		6:48 Interruption Tremor 17
		6:56 Voidstalker Sting 12
		7:05 Interrupting Tremor 17
		7:08 Voidstalker Sting 14
		7:11 Aspect of the End 19

		]]

	end,
	onStageChanged = function(self, stage)
		self:ResetDurationCounts()
		self:ResetAllSpellCounts()
	end,
	onEventAdded = function(self, event)
		if self:GetNoteStageTime() > 5 then
			if self:GetNoteStage() == 1 then
				local added = 0
				for e in self:IterateEvents() do
					if e:SinceAdded() < 0.1 and (e.duration == 1.5 or e.duration == 25) then
						added = added + 1
					end
				end
				if added >= 2 then
					-- self:SetStage(1.5)
					self:SetNoteStage(2)
				end
			elseif self:GetNoteStage() == 2 or self:GetNoteStage() == 4 then
				local added = 0
				for e in self:IterateEvents() do
					if e:SinceAdded() < 0.1 then
						added = added + 1
					end
				end

				if added >= 4 then
					if self:GetNoteStage() == 2 then
						-- self:SetStage(2)
						self:SetNoteStage(3)
					elseif self:GetNoteStage() == 4 then
						-- self:SetStage(3)
						self:SetNoteStage(5)
					end
				end
			end
		end

		if self.p2TimersPending then
			self.p2TimersPending = false
			self:SetStage(2)
		end

		if self:GetStage() == 1 then
			if self:GetStageTime() < 1 then
				for time, spellID in pairs(self.pullTimers) do
					if self:IsTimeEqual(event.duration, time) then
						self:SetSpellID(event, spellID)
						break
					end
				end
			elseif self:IsTimeEqual(event.duration, 1.5) then
				self:SetStage(1.5)
				self:SetSpellID(event, self.s.SILVERSTRIKE_BARRAGE)
			else
				local sid = self.stage1TimersResolve[event.duration]
				if sid then
					self:SetSpellID(event, sid, "direct lookup")
				elseif self:IsTimeEqual(event.duration, 40) then
					local durationCount = self:IncreaseDurationCount(event.duration)
					if durationCount == 2 then
						self:SetSpellID(event, self.s.NULL_CORONA, "40 second spell 1", durationCount)
					else
						self:SetSpellID(event, self.s.VOID_EXPULSION, "40 second spell 2", durationCount)
					end
				else
					for time, spellID in pairs(self.stage1TimersResolve) do
						if self:IsTimeEqual(event.duration, time, 0.025) then -- non default margin
							self:SetSpellID(event, spellID, "iterate match")
							break
						end
					end
				end
			end
		elseif self:GetStage() == 1.5 then
			if self:IsTimeEqual(event.duration, 25) then
				self:SetSpellID(event, self.s.STAGE_TWO)
			elseif self:IsTimeEqual(event.duration, 6) then
				self:SetSpellID(event, self.s.SILVERSTRIKE_BARRAGE)
			end
		elseif self:GetStage() == 2 then
			if self:GetStageTime() < 1 then
				for time, spellID in pairs(self.stage2Timers) do
					if self:IsTimeEqual(event.duration, time) then
						if type(spellID) == "table" then
							local sid = tremove(spellID, 1)
							if sid then
								self:SetSpellID(event, sid)
							else
								TimelineParser:Log("Warning: no more spellIDs left for time "..time.." in stage 2 timers")
							end
						else
							self:SetSpellID(event, spellID)
						end
						break
					end
				end
			else
				local sid = self.stage2TimersResolve[event.duration]
				if sid then
					self:SetSpellID(event, sid, "direct lookup")
				elseif self:IsTimeEqual(event.duration, 4) then
					local durationCount = self:IncreaseDurationCount(event.duration)
					if durationCount % 2 == 1 then
						self:SetSpellID(event, self.s.RIFT_SLASH, "4 second spell 1", durationCount)
					else
						self:SetSpellID(event, self.s.CALL_OF_THE_VOID, "4 second spell 2", durationCount)
					end
				elseif self:IsTimeEqual(event.duration, 6) then
					local durationCount = self:IncreaseDurationCount(event.duration)
					if durationCount == 1 then
						self:SetSpellID(event, self.s.RIFT_SLASH, "6 second spell 1", durationCount)
					elseif durationCount == 2 then
						self:SetSpellID(event, self.s.CALL_OF_THE_VOID, "6 second spell 2", durationCount)
					end
				elseif self:IsTimeEqual(event.duration, 25) then
					local durationCount = self:IncreaseDurationCount(event.duration)
					if durationCount % 4 == 1 then -- 1
						self:SetSpellID(event, self.s.GRASP_OF_EMPTINESS, "25 second spell 1", durationCount)
					elseif durationCount % 4 == 2 then -- 2
						self:SetSpellID(event, self.s.VOID_EXPULSION, "25 second spell 2", durationCount)
					else -- 3/4
						self:SetSpellID(event, self.s.RANGER_CAPTAINS_MARK, "25 second spell 1", durationCount)
					end
				else
					for time, spellID in pairs(self.stage2TimersResolve) do
						if self:IsTimeEqual(event.duration, time) then
							self:SetSpellID(event, spellID)
							break
						end
					end
				end
			end
		elseif self:GetStage() == 2.5 then
			if self:GetStageTime() > 2  then
				self:SetStage(3)
				self.p3Platform = 1
			end
		end

		if self:GetStage() == 3 then
			-- if self.p3Platform == 1
			if self:GetStageTime() < 1 then
				for time, spellID in pairs(self.stage3Timers) do
					if self:IsTimeEqual(event.duration, time) then
						self:SetSpellID(event, spellID)
						break
					end
				end
			else
				local sid = self.stage3TimersResolve[event.duration]
				if sid then
					self:SetSpellID(event, sid, "direct lookup")
				elseif self:IsTimeEqual(event.duration, 14) then
					local durationCount = self:IncreaseDurationCount(event.duration)
					local riftSimulacrumCount = self:GetSpellCount(self.s.RIFT_SIMULACRUM)
					if riftSimulacrumCount == 3 then
						if durationCount % 3 == 1 then
							self:SetSpellID(event, self.s.COSMIC_PORTAL, "14 second spell 1", durationCount)
						elseif durationCount % 3 == 2 then
							self:SetSpellID(event, self.s.DARK_HAND, "14 second spell 2", durationCount)
						elseif durationCount % 3 == 0 then
							self:SetSpellID(event, self.s.VOIDSTALKER_STING, "14 second spell 3", durationCount)
						end
					else
						if durationCount % 2 == 1 then
							self:SetSpellID(event, self.s.VOIDSTALKER_STING, "14 second spell 1", durationCount)
						else
							self:SetSpellID(event, self.s.COSMIC_PORTAL, "14 second spell 2", durationCount)
						end
					end
				else
					-- 4 seconds after event finishes + 8 seconds
					local addCantDo17SecondsTimer = (self.lastSimulacrumTime + 8) > GetTime()
					local riftSimulacrumCount = self:GetSpellCount(self.s.RIFT_SIMULACRUM)
					if self:IsTimeEqual(event.duration, 17) and addCantDo17SecondsTimer then
						self:SetSpellID(event, self.s.VOIDSTALKER_STING, "17 second spell")
					elseif riftSimulacrumCount == 1 and (self:IsTimeEqual(event.duration, 8) or self:IsTimeEqual(event.duration, 16.5)) then
						self:SetSpellID(event, self.s.RAVENOUS_ABYSS, "8/16.5 second spell with 1 simulacrum")
					elseif riftSimulacrumCount == 2 and (self:IsTimeEqual(event.duration, 8) or self:IsTimeEqual(event.duration, 17)) then
						self:SetSpellID(event, self.s.INTERRUPTING_TREMOR, "8/17 second spell with 2 simulacra")
					elseif riftSimulacrumCount == 4 and self:IsTimeEqual(event.duration, 8) then -- all adds are up
						local durationCount = self:IncreaseDurationCount(event.duration)
						if durationCount == 1 then -- order can change
							self:ResetSpellCount(self.s.INTERRUPTING_TREMOR)
							self:SetSpellID(event, self.s.INTERRUPTING_TREMOR, "8 second spell with 4 simulacra 1", durationCount)
						elseif durationCount == 2 then
							self:ResetSpellCount(self.s.RAVENOUS_ABYSS)
							self:SetSpellID(event, self.s.RAVENOUS_ABYSS, "8 second spell with 4 simulacra 2", durationCount)
						end
					else
						for time, spellID in pairs(self.stage3TimersResolve) do
							if self:IsTimeEqual(event.duration, time) then
								self:SetSpellID(event, spellID, "resolved spell")
								break
							end
						end
					end
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if self:GetStage() == 2 and self:GetStageTime() > 15 then
			if self:EventsCanceledInLast(0.1) >= 3 then
				self:SetStage(2.5)
				self:SetNoteStage(4)
			end
		end

		-- if self:GetEncounterTime() > 3 and self:GetEncounterTime() < 7 then return end
		-- if self:GetStage() == 2 and self:GetStageTime() < 7.5 then return end
		-- if self:GetStage() == 2.5 then return end

		local spellID = event:GetSpellID()
		if spellID then
			if self:GetStage() == 1.5 then
				if spellID == self.s.STAGE_TWO then
					self.p2TimersPending = true
				end
			elseif self:GetStage() == 3 then
				if spellID == self.s.DEVOURING_COSMOS then
					self.p3Platform = self.p3Platform + 1
				elseif spellID == self.s.RIFT_SIMULACRUM then
					self.lastSimulacrumTime = GetTime()
				end
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
