local Creator = require("src/modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local NotificationModule = {
    Size = UDim2.new(0,300,1,-100-56),
    SizeLower = UDim2.new(0,300,1,-56),
    UICorner = 18,
    UIPadding = 14,
    --ButtonPadding = 9,
    Holder = nil,
    NotificationIndex = 0,
    Notifications = {}
}

function NotificationModule.Init(Parent)
    local NotModule = {
        Lower = false
    }
    
    function NotModule.SetLower(val)
        NotModule.Lower = val
        NotModule.Frame.Size = val and NotificationModule.SizeLower or NotificationModule.Size
    end
    
    NotModule.Frame = New("Frame", {
        Position = UDim2.new(1,-116/4,0,56),
        AnchorPoint = Vector2.new(1,0),
        Size = NotificationModule.Size ,
        Parent = Parent,
        BackgroundTransparency = 1,
        --[[ScrollingDirection = "Y",
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = "Y",--]]
    }, {
        New("UIListLayout", {
            HorizontalAlignment = "Center",
			SortOrder = "LayoutOrder",
			VerticalAlignment = "Bottom",
			Padding = UDim.new(0, 8),
        }),
        New("UIPadding", {
            PaddingBottom = UDim.new(0,116/4)
        })
    })
    return NotModule
end

function NotificationModule.New(Config)
    local Notification = {
        Title = Config.Title or "Notification",
        Content = Config.Content or nil,
        Icon = Config.Icon or nil,
        IconThemed = Config.IconThemed,
        Background = Config.Background,
        BackgroundImageTransparency = Config.BackgroundImageTransparency,
        Duration = Config.Duration or 5,
        Buttons = Config.Buttons or {},
        CanClose = Config.CanClose ~= false,
        UIElements = {},
        Closed = false,
    }
    --[[if Notification.CanClose == nil then
        Notification.CanClose = true
    end--]]
    NotificationModule.NotificationIndex = NotificationModule.NotificationIndex + 1
    NotificationModule.Notifications[NotificationModule.NotificationIndex] = Notification
    
    -- local UIStroke = New("UIStroke", {
    --     ThemeTag = {
    --         Color = "Text"
    --     },
    --     Transparency = 1, -- - .9
    --     Thickness = .6,
    -- })
    
    local Icon

    if Notification.Icon then
        -- if Creator.Icon(Notification.Icon) and Creator.Icon(Notification.Icon)[2] then
        --     Icon = New("ImageLabel", {
        --         Size = UDim2.new(0,26,0,26),
        --         Position = UDim2.new(0,NotificationModule.UIPadding,0,NotificationModule.UIPadding),
        --         BackgroundTransparency = 1,
        --         Image = Creator.Icon(Notification.Icon)[1],
        --         ImageRectSize = Creator.Icon(Notification.Icon)[2].ImageRectSize,
        --         ImageRectOffset = Creator.Icon(Notification.Icon)[2].ImageRectPosition,
        --         ThemeTag = {
        --             ImageColor3 = "Text"
        --         }
        --     })
        -- elseif string.find(Notification.Icon, "rbxassetid") then
        --     Icon = New("ImageLabel", {
        --         Size = UDim2.new(0,26,0,26),
        --         BackgroundTransparency = 1,
        --         Position = UDim2.new(0,NotificationModule.UIPadding,0,NotificationModule.UIPadding),
        --         Image = Notification.Icon
        --     })
        -- end
        
        Icon = Creator.Image(
            Notification.Icon,
            Notification.Title .. ":" .. Notification.Icon,
            0,
            Config.Window,
            "Notification",
            Notification.IconThemed
        )
        Icon.Size = UDim2.new(0,26,0,26)
        Icon.Position = UDim2.new(0,NotificationModule.UIPadding,0,NotificationModule.UIPadding)
        -- Icon.LayoutOrder = -1
    end
    
    local CloseButton
    if Notification.CanClose then
        CloseButton = New("ImageButton", {
            Image = Creator.Icon("x")[1],
            ImageRectSize = Creator.Icon("x")[2].ImageRectSize,
            ImageRectOffset = Creator.Icon("x")[2].ImageRectPosition,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,16,0,16),
            Position = UDim2.new(1,-NotificationModule.UIPadding,0,NotificationModule.UIPadding),
            AnchorPoint = Vector2.new(1,0),
            ThemeTag = {
                ImageColor3 = "Text"
            },
            ImageTransparency = .4,
        }, {
            New("UIScale", {
                Scale = 1,
            }),
            New("TextButton", {
                Size = UDim2.new(1,8,1,8),
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
                Text = "",
            })
        })
    end
    
    local DurationTrack = New("Frame", {
        Name = "DurationTrack",
        AnchorPoint = Vector2.new(0,1),
        Position = UDim2.new(0,NotificationModule.UIPadding,1,-8),
        Size = UDim2.new(1,-NotificationModule.UIPadding*2,0,2),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = .82,
        BorderSizePixel = 0,
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(1,0),
        }),
        New("Frame", {
            Name = "Bar",
            Size = UDim2.new(1,0,1,0),
            BackgroundColor3 = Color3.new(1,1,1),
            BackgroundTransparency = .08,
            BorderSizePixel = 0,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(1,0),
            }),
        }),
    })
    local DurationBar = DurationTrack.Bar
    
    local TextContainer = New("Frame", {
        Size = UDim2.new(1,
            Notification.Icon and -28-NotificationModule.UIPadding or 0,
            1,0),
        Position = UDim2.new(1,0,0,0),
        AnchorPoint = Vector2.new(1,0),
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0,NotificationModule.UIPadding),
            PaddingLeft = UDim.new(0,NotificationModule.UIPadding),
            PaddingRight = UDim.new(0,NotificationModule.UIPadding),
            PaddingBottom = UDim.new(0,NotificationModule.UIPadding),
        }),
        New("TextLabel", {
            AutomaticSize = "Y",
            Size = UDim2.new(1,-30-NotificationModule.UIPadding,0,0),
            TextWrapped = true,
            TextXAlignment = "Left",
            RichText = true,
            BackgroundTransparency = 1,
            TextSize = 18,
            ThemeTag = {
                TextColor3 = "NotificationTitle",
                TextTransparency = "NotificationTitleTransparency",
            },
            Text = Notification.Title,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold)
        }),
        New("UIListLayout", {
            Padding = UDim.new(0,NotificationModule.UIPadding/3)
        })
    })
    
    if Notification.Content then
        New("TextLabel", {
            AutomaticSize = "Y",
            Size = UDim2.new(1,0,0,0),
            TextWrapped = true,
            TextXAlignment = "Left",
            RichText = true,
            BackgroundTransparency = 1,
            --TextTransparency = .4,
            TextSize = 15,
            ThemeTag = {
                TextColor3 = "NotificationContent",
                TextTransparency = "NotificationContentTransparency",
            },
            Text = Notification.Content,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            Parent = TextContainer
        })
    end
    
    
    local Main = Creator.NewRoundFrame(NotificationModule.UICorner, "Squircle", {
        Size = UDim2.new(1,0,0,0),
        Position = UDim2.new(1.08,0,1,0),
        AnchorPoint = Vector2.new(0,1),
        AutomaticSize = "Y",
        ImageTransparency = 1,
        ThemeTag = {
            ImageColor3 = "Notification"
        },
        --ZIndex = 20
    }, {
        Creator.NewRoundFrame(NotificationModule.UICorner, "Glass-1", {
            Size = UDim2.new(1,0,1,0),
            ThemeTag = {
                ImageColor3 = "NotificationBorder",
                ImageTransparency = "NotificationBorderTransparency",
            },
        }),
        New("ImageLabel", {
            Name = "Background",
            Image = Notification.Background,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            ScaleType = "Crop",
            ImageTransparency = Notification.BackgroundImageTransparency
            --ZIndex = 19,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,NotificationModule.UICorner),
            })
        }),
        
        TextContainer,
        Icon, CloseButton,
        New("UIScale", {
            Name = "AnimationScale",
            Scale = .94,
        }),
        DurationTrack,
    })
    local MainScale = Main.AnimationScale

    local MainContainer = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,0),
        Parent = Config.Holder
    }, {
        Main
    })
    
    function Notification:Close()
        if not Notification.Closed then
            Notification.Closed = true
            Tween(MainContainer, 0.32, {Size = UDim2.new(1,0,0,0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()
            Tween(Main, 0.32, {
                Position = UDim2.new(1.08,0,1,0),
                ImageTransparency = 1,
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()
            Tween(MainScale, 0.32, {Scale = .92}, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
            task.wait(.34)
            MainContainer:Destroy()
        end
    end
    
    task.spawn(function()
        task.wait()
        Tween(MainContainer, 0.48, {Size = UDim2.new(
            1,
            0,
            0,
            Main.AbsoluteSize.Y
        )}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Main, 0.48, {
            Position = UDim2.new(0,0,1,0),
            ImageTransparency = .05,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(MainScale, 0.55, {Scale = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
        if Notification.Duration then
            Tween(DurationBar, Notification.Duration, {Size = UDim2.new(0,0,1,0)}, Enum.EasingStyle.Linear,Enum.EasingDirection.InOut):Play()
            task.wait(Notification.Duration)
            Notification:Close()
        end
    end)
    
    if CloseButton then
        local CloseScale = CloseButton.UIScale
        Creator.AddSignal(CloseButton.MouseEnter, function()
            Tween(CloseButton, 0.2, {Rotation = 45}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(CloseScale, 0.2, {Scale = 1.15}, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
            Tween(CloseButton, 0.15, {ImageTransparency = 0}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
        end)
        Creator.AddSignal(CloseButton.MouseLeave, function()
            Tween(CloseButton, 0.2, {Rotation = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(CloseScale, 0.2, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(CloseButton, 0.15, {ImageTransparency = .4}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
        end)
        Creator.AddSignal(CloseButton.TextButton.MouseButton1Click, function()
            Notification:Close()
        end)
    end
    
    --Tween():Play()
    return Notification
end

return NotificationModule
