local Toggle = {}

local Creator = require("src/modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")

function Toggle.New(_, Config)
    Config = Config or {}

    local Value = Config.Value ~= nil and Config.Value or false
    local Icon = Config.Icon
    local IconSize = Config.IconSize
    local Parent = Config.Parent
    local Callback = Config.Callback
    local NewElement = Config.Window and Config.Window.NewElements or false
    local Toggle = {
        __type = "Toggle",
        Title = Config.Title or "Toggle",
        Desc = Config.Desc,
        Locked = Config.Locked or false,
        LockedTitle = Config.LockedTitle,
        Value = Value,
        Callback = Callback or function() end,
        UIElements = {},

        GlassSpritesheet = {
            Id = "rbxassetid://77297718671545",
            MirroredId = "rbxassetid://92258969882244",
            Size = Vector2.new(102, 128),
            Total = 80,
            Cols = 10,
        }
    }

    function Toggle:GetGlassFrame(T: number): (string, Vector2, Vector2)
        local S = Toggle.GlassSpritesheet
        local Frame: number

        if T <= 0.4 then
            Frame = math.floor((T / 0.4) * (S.Total - 1))
        elseif T < 0.6 then
            Frame = S.Total - 1
        else
            Frame = math.floor(((T - 0.6) / 0.4) * (S.Total - 1))
        end

        Frame = math.clamp(Frame, 0, S.Total - 1)

        local Mirrored = T >= 0.6
        if Mirrored then
            Frame = (S.Total - 1) - Frame
        end

        local Id = Mirrored and S.MirroredId or S.Id

        return Id,
            S.Size,
            Vector2.new(
                (Frame % S.Cols)           * S.Size.X,
                math.floor(Frame / S.Cols) * S.Size.Y
            )
    end
    
    local Radius = 24/2
    local IconToggleFrame
    if Icon and Icon ~= "" then
        local IconData = Creator.Icon(Icon)

        if IconData then
            IconToggleFrame = New("ImageLabel", {
                Size = UDim2.new(0,20-7,0,20-7),
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
                Image = IconData[1],
                ImageRectOffset = IconData[2].ImageRectPosition,
                ImageRectSize = IconData[2].ImageRectSize,
                ImageTransparency = 1,
                ImageColor3 = Color3.new(0,0,0),
            })
        end
    end

    local ElementFrame = require("src/components/window/Element")({
        Title = Toggle.Title,
        Desc = Toggle.Desc,
        Parent = Parent,
        TextOffset = NewElement and 52 or 41,
        Hover = false,
        Tab = Config.Tab,
        Index = Config.Index,
        Window = Config.Window,
        ElementTable = Toggle,
        ParentConfig = Config,
    })

    Toggle.ToggleFrame = ElementFrame

local ToggleContainer = New("Frame", {
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Parent = ElementFrame.UIElements.Main,
})

