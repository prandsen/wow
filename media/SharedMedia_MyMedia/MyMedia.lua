local LSM = LibStub("LibSharedMedia-3.0")
local ruRU, western = LSM.LOCALE_BIT_ruRU, LSM.LOCALE_BIT_western

-- ----- 
-- BACKGROUND 
-- ----- 

-- ----- 
--  BORDER 
-- ---- 

-- -----
--   FONT
-- -----
LSM:Register("font", "ITCAvantGardeGothicDemi", [[Interface\Addons\SharedMedia_MyMedia\fonts\ITCAvantGardeGothicDemi.ttf]], ruRU + western)

-- -----
--   SOUND
-- -----

-- -----
--   STATUSBAR
-- -----
LSM:Register("statusbar", "Arrows Target", [[Interface\Addons\SharedMedia_MyMedia\textures\Arrows_Target.tga]])
LSM:Register("statusbar", "Arrows Mouseover", [[Interface\Addons\SharedMedia_MyMedia\textures\Arrows_Mouseover.tga]])