
NaowhQOLDB = {
["char"] = {
["Сорчистино - Свежеватель Душ"] = {
["migrationCompleted"] = true,
},
["Вольтчара - Свежеватель Душ"] = {
["migrationCompleted"] = true,
},
["Бимладен - Ревущий фьорд"] = {
["migrationCompleted"] = true,
},
["Мальдика - Свежеватель Душ"] = {
["migrationCompleted"] = true,
},
},
["global"] = {
["defaultsV2Migrated"] = true,
["profileSnapshotMigrated"] = true,
["savedProfiles"] = {
["All classes"] = true,
},
},
["profileKeys"] = {
["Бимладен - Ревущий фьорд"] = "All classes",
["Сорчистино - Свежеватель Душ"] = "Default",
},
["profiles"] = {
["All classes"] = {
["misc"] = {
["hideTalkingHead"] = true,
["durabilityWarning"] = true,
["autoSlotKeystone"] = true,
["ahCurrentExpansion"] = true,
["durabilityFont"] = "ITCAvantGardeGothicDemi",
},
["general"] = {
["globalFont"] = "ITCAvantGardeGothicDemi",
},
["rangeCheck"] = {
["hideSuffix"] = false,
["rangeWidth"] = 172,
["rangeHeight"] = 60,
["rangeFont"] = "ITCAvantGardeGothicDemi",
["rangeUnlock"] = true,
["rangeColors"] = {
[0] = {
["b"] = 0.15,
["g"] = 0.91,
["r"] = 0.01,
},
[25] = {
["b"] = 0.01,
["g"] = 0.2,
["r"] = 0.91,
},
[35] = {
["b"] = 0.01,
["g"] = 0.01,
["r"] = 0.91,
},
[15] = {
["b"] = 0.01,
["g"] = 0.56,
["r"] = 0.91,
},
[30] = {
["b"] = 0.01,
["g"] = 0.01,
["r"] = 0.91,
},
[5] = {
["b"] = 0.15,
["g"] = 0.91,
["r"] = 0.01,
},
[10] = {
["b"] = 0.01,
["g"] = 0.91,
["r"] = 0.91,
},
[20] = {
["b"] = 0.01,
["g"] = 0.56,
["r"] = 0.91,
},
[40] = {
["b"] = 0.01,
["g"] = 0.01,
["r"] = 0.91,
},
},
["rangeEnabled"] = false,
["rangeY"] = -110,
["rangeX"] = 287,
},
["spellQueueWindow"] = 200,
["movementAlert"] = {
["gwUnlock"] = true,
["tsSoundID"] = "|cFFFF0000Move|r",
["tsColorUseClassColor"] = true,
["tsX"] = 4,
["tsTextFormat"] = "Time Spiral\\n%ts",
["tsY"] = -63,
["tsEnabled"] = true,
["tsTtsMessage"] = "Time Spiral",
},
["combatAlert"] = {
["font"] = "ITCAvantGardeGothicDemi",
},
["mouseRing"] = {
["size"] = 38,
["trailDuration"] = 0.48,
["hideOnMouseClick"] = true,
["swipeDelay"] = 0.08,
},
["focusCastBar"] = {
["spellNameTruncate"] = 0,
},
["buffWatcherV2"] = {
["buffDropReminder"] = true,
["classBuffs"] = {
["SHAMAN"] = {
["groups"] = {
{
["key"] = "shamanImbue",
["minRequired"] = 1,
["enchantIDs"] = {
5400,
5401,
6498,
},
["specFilter"] = {
},
["name"] = "Weapon Imbue",
["checkType"] = "weaponEnchant",
},
{
["spellIDs"] = {
974,
192106,
52127,
},
["key"] = "shamanShield",
["minRequired"] = 1,
["specFilter"] = {
},
["name"] = "Shield",
["checkType"] = "self",
},
},
},
["MAGE"] = {
["groups"] = {
{
["spellIDs"] = {
210126,
},
["key"] = "arcaneFamiliar",
["talentCondition"] = {
["talentID"] = 205022,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Arcane Familiar",
["checkType"] = "self",
},
},
},
["PRIEST"] = {
["groups"] = {
{
["spellIDs"] = {
232698,
194249,
},
["key"] = "shadowform",
["specFilter"] = {
258,
},
["name"] = "Shadowform",
["checkType"] = "self",
},
},
},
["WARLOCK"] = {
["groups"] = {
{
["spellIDs"] = {
196099,
},
["key"] = "grimoireOfSacrifice",
["talentCondition"] = {
["talentID"] = 108503,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Grimoire of Sacrifice",
["checkType"] = "self",
},
},
},
["DRUID"] = {
["groups"] = {
{
["spellIDs"] = {
474750,
},
["minRequired"] = 1,
["key"] = "symbioticRelationship",
["thresholds"] = {
["dungeon"] = 0,
["raid"] = 0,
["other"] = 0,
},
["talentCondition"] = {
["talentID"] = 474750,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Symbiotic Relationship",
["checkType"] = "self",
},
},
},
["EVOKER"] = {
["groups"] = {
{
["spellIDs"] = {
369459,
},
["key"] = "sourceOfMagic",
["specFilter"] = {
},
["name"] = "Source of Magic",
["checkType"] = "targeted",
},
{
["spellIDs"] = {
360827,
},
["key"] = "blisteringScales",
["talentCondition"] = {
["talentID"] = 360827,
["mode"] = "activate",
},
["specFilter"] = {
1473,
},
["name"] = "Blistering Scales",
["checkType"] = "targeted",
},
},
},
["PALADIN"] = {
["groups"] = {
{
["spellIDs"] = {
465,
},
["key"] = "devotionAura",
["specFilter"] = {
},
["name"] = "Devotion Aura",
["checkType"] = "self",
},
{
["key"] = "riteOfAdjuration",
["enchantIDs"] = {
7144,
},
["talentCondition"] = {
["talentID"] = 433583,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Rite of Adjuration",
["checkType"] = "weaponEnchant",
},
{
["key"] = "riteOfSanctification",
["enchantIDs"] = {
7143,
},
["talentCondition"] = {
["talentID"] = 433568,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Rite of Sanctification",
["checkType"] = "weaponEnchant",
},
{
["spellIDs"] = {
53563,
},
["key"] = "beaconOfLight",
["specFilter"] = {
65,
},
["name"] = "Beacon of Light",
["checkType"] = "targeted",
},
{
["spellIDs"] = {
156910,
},
["key"] = "beaconOfFaith",
["talentCondition"] = {
["talentID"] = 156910,
["mode"] = "activate",
},
["specFilter"] = {
65,
},
["name"] = "Beacon of Faith",
["checkType"] = "targeted",
},
},
},
},
["classicDisplay"] = false,
["enabled"] = true,
["reportCardPosition"] = {
["y"] = -8.205836296081543,
["x"] = -387.7700500488281,
["point"] = "RIGHT",
},
["userEntries"] = {
["consumable_weaponBuff"] = {
["spellIDs"] = {
},
["itemIDs"] = {
},
},
["consumable_food"] = {
["spellIDs"] = {
},
["itemIDs"] = {
},
},
["inventory_dpsPotion"] = {
["itemIDs"] = {
},
},
["inventory_manaBun"] = {
["itemIDs"] = {
},
},
["consumable_rune"] = {
["spellIDs"] = {
},
["itemIDs"] = {
},
},
["inventory_gatewayControl"] = {
["itemIDs"] = {
},
},
["inventory_healthstone"] = {
["itemIDs"] = {
},
},
["inventory_healthPotion"] = {
["itemIDs"] = {
},
},
["consumable_flask"] = {
["spellIDs"] = {
},
["itemIDs"] = {
},
},
},
["disabledDefaults"] = {
["consumable_weaponBuff"] = {
},
["consumable_food"] = {
},
["raidBuffs"] = {
},
["inventory_dpsPotion"] = {
},
["inventory_manaBun"] = {
},
["consumable_rune"] = {
},
["inventory_gatewayControl"] = {
},
["inventory_healthstone"] = {
},
["inventory_healthPotion"] = {
},
["consumable_flask"] = {
},
},
["_classBuffDefaultsVersion"] = 1,
},
["individualBackups"] = {
["LowLatencyMode"] = "0",
["physicsLevel"] = "0",
["ffxAntiAliasingMode"] = "0",
["useTargetFPS"] = "1",
["ResampleSharpness"] = "0.2",
["TextureFilteringMode"] = "3",
},
["dragonriding"] = {
["speedTextOffsetX"] = -143,
["chargeHeight"] = 8,
["enabled"] = true,
["matchAnchorWidth"] = true,
["surgeOffsetY"] = 3,
["surgeIconSize"] = 34,
["bgAlpha"] = 1,
["speedFontSize"] = 15,
["anchorTo"] = "TOP",
["speedHeight"] = 8,
["surgeAnchor"] = "TOP",
["speedFont"] = "ITCAvantGardeGothicDemi",
["surgeOffsetX"] = 0,
["barStyle"] = "Melli",
["posY"] = 0,
["speedTextOffsetY"] = -5,
["showThrillTick"] = false,
["anchorFrame"] = "EssentialCooldownViewer",
["barWidth"] = 53,
},
["stealthReminder"] = {
["unlock"] = true,
},
["config"] = {
["lastTab"] = "dragonriding",
},
["equipmentReminder"] = {
["ecSpecRules"] = {
[0] = {
},
},
},
["petTracker"] = {
["font"] = "ITCAvantGardeGothicDemi",
},
["combatTimer"] = {
["hidePrefix"] = true,
["stickyTimer"] = true,
["width"] = 67,
["y"] = -280,
["font"] = "ITCAvantGardeGothicDemi",
["chatReport"] = false,
["height"] = 43,
["x"] = -421,
},
["slashCommands"] = {
["enabled"] = true,
["commands"] = {
nil,
{
["enabled"] = false,
},
{
["enabled"] = false,
},
},
},
},
["Default"] = {
["buffWatcherV2"] = {
["buffDropReminder"] = true,
["_classBuffDefaultsVersion"] = 1,
["classBuffs"] = {
["SHAMAN"] = {
["groups"] = {
{
["key"] = "shamanImbue",
["minRequired"] = 1,
["enchantIDs"] = {
5400,
5401,
6498,
},
["specFilter"] = {
},
["name"] = "Weapon Imbue",
["checkType"] = "weaponEnchant",
},
{
["spellIDs"] = {
974,
192106,
52127,
},
["key"] = "shamanShield",
["minRequired"] = 1,
["specFilter"] = {
},
["name"] = "Shield",
["checkType"] = "self",
},
},
},
["WARLOCK"] = {
["groups"] = {
{
["spellIDs"] = {
196099,
},
["key"] = "grimoireOfSacrifice",
["talentCondition"] = {
["talentID"] = 108503,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Grimoire of Sacrifice",
["checkType"] = "self",
},
},
},
["PALADIN"] = {
["groups"] = {
{
["spellIDs"] = {
465,
},
["name"] = "Devotion Aura",
["specFilter"] = {
},
["key"] = "devotionAura",
["checkType"] = "self",
},
{
["key"] = "riteOfAdjuration",
["enchantIDs"] = {
7144,
},
["talentCondition"] = {
["talentID"] = 433583,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Rite of Adjuration",
["checkType"] = "weaponEnchant",
},
{
["key"] = "riteOfSanctification",
["enchantIDs"] = {
7143,
},
["talentCondition"] = {
["talentID"] = 433568,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Rite of Sanctification",
["checkType"] = "weaponEnchant",
},
{
["spellIDs"] = {
53563,
},
["name"] = "Beacon of Light",
["specFilter"] = {
65,
},
["key"] = "beaconOfLight",
["checkType"] = "targeted",
},
{
["spellIDs"] = {
156910,
},
["key"] = "beaconOfFaith",
["talentCondition"] = {
["talentID"] = 156910,
["mode"] = "activate",
},
["specFilter"] = {
65,
},
["name"] = "Beacon of Faith",
["checkType"] = "targeted",
},
},
},
["MAGE"] = {
["groups"] = {
{
["spellIDs"] = {
210126,
},
["key"] = "arcaneFamiliar",
["talentCondition"] = {
["talentID"] = 205022,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Arcane Familiar",
["checkType"] = "self",
},
},
},
["DRUID"] = {
["groups"] = {
{
["spellIDs"] = {
474750,
},
["key"] = "symbioticRelationship",
["talentCondition"] = {
["talentID"] = 474750,
["mode"] = "activate",
},
["specFilter"] = {
},
["name"] = "Symbiotic Relationship",
["checkType"] = "targeted",
},
},
},
["EVOKER"] = {
["groups"] = {
{
["spellIDs"] = {
369459,
},
["name"] = "Source of Magic",
["specFilter"] = {
},
["key"] = "sourceOfMagic",
["checkType"] = "targeted",
},
{
["spellIDs"] = {
360827,
},
["key"] = "blisteringScales",
["talentCondition"] = {
["talentID"] = 360827,
["mode"] = "activate",
},
["specFilter"] = {
1473,
},
["name"] = "Blistering Scales",
["checkType"] = "targeted",
},
},
},
["PRIEST"] = {
["groups"] = {
{
["spellIDs"] = {
232698,
194249,
},
["name"] = "Shadowform",
["specFilter"] = {
258,
},
["key"] = "shadowform",
["checkType"] = "self",
},
},
},
},
},
},
},
}
NaowhQOL_Profiles = nil
