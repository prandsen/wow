local LSM = LibStub("LibSharedMedia-3.0")
local koKR, ruRU, zhCN, zhTW, western = LSM.LOCALE_BIT_koKR, LSM.LOCALE_BIT_ruRU, LSM.LOCALE_BIT_zhCN, LSM.LOCALE_BIT_zhTW, LSM.LOCALE_BIT_western

local MediaType_BACKGROUND = LSM.MediaType.BACKGROUND
local MediaType_BORDER = LSM.MediaType.BORDER
local MediaType_FONT = LSM.MediaType.FONT
local MediaType_STATUSBAR = LSM.MediaType.STATUSBAR

-- ----- 
-- BACKGROUND 
-- ----- 

-- ----- 
--  BORDER 
-- ---- 

-- -----
--   FONT
-- -----
LSM:Register(MediaType_FONT, "ITCAvantGardeGothicDemi", [[Interface\Addons\SharedMedia_MyMedia\fonts\ITCAvantGardeGothicDemi.ttf]], ruRU + western)

-- -----
--   SOUND
-- -----

-- -----
--   STATUSBAR
-- -----
LSM:Register(MediaType_STATUSBAR, "Arrows Target", [[Interface\Addons\SharedMedia_MyMedia\textures\Arrows_Target.tga]])