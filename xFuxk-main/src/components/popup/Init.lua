local PopupModule = {}

local Creator = require("src/modules/Creator")
local New = Creator.New
local Tween = Creator.Tween


function PopupModule.new(PopupConfig, Parent)
    local Popup = {
        Title = PopupConfig.Title or "Dialog",
        Version = PopupConfig.Version and tostring(PopupConfig.Version),
        Content = PopupConfig.Content,
        Icon = PopupConfig.Icon,
        IconThemed = PopupConfig.IconThemed,
        Thumbnail = PopupConfig.Thumbnail,
        Buttons = PopupConfig.Buttons,
        
        IconSize = 22,
    }
    
    local DialogInit = require("../window/Dialog")
    local Dialog = DialogInit.Create(true, "Popup", PopupConfig.WindUI.Window, PopupConfig.WindUI, Parent)
    
    local ThumbnailSize = 200
    
    local UISize = 430
    if Popup.Thumbnail and Popup.Thumbnail.Image then
        UISize = 430+(ThumbnailSize/2)
    end
    
    Dialog.UIElements.Main.AutomaticSize = "Y"
    Dialog.UIElements.Main.Size = UDim2.new(0,UISize,0,0)
    
    
    
    local IconFrame
    
    if Popup.Icon then
        IconFrame = Creator.Image(
            Popup.Icon,
            Popup.Title .. ":" .. Popup.Icon,
            0,
            PopupConfig.WindUI.Window,
            "Popup",
            true,
            PopupConfig.IconThemed,
            "PopupIcon"
        )
        IconFrame.Size = UDim2.new(0,Popup.IconSize,0,Popup.IconSize)
        IconFrame.LayoutOrder = -1
    end
    
    
    local Title = New("TextLabel", {
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Text = Popup.Title,
        TextXAlignment = "Left",
        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        ThemeTag = {
            TextColor3 = "PopupTitle",
        },
        TextSize = 20,
        TextWrapped = true,
        Size = UDim2.new(1, IconFrame and -Popup.IconSize-14 or 0,0,0)
    })

    local VersionBadge
    if Popup.Version and Popup.Version ~= "" then
        local VersionText = New("TextLabel", {
            AutomaticSize = "XY",
            BackgroundTransparency = 1,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
            Text = Popup.Version,
            TextSize = 13,
            ThemeTag = {
                TextColor3 = "Text",
            },
        })

        VersionBadge = New("Frame", {
            AutomaticSize = "XY",
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.92,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }),
            New("UIStroke", {
                Color = Color3.new(1, 1, 1),
                Transparency = 0.72,
                Thickness = 1,
            }),
            VersionText,
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 9),
                PaddingRight = UDim.new(0, 9),
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
            }),
        })
    end

    local IconAndTitleContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = "XY",
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0,14),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center"
        }),
        IconFrame, Title
    })
    
    local TitleContainer = New("Frame", {
        AutomaticSize = "Y",
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = "Vertical",
            SortOrder = "LayoutOrder",
        }),
        IconAndTitleContainer,
        VersionBadge,
    })
    
    local NoteText
    if Popup.Content and Popup.Content ~= "" then
        if PopupConfig.BulletPoints then
            local ContentLayout = New("UIListLayout", {
                SortOrder = "LayoutOrder",
                Padding = UDim.new(0, 6),
            })
            local ContentLines = New("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = "Y",
                BackgroundTransparency = 1,
            }, {
                ContentLayout,
            })

            local LineCount = 0
            local Content = string.gsub(tostring(Popup.Content), "\r\n", "\n")
            for Line in string.gmatch(Content .. "\n", "(.-)\n") do
                Line = string.gsub(Line, "^%s*(.-)%s*$", "%1")
                if Line ~= "" then
                    LineCount = LineCount + 1
                    if string.sub(Line, 1, #"•") ~= "•" then
                        Line = "• " .. Line
                    end

                    New("TextLabel", {
                        LayoutOrder = LineCount,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = "Y",
                        BackgroundTransparency = 1,
                        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                        Text = Line,
                        TextSize = 18,
                        TextTransparency = 0.2,
                        TextXAlignment = "Left",
                        TextWrapped = true,
                        RichText = true,
                        ThemeTag = {
                            TextColor3 = "PopupContent",
                        },
                    }, {
                        New("UIPadding", {
                            PaddingLeft = UDim.new(0, 2),
                            PaddingRight = UDim.new(0, 2),
                        }),
                    }).Parent = ContentLines
                end
            end

            if LineCount > 0 then
                local CurrentCamera = workspace.CurrentCamera
                local ViewportHeight = CurrentCamera and CurrentCamera.ViewportSize.Y or 720
                local MaxContentHeight = math.clamp(ViewportHeight - 220, 80, 320)

                NoteText = New("ScrollingFrame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = "None",
                    AutomaticCanvasSize = "Y",
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollingDirection = "Y",
                    ScrollBarThickness = 0,
                    ScrollBarImageTransparency = 1,
                    ElasticBehavior = "Never",
                    ClipsDescendants = true,
                    BackgroundTransparency = 1,
                }, {
                    ContentLines,
                })

                local function UpdateContentHeight()
                    NoteText.Size = UDim2.new(
                        1,
                        0,
                        0,
                        math.min(ContentLayout.AbsoluteContentSize.Y, MaxContentHeight)
                    )
                end

                Creator.AddSignal(ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), UpdateContentHeight)
                UpdateContentHeight()
            end
        else
            NoteText = New("TextLabel", {
                Size = UDim2.new(1,0,0,0),
                AutomaticSize = "Y",
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                TextXAlignment = "Left",
                Text = Popup.Content,
                TextSize = 18,
                TextTransparency = .2,
                ThemeTag = {
                    TextColor3 = "PopupContent",
                },
                BackgroundTransparency = 1,
                RichText = true,
                TextWrapped = true,
            })
        end
    end

    local ButtonsContainer = New("Frame", {
        Size = UDim2.new(1,0,0,46),
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0,18/2),
            FillDirection = "Horizontal",
            HorizontalAlignment = "Right"
        })
    })
    
    local ThumbnailFrame
    if Popup.Thumbnail and Popup.Thumbnail.Image then
        local ThumbnailTitle
        if Popup.Thumbnail.Title then
            ThumbnailTitle = New("TextLabel", {
                Text = Popup.Thumbnail.Title,
                ThemeTag = {
                    TextColor3 = "Text",
                },
                TextSize = 18,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                BackgroundTransparency = 1,
                AutomaticSize = "XY",
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
            })
        end
        ThumbnailFrame = New("ImageLabel", {
            Image = Popup.Thumbnail.Image,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,ThumbnailSize,1,0),
            Parent = Dialog.UIElements.Main,
            ScaleType = "Crop"
        }, {
            ThumbnailTitle,
            New("UICorner", {
                CornerRadius = UDim.new(0,0),
            })
        })
    end
    
    local MainFrame = New("Frame", {
        --AutomaticSize = "XY",
        Size = UDim2.new(1, ThumbnailFrame and -ThumbnailSize or 0,1,0),
        Position = UDim2.new(0, ThumbnailFrame and ThumbnailSize or 0,0,0),
        BackgroundTransparency = 1,
        Parent = Dialog.UIElements.Main
    }, {
        New("Frame", {
            --AutomaticSize = "XY",
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,18),
                FillDirection = "Vertical",
            }),
            TitleContainer,
            NoteText,
            ButtonsContainer,
            New("UIPadding", {
                PaddingTop = UDim.new(0,18),
                PaddingLeft = UDim.new(0,16),
                PaddingRight = UDim.new(0,16),
                PaddingBottom = UDim.new(0,24),
            })
        }),
    })

    -- ... (todo el código anterior se mantiene igual hasta la línea del for)

    local CreateButton = require("../ui/Button").New
    
    for _, values in next, Popup.Buttons do
        CreateButton(values.Title, values.Icon, values.Callback, values.Variant, ButtonsContainer, Dialog, nil, nil, values.Color)
    end  -- <--- ¡AGREGA ESTE 'end' PARA CERRAR EL FOR!

    local PopupScale = New("UIScale", {
        Scale = 0.92,
        Parent = Dialog.UIElements.MainContainer,
    })

    Dialog:Open()
    Tween(PopupScale, 0.42, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
    
    return Popup
end

return PopupModule