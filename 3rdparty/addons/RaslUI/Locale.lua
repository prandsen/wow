local _, addon = ...
addon.locale = {
    ["enUS"] = {
        page1 = {
            heading = "Welcome to the |cff9451eeRasl|r|cffffffffUI|r installer!",
            desc1 = "• RaslUI helps to install profiles of other ADDONS and spell layouts (CDM) in a few clicks.\n\n|cffe04c4cBe sure to read all the information on every page.|r\n\n• If you are using ElvUI, disable the following addons:\nABE, UUF, Danders Frames.\n• If you want a build without ElvUI:\ndisable ElvUI and install all the necessary profiles.\n\n• You can open this window using the command\n/rasl at any time.\n• To activate all profiles on alts, use the command /rasl alts\n\n|cffe04c4c• For the profiles to work correctly, setting up UI Scale and Edit Mode is mandatory !\n\n• At the end of the installation, make sure to click the Finish button or type /reload.|r",
            --desc2 = "You can reopen this at any time with the /rui command.",
            --desc3 = "On the next page, select your screen size,\nthen click IMPORT to install the profile you need.",
            --addonListHeading = "Here's a list of AddOns that have profiles available:",
            --addonList =
            --"ElvUI, Details, Dander Frames, Plater, BigWigs, Unhalted Unit\nFrames, Better Cooldown Manager, ActionBars Enhanced, Enhance QoL.",

        },
        page2 = {
            heading = "UI scale setup",
            desc1 = "UI Scale is very important if you need a Pixel-Perfect interface.\nUI Scale is set automatically in |cff3bbf32ElvUI|r or |cff3bbf32Unhalted Unit Frames|r.",
            desc2 = "If you find the interface too small, you need to increase the UI scale in |cff3bbf32/uuf|r or |cff3bbf32/elvui|r, but you may lose Pixel-Perfect in the process.",
            desc3 = "You need to choose which resolution you want to install the profiles for.",
            desc4 = "For 1080p - 0.71\nFor 1440p - 0.53",
            scale = "Current UI Scale - "
        },
        -- Addon import pages
        editMode = {
            heading = "Edit Mode",
            desc = "Edit Mode is important for the position of certain elements on the screen.\n\nMost elements can only be moved inside their respective addons.\nFor example, UUF frames are moved only in the UUF addon.\nElvUI elements are moved only in ElvUI.\n\n When changing your specialization, your layout might reset to default; to fix this, press ESC > Edit Mode and select the RaslUI layout. One time per spec.",
            maxLayouts = "[Edit Mode] You already have %d/%d Edit Mode layouts. Please leave a maximum of 4 layers before import.",
        },
        elvui = {
            heading = "ElvUI",
            desc = "A complete addon for all interface elements, except the cooldown manager (spells in the center of the screen).\n\nIf you use ElvUI, make sure you have disabled the addons: Action Bars Enhanced, Unhalted Unit Frames,\nDanders Frames, and other chat/minimap addons (if you have them).\n\nSettings - /elvui in chat.",
        },
        plater = {
            heading = "Plater",
            desc = "Replaces enemy nameplates.\n\nSettings - /plater in chat.",
        },
        details = {
            heading = "Details",
            desc = "Reskin of the standard Blizz DPS meter.\n\nSettings - Gear icon on the Details window.",
        },
        bigwigs = {
            heading = "BigWigs",
            desc = "Replaces the standard boss spell bar with familiar lists.\nWorks only on bosses.\nNo longer available on trash.\nAdds an icon with Private Debuffs slightly above the CDM.\n\nSettings - /bw in chat.",
        },
        danderFrames = {
            heading = "Danders Frames",
            desc = "Replaces Party, Raid, and Boss frames.\n\nIf you use ElvUI, disable this addon.\n\nSettings - /df in chat.",
        },
        uuf = {
            heading = "Unhalted Unit Frames",
            desc = "Replaces Target, Player, and Pet frames.\n\nType /uuf and make sure the Use Global Settings checkbox is not checked in the Profiles section.\n\nIf you use ElvUI, disable this addon.\n\nSettings - /uuf.",
        },
        bcdm = {
            heading = "Better Cooldown Manager",
            desc = "Imports the Better Cooldown Manager profile.",
        },
        abe = {
            heading = "ActionBars Enhanced",
            desc = "Replaces the appearance of action bars.\n\nIf you use ElvUI, disable this addon.\n\nSettings - /abe in chat.",
        },
        enhanceQol = {
            heading = "Enhance QoL",
            desc = "Imports the Enhance QoL profile.",
        },
        cooldownManager = {
            desc = "Position of spell icons in the center of the screen - cooldown manager. Settings - /spells.",
        },
        ayijeCDM = {
            heading = "Ayije CDM",
            desc = "Setup for displaying your spells in the center of the screen, resource bar, cast bar.\nTrinkets, pots, healthstones, racial abilities above the player frame.\n\nSettings - /acdm in chat.",
        },
        naowh = {
            heading = "Naowh QOL",
            desc = "Useful interface improvements. Automatic quest turn-ins, combat enter/exit icon, buff reminder, dragonriding bar, and much more.\n\nSettings - type /nao in chat.",
        },
        -- Navigation
        nav = {
            introduction = "Introduction",
            uiScale = "UI Scale",
            editMode = "Edit Mode",
            elvui = "ElvUI",
            plater = "Plater",
            ayijeCDM = "Ayije CDM",
            details = "Details",
            bigwigs = "BigWigs",
            danderFrames = "Danders Frames",
            uuf = "UUF",
            abe = "ABE",
            naowh = "NaowhQOL",
            cooldownManager = "Cooldown Manager",

        },
        profileStatus = {
            none      = "You have not imported this profile.",
            outdated  = "Your version is outdated.",
            current   = "Your profile has the actual version ",
            version   = " Current version: ",
            notLoaded = "Addon is not enabled.",
        },
        popup = "Are you sure you want to import the %s profile? This will overwrite your current settings.",
        -- НОВЫЕ СТРОКИ ДЛЯ ALTS
        alts = {
            heading = "Setup Alts",
            desc = "Select addons to apply profiles",
            applyBtn = "Apply",
            reloadText = "Settings applied.\nA UI Reload is required for changes to take effect.",
            reloadBtn = "Reload",
            laterBtn = "Later",
            applying = "--- Applying Profiles (%s) ---",
            success = "|cff00ff00[+] %s|r",
            notFound = "|cffff0000[-] %s profile not imported. Use /rasl|r",
            notLoaded = "|cffff0000[-] %s not loaded|r",
            wrongScale = "You have different Scale. Choose profiles Manually",
        }
    },
    ["ruRU"] = {
         page1 = {
         heading = "Добро пожаловать в установщик!",
            desc1 = "• RaslUI помогает установить профили других АДДОНОВ и расположение заклинаний(CDM) за пару кликов.\n\n|cffe04c4cОбязательно читайте всю информацию на каждой странице.|r\n\n• Если вы используете ElvUI, то выключите аддоны:\nABE, UUF, Danders Frames.\n• Если вы хотите сборку без ElvUI:\nвыключите ElvUI и установите все нужные профили.\n\n• Открыть данное окно можно с помощью команды\n`/rasl` в любое время.\n• Для того чтобы активировать все профили на альтах воспользуйтесь командой `/rasl alts`\n\n|cffe04c4c• Для правильной работы профилей установка UI Scale и Edit Mode обязательны !\n\n• В конце установки обязательно нажмите кнопку Finish или пропишите /reload.|r",
            --desc2 = "",
            --desc3 = "",
            --addonListHeading = "",
            --addonList = "",
            },
        page2 = {
            heading = "Установка UI scale",
            desc1 = "UI Scale очень важен, если вам нужен Pixel-Perfect интерфейс.\nUI Scale устанавливается автоматически в |cff3bbf32ElvUI|r или |cff3bbf32Unhalted Unit Frames.|r",
            desc2 = "Если вам покажется что интерфейс слишком маленький, то вам нужно увеличить UI scale в |cff3bbf32/uuf|r или |cff3bbf32/elvui|r, но при этом вы можете потерять Pixel-Perfect.",
            desc3 = "Вам нужно выбрать для какого разрешения вы хотите установить профили.",
            desc4 = "Для 1080p - 0.71\nДля 1440p - 0.53",
            scale = "Текущий UI Scale - "
        },
        -- Addon import pages
        editMode = {
            heading = "Режим редактирования (Edit Mode)",
            desc = "Режим редактирования важен для положения некоторых элементов на экране.\n\nБольшинство элементов можно сместить исключительно внутри аддона.\nК примеру, фреймы |cff3bbf32UUF|r смещаются только в аддон |cff3bbf32UUF|r.\nЭлементы |cff3bbf32ElvUI|r смещаются только в |cff3bbf32ElvUI|r.\n\n |cffe04c4cПри смене специализации ваш макет может сброситься на стандартный, для этого нажмите ESC > Редактирования и выберите макет RaslUI. 1 раз для каждой специализации.|r",
            maxLayouts = "[Режим редактирования] У вас уже есть %d/%d макетов Edit Mode. Пожалуйста, сделайте 4 макета перед импортом. Esc -> Режим редактирования.",
        },
        elvui = {
            heading = "ElvUI",
            desc = "Полноценный аддон для всех элементов интерфейса, кроме кулдаун менеджера(заклинания по центру экрана).\n\n|cffe04c4cЕсли вы используете ElvUI убедитесь что вы выключили аддоны: Action Bars Enhanced, Unhalted Unit Frames,\nDanders Frames и другие аддоны для чата/мини карты (если они у вас есть)|r.\n\nНастройки - /elvui в чат.",
        },
        plater = {
            heading = "Plater",
            desc = "Заменяет неймплейты врагов.\n\nНастройки - /plater в чат.",
        },
        details = {
            heading = "Details",
            desc = "Рескин стандартного ДПС метра близзов.\n\nНастройки - Шестерёнка на окне Details.",
        },
        bigwigs = {
            heading = "BigWigs",
            desc = "Заменяет стандартную полосу заклинаний боссах на привычные списки.\nРаботает только на боссах.\nНа треше больше не доступен.\nДобавляет иконку с Приват Дебаффами чуть выше CDM.\n\nНастройки - /bw в чат.",
        },
        danderFrames = {
            heading = "Danders Frames",
            desc = "Заменяет Пати, Рейд и Босс фреймы.\n\n|cffe04c4cЕсли вы используете ElvUI, выключите данный аддон.|r\n\nНастройки - /df в чат.",
        },
        uuf = {
            heading = "Unhalted Unit Frames",
            desc = "Заменяет Таргет, Плеер, Пет фреймы.\n\nНапишите /uuf и убедитесь что галочка Использовать Глобальные настройки не стоит в разделе Профили.\n\n|cffe04c4cЕсли вы используете ElvUI, выключите данный аддон.|r\n\nНастройки - /uuf.",
        },
        bcdm = {
            heading = "Better Cooldown Manager",
            desc = "Imports the Better Cooldown Manager profile.",
        },
        abe = {
            heading = "ActionBars Enhanced",
            desc = "Заменяет внешний вид панелей с кнопками.\n\n|cffe04c4cЕсли вы используете ElvUI, выключите данный аддон.|r\n\nНастройки - /abe в чат.",
        },
        enhanceQol = {
            heading = "Enhance QoL",
            desc = "Imports the Enhance QoL profile.",
        },
        cooldownManager = {
            desc = "Позиция иконок заклинаний в центру экрана - кулдаун менеджер. Настройки - /spells.",
        },
        ayijeCDM = {
            heading = "Ayije CDM",
            desc = "Настройка отображения ваших заклинаний по центру экрана, полоса с ресурсами, каст бар.\nТринкеты, поты, камни, расовые способности над окном игрока.\n\nНастройки - /acdm в чат.",
        },
        naowh = {
            heading = "Naowh QOL",
            desc = "Полезные улучшения интерфейса. Автоматические сдачи квестов, иконка входа и выхода из комбата, БАФФ напоминатель, полоса драгонрайдинга и многое другое.\n\nНастройки - /nao в чат.",
        },
        -- Navigation
        nav = {
            introduction = "Введение",
            uiScale = "UI Scale",
            editMode = "Edit Mode",
            elvui = "ElvUI",
            plater = "Plater",
            ayijeCDM = "Ayije CDM",
            details = "Details",
            bigwigs = "BigWigs",
            danderFrames = "Danders Frames",
            uuf = "UUF",
            abe = "ABE",
            naowh = "NaowhQOL",
            cooldownManager = "Cooldown Manager",
        },
        profileStatus = {
            none      = "Профиль не импортирован.",
            outdated  = "Ваша версия устарела.",
            current   = "Профиль актуален. Версия: ",
            version   = "Актуальная версия: ",
            notLoaded = "Аддон не включён.",
        },
        popup = "Вы точно хотите импортировать %s профиль? Это перезапишет ваши текущие настройки.",
        -- НОВЫЕ СТРОКИ ДЛЯ ALTS
        alts = {
            heading = "Активация всех профилей",
            desc = "Поставь галочку для включения нужного профиля аддона.",
            applyBtn = "Активировать",
            reloadText = "Настройки применены.\nТребуется /reload для корректной работы.",
            reloadBtn = "Reload",
            laterBtn = "Позже.",
            applying = "--- Применение настроек (%s) ---",
            success = "|cff00ff00[+] %s|r",
            notFound = "|cffff0000[-] %s Профиль не импортирован. Импортируй в /rasl|r",
            notLoaded = "|cffff0000[-] %s не загружен|r",
            wrongScale = "You have different Scale. Choose profiles Manually",
        }
    },
}
