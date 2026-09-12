local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Intro = {}
Intro.IsPlaying = false

function Intro.Show(Config)
	Config = Config or {}

	local Duration = Config.Duration or 3.5
	local Title = Config.Title or "Loading xFuxk"

	Intro.IsPlaying = true

	-- Evita crear otra intro encima de una existente
	if Intro.Gui then
		Intro.Gui:Destroy()
		Intro.Gui = nil
	end

	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

	local Gui = Instance.new("ScreenGui")
	Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Gui.Parent = PlayerGui

	Intro.Gui = Gui

	local Container = Instance.new("ImageLabel")
	Container.BorderSizePixel = 0
	Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Container.ImageColor3 = Color3.fromRGB(77, 77, 77)
	Container.AnchorPoint = Vector2.new(0.5, 0.5)
	Container.Image = "rbxassetid://90245988184263"
	Container.Size = UDim2.new(0.27686, 0, 0.27466, 0)
	Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Container.BackgroundTransparency = 1
	Container.Position = UDim2.new(0.46907, 0, 0.48089, 0)
	Container.Parent = Gui

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.TextWrapped = true
	TitleLabel.BorderSizePixel = 0
	TitleLabel.TextSize = 22
	TitleLabel.TextScaled = true
	TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(0.6821, 0, 0.22151, 0)
	TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TitleLabel.Text = Title
	TitleLabel.Name = "Hubtitle"
	TitleLabel.Position = UDim2.new(0.29529, 0, 0.23209, 0)
	TitleLabel.Parent = Container

	local TitleStroke = Instance.new("UIStroke")
	TitleStroke.Thickness = 0.056
	TitleStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	TitleStroke.Parent = TitleLabel

	local DisplayName = Instance.new("TextLabel")
	DisplayName.TextWrapped = true
	DisplayName.BorderSizePixel = 0
	DisplayName.TextSize = 14
	DisplayName.TextScaled = true
	DisplayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DisplayName.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	DisplayName.BackgroundTransparency = 1
	DisplayName.Size = UDim2.new(0.4513, 0, 0.25185, 0)
	DisplayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DisplayName.Text = "@" .. LocalPlayer.DisplayName
	DisplayName.Name = "Hubtitle"
	DisplayName.Position = UDim2.new(0.34801, 0, 0.48667, 0)
	DisplayName.Parent = Container

	local DisplayNameStroke = Instance.new("UIStroke")
	DisplayNameStroke.Thickness = 0.056
	DisplayNameStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	DisplayNameStroke.Parent = DisplayName

	local Avatar = Instance.new("ImageLabel")
	Avatar.Name = "Avatar"
	Avatar.BorderSizePixel = 0
	Avatar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	Avatar.Size = UDim2.new(0, 81, 0, 79)
	Avatar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Avatar.BackgroundTransparency = 1
	Avatar.Position = UDim2.new(0.0415, 0, 0.28823, 0)
	Avatar.Parent = Container

	local AvatarCorner = Instance.new("UICorner")
	AvatarCorner.CornerRadius = UDim.new(1, 5)
	AvatarCorner.Parent = Avatar

	-- Obtener avatar
	task.spawn(function()
		local Success, Image = pcall(function()
			return Players:GetUserThumbnailAsync(
				LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size100x100
			)
		end)

		if Success and Intro.Gui == Gui then
			Avatar.Image = Image
		end
	end)

	task.delay(Duration, function()
		if Intro.Gui ~= Gui then
			return
		end

		Gui:Destroy()
		Intro.Gui = nil
		Intro.IsPlaying = false
	end)
end

function Intro.Wait()
	while Intro.IsPlaying do
		task.wait()
	end
end

function Intro.Hide()
	if not Intro.Gui then
		return
	end

	Intro.Gui:Destroy()
	Intro.Gui = nil
	Intro.IsPlaying = false
end

return Intro