    function (self, unitId, unitFrame, envTable, modTable)

        local markerToHex = {
            [1] = "FFEAEA0D", -- Yellow 5 Point Star
            [2] = "FFEAB10D", -- Orange Circle
            [3] = "FFCD00FF", -- Purple Diamond
            [4] = "FF06D425", -- Green Triangle
            [5] = "FFB3E3D8", -- Light Blue Moon
            [6] = "FF0CD2EA", -- Blue Square
            [7] = "FFD6210B", -- Red Cross
            [8] = "FFFFFFFF", -- White Skull
        }

        local dungeonMobNames = {

            -- Cinderbrew Meadery
            [210264] = "Укротитель",
            [214661] = "Голди",
            [214668] = "Посетитель",
            [214673] = "Исследователь",
            [214920] = "Работница",
            [218671] = "Пироман",
            [220141] = "Поставщик",
            [220946] = "Сборщик",

            -- Darkflame Cleft
            [210818] = "Кротопас",
            [212383] = "Служитель",
            [213913] = "Хранитель",

            -- Operation: Floodgate
            [226403] = "Киза",
            [226404] = "Гизл",
            [227145] = "Кроколиск",
            [228144] = "Солдат",
            [228424] = "Мехадрон",
            [229069] = "Снайпер",
            [229212] = "Подрывник",
            [229250] = "Подрядчик",
            [229251] = "Архитектор",
            [229252] = "Гиена",
            [229686] = "Геодезист",
            [230740] = "Крошшенатор",
            [230748] = "Кровоплет",
            [231014] = "Бот",
            [231312] = "Электрик",
            [231325] = "Запускатель",
            [231385] = "Инспектор",
            [231496] = "Ныряльщик",
            [231497] = "Краб",
            [232228] = "Донник",
            [236982] = "Солдат",

            -- The Motherlode
            [129214] = "Разгонятель",
            [129231] = "Рикса",
            [130437] = "Рудокоп",
            [130661] = "Геомант",
            [133430] = "Гений",
            [133432] = "Алхимик",
            [133463] = "Робот",
            [136139] = "Робот",
            [136643] = "Экстрактор",
            [136934] = "Испытатель",
            [137713] = "Краб",
            [138061] = "Докер",

            -- Priory of the Sacred Flame
            [206698] = "Фанатичка",
            [206710] = "Огонек",
            [222927] = "Винодел",

            -- The Rookery
            [207207] = "Чудище",
            [207197] = "Страж",
            [207199] = "Наставник",
            [212739] = "Камень",
            [212786] = "Странник",
            [212793] = "Служительница",
            [214421] = "Распылитель",

            -- Theater of Pain
            [160495] = "Стражник",
            [162329] = "Ксав",
            [162763] = "Похититель",
            [164461] = "Сатель",
            [164463] = "Пакиран",
            [164464] = "Зира",
            [165946] = "Мордрета",
            [167998] = "Страж",
            [174210] = "Изрыгатель",

            -- Mechagon: Workshop
            [144244] = "Лупцеватор",
            [144248] = "Искродрочец",
            [144249] = "Трансформер",
            [144293] = "Переработчик",
            [144294] = "Белкострел",
            [144296] = "Паук",
            [144298] = "Робот",
            [144299] = "Защитник",
            [144300] = "Житель",
            [145185] = "Гномогеддон",
            [150396] = "НЛО",
            [150397] = "Король Мехагон",
            [151476] = "Взрывотрон",
            [151579] = "Генератор",
            [151649] = "Робот",
            [151658] = "Долгоног",
            [151773] = "Пес",

            -- Raid: Undermine(d)
            [225822] = "Векси",
            [227955] = "Искра",
            [227961] = "Миротворец",
            [228514] = "Механик",
            [228648] = "Рик",
            [229180] = "Стрелок",
            [229219] = "Хобгоблин",
            [229222] = "Плавильщик",
            [229224] = "Утилизатор",
            [229513] = "Оглушитель",
            [230322] = "Стикз",
            [231839] = "Мастер",
            [238237] = "Головорез",
        }

        function envTable.rename(npcId, unitId)
            if unitId then
                local name = UnitName(unitId)
                local a, b, c, d, e, f = strsplit(' ', name, 5)

                local unitName

                if dungeonMobNames[npcId] then
                    unitName = dungeonMobNames[npcId]
                else
                    unitName = name ~=nil and (f or e or d or c or b or a) or nil
                end

                if unitName == nil then
                    unitName = name
                end

                -- Capitalize first word
                unitName = unitName:utf8sub(1,1):upper()..unitName:utf8sub(2)

                local marker = GetRaidTargetIndex(unitId)
                if unitId and marker == nil then
                    marker = 8
                end

                if unitId and marker then
                    unitFrame.healthBar.unitName:SetText(WrapTextInColorCode(unitName, markerToHex[marker]))
                elseif unitId then
                    unitFrame.healthBar.unitName:SetText(unitName)
                end
            end
        end
    end

