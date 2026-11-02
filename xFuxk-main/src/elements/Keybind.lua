local cloneref = (cloneref or clonereference or function(instance) return instance end)

local UserInputService = cloneref(game:GetService("UserInputService"))

local Creator = require("src/modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {
    UICorner = 6,
    UIPadding = 8,
}

local CreateLabel = require("../components/ui/Label").New

function Element:New(Config)
    local function NormalizeKeyCode(value)
        if typeof(value) == "EnumItem" then
            return value.Name
        elseif type(value) == "string" then
            return value
        else
            return "F"
        end
    end

    local Keybind = {
        __type = "Keybind",
        Title = Config.Title or "Keybind",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        LockedTitle = Config.LockedTitle,
        Value = NormalizeKeyCode(Config.Value) or "F",
        Callback = Config.Callback or function() end,
        CanChange = Config.CanChange or true,
        Picking = false,
        UIElements = {},
    }
    local WindowKeybinds = Config.Window.Keybinds
    table.insert(WindowKeybinds, Keybind)
    
    local CanCallback = true
    
    Keybind.KeybindFrame = require("../components/window/Element")({
        Title = Keybind.Title,
        Desc = Keybind.Desc,
        Parent = Config.Parent,
        TextOffset = 85,
        Hover = Keybind.CanChange,
        Tab = Config.Tab,
        Index = Config.Index,
        Window = Config.Window,
        ElementTable = Keybind,
        ParentConfig = Config,
    })
    
    Keybind.UIElements.Keybind = CreateLabel(Keybind.Value, nil, Keybind.KeybindFrame.UIElements.Main, nil, Config.Window.NewElements and 12 or 10)
    
    Keybind.UIElements.Keybind.Size = UDim2.new(
            0,
            12+12+Keybind.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
            0,
            42
        )
    Keybind.UIElements.Keybind.AnchorPoint = Vector2.new(1,0.5)
    Keybind.UIElements.Keybind.Position = UDim2.new(1,0,0.5,0)

    New("UIScale", {
        Parent = Keybind.UIElements.Keybind,
        Scale = .85,
    })

    Creator.AddSignal(Keybind.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal("TextBounds"), function()
        Keybind.UIElements.Keybind.Size = UDim2.new(
            0,
            12+12+Keybind.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
            0,
            42
        )
    end)

    function Keybind:Lock()
        Keybind.Locked = true
        CanCallback = false
        return Keybind.KeybindFrame:Lock(Keybind.LockedTitle)
    end
    function Keybind:Unlock()
        Keybind.Locked = false
        CanCallback = true
        return Keybind.KeybindFrame:Unlock()
    end
    
    function Keybind:Set(v)
        local normalizedValue = NormalizeKeyCode(v)
        for _, element in next, WindowKeybinds do
            if element ~= Keybind and element.__type == "Keybind" and element.Value == normalizedValue then
                return false
            end
        end

        Keybind.Value = normalizedValue
        Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = normalizedValue
        if Config.Window.ConfigManager then
            Config.Window.ConfigManager:MarkDirty()
        end
        return true
    end
    
    if Keybind.Locked then
        Keybind:Lock()
    end

    local CaptureInputBegan
    local CaptureInputEnded

    local function StopPicking()
        if CaptureInputBegan then
            CaptureInputBegan:Disconnect()
            CaptureInputBegan = nil
        end
        if CaptureInputEnded then
            CaptureInputEnded:Disconnect()
            CaptureInputEnded = nil
        end
        Keybind.Picking = false
        Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = Keybind.Value
    end
    Keybind.CancelPicking = StopPicking

    local function GetInputKey(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
            return input.KeyCode.Name
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            return "MouseLeft"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            return "MouseRight"
        end
    end

    local function IsDuplicateKey(key)
        for _, element in next, WindowKeybinds do
            if element ~= Keybind and element.__type == "Keybind" and element.Value == key then
                return true
            end
        end
        return false
    end

    local function IsAnyKeybindPicking()
        for _, element in next, WindowKeybinds do
            if element.__type == "Keybind" and element.Picking then
                return true
            end
        end
        return false
    end

    Creator.AddSignal(Keybind.KeybindFrame.UIElements.Main.MouseButton1Click, function()
        if CanCallback then
            if Keybind.CanChange then
                if Keybind.Picking then
                    return
                end

                Keybind.Picking = true
                Keybind.UIElements.Keybind.Frame.Frame.TextLabel.Text = "..."

                task.delay(0.2, function()
                    if not Keybind.Picking or not Keybind.KeybindFrame.UIElements.Main.Parent then
                        return
                    end

                    CaptureInputBegan = UserInputService.InputBegan:Connect(function(input)
                        local key = GetInputKey(input)
                        if not key then
                            return
                        end

                        if CaptureInputBegan then
                            CaptureInputBegan:Disconnect()
                            CaptureInputBegan = nil
                        end

                        CaptureInputEnded = UserInputService.InputEnded:Connect(function(endedInput)
                            if GetInputKey(endedInput) ~= key then
                                return
                            end

                            if IsDuplicateKey(key) then
                                StopPicking()
                                Config.Window:Dialog({
                                    Title = "Peakx Warning",
                                    Content = "No duplicate keys are allowed.",
                                    Buttons = {
                                        {
                                            Title = "Confirm",
                                            Variant = "Primary",
                                            Callback = function()
                                                print("Confirmed")
                                            end,
                                        },
                                    },
                                })
                                return
                            end

                            local wasPicking = Keybind.Picking
                            StopPicking()
                            if wasPicking then
                                Keybind:Set(key)
                            end
                        end)
                    end)
                end)
            end
        end
    end) 
        
    Creator.AddSignal(UserInputService.InputBegan, function(input, gpe)
        if UserInputService:GetFocusedTextBox() then 
            return 
        end
    
        if not CanCallback or IsAnyKeybindPicking() then
            return
        end
    
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode.Name == Keybind.Value then
                Creator.SafeCallback(Keybind.Callback, input.KeyCode.Name)
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Value == "MouseLeft" then
            Creator.SafeCallback(Keybind.Callback, "MouseLeft")
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.Value == "MouseRight" then
            Creator.SafeCallback(Keybind.Callback, "MouseRight")
        end
    end)
    
    return Keybind.__type, Keybind
end

return Element