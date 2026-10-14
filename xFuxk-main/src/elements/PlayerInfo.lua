local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Creator = require("src/modules/Creator")
local New = Creator.New

local LocalPlayer = Players.LocalPlayer
local ExecutorIcon = Creator.Icon("terminal")

local Element = {}

local function FormatElapsedTime(seconds)
	seconds = math.max(0, math.floor(seconds))
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor(seconds % 3600 / 60)
	local remainingSeconds = seconds % 60
	return string.format("%02d:%02d:%02d", hours, minutes, remainingSeconds)
end

local function GetExecutorName()
	if RunService:IsStudio() then
		return "Studio"
	end

	local identify = identifyexecutor
	if type(identify) ~= "function" then
		identify = getexecutorname
	end

	if type(identify) ~= "function" then
		return "Unknown"
	end

	local success, name = pcall(identify)
	if not success then
		warn("[ WindUI.PlayerInfo ] Executor identification failed: " .. tostring(name))
		return "Unknown"
	end

	if type(name) ~= "string" or name:match("^%s*$") then
		return "Unknown"
	end

	return name
end

function Element:New(Config)
	local ShowAvatar = Config.ShowAvatar ~= false
	local ShowDisplayName = Config.ShowDisplayName ~= false
	local ShowUsername = Config.ShowUsername ~= false
	local ShowSessionTime = Config.ShowSessionTime ~= false
	local ShowExecutor = Config.ShowExecutor ~= false

	local PlayerInfo = {
		__type = "PlayerInfo",
		Title = Config.Title or "Player",
		Locked = Config.Locked or false,
		Player = LocalPlayer,
		UIElements = {},
	}

	local ElementConfig = {
		Title = "",
		Desc = nil,
		Hover = false,
		TextOffset = 0,
		ParentConfig = Config,
		Parent = Config.Parent,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = PlayerInfo,
	}

	local PlayerInfoFrame = require("../components/window/Element")(ElementConfig)
	PlayerInfoFrame.UIElements.Container.Size = UDim2.new(1, 0, 0, 0)
	PlayerInfoFrame.UIElements.Container.TitleFrame.Visible = false

	local AvatarSize = 70
	local SessionColumnWidth = 82
	local ColumnGap = 10
	local RowChildren = {}
	local FixedWidth = 0
	local VisibleColumns = 0

	local function AddColumn(column, width)
		table.insert(RowChildren, column)
		VisibleColumns += 1
		if width then
			FixedWidth += width
		end
	end

	if ShowAvatar then
		local Avatar = New("ImageLabel", {
			Name = "Avatar",
			Size = UDim2.new(0, AvatarSize, 0, AvatarSize),
			BackgroundTransparency = 1,
			Image = string.format(
				"rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150",
				LocalPlayer.UserId
			),
			ScaleType = "Crop",
			LayoutOrder = 1,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, math.max(Config.Window.ElementConfig.UICorner - 4, 0)),
			}),
		})
		AddColumn(Avatar, AvatarSize)
	end

	local InfoLabels = {}
	local DisplayNameLabel
	local UsernameLabel
	local function AddInfoLabel(text, layoutOrder, textSize, fontWeight, textTransparency)
		local label = New("TextLabel", {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = text,
			TextSize = textSize,
			TextTransparency = textTransparency or 0,
			TextXAlignment = "Left",
			TextTruncate = "AtEnd",
			FontFace = Font.new(Creator.Font, fontWeight),
			ThemeTag = {
				TextColor3 = "Text",
			},
			LayoutOrder = layoutOrder,
		})
		table.insert(InfoLabels, label)
		return label
	end

	if ShowDisplayName then
		DisplayNameLabel = AddInfoLabel(LocalPlayer.DisplayName, 1, 17, Enum.FontWeight.SemiBold)
	end

	if ShowUsername then
		UsernameLabel = AddInfoLabel("@" .. LocalPlayer.Name, 2, 14, Enum.FontWeight.Medium, 0.2)
	end

	if ShowExecutor then
		local executorName = GetExecutorName()
		local ExecutorRow = New("Frame", {
			Name = "Executor",
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			LayoutOrder = 3,
		}, {
			New("UIListLayout", {
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				Padding = UDim.new(0, 5),
			}),
			New("ImageLabel", {
				Size = UDim2.new(0, 14, 0, 14),
				BackgroundTransparency = 1,
				Image = ExecutorIcon[1],
				ImageRectOffset = ExecutorIcon[2].ImageRectPosition,
				ImageRectSize = ExecutorIcon[2].ImageRectSize,
				ThemeTag = {
					ImageColor3 = "Text",
				},
			}),
			New("TextLabel", {
				Name = "Value",
				Size = UDim2.new(1, -19, 1, 0),
				BackgroundTransparency = 1,
				Text = "Exe: " .. executorName,
				TextSize = 13,
				TextTransparency = 0.2,
				TextXAlignment = "Left",
				TextTruncate = "AtEnd",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
		})
		table.insert(InfoLabels, ExecutorRow)
	end

	local InfoColumn
	if #InfoLabels > 0 or ShowSessionTime then
		InfoColumn = New("Frame", {
			Name = "PlayerDetails",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			LayoutOrder = 2,
		}, {
			New("UIListLayout", {
				FillDirection = "Vertical",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Left",
				Padding = UDim.new(0, 3),
			}),
		})
		for _, label in ipairs(InfoLabels) do
			label.Parent = InfoColumn
		end
		AddColumn(InfoColumn)
	end

	local SessionTime
	if ShowSessionTime then
		local SessionColumn = New("Frame", {
			Name = "Session",
			Size = UDim2.new(0, SessionColumnWidth, 0, 42),
			BackgroundTransparency = 1,
			LayoutOrder = 3,
		}, {
			New("UIListLayout", {
				FillDirection = "Vertical",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Right",
				Padding = UDim.new(0, 2),
			}),
			New("TextLabel", {
				Size = UDim2.new(1, 0, 0, 18),
				BackgroundTransparency = 1,
				Text = "Session",
				TextSize = 12,
				TextTransparency = 0.35,
				TextXAlignment = "Right",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
			New("TextLabel", {
				Name = "Time",
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundTransparency = 1,
				Text = "00:00:00",
				TextSize = 16,
				TextXAlignment = "Right",
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				TextColor3 = Color3.fromRGB(46, 204, 113),
			}),
		})
		SessionTime = SessionColumn.Time
		AddColumn(SessionColumn, SessionColumnWidth)
	end

	local Row = New("Frame", {
		Name = "PlayerInfo",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Left",
			Padding = UDim.new(0, ColumnGap),
		}),
	})

	local GapCount = math.max(VisibleColumns - 1, 0)
	if InfoColumn then
		InfoColumn.Size = UDim2.new(1, -FixedWidth - GapCount * ColumnGap, 0, 0)
	end

	for _, column in ipairs(RowChildren) do
		column.Parent = Row
	end

	Row.Parent = PlayerInfoFrame.UIElements.Container
	PlayerInfoFrame.UIElements.Container.Visible = true

	PlayerInfo.PlayerInfoFrame = PlayerInfoFrame
	PlayerInfo.UIElements.Avatar = PlayerInfoFrame.UIElements.Container:FindFirstChild("Avatar", true)
	PlayerInfo.UIElements.DisplayName = DisplayNameLabel
	PlayerInfo.UIElements.Username = UsernameLabel
	PlayerInfo.UIElements.SessionTime = SessionTime

	if SessionTime then
		task.spawn(function()
			while PlayerInfoFrame.UIElements.Main.Parent do
				SessionTime.Text = FormatElapsedTime(os.clock() - Config.WindUI.StartedAt)
				task.wait(1)
			end
		end)
	end

	return PlayerInfo.__type, PlayerInfo
end

return Element
