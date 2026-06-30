local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

function Library.CreateWindow(title,subtitle,size,version)
	local self = setmetatable({}, Library)

	self.mainTabs = {}
	self.CurrentTab = nil
	self.Elements = {}
	self.Notipos = 0.9
	self.tabpos = 0
	self.Theme = {
		BackGroundIcon = "rbxassetid://139069464889319",
		TextColor = Color3.fromRGB(255, 255, 255),
		SubTtitleTextColor = Color3.fromRGB(125, 125, 125),
		Notisubtitlecolor = Color3.fromRGB(199, 199, 199),
		HeaderColor = Color3.fromRGB(16, 17, 31),
		headerlinecolor = Color3.fromRGB(255, 255, 255),
		headerlinetrans = 1,
		TabsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		NotiImg = "rbxassetid://133419353491012",
		NotiTitleColor = Color3.fromRGB(255, 255, 255),
		BackGroundTran = 0.05,
		DestroyGFrame = Color3.fromRGB(22, 23, 42),
		DestroyGFrameTransparency = 0,
		dbtntran = 0.95,
		TabTransparancy = 0.95,
		dbtncolor = Color3.fromRGB(255, 255, 255),
		versionBackgroundColor3 = Color3.fromRGB(224, 206, 255),
		versionBackgroundTransparency = 0,
		versionTextColor = Color3.fromRGB(0, 0, 0),
		IOSdraglineColor = Color3.fromRGB(63, 59, 126),
		TabTextColor = Color3.fromRGB(255, 255, 255),
		TabColor = Color3.fromRGB(255, 255, 255),
		TabSubTtitleTextColor = Color3.fromRGB(199, 199, 199),
		TogleActivColor = Color3.fromRGB(63, 59, 126),
		DropDownArrowImg = Color3.fromRGB(69, 65, 140),
		TabsIconColor = Color3.fromRGB(255, 255, 255),
		InputTextColor = Color3.fromRGB(175, 175, 175),
		BackGroundElemTran = 0.95,
		BackGroundElemCol = Color3.fromRGB(255, 255, 255),
		BackGroundButtonTran = 0.95,
		ActionBackColor = Color3.fromRGB(255, 255, 255),
		ToggleButton = Color3.fromRGB(255, 255, 255),
		ToggleTran = 0.9,
		SectionsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		DropDownColor = Color3.fromRGB(16, 17, 31),
		DropDownTransparency = 0,
		DropDownFrameColor = Color3.fromRGB(63, 59, 126),
		SliderUnderLineColor = Color3.fromRGB(63, 59, 126),
		Togglebtn = Color3.fromRGB(255, 255, 255),
		Sliderball = Color3.fromRGB(255, 255, 255),
		ColorPickerColoro = Color3.fromRGB(16, 17, 31),
		ListFrameColor = Color3.fromRGB(16, 17, 31)
	}
	self.CurrentThemeName = "Cursed"
	self.AllElements = {
		Toggles = {},
		Keybinds = {},
		Dropdowns = {},
		Sliders = {},
		ColorPickers = {},
		Inputs = {}
	}
	self.ScrollingFrameCanvasSize = 0
	self.BlurEffect = nil
	self.Connections = {}
	self.ActiveTweens = {}
	self.Windowscd = false
	self.userinfo = true
	self.saveFolder = nil
	self.saveFileName = nil
	self.ActiveNotifications = {}
	self.OriginalTabElements = {}
	self.CurrentSearchResults = {}
	self.IsSearching = false

	local function getTargetContainer()
		if RunService:IsStudio() then
			return Players.LocalPlayer:WaitForChild("PlayerGui")
		end

		if typeof(gethui) == "function" then
			return gethui()
		end

		local success, coreGui = pcall(function()
			return game:GetService("CoreGui")
		end)

		if success and coreGui then
			return coreGui
		end

		return nil
	end

	self.UI = Instance.new("ScreenGui")
	self.UI.Name = math.random(100000, 999999)
	self.UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.UI.Parent = getTargetContainer()

	self.ImageLabel = Instance.new("ImageLabel")
	self.ImageLabel.Parent = self.UI
	self.ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.ImageLabel.BackgroundTransparency = 1
	self.ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.ImageLabel.BorderSizePixel = 0
	self.ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	self.ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	self.ImageLabel.Size = UDim2.new(0,10,0,10)

	if UserInputService.touchEnabled then
		local uiScale = Instance.new("UIScale")
		uiScale.Scale = 0.75
		uiScale.Parent = self.ImageLabel
	end

	self.ImageLabel.Image = self.Theme.BackGroundIcon
	self.ImageLabel.Active = true
	self.ImageLabel.Selectable = true
	self.ImageLabel.Draggable = true
	self.ImageLabel.ImageTransparency = 0.05

	self.IOSdragline = Instance.new("Frame")
	self.IOSdragline.Parent = self.ImageLabel
	self.IOSdragline.BackgroundColor3 = self.Theme.IOSdraglineColor
	self.IOSdragline.BackgroundTransparency = 0.4
	self.IOSdragline.BorderSizePixel = 0
	self.IOSdragline.Position = UDim2.new(0.31, 0, 0.99, 0)
	self.IOSdragline.Size = UDim2.new(0.4, 0, 0, 5)
	self.IOSdragline.ZIndex = 2

	local UIcorner = Instance.new("UICorner")
	UIcorner.Parent = self.IOSdragline
	UIcorner.CornerRadius = UDim.new(0, 12)

	self.IOSdragHitbox = Instance.new("Frame")
	self.IOSdragHitbox.Parent = self.ImageLabel
	self.IOSdragHitbox.BackgroundTransparency = 1
	self.IOSdragHitbox.BorderSizePixel = 0

	self.IOSdragHitbox.Size = UDim2.new(0, 300, 0, 40)
	self.IOSdragHitbox.Position = UDim2.new(0.3, -25, 0.95, 0)
	self.IOSdragHitbox.ZIndex = 1

	self.IOSdragHitbox.Active = true
	self.IOSdragHitbox.Selectable = true

	local dragging = false
	local dragInput
	local startInputPos
	local startGuiPos
	local moveConnection

	self.IOSdragHitbox.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		for _, v in pairs(self.Frame_7:GetChildren()) do
			if v:IsA("GuiObject") then
				v.Interactable = false
			end
		end

		dragging = true
		dragInput = input
		startInputPos = input.Position
		startGuiPos = self.ImageLabel.Position

		self:Tween(self.IOSdragline, { BackgroundTransparency = 0 }, 0.2)

		moveConnection = input.Changed:Connect(function()
			if not dragging then return end
			if input.UserInputState ~= Enum.UserInputState.Change then return end

			local delta = input.Position - startInputPos

			self.ImageLabel.Position = UDim2.new(
				startGuiPos.X.Scale,
				startGuiPos.X.Offset + delta.X,
				startGuiPos.Y.Scale,
				startGuiPos.Y.Offset + delta.Y
			)
		end)
	end)

	self.IOSdragHitbox.InputEnded:Connect(function(input)
		if input ~= dragInput then return end

		for _, v in pairs(self.Frame_7:GetChildren()) do
			if v:IsA("GuiObject") then
				v.Interactable = true
			end
		end

		dragging = false
		dragInput = nil

		if moveConnection then
			moveConnection:Disconnect()
			moveConnection = nil
		end

		self:Tween(self.IOSdragline, { BackgroundTransparency = 0.4 }, 0.2)
	end)

	self.Destroy_gui = Instance.new("Frame")
	self.dFrame_2 = Instance.new("Frame")
	self.dTextLabel = Instance.new("TextLabel")
	local dUICorner = Instance.new("UICorner")
	self.dTextLabel_2 = Instance.new("TextLabel")
	self.dTextButton = Instance.new("TextButton")
	local dUICorner_2 = Instance.new("UICorner")
	self.dTextButton_2 = Instance.new("TextButton")
	local dUICorner_3 = Instance.new("UICorner")
	local dUICorner_4 = Instance.new("UICorner")

	self.Destroy_gui.Parent = self.ImageLabel
	self.Destroy_gui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	self.Destroy_gui.BackgroundTransparency = 0.4
	self.Destroy_gui.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.Destroy_gui.BorderSizePixel = 0
	self.Destroy_gui.Position = UDim2.new(0.017231673, 0, 0.0208332706, 0)
	self.Destroy_gui.Size = UDim2.new(0, 560, 0, 460)
	self.Destroy_gui.Visible = false
	self.Destroy_gui.ZIndex = 10

	dUICorner_4.CornerRadius = UDim.new(0, 24)
	dUICorner_4.Parent = self.Destroy_gui

	self.dFrame_2.Parent = self.Destroy_gui
	self.dFrame_2.BackgroundColor3 = self.Theme.DestroyGFrame
	self.dFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.dFrame_2.BorderSizePixel = 0
	self.dFrame_2.Position = UDim2.new(0.306779772, 0, 0.328608334, 0)
	self.dFrame_2.Size = UDim2.new(0, 240, 0, 140)
	self.dFrame_2.Transparency = 1
	self.dFrame_2.BackgroundTransparency = self.Theme.DestroyGFrameTransparency
	self.dFrame_2.ZIndex = 10

	self.dTextLabel.Parent = self.dFrame_2
	self.dTextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.dTextLabel.BackgroundTransparency = 1.000
	self.dTextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.dTextLabel.BorderSizePixel = 2
	self.dTextLabel.Position = UDim2.new(0.0291666668, 0, 0.0349650346, 0)
	self.dTextLabel.Size = UDim2.new(0, 200, 0, 36)
	self.dTextLabel.Font = Enum.Font.FredokaOne
	self.dTextLabel.Text = "Destroy Interface?"
	self.dTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.dTextLabel.TextSize = 23.000
	self.dTextLabel.TextWrapped = true
	self.dTextLabel.Visible = false
	self.dTextLabel.TextXAlignment = Enum.TextXAlignment.Left

	dUICorner.CornerRadius = UDim.new(0, 12)
	dUICorner.Parent = self.dFrame_2

	self.dTextLabel_2.Parent = self.dFrame_2
	self.dTextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.dTextLabel_2.BackgroundTransparency = 1.000
	self.dTextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.dTextLabel_2.BorderSizePixel = 0
	self.dTextLabel_2.Position = UDim2.new(0.03, 0, 0.25, 0)
	self.dTextLabel_2.Size = UDim2.new(0, 219, 0, 40)
	self.dTextLabel_2.Font = Enum.Font.FredokaOne
	self.dTextLabel_2.TextWrapped = true
	self.dTextLabel_2.Text = "This action will permamently close the GUI."
	self.dTextLabel_2.TextColor3 = Color3.fromRGB(184, 184, 184)
	self.dTextLabel_2.TextSize = 15
	self.dTextLabel_2.Visible = false
	self.dTextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

	self.dTextButton.Parent = self.dFrame_2
	self.dTextButton.BackgroundColor3 = Color3.fromRGB(207, 0, 0)
	self.dTextButton.BackgroundTransparency = 0.4
	self.dTextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.dTextButton.BorderSizePixel = 0
	self.dTextButton.Position = UDim2.new(0.0170000009, 0, 0.721000016, 0)
	self.dTextButton.Size = UDim2.new(0, 112, 0, 36)
	self.dTextButton.ZIndex = 10
	self.dTextButton.Font = Enum.Font.FredokaOne
	self.dTextButton.Text = "Destroy"
	self.dTextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.dTextButton.Visible = false
	self.dTextButton.TextSize = 14.000

	self.dTextButton.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	dUICorner_2.CornerRadius = UDim.new(0, 5)
	dUICorner_2.Parent = self.dTextButton

	self.dTextButton_2.Parent = self.dFrame_2
	self.dTextButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.dTextButton_2.BackgroundTransparency = 0.950
	self.dTextButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.dTextButton_2.BorderSizePixel = 0
	self.dTextButton_2.Position = UDim2.new(0.51700002, 0, 0.721000016, 0)
	self.dTextButton_2.Size = UDim2.new(0, 112, 0, 36)
	self.dTextButton_2.ZIndex = 10
	self.dTextButton_2.Font = Enum.Font.FredokaOne
	self.dTextButton_2.Text = "Close"
	self.dTextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.dTextButton_2.Visible = false
	self.dTextButton_2.TextSize = 14.000

	self.dTextButton_2.MouseButton1Click:Connect(function()
		self:ShowDestroyQ()
	end)

	dUICorner_3.CornerRadius = UDim.new(0, 5)
	dUICorner_3.Parent = self.dTextButton_2

	function self:Blur()
		
	end
	function self:BlurOff()

	end
	self.Header = Instance.new("Frame")
	self.Header.Name = "Header"
	self.Header.Parent = self.ImageLabel
	self.Header.BackgroundColor3 = self.Theme.HeaderColor
	self.Header.BackgroundTransparency = 1
	self.Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.Header.BorderSizePixel = 0
	self.Header.Position = UDim2.new(0.0203390867, 0, 0.0250000004, 0)
	self.Header.Size = UDim2.new(0, size - 24, 0, 40)
	local HeaderUICorner = Instance.new("UICorner")
	HeaderUICorner.CornerRadius = UDim.new(0, 12)
	HeaderUICorner.Parent = self.Header

	self.Search = Instance.new("Frame")
	local SearchUICorner = Instance.new("UICorner")
	self.SearchImageLabel = Instance.new("ImageLabel")
	self.SearchTextBox2 = Instance.new("TextBox")

	self.SearchTextBox = self.SearchTextBox2

	self.SearchTextBox.Focused:Connect(function()
		if not self.OriginallyHidden then
			self.OriginallyHidden = {}
			for i, v in pairs(self.CurrentTab["Elements"]) do
				if not v.Visible then
					self.OriginallyHidden[i] = true
				end
			end
		end

		if self.SearchTextBox.Text == "Search..." then
			self.SearchTextBox.Text = ""
		end

		for i, v in pairs(self.CurrentTab["Elements"]) do
			if v.Visible then
				v.Visible = false
			end
		end
		self.SearchTextBox2.TextSize = 15.000
	end)

	self.SearchTextBox.FocusLost:Connect(function()
		if self.SearchTextBox.Text == "" then
			self.SearchTextBox2.TextSize = 14.000
			self.SearchTextBox.Text = "Search..."

			for i, v in pairs(self.CurrentTab["Elements"]) do
				if not self.OriginallyHidden or not self.OriginallyHidden[i] then
					v.Visible = true
				end
			end

			self.OriginallyHidden = nil
		end
	end)

	self.SearchTextBox:GetPropertyChangedSignal("Text"):Connect(function()
		self:SearchAllTabs()
	end)

	self.Search.Parent = self.Header
	self.Search.BackgroundColor3 =  self.Theme.dbtncolor
	self.Search.BackgroundTransparency =  self.Theme.dbtntran
	self.Search.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.Search.BorderSizePixel = 0
	self.Search.Position = UDim2.new(0.570, 0, 0.19, 0)
	self.Search.Size = UDim2.new(0, 140, 0, 26)

	SearchUICorner.Parent = self.Search
	SearchUICorner.CornerRadius = UDim.new(0.22, 0)

	self.SearchImageLabel.Parent = self.Search
	self.SearchImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.SearchImageLabel.BackgroundTransparency = 1.000
	self.SearchImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.SearchImageLabel.BorderSizePixel = 0
	self.SearchImageLabel.Position = UDim2.new(0.81, 0, 0.1, 0)
	self.SearchImageLabel.Size = UDim2.new(0, 20, 0, 20)
	self.SearchImageLabel.Image = "rbxassetid://136089190882362"

	self.SearchTextBox2.Parent = self.Search
	self.SearchTextBox2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.SearchTextBox2.BackgroundTransparency = 1.000
	self.SearchTextBox2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.SearchTextBox2.BorderSizePixel = 0
	self.SearchTextBox2.Position = UDim2.new(0.04, 0, 0.115000002, -0.9)
	self.SearchTextBox2.Size = UDim2.new(0, 90, 0, 20)
	self.SearchTextBox2.Font = Enum.Font.SourceSans
	self.SearchTextBox2.Text = "Search..."
	self.SearchTextBox2.Font = Enum.Font.FredokaOne
	self.SearchTextBox2.TextColor3 = self.Theme.TextColor
	self.SearchTextBox2.TextSize = 14.000
	self.SearchTextBox2.TextXAlignment = Enum.TextXAlignment.Left

	local function substr(str)
		local strlen = string.len(str)
		if(strlen > 50) then
			return string.sub(str,1,20)
		else
			return str
		end
	end

	local function labelsize(str)
		return string.len(str) * 7
	end

	local title = substr(title)
	local titlesize = labelsize(title)

	local subtitle = substr(subtitle)
	local subtitlesize = labelsize(subtitle)

	self.TextLabel = Instance.new("TextLabel")
	self.TextLabel.Parent = self.Header
	self.TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.TextLabel.BackgroundTransparency = 1.000
	self.TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.TextLabel.BorderSizePixel = 0
	self.TextLabel.Position = UDim2.new(0.02, 0, 0, -1)
	self.TextLabel.Size = UDim2.new(0, titlesize, 0, 40)
	self.TextLabel.Font = Enum.Font.FredokaOne
	self.TextLabel.Text = title
	self.TextLabel.TextColor3 = self.Theme.TextColor
	self.TextLabel.TextSize = 16.000
	self.TextLabel.TextWrapped = true
	self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	local positionsubt = self.TextLabel.Position.X.Scale
	local sizetitle = self.TextLabel.Size.X.Offset

	local trueposition = sizetitle + 10 + 5

	self.TextLabel_2 = Instance.new("TextLabel")
	self.TextLabel_2.Parent = self.Header
	self.TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.TextLabel_2.BackgroundTransparency = 1.000
	self.TextLabel_2.BorderColor3 = Color3.fromRGB(59, 59, 59)
	self.TextLabel_2.BorderSizePixel = 0
	self.TextLabel_2.Position = UDim2.new(0, trueposition, 0.05, -1)
	self.TextLabel_2.Size = UDim2.new(0, subtitlesize, 0, 40)
	self.TextLabel_2.Font = Enum.Font.FredokaOne
	self.TextLabel_2.Text = subtitle
	self.TextLabel_2.TextColor3 = self.Theme.SubTtitleTextColor
	self.TextLabel_2.TextSize = 12.000
	self.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

	if version then
		self.version = Instance.new("Frame")
		self.versionUICorner = Instance.new("UICorner")
		self.versionTextLabel = Instance.new("TextLabel")

		self.version.Parent = self.Header
		self.version.BackgroundColor3 = self.Theme.versionBackgroundColor3
		self.version.BackgroundTransparency = self.Theme.versionBackgroundTransparency
		self.version.BorderColor3 = Color3.fromRGB(0, 0, 0)
		self.version.BorderSizePixel = 0
		self.version.Position = UDim2.new(0, trueposition + subtitlesize - 2, 0.20, 0)
		self.version.Size = UDim2.new(0, 55, 0, 24)

		self.versionUICorner.Parent = self.version
		self.versionUICorner.CornerRadius = UDim.new(0, 11)


		self.versionTextLabel.Parent = self.version
		self.versionTextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		self.versionTextLabel.BackgroundTransparency = 1.000
		self.versionTextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		self.versionTextLabel.BorderSizePixel = 0
		self.versionTextLabel.Position = UDim2.new(0.08, 0, 0.11, 0)
		self.versionTextLabel.Size = UDim2.new(0, 45, 0, 18)
		self.versionTextLabel.Font = Enum.Font.FredokaOne
		self.versionTextLabel.Text = version
		self.versionTextLabel.TextColor3 = self.Theme.versionTextColor
		self.versionTextLabel.TextSize = 14.000
	end

	self.Frame = Instance.new("Frame")
	self.Frame.Parent = self.Header
	self.Frame.BackgroundColor3 = self.Theme.headerlinecolor
	self.Frame.BackgroundTransparency = 0.95
	self.Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.Frame.BorderSizePixel = 0
	self.Frame.Position = UDim2.new(0, -1, 1, 0)
	self.Frame.Size = UDim2.new(0, 197, 0, 2)

	self.close = Instance.new("ImageButton")
	self.close.Parent = self.Header
	self.close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.close.BackgroundTransparency = 1.000
	self.close.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.close.BorderSizePixel = 0
	self.close.Position = UDim2.new(0.935, 0, 0.2, 0)
	self.close.Size = UDim2.new(0, 24, 0, 24)
	self.close.Image = "rbxassetid://115483385285173"

	local btnclose = Instance.new("TextButton")
	btnclose.Parent = self.close
	btnclose.Size = UDim2.new(0, 24, 0, 24)
	btnclose.Text = ""
	btnclose.Transparency = 1
	btnclose.Position = UDim2.new(0, 0 , 0, 0)

	local btnclose3 = Instance.new("TextButton")

	btnclose.MouseButton1Click:Connect(function()
		self:ShowDestroyQ()
	end)

	self.ImageButton = Instance.new("ImageButton")
	self.ImageButton.Parent = self.Header
	self.ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.ImageButton.BackgroundTransparency = 1.000
	self.ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.ImageButton.BorderSizePixel = 0
	self.ImageButton.Position = UDim2.new(0.887, 0, 0.35, 0)
	self.ImageButton.Size = UDim2.new(0, 16, 0, 12)
	self.ImageButton.Image = "rbxassetid://89738650787294"

	local btnclose2 = Instance.new("TextButton")
	btnclose2.Parent = self.ImageButton
	btnclose2.Size = UDim2.new(0, 20, 0, 20)
	btnclose2.Text = ""
	btnclose2.Transparency = 1
	btnclose2.Position = UDim2.new(0, -2.9 , 0, -4)

	btnclose2.MouseButton1Click:Connect(function()
		self:ColumnWindow()
	end)

	self.ImageButton_2 = Instance.new("ImageButton")
	self.ImageButton_2.Parent = self.Header
	self.ImageButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.ImageButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.ImageButton_2.BorderSizePixel = 0
	self.ImageButton_2.Position = UDim2.new(0.825, 0, 0.29, 0)
	self.ImageButton_2.Size = UDim2.new(0, 18, 0, 18)
	self.ImageButton_2.Image = "rbxassetid://122178947900744"
	self.ImageButton_2.BackgroundTransparency = 1.000

	local btnclose3 = Instance.new("TextButton")
	btnclose3.Parent = self.ImageButton_2
	btnclose3.Size = UDim2.new(0, 22, 0, 20)
	btnclose3.Text = ""
	btnclose3.Transparency = 1
	btnclose3.Position = UDim2.new(0, -2 , 0, -9)

	btnclose3.MouseButton1Click:Connect(function()
		self:Minimaze()
	end)

	self.Tabs = Instance.new("Frame")
	self.Frame_2 = Instance.new("Frame")
	local ImageButton_3 = Instance.new("ImageButton")
	local ImageButton_4 = Instance.new("ImageButton")
	local ImageButton_5 = Instance.new("ImageButton")
	self.ScrollingFrame = Instance.new("ScrollingFrame")
	self.Tabs.Name = "Tabs"
	self.Tabs.Parent = self.ImageLabel
	self.Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.Tabs.BackgroundTransparency = 1
	self.Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.Tabs.BorderSizePixel = 0
	self.Tabs.Position = UDim2.new(0.035, 0, 0.116, 0)
	self.Tabs.Size = UDim2.new(0, 185, 0, 372)

	self.WindowUser = Instance.new("Frame")
	local ImageLabel = Instance.new("ImageLabel")
	local UICorner = Instance.new("UICorner")
	local UICorner_User = Instance.new("UICorner")
	self.wTextLabel = Instance.new("TextLabel")
	self.wTextLabel_2 = Instance.new("TextLabel")

	self.WindowUser.Parent = self.Tabs
	self.WindowUser.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.WindowUser.BackgroundTransparency = 0.95
	self.WindowUser.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.WindowUser.BorderSizePixel = 0
	self.WindowUser.Position = UDim2.new(0, 0, 0.97, 0)
	self.WindowUser.Size = UDim2.new(0, 175, 0, 45)

	UICorner_User.CornerRadius = UDim.new(0.3, 0)
	UICorner_User.Parent = self.WindowUser

	ImageLabel.Parent = self.WindowUser
	ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
	ImageLabel.Size = UDim2.new(0, 30, 0, 30)
	ImageLabel.Image = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-placeholder-70x70.png"

	local userimg = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-placeholder-70x70.png"

	task.spawn(function()
		local userId = Players.LocalPlayer.UserId
		local thumbnailType = Enum.ThumbnailType.HeadShot
		local thumbnailSize = Enum.ThumbnailSize.Size150x150

		local success, thumbnailUrl = pcall(function()
			return Players:GetUserThumbnailAsync(userId, thumbnailType, thumbnailSize)
		end)

		if success and thumbnailUrl then
			task.defer(function()
				ImageLabel.Image = thumbnailUrl
				userimg = thumbnailUrl
			end)
		end
	end)

	UICorner.CornerRadius = UDim.new(0, 100)
	UICorner.Parent = ImageLabel

	local function limit(str)
		if #str > 14 then
			return string.sub(str, 1, 14) .. "..."
		else
			return str
		end
	end

	local realDisplay = limit(Players.LocalPlayer.DisplayName)
	local realName = limit(Players.LocalPlayer.Name)

	local ImageLabelRef = ImageLabel
	local toggled = false

	self.WindowUser.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 then

			toggled = not toggled

			if toggled then
				ImageLabelRef.Image = ""
				self.wTextLabel.Text = "Roblox"
				self.wTextLabel_2.Text = "@Roblox"
			else
				ImageLabelRef.Image = userimg
				self.wTextLabel.Text = realDisplay
				self.wTextLabel_2.Text = "@" .. realName
			end

		end

		if input.UserInputType == Enum.UserInputType.Touch then

			toggled = not toggled

			if toggled then
				ImageLabelRef.Image = ""
				self.wTextLabel.Text = "Roblox"
				self.wTextLabel_2.Text = "@Roblox"
			else
				ImageLabelRef.Image = userimg
				self.wTextLabel.Text = realDisplay
				self.wTextLabel_2.Text = "@" .. realName
			end

		end
	end)

	self.wTextLabel.Parent = self.WindowUser
	self.wTextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.wTextLabel.BackgroundTransparency = 1.000
	self.wTextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.wTextLabel.BorderSizePixel = 0
	self.wTextLabel.Position = UDim2.new(0.27, 0, 0, 7)
	self.wTextLabel.Size = UDim2.new(0, 131, 0, 15)
	self.wTextLabel.Font = Enum.Font.FredokaOne
	self.wTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.wTextLabel.TextSize = 14.000
	self.wTextLabel.Text = realDisplay
	self.wTextLabel.TextXAlignment = Enum.TextXAlignment.Left

	self.wTextLabel_2.Parent = self.WindowUser
	self.wTextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.wTextLabel_2.BackgroundTransparency = 1.000
	self.wTextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.wTextLabel_2.BorderSizePixel = 0
	self.wTextLabel_2.Position = UDim2.new(0.27, 0, 0, 21)
	self.wTextLabel_2.Size = UDim2.new(0, 131, 0, 15)
	self.wTextLabel_2.Font = Enum.Font.FredokaOne
	self.wTextLabel_2.TextColor3 = Color3.fromRGB(171, 171, 171)
	self.wTextLabel_2.TextSize = 14.000
	self.wTextLabel_2.Text = "@" .. realName
	self.wTextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

	self.Frame_2.Parent = self.Tabs
	self.Frame_2.BackgroundColor3 = Color3.fromRGB(165, 165, 165)
	self.Frame_2.BackgroundTransparency = 0.95 --0.550
	self.Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.Frame_2.BorderSizePixel = 0
	self.Frame_2.Position = UDim2.new(1, 0, 0, 0)
	self.Frame_2.Size = UDim2.new(0, 2, 0, 413)

	self.ScrollingFrame.Parent = self.Tabs
	self.ScrollingFrame.Active = true
	self.ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.ScrollingFrame.BackgroundTransparency = 1.000
	self.ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.ScrollingFrame.BorderSizePixel = 0
	self.ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
	self.ScrollingFrame.Size = UDim2.new(0, 187, 0, 358)
	self.ScrollingFrame.ScrollBarThickness = 2
	self.ScrollingFrame.ScrollBarImageColor3 = self.Theme.TabsScrollingBarFrameColor

	self.Sections = Instance.new("Frame")
	self.Sections.Name = "Sections"
	self.Sections.Parent = self.ImageLabel
	self.Sections.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.Sections.BackgroundTransparency = 1
	self.Sections.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.Sections.BorderSizePixel = 0
	self.Sections.Position = UDim2.new(0.35, 0, 0.11, 0)
	self.Sections.Size = UDim2.new(0, 380, 0, 414)

	self.TextLabel_5 = Instance.new("TextLabel")
	self.TextLabel_5.Parent = self.Sections
	self.TextLabel_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.TextLabel_5.BackgroundTransparency = 1.000
	self.TextLabel_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.TextLabel_5.BorderSizePixel = 0
	self.TextLabel_5.Position = UDim2.new(0.0191, 0, 0.0144, 0)
	self.TextLabel_5.Size = UDim2.new(0, 192, 0, 29)
	self.TextLabel_5.Font = Enum.Font.FredokaOne
	self.TextLabel_5.Text = ''
	self.TextLabel_5.TextColor3 = self.Theme.TextColor
	self.TextLabel_5.TextSize = 24.000
	self.TextLabel_5.TextWrapped = true
	self.TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left

	self.Frame_7 = Instance.new("Frame")
	self.Frame_7.Parent = self.Sections
	self.Frame_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.Frame_7.BackgroundTransparency = 1.000
	self.Frame_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.Frame_7.BorderSizePixel = 0
	self.Frame_7.Position = UDim2.new(0, 0, 0.08454106, 0)
	self.Frame_7.Size = UDim2.new(0, 366, 0, 379)

	local TypeIcons = {
		Notification = "rbxassetid://75930996983661",
		Warn = "rbxassetid://85045950898455",
		Error = "rbxassetid://71852580046993"
	}

	function Library:Notification(config)
		self.NotificationCounter = (self.NotificationCounter or 0) + 1
		local notificationId = self.NotificationCounter
		self.ActiveNotifications = self.ActiveNotifications or {}

		local title = config.Name or "Notification"
		local description = config.Description or ""
		local duration = config.Duration or 5
		local notiType = config.Type or "Notification"

		local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
		local targetX = isMobile and 0.55 or 0.8
		local startY = isMobile and 0.75 or 0.9
		local offsetMulti = isMobile and 0.2 or 0.08
		local width = isMobile and 280 or 360

		if not self.NotificationTemplate then
			self:CreateNotificationTemplate()
		end

		local Notification = self.NotificationTemplate:Clone()
		
		local img = TypeIcons[notiType]
		if notiType == 'Notification' then
			Notification.Icon.ImageColor3 = self.Theme.TabsIconColor
		end

		if not img then return end

		Notification.Name = notiType
		Notification.Parent = self.UI
		Notification.Size = UDim2.new(0, width, 0, 75)
		Notification.Position = UDim2.new(1.2, 0, startY, 0)
		Notification.Visible = true
		Notification.Image = self.Theme.NotiImg

		Notification.Icon.Image = img
		Notification.Title.Text = title
		Notification.Description.Text = description
		Notification.Title.TextColor3 = self.Theme.TextColor
		Notification.Description.TextColor3 = self.Theme.Notisubtitlecolor
		Notification.CloseButton.ImageColor3 = self.Theme.TabsIconColor
		
		Notification.CloseButton.MouseButton1Click:Connect(function()
			self:CloseNotification(notificationId)
		end)

		self.ActiveNotifications[notificationId] = {
			notification = Notification,
			targetX = targetX,
			targetY = startY,
			multi = offsetMulti
		}

		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(targetX, 0, startY, 0)}):Play()

		for id, notifData in pairs(self.ActiveNotifications) do
			if id ~= notificationId then
				local newY = notifData.notification.Position.Y.Scale - offsetMulti
				notifData.targetY = newY
				TweenService:Create(notifData.notification, tweenInfo, {Position = UDim2.new(targetX, 0, newY, 0)}):Play()
			end
		end

		task.delay(duration, function()
			self:CloseNotification(notificationId)
		end)
	end

	function Library:CreateNotificationTemplate()
		local template = Instance.new("ImageLabel")
		template.Name = "NotificationTemplate"
		template.BackgroundTransparency = 1.000
		template.BorderSizePixel = 0
		template.Size = UDim2.new(0, 360, 0, 75)
		template.Visible = false
		template.ZIndex = 50

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = template

		local Icon = Instance.new("ImageLabel")
		Icon.Name = "Icon"
		Icon.Parent = template
		Icon.BackgroundTransparency = 1.000
		Icon.Position = UDim2.new(0.04, 0, 0.24, 0)
		Icon.Size = UDim2.new(0, 18, 0, 18)
		Icon.ZIndex = 51

		local Description = Instance.new("TextLabel")
		Description.Name = "Description"
		Description.Parent = template
		Description.BackgroundTransparency = 1.000
		Description.Position = UDim2.new(0.04, 0, 0.47, 0)
		Description.Size = UDim2.new(0, 321, 0, 23)
		Description.Font = Enum.Font.FredokaOne
		Description.TextSize = 14.000
		Description.TextXAlignment = Enum.TextXAlignment.Left
		Description.ZIndex = 51

		local Title = Instance.new("TextLabel")
		Title.Name = "Title"
		Title.Parent = template
		Title.BackgroundTransparency = 1.000
		Title.Position = UDim2.new(0.11, 0, 0.19, 0)
		Title.Size = UDim2.new(0, 200, 0, 24)
		Title.Font = Enum.Font.FredokaOne
		Title.TextSize = 18.000
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.ZIndex = 51

		local CloseButton = Instance.new("ImageButton")
		CloseButton.Name = "CloseButton"
		CloseButton.Parent = template
		CloseButton.BackgroundTransparency = 1.000
		CloseButton.Position = UDim2.new(0.91, 0, 0.21, 0)
		CloseButton.Size = UDim2.new(0, 14, 0, 14)
		CloseButton.ZIndex = 51
		CloseButton.Image = "rbxassetid://134899599114088"

		self.NotificationTemplate = template
	end

	function Library:CloseNotification(notificationId)
		local data = self.ActiveNotifications[notificationId]
		if not data then return end

		local notification = data.notification
		self.ActiveNotifications[notificationId] = nil

		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local tweenOut = TweenService:Create(notification, tweenInfo, {Position = UDim2.new(1.2, 0, notification.Position.Y.Scale, 0)})
		tweenOut:Play()

		tweenOut.Completed:Connect(function()
			notification:Destroy()
		end)

		local activeList = {}
		for id, notifData in pairs(self.ActiveNotifications) do
			table.insert(activeList, {id = id, data = notifData})
		end

		table.sort(activeList, function(a, b) return a.id < b.id end)

		local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
		local startY = isMobile and 0.75 or 0.9

		local currentY = startY
		for i = #activeList, 1, -1 do
			local item = activeList[i]
			TweenService:Create(item.data.notification, tweenInfo, {Position = UDim2.new(item.data.targetX, 0, currentY, 0)}):Play()
			currentY = currentY - item.data.multi
		end
	end

	self.Tabs.Visible = false
	self.Sections.Visible = false

	self.Search.Visible = false
	self.TextLabel.Visible = false
	self.TextLabel_2.Visible = false
	self.version.Visible = false
	self.close.Visible = false
	self.ImageButton.Visible = false
	self.ImageButton_2.Visible = false
	self.IOSdragline.Visible = false
	self.IOSdragHitbox.Visible = false
	self.Frame.Visible = false

	self:Tween(self.ImageLabel,{Size = UDim2.new(0,size,0,480)},0.9)
	wait(0.9)

	self.Tabs.Visible = true
	self.Sections.Visible = true
	self.Frame.Visible = true
	self.Search.Visible = true
	self.TextLabel.Visible = true
	self.TextLabel_2.Visible = true
	self.version.Visible = true
	self.close.Visible = true
	self.ImageButton.Visible = true
	self.ImageButton_2.Visible = true
	self.IOSdragline.Visible = true
	self.IOSdragHitbox.Visible = true

	return self