local SwitchFrame = Creator.NewRoundFrame(Radius, "Squircle", {
    ImageTransparency = .85,
    ThemeTag = {
        ImageColor3 = "Text"
    },
    Parent = ToggleContainer,
    Size = UDim2.new(0,NewElement and (24+24+4) or (24*1.7),0,24),
    AnchorPoint = Vector2.new(1,0.5),
    Position = UDim2.new(1,0,0.5,0),
    Name = "ToggleFrame",
}, {
        Creator.NewRoundFrame(Radius, "Squircle", {
            Size = UDim2.new(1,0,1,0),
            Name = "Layer",
            ThemeTag = {
                ImageColor3 = "Toggle",
            },
            ImageTransparency = 1, -- 0
        }),
        Creator.NewRoundFrame(Radius, "SquircleOutline", {
            Size = UDim2.new(1,0,1,0),
            Name = "Stroke",
            ImageColor3 = Color3.new(1,1,1),
            ImageTransparency = 1, -- .95
        }, {
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                })
            })
        }),
        
        --bar
        Creator.NewRoundFrame(Radius, "Squircle", {
            Size = UDim2.new(0,NewElement and 30 or 20,0,20),
            Position = UDim2.new(0,2,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            ImageTransparency = 1,
            Name = "Frame",
        }, {
            Creator.NewRoundFrame(Radius, "Squircle", {
                Size = UDim2.new(1,0,1,0),
                ImageTransparency = 0,
                
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
                Name = "Bar"
            }, {
                Creator.NewRoundFrame(Radius, "Glass-1.4", {
                    Size = UDim2.new(1,0,1,0),
                    ImageColor3 = Color3.new(1,1,1),
                    Name = "Highlight",
                    ImageTransparency = 1,
                }, {
                    -- New("UIGradient", {
                    --     Rotation = 60,
                    --     Color = ColorSequence.new({
                    --         ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                    --         ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                    --         ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
                    --     }),
                    --     Transparency = NumberSequence.new({
                    --         NumberSequenceKeypoint.new(0.0, 0.1),
                    --         NumberSequenceKeypoint.new(0.5, 1),
                    --         NumberSequenceKeypoint.new(1.0, 0.1),
                    --     })
                    -- }),
                    Creator.NewRoundFrame(Radius, "Squircle", {
                        Size = UDim2.new(1,0,1,0),
                        Name = "GlassBackground",
                        ImageTransparency = 0,
                        ThemeTag = {
                            ImageColor3 = "ElementBackground",
                        },
                        ZIndex = -1,
                    }),
                    New("ImageLabel", {
                        Size = UDim2.new(1,0,1,0),
                        BackgroundTransparency = 1,
                        Name = "Glass",
                        ImageTransparency = 0,
                    }, {
                        New("UICorner", {
                            CornerRadius = UDim.new(1,0),
                        })
                    }),
                    Creator.NewRoundFrame(Radius, "Glass-1.4", {
                        Size = UDim2.new(1,0,1,0),
                        ImageColor3 = Color3.new(1,1,1),
                        Name = "Highlight",
                        ImageTransparency = 0.3,
                    }),
                    Creator.NewRoundFrame(Radius, "Squircle", {
                        Size = UDim2.new(1,0,1,0),
                        Name = "BarOverlay",
                        ThemeTag = {
                            ImageColor3 = "ToggleBar",
                        },
                        ZIndex = 999,
                    })
                }),
                IconToggleFrame,
                New("UIScale", {
                    Scale = 1, -- 1.66
                })
            }),
        }), 
        New("TextButton", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5,0,0.5,0),
            AnchorPoint = Vector2.new(0.5,0.5),
            Name = "Hitbox",
            Text = "",
        })
    })
    
    Toggle.UIElements.Toggle = SwitchFrame

    local Hitbox = SwitchFrame:FindFirstChild("Hitbox", true)

    local dragConnection
    local endConnection
    local startX
    local FrameWidth = NewElement and 30 or 20
    local ToggleWidth = SwitchFrame.Size.X.Offset
    
    function Toggle:Set(Toggled, isCallback, isAnim)
        local changed = Toggle.Value ~= Toggled
        Toggle.Value = Toggled

        if changed and Config.Window and Config.Window.ConfigManager then
            Config.Window.ConfigManager:MarkDirty()
        end

        if not isAnim then
            if Toggled then
                Tween(SwitchFrame.Frame, 0.35, {
                    Position = UDim2.new(0, ToggleWidth - FrameWidth - 2, 0.5, 0),
                }, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
                Creator.SetThemeTag(SwitchFrame.Frame.Bar.Highlight.Glass, { ImageColor3 = Color3.fromRGB(255, 255, 255) }, 0.15)
                Tween(SwitchFrame.Frame.Bar.Highlight.Glass, 0.15, { ImageTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            else
                Tween(SwitchFrame.Frame, 0.35, {
                    Position = UDim2.new(0, 2, 0.5, 0),
                }, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
                Creator.SetThemeTag(SwitchFrame.Frame.Bar.Highlight.Glass, { ImageColor3 = Color3.fromRGB(145, 145, 145) }, 0.15)
                Tween(SwitchFrame.Frame.Bar.Highlight.Glass, 0.15, { ImageTransparency = 0.85 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            end
        else
            if Toggled then
                SwitchFrame.Frame.Position = UDim2.new(0, ToggleWidth - FrameWidth - 2, 0.5, 0)
            else
                SwitchFrame.Frame.Position = UDim2.new(0, 2, 0.5, 0)
            end
        end
    
        if Toggled then
            Tween(SwitchFrame.Layer, 0.1, {
                ImageTransparency = 0,
            }):Play()
            Creator.SetThemeTag(SwitchFrame.Frame.Bar.Highlight.Glass, { ImageColor3 = Color3.fromRGB(255, 255, 255) }, 0.1)
            Tween(SwitchFrame.Frame.Bar.Highlight.Glass, 0.1, { ImageTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        
            if IconToggleFrame then 
                Tween(IconToggleFrame, 0.1, {
                    ImageTransparency = 0,
                }):Play()
            end

            local Id, RectSize, RectOffset = Toggle:GetGlassFrame(1)

            SwitchFrame.Frame.Bar.Highlight.Glass.Image = Id
            SwitchFrame.Frame.Bar.Highlight.Glass.ImageRectSize = RectSize
            SwitchFrame.Frame.Bar.Highlight.Glass.ImageRectOffset = RectOffset
        else
            Tween(SwitchFrame.Layer, 0.1, {
                ImageTransparency = 1,
            }):Play()
            Creator.SetThemeTag(SwitchFrame.Frame.Bar.Highlight.Glass, { ImageColor3 = Color3.fromRGB(145, 145, 145) }, 0.1)
            Tween(SwitchFrame.Frame.Bar.Highlight.Glass, 0.1, { ImageTransparency = 0.85 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        
            if IconToggleFrame then 
                Tween(IconToggleFrame, 0.1, {
                    ImageTransparency = 1,
                }):Play()
            end

            local Id, RectSize, RectOffset = Toggle:GetGlassFrame(0)

            SwitchFrame.Frame.Bar.Highlight.Glass.Image = Id
            SwitchFrame.Frame.Bar.Highlight.Glass.ImageRectSize = RectSize
            SwitchFrame.Frame.Bar.Highlight.Glass.ImageRectOffset = RectOffset
        end
    
        isCallback = isCallback ~= false
        
        task.spawn(function()
            if Callback and isCallback then
                Creator.SafeCallback(Callback, Toggled)
            end
        end)
    end

    Toggle.SetValue = Toggle.Set
    Toggle.SetState = Toggle.Set
    
    function Toggle:Lock()
        Toggle.Locked = true
        if Toggle.ToggleFrame.Lock then
            return Toggle.ToggleFrame:Lock(Toggle.LockedTitle)
        end
    end

    function Toggle:Unlock()
        Toggle.Locked = false
        if Toggle.ToggleFrame.Unlock then
            return Toggle.ToggleFrame:Unlock()
        end
    end

    if Toggle.Locked then
        Toggle:Lock()
    end

    if Hitbox then
        Creator.AddSignal(Hitbox.InputBegan, function(input)
            if Toggle.Locked then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            Toggle:Animate(input, Toggle)
        end)
    end

    function Toggle:Animate(input, ToggleObj)
        if not Config.Window.IsToggleDragging then
            Config.Window.IsToggleDragging = true

            local startMouseX = input.Position.X
            local startMouseY = input.Position.Y
            local startFrameX = SwitchFrame.Frame.Position.X.Offset
            local isScrolling = false
            local hasDragged = false

            Tween(SwitchFrame.Frame.Bar.UIScale, 0.28, {Scale = 1.5}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(SwitchFrame.Frame.Bar.Highlight.BarOverlay, 0.28, {ImageTransparency = .86}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

            if dragConnection then dragConnection:Disconnect() end

            dragConnection = UserInputService.InputChanged:Connect(function(inputChanged)
                if not Config.Window.IsToggleDragging then return end
                if inputChanged.UserInputType ~= Enum.UserInputType.MouseMovement and inputChanged.UserInputType ~= Enum.UserInputType.Touch then return end
                if isScrolling then return end

                local deltaX = math.abs(inputChanged.Position.X - startMouseX)
                local deltaY = math.abs(inputChanged.Position.Y - startMouseY)

                if not hasDragged and deltaX > 8 then
                    hasDragged = true
                end

                local mouseDelta = inputChanged.Position.X - startMouseX
                local newX = math.max(2, math.min(startFrameX + mouseDelta, ToggleWidth - FrameWidth - 2))

                local Percent = math.clamp((newX - 2) / (ToggleWidth - FrameWidth - 4), 0, 1)

                local Id, RectSize, RectOffset = Toggle:GetGlassFrame(Percent)
                SwitchFrame.Frame.Bar.Highlight.Glass.Image = Id
                SwitchFrame.Frame.Bar.Highlight.Glass.ImageRectSize = RectSize
                SwitchFrame.Frame.Bar.Highlight.Glass.ImageRectOffset = RectOffset

                Tween(SwitchFrame.Frame, 0.12, {
                    Position = UDim2.new(0, newX, 0.5, 0)
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            end)

            if endConnection then endConnection:Disconnect() end

            endConnection = UserInputService.InputEnded:Connect(function(inputEnded)
                if not Config.Window.IsToggleDragging then return end
                if inputEnded.UserInputType ~= Enum.UserInputType.MouseButton1 and inputEnded.UserInputType ~= Enum.UserInputType.Touch then return end

                Config.Window.IsToggleDragging = false

                if dragConnection then dragConnection:Disconnect() dragConnection = nil end
                if endConnection then endConnection:Disconnect() endConnection = nil end

                if isScrolling then return end

                if not hasDragged then
                    ToggleObj:Set(not ToggleObj.Value, true, false)
                else
                    local currentX = SwitchFrame.Frame.Position.X.Offset
                    local barCenter = currentX + FrameWidth / 2
                    local newValue = barCenter > ToggleWidth / 2
                    ToggleObj:Set(newValue, true, false)
                end

                Tween(SwitchFrame.Frame.Bar.UIScale, 0.23, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                Tween(SwitchFrame.Frame.Bar.Highlight.BarOverlay, 0.23, {ImageTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            end)
        end
    end
    
    Toggle:Set(Toggle.Value, false, true)

    return Toggle.__type, Toggle
end

return Toggle