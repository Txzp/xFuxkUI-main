local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Intro = {}

local function Tween(Object, Duration, Properties, EasingStyle, EasingDirection)
local TweenInfoObject = TweenInfo.new(
Duration,
EasingStyle or Enum.EasingStyle.Quint,
EasingDirection or Enum.EasingDirection.Out
)

return TweenService:Create(Object, TweenInfoObject, Properties)

end

function Intro.Show(Config)
Config = Config or {}

local Duration = Config.Duration or 3.5
local Title = Config.Title or "Loading xFuxk"

-- Evita crear otra intro encima de una existente
if Intro.Gui then
	Intro.Gui:Destroy()
	Intro.Gui = nil
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Gui = Instance.new("ScreenGui")
Gui.Name = "xFuxkIntro"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 999999
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

Intro.Gui = Gui

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.Size = UDim2.fromOffset(270, 80)
Container.BackgroundTransparency = 1
Container.Parent = Gui

-- Texto
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.BackgroundTransparency = 1
TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
TitleLabel.Position = UDim2.new(0, -25, 0, 20)
TitleLabel.Size = UDim2.fromOffset(205, 28)
TitleLabel.Font = Enum.Font.GothamSemibold
TitleLabel.Text = Title
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Container

local DisplayName = Instance.new("TextLabel")
DisplayName.Name = "DisplayName"
DisplayName.BackgroundTransparency = 1
DisplayName.AnchorPoint = Vector2.new(0, 0.5)
DisplayName.Position = UDim2.new(0, -25, 0, 47)
DisplayName.Size = UDim2.fromOffset(205, 24)
DisplayName.Font = Enum.Font.Gotham
DisplayName.Text = "@" .. LocalPlayer.DisplayName
DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayName.TextSize = 14
DisplayName.TextTransparency = 1
DisplayName.TextXAlignment = Enum.TextXAlignment.Left
DisplayName.Parent = Container

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Name = "Avatar"
Avatar.BackgroundTransparency = 1
Avatar.AnchorPoint = Vector2.new(1, 0.5)
Avatar.Position = UDim2.new(1, 25, 0.5, 0)
Avatar.Size = UDim2.fromOffset(58, 58)
Avatar.ImageTransparency = 1
Avatar.Parent = Container

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
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

-- Posiciones iniciales
TitleLabel.Position = UDim2.new(0, -40, 0, 20)
DisplayName.Position = UDim2.new(0, -40, 0, 47)
Avatar.Position = UDim2.new(1, 40, 0.5, 0)

-- Entrada
Tween(TitleLabel, 0.45, {
	Position = UDim2.new(0, 0, 0, 20),
	TextTransparency = 0,
}):Play()

Tween(DisplayName, 0.45, {
	Position = UDim2.new(0, 0, 0, 47),
	TextTransparency = 0.15,
}):Play()

Tween(Avatar, 0.45, {
	Position = UDim2.new(1, 0, 0.5, 0),
	ImageTransparency = 0,
}):Play()

-- Duración total de la intro
task.delay(Duration, function()
	if Intro.Gui ~= Gui then
		return
	end

	-- Salida
	Tween(TitleLabel, 0.4, {
		Position = UDim2.new(0, -25, 0, 20),
		TextTransparency = 1,
	}, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()

	Tween(DisplayName, 0.4, {
		Position = UDim2.new(0, -25, 0, 47),
		TextTransparency = 1,
	}, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()

	local AvatarTween = Tween(Avatar, 0.4, {
		Position = UDim2.new(1, 25, 0.5, 0),
		ImageTransparency = 1,
	}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	AvatarTween:Play()

	AvatarTween.Completed:Wait()

	if Intro.Gui == Gui then
		Gui:Destroy()
		Intro.Gui = nil
	end
end)

end

function Intro.Hide()
	if not Intro.Gui then
		return
	end

	Intro.Gui:Destroy()
	Intro.Gui = nil
end

return Intro