end

local TAB_ICONS = {
	["Settings"]  = "rbxassetid://121074539743502",
	["Visual"]    = "rbxassetid://92250291747112",
	["Player"]    = "rbxassetid://92793433656183", 
	["Combat"]    = "rbxassetid://73787033062338", 
	["Generator"] = "rbxassetid://88963434013027", 
	["AutoFarm"]  = "rbxassetid://78576858777870", 
	["Animation"] = "rbxassetid://126672101469278", 
	["Items"]     = "rbxassetid://100873317961037", 
	["Teleport"]  = "rbxassetid://93236186125909", 
	["Badge"]     = "rbxassetid://119734718512317",
	["Quests"]    = "rbxassetid://88588775334975",
	["Main"]      = "rbxassetid://103472623123751",
	["Halloween"] = "rbxassetid://115053236948532",
	["Misc"]      = "rbxassetid://137583062645541", 
	["Block"]     = "rbxassetid://94027029642332",
	["Aim"]       = "rbxassetid://130183131122604", 
	["Fun"]       = "rbxassetid://137362629704355", 
	["Fish"]      = "rbxassetid://105045060721724",
	["WebHook"]   = "rbxassetid://120375090333993",
	["Heart"]     = "rbxassetid://111088001331743",
	["Shop"]      = "rbxassetid://82363507426406",
	["Boat"]      = "rbxassetid://103950075513303",
	["Trade"]     = "rbxassetid://128997687956087",
	["Text"]   = "rbxassetid://140272486271785", 
}

