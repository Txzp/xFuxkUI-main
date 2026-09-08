-- ============================================================
-- EJEMPLO COMPLETO: CREACIÓN DE TABS CON xFlux-UI/WindUI
-- ============================================================

-- 1. Cargar la librería
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/xFuxkUI-main/main/xFuxk-main/dist/main.lua?t=" .. os.time()))()

-- 2. Crear la ventana principal

local Window = WindUI:CreateWindow({
    Title = "xFuxh - Ejemplo",
    Icon = "rocket",
    Theme = "Dark",
    Size = UDim2.fromOffset(450, 400),

    OpenButton = {
        Enabled = true,
        OnlyMobile = false,
        Draggable = true,
        OnlyIcon = false,
        Scale = 1,
    },
})

Window:Tag({
    Title = "v1.0.0",
    Icon = "github",
    Color = Color3.fromHex("#000000"),
    Border = true,
})

WindUI.Intro.Show({
    Duration = 3.5,
    Title = "Loading xFuxk",
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
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("[Slider] Valor:", value)
    end
})

-- Dropdown
MainTab:Dropdown({
    Title = "Dropdown Ejemplo",
    Values = {"Opción 1", "Opción 2", "Opción 3"},
    Default = "Opción 1",
    Callback = function(value)
        print("[Dropdown] Seleccionado:", value)
    end
})

-- Keybind
MainTab:Keybind({
    Title = "Keybind Ejemplo",
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
    Value = false,
    Callback = function(state)
        print("[ESP] Estado:", state)
    end
})

VisualsTab:Toggle({
    Title = "Highlight",
    Value = false,
    Callback = function(state)
        print("[Highlight] Estado:", state)
    end
})

VisualsTab:Slider({
    Title = "FOV Size",
    Value = { Min = 50, Max = 300, Default = 150 },
    Callback = function(value)
        print("[FOV] Tamaño:", value)
    end
})

-- ========== SETTINGS TAB ==========
SettingsTab:Toggle({
    Title = "Notificaciones",
    Value = true,
    Callback = function(state)
        print("[Settings] Notificaciones:", state)
    end
})

SettingsTab:Keybind({
    Title = "Toggle UI",
    Value = "RightShift",
    Callback = function()
        Window:Toggle()
    end
})

-- ========== ABOUT TAB ==========
AboutTab:Paragraph({
    Title = "xFuxh v1.0",
    Desc = "Script de ejemplo\n\nHecho con ❤️"
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
