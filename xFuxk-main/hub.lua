-- AstraHub Zz - Script con Debug Avanzado para Keybind
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Astras-Zzz/main/WindUI-main/dist/main.lua"))()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

print("🔄 Iniciando AstraHub Zz con Debug Avanzado...")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DE LA VENTANA
-- ═══════════════════════════════════════════════════════════════
local Window = WindUI:CreateWindow({
    Title = "AstraHub Zz [DEBUG]",
    Theme = "Dark",
    Size = UDim2.fromOffset(480, 420),
    Folder = "AstraHubZz",
    IgnoreAlerts = false,
})

print("✅ Ventana cargada.")

-- ═══════════════════════════════════════════════════════════════
-- CONSOLA DE LOGS VISUAL (Funcional)
-- ═══════════════════════════════════════════════════════════════
local DebugTab = Window:Tab({ Title = "Debug Console", Icon = "terminal" })

-- Creamos un ScrollingFrame manual para los logs
local LogContainer = Instance.new("ScrollingFrame")
LogContainer.Size = UDim2.new(1, 0, 1, 0)
LogContainer.BackgroundTransparency = 1
LogContainer.ScrollBarThickness = 4
LogContainer.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
LogContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
LogContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogContainer.ClipsDescendants = true
LogContainer.Parent = DebugTab.ContainerFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.Padding = UDim.new(0, 4)
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Parent = LogContainer

local function AddLog(message, type)
    local color = Color3.fromRGB(255, 255, 255)
    if type == "ERROR" then color = Color3.fromRGB(255, 50, 50) end
    if type == "SUCCESS" then color = Color3.fromRGB(50, 255, 50) end
    if type == "WARN" then color = Color3.fromRGB(255, 165, 0) end
    if type == "INFO" then color = Color3.fromRGB(100, 200, 255) end
    
    print("[" .. type .. "] " .. message)
    
    local LogLabel = Instance.new("TextLabel")
    LogLabel.Size = UDim2.new(1, -10, 0, 20)
    LogLabel.BackgroundTransparency = 0.8
    LogLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogLabel.Text = "[" .. os.date("%H:%M:%S") .. "] " .. message
    LogLabel.TextColor3 = color
    LogLabel.TextSize = 14
    LogLabel.Font = Enum.Font.Code
    LogLabel.TextXAlignment = "Left"
    LogLabel.TextYAlignment = "Center"
    LogLabel.BorderSizePixel = 0
    LogLabel.Parent = LogContainer
    
    task.spawn(function()
        task.wait()
        LogContainer.CanvasPosition = Vector2.new(0, LogContainer.AbsoluteCanvasSize.Y)
    end)
end

AddLog("Consola de Debug iniciada...", "SUCCESS")

-- ═══════════════════════════════════════════════════════════════
-- INSPECCIÓN INTERNA DE WINDUI PARA ENCONTRAR EL BUG
-- ═══════════════════════════════════════════════════════════════

AddLog("Inspeccionando objeto Window...", "INFO")

-- Verificar si Window tiene ToggleKey
if Window.ToggleKey then
    AddLog("✅ Window.ToggleKey EXISTE: " .. Window.ToggleKey.Name, "SUCCESS")
else
    AddLog("❌ Window.ToggleKey NO EXISTE (es NIL)", "ERROR")
end

-- Verificar si Window tiene SetToggleKey
if Window.SetToggleKey then
    AddLog("✅ Window.SetToggleKey EXISTE", "SUCCESS")
else
    AddLog("❌ Window.SetToggleKey NO EXISTE", "ERROR")
end

-- Intentar listar todas las propiedades de Window
AddLog("Propiedades de Window:", "INFO")
for key, value in pairs(Window) do
    if typeof(value) ~= "function" then
        AddLog("  - " .. tostring(key) .. ": " .. tostring(value), "INFO")
    end
end

-- Intentar listar métodos de Window
AddLog("Métodos de Window:", "INFO")
for key, value in pairs(Window) do
    if typeof(value) == "function" then
        AddLog("  - " .. tostring(key) .. "()", "INFO")
    end
end

-- ═══════════════════════════════════════════════════════════════
-- MONITOREO DE TECLAS (RAW INPUT)
-- ═══════════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        
        if keyName == "RightShift" or keyName == "Q" or keyName == "Insert" or keyName == "Home" then
            AddLog("Tecla Detectada: " .. keyName .. " | GameProcessed: " .. tostring(gameProcessed), "WARN")
            
            if Window.ToggleKey then
                if Window.ToggleKey == input.KeyCode then
                    AddLog("✅ MATCH: La tecla coincide con Window.ToggleKey (" .. Window.ToggleKey.Name .. ")", "SUCCESS")
                else
                    AddLog("❌ NO MATCH: Window.ToggleKey es " .. Window.ToggleKey.Name, "ERROR")
                end
            else
                AddLog("❌ ERROR: Window.ToggleKey es NIL", "ERROR")
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB PRINCIPAL Y KEYBIND TEST
-- ═══════════════════════════════════════════════════════════════
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Paragraph({
    Title = "Prueba de Keybind",
    Desc = "La consola de Debug mostrará qué propiedades existen en Window."
})

-- Botón para probar SetToggleKey manualmente
MainTab:Button({
    Title = "Probar Window:SetToggleKey(RightShift)",
    Callback = function()
        if Window.SetToggleKey then
            Window:SetToggleKey(Enum.KeyCode.RightShift)
            AddLog("Se llamó Window:SetToggleKey(RightShift)", "WARN")
            AddLog("Nuevo valor de Window.ToggleKey: " .. (Window.ToggleKey and Window.ToggleKey.Name or "NIL"), "SUCCESS")
        else
            AddLog("❌ No se puede llamar a Window:SetToggleKey porque no existe", "ERROR")
        end
    end
})

-- Mostrar estado final
task.wait(1)
AddLog("Estado Final Window.ToggleKey: " .. (Window.ToggleKey and Window.ToggleKey.Name or "NIL"), "WARN")
AddLog("Estado Final Window.SetToggleKey: " .. (Window.SetToggleKey and "EXISTE" or "NO EXISTE"), "WARN")

print("🟢 AstraHub Zz con Debug Avanzado cargado completamente.")
