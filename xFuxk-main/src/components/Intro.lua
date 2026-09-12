local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Intro = {}
Intro.IsPlaying = false

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

	Intro.IsPlaying = true

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

	-- Fondo completo, sólido y sin transparencia
	local Background = Instance.new("Frame")
	Background.Name = "Background"
	Background.Size = UDim2.fromScale(1, 1)
	Background.Position = UDim2.fromScale(0, 0)
	Background.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
	Background.BackgroundTransparency = 0
	Background.BorderSizePixel = 0
	Background.Parent = Gui

	-- Contenedor pequeño para el contenido central
	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.AnchorPoint = Vector2.new(0.5, 0.5)
	Container.Position = UDim2.fromScale(0.5, 0.5)
	Container.Size = UDim2.fromOffset(360, 130)
	Container.BackgroundTransparency = 1
	Container.Parent = Background

	-- Avatar
	local Avatar = Instance.new("ImageLabel")
	Avatar.Name = "Avatar"
	Avatar.BackgroundTransparency = 1
	Avatar.AnchorPoint = Vector2.new(0.5, 0.5)
	Avatar.Position = UDim2.new(0.5, -110, 0.5, 0)
	Avatar.Size = UDim2.fromOffset(86, 86)
	Avatar.ImageTransparency = 0
	Avatar.Parent = Container

	local AvatarCorner = Instance.new("UICorner")
	AvatarCorner.CornerRadius = UDim.new(1, 0)
	AvatarCorner.Parent = Avatar

	-- Título
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
	TitleLabel.Position = UDim2.new(0.5, -58, 0.5, -18)
	TitleLabel.Size = UDim2.fromOffset(250, 42)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = Title
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 28
	TitleLabel.TextTransparency = 0
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
	TitleLabel.Parent = Container

	-- Display name
	local DisplayName = Instance.new("TextLabel")
	DisplayName.Name = "DisplayName"
	DisplayName.BackgroundTransparency = 1
	DisplayName.AnchorPoint = Vector2.new(0, 0.5)
	DisplayName.Position = UDim2.new(0.5, -58, 0.5, 16)
	DisplayName.Size = UDim2.fromOffset(250, 26)
	DisplayName.Font = Enum.Font.Gotham
	DisplayName.Text = "@" .. LocalPlayer.DisplayName
	DisplayName.TextColor3 = Color3.fromRGB(175, 175, 180)
	DisplayName.TextSize = 15
	DisplayName.TextTransparency = 0
	DisplayName.TextXAlignment = Enum.TextXAlignment.Left
	DisplayName.TextYAlignment = Enum.TextYAlignment.Center
	DisplayName.Parent = Container

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

	-- Posiciones iniciales para la entrada
	Avatar.Position = UDim2.new(0.5, -125, 0.5, 0)
	Avatar.ImageTransparency = 1

	TitleLabel.Position = UDim2.new(0.5, 15, 0.5, -18)
	TitleLabel.TextTransparency = 1

	DisplayName.Position = UDim2.new(0.5, 15, 0.5, 16)
	DisplayName.TextTransparency = 1

	-- Entrada del avatar
	Tween(Avatar, 0.5, {
		Position = UDim2.new(0.5, -110, 0.5, 0),
		ImageTransparency = 0,
	}):Play()

	-- Entrada del texto
	Tween(TitleLabel, 0.5, {
		Position = UDim2.new(0.5, -58, 0.5, -18),
		TextTransparency = 0,
	}):Play()

	Tween(DisplayName, 0.5, {
		Position = UDim2.new(0.5, -58, 0.5, 16),
		TextTransparency = 0,
	}):Play()

	-- Duración total de la intro
	task.delay(Duration, function()
		if Intro.Gui ~= Gui then
			return
		end

		-- Salida del contenido
		local AvatarTween = Tween(
			Avatar,
			0.4,
			{
				Position = UDim2.new(0.5, -125, 0.5, 0),
				ImageTransparency = 1,
			},
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.In
		)

		Tween(
			TitleLabel,
			0.4,
			{
				Position = UDim2.new(0.5, 15, 0.5, -18),
				TextTransparency = 1,
			},
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.In
		):Play()

		Tween(
			DisplayName,
			0.4,
			{
				Position = UDim2.new(0.5, 15, 0.5, 16),
				TextTransparency = 1,
			},
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.In
		):Play()

		AvatarTween:Play()
		AvatarTween.Completed:Wait()

		if Intro.Gui == Gui then
			Gui:Destroy()
			Intro.Gui = nil
			Intro.IsPlaying = false
		end
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