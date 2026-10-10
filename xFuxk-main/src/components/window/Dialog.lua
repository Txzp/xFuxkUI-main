local Creator = require("src/modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local DialogModule = {
	Holder = nil,
	Parent = nil,
}

function DialogModule.Create(Key, Type, Window, WindUI, Parent)
	local Dialog = {
		UICorner = 28,
		UIPadding = 12,
		Window = Window,
		WindUI = WindUI,
		UIElements = {},
	}

	if Key then
		Dialog.UIPadding = 0
	end
	if Key then
		Dialog.UICorner = 26
	end

	Type = Type or "Dialog"

	if not Key then
		Dialog.UIElements.FullScreen = New("Frame", {
			ZIndex = 999,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromHex("#000000"),
			Size = UDim2.new(1, 0, 1, 0),
			Active = false,
			Visible = false,
			Parent = DialogModule.Parent
				or (Window and Window.UIElements and Window.UIElements.Main and Window.UIElements.Main.Main),
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})
	end

	local Blur = New("ImageLabel", {
		Image = "rbxassetid://8992230677",
		ThemeTag = {
			ImageColor3 = "WindowShadow",
		},
		ImageTransparency = 1,
		Size = UDim2.new(1, 100, 1, 100),
		Position = UDim2.new(0, -50, 0, -50),
		ScaleType = "Slice",
		SliceCenter = Rect.new(99, 99, 99, 99),
		BackgroundTransparency = 1,
		ZIndex = -999999999999999,
		Name = "Blur",
	})

	Dialog.UIElements.Main = New("Frame", {
		Size = UDim2.new(0, 280, 0, 0),
		ThemeTag = {
			BackgroundColor3 = Type .. "Background",
		},
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 99999,
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, Dialog.UIPadding),
			PaddingLeft = UDim.new(0, Dialog.UIPadding),
			PaddingRight = UDim.new(0, Dialog.UIPadding),
			PaddingBottom = UDim.new(0, Dialog.UIPadding),
		}),
	})

	Dialog.UIElements.MainContainer = Creator.NewRoundFrame(Dialog.UICorner, "Squircle", {
		Visible = false,
		ImageTransparency = Key and 0.15 or 0,
		Parent = Parent or Dialog.UIElements.FullScreen,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = "XY",
		ThemeTag = {
			ImageColor3 = Type .. "Background",
			ImageTransparency = Type .. "BackgroundTransparency",
		},
		ZIndex = 9999,
	}, {
		Creator.NewRoundFrame(Dialog.UICorner, "Glass-1", {
		    ImageTransparency = 0.89,
		    Size = UDim2.new(1,0,1,0)
		}),
		Dialog.UIElements.Main,
	})

	function Dialog:Open()
		if not Key then
			Dialog.UIElements.FullScreen.Visible = true
			Dialog.UIElements.FullScreen.Active = true
		end

		task.spawn(function()
			if Type == "Dialog" then
				local MainContainer = Dialog.UIElements.MainContainer
				local TargetPosition = MainContainer.Position
				local StartPosition = UDim2.new(
					TargetPosition.X.Scale,
					TargetPosition.X.Offset,
					TargetPosition.Y.Scale,
					TargetPosition.Y.Offset + 10
				)
				local Scale = New("UIScale", {
					Scale = 0.94,
					Parent = MainContainer,
				})

				MainContainer.Position = StartPosition
				Tween(
					MainContainer,
					0.42,
					{ Position = TargetPosition },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
				Tween(Scale, 0.42, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
			end

			Dialog.UIElements.MainContainer.Visible = true

			if not Key then
				Tween(Dialog.UIElements.FullScreen, 0.1, { BackgroundTransparency = 0.3 }):Play()
			end
			Tween(Dialog.UIElements.MainContainer, 0.1, { ImageTransparency = 0 }):Play()
			
			task.spawn(function()
				task.wait(0.05)
				Dialog.UIElements.Main.Visible = true
			end)
		end)
	end

	function Dialog:Close()
		if Dialog.IsClosing then
			return function() end
		end
		Dialog.IsClosing = true

		if Dialog.DragModule then
			Dialog.DragModule:Set(false)
		end

		if not Key then
			Tween(Dialog.UIElements.FullScreen, 0.2, { BackgroundTransparency = 1 }):Play()
			Dialog.UIElements.FullScreen.Active = false
		end
		local Scale = Dialog.UIElements.MainContainer:FindFirstChildOfClass("UIScale")
		if not Scale then
			Scale = New("UIScale", {
				Scale = 1,
				Parent = Dialog.UIElements.MainContainer,
			})
		end

		Tween(Scale, 0.2, { Scale = 0.94 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()
		Tween(Dialog.UIElements.MainContainer, 0.2, { ImageTransparency = 1 }):Play()

		task.delay(0.2, function()
			if Dialog.UIElements.MainContainer.Parent then
				Dialog.UIElements.MainContainer:Destroy()
			end
			if not Key and Dialog.UIElements.FullScreen.Parent then
				Dialog.UIElements.FullScreen:Destroy()
			end
		end)

		return function() end
	end

	return Dialog
end

return DialogModule
