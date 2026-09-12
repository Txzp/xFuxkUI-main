-- ============================================================
-- EJEMPLO COMPLETO: CREACIÓN DE TABS CON xFlux-UI/WindUI
-- ============================================================

-- 1. Cargar la librería
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/xFuxkUI-main/main/xFuxk-main/dist/main.lua?t=" .. os.time()))()

-- 2. Crear la ventana principal

local Window = WindUI:CreateWindow({
    Title = "Test",
    Icon = "rocket",
    Theme = "Dark",
    Author = "xFuxk",
    Size = UDim2.fromOffset(300, 300),

    OpenButton = {
        Enabled = true,
        OnlyMobile = true,
        Draggable = true,
        OnlyIcon = false,
        Scale = 1,
    },

    KeySystem = {
        SaveKey = false,
        Note = "Enter the key to unlock xFuxk",
        URL = "https://links.lootlabs.gg/s?wOdUyESX",

        KeyValidator = function(Key)
            return Key == "12345"
        end,
    },

    DataSystem = {
        DataSave = true,
    },
})

Window:Tag({
    Title = "v1.0.0",
    Icon = "github",
    Color = Color3.fromHex("#000000"),
    Border = true,
})
-- ============================================================
-- 3. CREAR TABS (CADA TAB ES UNA SECCIÓN INDEPENDIENTE)
-- ============================================================

-- Tab 1: Main (icono "house")
local Section = Window:Section({
    Title = "Gameplay",
    Icon = "gamepad-2",
    Opened = true,
})

local MainTab = Section:Tab({
    Title = "Main",
    Icon = "house",
})

-- Tab 2: Visuals (icono "eye")
local VisualsTab = Window:Tab({
    Title = "Visuals",
    Icon = "eye"
})

-- Tab 3: Settings (icono "settings")
local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})

-- Tab 4: About (icono "info")
local AboutTab = Window:Tab({
    Title = "About",
    Icon = "info"
})

local OthersTab = Window:Tab({
    Title = "Others",
    Icon = "bird"
})

-- ============================================================
-- 4. AGREGAR ELEMENTOS A CADA TAB
-- ============================================================

-- ========== MAIN TAB ==========
-- Paragraph (texto informativo)
MainTab:Paragraph({
    Title = "Bienvenido a xFuxh",
    Desc = "Este es un ejemplo de cómo se crean tabs y elementos."
})

-- Toggle
local toggleRef = MainTab:Toggle({
    Title = "Toggle Ejemplo",
    Flag = "Main.ToggleEjemplo",
    Value = false,
    Callback = function(state)
        print("[Toggle] Estado:", state)
    end
})

-- Button
MainTab:Button({
    Title = "Botón Ejemplo",
    Callback = function()
        WindUI:Notify({
            Title = "Ejemplo",
            Content = "Has pulsado el botón",
            Duration = 2
        })
    end
})

-- Slider
MainTab:Slider({
    Title = "Slider Ejemplo",
    Flag = "Main.SliderEjemplo",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("[Slider] Valor:", value)
    end
})

-- Dropdown
MainTab:Dropdown({
    Title = "Dropdown Ejemplo",
    Flag = "Main.DropdownEjemplo",
    Values = {"Opción 1", "Opción 2", "Opción 3"},
    Default = "Opción 1",
    Callback = function(value)
        print("[Dropdown] Seleccionado:", value)
    end
})

-- Keybind
MainTab:Keybind({
    Title = "Keybind Ejemplo",
    Flag = "Main.KeybindEjemplo",
    Value = "K",
    Callback = function()
        print("[Keybind] Presionado K")
        if toggleRef then
            toggleRef:SetState(not toggleRef.Value)
        end
    end
})

-- ========== VISUALS TAB ==========
VisualsTab:Toggle({
    Title = "ESP",
    Flag = "Visuals.ESP",
    Value = false,
    Callback = function(state)
        print("[ESP] Estado:", state)
    end
})

VisualsTab:Toggle({
    Title = "Highlight",
    Flag = "Visuals.Highlight",
    Value = false,
    Callback = function(state)
        print("[Highlight] Estado:", state)
    end
})

VisualsTab:Slider({
    Title = "FOV Size",
    Flag = "Visuals.FOVSize",
    Value = { Min = 50, Max = 300, Default = 150 },
    Callback = function(value)
        print("[FOV] Tamaño:", value)
    end
})

-- ========== SETTINGS TAB ==========
SettingsTab:Toggle({
    Title = "Notificaciones",
    Flag = "Settings.Notificaciones",
    Value = true,
    Callback = function(state)
        print("[Settings] Notificaciones:", state)
    end
})

SettingsTab:Keybind({
    Title = "Toggle UI",
    Flag = "Settings.ToggleUI",
    Value = "RightShift",
    Callback = function()
        Window:Toggle()
    end
})

SettingsTab:Input({
    Title = "Player Name",
    Flag = "Settings.PlayerName",
    Value = "Player",
    Callback = function(value)
        print("[Input] Texto:", value)
    end,
})

SettingsTab:Dropdown({
    Title = "Enabled Features",
    Flag = "Settings.EnabledFeatures",
    Values = { "ESP", "Highlight", "FOV" },
    Multi = true,
    Value = { "ESP" },
    Callback = function(value)
        print("[Multi Dropdown] Seleccionado:", value)
    end,
})

SettingsTab:Colorpicker({
    Title = "Accent Color",
    Flag = "Settings.AccentColor",
    Default = Color3.fromRGB(0, 170, 255),
    Transparency = 0,
    Callback = function(color, transparency)
        print("[Colorpicker] Color:", color, "Transparencia:", transparency)
    end,
})

-- ========== ABOUT TAB ==========
AboutTab:Paragraph({
    Title = "xFuxh v1.0",
    Desc = "Script de ejemplo\n\nHecho con ❤️"
})

-- ========== OTHERs TAB ==========
OthersTab:Toggle({
	Title = "Toggle",
	Locked = true,
	LockedTitle = "This element is locked",
})

OthersTab:Paragraph({
    Title = "xFuxk Community",
    Desc = "Join our Discord community!",

    Image = "https://cdn.discordapp.com/icons/1545627254799736883/219c58a7c38612b832f8c5be16d4b5d6.webp?size=1280",

    Thumbnail = "https://delivery.pixelbin.io/predictions/outputs/1d/sr/upscaleRestricted/01a07f40-054b-7cc2-ae2a-fd8fe84f89cb/result_0.png",

    ImageSize = 48,

    Buttons = {
        {
            Title = "Copy link",
            Icon = "link",
            Callback = function()
                local InviteLink = "https://discord.gg/dPdv3jw5RA"

                if setclipboard then
                    setclipboard(InviteLink)

                    WindUI:Notify({
                        Title = "Discord Invite",
                        Content = "Invite link copied to clipboard!",
                        Icon = "check",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Discord Invite",
                        Content = InviteLink,
                        Icon = "link",
                        Duration = 5,
                        CanClose = true,
                    })
                end
            end,
        },
    },
})
-- ============================================================
-- 5. NOTIFICACIÓN DE INICIO
-- ============================================================
WindUI:Notify({
    Title = "xFuxh",
    Content = "Ejemplo cargado correctamente",
    Duration = 3
})

print("[xFuxh] Script de ejemplo funcionando")
print("[xFuxh] Tabs creadas: Main, Visuals, Settings, About")