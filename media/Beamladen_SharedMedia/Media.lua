local LSM = LibStub("LibSharedMedia-3.0")
local ruRU, western = LSM.LOCALE_BIT_ruRU, LSM.LOCALE_BIT_western

local SOUNDS_BASE_PATH  = "Interface\\AddOns\\Beamladen_SharedMedia\\sounds\\"
local FONTS_BASE_PATH  = "Interface\\AddOns\\Beamladen_SharedMedia\\fonts\\"
local TEXTURES_BASE_PATH = "Interface\\AddOns\\Beamladen_SharedMedia\\textures\\"

function BuildLabel(label)
    return "|cFFFF7C0ABeamladen - " .. label .. "|r"
end

-- ----- 
-- BACKGROUND 
-- ----- 

-- ----- 
--  BORDER 
-- ---- 

-- -----
--   FONT
-- -----
local FONTS = {
    { "ITCAvantGardeGothicDemi", "ITCAvantGardeGothicDemi.ttf", ruRU + western }
}
for _, entry in ipairs(FONTS) do
    local label, file, locale_bit = entry[1], entry[2], entry[3]
    LSM:Register("font", BuildLabel(label), FONTS_BASE_PATH .. file, locale_bit)
end

-- -----
--   SOUND
-- -----
local SOUNDS = {
    { "Adds", "adds.ogg" },
    { "AOE", "aoe.ogg" },
    { "Beam", "beam.ogg" },
    { "Bombs", "bombs.ogg" },
    { "Collect", "collect.ogg" },
    { "Deffensive", "deffensive.ogg" },
    { "Debuff", "debuff.ogg" },
    { "Dispell", "dispell.ogg" },
    { "Dodge", "dodge.ogg" },
    { "Don't Move", "dontmove.ogg" },
    { "Feet", "feet.ogg" },
    { "Dance", "dance.ogg" },
    { "Frontal", "frontal.ogg" },
    { "Gate", "gate.ogg" },
    { "Intermission", "intermission.ogg" },
    { "Interrupt", "interrupt.ogg" },
    { "Run", "run.ogg" },
    { "Soak", "soak.ogg" },
    { "Spread", "spread.ogg" },
    { "Switch", "switch.ogg" },
    { "Wave", "wave.ogg" },
    { "Knockback", "knockback.ogg" },
    { "Fixate", "fixate.ogg" },
    { "Stopcast", "stopcast.ogg" },
    { "Move", "move.ogg" },
    { "Time Spiral", "timespiral.ogg" },
    { "Bait", "bait.ogg" },
    { "Hide", "hide.ogg" },
    { "Add", "add.ogg" },
    { "Clear", "clear.ogg" },
    { "Bloodlust", "bloodlust.ogg" },
    { "Damage Phase", "dmg.ogg" },
    { "Targeted", "targeted.ogg" },
    { "Bomb", "bomb.ogg" },
    { "Jump", "jump.ogg" },
    { "Stack", "stack.ogg" },
}
for _, entry in ipairs(SOUNDS) do
    local label, file = entry[1], entry[2]
    LSM:Register("sound", BuildLabel(label), SOUNDS_BASE_PATH .. file)
end

-- -----
--   STATUSBAR
-- -----
local STATUS_BARS = {
    { "Arrows Target", "Arrows_Target.tga" },
    { "Arrows Mouseover", "Arrows_Mouseover.tga" },
}
for _, entry in ipairs(STATUS_BARS) do
    local label, file = entry[1], entry[2]
    LSM:Register("statusbar", BuildLabel(label), TEXTURES_BASE_PATH .. file)
end