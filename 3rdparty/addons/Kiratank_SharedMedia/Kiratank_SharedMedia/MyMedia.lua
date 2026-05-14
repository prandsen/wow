local LSM = LibStub("LibSharedMedia-3.0")
local MediaType_SOUND     = LSM.MediaType.SOUND
local MediaType_STATUSBAR = LSM.MediaType.STATUSBAR

local SOUND_PATH     = [[Interface\Addons\Kiratank_SharedMedia\sounds\]]
local STATUSBAR_PATH = [[Interface\Addons\Kiratank_SharedMedia\statusbars\]]

-- Statusbar textures
LSM:Register(MediaType_STATUSBAR, "|cFF00FF00Kira - Norm|r",  STATUSBAR_PATH .. "Kira_Norm")
LSM:Register(MediaType_STATUSBAR, "|cFF00FF00Kira - Solid|r", STATUSBAR_PATH .. "Kira_Solid")
LSM:Register(MediaType_STATUSBAR, "|cFF00FF00Kira - Melli|r", STATUSBAR_PATH .. "Kira_Melli")

-- Original 6
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Apex|r",         SOUND_PATH .. "apex.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Proc|r",         SOUND_PATH .. "proc.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Tank Hit|r",     SOUND_PATH .. "tankhit.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Dispel|r",       SOUND_PATH .. "dispel.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Cheat Death|r",  SOUND_PATH .. "cheatdeath.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Use|r",          SOUND_PATH .. "use.ogg")

-- Batch 2
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Ravage|r",       SOUND_PATH .. "ravage.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - DRW|r",          SOUND_PATH .. "drw.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Battle Stance|r",SOUND_PATH .. "battlestance.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Rebuff|r",       SOUND_PATH .. "rebuff.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Dwarf|r",        SOUND_PATH .. "dwarf.ogg")

-- Batch 3
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Cheat Death Back|r", SOUND_PATH .. "cheatdeathback.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Bloodlust|r",    SOUND_PATH .. "bloodlust.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - External|r",     SOUND_PATH .. "external.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Noob|r",         SOUND_PATH .. "noob.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Bear Form|r",    SOUND_PATH .. "bearform.ogg")

-- Batch 4
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Wings|r",        SOUND_PATH .. "wings.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Wings Out|r",    SOUND_PATH .. "wingsout.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Bubble|r",       SOUND_PATH .. "bubble.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Spellward|r",    SOUND_PATH .. "spellward.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Bubble Out|r",   SOUND_PATH .. "bubbleout.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Spellward Out|r",SOUND_PATH .. "spellwardout.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Potion|r",       SOUND_PATH .. "potion.ogg")

-- Batch 5
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Soak|r",         SOUND_PATH .. "soak.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Heal|r",         SOUND_PATH .. "heal.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Watch|r",        SOUND_PATH .. "watch.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Run|r",          SOUND_PATH .. "run.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Move|r",         SOUND_PATH .. "move.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Dodge|r",        SOUND_PATH .. "dodge.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Dispell|r",      SOUND_PATH .. "dispell.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Ress|r",         SOUND_PATH .. "ress.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Dead|r",         SOUND_PATH .. "dead.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Add|r",          SOUND_PATH .. "add.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Adds|r",         SOUND_PATH .. "adds.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Intermission|r", SOUND_PATH .. "intermission.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Damage Amp|r",   SOUND_PATH .. "damageamp.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Kick|r",         SOUND_PATH .. "kick.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Jump|r",         SOUND_PATH .. "jump.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Bait|r",         SOUND_PATH .. "bait.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Knock|r",        SOUND_PATH .. "knock.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Hide|r",         SOUND_PATH .. "hide.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Clean|r",        SOUND_PATH .. "clean.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Debuffs|r",      SOUND_PATH .. "debuffs.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - AoE|r",          SOUND_PATH .. "aoe.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Frontal|r",      SOUND_PATH .. "frontal.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Spread|r",       SOUND_PATH .. "spread.ogg")
LSM:Register(MediaType_SOUND, "|cFF00FF00Kira - Shields|r",      SOUND_PATH .. "shields.ogg")
