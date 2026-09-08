local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Intro = {
	IsPlaying = false,
}

local function Tween(Object, Duration, Properties, EasingStyle, EasingDirection)
	return TweenService:Create(
		Object,
		TweenInfo.new(
			Duration,
			EasingStyle or Enum.EasingStyle.Quint,
			EasingDirection or Enum.EasingDirection.Out
		),
		Properties
	)
end

function Intro.Show(Config)
	Config = Config or {}

	local Duration = Config.Duration or 3.5
	local Title = Config.Title or "Loading xFuxk"
	local Subtitle = Config.Subtitle or "Key System"

	if Intro.Gui then
		Intro.Gui:Destroy()
	end

	Intro.IsPlaying = true

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
	Container.Size = UDim2.fromOffset(430, 150)
	Container.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
	Container.BackgroundTransparency = 1
	Container.Parent = Gui

	local ContainerCorner = Instance.new("UICorner")
	ContainerCorner.CornerRadius = UDim.new(0, 18)
	ContainerCorner.Parent = Container

	local ContainerStroke = Instance.new("UIStroke")
	ContainerStroke.Color = Color3.fromRGB(255, 255, 255)
	ContainerStroke.Thickness = 1
	ContainerStroke.Transparency = 1
	ContainerStroke.Parent = Container

	local Avatar = Instance.new("ImageLabel")
	Avatar.Name = "Avatar"
	Avatar.AnchorPoint = Vector2.new(0, 0.5)
	Avatar.Position = UDim2.new(0, 8, 0.5, 0)
	Avatar.Size = UDim2.fromOffset(82, 82)
	Avatar.BackgroundTransparency = 1
	Avatar.ImageTransparency = 1
	Avatar.Parent = Container

	local AvatarCorner = Instance.new("UICorner")
	AvatarCorner.CornerRadius = UDim.new(1, 0)
	AvatarCorner.Parent = Avatar

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
	TitleLabel.Position = UDim2.new(0, 92, 0, 62)
	TitleLabel.Size = UDim2.fromOffset(310, 32)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Font = Enum.Font.GothamSemibold
	TitleLabel.Text = Title
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 20
	TitleLabel.TextTransparency = 1
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Container

	local SubtitleLabel = Instance.new("TextLabel")
	SubtitleLabel.Name = "Subtitle"
	SubtitleLabel.AnchorPoint = Vector2.new(0, 0.5)
	SubtitleLabel.Position = UDim2.new(0, 92, 0, 102)
	SubtitleLabel.Size = UDim2.fromOffset(310, 24)
	SubtitleLabel.BackgroundTransparency = 1
	SubtitleLabel.Font = Enum.Font.Gotham
	SubtitleLabel.Text = Subtitle
	SubtitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	SubtitleLabel.TextSize = 14
	SubtitleLabel.TextTransparency = 1
	SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	SubtitleLabel.Parent = Container

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

	Tween(Container, 0.45, { BackgroundTransparency = 0.08 }):Play()
	Tween(ContainerStroke, 0.45, { Transparency = 0.78 }):Play()
	Tween(Avatar, 0.45, {
		Position = UDim2.new(0, 28, 0.5, 0),
		ImageTransparency = 0,
	}):Play()
	Tween(TitleLabel, 0.45, {
		Position = UDim2.new(0, 122, 0, 62),
		TextTransparency = 0,
	}):Play()
	Tween(SubtitleLabel, 0.45, {
		Position = UDim2.new(0, 122, 0, 102),
		TextTransparency = 0.15,
	}):Play()

	task.delay(Duration, function()
		if Intro.Gui ~= Gui then
			return
		end

		Tween(Container, 0.4, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()
		Tween(ContainerStroke, 0.4, { Transparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()
		Tween(Avatar, 0.4, {
			Position = UDim2.new(0, 8, 0.5, 0),
			ImageTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()
		Tween(TitleLabel, 0.4, {
			Position = UDim2.new(0, 92, 0, 62),
			TextTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()
		local SubtitleTween = Tween(SubtitleLabel, 0.4, {
			Position = UDim2.new(0, 92, 0, 102),
			TextTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		SubtitleTween:Play()
		SubtitleTween.Completed:Wait()

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
	if Intro.Gui then
		Intro.Gui:Destroy()
		Intro.Gui = nil
	end
	Intro.IsPlaying = false
end

return Intro