function Library:AddTab(name : string,icon : string)
	local tab = {
		Name = name,
		Elements = {},
		Container = nil,
		Button = nil,
		Frame = nil,
		pos = 0,
		Icon = icon,
		Tab = {},
		ElemBtn = {},
		Texttitle = {},
		Textsubtitle = {},
		actionBakcColor = {},
		BtnImg = {},
		ArrowImg = {},
		ListFrames = {},
		DropImg = {},
		DropDownArrowImg = {},
		DropDownFrameColor = {},
		ActiveToggleColor = {},
		InputTextColor = {},
		SliderUnderLineColor = {},
		Togglebtn = {},
		Sliderball = {},
		Connections = {},
		KeybindConnections = {},
		ColorPickerColor = {},
		SearchData = {}
	}

	setmetatable(tab, { __index = self })

	local Frame_3 = Instance.new("TextButton")
	local UICorner = Instance.new("UICorner")
	local TextLabel_3 = Instance.new("TextLabel")
	local Frame_4 = Instance.new("Frame")

	Frame_3.Parent = self.ScrollingFrame
	Frame_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame_3.BackgroundTransparency = 1.000
	Frame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_3.BorderSizePixel = 0
	Frame_3.Position = UDim2.new(0, 0, 0, 8 + self.tabpos) --5
	Frame_3.Size = UDim2.new(0, 173, 0, 35)
	Frame_3.Text = ''
	table.insert(tab.Tab, Frame_3)

	self.tabpos += 40

	Frame_3.MouseEnter:Connect(function()
		self:Tween(Frame_3,{BackgroundTransparency = self.Theme.TabTransparancy},0.3)
		self:Tween(Frame_4,{Size = UDim2.new(0, 2, 0, 23)},0.3)
		self:Tween(Frame_4,{BackgroundTransparency = 0},0.3)
	end)

	Frame_3.MouseLeave:Connect(function()
		if self.CurrentTab ~= tab then
			self:Tween(Frame_3,{BackgroundTransparency = 1},0.3)
			self:Tween(Frame_4,{BackgroundTransparency = 1},0.3)
			self:Tween(Frame_4,{Size = UDim2.new(0, 2, 0, 0)},0.3)
		end
	end)

	Frame_3.MouseButton1Click:Connect(function()
		self:SelectTab(tab,Frame_3)
	end)

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = Frame_3

	local textpos2 = 0.05

	if (icon ~= nil and icon ~= '') then
		textpos2 = 0.21
	else
		textpos2 = 0.05
		icon = 1
	end

	icon = TAB_ICONS[icon] or icon

	TextLabel_3.Parent = Frame_3
	TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_3.BackgroundTransparency = 1.000
	TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_3.BorderSizePixel = 0
	TextLabel_3.Position = UDim2.new(textpos2, 0, 0, -1)
	TextLabel_3.Size = UDim2.new(0, 52, 0, 35)
	TextLabel_3.Font = Enum.Font.FredokaOne
	TextLabel_3.Text = name
	TextLabel_3.TextColor3 = self.Theme.TabTextColor
	table.insert(tab.Tab, TextLabel_3)
	TextLabel_3.TextSize = 14.000
	TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left

	Frame_4.Parent = Frame_3
	Frame_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame_4.BackgroundTransparency = 1.000
	Frame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_4.BorderSizePixel = 0
	Frame_4.Position = UDim2.new(0, 1, 0.171428576, 0)
	Frame_4.Size = UDim2.new(0, 2, 0, 0)
	table.insert(tab.Tab, 3,Frame_4)

	local ScrollingFrame_2 = Instance.new("ScrollingFrame")
	ScrollingFrame_2.Name = "ScrollingFrame"
	ScrollingFrame_2.Parent = self.Frame_7
	ScrollingFrame_2.Active = true
	ScrollingFrame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame_2.BackgroundTransparency = 1.000
	ScrollingFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame_2.BorderSizePixel = 0
	ScrollingFrame_2.Position = UDim2.new(0, 0, 0.023, 0)
	ScrollingFrame_2.Size = UDim2.new(0, 381, 0, 370)
	ScrollingFrame_2.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame_2.ScrollBarThickness = 2
	ScrollingFrame_2.Visible = false
	table.insert(tab.Tab, 5,ScrollingFrame_2)

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Parent = Frame_3
	ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel.BackgroundTransparency = 1.000
	ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = UDim2.new(0, 8, 0, 6.5)
	ImageLabel.Size = UDim2.new(0, 22, 0, 22)
	ImageLabel.Image = icon
	table.insert(tab.Tab,4,ImageLabel)

	tab.Container = ScrollingFrame_2
	tab.Button = Frame_3
	tab.Frame = Frame_4

	table.insert(self.mainTabs, tab)

	if #self.mainTabs == 1 then
		self:SelectTab(tab, Frame_3)
	end

	function tab:CalcScroll()
		self.pos = 0
		for i,v in pairs(tab.Elements) do
			if v.Visible == true and v.ClassName ~= "Frame" or v.Name == "Paragraph" then
				self.pos += v.Size.Y.Offset + 5
			end
		end
		self.Tab[5].CanvasSize = UDim2.new(0, 0, 0, self.pos)
	end

	function tab:Reposelem()
		local startpos = 0
		for i,v in pairs(tab.Elements) do
			if v.Visible == true and v.Parent:IsA("ScrollingFrame") then
				v.Position = UDim2.new(v.Position.X.Scale, v.Position.X.Offset, v.Position.Y.Scale, startpos)
				if v.Name == "List" and v:FindFirstChildOfClass("Frame").Visible == true then
					local Frame = v:FindFirstChildOfClass("Frame")
					if Frame then
						startpos += Frame.Size.Y.Offset + 5
					end
				elseif v.ClassName == "Frame" then
					startpos += v.Size.Y.Offset + 5
				else
					startpos += v.Size.Y.Offset + 5
				end

			end
		end
		self:CalcScroll()
	end

	function tab:AddList(config)
		local Config = {
			Name = config.Name,
			Elems = config.Elems,
		}

		local List = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")
		local name = Instance.new("TextLabel")
		local ImageLabel = Instance.new("ImageLabel")
		local Frame = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")

		List.Name = "List"
		List.Parent = self.Container
		List.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		List.BackgroundTransparency = self.Theme.BackGroundElemTran
		List.BorderColor3 = Color3.fromRGB(0, 0, 0)
		List.BorderSizePixel = 0
		List.Position = UDim2.new(0, 7, 0, self.pos)
		List.Size = UDim2.new(0, 360, 0, 30)
		List.Text = ""
		table.insert(tab.ElemBtn, List)

		UICorner.CornerRadius = UDim.new(0, 12)
		UICorner.Parent = List

		name.Parent = List
		name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		name.BackgroundTransparency = 1.000
		name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		name.BorderSizePixel = 0
		name.Position = UDim2.new(0.0290000141, 0, 0, 4)
		name.Size = UDim2.new(0, 77, 0, 20)
		name.Font = Enum.Font.FredokaOne
		name.Text = tostring(Config.Name) or "Test"
		name.TextColor3 = Color3.fromRGB(255, 255, 255)
		name.TextSize = 16.000
		name.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(tab.Texttitle, name)

		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.87, 0, 0.1, 0)
		ImageLabel.Rotation = -90
		ImageLabel.Size = UDim2.new(0, 24, 0, 24)
		ImageLabel.Image = "rbxassetid://126982255108418"
		ImageLabel.ImageColor3 = self.Theme.DropDownArrowImg
		ImageLabel.Parent = List
		table.insert(tab.ArrowImg, ImageLabel)

		Frame.Parent = List
		Frame.BackgroundColor3 = self.Theme.ListFrameColor
		Frame.BackgroundTransparency = 0.65
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(0, 360, 0, 144)
		Frame.Visible = false
		table.insert(self.Elements, Frame)
		table.insert(tab.ListFrames, Frame)

		UICorner_2.CornerRadius = UDim.new(0, 12)
		UICorner_2.Parent = Frame

		local size = 31

		for i,v in pairs(Config.Elems) do
			if v.Elem then
				v.Elem.Visible = false
				v.Elem.Parent = Frame
				v.Elem.Position = UDim2.new(0, 0, 0, size)
				size += v.Elem.Size.Y.Offset + 5
			end
		end

		local ListClose = true
		local FrameSize = UDim2.new(0, 360, 0, size)
		local ListPos = List.Position

		List.MouseButton1Click:Connect(function()
			if ListClose then
				Frame.Visible = true
				Library:Tween(ImageLabel,{Rotation = 0},0.5)
				Frame.Size = FrameSize
				ListClose = false
				for i,v in pairs(Config.Elems) do
					if v.Elem then
						v.Elem.Visible = true
					end
				end

				self:Reposelem()

				Frame.Parent = self.Container
				Frame.Position = List.Position
				List.Parent = Frame
				List.Position = UDim2.new(0, 0, 0, 0)

				local size = 35

				for i,v in pairs(Config.Elems) do
					if v.Elem then
						v.Elem.Position = UDim2.new(0, 0, 0, size)
						size += v.Elem.Size.Y.Offset + 5
					end
				end
			else
				List.Parent = self.Container
				List.Position = ListPos
				Frame.Parent = List

				Library:Tween(ImageLabel,{Rotation = -90},0.5)
				Frame.Size = UDim2.new(0, 360, 0, 0)

				Frame.Visible = false
				ListClose = true

				for i,v in pairs(Config.Elems) do
					if v.Elem then
						v.Elem.Visible = false
					end
				end

				self:Reposelem()
			end
		end)

		table.insert(self.Elements, List)

		self.pos = self.pos + List.Size.Y.Offset + 5
		tab:CalcScroll()

		tab.SearchData[List] = (config.Name or "") .. " " .. ("")
	end

	function tab:AddParagraph(title, subtitle)
		local TextService = game:GetService("TextService")

		local Paragraph = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local TitleLabel = Instance.new("TextLabel")
		local ContentLabel = Instance.new("TextLabel")

		Paragraph.Name = "Paragraph"
		Paragraph.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		Paragraph.BackgroundTransparency = self.Theme.BackGroundElemTran
		Paragraph.BorderSizePixel = 0
		Paragraph.Position = UDim2.new(0, 7, 0, self.pos)

		UICorner.CornerRadius = UDim.new(0, 12)
		UICorner.Parent = Paragraph

		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Position = UDim2.new(0.027, 0, 0, 5)
		TitleLabel.Size = UDim2.new(0, 328, 0, 20)
		TitleLabel.Font = Enum.Font.FredokaOne
		TitleLabel.Text = title or ""
		TitleLabel.TextColor3 = self.Theme.TabTextColor
		TitleLabel.TextSize = 16
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		TitleLabel.TextWrapped = false
		TitleLabel.Parent = Paragraph

		ContentLabel.BackgroundTransparency = 1
		ContentLabel.Position = UDim2.new(0.027, 0, 0, 28)
		ContentLabel.Size = UDim2.new(0, 328, 0, 10)
		ContentLabel.Font = Enum.Font.FredokaOne
		ContentLabel.Text = subtitle or ""
		ContentLabel.TextColor3 = self.Theme.TabSubTtitleTextColor
		ContentLabel.TextSize = 14
		ContentLabel.TextWrapped = true
		ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
		ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
		ContentLabel.Parent = Paragraph

		Paragraph.Parent = self.Container

		table.insert(tab.ElemBtn, Paragraph)
		table.insert(tab.Texttitle, TitleLabel)
		table.insert(tab.Textsubtitle, ContentLabel)
		table.insert(self.Elements, Paragraph)

		local function recalcSizes()
			local contentText = ContentLabel.Text
			local textSizeVec = TextService:GetTextSize(contentText, ContentLabel.TextSize, ContentLabel.Font, Vector2.new(328, 10000))
			local contentHeight = math.max(16, math.ceil(textSizeVec.Y))

			ContentLabel.Size = UDim2.new(0, 328, 0, contentHeight + 4)
			Paragraph.Size = UDim2.new(0, 360, 0, 33 + contentHeight)
		end

		recalcSizes()

		local paragraphObj = {
			Element = Paragraph,
			Elem = Paragraph,
			Update = function(objSelf, newTitle, newSubtitle)
				if not objSelf.Element then return end

				if newTitle then TitleLabel.Text = newTitle end
				if newSubtitle then ContentLabel.Text = newSubtitle end

				recalcSizes()

				tab.SearchData[objSelf.Element] = TitleLabel.Text .. " " .. ContentLabel.Text
				tab:CalcScroll()
			end,

			SetVisible = function(objSelf, visible)
				if objSelf.Element then
					objSelf.Element.Visible = visible
				end
			end,

			Destroy = function(objSelf)
				if objSelf.Element then
					objSelf.Element:Destroy()
					objSelf.Element = nil
				end
			end
		}

		self.pos = self.pos + Paragraph.Size.Y.Offset + 5
		tab:CalcScroll()

		tab.SearchData[Paragraph] = (title or "") .. " " .. (subtitle or "")

		return paragraphObj
	end

	function tab:AddImage(config)
		local image = {
			Image = config.Image or "",
			Size = config.Size or UDim2.new(0, 80, 0, 80),
			CornerRadius = config.CornerRadius or UDim.new(0, 12),
		}

		local ImageButton = Instance.new("ImageButton")
		table.insert(tab.ElemBtn, ImageButton)

		ImageButton.Parent = self.Container
		ImageButton.BackgroundTransparency = 1
		ImageButton.BorderSizePixel = 0
		ImageButton.Position = UDim2.new(0, 7, 0, self.pos)
		ImageButton.Size = image.Size
		ImageButton.Image = image.Image

		if image.CornerRadius then
			local UICorner = Instance.new("UICorner")
			UICorner.CornerRadius = image.CornerRadius
			UICorner.Parent = ImageButton
		end

		table.insert(self.Elements, ImageButton)
		self.pos += ImageButton.Size.Y.Offset + 5
		tab:CalcScroll()
	end

	function tab:AddSection(title)
		local TextLabel = Instance.new("TextLabel")
		table.insert(tab.Texttitle, TextLabel)

		TextLabel.Parent = self.Container
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0.029, 0, 0, self.pos)
		TextLabel.Size = UDim2.new(0, 193, 0, 21)
		TextLabel.Font = Enum.Font.FredokaOne
		TextLabel.Text = title
		TextLabel.TextColor3 = self.Theme.TabTextColor
		TextLabel.TextSize = 18.000
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(self.Elements, TextLabel)
		self.pos += 26
		tab:CalcScroll()
	end

	function tab:AddButton(config)
		local button = {
			Name = config.Name,
			Description = config.Description or '',
			Callback = config.Callback
		}

		local Button = Instance.new("TextButton")
		table.insert(tab.ElemBtn, Button)
		local UICorner = Instance.new("UICorner")
		local name = Instance.new("TextLabel")
		table.insert(tab.Texttitle, name)
		local subtext = Instance.new("TextLabel")
		table.insert(tab.Textsubtitle, subtext)
		local ImageLabel = Instance.new("ImageLabel")

		Button.Name = "Button"
		Button.Parent = self.Container
		Button.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		Button.BackgroundTransparency = self.Theme.BackGroundElemTran
		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button.BorderSizePixel = 0
		Button.Position = UDim2.new(0, 7, 0, self.pos)
		Button.Size = UDim2.new(0, 360, 0, 45)
		Button.Text = ''

		Button.MouseButton1Click:Connect(function()
			if button.Callback then
				button.Callback()
			end
		end)

		UICorner.Parent = Button
		UICorner.CornerRadius = UDim.new(0, 12)

		local namepos = config.Description and config.Description ~= '' and 4 or 12.5

		name.Parent = Button
		name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		name.BackgroundTransparency = 1.000
		name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		name.BorderSizePixel = 0
		name.Position = UDim2.new(0.0290000141, 0, 0, namepos)
		name.Size = UDim2.new(0, 77, 0, 20)
		name.Font = Enum.Font.FredokaOne
		name.Text = button.Name
		name.TextColor3 = self.Theme.TabTextColor
		name.TextSize = 16.000
		name.TextXAlignment = Enum.TextXAlignment.Left

		subtext.Parent = Button
		subtext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		subtext.BackgroundTransparency = 1.000
		subtext.BorderColor3 = Color3.fromRGB(0, 0, 0)
		subtext.BorderSizePixel = 0
		subtext.Position = UDim2.new(0.0289855078, 0, 0, 25)
		subtext.Size = UDim2.new(0, 193, 0, 14)
		subtext.Font = Enum.Font.FredokaOne
		subtext.Text = button.Description
		subtext.TextColor3 = self.Theme.TabSubTtitleTextColor
		subtext.TextSize = 14.000
		subtext.TextXAlignment = Enum.TextXAlignment.Left

		ImageLabel.Parent = Button
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.841222107, 0, 0.244000241, 0)
		ImageLabel.Size = UDim2.new(0, 25, 0, 23)
		ImageLabel.Image = "rbxassetid://140083176080437"
		ImageLabel.ImageColor3 = self.Theme.DropDownArrowImg
		table.insert(tab.BtnImg, ImageLabel)

		table.insert(self.Elements, Button)
		self.pos += 50
		tab:CalcScroll()

		self.SearchData[Button] = config.Name .. " " .. (config.Description or "")

		local ButtonObj = {
			Elem = Button
		}

		return ButtonObj
	end

	function tab:AddToggle(config)
		local toggle = {
			Name = config.Name,
			Description = config.Description or '',
			Default = config.Default or false,
			Callback = config.Callback
		}

		local Toggle = Instance.new("TextButton")
		table.insert(tab.ElemBtn, Toggle)
		local UICorner = Instance.new("UICorner")
		local name = Instance.new("TextLabel")
		table.insert(tab.Texttitle, name)
		local subtext = Instance.new("TextLabel")
		table.insert(tab.Textsubtitle, subtext)
		local sliderbutton = Instance.new("Frame")
		table.insert(tab.actionBakcColor, sliderbutton)
		local UICorner_2 = Instance.new("UICorner")
		local Frame = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local Frame2 = Instance.new("Frame")
		table.insert(tab.Togglebtn, Frame)
		local UICorner2 = Instance.new("UICorner")

		Toggle.Name = "Toggle"
		Toggle.Parent = self.Container
		Toggle.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		Toggle.BackgroundTransparency = self.Theme.BackGroundElemTran
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.Position = UDim2.new(0, 7, 0, self.pos)
		Toggle.Size = UDim2.new(0, 360, 0, 45)
		Toggle.Text = ''

		UICorner.Parent = Toggle
		UICorner.CornerRadius = UDim.new(0, 12)

		local namepos = config.Description and config.Description ~= '' and 4 or 12.5

		name.Parent = Toggle
		name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		name.BackgroundTransparency = 1.000
		name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		name.BorderSizePixel = 0
		name.Position = UDim2.new(0.0290000141, 0, 0, namepos)
		name.Size = UDim2.new(0, 77, 0, 20)
		name.Font = Enum.Font.FredokaOne
		name.Text = toggle.Name
		name.TextColor3 = self.Theme.TabTextColor
		name.TextSize = 15.000
		name.TextXAlignment = Enum.TextXAlignment.Left

		subtext.Parent = Toggle
		subtext.BackgroundColor3 = Color3.fromRGB(199, 199, 199)
		subtext.BackgroundTransparency = 1.000
		subtext.BorderColor3 = Color3.fromRGB(0, 0, 0)
		subtext.BorderSizePixel = 0
		subtext.Position = UDim2.new(0.0289855078, 0, 0, 25)
		subtext.Size = UDim2.new(0, 193, 0, 14)
		subtext.Font = Enum.Font.FredokaOne
		subtext.Text = toggle.Description
		subtext.TextColor3 = self.Theme.TabSubTtitleTextColor
		subtext.TextSize = 14.000
		subtext.TextXAlignment = Enum.TextXAlignment.Left

		sliderbutton.Parent = Toggle
		sliderbutton.BackgroundColor3 = self.Theme.ToggleButton
		sliderbutton.BackgroundTransparency = self.Theme.ToggleTran
		sliderbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		sliderbutton.BorderSizePixel = 0
		sliderbutton.Position = UDim2.new(0.801999986, 0, 0.206, 0)
		sliderbutton.Size = UDim2.new(0, 54, 0, 25)

		UICorner_2.Parent = sliderbutton

		Frame.Parent = sliderbutton
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(0, 3, 0.119999997, 0)
		Frame.Size = UDim2.new(0, 19, 0, 19)

		Frame2.Parent = sliderbutton
		Frame2.BackgroundColor3 = self.Theme.TogleActivColor
		table.insert(tab.ActiveToggleColor, Frame2)
		Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame2.BorderSizePixel = 0
		Frame2.Position = UDim2.new(0, 3, 0.119999997, 0)
		Frame2.Size = UDim2.new(0, 0, 0, 19)
		Frame2.ZIndex = -1

		UICorner2.Parent = Frame2
		UICorner_3.Parent = Frame

		local toggleController = {
			Elem = Toggle,
			Value = toggle.Default,
			UpdateVisuals = function(self, state)
				if state then
					Library:Tween(Frame, {Position = UDim2.new(0, 32, 0.12, 0)}, 0.2)
					Library:Tween(Frame2, {Size = UDim2.new(0, 47, 0, 19), BackgroundTransparency = 0}, 0.2)
				else
					Library:Tween(Frame, {Position = UDim2.new(0, 3, 0.12, 0)}, 0.2)
					Library:Tween(Frame2, {Size = UDim2.new(0, 0, 0, 19), BackgroundTransparency = 1}, 0.2)
				end
			end,
			SetState = function(self, state)
				if state == self.Value then return end
				self.Value = state
				self:UpdateVisuals(state)
				if toggle.Callback then
					task.spawn(function()
						toggle.Callback(state)
					end)
				end
			end,
			GetState = function(self)
				return self.Value
			end,
			Toggle = function(self)
				self:SetState(not self.Value)
			end
		}

		toggleController:UpdateVisuals(toggleController.Value)

		Toggle.MouseButton1Click:Connect(function()
			toggleController:Toggle()
		end)

		table.insert(self.Elements, Toggle)
		self.pos += 50
		tab:CalcScroll()

		self.AllElements.Toggles[config.Name] = toggleController

		self.SearchData[Toggle] = config.Name .. " " .. (config.Description or "")


		return toggleController
	end

	function tab:AddKeybind(config)
		local Keybind = {
			Name = config.Name,
			Description = config.Description,
			key = config.Default,
			Callback = config.Callback
		}

		local container = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")
		local name = Instance.new("TextLabel")
		local subtext = Instance.new("TextLabel")
		local bindButton = Instance.new("TextButton")
		local UICorner_2 = Instance.new("UICorner")

		tab.ElemBtn[#tab.ElemBtn + 1] = container
		tab.Texttitle[#tab.Texttitle + 1] = name
		tab.Texttitle[#tab.Texttitle + 1] = bindButton
		tab.Textsubtitle[#tab.Textsubtitle + 1] = subtext
		tab.actionBakcColor[#tab.actionBakcColor + 1] = bindButton

		container.Name = "keybind"
		container.Parent = self.Container
		container.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		container.BackgroundTransparency = self.Theme.BackGroundElemTran
		container.BorderColor3 = Color3.fromRGB(0, 0, 0)
		container.BorderSizePixel = 0
		container.Position = UDim2.new(0, 7, 0, self.pos)
		container.Size = UDim2.new(0, 360, 0, 45)
		container.Text = ''

		UICorner.CornerRadius = UDim.new(0, 12)
		UICorner.Parent = container

		local namepos = (config.Description and config.Description ~= '') and 4 or 12.5

		name.Parent = container
		name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		name.BackgroundTransparency = 1.000
		name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		name.BorderSizePixel = 0
		name.Position = UDim2.new(0.029, 0, 0, namepos)
		name.Size = UDim2.new(0, 77, 0, 20)
		name.Font = Enum.Font.FredokaOne
		name.Text = Keybind.Name
		name.TextColor3 = self.Theme.TabTextColor
		name.TextSize = 16.000
		name.TextXAlignment = Enum.TextXAlignment.Left

		subtext.Parent = container
		subtext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		subtext.BackgroundTransparency = 1.000
		subtext.BorderColor3 = Color3.fromRGB(0, 0, 0)
		subtext.BorderSizePixel = 0
		subtext.Position = UDim2.new(0.0289, 0, 0, 25)
		subtext.Size = UDim2.new(0, 193, 0, 14)
		subtext.Font = Enum.Font.FredokaOne
		subtext.Text = Keybind.Description or ""
		subtext.TextColor3 = self.Theme.TabSubTtitleTextColor
		subtext.TextSize = 14.000
		subtext.TextXAlignment = Enum.TextXAlignment.Left

		bindButton.Parent = container
		bindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		bindButton.BackgroundTransparency = self.Theme.BackGroundButtonTran
		bindButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		bindButton.BorderSizePixel = 0
		bindButton.Position = UDim2.new(0.672, 0, 0.221, 0)
		bindButton.Size = UDim2.new(0, 100, 0, 25)
		bindButton.Font = Enum.Font.FredokaOne
		bindButton.TextColor3 = self.Theme.TabTextColor
		bindButton.TextSize = 14.000

		UICorner_2.CornerRadius = UDim.new(0, 5)
		UICorner_2.Parent = bindButton

		local currentKey = Keybind.key

		if typeof(currentKey) == "EnumItem" then
			bindButton.Text = currentKey.Name
		else
			bindButton.Text = "None"
		end

		local function setKey(newKey)
			currentKey = newKey
			bindButton.Text = (typeof(newKey) == "EnumItem" and newKey.Name) or "None"
		end

		local selectConnection = bindButton.MouseButton1Click:Connect(function()
			bindButton.Text = "..."
			local connection

			connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
				task.wait()
				if gameProcessed then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					setKey(nil)
					connection:Disconnect()
				elseif input.UserInputType == Enum.UserInputType.Keyboard then
					setKey(input.KeyCode)
					connection:Disconnect()
				end
			end)
		end)
		tab.Connections[#tab.Connections + 1] = selectConnection

		local actionConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and currentKey and input.KeyCode == currentKey and config.Callback then
				config.Callback()
			end
		end)
		tab.KeybindConnections[#tab.KeybindConnections + 1] = actionConnection

		self.Elements[#self.Elements + 1] = container
		self.pos += 50
		tab:CalcScroll()

		local keybindObj = {
			Name = config.Name,
			Elem = container,
			Key = currentKey,
			SetKey = setKey,
			GetState = function()
				return bindButton.Text
			end,
			Callback = config.Callback
		}

		self.AllElements.Keybinds[config.Name] = keybindObj
		self.SearchData[container] = config.Name .. " " .. (config.Description or "")

		return keybindObj
	end

	function tab:AddInput(config)
		local Input = {
			Name = config.Name,
			Description = config.Description,
			SaveUserText = config.SaveUserText or false,
			SaveConfig = config.SaveConfig or false,
			Default = config.Default or "Default",
			Callback = config.Callback
		}

		local input = Instance.new("TextButton")
		table.insert(tab.ElemBtn, input)
		local UICorner = Instance.new("UICorner")
		local name = Instance.new("TextLabel")
		table.insert(tab.Texttitle, name)
		local subtext = Instance.new("TextLabel")
		table.insert(tab.Textsubtitle, subtext)
		local TextBox = Instance.new("TextBox")
		table.insert(tab.actionBakcColor, TextBox)
		local UICorner_2 = Instance.new("UICorner")

		input.Name = "input"
		input.Parent = self.Container
		input.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		input.BackgroundTransparency = self.Theme.BackGroundElemTran
		input.BorderColor3 = Color3.fromRGB(0, 0, 0)
		input.BorderSizePixel = 0
		input.Position = UDim2.new(0, 7, 0, self.pos)
		input.Size = UDim2.new(0, 360, 0, 45)
		input.Text = ''

		UICorner.Parent = input
		UICorner.CornerRadius = UDim.new(0, 12)

		local namepos = 4

		if config.Description == '' then
			namepos = 12.5
		end

		name.Parent = input
		name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		name.BackgroundTransparency = 1.000
		name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		name.BorderSizePixel = 0
		name.Position = UDim2.new(0.0290000141, 0, 0, namepos)
		name.Size = UDim2.new(0, 77, 0, 20)
		name.Font = Enum.Font.FredokaOne
		name.Text = Input.Name
		name.TextColor3 = self.Theme.TabTextColor
		name.TextSize = 16.000
		name.TextXAlignment = Enum.TextXAlignment.Left

		subtext.Parent = input
		subtext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		subtext.BackgroundTransparency = 1.000
		subtext.BorderColor3 = Color3.fromRGB(0, 0, 0)
		subtext.BorderSizePixel = 0
		subtext.Position = UDim2.new(0.0289855078, 0, 0, 25)
		subtext.Size = UDim2.new(0, 193, 0, 14)
		subtext.Font = Enum.Font.FredokaOne
		subtext.Text = Input.Description
		subtext.TextColor3 = self.Theme.TabSubTtitleTextColor
		subtext.TextSize = 14.000
		subtext.TextXAlignment = Enum.TextXAlignment.Left

		TextBox.Parent = input
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = self.Theme.BackGroundButtonTran
		TextBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0.574999988, 0, 0.155555561, 0)
		TextBox.Size = UDim2.new(0, 135, 0, 30)
		TextBox.Font = Enum.Font.FredokaOne
		TextBox.Text = Input.Default
		TextBox.TextColor3 = self.Theme.InputTextColor
		TextBox.TextSize = 14.000
		table.insert(tab.InputTextColor, TextBox)

		UICorner_2.CornerRadius = UDim.new(0, 5)
		UICorner_2.Parent = TextBox

		TextBox.FocusLost:Connect(function(enterPressed)
			if enterPressed and config.Callback then
				config.Callback(TextBox.Text)
			end
		end)

		TextBox.FocusLost:Connect(function()
			wait(0.01)
			if not Input.SaveUserText then
				TextBox.Text = Input.Default
			end
		end)

		local function SetInput(Text2)
			TextBox.Text = Text2
			config.Callback(TextBox.Text)
		end
		table.insert(self.Elements, input)
		self.pos += 50
		tab:CalcScroll()

		local InputObj = {
			Name = config.Name,
			Elem = input,
			SetText = SetInput,
			GetState = function(self)
				return TextBox.Text
			end,
			SaveConfig = Input.SaveConfig,
			Callback = config.Callback
		}
		self.AllElements.Inputs[config.Name] = InputObj

		self.SearchData[input] = config.Name .. " " .. (config.Description or "")

		return InputObj
	end

	local UserInputService = game:GetService("UserInputService")

	function tab:AddSlider(config)
		local Slider = {
			Name = config.Name,
			Description = config.Description or '',
			min = config.Min or 0,
			max = config.Max or 100,
			Callback = config.Callback,
		}
		local value = config.Default or Slider.min

		local slider = Instance.new("TextButton")
		table.insert(tab.ElemBtn, slider)

		local UICorner = Instance.new("UICorner")
		local name = Instance.new("TextLabel")
		table.insert(tab.Texttitle, name)

		local subtext = Instance.new("TextLabel")
		table.insert(tab.Textsubtitle, subtext)

		local sliderbutton = Instance.new("Frame")
		local sliderline = Instance.new("Frame")
		local sliderball = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local slideramount = Instance.new("TextLabel")
		local underline = Instance.new("Frame")

		table.insert(tab.SliderUnderLineColor, underline)
		table.insert(tab.Sliderball, sliderball)

		slider.Name = "slider"
		slider.Parent = self.Container
		slider.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		slider.BackgroundTransparency = self.Theme.BackGroundElemTran
		slider.BorderSizePixel = 0
		slider.Position = UDim2.new(0, 7, 0, self.pos)
		slider.Size = UDim2.new(0, 360, 0, 45)
		slider.Text = ''

		UICorner.Parent = slider
		UICorner.CornerRadius = UDim.new(0, 12)

		local namepos = (Slider.Description == '') and 12.5 or 4

		name.Parent = slider
		name.BackgroundTransparency = 1.000
		name.Position = UDim2.new(0.029, 0, 0, namepos)
		name.Size = UDim2.new(0, 77, 0, 20)
		name.Font = Enum.Font.FredokaOne
		name.Text = Slider.Name
		name.TextColor3 = self.Theme.TabTextColor
		name.TextSize = 16.000
		name.TextXAlignment = Enum.TextXAlignment.Left

		subtext.Parent = slider
		subtext.BackgroundTransparency = 1.000
		subtext.Position = UDim2.new(0.029, 0, 0, 25)
		subtext.Size = UDim2.new(0, 193, 0, 14)
		subtext.Font = Enum.Font.FredokaOne
		subtext.Text = Slider.Description
		subtext.TextColor3 = self.Theme.TabSubTtitleTextColor
		subtext.TextSize = 14.000
		subtext.TextXAlignment = Enum.TextXAlignment.Left

		sliderbutton.Parent = slider
		sliderbutton.BackgroundTransparency = 1.000
		sliderbutton.Position = UDim2.new(0.671, 0, 0.244, 0)
		sliderbutton.Size = UDim2.new(0, 100, 0, 22)

		sliderline.Parent = sliderbutton
		sliderline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		sliderline.BorderSizePixel = 0
		sliderline.Position = UDim2.new(0, 0, 0.455, 0)
		sliderline.Size = UDim2.new(1, 0, 0, 2)

		sliderball.Parent = sliderbutton
		sliderball.BackgroundColor3 = self.Theme.Sliderball
		sliderball.BorderSizePixel = 0
		sliderball.AnchorPoint = Vector2.new(0.5, 0.5)
		sliderball.Position = UDim2.new(0, 0, 0.5, 0)
		sliderball.Size = UDim2.new(0, 15, 0, 15)
		sliderball.ZIndex = 2
		UICorner_2.Parent = sliderball
		UICorner_2.CornerRadius = UDim.new(1, 0)

		slideramount.Parent = sliderbutton
		slideramount.BackgroundTransparency = 1.000
		slideramount.Position = UDim2.new(0, -35, 0.075, 0)
		slideramount.Size = UDim2.new(0, 21, 0, 18)
		slideramount.Font = Enum.Font.FredokaOne
		slideramount.TextColor3 = self.Theme.TabTextColor
		slideramount.TextSize = 14.000
		table.insert(tab.Texttitle, slideramount)

		underline.Parent = sliderbutton
		underline.BackgroundColor3 = self.Theme.SliderUnderLineColor
		underline.BorderSizePixel = 0
		underline.Position = UDim2.new(0, 0, 0.455, 0)
		underline.Size = UDim2.new(0, 0, 0, 2)

		local dragging = false

		local function updateValue(newValue)
			value = math.clamp(newValue, Slider.min, Slider.max)

			local percent = (value - Slider.min) / (Slider.max - Slider.min)

			underline.Size = UDim2.new(percent, 0, 0, 2)
			sliderball.Position = UDim2.new(percent, 0, 0.5, 0)

			local displayValue = (Slider.max > 10) and math.floor(value + 0.5) or (math.floor(value * 10 + 0.5) / 10)
			slideramount.Text = (Slider.max > 10) and tostring(displayValue) or string.format("%.1f", displayValue)

			if config.Callback then
				task.spawn(config.Callback, displayValue)
			end
		end

		local function moveSlider(input)
			local pos = input.Position.X - sliderbutton.AbsolutePosition.X
			local percent = math.clamp(pos / sliderbutton.AbsoluteSize.X, 0, 1)
			updateValue(Slider.min + percent * (Slider.max - Slider.min))
		end

		sliderbutton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				moveSlider(input)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				moveSlider(input)
			end
		end)

		table.insert(self.Elements, slider)
		self.pos += 50
		tab:CalcScroll()

		local sliderObj = {
			Elem = slider,
			Name = config.Name,
			Value = value,
			GetState = function() return value end,
			SetValue = updateValue
		}

		self.AllElements.Sliders[config.Name] = sliderObj
		self.SearchData[slider] = config.Name .. " " .. (config.Description or "")

		updateValue(value)

		return sliderObj
	end

	function tab:AddColorPicker(config)
		local colorPicker = {
			Name = config.Name,
			Description = config.Description or "",
			Default = config.Default or Color3.new(1, 1, 1),
			Callback = config.Callback
		}

		local function create(className, props)
			local inst = Instance.new(className)
			for k, v in pairs(props) do inst[k] = v end
			return inst
		end

		local pos = self.pos
		local namepos = config.Description and config.Description ~= '' and 4 or 12.5

		local ColorPick = create("TextButton", {
			Name = "ColorPick",
			Parent = self.Container,
			BackgroundColor3 = Color3.fromRGB(225, 225, 225),
			BackgroundTransparency = self.Theme.BackGroundElemTran,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 7, 0, pos),
			Size = UDim2.new(0, 360, 0, 45),
			Text = ''
		})
		table.insert(tab.ElemBtn, ColorPick)
		create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = ColorPick})

		local name = create("TextLabel", {
			Name = "name", Parent = ColorPick, BackgroundTransparency = 1,
			Position = UDim2.new(0.029, 0, 0, namepos), Size = UDim2.new(0, 77, 0, 20),
			Font = Enum.Font.FredokaOne, Text = colorPicker.Name,
			TextColor3 = self.Theme.TabTextColor, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left
		})
		table.insert(tab.Texttitle, name)

		local subtext = create("TextLabel", {
			Name = "subtext", Parent = ColorPick, BackgroundTransparency = 1,
			Position = UDim2.new(0.029, 0, 0, 25), Size = UDim2.new(0, 193, 0, 14),
			Font = Enum.Font.FredokaOne, Text = colorPicker.Description,
			TextColor3 = self.Theme.TabSubTtitleTextColor, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
		})
		table.insert(tab.Textsubtitle, subtext)

		local colorButton = create("TextButton", {
			Parent = ColorPick, BackgroundColor3 = colorPicker.Default, BorderSizePixel = 0,
			Position = UDim2.new(0.802, 0, 0.206, 0), Size = UDim2.new(0, 54, 0, 25), Text = "", ZIndex = 2
		})
		create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = colorButton})

		local currentColor = colorPicker.Default
		local colorPaletteFrame, modalBackground
		local hue, saturation, value = currentColor:ToHSV()

		local svGradient, hueSlider, svSelector, innerCircle, previewFrame, hexInput

		local function updateVisuals()
			if not colorPaletteFrame then return end
			svGradient.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
			hueSlider.Position = UDim2.new(0, 0, hue, -2)
			svSelector.Position = UDim2.new(saturation, 0, 1 - value, 0)
			innerCircle.BackgroundColor3 = currentColor
			previewFrame.BackgroundColor3 = currentColor

			local r, g, b = math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255)
			hexInput.Text = string.format("#%02X%02X%02X", r, g, b)
		end

		local function setColor(color)
			if not color then return end
			currentColor = color
			colorButton.BackgroundColor3 = color
			hue, saturation, value = color:ToHSV()
			updateVisuals()
			if colorPicker.Callback then colorPicker.Callback(color) end
		end

		setColor(colorPicker.Default)

		local function togglePalette()
			if colorPaletteFrame and colorPaletteFrame.Visible then
				local tween = TweenService:Create(colorPaletteFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 0, 0, 0)
				})
				tween:Play()
				tween.Completed:Once(function()
					colorPaletteFrame.Visible = false
					modalBackground.Visible = false
				end)
				return
			end

			if not modalBackground then
				modalBackground = create("Frame", {
					Name = "ModalBackground", Parent = self.ImageLabel, BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.5, Size = UDim2.new(0.966, 0, 0.96, 0), Position = UDim2.new(0, 10, 0, 10), ZIndex = 40
				})
				create("UICorner", {CornerRadius = UDim.new(0, 24), Parent = modalBackground})

				colorPaletteFrame = create("Frame", {
					Name = "ColorPalette", Parent = self.ImageLabel, BackgroundColor3 = self.Theme.ColorPickerColoro,
					BorderSizePixel = 0, ZIndex = 50, Visible = false, Size = UDim2.new(0, 0, 0, 0),
					Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5)
				})
				table.insert(tab.ColorPickerColor, colorPaletteFrame)
				create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = colorPaletteFrame})
				create("UIStroke", {Color = Color3.fromRGB(60, 60, 70), Thickness = 2, Parent = colorPaletteFrame})

				local titleFrame = create("Frame", {Parent = colorPaletteFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), ZIndex = 51})
				local titleLabel = create("TextLabel", {
					Parent = titleFrame, Text = "Сhoose a color", Font = Enum.Font.GothamSemibold, TextSize = 16,
					TextColor3 = self.Theme.TabTextColor, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 52
				})
				table.insert(tab.Texttitle, titleLabel)

				svGradient = create("Frame", {Parent = colorPaletteFrame, Size = UDim2.new(0, 200, 0, 200), Position = UDim2.new(0.435, -100, 0, 50), ZIndex = 51})
				create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = svGradient})
				create("UIGradient", {Parent = svGradient, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})})
				create("UIGradient", {Parent = svGradient, Rotation = 90, Color = ColorSequence.new(Color3.new(0, 0, 0)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})})

				svSelector = create("Frame", {Parent = svGradient, Size = UDim2.new(0, 14, 0, 14), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, BorderSizePixel = 2, BorderColor3 = Color3.new(1, 1, 1), ZIndex = 52})
				create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = svSelector})

				innerCircle = create("Frame", {Parent = svSelector, Size = UDim2.new(0, 6, 0, 6), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), ZIndex = 53})
				create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = innerCircle})

				local hueFrame = create("Frame", {Parent = colorPaletteFrame, Size = UDim2.new(0, 20, 0, 200), Position = UDim2.new(0.82, 0, 0, 50), BackgroundTransparency = 1, ZIndex = 51})
				local hueGradientFrame = create("Frame", {Parent = hueFrame, Size = UDim2.new(1, 0, 1, 0), ZIndex = 51})
				create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = hueGradientFrame})

				local hueColors = {}
				for i = 0, 6 do table.insert(hueColors, ColorSequenceKeypoint.new(i/6, Color3.fromHSV(i/6, 1, 1))) end
				create("UIGradient", {Parent = hueGradientFrame, Rotation = 90, Color = ColorSequence.new(hueColors)})

				hueSlider = create("Frame", {Parent = hueFrame, Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 52})
				create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = hueSlider})

				local inputFrame = create("Frame", {Parent = colorPaletteFrame, BackgroundTransparency = 1, Size = UDim2.new(1, -40, 0, 40), Position = UDim2.new(0, 30, 0, 260), ZIndex = 51})

				hexInput = create("TextBox", {
					Parent = inputFrame, Size = UDim2.new(0.7, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(40, 40, 45),
					BackgroundTransparency = 0.5, TextColor3 = self.Theme.TabTextColor, Font = Enum.Font.Gotham,
					TextSize = 14, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 52
				})
				table.insert(tab.Texttitle, hexInput)
				create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = hexInput})
				create("UIStroke", {Color = Color3.fromRGB(60, 60, 70), Thickness = 1, Parent = hexInput})

				previewFrame = create("Frame", {Parent = colorPaletteFrame, Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0.76, 0, 0, 260), ZIndex = 51})
				create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = previewFrame})
				create("UIStroke", {Color = Color3.fromRGB(60, 60, 70), Thickness = 2, Parent = previewFrame})

				local function processInput(input, frame, isHueMode)
					local y = math.clamp((input.Position.Y - frame.AbsolutePosition.Y) / frame.AbsoluteSize.Y, 0, 1)
					if isHueMode then
						hue = y
					else
						local x = math.clamp((input.Position.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1)
						saturation, value = x, 1 - y
					end
					setColor(Color3.fromHSV(hue, saturation, value))
				end

				local draggingHue, draggingSV = false, false

				hueFrame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						draggingHue = true
						processInput(input, hueFrame, true)
					end
				end)

				svGradient.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						draggingSV = true
						processInput(input, svGradient, false)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						draggingHue, draggingSV = false, false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						if draggingHue then processInput(input, hueFrame, true)
						elseif draggingSV then processInput(input, svGradient, false) end
					end
				end)

				hexInput.FocusLost:Connect(function(enterPressed)
					if enterPressed then
						local hex = hexInput.Text:gsub("#", "")
						if #hex == 6 then
							local r, g, b = tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
							if r and g and b then setColor(Color3.fromRGB(r / 255, g / 255, b / 255)) end
						else
							updateVisuals()
						end
					end
				end)

				modalBackground.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						local pos, absPos, absSize = input.Position, colorPaletteFrame.AbsolutePosition, colorPaletteFrame.AbsoluteSize
						if pos.X < absPos.X or pos.X > absPos.X + absSize.X or pos.Y < absPos.Y or pos.Y > absPos.Y + absSize.Y then
							togglePalette()
						end
					end
				end)

				updateVisuals()
			else
				modalBackground.Visible = true
			end

			colorPaletteFrame.Visible = true
			TweenService:Create(colorPaletteFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 300, 0, 310)
			}):Play()
		end

		colorButton.MouseButton1Click:Connect(togglePalette)

		table.insert(self.Elements, ColorPick)
		self.pos += 50
		tab:CalcScroll()

		local colorPickerObj = { Elem = ColorPick }
		function colorPickerObj:SetColor(color) setColor(color) end
		function colorPickerObj:GetColor() return currentColor end

		self.AllElements.ColorPickers[config.Name] = colorPickerObj
		self.SearchData[ColorPick] = config.Name .. " " .. (config.Description or "")

		return colorPickerObj
	end

	function tab:AddDropdown(config)
		local dropdown = {
			Name = config.Name,
			Description = config.Description or '',
			Options = config.Options or {},
			Default = config.Default or "",
			Multi = config.Multi or false,
			Callback = config.Callback,
			Selected = config.Multi and {} or nil
		}

		local pos = self.pos
		local clickConnection = nil
		local optionElements = {}

		local Dropdown = Instance.new("TextButton")
		table.insert(tab.ElemBtn, Dropdown)
		local UICorner = Instance.new("UICorner")
		local name = Instance.new("TextLabel")
		table.insert(tab.Texttitle, name)
		local subtext = Instance.new("TextLabel")
		table.insert(tab.Textsubtitle, subtext)
		local Select = Instance.new("TextButton")
		table.insert(tab.actionBakcColor, Select)
		local UICorner_2 = Instance.new("UICorner")
		local TextLabel = Instance.new("TextLabel")
		local ImageLabel = Instance.new("ImageLabel")
		local ImageLabel_2 = Instance.new("ImageLabel")
		local Options = Instance.new("ScrollingFrame")
		local UICorner_3 = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")

		Dropdown.Name = "Dropdown"
		Dropdown.Parent = self.Container
		Dropdown.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		Dropdown.BackgroundTransparency = self.Theme.BackGroundElemTran
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.Position = UDim2.new(0, 7, 0, pos)
		Dropdown.Size = UDim2.new(0, 360, 0, 45)
		Dropdown.Text = ''

		UICorner.Parent = Dropdown
		UICorner.CornerRadius = UDim.new(0, 12)

		local namepos = config.Description and config.Description ~= '' and 4 or 12.5

		name.Name = "name"
		name.Parent = Dropdown
		name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		name.BackgroundTransparency = 1.000
		name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		name.BorderSizePixel = 0
		name.Position = UDim2.new(0.0290000141, 0, 0, namepos)
		name.Size = UDim2.new(0, 77, 0, 20)
		name.Font = Enum.Font.FredokaOne
		name.Text = dropdown.Name
		name.TextColor3 = self.Theme.TabTextColor
		name.TextSize = 16.000
		name.TextXAlignment = Enum.TextXAlignment.Left

		subtext.Name = "subtext"
		subtext.Parent = Dropdown
		subtext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		subtext.BackgroundTransparency = 1.000
		subtext.BorderColor3 = Color3.fromRGB(0, 0, 0)
		subtext.BorderSizePixel = 0
		subtext.Position = UDim2.new(0.0289855078, 0, 0, 25)
		subtext.Size = UDim2.new(0, 193, 0, 14)
		subtext.Font = Enum.Font.FredokaOne
		subtext.Text = dropdown.Description
		subtext.TextColor3 = self.Theme.TabSubTtitleTextColor
		subtext.TextSize = 14.000
		subtext.TextXAlignment = Enum.TextXAlignment.Left

		Select.Name = "Select"
		Select.Parent = Dropdown
		Select.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Select.BackgroundTransparency = self.Theme.BackGroundButtonTran
		Select.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Select.BorderSizePixel = 0
		Select.Position = UDim2.new(0.576207817, 0, 0.155555561, 0)
		Select.Size = UDim2.new(0, 135, 0, 30)
		Select.Text = ''

		UICorner_2.CornerRadius = UDim.new(0, 5)
		UICorner_2.Parent = Select

		TextLabel.Parent = Select
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0.038557943, 0, -0.0200012214, 0)
		TextLabel.Size = UDim2.new(0, 88, 0, 30)
		TextLabel.Font = Enum.Font.FredokaOne
		TextLabel.Text = "Select..."
		table.insert(tab.Texttitle, TextLabel)
		TextLabel.TextColor3 = self.Theme.TabTextColor
		TextLabel.TextSize = 14.000
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.816335738, 0, 0.166666672, 0)
		ImageLabel.Size = UDim2.new(0, 20, 0, 20)
		ImageLabel.Image = "rbxassetid://126982255108418"
		ImageLabel.ImageColor3 = self.Theme.DropDownArrowImg
		ImageLabel.Parent = Select

		table.insert(tab.DropDownArrowImg, ImageLabel)

		ImageLabel_2.Parent = self.Container.Parent.Parent
		ImageLabel_2.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
		ImageLabel_2.BackgroundTransparency = 1
		ImageLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel_2.BorderSizePixel = 0
		ImageLabel_2.Size = UDim2.new(0, 135, 0, 0)
		ImageLabel_2.Visible = false
		ImageLabel_2.ZIndex = 20
		ImageLabel_2.Image = "ImageLabel_2"
		ImageLabel_2.ImageTransparency = 0.9
		ImageLabel_2.ClipsDescendants = true

		Options.Name = "Options"
		Options.Parent = ImageLabel_2
		Options.Active = true
		Options.BackgroundColor3 = self.Theme.DropDownColor
		Options.BackgroundTransparency = self.Theme.DropDownTransparency
		Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Options.BorderSizePixel = 0
		Options.Position = UDim2.new(0.027777778, 0, 0.0350000001, 0)
		Options.Size = UDim2.new(0, 135, 0, 0)
		Options.ZIndex = 20
		Options.ScrollBarThickness = 2
		Options.CanvasSize = UDim2.new(0, 0, 0, 0)
		Options.ClipsDescendants = true
		table.insert(tab.DropImg, Options)

		UICorner_3.CornerRadius = UDim.new(0, 5)
		UICorner_3.Parent = Options

		UIListLayout.Parent = Options
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local dropdownElements = {
			Dropdown = Dropdown,
			Select = Select,
			TextLabel = TextLabel,
			ImageLabel_2 = ImageLabel_2,
			Options = Options
		}

		local function formatMultiText(selectedData)
			local selectedText = ""
			for opt, sel in pairs(selectedData) do
				if sel then
					selectedText = selectedText .. (selectedText == "" and opt or "," .. opt)
				end
			end

			if selectedText == "" then return "Select..." end

			local visible_count = 0

			for i = 1, #selectedText do
				local c = selectedText:sub(i, i)
				if c ~= " " and c ~= "," then
					visible_count = visible_count + 1
				end

				if visible_count >= 14 then
					local break_pos = i
					for j = i + 1, #selectedText do
						local next_char = selectedText:sub(j, j)
						if next_char ~= " " and next_char ~= "," then
							break
						end
						break_pos = j
					end

					local str = selectedText

					if #str >= 28 then
						str = str:sub(1, 28) .. "..."
					end
					return str:sub(1, break_pos) .. "\n" .. str:sub(break_pos + 1)
				end
			end

			if #selectedText >= 28 then
				selectedText = selectedText:sub(1, 28) .. "..."
			end

			return selectedText
		end

		local function formatSingleText(optionStr)
			local result = optionStr
			if #result >= 26 then result = result:sub(1, 26) .. "..." end
			return result
		end

		local function refreshVisuals()
			for optText, frameInd in pairs(optionElements) do
				local isSelected = dropdown.Multi and dropdown.Selected[optText] or (dropdown.Selected == optText)
				if isSelected then
					Library:Tween(frameInd, {Size = UDim2.new(0, 2, 0, 22), BackgroundTransparency = 0}, 0.2)
				else
					Library:Tween(frameInd, {Size = UDim2.new(0, 2, 0, 0), BackgroundTransparency = 1}, 0.2)
				end
			end
		end

		local function closeDropdown()
			if not ImageLabel_2.Visible then return end
			Library:Tween(ImageLabel_2, {Size = UDim2.new(0, 140, 0, 0)}, 0.2)
			Library:Tween(Options, {Size = UDim2.new(0, 135, 0, 0)}, 0.2)
			task.wait(0.2)
			ImageLabel_2.Visible = false
			if clickConnection then clickConnection:Disconnect() clickConnection = nil end
		end

		local function handleOptionClick(option)
			if dropdown.Multi then
				dropdown.Selected[option] = not dropdown.Selected[option]
				TextLabel.Text = formatMultiText(dropdown.Selected)
				refreshVisuals()
			else
				TextLabel.Text = formatSingleText(option)
				dropdown.Selected = option
				refreshVisuals()
				closeDropdown()
			end

			if dropdown.Callback then
				dropdown.Callback(dropdown.Multi and dropdown.Selected or option)
			end
		end

		local function createOption(optionText)
			local Option = Instance.new("TextButton")
			local OptionTextLabel = Instance.new("TextLabel")
			local Frame = Instance.new("Frame")
			local UICornerBtn = Instance.new("UICorner")
			local UICornerFrame = Instance.new("UICorner")

			Option.Name = optionText
			Option.Parent = Options
			Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Option.BackgroundTransparency = 1
			Option.Size = UDim2.new(0, 135, 0, 30)
			Option.ZIndex = 21
			Option.Text = ''

			optionElements[optionText] = Frame

			Option.MouseEnter:Connect(function()
				Library:Tween(Option, {BackgroundTransparency = 0.95}, 0.3)
				local isSelected = dropdown.Multi and dropdown.Selected[optionText] or (dropdown.Selected == optionText)
				if not isSelected then
					Library:Tween(Frame, {Size = UDim2.new(0, 2, 0, 22), BackgroundTransparency = 0.5}, 0.3)
				end
			end)

			Option.MouseLeave:Connect(function()
				Library:Tween(Option, {BackgroundTransparency = 1}, 0.3)
				local isSelected = dropdown.Multi and dropdown.Selected[optionText] or (dropdown.Selected == optionText)
				if not isSelected then
					Library:Tween(Frame, {BackgroundTransparency = 1, Size = UDim2.new(0, 2, 0, 0)}, 0.3)
				end
			end)

			OptionTextLabel.Parent = Option
			OptionTextLabel.BackgroundTransparency = 1
			OptionTextLabel.Position = UDim2.new(0.047, 0, 0, 0)
			OptionTextLabel.Size = UDim2.new(0, 124, 0, 30)
			OptionTextLabel.Font = Enum.Font.FredokaOne
			OptionTextLabel.Text = optionText
			OptionTextLabel.TextColor3 = self.Theme.TabTextColor
			OptionTextLabel.TextSize = 14
			OptionTextLabel.TextXAlignment = Enum.TextXAlignment.Left
			OptionTextLabel.ZIndex = 22
			table.insert(tab.Texttitle, OptionTextLabel)

			Frame.Parent = Option
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0.01, 0, 0, 4)
			Frame.Size = UDim2.new(0, 2, 0, 0)
			Frame.ZIndex = 22
			Frame.Transparency = 1
			table.insert(tab.DropDownFrameColor, Frame)

			UICornerFrame.CornerRadius = UDim.new(0, 20)
			UICornerFrame.Parent = Frame
			UICornerBtn.CornerRadius = UDim.new(0, 5)
			UICornerBtn.Parent = Option

			Option.MouseButton1Click:Connect(function()
				handleOptionClick(optionText)
			end)

			return Option
		end

		for _, option in ipairs(dropdown.Options) do createOption(option) end
		Options.CanvasSize = UDim2.new(0, 0, 0, #dropdown.Options * 30)

		local function updateDropdownPosition()
			local absolutePos = Select.AbsolutePosition
			local containerPos = ImageLabel_2.Parent.AbsolutePosition

			local currentScale = 1
			local ancestor = ImageLabel_2.Parent
			while ancestor and not ancestor:IsA("ScreenGui") do
				local uiScale = ancestor:FindFirstChildWhichIsA("UIScale")
				if uiScale then currentScale *= uiScale.Scale end
				ancestor = ancestor.Parent
			end

			local x = (absolutePos.X - containerPos.X) / currentScale - 4
			local y = (absolutePos.Y - containerPos.Y + Select.AbsoluteSize.Y) / currentScale

			ImageLabel_2.Position = UDim2.new(0, x, 0, y)
		end

		local function posselect()
			task.spawn(function()
				while ImageLabel_2.Visible do
					updateDropdownPosition()
					task.wait()
				end
			end)
		end

		local function openDropdown()
			updateDropdownPosition()
			ImageLabel_2.Visible = true
			local height = math.min(150, #dropdown.Options * 30)
			Library:Tween(ImageLabel_2, {Size = UDim2.new(0, 140, 0, height + 10)}, 0.2)
			Library:Tween(Options, {Size = UDim2.new(0, 135, 0, height)}, 0.2)
			refreshVisuals()
			posselect()

			if clickConnection then clickConnection:Disconnect() end
			clickConnection = UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					local pos = input.Position
					local inSelect = pos.X >= Select.AbsolutePosition.X and pos.X <= Select.AbsolutePosition.X + Select.AbsoluteSize.X and pos.Y >= Select.AbsolutePosition.Y and pos.Y <= Select.AbsolutePosition.Y + Select.AbsoluteSize.Y
					local inOptions = pos.X >= ImageLabel_2.AbsolutePosition.X and pos.X <= ImageLabel_2.AbsolutePosition.X + ImageLabel_2.AbsoluteSize.X and pos.Y >= ImageLabel_2.AbsolutePosition.Y and pos.Y <= ImageLabel_2.AbsolutePosition.Y + ImageLabel_2.AbsoluteSize.Y

					if not inSelect and not inOptions then closeDropdown() end
				end
			end)
		end

		Select.MouseButton1Click:Connect(function()
			if ImageLabel_2.Visible then closeDropdown() else openDropdown() end
		end)

		table.insert(self.Elements, Dropdown)
		self.pos += 50
		tab:CalcScroll()

		local dropdownObj = {
			Name = config.Name,
			Elem = Dropdown,
			Value = config.Default,
			Options = config.Options,
			Multi = config.Multi,
			GetValue = function() return dropdown.Selected end,
			SetValue = function(self, value)
				if self.Multi then
					table.clear(dropdown.Selected)
					if type(value) == "table" then
						for option, selected in pairs(value) do
							if selected and table.find(self.Options, option) then dropdown.Selected[option] = true end
						end
					end
					TextLabel.Text = formatMultiText(dropdown.Selected)
				else
					if table.find(self.Options, value) then
						dropdown.Selected = value
						TextLabel.Text = formatSingleText(value)
					end
				end
				refreshVisuals()
				if config.Callback then config.Callback(dropdown.Selected) end
			end,
			UpdateOptions = function(self, newOptions, newDefault)
				self.Options = newOptions
				dropdown.Options = newOptions
				table.clear(optionElements)
				for _, child in pairs(Options:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				for _, option in ipairs(newOptions) do createOption(option) end
				Options.CanvasSize = UDim2.new(0, 0, 0, #newOptions * 30)
				self:SetValue(newDefault or (dropdown.Multi and {} or nil))
			end,
			SetVisible = function(self, visible) Dropdown.Visible = visible end,
			Destroy = function(self)
				if clickConnection then clickConnection:Disconnect() end
				Dropdown:Destroy()
				ImageLabel_2:Destroy()
			end
		}

		if config.Default then dropdownObj:SetValue(config.Default) end
		self.AllElements.Dropdowns[config.Name] = dropdownObj
		self.SearchData[Dropdown] = config.Name .. " " .. (config.Description or "")

		return dropdownObj
	end

	self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.tabpos + 2)

	self.ScrollingFrameCanvasSize = UDim2.new(0, 0, 0, self.tabpos + 2)

	return tab
end

function Library:SelectTab(tab, button)
	for _, t in ipairs(self.mainTabs) do
		if t.Container then
			t.Container.Visible = false
		end
		if t.Button then
			self:Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
		end
		if t.Frame then
			self:Tween(t.Frame, {BackgroundTransparency = 1}, 0.2)
			self:Tween(t.Frame, {Size = UDim2.new(0, 2, 0, 0)}, 0.2)
		end
	end

	self.SearchTextBox.Text = "Search..."
	self:ClearSearchResults()

	if tab.Container then
		tab.Container.Visible = true
	end

	if button then
		self:Tween(button, {BackgroundTransparency = self.Theme.TabTransparancy}, 0.2)
		self:Tween(tab.Frame, {BackgroundTransparency = 0}, 0.2)
		self:Tween(tab.Frame, {Size = UDim2.new(0, 2, 0, 23)}, 0.2)
	end

	self.CurrentTab = tab
	self.TextLabel_5.Text = tab.Name
end

function Library:Tween(instance, properties, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end

function Library:ChangeBackgroundTransparance()
	if self.ImageLabel.ImageTransparency <= 0.05  then
		self.ImageLabel.ImageTransparency = 0.05
		self.Theme.BackGroundTran = 0.05
	else
		self.ImageLabel.ImageTransparency = 0
		self.Theme.BackGroundTran = 0
	end
end

function Library:Minimaze()
	if self.Windowscd == false then
		self.Windowscd = true
		if(self.ImageLabel.ImageTransparency ~= 1) then
			local gui = self.ImageLabel
			local newAnchor = Vector2.new(0.5, 0)

			local deltaX = newAnchor.X - gui.AnchorPoint.X
			local deltaY = newAnchor.Y - gui.AnchorPoint.Y

			local xOffset = deltaX * gui.AbsoluteSize.X
			local yOffset = deltaY * gui.AbsoluteSize.Y

			gui.AnchorPoint = newAnchor
			gui.Position = gui.Position + UDim2.new(0, xOffset, 0, yOffset)
			if not UserInputService.TouchEnabled then
				self.Frame.BackgroundTransparency = 1
				self.Header.BackgroundTransparency = self.Theme.BackGroundTran
				self.Tabs.Visible = false
				self.Sections.Visible = false
				self.IOSdragline.Visible = false
				if self.Sections.Size == UDim2.new(0, 375,0, 370) then
					self:Tween(self.ImageLabel,{Size = UDim2.new(0, 395,0, 40)},1)
					self:Tween(self.Header,{Size = UDim2.new(0, 380,0, 40)},0)
				else
					self:Tween(self.ImageLabel,{Size = UDim2.new(0, 620, 0, 40)},1)
					self.Header.Size = UDim2.new(0, 620 - 24, 0, 40)
				end
				wait(1)
				self.ImageLabel.ImageTransparency = 1
				self.Windowscd = false
			else
				local gui = self.ImageLabel
				local newAnchor = Vector2.new(0.5, 0)

				local deltaX = newAnchor.X - gui.AnchorPoint.X
				local deltaY = newAnchor.Y - gui.AnchorPoint.Y

				local xOffset = deltaX * gui.AbsoluteSize.X
				local yOffset = deltaY * gui.AbsoluteSize.Y

				gui.AnchorPoint = newAnchor
				gui.Position = gui.Position + UDim2.new(0, xOffset, 0, yOffset)
				self.Frame.BackgroundTransparency = 1
				self.Header.BackgroundTransparency = 1
				self.Tabs.Visible = false
				self.Sections.Visible = false

				self.Search.Visible = false
				self.TextLabel.Visible = false
				self.TextLabel_2.Visible = false
				self.version.Visible = false
				self.close.Visible = false
				self.ImageButton.Visible = false
				self.ImageButton_2.Visible = false

				self.IOSdragline.Visible = false

				if self.Sections.Size == UDim2.new(0, 375,0, 370) then
					self:Tween(self.ImageLabel,{Size = UDim2.new(0, 55,0, 40)},1)
					self:Tween(self.Header,{Size = UDim2.new(0, 40,0, 40)},0)
					self.ImageButton_2.Position = UDim2.new(0.28, 0,0.25, 0)
				else
					self:Tween(self.ImageLabel,{Size = UDim2.new(0, 40, 0, 40)},1)
					self.Header.Size = UDim2.new(0, 64 - 24, 0, 40)
					self.ImageButton_2.Position = UDim2.new(0.28, 0,0.25, 0)
				end
				wait(1)
				self.ImageButton_2.Visible = true
				self.ImageLabel.ImageTransparency = 1
				self.Header.BackgroundTransparency = self.Theme.BackGroundTran
				self.Windowscd = false
			end
		else
			if not UserInputService.TouchEnabled then
				self.Frame.BackgroundTransparency = self.Theme.headerlinetrans
				self.ImageLabel.ImageTransparency = self.Theme.BackGroundTran
				self.Header.BackgroundTransparency = 1
				if self.Sections.Size == UDim2.new(0, 375,0, 370) then
					self:Tween(self.ImageLabel,{Size = UDim2.new(0, 395,0, 480)},1)
					self:Tween(self.Header,{Size = UDim2.new(0, 380,0, 40)},1)
				else
					self:Tween(self.ImageLabel,{Size = UDim2.new(0, 620, 0, 480)},1)
					self:Tween(self.Header,{Size = UDim2.new(0, 620 - 24, 0, 40)},1)
				end

				wait(1)

				local gui = self.ImageLabel
				local targetAnchor = Vector2.new(0.5, 0.5)

				local delta = targetAnchor - gui.AnchorPoint

				local xOffset = delta.X * gui.AbsoluteSize.X
				local yOffset = delta.Y * gui.AbsoluteSize.Y

				gui.AnchorPoint = targetAnchor
				gui.Position = gui.Position + UDim2.new(0, xOffset, 0, yOffset)
				self.Tabs.Visible = true
				self.Sections.Visible = true
				self.Windowscd = false
				self.IOSdragline.Visible = true
			else
				local IsVisibleSearch = false
				self.ImageButton_2.Visible = false

				self.Frame.BackgroundTransparency = self.Theme.headerlinetrans
				self.ImageLabel.ImageTransparency = self.Theme.BackGroundTran
				self.Header.BackgroundTransparency = 1


				if self.Sections.Size == UDim2.new(0, 375,0, 370) then
					self:Tween(self.ImageLabel,{Size = UDim2.new(0, 395,0, 480)},1)
					self:Tween(self.Header,{Size = UDim2.new(0, 380,0, 40)},1)
					self.ImageButton_2.Position = UDim2.new(0.76, 0,0.29, 0)
				else
					self:Tween(self.ImageLabel,{Size = UDim2.new(0, 620, 0, 480)},1)
					IsVisibleSearch = true

					self.ImageButton_2.Position = UDim2.new(0.825, 0,0.29, 0)
					self:Tween(self.Header,{Size = UDim2.new(0, 620 - 24, 0, 40)},1)
				end

				wait(1)

				self.Frame.BackgroundTransparency = 0.95

				local gui = self.ImageLabel
				local targetAnchor = Vector2.new(0.5, 0.5)

				local delta = targetAnchor - gui.AnchorPoint

				local xOffset = delta.X * gui.AbsoluteSize.X
				local yOffset = delta.Y * gui.AbsoluteSize.Y

				gui.AnchorPoint = targetAnchor
				gui.Position = gui.Position + UDim2.new(0, xOffset, 0, yOffset)

				if IsVisibleSearch then
					self.Search.Visible = true
				end
				self.TextLabel.Visible = true
				self.TextLabel_2.Visible = true
				self.version.Visible = true
				self.close.Visible = true
				self.ImageButton.Visible = true
				self.ImageButton_2.Visible = true


				self.Tabs.Visible = true
				self.Sections.Visible = true
				self.Windowscd = false

				self.IOSdragline.Visible = true
			end
		end
	end
end

local SearchVis = false

function Library:ColumnWindow()
	if self.Windowscd == false then
		self.Windowscd = true
		if self.Sections.Size ~= UDim2.new(0, 375,0, 370) then
			SearchVis = false
			if self.Search.Visible == true then
				self:ShowSearch()
				SearchVis = true
			end
			self.Header.BackgroundTransparency = 1
			self.ImageLabel.ImageTransparency = 0.05
			self.Frame_2.Visible = false
			self:Tween(self.close, {Position = UDim2.new(0.92, 0,0.2, 0)}, 1)
			self:Tween(self.ImageButton, {Position = UDim2.new(0.854, 0,0.35, 0)}, 1)
			self:Tween(self.ImageButton_2, {Position = UDim2.new(0.76, 0,0.29, 0)}, 1)
			self:Tween(self.ImageLabel, {Size = UDim2.new(0, 395,0, 480)}, 1)
			self:Tween(self.Frame, {Size = UDim2.new(0, 381,0, 1)}, 1)
			self:Tween(self.Header, {Size = UDim2.new(0, 381,0, 40)}, 1)
			self.Tabs.Visible = false
			self.Sections.Visible = false
			self.WindowUser.Visible = false
			self.Sections.Size = UDim2.new(0, 375,0, 370)
			self.Sections.Position = UDim2.new(0.02, 0,0.201, 0)
			self.Frame_7.Size = UDim2.new(0, 375,0, 370)
			self.Frame_7.Position = UDim2.new(0, 2,0, 5)
			for i,v in pairs(self.mainTabs) do
				v.Tab[5].Position = UDim2.new(0,0,0,0)
				v.Tab[5].Size = UDim2.new(0, 375,0, 365)
			end
			self.Tabs.Size = UDim2.new(0, 375,0, 45)
			self.Tabs.Position =  UDim2.new(0.02,0,0.11, 0)
			self.ScrollingFrame.Size = UDim2.new(0, 375,0, 45)
			self.ScrollingFrame.Position =  UDim2.new(0,0,0,0)
			self.TextLabel_5.Visible = false
			local wight = 565 / #self.mainTabs
			if wight > 171 then
				wight = 171
			end
			local pos = 0
			local scroll = 1
			for i,v in pairs(self.mainTabs) do
				v.Tab[1].Position = UDim2.new(0, pos,0.1, 0)
				v.Tab[1].Size = UDim2.new(0, 130,0, 35)
				pos += 130
				if i == 3 then
					scroll += 0.045
				end
				if i > 3 then
					scroll += 0.34
				end
			end
			for i,v in pairs(self.mainTabs) do
				if v.Tab[4].Image ~= "1" then
					v.Tab[2].Position = UDim2.new(0.28, 0,0, -1)
				end
			end
			self.ScrollingFrame.CanvasSize = UDim2.new(scroll,0,0,0)
			self.ScrollingFrame.ScrollBarImageTransparency = 1
			wait(1)
			self.Tabs.Visible = true
			self.Sections.Visible = true
			self.Windowscd = false
		else
			self.Header.BackgroundTransparency = 1
			self.ImageLabel.ImageTransparency = 0.05
			self:Tween(self.ImageLabel, {Size = UDim2.new(0, 620,0, 480)}, 1)
			self:Tween(self.Frame, {Size = UDim2.new(0, 197,0, 1)}, 1)
			self:Tween(self.Header, {Size = UDim2.new(0, 596,0, 40)}, 1)
			self:Tween(self.close, {Position = UDim2.new(0.935, 0,0.2, 0)}, 1)
			self:Tween(self.ImageButton, {Position = UDim2.new(0.887, 0,0.35, 0)}, 1)
			self:Tween(self.ImageButton_2, {Position = UDim2.new(0.825, 0,0.29, 0)}, 1)
			self.Tabs.Visible = false
			self.Sections.Visible = false
			self.Frame_2.Visible = true
			self.Sections.Size = UDim2.new(0, 380,0, 414)
			self.Sections.Position = UDim2.new(0.35, 0,0.11, 0)
			self.Frame_7.Size = UDim2.new(0, 366,0, 379)
			self.Frame_7.Position = UDim2.new(0, 0,0.085, 0)
			for i,v in pairs(self.mainTabs) do
				v.Tab[5].Position = UDim2.new(0, 0,0.023, 0)
				v.Tab[5].Size = UDim2.new(0, 379,0, 370)
			end
			self.Tabs.Size = UDim2.new(0, 185,0, 414)
			self.Tabs.Position =  UDim2.new(0.035, 0,0.116, 0)
			self.ScrollingFrame.Size = UDim2.new(0, 185,0, 415)
			self.ScrollingFrame.Position =  UDim2.new(0, 0,0, 0)
			self.TextLabel_5.Visible = true
			local pos = 5
			local scroll = 5
			for i,v in pairs(self.mainTabs) do
				v.Tab[1].Position = UDim2.new(0, 0, 0, pos)
				v.Tab[1].Size = UDim2.new(0, 171,0, 35)
				pos += 40
				if i == 5 then
					scroll += 0.16
				end
				if i > 5 then
					scroll += 0.23
				end
			end
			for i,v in pairs(self.mainTabs) do
				if v.Tab[4].Image ~= "1" then
					v.Tab[2].Position = UDim2.new(0.21, 0,0, -1)
				end
			end
			self.ScrollingFrame.CanvasSize = self.ScrollingFrameCanvasSize
			wait(1)
			self.Tabs.Visible = true
			self.Sections.Visible = true
			if self.userinfo then
				self.WindowUser.Visible = true
				self.Tabs.Size = UDim2.new(0, 185,0, 372)
				self.ScrollingFrame.Size = UDim2.new(0, 185,0, 358)
			end
			if SearchVis == true then
				self:ShowSearch()
			end
		end
		self.Windowscd = false
	end
end

function Library:Destroy()
	for _, tab in ipairs(self.mainTabs) do
		for _, connection in ipairs(tab.Connections) do
			connection:Disconnect()
		end
		for _, connection in ipairs(tab.KeybindConnections) do
			connection:Disconnect()
		end
	end
	for name, controller in pairs(self.AllElements.Toggles) do
		if controller.Value == true then
			controller:SetState(false) 
		end
	end
	self:ClearSearchResults()
	self.Destroy_gui.Visible = false
	self.AllElements.Toggles = {}
	self:BlurOff()
	local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(self.ImageLabel, tweenInfo, {ImageTransparency = 1})
	tween:Play()
	self.Tabs.Visible = false
	self.Sections.Visible = false
	self.Header.Visible = false
	wait(0.5)
	self.UI:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.remove(self)
end

function Library:ShowDestroyQ()
	if self.Destroy_gui.Visible then
		self.dTextLabel.Visible = false
		self.dTextButton.Visible = false
		self.dTextLabel_2.Visible = false
		self.dTextButton_2.Visible = false
		self:Tween(self.dFrame_2,{Transparency = 1},0.15)
		wait(0.15)
		self.Destroy_gui.Visible = false
	else
		local newX = UDim.new(0, self.ImageLabel.Size.X.Offset - 22)
		local newY = UDim.new(0, self.ImageLabel.Size.Y.Offset - 20)
		self.Destroy_gui.Size = UDim2.new(newX, newY)
		if self.ImageLabel.Size ~= UDim2.new(0, 620, 0, 40) and self.ImageLabel.Size ~= UDim2.new(0, 620, 0, 480)  then
			self.dFrame_2.Position = UDim2.new(0.18, 0,0.329, 0)
		else
			self.dFrame_2.Position = UDim2.new(0.307, 0,0.329, 0)
		end
		self.Destroy_gui.Visible = true
		self:Tween(self.ImageLabel,{Position = UDim2.new(0.5, 0, 0.5, 0)},0.25)
		self:Tween(self.dFrame_2,{Transparency = self.Theme.DestroyGFrameTransparency},0.15)
		wait(0.15)
		self.dTextLabel.Visible = true
		self.dTextButton.Visible = true
		self.dTextLabel_2.Visible = true
		self.dTextButton_2.Visible = true
	end
end

function Library:UserInfo()
	if self.WindowUser.Visible then
		self.userinfo = false
		self.WindowUser.Visible = false
		self.Tabs.Size = UDim2.new(0, 185,0, 416)
		self.ScrollingFrame.Size = UDim2.new(0, 185,0, 416)
	else
		self.WindowUser.Visible = true
		self.Tabs.Size = UDim2.new(0, 185,0, 372)
		self.ScrollingFrame.Size = UDim2.new(0, 185,0, 358)
		self.userinfo = true
	end
end

function Library:Close()
	local size = self.ImageLabel.Size
	if self.ImageLabel.Visible then
		self:Tween(self.ImageLabel,{Size = UDim2.new(0, 40, 0, 0)},0)
		self.ImageLabel.Visible = false
	else
		if self.Sections.Visible == false then
			self:Tween(self.ImageLabel,{Size = UDim2.new(0, 620, 0, 40)},0)
		elseif self.Sections.Size == UDim2.new(0, 375,0, 370) then
			self:Tween(self.ImageLabel,{Size = UDim2.new(0, 395,0, 480)},0)
		else
			self:Tween(self.ImageLabel,{Size = UDim2.new(0, 620, 0, 480)},0)
		end
		self.ImageLabel.Visible = true
	end
end

function Library:TurnOffAllFunctions(WhiteList, CallBack)
	for name, controller in pairs(self.AllElements.Toggles) do
		local check = false

		if WhiteList ~= nil then
			for i, v in pairs(WhiteList) do
				if v == controller then
					check = true
					break
				end
			end
		end

		if not check then
			if controller.Value == true then
				controller:SetState(false)
			end
		end
	end

	if CallBack then
		CallBack()
	end
end

function Library:GetConfig(filename)
	if not isfile(filename) then
		self:Notification({
			Name = "Error",
			Description = "Config not found",
			Duration = 10,
			Type = "Error"
		})
	else
		setclipboard(readfile(filename))
		self:Notification({
			Name = "Config",
			Description = "The config has been successfully copied to the clipboard",
			Duration = 10,
			Type = "Notification"
		})
	end
end

function Library:InputConfig(filename,Config)
	writefile(filename,Config)
end

function Library:SaveConfig(foldername,filename)
	local config = {
		Toggles = {}, Keybinds = {}, Dropdowns = {},
		Sliders = {}, ColorPickers = {}, Inputs = {}
	}

	for name, obj in pairs(self.AllElements.Toggles) do
		config.Toggles[name] = obj:GetState()
	end

	for name, obj in pairs(self.AllElements.Keybinds) do
		config.Keybinds[name] = tostring(obj:GetState())
	end

	for name, obj in pairs(self.AllElements.Sliders) do
		config.Sliders[name] = obj:GetState()
	end

	for name, obj in pairs(self.AllElements.Dropdowns) do
		config.Dropdowns[name] = obj.GetValue()
	end

	for name, obj in pairs(self.AllElements.Inputs) do
		config.Inputs[name] = obj:GetState()
	end

	for name, obj in pairs(self.AllElements.ColorPickers) do
		local color = obj:GetColor()
		config.ColorPickers[name] = {R = color.R, G = color.G, B = color.B}
	end

	if not isfolder(foldername) then makefolder(foldername) end
	writefile(foldername .. "/" .. filename, HttpService:JSONEncode(config))
end

function Library:IsLoadConfig(filename)
    if not isfile(filename) then 
        return false 
    end

    local success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(filename))
    end)

    if not success or not data or not data.Toggles then 
        return false 
    end

    local toggles = self.AllElements.Toggles
    local savedToggles = data.Toggles

    -- Список имен тоглов для проверки
    local configKeys = {"Load Config", "Auto Load Config"}

    for _, key in ipairs(configKeys) do
        local toggleElement = toggles[key]
        local savedState = savedToggles[key]

        if toggleElement and savedState == true then
            toggleElement:SetState(true)
            return true -- Возвращаем true, если нашли и активировали автозагрузку
        end
    end

    return false
end

function Library:LoadConfig(filename)
	if not isfile(filename) then return false end

	local success, data = pcall(function()
		return HttpService:JSONDecode(readfile(filename))
	end)
	if not success then return false end

	if data.Inputs then
		for name, value in pairs(data.Inputs) do
			local obj = self.AllElements.Inputs[name]
			if obj then
				if obj.SaveConfig ~= true then
					obj.SetText(value)
				end
			end
		end
	end

	if data.Keybinds then
		for name, keyStr in pairs(data.Keybinds) do
			local obj = self.AllElements.Keybinds[name]
			if obj and keyStr ~= "None" then
				local successKey, keyCode = pcall(function() return Enum.KeyCode[keyStr] end)
				if successKey then obj.SetKey(keyCode) end
			end
		end
	end

	if data.Sliders then
		for name, value in pairs(data.Sliders) do
			local obj = self.AllElements.Sliders[name]
			if obj then obj.SetValue(value) end
		end
	end

	if data.Dropdowns then
		for name, value in pairs(data.Dropdowns) do
			local obj = self.AllElements.Dropdowns[name]
			if obj then
				if obj.Multi and type(value) == "table" then
					local fixed = {}
					for k, v in pairs(value) do
						if type(k) == "string" then fixed[k] = v else fixed[v] = true end
					end
					obj:SetValue(fixed)
				else
					obj:SetValue(value)
				end
			end
		end
	end

	if data.ColorPickers then
		for name, c in pairs(data.ColorPickers) do
			local obj = self.AllElements.ColorPickers[name]
			if obj then obj:SetColor(Color3.new(c.R, c.G, c.B)) end
		end
	end

	if data.Toggles then
		for name, state in pairs(data.Toggles) do
			local obj = self.AllElements.Toggles[name]
			if obj then
				if name ~= "Load Config" and name ~= "Auto Load Config" then
					obj:SetState(state)
				end
			end
		end
	end

	return true
end

function Library:SetSavePath(folder, filename)
	self.saveFolder = folder
	self.saveFileName = filename
end

function Library:GetConfigsList()
	local folder = self.saveFolder or "zxcursedsocute"
	if not isfolder(folder) then makefolder(folder) end

	local files = listfiles(folder)
	local configs = {}
	for _, path in ipairs(files) do
		local name = path:gsub(folder .. "/", "")
		if name:find(".json") then
			table.insert(configs, name)
		end
	end
	return configs
end

function Library:UpdateConfigSelection(name)
	local validName = name:find(".json") and name or name .. ".json"
	self.saveFileName = validName

	writefile(self.saveFolder .. "/last_config.txt", validName)
end

function Library:DeleteConfig(folder, filename)
	local path = folder .. "/" .. filename
	if isfile(path) then
		delfile(path)
		return true
	end
	return false
end

function Library:SearchAllTabs()
	local searchText = self.SearchTextBox.Text
	if searchText == "Search..." then
		searchText = ""
	end

	self:ClearSearchResults()

	if searchText == "" then
		self.IsSearching = false
		return
	end

	self.IsSearching = true
	local searchLower = string.lower(searchText)
	local currentTab = self.CurrentTab
	local foundElements = {}

	for _, tab in ipairs(self.mainTabs) do
		for element, elementData in pairs(tab.SearchData) do
			if string.find(string.lower(elementData), searchLower, 1, true) then
				table.insert(foundElements, {
					element = element,
					originalTab = tab,
					originalParent = element.Parent,
					originalPosition = element.Position
				})
			end
		end
	end

	table.sort(foundElements, function(a, b)
		local aIsCurrent = a.originalTab == currentTab
		local bIsCurrent = b.originalTab == currentTab

		if aIsCurrent and not bIsCurrent then
			return true
		elseif not aIsCurrent and bIsCurrent then
			return false
		else
			return a.originalTab.Name < b.originalTab.Name
		end
	end)

	local container = currentTab.Container
	local yOffset = 5
	local positionStep = 50

	for i, result in ipairs(foundElements) do
		local element = result.element
		self.OriginalTabElements[element] = {
			Parent = element.Parent,
			Position = element.Position,
			Visible = element.Visible
		}

		element.Parent = container
		element.Visible = true
		element.Position = UDim2.new(0, 7, 0, yOffset)

		yOffset = yOffset + element.Size.Y.Offset + 5

		table.insert(self.CurrentSearchResults, element)
	end

	container.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

function Library:ClearSearchResults()
	if self.CurrentTab then
		self.CurrentTab:CalcScroll()
	end
	if not self.IsSearching then return end

	for _, element in ipairs(self.CurrentSearchResults) do
		local original = self.OriginalTabElements[element]
		if original then
			element.Parent = original.Parent
			element.Position = original.Position
			element.Visible = original.Visible
		end
	end

	self.OriginalTabElements = {}
	self.CurrentSearchResults = {}
	self.IsSearching = false
end

function Library:ShowSearch()
	if self.Search.Visible then
		self.Search.Visible = false
	else
		self.Search.Visible = true
	end	
end

local Themes = {
	["Dark"] = {
		BackGroundIcon = "rbxassetid://124703424830654",
		TextColor = Color3.fromRGB(255, 255, 255),
		SubTtitleTextColor = Color3.fromRGB(125, 125, 125),
		Notisubtitlecolor = Color3.fromRGB(199, 199, 199),
		HeaderColor = Color3.fromRGB(26, 26, 26),
		headerlinecolor = Color3.fromRGB(255, 255, 255),
		headerlinetrans = 1,
		TabsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		NotiImg = "rbxassetid://101518186301089",
		NotiTitleColor = Color3.fromRGB(255, 255, 255),
		BackGroundTran = 0.05,
		DestroyGFrame = Color3.fromRGB(22, 22, 22),
		DestroyGFrameTransparency = 0,
		dbtntran = 0.95,
		TabTransparancy = 0.95,
		dbtncolor = Color3.fromRGB(255, 255, 255),
		versionBackgroundColor3 = Color3.fromRGB(255, 255, 255),
		versionBackgroundTransparency = 0,
		versionTextColor = Color3.fromRGB(0, 0, 0),
		IOSdraglineColor = Color3.fromRGB(255, 255, 255),
		TabTextColor = Color3.fromRGB(255, 255, 255),
		TabColor = Color3.fromRGB(255, 255, 255),
		TabSubTtitleTextColor = Color3.fromRGB(199, 199, 199),
		TogleActivColor = Color3.fromRGB(28, 96, 255),
		DropDownArrowImg = Color3.fromRGB(255, 255, 255),
		TabsIconColor = Color3.fromRGB(255, 255, 255),
		InputTextColor = Color3.fromRGB(175, 175, 175),
		BackGroundElemTran = 0.95,
		BackGroundElemCol = Color3.fromRGB(255, 255, 255),
		BackGroundButtonTran = 0.95,
		ActionBackColor = Color3.fromRGB(255, 255, 255),
		ToggleButton = Color3.fromRGB(255, 255, 255),
		ToggleTran = 0.9,
		SectionsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		DropDownColor = Color3.fromRGB(47, 47, 47),
		DropDownTransparency = 0,
		DropDownFrameColor = Color3.fromRGB(255, 255, 255),
		SliderUnderLineColor = Color3.fromRGB(28, 96, 255),
		Togglebtn = Color3.fromRGB(255, 255, 255),
		Sliderball = Color3.fromRGB(255, 255, 255),
		ColorPickerColoro = Color3.fromRGB(47, 47, 47),
		ListFrameColor = Color3.fromRGB(40, 40, 40)
	},
	["White"] = {
		BackGroundIcon = "rbxassetid://85154344778026",
		TextColor = Color3.fromRGB(0, 0, 0),
		SubTtitleTextColor = Color3.fromRGB(49, 49, 49),
		Notisubtitlecolor = Color3.fromRGB(67, 67, 67),
		HeaderColor = Color3.fromRGB(255, 255, 255),
		headerlinecolor = Color3.fromRGB(165, 165, 165),
		headerlinetrans = 1,
		TabsScrollingBarFrameColor = Color3.fromRGB(0, 0, 0),
		NotiImg = "rbxassetid://103895576341932",
		NotiTitleColor = Color3.fromRGB(0, 0, 0),
		BackGroundTran = 0.05,
		DestroyGFrame = Color3.fromRGB(255, 255, 255),
		DestroyGFrameTransparency = 0,
		dbtntran = 0.8,
		TabTransparancy = 0.95,
		dbtncolor = Color3.fromRGB(0, 0, 0),
		versionBackgroundColor3 = Color3.fromRGB(0, 0, 0),
		versionBackgroundTransparency = 0,
		versionTextColor = Color3.fromRGB(255, 255, 255),
		IOSdraglineColor = Color3.fromRGB(0, 0, 0),
		TabTextColor = Color3.fromRGB(0, 0, 0),
		TabColor = Color3.fromRGB(0, 0, 0),
		TabSubTtitleTextColor = Color3.fromRGB(67, 67, 67),
		TogleActivColor = Color3.fromRGB(84, 84, 84),
		DropDownArrowImg = Color3.fromRGB(0, 0, 0),
		TabsIconColor = Color3.fromRGB(0, 0, 0),
		InputTextColor = Color3.fromRGB(67, 67, 67),
		BackGroundElemTran = 0.9,
		BackGroundElemCol = Color3.fromRGB(0, 0, 0),
		ActionBackColor = Color3.fromRGB(33, 33, 33),
		BackGroundButtonTran = 0.9,
		SectionsScrollingBarFrameColor = Color3.fromRGB(0, 0, 0),
		DropDownColor = Color3.fromRGB(202, 202, 202),
		DropDownTransparency = 0,
		DropDownFrameColor = Color3.fromRGB(0, 0, 0),
		SliderUnderLineColor = Color3.fromRGB(0, 0, 0),
		Togglebtn = Color3.fromRGB(0, 0, 0),
		Sliderball = Color3.fromRGB(0, 0, 0),
		ColorPickerColoro = Color3.fromRGB(255, 255, 255),
		ListFrameColor = Color3.fromRGB(220, 220, 220)
	},
	["Darkness"] = {
		BackGroundIcon = "rbxassetid://71126967316056",
		TextColor = Color3.fromRGB(255, 255, 255),
		SubTtitleTextColor = Color3.fromRGB(125, 125, 125),
		Notisubtitlecolor = Color3.fromRGB(199, 199, 199),
		HeaderColor = Color3.fromRGB(61, 63, 65),
		headerlinecolor = Color3.fromRGB(255, 255, 255),
		headerlinetrans = 1,
		TabsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		NotiImg = "rbxassetid://116797594577574",
		NotiTitleColor = Color3.fromRGB(255, 255, 255),
		BackGroundTran = 0.05,
		DestroyGFrame = Color3.fromRGB(61, 63, 65),
		DestroyGFrameTransparency = 0,
		dbtntran = 0.95,
		TabTransparancy = 0.95,
		dbtncolor = Color3.fromRGB(255, 255, 255),
		versionBackgroundColor3 = Color3.fromRGB(255, 255, 255),
		versionBackgroundTransparency = 0,
		versionTextColor = Color3.fromRGB(0, 0, 0),
		IOSdraglineColor = Color3.fromRGB(255, 255, 255),
		TabTextColor = Color3.fromRGB(255, 255, 255),
		TabColor = Color3.fromRGB(255, 255, 255),
		TabSubTtitleTextColor = Color3.fromRGB(199, 199, 199),
		TogleActivColor = Color3.fromRGB(28, 96, 255),
		DropDownArrowImg = Color3.fromRGB(255, 255, 255),
		TabsIconColor = Color3.fromRGB(255, 255, 255),
		InputTextColor = Color3.fromRGB(175, 175, 175),
		BackGroundElemTran = 0.95,
		BackGroundElemCol = Color3.fromRGB(255, 255, 255),
		BackGroundButtonTran = 0.95,
		ActionBackColor = Color3.fromRGB(255, 255, 255),
		ToggleButton = Color3.fromRGB(255, 255, 255),
		ToggleTran = 0.9,
		SectionsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		DropDownColor = Color3.fromRGB(61, 63, 65),
		DropDownTransparency = 0,
		DropDownFrameColor = Color3.fromRGB(255, 255, 255),
		SliderUnderLineColor = Color3.fromRGB(28, 96, 255),
		Togglebtn = Color3.fromRGB(255, 255, 255),
		Sliderball = Color3.fromRGB(255, 255, 255),
		ColorPickerColoro = Color3.fromRGB(61, 63, 65),
		ListFrameColor = Color3.fromRGB(66, 66, 66)
	},
	["Black"] = {
		BackGroundIcon = "rbxassetid://135546341015171",
		TextColor = Color3.fromRGB(255, 255, 255),
		SubTtitleTextColor = Color3.fromRGB(199, 199, 199),
		Notisubtitlecolor = Color3.fromRGB(199, 199, 199),
		HeaderColor = Color3.fromRGB(0, 0, 0),
		headerlinecolor = Color3.fromRGB(165, 165, 165),
		headerlinetrans = 1,
		TabsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		NotiImg = "rbxassetid://121010433723211",
		NotiTitleColor = Color3.fromRGB(255, 255, 255),
		BackGroundTran = 0.05,
		DestroyGFrame = Color3.fromRGB(0, 0, 0),
		DestroyGFrameTransparency = 0,
		dbtntran = 0.9,
		TabTransparancy = 0.95,
		dbtncolor = Color3.fromRGB(255, 255, 255),
		versionBackgroundColor3 = Color3.fromRGB(255, 255, 255),
		versionBackgroundTransparency = 0,
		versionTextColor = Color3.fromRGB(0, 0, 0),
		IOSdraglineColor = Color3.fromRGB(255, 255, 255),
		TabTextColor = Color3.fromRGB(255, 255, 255),
		TabColor = Color3.fromRGB(255, 255, 255),
		TabSubTtitleTextColor = Color3.fromRGB(203, 203, 203),
		TogleActivColor = Color3.fromRGB(0, 0, 0),
		DropDownArrowImg = Color3.fromRGB(255, 255, 255),
		TabsIconColor = Color3.fromRGB(255, 255, 255),
		InputTextColor = Color3.fromRGB(255, 255, 255),
		BackGroundElemTran = 0.95,
		BackGroundElemCol = Color3.fromRGB(255, 255, 255),
		ActionBackColor = Color3.fromRGB(255, 255, 255),
		BackGroundButtonTran = 0.9,
		SectionsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		DropDownColor = Color3.fromRGB(0, 0, 0),
		DropDownTransparency = 0,
		DropDownFrameColor = Color3.fromRGB(255, 255, 255),
		SliderUnderLineColor = Color3.fromRGB(0, 0, 0),
		Togglebtn = Color3.fromRGB(255, 255, 255),
		Sliderball = Color3.fromRGB(255, 255, 255),
		ColorPickerColoro = Color3.fromRGB(0, 0, 0),
		ListFrameColor = Color3.fromRGB(18, 18, 18)
	},
	["Forest 2021"] = {
		BackGroundIcon = "rbxassetid://101614984726336",
		TextColor = Color3.fromRGB(255, 255, 255),
		SubTtitleTextColor = Color3.fromRGB(125, 125, 125),
		Notisubtitlecolor = Color3.fromRGB(199, 199, 199),
		HeaderColor = Color3.fromRGB(0, 0, 0),
		headerlinecolor = Color3.fromRGB(229, 229, 229),
		headerlinetrans = 1,
		TabsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		NotiImg = "rbxassetid://129831795524094",
		NotiTitleColor = Color3.fromRGB(255, 255, 255),
		BackGroundTran = 0.05,
		DestroyGFrame = Color3.fromRGB(54, 54, 54),
		DestroyGFrameTransparency = 0,
		dbtntran = 0.95,
		TabTransparancy = 0.95,
		dbtncolor = Color3.fromRGB(255, 255, 255),
		versionBackgroundColor3 = Color3.fromRGB(255, 255, 255),
		versionBackgroundTransparency = 0.8,
		versionTextColor = Color3.fromRGB(255, 255, 255),
		IOSdraglineColor = Color3.fromRGB(255, 255, 255),
		TabTextColor = Color3.fromRGB(255, 255, 255),
		TabColor = Color3.fromRGB(255, 255, 255),
		TabSubTtitleTextColor = Color3.fromRGB(199, 199, 199),
		TogleActivColor = Color3.fromRGB(28, 96, 255),
		DropDownArrowImg = Color3.fromRGB(255, 255, 255),
		TabsIconColor = Color3.fromRGB(255, 255, 255),
		InputTextColor = Color3.fromRGB(175, 175, 175),
		BackGroundElemTran = 0.95,
		BackGroundElemCol = Color3.fromRGB(255, 255, 255),
		BackGroundButtonTran = 0.95,
		ActionBackColor = Color3.fromRGB(255, 255, 255),
		ToggleButton = Color3.fromRGB(255, 255, 255),
		ToggleTran = 0.9,
		SectionsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		DropDownColor = Color3.fromRGB(255, 255, 255),
		DropDownTransparency = 0.95,
		DropDownFrameColor = Color3.fromRGB(255, 255, 255),
		SliderUnderLineColor = Color3.fromRGB(28, 96, 255),
		Togglebtn = Color3.fromRGB(255, 255, 255),
		Sliderball = Color3.fromRGB(255, 255, 255),
		ColorPickerColoro = Color3.fromRGB(152, 152, 152),
		ListFrameColor = Color3.fromRGB(40, 40, 40)
	},
	["Cursed"] = {
		BackGroundIcon = "rbxassetid://139069464889319",
		TextColor = Color3.fromRGB(255, 255, 255),
		SubTtitleTextColor = Color3.fromRGB(125, 125, 125),
		Notisubtitlecolor = Color3.fromRGB(199, 199, 199),
		HeaderColor = Color3.fromRGB(16, 17, 31),
		headerlinecolor = Color3.fromRGB(255, 255, 255),
		headerlinetrans = 1,
		TabsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		NotiImg = "rbxassetid://133419353491012",
		NotiTitleColor = Color3.fromRGB(255, 255, 255),
		BackGroundTran = 0.05,
		DestroyGFrame = Color3.fromRGB(22, 23, 42),
		DestroyGFrameTransparency = 0,
		dbtntran = 0.95,
		TabTransparancy = 0.95,
		dbtncolor = Color3.fromRGB(255, 255, 255),
		versionBackgroundColor3 = Color3.fromRGB(224, 206, 255),
		versionBackgroundTransparency = 0,
		versionTextColor = Color3.fromRGB(0, 0, 0),
		IOSdraglineColor = Color3.fromRGB(63, 59, 126),
		TabTextColor = Color3.fromRGB(255, 255, 255),
		TabColor = Color3.fromRGB(255, 255, 255),
		TabSubTtitleTextColor = Color3.fromRGB(199, 199, 199),
		TogleActivColor = Color3.fromRGB(63, 59, 126),
		DropDownArrowImg = Color3.fromRGB(69, 65, 140),
		TabsIconColor = Color3.fromRGB(255, 255, 255),
		InputTextColor = Color3.fromRGB(175, 175, 175),
		BackGroundElemTran = 0.95,
		BackGroundElemCol = Color3.fromRGB(255, 255, 255),
		BackGroundButtonTran = 0.95,
		ActionBackColor = Color3.fromRGB(255, 255, 255),
		ToggleButton = Color3.fromRGB(255, 255, 255),
		ToggleTran = 0.9,
		SectionsScrollingBarFrameColor = Color3.fromRGB(255, 255, 255),
		DropDownColor = Color3.fromRGB(16, 17, 31),
		DropDownTransparency = 0,
		DropDownFrameColor = Color3.fromRGB(63, 59, 126),
		SliderUnderLineColor = Color3.fromRGB(63, 59, 126),
		Togglebtn = Color3.fromRGB(255, 255, 255),
		Sliderball = Color3.fromRGB(255, 255, 255),
		ColorPickerColoro = Color3.fromRGB(16, 17, 31),
		ListFrameColor = Color3.fromRGB(16, 17, 31)
	},
	["Ocean"] = {
		BackGroundIcon = "rbxassetid://105905712253823",
		TextColor = Color3.fromRGB(235, 245, 255),
		SubTtitleTextColor = Color3.fromRGB(150, 190, 220),
		Notisubtitlecolor = Color3.fromRGB(180, 210, 235),
		HeaderColor = Color3.fromRGB(20, 40, 70),
		headerlinecolor = Color3.fromRGB(120, 170, 220),
		headerlinetrans = 0.3,
		TabsScrollingBarFrameColor = Color3.fromRGB(200, 230, 255),
		NotiImg = "rbxassetid://126290083909491",
		NotiTitleColor = Color3.fromRGB(230, 245, 255),
		BackGroundTran = 0.12,
		DestroyGFrame = Color3.fromRGB(15, 30, 55),
		DestroyGFrameTransparency = 0,
		dbtntran = 0.85,
		TabTransparancy = 0.88,
		dbtncolor = Color3.fromRGB(210, 235, 255),
		versionBackgroundColor3 = Color3.fromRGB(74, 98, 255),
		versionBackgroundTransparency = 0,
		versionTextColor = Color3.fromRGB(0, 0, 0),
		IOSdraglineColor = Color3.fromRGB(255, 255, 255),
		TabTextColor = Color3.fromRGB(235, 245, 255),
		TabColor = Color3.fromRGB(190, 220, 255),
		TabSubTtitleTextColor = Color3.fromRGB(160, 195, 230),
		TogleActivColor = Color3.fromRGB(0, 120, 255),
		DropDownArrowImg = Color3.fromRGB(255, 255, 255),
		TabsIconColor = Color3.fromRGB(255, 255, 255),
		InputTextColor = Color3.fromRGB(170, 200, 235),
		BackGroundElemTran = 0.88,
		BackGroundElemCol = Color3.fromRGB(225, 245, 255),
		BackGroundButtonTran = 0.85,
		ActionBackColor = Color3.fromRGB(230, 245, 255),
		ToggleButton = Color3.fromRGB(200, 230, 255),
		ToggleTran = 0.83,
		SectionsScrollingBarFrameColor = Color3.fromRGB(200, 225, 255),
		DropDownColor = Color3.fromRGB(25, 45, 75),
		DropDownTransparency = 0.1,
		DropDownFrameColor = Color3.fromRGB(220, 240, 255),
		SliderUnderLineColor = Color3.fromRGB(25, 130, 255),
		Togglebtn = Color3.fromRGB(235, 245, 255),
		Sliderball = Color3.fromRGB(255, 255, 255),
		ColorPickerColoro = Color3.fromRGB(30, 50, 80),
		ListFrameColor = Color3.fromRGB(66, 66, 66)
	}
}

function Library:SetTheme(themeName : string)
	if self.CurrentThemeName == themeName then return end

	local theme = Themes[themeName]
	if not theme then return end

	self.CurrentThemeName = themeName
	self.Theme = theme

	for i, v in pairs(self["ActiveNotifications"]) do
		v["notification"].Image = theme.NotiImg
		v["notification"].Title.TextColor3 = theme.TextColor
		v["notification"].Description.TextColor3 = theme.SubTtitleTextColor
		v["notification"].CloseButton.ImageColor3 = self.Theme.TabsIconColor
		if v["notification"].Icon.Image == "rbxassetid://75930996983661" or v["notification"].Icon.Image == "rbxassetid://76158273611595" then
			v["notification"].Icon.ImageColor3 = self.Theme.TabsIconColor
		end
	end

	self.SearchImageLabel.ImageColor3 = theme.TabsIconColor

	self.Frame_2.BackgroundColor3 = theme.TextColor
	self.Frame.BackgroundColor3 = theme.TextColor
	self.WindowUser.BackgroundColor3 = theme.versionBackgroundColor3
	self.version.BackgroundColor3 = theme.versionBackgroundColor3
	self.IOSdragline.BackgroundColor3 = theme.IOSdraglineColor
	self.version.BackgroundTransparency = theme.versionBackgroundTransparency
	self.versionTextLabel.TextColor3 = theme.versionTextColor
	self.Search.BackgroundColor3 =  theme.dbtncolor
	self.Search.BackgroundTransparency =  theme.dbtntran
	self.SearchTextBox2.TextColor3 = theme.TextColor
	self.ImageLabel.Image = theme.BackGroundIcon
	self.TextLabel.TextColor3 = theme.TextColor
	self.TextLabel_2.TextColor3 = theme.SubTtitleTextColor
	self.TextLabel_5.TextColor3 = theme.TextColor
	self.close.ImageColor3 = theme.TabsIconColor
	self.ImageButton_2.ImageColor3 = theme.TabsIconColor
	self.ImageButton.ImageColor3 = theme.TabsIconColor
	self.Frame.BackgroundColor3 = theme.headerlinecolor
	self.Frame.BackgroundTransparency = theme.headerlinetrans
	self.ScrollingFrame.ScrollBarImageColor3 = theme.TabsScrollingBarFrameColor
	self.Header.BackgroundColor3 = theme.HeaderColor
	self.dFrame_2.BackgroundColor3 = theme.DestroyGFrame
	self.dFrame_2.BackgroundTransparency = theme.DestroyGFrameTransparency
	self.dTextLabel.TextColor3 = theme.TextColor
	self.dTextButton_2.BackgroundColor3 = theme.dbtncolor
	self.dTextLabel_2.TextColor3 = theme.SubTtitleTextColor
	self.dTextButton_2.TextColor3 = theme.TextColor
	self.wTextLabel.TextColor3 = theme.TextColor
	self.wTextLabel_2.TextColor3 = theme.SubTtitleTextColor
	if self.CurrentTab then
		self.CurrentTab ["Tab"][1].BackgroundTransparency = theme.TabTransparancy
	end
	for i,v in pairs(self.mainTabs) do
		v.Tab[1].BackgroundColor3 = theme.TabColor
		v.Tab[2].TextColor3 = theme.TabTextColor
		v.Tab[4].ImageColor3 = theme.TabsIconColor
		v.Tab[3].BackgroundColor3 = theme.TabTextColor
		v.Tab[5].ScrollBarImageColor3 = theme.SectionsScrollingBarFrameColor

		local updateMap = {
			{v.ElemBtn, "BackgroundColor3", theme.BackGroundElemCol},
			{v.ElemBtn, "BackgroundTransparency", theme.BackGroundElemTran},
			{v.Texttitle, "TextColor3", theme.TabTextColor},
			{v.Textsubtitle, "TextColor3", theme.TabSubTtitleTextColor},
			{v.actionBakcColor, "BackgroundColor3", theme.BackGroundElemCol},
			{v.BtnImg, "ImageColor3", theme.DropDownArrowImg},
			{v.ArrowImg, "ImageColor3", theme.DropDownArrowImg},
			{v.DropImg, "BackgroundColor3", theme.DropDownColor},
			{v.DropDownArrowImg, "ImageColor3", theme.DropDownArrowImg},
			{v.DropImg, "BackgroundTransparency", theme.DropDownTransparency},
			{v.DropDownFrameColor, "BackgroundColor3", theme.DropDownFrameColor},
			{v.ActiveToggleColor, "BackgroundColor3", theme.TogleActivColor},
			{v.InputTextColor, "TextColor3", theme.InputTextColor},
			{v.SliderUnderLineColor, "BackgroundColor3", theme.SliderUnderLineColor},
			{v.Togglebtn, "BackgroundColor3", theme.Togglebtn},
			{v.Sliderball, "BackgroundColor3", theme.Sliderball},
			{v.ColorPickerColor, "BackgroundColor3", theme.ColorPickerColoro},
			{v.ListFrames, "BackgroundColor3", theme.ListFrameColor}
		}

		for _, data in ipairs(updateMap) do
			local list, prop, val = data[1], data[2], data[3]
			if list and val ~= nil then
				for _, obj in ipairs(list) do
					obj[prop] = val
				end
			end
		end

		if theme.BackGroundElemTran then
			for _, bg in ipairs(v.actionBakcColor) do
				bg.BackgroundTransparency = theme.BackGroundElemTran
			end
		end
	end  
end

return Library
