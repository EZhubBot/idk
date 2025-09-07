local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CoreGui = Players.LocalPlayer.PlayerGui
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local speed = 5
local option1 = Color3.new(149, 0, 255)
local option2 = Color3.new(255, 0, 127)
local option3 = Color3.new(0.8, 0, 1)
local option = 3
local Color = Color3.new(0,0,0)
local rainbow = false
local toolblur = nil
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = PlayerGui
local tooltipUI = Instance.new('Frame')
tooltipUI.Name = 'tooltipUI'
tooltipUI.ZIndex = 9999
tooltipUI.Size = UDim2.fromScale(1, 1)
tooltipUI.BackgroundTransparency = 1
tooltipUI.Parent = gui

local ConfigSetting = {ToggleButton = {MiniToggle = {}, Sliders = {}, Dropdown = {}}}
local MainFile = nil
local Library = {}

local tooltip

function Dark(col, num)
	local h, s, v = col:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(select(3, Color3.fromRGB(26, 25, 26):ToHSV()) > 0.5 and v + num or v - num, 0, 1))
end

tooltip = Instance.new('TextLabel')
tooltip.Name = 'Tooltip'
tooltip.Position = UDim2.fromScale(-1, -1)
tooltip.ZIndex = 999
tooltip.BackgroundColor3 = Dark(Color3.fromRGB(26, 25, 26), 0.02)
tooltip.Visible = false
tooltip.Text = ''
tooltip.TextColor3 = Color3.fromRGB(235, 235, 235)
tooltip.TextSize = 26
tooltip.FontFace = Font.fromEnum(Enum.Font.Arial, Enum.FontWeight.Bold)
tooltip.Parent = tooltipUI
scale = Instance.new('UIScale')
scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
scale.Parent = tooltipUI

if not shared.FunnyStarPanel then
	shared.FunnyStarPanel = {
		Uninjected = false,
		Visual = {
			Hud = true,
			Arraylist = true,
			Watermark = true
		}
	}
end

local AutoSave = false
spawn(function()
	while AutoSave do
		task.wait(2)
		if shared.FunnyStarPanel.Uninjected then
			AutoSave = false
		end
	end
end)

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge

local getfontsize = function(text, size, font)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then
		fontsize.Font = font
	end
	return game:GetService("TextService"):GetTextBoundsAsync(fontsize)
end

function addTooltip(gui, text)
	if not text then return end

	local function tooltipMoved(x, y)
		local right = x + 16 + tooltip.Size.X.Offset > (scale.Scale * 1920)
		tooltip.Position = UDim2.fromOffset(
			(right and x - (tooltip.Size.X.Offset * scale.Scale) - 16 or x + 16) / scale.Scale,
			((y + 11) - (tooltip.Size.Y.Offset)) / scale.Scale
		)
		tooltip.Visible = true
	end

	gui.MouseEnter:Connect(function(x, y)
		local tooltipSize = getfontsize(text, tooltip.TextSize, Font.fromEnum(Enum.Font.Arial, Enum.FontWeight.Bold))
		tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)
		tooltip.Text = text
		tooltipMoved(x, y)
	end)
	gui.MouseMoved:Connect(tooltipMoved)
	gui.MouseLeave:Connect(function()
		tooltip.Visible = false
	end)
end

function MakeDraggable(object)
	local dragging, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	object.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	object.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function Spoof(length)
	local Letter = {}
	for i = 1, length do
		local RandomLetter = string.char(math.random(97, 122))
		table.insert(Letter, RandomLetter)
	end
	return table.concat(Letter)
end

spawn(function()

	game:GetService("TextChatService").MessageReceived:Connect(function(msg)
		if msg and msg.Text then
			if string.match(msg.Text:lower(), "nothm") or string.match(msg.Text:upper(), "NOTHM") then
				shared.FunnyStarPanel.Uninjected = true
				game:GetService("StarterGui"):SetCore("SendNotification", { 
					Title = "Funny Star Panel",
					Text = "Uninjecting..",
					Duration = 2,
				})
			end
		end
	end)
end)

function Library:CreateMain()
	local Main = {}

	if RunService:IsClient() then
		local TextChatService = game:GetService('TextChatService')

		TextChatService.OnIncomingMessage = function(Message)
			local Properties = Instance.new('TextChatMessageProperties')
			if game.Players.LocalPlayer.Name == "stargamer_m" then else return end

			if Message.TextSource.UserId == game.Players.LocalPlayer.UserId then
				task.spawn(function()
					Properties.PrefixText = "<font color='rgb(255, 0, 144)'>[FUNNYSTARHUB OWNER] </font>" .. Message.PrefixText
				end)
			end

			return Properties
		end
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Name = Spoof(math.random(8, 12))
	if RunService:IsStudio() then
		ScreenGui.Parent = PlayerGui
	end

	spawn(function()
		RunService.RenderStepped:Connect(function()
			if ScreenGui then
				if shared.FunnyStarPanel.Uninjected then
					task.wait(1.2)
					ScreenGui:Destroy()
					shared.FunnyStarPanel.Uninjected = false
				end
			end
		end)
	end)

	local MainFrame = nil
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		if MainFrame == nil then
			MainFrame = Instance.new("ScrollingFrame")
			MainFrame.Parent = ScreenGui
			MainFrame.Active = true
			MainFrame.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
			print(MainFrame.BackgroundColor3)
			MainFrame.BackgroundTransparency = 1.000
			MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainFrame.BorderSizePixel = 0
			MainFrame.Size = UDim2.new(1, 0, 1, 0)
			MainFrame.CanvasPosition = Vector2.new(240, 0)
			MainFrame.CanvasSize = UDim2.new(1.60000002, 0, 0, 0)
			MainFrame.ScrollBarThickness = 8
			MainFrame.Visible = false
		end
	elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
		if MainFrame == nil then
			MainFrame = Instance.new("Frame")
			MainFrame.Parent = ScreenGui
			MainFrame.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
			MainFrame.BackgroundTransparency = 1.000
			MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainFrame.Size = UDim2.new(1, 0, 1, 0)
			MainFrame.Visible = false
		end
	end

	spawn(function()
		local OldX = 0
		if MainFrame ~= nil and MainFrame.Parent then
			for _, child in ipairs(MainFrame:GetChildren()) do
				if child:IsA("GuiObject") then
					child.Position = UDim2.new(0, OldX, 0, 0)
					OldX = OldX + child.Size.X.Offset + 18
				end
			end
		end
	end)

	local KeybindFrame = Instance.new("Frame")
	KeybindFrame.Parent = ScreenGui
	KeybindFrame.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
	KeybindFrame.BackgroundTransparency = 1.000
	KeybindFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindFrame.Size = UDim2.new(1, 0, 1, 0)
	KeybindFrame.Visible = true

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = MainFrame
	UIPadding.PaddingLeft = UDim.new(0, 20)
	UIPadding.PaddingTop = UDim.new(0, 22)

	local HudFrame = Instance.new("Frame")
	HudFrame.Parent = ScreenGui
	HudFrame.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
	HudFrame.BackgroundTransparency = 1.000
	HudFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HudFrame.BorderSizePixel = 0
	HudFrame.Size = UDim2.new(1, 0, 1, 0)
	Library.HudMainFrame = HudFrame

	spawn(function()
		RunService.RenderStepped:Connect(function()	
			if HudFrame then
				if shared.FunnyStarPanel.Visual.Hud then
					HudFrame.Visible = true
				else
					HudFrame.Visible = false
				end
			end
		end)
	end)

	local LibraryTitle = Instance.new("TextLabel")
	LibraryTitle.Parent = HudFrame
	LibraryTitle.Visible = false
	LibraryTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LibraryTitle.BackgroundTransparency = 1.000
	LibraryTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LibraryTitle.BorderSizePixel = 0
	LibraryTitle.Position = UDim2.new(0, 20, 0, -6.5)
	LibraryTitle.Size = UDim2.new(0, 345, 0, 30)
	LibraryTitle.Text = "FunnyStarPanel"
	LibraryTitle.FontFace = Font.new([[rbxasset://fonts/families/Michroma.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	LibraryTitle.TextColor3 = rainbow and Color or Color3.fromRGB(255, 0, 127)
	LibraryTitle.TextScaled = true
	LibraryTitle.TextSize = 14.000
	LibraryTitle.TextWrapped = true
	LibraryTitle.TextXAlignment = Enum.TextXAlignment.Left
	LibraryTitle.ZIndex = -1

	local LibraryTitle2 = Instance.new("TextLabel")
	LibraryTitle2.Parent = HudFrame
	LibraryTitle2.Visible = false
	LibraryTitle2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LibraryTitle2.BackgroundTransparency = 1.000
	LibraryTitle2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LibraryTitle2.BorderSizePixel = 0
	LibraryTitle2.Position = UDim2.new(0, 1129,0, -10)
	LibraryTitle2.Size = UDim2.new(0, 345, 0, 30)
	LibraryTitle2.Text = "FunnyStarPanel"
	LibraryTitle2.FontFace = Font.new([[rbxasset://fonts/families/Michroma.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	LibraryTitle2.TextColor3 = rainbow and Color or Color3.fromRGB(255, 0, 127)
	LibraryTitle2.TextScaled = true
	LibraryTitle2.TextSize = 14.000
	LibraryTitle2.TextWrapped = true
	LibraryTitle2.TextXAlignment = Enum.TextXAlignment.Left
	LibraryTitle2.ZIndex = -1

	local TitleGradient = Instance.new("UIGradient")
	TitleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
	TitleGradient.Parent = LibraryTitle

	spawn(function()
		RunService.RenderStepped:Connect(function()	
			if HudFrame and LibraryTitle2 then
				if shared.FunnyStarPanel.Visual.Watermark then
					LibraryTitle2.Visible = true
				else
					LibraryTitle2.Visible = false
				end
			end
		end)
	end)

	local ArrayTable = {}
	local ArrayFrame = Instance.new("Frame")
	ArrayFrame.Parent = HudFrame
	ArrayFrame.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
	ArrayFrame.BackgroundTransparency = 1.000
	ArrayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ArrayFrame.BorderSizePixel = 0
	ArrayFrame.Position = UDim2.new(0.819999993, 0, 0.0399999991, 0)
	ArrayFrame.Size = UDim2.new(0.162, 0, 0.930000007, 0)

	local UIListLayout_4 = Instance.new("UIListLayout")
	UIListLayout_4.Parent = ArrayFrame
	UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Right

	spawn(function()
		RunService.RenderStepped:Connect(function()	
			if HudFrame and ArrayFrame then
				if shared.FunnyStarPanel.Visual.Arraylist then
					ArrayFrame.Visible = true
				else
					ArrayFrame.Visible = false
				end
			end
		end)
	end)

	local function AddArray(name)
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = ArrayFrame
		TextLabel.BackgroundColor3 = rainbow and Color or Color3.fromRGB(0, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextTransparency = 1
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.Text = name

		--local bar = Instance.new("Frame")
		--bar.Size = UDim2.new(0, 0, 1, 0)
		--bar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		--bar.ZIndex = 1
		--bar.BorderColor3 = Color3.fromRGB(255, 100, 100)
		--bar.BorderSizePixel = .5
		--bar.Parent = TextLabel

		--local function updateBar()
		--	bar.Size = UDim2.new(0, 0, 1, 0)
		--	bar.Position = UDim2.new(
		--		TextLabel.Position.X.Scale,
		--		TextLabel.Position.X.Offset + TextLabel.Size.X.Offset, -- shift right by width
		--		TextLabel.Position.Y.Scale,
		--		TextLabel.Position.Y.Offset
		--	)
		--end

		--updateBar()
		--TextLabel:GetPropertyChangedSignal("Size"):Connect(updateBar)
		--TextLabel:GetPropertyChangedSignal("Position"):Connect(updateBar)

		if option == 1 then
			TextLabel.TextColor3 = rainbow and Color or option1
		elseif option == 2 then
			TextLabel.TextColor3 = rainbow and Color or option2
		elseif option == 3 then
			TextLabel.TextColor3 = rainbow and Color or option3
		end
		TextLabel.TextScaled = true
		TextLabel.TextSize = 18.000
		TextLabel.TextWrapped = true
		TextLabel.ZIndex = -1
		TextLabel.TextXAlignment = Enum.TextXAlignment.Right
		TweenService:Create(TextLabel, TweenInfo.new(1.8), {TextTransparency = 0, BackgroundTransparency = 0.750}):Play()

		local TextGradient = Instance.new("UIGradient")
		TextGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
		TextGradient.Parent = TextLabel

		local NewWidth = game.TextService:GetTextSize(name, 18, Enum.Font.SourceSans, Vector2.new(0, 0)).X
		local NewSize = UDim2.new(0.01, game.TextService:GetTextSize(name , 18, Enum.Font.SourceSans, Vector2.new(0,0)).X, 0,20)
		if name == "" then
			NewSize = UDim2.fromScale(0,0)
		end

		TextLabel.Position = UDim2.new(1, -NewWidth, 0, 0)
		TextLabel.Size = NewSize
		table.insert(ArrayTable,TextLabel)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text .. "  ", 18, Enum.Font.SourceSans, Vector2.new(0,20)).X > game.TextService:GetTextSize(b.Text .. "  ", 18, Enum.Font.SourceSans,Vector2.new(0,20)).X end)
		for i,v in ipairs(ArrayTable) do
			v.LayoutOrder = i
		end
	end

	local function RemoveArray(name)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,20)).X > game.TextService:GetTextSize(b.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,20)).X end)
		local c = 0
		for i,v in ipairs(ArrayTable) do
			c += 1
			if (v.Text == name) then
				v:Destroy()
				table.remove(ArrayTable,c)
			else
				v.LayoutOrder = i
			end
		end
	end

	local MainOpen = nil
	local UICorner_2 = nil
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		if MainFrame:IsA("ScrollingFrame") and MainFrame.Parent then
			MainOpen = Instance.new("TextButton")
			MainOpen.Parent = ScreenGui
			MainOpen.AnchorPoint = Vector2.new(0.5, 0.5)
			MainOpen.BackgroundColor3 = rainbow and Color or Color3.fromRGB(20, 20, 20)
			MainOpen.BackgroundTransparency = 0.550
			MainOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainOpen.BorderSizePixel = 0
			--MainOpen.Position = UDim2.new(0.02, 0, 0.95, 0)
			MainOpen.Position = UDim2.new(0.5, 0, 0.0380000018, 0)
			MainOpen.Size = UDim2.new(0, 25, 0, 25)
			MainOpen.ZIndex = 5
			MainOpen.Font = Enum.Font.SourceSans
			MainOpen.Text = "FunnyStarPanel"
			MainOpen.Visible = false
			MainOpen.TextColor3 = Color3.fromRGB(255, 255, 255)
			MainOpen.TextScaled = true
			MainOpen.TextSize = 14.000
			MainOpen.TextWrapped = true

			UICorner_2 = Instance.new("UICorner")
			UICorner_2.CornerRadius = UDim.new(0, 4)
			UICorner_2.Parent = MainOpen

			MainOpen.MouseButton1Click:Connect(function()
				MainFrame.Visible = not MainFrame.Visible
			end)
		end
	end

	UserInputService.InputBegan:Connect(function(Input, isTyping)
		if Input.KeyCode == Enum.KeyCode.K and not isTyping then
			print("a")
			LibraryTitle.Visible = not LibraryTitle.Visible
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	local Frame = Instance.new("Frame")
	Frame.Parent = HudFrame
	Frame.AnchorPoint = Vector2.new(0, 0.5)
	Frame.BackgroundColor3 = rainbow and Color or Color3.fromRGB(45, 45, 45)
	Frame.BackgroundTransparency = 0.15
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(0, 231, 0, 50)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Visible = false
	MakeDraggable(Frame)

	local ImageLabel_2 = Instance.new("ImageLabel")
	ImageLabel_2.Parent = Frame
	ImageLabel_2.AnchorPoint = Vector2.new(0, 0.5)
	ImageLabel_2.BackgroundTransparency = 1
	ImageLabel_2.Position = UDim2.new(0, 5, 0.5, 0)
	ImageLabel_2.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
	ImageLabel_2.Size = UDim2.new(0, 40, 0, 40)

	local Frame_2 = Instance.new("Frame")
	Frame_2.Parent = Frame
	Frame_2.AnchorPoint = Vector2.new(0, 0.5)
	Frame_2.BackgroundColor3 = rainbow and Color or Color3.fromRGB(25, 25, 25)
	Frame_2.BackgroundTransparency = 0.35
	Frame_2.Position = UDim2.new(0, 50, 0.75, 0)
	Frame_2.Size = UDim2.new(0, 100, 0, 8)
	Frame_2.BorderSizePixel = 0

	local TextLabel_2 = Instance.new("TextLabel")
	TextLabel_2.Parent = Frame
	TextLabel_2.BackgroundTransparency = 1
	TextLabel_2.Font = Enum.Font.SourceSansBold
	TextLabel_2.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextSize = 18
	TextLabel_2.TextWrapped = true
	TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

	local Frame_3 = Instance.new("Frame")
	Frame_3.Parent = Frame_2
	Frame_3.AnchorPoint = Vector2.new(0, 0.5)
	Frame_3.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 0, 127)
	Frame_3.Position = UDim2.new(0, 0, 0.5, 0)
	Frame_3.Size = UDim2.new(0, 50, 0, 8)
	Frame_3.BorderSizePixel = 0

	local Frame3Gradient = Instance.new("UIGradient")
	Frame3Gradient.Parent = Frame_3
	Frame3Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}

	function Main:CreateTargetHUD(name, thumbnail, humanoid, ishere)
		local TargetHUD = {}

		if ishere then
			Frame.Visible = true
			if name and humanoid then
				ImageLabel_2.Image = thumbnail
				TextLabel_2.Text = name

				local Calculation = humanoid.Health / humanoid.MaxHealth
				local NewTextSize = game:GetService("TextService"):GetTextSize(TextLabel_2.Text, TextLabel_2.TextSize, TextLabel_2.Font, Vector2.new(9999, 50))
				local Width = NewTextSize.X + ImageLabel_2.Size.X.Offset + 20
				local NewSize_2 = UDim2.new(0, Width, 0, 50)

				Frame.Size = NewSize_2
				Frame_2.Size = UDim2.new(0, NewTextSize.X, 0, 8)
				TextLabel_2.Size = UDim2.new(0, NewTextSize.X, 0, NewTextSize.Y)
				TextLabel_2.Position = UDim2.new(0, Frame_2.Position.X.Offset, 0.12, 0)

				if humanoid.Health > 0 then
					TweenService:Create(Frame_3, TweenInfo.new(0.5), {Size = UDim2.new(Calculation, 0, 0, 8)}):Play()
				elseif humanoid.Health < 0 then
					TweenService:Create(Frame_3, TweenInfo.new(0.5), {Size = UDim2.new(-0, 0, 0, 8)}):Play()
				else
					TweenService:Create(Frame_3, TweenInfo.new(0.5), {Size = UDim2.new(-0, 0, 0, 8)}):Play()
				end
			end
		else
			Frame.Visible = false
		end

		return TargetHUD
	end

	function Main:CreateLine(Origin, Destination)
		local Position = (Origin + Destination) / 2

		local Line = Instance.new("Frame")
		Line.Name = "Line"
		Line.AnchorPoint = Vector2.new(0.5, 0.5)
		Line.Parent = HudFrame
		Line.Position = UDim2.new(0, Position.X, 0, Position.Y)
		Line.Size = UDim2.new(0, (Origin - Destination).Magnitude, 0, 0.02)
		Line.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
		Line.BorderColor3 = Color3.fromRGB(255, 255, 255)
		Line.Rotation = math.deg(math.atan2(Destination.Y - Origin.Y, Destination.X - Origin.X))

		return Line
	end

	function Main:CreateTab(name, icon, iconcolor)
		local Tabs = {}

		local TabHolder = Instance.new("Frame")
		TabHolder.ZIndex = 2
		TabHolder.Parent = MainFrame
		TabHolder.BackgroundColor3 = rainbow and Color or Color3.fromRGB(20, 20, 20)
		TabHolder.BackgroundTransparency = 0.030
		TabHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabHolder.BorderSizePixel = 0
		TabHolder.Size = UDim2.new(0, 185, 0, 25)
		if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
			MakeDraggable(TabHolder)
		end

		local TabName = Instance.new("TextLabel")
		TabName.ZIndex = 2
		TabName.Parent = TabHolder
		TabName.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1.000
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Position = UDim2.new(0, 5, 0, 0)
		TabName.Size = UDim2.new(0, 145, 1, 0)
		TabName.Font = Enum.Font.Nunito
		TabName.Text = name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextSize = 18.000
		TabName.TextWrapped = true
		TabName.TextXAlignment = Enum.TextXAlignment.Left

		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.ZIndex = 2
		ImageLabel.Parent = TabHolder
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0, 172, 0.5, 0)
		ImageLabel.Size = UDim2.new(0, 18, 0, 18)
		ImageLabel.Image = "http://www.roblox.com/asset/?id=" .. icon
		ImageLabel.ImageColor3 = iconcolor

		local TogglesList = Instance.new("Frame")
		TogglesList.ZIndex = 2
		TogglesList.Parent = TabHolder
		TogglesList.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
		TogglesList.BackgroundTransparency = 1.000
		TogglesList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TogglesList.BorderSizePixel = 0
		TogglesList.Position = UDim2.new(0, 0, 1, 0)
		TogglesList.Size = UDim2.new(1, 0, 0, 0)

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Parent = TogglesList
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		function Tabs:CreateToggle(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				ToolTipText = ToggleButton.ToolTipText,
				Keybind = ToggleButton.Keybind or "Home",
				Enabled = ToggleButton.Enabled or false,
				AutoEnable = ToggleButton.AutoEnable or false,
				AutoDisable = ToggleButton.AutoDisable or false,
				Hide = ToggleButton.Hide or false,
				Callback = ToggleButton.Callback or function() end
			}
			if not ConfigSetting.ToggleButton[ToggleButton.Name] then
				ConfigSetting.ToggleButton[ToggleButton.Name] = {
					Enabled = ToggleButton.Enabled,
					Keybind = ToggleButton.Keybind,
				}
			else
				ToggleButton.Enabled = ConfigSetting.ToggleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = ConfigSetting.ToggleButton[ToggleButton.Name].Keybind
			end

			local ToggleButtonHolder = Instance.new("TextButton")
			ToggleButtonHolder.Parent = TogglesList
			ToggleButtonHolder.BackgroundColor3 = rainbow and Color or Color3.fromRGB(30, 30, 30)
			ToggleButtonHolder.BackgroundTransparency = 0--.230
			ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.BorderSizePixel = 0
			ToggleButtonHolder.Size = UDim2.new(1, 0, 0, 25)
			ToggleButtonHolder.AutoButtonColor = false
			ToggleButtonHolder.Font = Enum.Font.SourceSans
			ToggleButtonHolder.Text = ""
			ToggleButtonHolder.ZIndex = 2
			ToggleButtonHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.TextSize = 14.000

			if ToggleButton.ToolTipText then
				addTooltip(ToggleButtonHolder, ToggleButton.ToolTipText)
			end

			local ToggleName = Instance.new("TextLabel")
			ToggleName.Parent = ToggleButtonHolder
			ToggleName.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleName.BorderSizePixel = 0
			ToggleName.Position = UDim2.new(0, 5, 0, 0)
			ToggleName.Size = UDim2.new(0, 145, 1, 0)
			ToggleName.FontFace =  Font.fromEnum(Enum.Font.Arial)
			ToggleName.Text = ToggleButton.Name
			ToggleName.ZIndex = 2
			ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.TextSize = 16.000
			ToggleName.TextWrapped = true
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left

			local OpenMenu = Instance.new("TextButton")
			OpenMenu.Parent = ToggleButtonHolder
			OpenMenu.AnchorPoint = Vector2.new(0.5, 0.5)
			OpenMenu.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
			OpenMenu.BackgroundTransparency = 1.000
			OpenMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OpenMenu.BorderSizePixel = 0
			OpenMenu.Position = UDim2.new(0, 173, 0.5, 0)
			OpenMenu.Size = UDim2.new(0, 20, 0, 20)
			OpenMenu.Font = Enum.Font.SourceSans
			OpenMenu.ZIndex = 2
			OpenMenu.Text = ">"
			OpenMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.TextScaled = true
			OpenMenu.TextSize = 14.000
			OpenMenu.TextWrapped = true

			local UIGradient = Instance.new("UIGradient")
			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
			UIGradient.Parent = ToggleButtonHolder
			UIGradient.Enabled = false

			local ToggleMenuOpened = false
			local ToggleMenuOld = UDim2.new(1, 0, 0, 0)
			local ToggleMenuNew = UDim2.new(1, 0, 0, 125)
			local ToggleMenu, ScrollingMenu = nil, nil
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if ToggleMenu == nil then
					ToggleMenu = Instance.new("Frame")
					ToggleMenu.Parent = TogglesList
					ToggleMenu.BackgroundColor3 = rainbow and Color or Color3.fromRGB(30, 30, 30)
					--ToggleMenu.BackgroundTransparency = 1
					ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ToggleMenu.BorderSizePixel = 0
					ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
					ToggleMenu.Size = UDim2.new(1, 0, 0, 125)
					ToggleMenu.Visible = false

					ScrollingMenu = Instance.new("ScrollingFrame")
					ScrollingMenu.Parent = ToggleMenu
					ScrollingMenu.Active = true
					ScrollingMenu.BackgroundColor3 = rainbow and Color or Color3.fromRGB(30, 30, 30)
					ScrollingMenu.BackgroundTransparency = 0--.150
					ScrollingMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ScrollingMenu.BorderSizePixel = 0
					ScrollingMenu.Size = UDim2.new(1, 0, 0, 125)
					ScrollingMenu.ScrollBarThickness = 0
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if ToggleMenu == nil then
					ToggleMenu = Instance.new("Frame")
					ToggleMenu.Parent = TogglesList
					ToggleMenu.BackgroundColor3 = rainbow and Color or Color3.fromRGB(30, 30, 30)
					ToggleMenu.BackgroundTransparency = 0--.150
					ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ToggleMenu.BorderSizePixel = 0
					ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
					ToggleMenu.Size = UDim2.new(1, 0, 0, 125)
					ToggleMenu.Visible = false
					ScrollingMenu = nil
				end
			end

			--Here
			local Keybinds = nil
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if Keybinds == nil then
					local MobileKeybinds, IsKeybind = nil, false
					Keybinds = Instance.new("TextButton")
					Keybinds.Parent = ScrollingMenu
					Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
					Keybinds.BackgroundTransparency = 1.000
					Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.BorderSizePixel = 0
					Keybinds.LayoutOrder = -1
					Keybinds.Size = UDim2.new(1, 0, 0, 25)
					Keybinds.Font = Enum.Font.SourceSans
					Keybinds.Text = "Show"
					Keybinds.TextColor3 = Color3.fromRGB(255, 255, 255)
					Keybinds.TextSize = 14.000
					Keybinds.MouseButton1Click:Connect(function()
						IsKeybind = not IsKeybind
						if IsKeybind then
							Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(60, 60, 60)
							local MobileKeybinds = Instance.new("TextButton")
							MobileKeybinds.Parent = KeybindFrame

							spawn(function()
								while true do
									task.wait()
									if ToggleButton.Enabled then
										MobileKeybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(0, 175, 0)
									else
										MobileKeybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(175, 0, 0)
									end
								end
							end)

							local MobileKeybindText = string.len(ToggleButton.Name)
							local MobileKeybindY = game:GetService("TextService"):GetTextSize(ToggleButton.Name, 14, Enum.Font.SourceSans, Vector2.new(200, math.huge))
							MobileKeybinds.BackgroundTransparency = 0.750
							MobileKeybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
							MobileKeybinds.BorderSizePixel = 0
							MobileKeybinds.Position = UDim2.new(0.192740932, 0, 0.301066756, 0)
							MobileKeybinds.Size = UDim2.new(0, 65, 0, MobileKeybindY.Y + 15)
							MobileKeybinds.Font = Enum.Font.SourceSans
							MobileKeybinds.Text = ToggleButton.Name
							MobileKeybinds.Name = ToggleButton.Name
							MobileKeybinds.TextColor3 = Color3.fromRGB(0, 0, 0)
							MobileKeybinds.TextScaled = true
							MobileKeybinds.TextSize = 14.000
							MobileKeybinds.TextWrapped = true
							MobileKeybinds.TextScaled = true
							MakeDraggable(MobileKeybinds)

							local UICorner_3 = Instance.new("UICorner")
							UICorner_3.CornerRadius = UDim.new(0, 4)
							UICorner_3.Parent = MobileKeybinds

							local function MobileButtonsOnClicked()
								if ToggleButton.Enabled then
									TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(255, 0, 127)}):Play()
									TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = true}):Play()
									if not ToggleButton.Hide then
										AddArray(ToggleButton.Name)
									end
								else
									TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()--Transparency = 0.230
									TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = false}):Play()
									RemoveArray(ToggleButton.Name)
								end
							end

							MobileKeybinds.MouseButton1Click:Connect(function()
								ToggleButton.Enabled = not ToggleButton.Enabled
								MobileButtonsOnClicked()

								if ToggleButton.Callback then
									ToggleButton.Callback(ToggleButton.Enabled)
								end
							end)
							spawn(function()
								RunService.RenderStepped:Connect(function()
									if KeybindFrame then
										if shared.FunnyStarPanel.Uninjected then
											for i, v in pairs(KeybindFrame:GetChildren()) do
												if v:IsA("TextButton") and v.Name == ToggleButton.Name then
													v:Destroy()
												end
											end
											Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
										end
									end
								end)
							end)
						else
							for i,v in pairs(KeybindFrame:GetChildren()) do
								if v:IsA("TextButton") and v.Name == ToggleButton.Name then
									v:Destroy()
								end
							end
							Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
						end
					end)
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if Keybinds == nil then
					Keybinds = Instance.new("TextBox")
					Keybinds.Parent = ToggleMenu
					Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
					Keybinds.BackgroundTransparency = 1.000
					Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.BorderSizePixel = 0
					Keybinds.LayoutOrder = -1
					Keybinds.Size = UDim2.new(1, 0, 0, 25)
					Keybinds.Font = Enum.Font.SourceSans
					Keybinds.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
					Keybinds.PlaceholderText = "None"
					Keybinds.Text = ""
					Keybinds.TextColor3 = Color3.fromRGB(255, 255, 255)
					Keybinds.TextSize = 14.000
					UserInputService.InputBegan:Connect(function(Input, isTyping)
						if Input.UserInputType == Enum.UserInputType.Keyboard then
							if Keybinds:IsFocused() then
								ToggleButton.Keybind = Input.KeyCode.Name
								Keybinds.PlaceholderText = ""
								Keybinds.Text = Input.KeyCode.Name
								Keybinds:ReleaseFocus()
								ConfigSetting.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
							elseif ToggleButton.Keybind == "Backspace" then
								ToggleButton.Keybind = "Home"
								Keybinds.Text = ""
								Keybinds.PlaceholderText = "None"
								ConfigSetting.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
							end       
						end
						spawn(function()
							RunService.RenderStepped:Connect(function()
								if ToggleButton.Keybind ~= "Home" then
									if Keybinds then
										Keybinds.PlaceholderText = ""
										Keybinds.Text = ToggleButton.Keybind
									end
								end
								if shared.FunnyStarPanel.Uninjected then
									if Keybinds then
										Keybinds.Text = ""
										Keybinds.PlaceholderText = "None"
									end
								end
							end)
						end)
					end)
				end
			end

			local UIListLayout_2 = Instance.new("UIListLayout")
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if ToggleMenu ~= nil then
					UIListLayout_2.Parent = ScrollingMenu
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if ToggleMenu ~= nil then
					UIListLayout_2.Parent = ToggleMenu
				end
			end

			local function ToggleButtonClicked()
				if ToggleButton.Enabled then
					ConfigSetting.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(255, 0, 127)}):Play()
					TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = true}):Play()
					AddArray(ToggleButton.Name)
					--[[
					ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
					ToggleButtonHolder.Transparency = 0
					UIGradient.Enabled = true
					--]]
				else
					ConfigSetting.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play() -- Transparency = 0.230,
					TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = false}):Play()
					RemoveArray(ToggleButton.Name)
					--[[
					ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					ToggleButtonHolder.Transparency = 0.230
					UIGradient.Enabled = false
					--]]
				end
			end

			--[[
			spawn(function()
				while true do
					wait()
					if ToggleButton.AutoDisable then
						if ToggleButton.AutoDisable and ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
					if ToggleButton.AutoEnable then
						if ToggleButton.AutoEnable and not ToggleButton.Enabled then
							ToggleButton.Enabled = true
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
				end
			end)
			--]]

			spawn(function()
				RunService.RenderStepped:Connect(function()
					if ToggleButton.AutoDisable then
						if ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
					if ToggleButton.AutoEnable then
						if not ToggleButton.Enabled then
							ToggleButton.Enabled = true
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
					if shared.FunnyStarPanel.Uninjected then
						if ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
				end)
			end)

			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end

			ToggleButtonHolder.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)

			ToggleButtonHolder.MouseButton2Click:Connect(function()
				ToggleMenuOpened = not ToggleMenuOpened
				if ToggleMenuOpened then
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 90}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuNew}):Play()
					ToggleMenu.Visible = true
				else
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
					ToggleMenu.Visible = false
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 0}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuOld}):Play()
				end
			end)

			OpenMenu.MouseButton1Click:Connect(function()
				ToggleMenuOpened = not ToggleMenuOpened
				if ToggleMenuOpened then
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 90}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuNew}):Play()
					ToggleMenu.Visible = true
				else
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
					ToggleMenu.Visible = false
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 0}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuOld}):Play()
				end
			end)

			if ToggleButton.Keybind then
				UserInputService.InputBegan:Connect(function(Input, isTyping)
					if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] and not isTyping then
						ToggleButton.Enabled = not ToggleButton.Enabled
						ToggleButtonClicked()

						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end
				end)
			end

			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled or false,
					--AutoDisable = MiniToggle.AutoDisable or false,
					Callback = MiniToggle.Callback or function() end
				}
				if not ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name] then
					ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled,
					}
				else
					MiniToggle.Enabled = ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name].Enabled
				end

				local MiniToggleHolder = Instance.new("Frame")
				MiniToggleHolder.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
				MiniToggleHolder.BackgroundTransparency = 1.000
				MiniToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.BorderSizePixel = 0
				MiniToggleHolder.Size = UDim2.new(1, 0, 0, 25)
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						MiniToggleHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						MiniToggleHolder.Parent = ToggleMenu
					end
				end

				local MiniToggleHolderName = Instance.new("TextLabel")
				MiniToggleHolderName.Parent = MiniToggleHolder
				MiniToggleHolderName.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.BackgroundTransparency = 1.000
				MiniToggleHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderName.BorderSizePixel = 0
				MiniToggleHolderName.Position = UDim2.new(0, 5, 0, 0)
				MiniToggleHolderName.Size = UDim2.new(0, 175, 1, 0)
				MiniToggleHolderName.Font = Enum.Font.SourceSans
				MiniToggleHolderName.Text = MiniToggle.Name
				MiniToggleHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.TextSize = 16.000
				MiniToggleHolderName.TextWrapped = true
				MiniToggleHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local MiniToggleHolderTrigger = Instance.new("TextButton")
				MiniToggleHolderTrigger.Parent = MiniToggleHolder
				MiniToggleHolderTrigger.BackgroundColor3 = rainbow and Color or Color3.fromRGB(45, 45, 45)
				MiniToggleHolderTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderTrigger.BorderSizePixel = 0
				MiniToggleHolderTrigger.Position = UDim2.new(0, 165, 0, 5)
				MiniToggleHolderTrigger.Size = UDim2.new(0, 15, 0, 15)
				MiniToggleHolderTrigger.AutoButtonColor = false
				MiniToggleHolderTrigger.Font = Enum.Font.SourceSans
				MiniToggleHolderTrigger.Text = "x"
				MiniToggleHolderTrigger.TextTransparency = 1
				MiniToggleHolderTrigger.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderTrigger.TextSize = 18.000
				MiniToggleHolderTrigger.TextWrapped = true
				MiniToggleHolderTrigger.TextYAlignment = Enum.TextYAlignment.Bottom

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = MiniToggleHolderTrigger

				local function MiniToggleClick()
					if MiniToggle.Enabled then
						ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
					else
						ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
					end
				end

				--[[
				spawn(function()
					while true do
						task.wait()
						if MiniToggle.AutoDisable then
							if MiniToggle.Enabled then
								MiniToggle.Enabled = false
								MiniToggleClick()

								if MiniToggle.Callback then
									MiniToggle.Callback(MiniToggle.Enabled)
								end
							end
						end
					end
				end)
				--]]

				if MiniToggle.Enabled then
					MiniToggle.Enabled = true
					MiniToggleClick()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end 

				MiniToggleHolderTrigger.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					MiniToggleClick()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end)
				return MiniToggle
			end

			function ToggleButton:CreateSlider(Slider)
				Slider = {
					Name = Slider.Name,
					Min = Slider.Min or 0,
					Max = Slider.Max or 100,
					Default = Slider.Default,
					Callback = Slider.Callback or function() end
				}
				if not ConfigSetting.ToggleButton.Sliders[Slider.Name] then
					ConfigSetting.ToggleButton.Sliders[Slider.Name] = {
						Default = Slider.Default
					}
				else
					Slider.Default = ConfigSetting.ToggleButton.Sliders[Slider.Name].Default
				end

				local Value
				local Dragged = false
				local SliderHolder = Instance.new("Frame")
				SliderHolder.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
				SliderHolder.BackgroundTransparency = 1.000
				SliderHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolder.BorderSizePixel = 0
				SliderHolder.Size = UDim2.new(1, 0, 0, 28)
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						SliderHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						SliderHolder.Parent = ToggleMenu
					end
				end

				local SliderHolderName = Instance.new("TextLabel")
				SliderHolderName.Parent = SliderHolder
				SliderHolderName.BackgroundColor3 = rainbow and Color or  Color3.fromRGB(255, 255, 255)
				SliderHolderName.BackgroundTransparency = 1.000
				SliderHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderName.BorderSizePixel = 0
				SliderHolderName.Position = UDim2.new(0, 5, 0, 0)
				SliderHolderName.Size = UDim2.new(1, 0, 0, 15)
				SliderHolderName.Font = Enum.Font.SourceSans
				SliderHolderName.Text = Slider.Name
				SliderHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.TextScaled = true
				SliderHolderName.TextSize = 16.000
				SliderHolderName.TextWrapped = true
				SliderHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local SliderHolderValue = Instance.new("TextLabel")
				SliderHolderValue.Parent = SliderHolder
				SliderHolderValue.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
				SliderHolderValue.BackgroundTransparency = 1.000
				SliderHolderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderValue.BorderSizePixel = 0
				SliderHolderValue.Size = UDim2.new(0, 180, 0, 15)
				SliderHolderValue.Font = Enum.Font.SourceSans
				SliderHolderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderValue.TextScaled = true
				SliderHolderValue.TextSize = 16.000
				SliderHolderValue.TextWrapped = true
				SliderHolderValue.TextXAlignment = Enum.TextXAlignment.Right

				local SliderHolderBack = Instance.new("Frame")
				SliderHolderBack.Parent = SliderHolder
				SliderHolderBack.BackgroundColor3 = rainbow and Color or Color3.fromRGB(75, 75, 75)
				SliderHolderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderBack.BorderSizePixel = 0
				SliderHolderBack.Position = UDim2.new(0, 5, 0, 18)
				SliderHolderBack.Size = UDim2.new(0, 172, 0, 8)

				local SliderHolderFront = Instance.new("Frame")
				SliderHolderFront.Parent = SliderHolderBack
				SliderHolderFront.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
				SliderHolderFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderFront.BorderSizePixel = 0
				SliderHolderFront.Size = UDim2.new(0, 50, 1, 0)

				local SliderHolderGradient = Instance.new("UIGradient")
				SliderHolderGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
				SliderHolderGradient.Parent = SliderHolderFront

				local SliderHolderMain = Instance.new("TextButton")
				SliderHolderMain.Parent = SliderHolderFront
				SliderHolderMain.BackgroundColor3 = rainbow and Color or Color3.fromRGB(25, 25, 25)
				SliderHolderMain.BackgroundTransparency = 0.150
				SliderHolderMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.BorderSizePixel = 0
				SliderHolderMain.Position = UDim2.new(1, 0, 0, -2)
				SliderHolderMain.Size = UDim2.new(0, 8, 0, 12)
				SliderHolderMain.Font = Enum.Font.SourceSans
				SliderHolderMain.Text = ""
				SliderHolderMain.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.TextSize = 14.000

				local function SliderDragged(input)
					local InputPos = input.Position
					Value = math.clamp((InputPos.X - SliderHolderBack.AbsolutePosition.X) / SliderHolderBack.AbsoluteSize.X, 0, 1)
					local SliderValue = math.round(Value * (Slider.Max - Slider.Min)) + Slider.Min
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					SliderHolderValue.Text = SliderValue
					Slider.Callback(SliderValue)
					ConfigSetting.ToggleButton.Sliders[Slider.Name].Default = SliderValue
				end

				SliderHolderMain.MouseButton1Down:Connect(function()
					Dragged = true
				end)

				UserInputService.InputChanged:Connect(function(input)
					if Dragged and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						SliderDragged(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						Dragged = false
					end
				end)

				if Slider.Default then
					SliderHolderValue.Text = Slider.Default
					Value = (Slider.Default - Slider.Min) / (Slider.Max - Slider.Min)
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					Slider.Callback(Slider.Default)
				end
				return Slider
			end

			function ToggleButton:CreateDropdown(Dropdown)
				Dropdown = {
					Name = Dropdown.Name,
					List = Dropdown.List or {},
					Default = Dropdown.Default,
					Callback = Dropdown.Callback or function() end
				}
				if not ConfigSetting.ToggleButton.Dropdown[Dropdown.Name] then
					ConfigSetting.ToggleButton.Dropdown[Dropdown.Name] = {
						Default = Dropdown.Default
					}
				else
					Dropdown.Default = ConfigSetting.ToggleButton.Dropdown[Dropdown.Name].Default
				end

				local Selected
				local DropdownHolder = Instance.new("TextButton")
				DropdownHolder.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
				DropdownHolder.BackgroundTransparency = 1.000
				DropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownHolder.BorderSizePixel = 0
				DropdownHolder.Size = UDim2.new(1, 0, 0, 25)
				DropdownHolder.AutoButtonColor = false
				DropdownHolder.Font = Enum.Font.SourceSans
				DropdownHolder.Text = ""
				DropdownHolder.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownHolder.TextSize = 16.000
				DropdownHolder.TextWrapped = true
				DropdownHolder.TextXAlignment = Enum.TextXAlignment.Left
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						DropdownHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						DropdownHolder.Parent = ToggleMenu
					end
				end

				local DropdownSelected = Instance.new("TextLabel")
				DropdownSelected.Parent = DropdownHolder
				DropdownSelected.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
				DropdownSelected.BackgroundTransparency = 1.000
				DropdownSelected.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownSelected.BorderSizePixel = 0
				DropdownSelected.Size = UDim2.new(0, 180, 1, 0)
				DropdownSelected.Font = Enum.Font.SourceSans
				DropdownSelected.Text = Dropdown.Default or "None"
				DropdownSelected.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.TextSize = 16.000
				DropdownSelected.TextWrapped = true
				DropdownSelected.TextXAlignment = Enum.TextXAlignment.Right

				local DropdownMode = Instance.new("TextLabel")
				DropdownMode.Parent = DropdownHolder
				DropdownMode.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
				DropdownMode.BackgroundTransparency = 1.000
				DropdownMode.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownMode.BorderSizePixel = 0
				DropdownMode.Position = UDim2.new(0, 5, 0, 0)
				DropdownMode.Size = UDim2.new(0, 45, 1, 0)
				DropdownMode.Font = Enum.Font.SourceSans
				DropdownMode.Text = "Mode"
				DropdownMode.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMode.TextSize = 16.000
				DropdownMode.TextWrapped = true
				DropdownMode.TextXAlignment = Enum.TextXAlignment.Left

				local CurrentDropdown = 1
				DropdownHolder.MouseButton1Click:Connect(function()
					DropdownSelected.Text = Dropdown.List[CurrentDropdown]
					Dropdown.Callback(Dropdown.List[CurrentDropdown])
					Selected = Dropdown.List[CurrentDropdown]
					CurrentDropdown = CurrentDropdown % #Dropdown.List + 1
					ConfigSetting.ToggleButton.Dropdown[Dropdown.Name].Default = Selected
				end)

				if Dropdown.Default then
					Dropdown.Callback(Dropdown.Default)
				end

				return Dropdown
			end

			function ToggleButton:CreateTextIndicator(TextIndicator)
				TextIndicator = {
					Name = TextIndicator.Name,
					PlaceholderText = TextIndicator.PlaceholderText or "",
					DefaultText = TextIndicator.DefaultText or "",
					Callback = TextIndicator.Callback or function() end
				}

				local TextIndicatorText = Instance.new("TextBox")
				TextIndicatorText.Parent = ToggleMenu
				TextIndicatorText.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
				TextIndicatorText.BackgroundTransparency = 1.000
				TextIndicatorText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextIndicatorText.BorderSizePixel = 0
				TextIndicatorText.LayoutOrder = -1
				TextIndicatorText.Size = UDim2.new(1, 0, 0, 25)
				TextIndicatorText.Font = Enum.Font.SourceSans
				TextIndicatorText.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
				TextIndicatorText.PlaceholderText = TextIndicator.PlaceholderText
				TextIndicatorText.Text = TextIndicator.DefaultText
				TextIndicatorText.TextScaled = true
				TextIndicatorText.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextIndicatorText.TextXAlignment = Enum.TextXAlignment.Left

				TextIndicatorText:GetPropertyChangedSignal("Text"):Connect(function()
					TextIndicator.Callback(TextIndicatorText.Text)
				end)
			end

			return ToggleButton
		end

		function Tabs:CreateButton(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				ToolTipText = ToggleButton.ToolTipText,
				Keybind = ToggleButton.Keybind or "Home",
				Enabled = ToggleButton.Enabled or false,
				AutoEnable = ToggleButton.AutoEnable or false,
				AutoDisable = ToggleButton.AutoDisable or false,
				Hide = ToggleButton.Hide or false,
				Callback = ToggleButton.Callback or function() end
			}
			if not ConfigSetting.ToggleButton[ToggleButton.Name] then
				ConfigSetting.ToggleButton[ToggleButton.Name] = {
					Enabled = ToggleButton.Enabled,
					Keybind = ToggleButton.Keybind,
				}
			else
				ToggleButton.Enabled = ConfigSetting.ToggleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = ConfigSetting.ToggleButton[ToggleButton.Name].Keybind
			end

			local ToggleButtonHolder = Instance.new("TextButton")
			ToggleButtonHolder.Parent = TogglesList
			ToggleButtonHolder.BackgroundColor3 = rainbow and Color or Color3.fromRGB(30, 30, 30)
			ToggleButtonHolder.BackgroundTransparency = 0--.230
			ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.BorderSizePixel = 0
			ToggleButtonHolder.Size = UDim2.new(1, 0, 0, 25)
			ToggleButtonHolder.AutoButtonColor = false
			ToggleButtonHolder.Font = Enum.Font.SourceSans
			ToggleButtonHolder.Text = ""
			ToggleButtonHolder.ZIndex = 2
			ToggleButtonHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.TextSize = 14.000

			if ToggleButton.ToolTipText then
				addTooltip(ToggleButtonHolder, ToggleButton.ToolTipText)
			end

			local ToggleName = Instance.new("TextLabel")
			ToggleName.Parent = ToggleButtonHolder
			ToggleName.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleName.BorderSizePixel = 0
			ToggleName.Position = UDim2.new(0, 5, 0, 0)
			ToggleName.Size = UDim2.new(0, 145, 1, 0)
			ToggleName.Font = Enum.Font.SourceSans
			ToggleName.Text = ToggleButton.Name
			ToggleName.ZIndex = 2
			ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.TextSize = 16.000
			ToggleName.TextWrapped = true
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left

			local OpenMenu = Instance.new("TextButton")
			OpenMenu.Parent = ToggleButtonHolder
			OpenMenu.AnchorPoint = Vector2.new(0.5, 0.5)
			OpenMenu.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
			OpenMenu.BackgroundTransparency = 1.000
			OpenMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OpenMenu.BorderSizePixel = 0
			OpenMenu.Position = UDim2.new(0, 173, 0.5, 0)
			OpenMenu.Size = UDim2.new(0, 20, 0, 20)
			OpenMenu.Font = Enum.Font.SourceSans
			OpenMenu.ZIndex = 2
			OpenMenu.Text = ">"
			OpenMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.TextScaled = true
			OpenMenu.TextSize = 14.000
			OpenMenu.TextWrapped = true

			local UIGradient = Instance.new("UIGradient")
			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
			UIGradient.Parent = ToggleButtonHolder
			UIGradient.Enabled = false

			local ToggleMenuOpened = false
			local ToggleMenuOld = UDim2.new(1, 0, 0, 0)
			local ToggleMenuNew = UDim2.new(1, 0, 0, 125)
			local ToggleMenu, ScrollingMenu = nil, nil
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if ToggleMenu == nil then
					ToggleMenu = Instance.new("Frame")
					ToggleMenu.Parent = TogglesList
					ToggleMenu.BackgroundColor3 = rainbow and Color or Color3.fromRGB(30, 30, 30)
					ToggleMenu.BackgroundTransparency = 1
					ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ToggleMenu.BorderSizePixel = 0
					ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
					ToggleMenu.Size = UDim2.new(1, 0, 0, 125)
					ToggleMenu.Visible = false

					ScrollingMenu = Instance.new("ScrollingFrame")
					ScrollingMenu.Parent = ToggleMenu
					ScrollingMenu.Active = true
					ScrollingMenu.BackgroundColor3 = rainbow and Color or Color3.fromRGB(30, 30, 30)
					ScrollingMenu.BackgroundTransparency = 0.150
					ScrollingMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ScrollingMenu.BorderSizePixel = 0
					ScrollingMenu.Size = UDim2.new(1, 0, 0, 125)
					ScrollingMenu.ScrollBarThickness = 0
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if ToggleMenu == nil then
					ToggleMenu = Instance.new("Frame")
					ToggleMenu.Parent = TogglesList
					ToggleMenu.BackgroundColor3 = rainbow and Color or Color3.fromRGB(30, 30, 30)
					ToggleMenu.BackgroundTransparency = 0.150
					ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ToggleMenu.BorderSizePixel = 0
					ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
					ToggleMenu.Size = UDim2.new(1, 0, 0, 125)
					ToggleMenu.Visible = false
					ScrollingMenu = nil
				end
			end

			--Here
			local Keybinds = nil
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if Keybinds == nil then
					local MobileKeybinds, IsKeybind = nil, false
					Keybinds = Instance.new("TextButton")
					Keybinds.Parent = ScrollingMenu
					Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
					Keybinds.BackgroundTransparency = 1.000
					Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.BorderSizePixel = 0
					Keybinds.LayoutOrder = -1
					Keybinds.Size = UDim2.new(1, 0, 0, 25)
					Keybinds.Font = Enum.Font.SourceSans
					Keybinds.Text = "Show"
					Keybinds.TextColor3 = Color3.fromRGB(255, 255, 255)
					Keybinds.TextSize = 14.000
					Keybinds.MouseButton1Click:Connect(function()
						IsKeybind = not IsKeybind
						if IsKeybind then
							Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(60, 60, 60)
							local MobileKeybinds = Instance.new("TextButton")
							MobileKeybinds.Parent = KeybindFrame

							spawn(function()
								while true do
									task.wait()
									if ToggleButton.Enabled then
										MobileKeybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(0, 175, 0)
									else
										MobileKeybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(175, 0, 0)
									end
								end
							end)

							local MobileKeybindText = string.len(ToggleButton.Name)
							local MobileKeybindY = game:GetService("TextService"):GetTextSize(ToggleButton.Name, 14, Enum.Font.SourceSans, Vector2.new(200, math.huge))
							MobileKeybinds.BackgroundTransparency = 0.750
							MobileKeybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
							MobileKeybinds.BorderSizePixel = 0
							MobileKeybinds.Position = UDim2.new(0.192740932, 0, 0.301066756, 0)
							MobileKeybinds.Size = UDim2.new(0, 65, 0, MobileKeybindY.Y + 15)
							MobileKeybinds.Font = Enum.Font.SourceSans
							MobileKeybinds.Text = ToggleButton.Name
							MobileKeybinds.Name = ToggleButton.Name
							MobileKeybinds.TextColor3 = Color3.fromRGB(0, 0, 0)
							MobileKeybinds.TextScaled = true
							MobileKeybinds.TextSize = 14.000
							MobileKeybinds.TextWrapped = true
							MobileKeybinds.TextScaled = true
							MakeDraggable(MobileKeybinds)

							local UICorner_3 = Instance.new("UICorner")
							UICorner_3.CornerRadius = UDim.new(0, 4)
							UICorner_3.Parent = MobileKeybinds

							local function MobileButtonsOnClicked()
								if ToggleButton.Enabled then
									TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(255, 0, 127)}):Play()
									TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = true}):Play()
									if not ToggleButton.Hide then
										AddArray(ToggleButton.Name)
									end
								else
									TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play() -- Transparency = 0.230
									TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = false}):Play()
									RemoveArray(ToggleButton.Name)
								end
							end

							MobileKeybinds.MouseButton1Click:Connect(function()
								ToggleButton.Enabled = not ToggleButton.Enabled
								MobileButtonsOnClicked()

								if ToggleButton.Callback then
									ToggleButton.Callback()
								end
							end)
							spawn(function()
								RunService.RenderStepped:Connect(function()
									if KeybindFrame then
										if shared.FunnyStarPanel.Uninjected then
											for i, v in pairs(KeybindFrame:GetChildren()) do
												if v:IsA("TextButton") and v.Name == ToggleButton.Name then
													v:Destroy()
												end
											end
											Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
										end
									end
								end)
							end)
						else
							for i,v in pairs(KeybindFrame:GetChildren()) do
								if v:IsA("TextButton") and v.Name == ToggleButton.Name then
									v:Destroy()
								end
							end
							Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
						end
					end)
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if Keybinds == nil then
					Keybinds = Instance.new("TextBox")
					Keybinds.Parent = ToggleMenu
					Keybinds.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
					Keybinds.BackgroundTransparency = 1.000
					Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.BorderSizePixel = 0
					Keybinds.LayoutOrder = -1
					Keybinds.Size = UDim2.new(1, 0, 0, 25)
					Keybinds.Font = Enum.Font.SourceSans
					Keybinds.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
					Keybinds.PlaceholderText = "None"
					Keybinds.Text = ""
					Keybinds.TextColor3 = Color3.fromRGB(255, 255, 255)
					Keybinds.TextSize = 14.000
					UserInputService.InputBegan:Connect(function(Input, isTyping)
						if Input.UserInputType == Enum.UserInputType.Keyboard then
							if Keybinds:IsFocused() then
								ToggleButton.Keybind = Input.KeyCode.Name
								Keybinds.PlaceholderText = ""
								Keybinds.Text = Input.KeyCode.Name
								Keybinds:ReleaseFocus()
								ConfigSetting.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
							elseif ToggleButton.Keybind == "Backspace" then
								ToggleButton.Keybind = "Home"
								Keybinds.Text = ""
								Keybinds.PlaceholderText = "None"
								ConfigSetting.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
							end       
						end
						spawn(function()
							RunService.RenderStepped:Connect(function()
								if ToggleButton.Keybind ~= "Home" then
									if Keybinds then
										Keybinds.PlaceholderText = ""
										Keybinds.Text = ToggleButton.Keybind
									end
								end
								if shared.FunnyStarPanel.Uninjected then
									if Keybinds then
										Keybinds.Text = ""
										Keybinds.PlaceholderText = "None"
									end
								end
							end)
						end)
					end)
				end
			end

			local UIListLayout_2 = Instance.new("UIListLayout")
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if ToggleMenu ~= nil then
					UIListLayout_2.Parent = ScrollingMenu
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if ToggleMenu ~= nil then
					UIListLayout_2.Parent = ToggleMenu
				end
			end

			local function ToggleButtonClicked()
				ConfigSetting.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(255, 0, 127)}):Play()
				TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = true}):Play()
					--[[
					ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
					ToggleButtonHolder.Transparency = 0
					UIGradient.Enabled = true
					--]]
				task.wait(.1)
				ConfigSetting.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play() -- Transparency = 0.230,
				TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = false}):Play()
					--[[
					ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					ToggleButtonHolder.Transparency = 0.230
					UIGradient.Enabled = false
					--]]
			end

			--[[
			spawn(function()
				while true do
					wait()
					if ToggleButton.AutoDisable then
						if ToggleButton.AutoDisable and ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
					if ToggleButton.AutoEnable then
						if ToggleButton.AutoEnable and not ToggleButton.Enabled then
							ToggleButton.Enabled = true
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
				end
			end)
			--]]

			spawn(function()
				RunService.RenderStepped:Connect(function()
					if ToggleButton.AutoDisable then
						if ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback()
							end
						end
					end
					if ToggleButton.AutoEnable then
						if not ToggleButton.Enabled then
							ToggleButton.Enabled = true
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback()
							end
						end
					end
					if shared.FunnyStarPanel.Uninjected then
						if ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback()
							end
						end
					end
				end)
			end)

			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback()
				end
			end

			ToggleButtonHolder.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback()
				end
			end)

			ToggleButtonHolder.MouseButton2Click:Connect(function()
				ToggleMenuOpened = not ToggleMenuOpened
				if ToggleMenuOpened then
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 90}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuNew}):Play()
					ToggleMenu.Visible = true
				else
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
					ToggleMenu.Visible = false
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 0}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuOld}):Play()
				end
			end)

			OpenMenu.MouseButton1Click:Connect(function()
				ToggleMenuOpened = not ToggleMenuOpened
				if ToggleMenuOpened then
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 90}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuNew}):Play()
					ToggleMenu.Visible = true
				else
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
					ToggleMenu.Visible = false
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 0}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuOld}):Play()
				end
			end)

			if ToggleButton.Keybind then
				UserInputService.InputBegan:Connect(function(Input, isTyping)
					if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] and not isTyping then
						ToggleButton.Enabled = not ToggleButton.Enabled
						ToggleButtonClicked()

						if ToggleButton.Callback then
							ToggleButton.Callback()
						end
					end
				end)
			end

			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled or false,
					--AutoDisable = MiniToggle.AutoDisable or false,
					Callback = MiniToggle.Callback or function() end
				}
				if not ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name] then
					ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled,
					}
				else
					MiniToggle.Enabled = ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name].Enabled
				end

				local MiniToggleHolder = Instance.new("Frame")
				MiniToggleHolder.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
				MiniToggleHolder.BackgroundTransparency = 1.000
				MiniToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.BorderSizePixel = 0
				MiniToggleHolder.Size = UDim2.new(1, 0, 0, 25)
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						MiniToggleHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						MiniToggleHolder.Parent = ToggleMenu
					end
				end

				local MiniToggleHolderName = Instance.new("TextLabel")
				MiniToggleHolderName.Parent = MiniToggleHolder
				MiniToggleHolderName.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.BackgroundTransparency = 1.000
				MiniToggleHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderName.BorderSizePixel = 0
				MiniToggleHolderName.Position = UDim2.new(0, 5, 0, 0)
				MiniToggleHolderName.Size = UDim2.new(0, 175, 1, 0)
				MiniToggleHolderName.Font = Enum.Font.SourceSans
				MiniToggleHolderName.Text = MiniToggle.Name
				MiniToggleHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.TextSize = 16.000
				MiniToggleHolderName.TextWrapped = true
				MiniToggleHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local MiniToggleHolderTrigger = Instance.new("TextButton")
				MiniToggleHolderTrigger.Parent = MiniToggleHolder
				MiniToggleHolderTrigger.BackgroundColor3 = rainbow and Color or Color3.fromRGB(45, 45, 45)
				MiniToggleHolderTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderTrigger.BorderSizePixel = 0
				MiniToggleHolderTrigger.Position = UDim2.new(0, 165, 0, 5)
				MiniToggleHolderTrigger.Size = UDim2.new(0, 15, 0, 15)
				MiniToggleHolderTrigger.AutoButtonColor = false
				MiniToggleHolderTrigger.Font = Enum.Font.SourceSans
				MiniToggleHolderTrigger.Text = "x"
				MiniToggleHolderTrigger.TextTransparency = 1
				MiniToggleHolderTrigger.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderTrigger.TextSize = 18.000
				MiniToggleHolderTrigger.TextWrapped = true
				MiniToggleHolderTrigger.TextYAlignment = Enum.TextYAlignment.Bottom

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = MiniToggleHolderTrigger

				local function MiniToggleClick()
					if MiniToggle.Enabled then
						ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
					else
						ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
					end
				end

				--[[
				spawn(function()
					while true do
						task.wait()
						if MiniToggle.AutoDisable then
							if MiniToggle.Enabled then
								MiniToggle.Enabled = false
								MiniToggleClick()

								if MiniToggle.Callback then
									MiniToggle.Callback(MiniToggle.Enabled)
								end
							end
						end
					end
				end)
				--]]

				if MiniToggle.Enabled then
					MiniToggle.Enabled = true
					MiniToggleClick()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end 

				MiniToggleHolderTrigger.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					MiniToggleClick()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end)
				return MiniToggle
			end

			function ToggleButton:CreateSlider(Slider)
				Slider = {
					Name = Slider.Name,
					Min = Slider.Min or 0,
					Max = Slider.Max or 100,
					Default = Slider.Default,
					Callback = Slider.Callback or function() end
				}
				if not ConfigSetting.ToggleButton.Sliders[Slider.Name] then
					ConfigSetting.ToggleButton.Sliders[Slider.Name] = {
						Default = Slider.Default
					}
				else
					Slider.Default = ConfigSetting.ToggleButton.Sliders[Slider.Name].Default
				end

				local Value
				local Dragged = false
				local SliderHolder = Instance.new("Frame")
				SliderHolder.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
				SliderHolder.BackgroundTransparency = 1.000
				SliderHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolder.BorderSizePixel = 0
				SliderHolder.Size = UDim2.new(1, 0, 0, 28)
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						SliderHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						SliderHolder.Parent = ToggleMenu
					end
				end

				local SliderHolderName = Instance.new("TextLabel")
				SliderHolderName.Parent = SliderHolder
				SliderHolderName.BackgroundColor3 = rainbow and Color or  Color3.fromRGB(255, 255, 255)
				SliderHolderName.BackgroundTransparency = 1.000
				SliderHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderName.BorderSizePixel = 0
				SliderHolderName.Position = UDim2.new(0, 5, 0, 0)
				SliderHolderName.Size = UDim2.new(1, 0, 0, 15)
				SliderHolderName.Font = Enum.Font.SourceSans
				SliderHolderName.Text = Slider.Name
				SliderHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.TextScaled = true
				SliderHolderName.TextSize = 16.000
				SliderHolderName.TextWrapped = true
				SliderHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local SliderHolderValue = Instance.new("TextLabel")
				SliderHolderValue.Parent = SliderHolder
				SliderHolderValue.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
				SliderHolderValue.BackgroundTransparency = 1.000
				SliderHolderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderValue.BorderSizePixel = 0
				SliderHolderValue.Size = UDim2.new(0, 180, 0, 15)
				SliderHolderValue.Font = Enum.Font.SourceSans
				SliderHolderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderValue.TextScaled = true
				SliderHolderValue.TextSize = 16.000
				SliderHolderValue.TextWrapped = true
				SliderHolderValue.TextXAlignment = Enum.TextXAlignment.Right

				local SliderHolderBack = Instance.new("Frame")
				SliderHolderBack.Parent = SliderHolder
				SliderHolderBack.BackgroundColor3 = rainbow and Color or Color3.fromRGB(75, 75, 75)
				SliderHolderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderBack.BorderSizePixel = 0
				SliderHolderBack.Position = UDim2.new(0, 5, 0, 18)
				SliderHolderBack.Size = UDim2.new(0, 172, 0, 8)

				local SliderHolderFront = Instance.new("Frame")
				SliderHolderFront.Parent = SliderHolderBack
				SliderHolderFront.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
				SliderHolderFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderFront.BorderSizePixel = 0
				SliderHolderFront.Size = UDim2.new(0, 50, 1, 0)

				local SliderHolderGradient = Instance.new("UIGradient")
				SliderHolderGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
				SliderHolderGradient.Parent = SliderHolderFront

				local SliderHolderMain = Instance.new("TextButton")
				SliderHolderMain.Parent = SliderHolderFront
				SliderHolderMain.BackgroundColor3 = rainbow and Color or Color3.fromRGB(25, 25, 25)
				SliderHolderMain.BackgroundTransparency = 0.150
				SliderHolderMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.BorderSizePixel = 0
				SliderHolderMain.Position = UDim2.new(1, 0, 0, -2)
				SliderHolderMain.Size = UDim2.new(0, 8, 0, 12)
				SliderHolderMain.Font = Enum.Font.SourceSans
				SliderHolderMain.Text = ""
				SliderHolderMain.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.TextSize = 14.000

				local function SliderDragged(input)
					local InputPos = input.Position
					Value = math.clamp((InputPos.X - SliderHolderBack.AbsolutePosition.X) / SliderHolderBack.AbsoluteSize.X, 0, 1)
					local SliderValue = math.round(Value * (Slider.Max - Slider.Min)) + Slider.Min
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					SliderHolderValue.Text = SliderValue
					Slider.Callback(SliderValue)
					ConfigSetting.ToggleButton.Sliders[Slider.Name].Default = SliderValue
				end

				SliderHolderMain.MouseButton1Down:Connect(function()
					Dragged = true
				end)

				UserInputService.InputChanged:Connect(function(input)
					if Dragged and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						SliderDragged(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						Dragged = false
					end
				end)

				if Slider.Default then
					SliderHolderValue.Text = Slider.Default
					Value = (Slider.Default - Slider.Min) / (Slider.Max - Slider.Min)
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					Slider.Callback(Slider.Default)
				end
				return Slider
			end

			function ToggleButton:CreateDropdown(Dropdown)
				Dropdown = {
					Name = Dropdown.Name,
					List = Dropdown.List or {},
					Default = Dropdown.Default,
					Callback = Dropdown.Callback or function() end
				}
				if not ConfigSetting.ToggleButton.Dropdown[Dropdown.Name] then
					ConfigSetting.ToggleButton.Dropdown[Dropdown.Name] = {
						Default = Dropdown.Default
					}
				else
					Dropdown.Default = ConfigSetting.ToggleButton.Dropdown[Dropdown.Name].Default
				end

				local Selected
				local DropdownHolder = Instance.new("TextButton")
				DropdownHolder.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
				DropdownHolder.BackgroundTransparency = 1.000
				DropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownHolder.BorderSizePixel = 0
				DropdownHolder.Size = UDim2.new(1, 0, 0, 25)
				DropdownHolder.AutoButtonColor = false
				DropdownHolder.Font = Enum.Font.SourceSans
				DropdownHolder.Text = ""
				DropdownHolder.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownHolder.TextSize = 16.000
				DropdownHolder.TextWrapped = true
				DropdownHolder.TextXAlignment = Enum.TextXAlignment.Left
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						DropdownHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						DropdownHolder.Parent = ToggleMenu
					end
				end

				local DropdownSelected = Instance.new("TextLabel")
				DropdownSelected.Parent = DropdownHolder
				DropdownSelected.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
				DropdownSelected.BackgroundTransparency = 1.000
				DropdownSelected.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownSelected.BorderSizePixel = 0
				DropdownSelected.Size = UDim2.new(0, 180, 1, 0)
				DropdownSelected.Font = Enum.Font.SourceSans
				DropdownSelected.Text = Dropdown.Default or "None"
				DropdownSelected.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.TextSize = 16.000
				DropdownSelected.TextWrapped = true
				DropdownSelected.TextXAlignment = Enum.TextXAlignment.Right

				local DropdownMode = Instance.new("TextLabel")
				DropdownMode.Parent = DropdownHolder
				DropdownMode.BackgroundColor3 = rainbow and Color or Color3.fromRGB(255, 255, 255)
				DropdownMode.BackgroundTransparency = 1.000
				DropdownMode.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownMode.BorderSizePixel = 0
				DropdownMode.Position = UDim2.new(0, 5, 0, 0)
				DropdownMode.Size = UDim2.new(0, 45, 1, 0)
				DropdownMode.Font = Enum.Font.SourceSans
				DropdownMode.Text = "Mode"
				DropdownMode.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMode.TextSize = 16.000
				DropdownMode.TextWrapped = true
				DropdownMode.TextXAlignment = Enum.TextXAlignment.Left

				local CurrentDropdown = 1
				DropdownHolder.MouseButton1Click:Connect(function()
					DropdownSelected.Text = Dropdown.List[CurrentDropdown]
					Dropdown.Callback(Dropdown.List[CurrentDropdown])
					Selected = Dropdown.List[CurrentDropdown]
					CurrentDropdown = CurrentDropdown % #Dropdown.List + 1
					ConfigSetting.ToggleButton.Dropdown[Dropdown.Name].Default = Selected
				end)

				if Dropdown.Default then
					Dropdown.Callback(Dropdown.Default)
				end

				return Dropdown
			end

			function ToggleButton:CreateTextIndicator(TextIndicator)
				TextIndicator = {
					Name = TextIndicator.Name,
					PlaceholderText = TextIndicator.PlaceholderText or "",
					DefaultText = TextIndicator.DefaultText or "",
					Callback = TextIndicator.Callback or function() end
				}

				local TextIndicatorText = Instance.new("TextBox")
				TextIndicatorText.Parent = ToggleMenu
				TextIndicatorText.BackgroundColor3 = rainbow and Color or Color3.fromRGB(40, 40, 40)
				TextIndicatorText.BackgroundTransparency = 1.000
				TextIndicatorText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextIndicatorText.BorderSizePixel = 0
				TextIndicatorText.LayoutOrder = -1
				TextIndicatorText.Size = UDim2.new(1, 0, 0, 25)
				TextIndicatorText.Font = Enum.Font.SourceSans
				TextIndicatorText.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
				TextIndicatorText.PlaceholderText = TextIndicator.PlaceholderText
				TextIndicatorText.Text = TextIndicator.DefaultText
				TextIndicatorText.TextScaled = true
				TextIndicatorText.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextIndicatorText.TextXAlignment = Enum.TextXAlignment.Left

				TextIndicatorText:GetPropertyChangedSignal("Text"):Connect(function()
					TextIndicator.Callback(TextIndicatorText.Text)
				end)
			end

			return ToggleButton
		end

		return Tabs
	end

	coroutine.wrap(
		function()
			while wait() do
				if rainbow then
					for i = 0,1,0.001*speed do
						Color = Color3.fromHSV(i,1,1)

						for _, descendant in pairs(ScreenGui:GetDescendants()) do
							if descendant:IsA("GuiObject") then
								descendant.BackgroundColor3 = Color
							end
						end

						RunService.RenderStepped:Wait()
					end
				end
			end
		end
	)()

	return Main
end

repeat wait() until game:IsLoaded()
local Service = {
	UserInputService = game:GetService("UserInputService"),
	TextChatService = game:GetService("TextChatService"),
	TweenService = game:GetService("TweenService"),
	SoundService = game:GetService("SoundService"),
	RunService = game:GetService("RunService"),
	Lighting = game:GetService("Lighting"),
	Players = game:GetService("Players"),
	Workspace = game:GetService("Workspace"),
	GuiService = game:GetService("GuiService")
}

local LocalPlayer = Service.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
--local OldTorsoC0 = LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0.p
local OldC0 = nil

local Main = Library:CreateMain()
local Tabs = {
	Combat = Main:CreateTab("Combat", 138185990548352, Color3.fromRGB(255, 85, 127)),
	Exploit = Main:CreateTab("Exploit", 71954798465945, Color3.fromRGB(0, 255, 187)),
	Move = Main:CreateTab("Move", 91366694317593, Color3.fromRGB(82, 246, 255)),
	Player = Main:CreateTab("Player", 103157697311305, Color3.fromRGB(255, 255, 127)),
	Visual = Main:CreateTab("Visual", 118420030502964, Color3.fromRGB(170, 85, 255)),
	World = Main:CreateTab("World", 76313147188124, Color3.fromRGB(255, 170, 0))
}

local camera = workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
end)

function getNextMovement(speed)
	if speed == nil then speed = 7 end
	local nextMove = Vector3.new(0,0,0)
	if Service.UserInputService:IsKeyDown("W") then
		nextMove = nextMove + Vector3.new(0,0,-1)
	end
	if Service.UserInputService:IsKeyDown("S") then
		nextMove = nextMove + Vector3.new(0,0,1)
	end
	if Service.UserInputService:IsKeyDown("A") then
		nextMove = nextMove + Vector3.new(-1,0,0)
	end
	if Service.UserInputService:IsKeyDown("D") then
		nextMove = nextMove + Vector3.new(1,0,0)
	end

	if Service.UserInputService:IsKeyDown("Space") then
		nextMove = nextMove + Vector3.new(0,1,0)
	elseif Service.UserInputService:IsKeyDown("LeftControl") then
		nextMove = nextMove + Vector3.new(0,-1,0)
	end

	return CFrame.new(nextMove*speed)
end

function findPlayer(Username)
	for i, v in pairs(game.Players:GetPlayers()) do
		if v.Name == Username then
			return v
		end
	end
end

function IfModelIsACharacter(model)
	for i, v in pairs(game.Players:GetPlayers()) do
		if v.Character == model then
			return true
		end
	end

	return false
end

local function IsAlive(v)
	return v and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0
end

local function GetWall()
	local Result = nil
	local Raycast = RaycastParams.new()
	Raycast.FilterType = Enum.RaycastFilterType.Exclude
	Raycast.IgnoreWater = true
	Raycast.FilterDescendantsInstances = {Character}
	for i, v in pairs(Service.Players:GetPlayers()) do
		if IsAlive(v) then
			for i, z in pairs(v.Character:GetChildren()) do
				if z.ClassName ~= "Script" and z.ClassName ~= "LocalScript" and z.ClassName ~= "ModuleScript" then
					table.insert(Raycast.FilterDescendantsInstances, z)
				end
			end
		end
	end

	local Direction = Character:FindFirstChildOfClass("Humanoid").MoveDirection * 1.5
	if Direction and Raycast then
		Result = game.Workspace:Raycast(Character:FindFirstChild("HumanoidRootPart").Position, Direction, Raycast)
	end
	return Result and Result.Instance
end

local function CheckWall(v)
	local Raycast, Result = nil, nil

	local Direction = (v:FindFirstChild("HumanoidRootPart").Position - Character:FindFirstChild("HumanoidRootPart").Position).Unit
	local Distance = (v:FindFirstChild("HumanoidRootPart").Position - Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
	if Direction and Distance then
		Raycast = RaycastParams.new()
		Raycast.FilterDescendantsInstances = {Character}
		Raycast.FilterType = Enum.RaycastFilterType.Exclude
		Result = game.Workspace:Raycast(Character:FindFirstChild("HumanoidRootPart").Position, Direction * Distance, Raycast)
		if Result then
			if not v:IsAncestorOf(Result.Instance) then
				return false
			end
		end
	end
	return true
end

function getPrimaryPart(v: Model)
	if v:IsA("Model") then
		if v.PrimaryPart then
			return v.PrimaryPart
		end
	end
end

local function GetNearestEntity(MaxDist, EntityCheck, EntitySort, EntityTeam, EntityWall)
	local Entity, MinDist, Distances

	for _, entities in pairs(game.Workspace:GetChildren()) do
		if entities:IsA("Model") and entities.Name ~= LocalPlayer.Name then
			if IsAlive(entities) then
				if not EntityCheck then
					if not EntityWall or CheckWall(entities) then
						if entities:FindFirstChild("HumanoidRootPart") then
							Distances = (entities:FindFirstChild("HumanoidRootPart").Position - Character.HumanoidRootPart.Position).Magnitude
						end
					end
				else
					for _, player in pairs(Service.Players:GetPlayers()) do
						if player.Name == entities.Name then
							if not EntityTeam or player.Team ~= LocalPlayer.Team then
								if not EntityWall or CheckWall(entities) then
									Distances = (entities:FindFirstChild("HumanoidRootPart").Position - Character.HumanoidRootPart.Position).Magnitude
								end
							end
						end
					end
				end

				if Distances ~= nil then
					if EntitySort == "Distance" then
						if Distances <= MaxDist and (not MinDist or Distances < MinDist) then
							MinDist = Distances
							Entity = entities
						end
					elseif EntitySort == "Furthest" then
						if Distances <= MaxDist and (not MinDist or Distances > MinDist) then
							MinDist = Distances
							Entity = entities
						end
					elseif EntitySort == "Health" then
						if entities:FindFirstChild("Humanoid") and Distances <= MaxDist and (not MinDist or entities:FindFirstChild("Humanoid").Health < MinDist) then
							MinDist = entities:FindFirstChild("Humanoid").Health
							Entity = entities
						end
					elseif EntitySort == "Threat" then
						if entities:FindFirstChild("Humanoid") and Distances <= MaxDist and (not MinDist or entities:FindFirstChild("Humanoid").Health > MinDist) then
							MinDist = entities:FindFirstChild("Humanoid").Health
							Entity = entities
						end
					end	
				end
			end
		end
	end
	return Entity
end

local function GetITemC0()
	local ToolC0 = nil
	local Viewmodel = game.Workspace.CurrentCamera:GetChildren()[1]
	if OldC0 == nil then
		OldC0 = Viewmodel:FindFirstChildWhichIsA("Model"):WaitForChild("Handle"):FindFirstChild("MainPart").C0
	end

	if Viewmodel then
		for i, v in pairs(Viewmodel:GetChildren()) do
			if v:IsA("Model") then
				for i, z in pairs(v:GetChildren()) do
					if z:IsA("Part") and z.Name == "Handle" then
						for i, x in pairs(z:GetChildren()) do
							if x:IsA("Motor6D") and x.Name == "MainPart" then
								ToolC0 = x
							end
						end
					end
				end
			end
		end
	end
	return ToolC0
end

local function AnimateC0(anim)
	if LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
		local Tool = GetITemC0()
		if Tool then
			local Tween = Service.TweenService:Create(Tool, TweenInfo.new(anim.Time), {C0 = OldC0 * anim.CFrame})
			if Tween then
				Tween:Play()
				Tween.Completed:Wait()
			end
		end
	end
end

local function PlaySound(id)
	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxassetid://" .. id
	Sound.Parent = game:GetService("SoundService")
	Sound:Play()
	Sound.Ended:Connect(function()
		Sound:Destroy()
	end)
end

local function GetTool(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

local function CheckTool(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Character:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

spawn(function()
	local speed, oldplat, oldanchor, oldspeed, loop = nil, nil, nil, nil, nil
	local Flight = Tabs.Move:CreateToggle({
		Name = "Flight",
		ToolTipText = "Have the ability to fly.",
		Callback = function(callback)
			if callback then
				local player = Service.Players.LocalPlayer
				local cam = workspace.CurrentCamera
				local human = Character:FindFirstChildOfClass("Humanoid")
				local rootpart: BasePart = Character.PrimaryPart

				LocalPlayer.CharacterAdded:Connect(function(char)
					local camnew = workspace.CurrentCamera
					local humannew = char:FindFirstChildOfClass("Humanoid")
					local rootpartnew: BasePart = char.PrimaryPart

					oldplat = humannew.PlatformStand
					oldspeed = humannew.WalkSpeed
					oldanchor = rootpartnew.Anchored

					task.wait()

					humannew.PlatformStand = true
					humannew.WalkSpeed = 0
					rootpartnew.Anchored = true

					loop = Service.RunService.RenderStepped:Connect(function(dt)
						task.wait()
						local look = (camnew.Focus.Position - camnew.CFrame.Position).Unit
						local pos = rootpartnew.Position
						local nextMove = getNextMovement(speed)
						rootpartnew.CFrame = CFrame.new(pos,pos+look) * nextMove
					end)
				end)

				oldplat = human.PlatformStand
				oldspeed = human.WalkSpeed
				oldanchor = rootpart.Anchored

				task.wait()

				human.PlatformStand = true
				human.WalkSpeed = 0
				rootpart.Anchored = true

				loop = Service.RunService.RenderStepped:Connect(function(dt)
					task.wait()
					local look = (cam.Focus.Position - cam.CFrame.Position).Unit
					local pos = rootpart.Position
					local nextMove = getNextMovement(speed)
					rootpart.CFrame = CFrame.new(pos,pos+look) * nextMove
				end)
			else
				local player = Service.Players.LocalPlayer
				local cam = workspace.CurrentCamera
				local human = Character:FindFirstChildOfClass("Humanoid")
				local rootpart: BasePart =  Character.PrimaryPart

				human.PlatformStand = oldplat
				human.WalkSpeed = oldspeed
				rootpart.Anchored = oldanchor

				loop:Disconnect()
				task.wait()
				loop = nil
			end
		end
	})
	local FlightSpeed = Flight:CreateSlider({
		Name = "FlySpeed",
		Min = 0,
		Max = 24,
		Default = 7,
		Callback = function(callback)
			if callback then
				speed = callback
			end
		end
	})
end)

spawn(function()
	local loop, label, ui = nil, nil, nil
	local FPS = Tabs.Visual:CreateToggle({
		Name = "FPS",
		ToolTipText = "Shows your current fps.",
		Callback = function(callback)
			if callback then
				ui = Instance.new("ScreenGui", Service.Players.LocalPlayer.PlayerGui)
				ui.ResetOnSpawn = false
				label = Instance.new('TextLabel')
				label.Parent = ui
				label.TextScaled = true
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.BackgroundTransparency = 1
				label.Size = UDim2.new(0, 345,0, 30)
				label.Position = UDim2.new(0, 20,0, 47)
				label.TextColor3 = Color3.fromRGB(255,255,255)
				label.FontFace = Font.new([[rbxasset://fonts/families/Arimo.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
				print("e")
				label.Parent = ui
				local corner = Instance.new('UICorner')
				corner.CornerRadius = UDim.new(0, 4)
				corner.Parent = label

				if not loop then
					loop = Service.RunService.RenderStepped:Connect(function(dt)
						task.wait()
						label.Text = "FPS: "..tostring(workspace:GetRealPhysicsFPS())
					end)
				else
					loop:Disconnect()
					loop = nil
				end
			else
				if ui then
					ui.ResetOnSpawn = true
					ui:Remove()
					ui = nil
				end
				if loop then
					loop:Disconnect()
					loop = nil
				end
				task.wait()
				loop = nil
			end
		end
	})
end)

spawn(function()
	local ToolSpam = Tabs.Exploit:CreateButton({
		Name = "Reset",
		ToolTipText = "Resets your character.",
		Callback = function()
			if Character:FindFirstChildOfClass("Humanoid") then
				Character:FindFirstChildOfClass("Humanoid").Health = 0
			end
		end
	})
end)

spawn(function()
	local Loop, Tool = nil, nil
	local ToolSpam = Tabs.Combat:CreateToggle({
		Name = "Spam Tool",
		ToolTipText = "Spam activate on the current tool equipped.",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function(dt)
						if Tool and Tool:IsA("Tool") then
							Tool:Activate()
						else
							if Character:FindFirstChildOfClass("Tool") then
								Tool = Character:FindFirstChildOfClass('Tool')

								print("tool set to "..Tool.Name)
								Tool.Unequipped:Connect(function()
									if Tool then
										Tool = nil
										print("unequipped")
									end
								end)

								Tool:Activate()
							end
						end
					end)
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
			end
		end
	})
end)

spawn(function()
	local Loop
	local Noclip = Tabs.Move:CreateToggle({
		Name = "Noclip",
		ToolTipText = "Clip through the wall.",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function(dt)
						task.wait()

						for _, bodypart in pairs(Character:GetDescendants()) do
							if bodypart:IsA("MeshPart") or bodypart:IsA("BasePart") or bodypart:IsA("Part")  then
								bodypart.CanCollide = false
							end
						end
					end)
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
			end
		end
	})
end)

spawn(function()
	local volume
	local Volume = Tabs.Exploit:CreateToggle({
		Name = "Volume",
		ToolTipText = "Changes your volume/sound.",
		Callback = function(callback)
			if callback then
				UserSettings():GetService("UserGameSettings").MasterVolume = volume
			else

			end
		end
	})
	Volume:CreateSlider({
		Name = "Volume Value",
		Min = 0,
		Max = 100,
		Default = 35,
		Callback = function(callback)
			if callback then
				volume = callback
			end
		end
	})
end)

spawn(function()
	local AntiLag = Tabs.Visual:CreateButton({
		Name = "Fps Booster",
		ToolTipText = "Boosts your fps.",
		Callback = function(callback)
			if callback then
				local Terrain = workspace:FindFirstChildOfClass('Terrain')
				Terrain.WaterWaveSize = 0
				Terrain.WaterWaveSpeed = 0
				Terrain.WaterReflectance = 0
				Terrain.WaterTransparency = 1
				Service.Lighting.GlobalShadows = false
				Service.Lighting.FogEnd = 9e9
				Service.Lighting.FogStart = 9e9
				settings().Rendering.QualityLevel = 1
				for i,v in pairs(game:GetDescendants()) do
					if v:IsA("BasePart") then
						v.Material = "Plastic"
						v.Reflectance = 0
						v.BackSurface = "SmoothNoOutlines"
						v.BottomSurface = "SmoothNoOutlines"
						v.FrontSurface = "SmoothNoOutlines"
						v.LeftSurface = "SmoothNoOutlines"
						v.RightSurface = "SmoothNoOutlines"
						v.TopSurface = "SmoothNoOutlines"
					elseif v:IsA("Decal") then
						v.Transparency = 1
					elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
						v.Lifetime = NumberRange.new(0)
					end
				end
				for i,v in pairs(Service.Lighting:GetDescendants()) do
					if v:IsA("PostEffect") then
						v.Enabled = false
					end
				end
				workspace.DescendantAdded:Connect(function(child)
					task.spawn(function()
						if child:IsA('ForceField') or child:IsA('Sparkles') or child:IsA('Smoke') or child:IsA('Fire') or child:IsA('Beam') then
							Service.RunService.Heartbeat:Wait()
							child:Destroy()
						end
					end)
				end)
			else

			end
		end
	})
end)

--if not hookmetamethod then 
--	return notify('Incompatible Exploit','Your exploit does not support this command (missing hookmetamethod)')
--end
--local TeleportService = TeleportService
--local oldhmmi
--local oldhmmnc
--oldhmmi = hookmetamethod(game, "__index", function(self, method)
--	if self == TeleportService then
--		if method:lower() == "teleport" then
--			return error("Expected ':' not '.' calling member function Kick", 2)
--		elseif method == "TeleportToPlaceInstance" then
--			return error("Expected ':' not '.' calling member function TeleportToPlaceInstance", 2)
--		end
--	end
--	return oldhmmi(self, method)
--end)
--oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
--	if self == TeleportService and getnamecallmethod():lower() == "teleport" or getnamecallmethod() == "TeleportToPlaceInstance" then
--		return
--	end
--	return oldhmmnc(self, ...)
--end)

spawn(function()
	local enabled = nil
	local Disable_Gameplay_Paused = Tabs.Visual:CreateToggle({
		Name = "Disable Gameplay Paused",
		ToolTipText = "Disables the gameplay paused message.",
		Callback = function(callback)
			if callback then
				enabled = Service.GuiService:GetGameplayPausedNotificationEnabled()
				task.wait()
				Service.GuiService:SetGameplayPausedNotificationEnabled(false)
			else
				if enabled then
					Service.GuiService:SetGameplayPausedNotificationEnabled(enabled)
				else
					Service.GuiService:SetGameplayPausedNotificationEnabled(true)
				end
			end
		end
	})
end)

spawn(function()
	local flingedPlayerName, connection = nil, nil
	local Fling = Tabs.Move:CreateToggle({
		Name = "Fling",
		ToolTipText = "Flings a player.",
		Callback = function(callback)
			if callback then
				local playerToFling = nil

				Service.RunService.Heartbeat:Connect(function(dt)
					task.wait(.1)
					if flingedPlayerName ~= nil then
						if not playerToFling then
							if findPlayer(flingedPlayerName) then
								playerToFling = findPlayer(flingedPlayerName)
							end
						end
					end
				end)

				repeat task.wait() until playerToFling ~= nil
				local lp = Service.Players.LocalPlayer
				local c, hrp, vel, movel = lp.Character or lp.CharacterAdded:Wait(), nil, nil, 0.1

				local function getRoot(char)
					local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
					return rootPart
				end

				game.Players.CharacterAdded:Connect(function(charara)
					c = charara
				end)

				local chahrhacrisd2 = playerToFling.Character

				playerToFling.CharacterAdded:Connect(function(zoooo)
					chahrhacrisd2 = zoooo
				end)

				if not connection then
					connection = Service.RunService.RenderStepped:Connect(function(dt)
						Service.RunService.Heartbeat:Wait()

						if c.Humanoid.Health ~= 0 and getRoot(c) and getRoot(chahrhacrisd2) and c and chahrhacrisd2.Humanoid.Health ~= 0 and chahrhacrisd2 then
							getRoot(c).CFrame = getRoot(chahrhacrisd2).CFrame 
						end

						hrp = c and c:FindFirstChild("HumanoidRootPart")

						if hrp then
							vel = hrp.Velocity
							hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
							Service.RunService.RenderStepped:Wait()
							hrp.Velocity = vel
							Service.RunService.Stepped:Wait()
							hrp.Velocity = vel + Vector3.new(0, movel, 0)
							movel = -movel
						end
					end)
				else
					connection:Disconnect()
					connection = nil
				end
			else
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		end
	})
	Fling:CreateTextIndicator({
		Name = "FlingedPlayer",
		PlaceholderText = "The player's username that you wanna fling.",
		DefaultText = "",
		Callback = function(callback)
			flingedPlayerName = callback
		end,
	})
end)

spawn(function()
	local spinSpeed = 20
	local Spin = nil
	local Spin = Tabs.Move:CreateToggle({
		Name = "Spin",
		ToolTipText = "Spin in a circle for fun.",
		Callback = function(callback)
			if callback then
				for i,v in pairs(getPrimaryPart(Character):GetChildren()) do
					if v.Name == "Spinning" then
						v:Destroy()
					end
				end
				if Spin then
					Spin:Destroy()
					Spin = nil
				end
				Spin = Instance.new("BodyAngularVelocity")
				Spin.Name = "Spinning"
				Spin.Parent = getPrimaryPart(Character)
				Spin.MaxTorque = Vector3.new(0, math.huge, 0)
				Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)

				LocalPlayer.CharacterAdded:Connect(function(char)
					for i,v in pairs(getPrimaryPart(char):GetChildren()) do
						if v.Name == "Spinning" then
							v:Destroy()
						end
					end
					if Spin then
						Spin:Destroy()
						Spin = nil
					end

					Spin = Instance.new("BodyAngularVelocity")
					Spin.Name = "Spinning"
					Spin.Parent = getPrimaryPart(char)
					Spin.MaxTorque = Vector3.new(0, math.huge, 0)
					Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
				end)
			else
				if Spin then
					Spin:Destroy()
					Spin = nil
				end
			end
		end
	})
	Spin:CreateSlider({
		Name = "SpinSpeed",
		Min = 5,
		Max = 500,
		Default = 20,
		Callback = function(callback)
			if callback then
				spinSpeed = callback
			end
		end
	})
end)

spawn(function()
	local GravityValue = 196.2
	local Loop = nil
	local oldGrav = Service.Workspace.Gravity
	local Gravity = Tabs.World:CreateToggle({
		Name = "Gravity",
		ToolTipText = "Change the worlds gravity (only to you).",
		Callback = function(callback)
			if callback then
				oldGrav = Service.Workspace.Gravity

				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function(dt)
						Service.Workspace.Gravity = GravityValue
					end)
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end

				GravityValue = oldGrav
			end
		end
	})
	Gravity:CreateSlider({
		Name = "Gravity Value",
		Min = 0,
		Max = 500,
		Default = 196.2,
		Callback = function(callback)
			if callback then
				GravityValue = callback
			end
		end
	})
end)

spawn(function()
	local speed_WalkSpeed, loop , oldSpeed = 16, nil, nil
	local Speed = Tabs.Move:CreateToggle({
		Name = "Speed",
		ToolTipText = "Be able to zoom around.",
		Callback = function(callback)
			if callback then
				local humanoid = Character:FindFirstChildOfClass("Humanoid")

				LocalPlayer.CharacterAdded:Connect(function(char)
					local newhum = char:FindFirstChildOfClass("Humanoid")
					if loop then
						loop:Disconnect()
						loop = nil
					end

					loop = Service.RunService.Heartbeat:Connect(function(dt)
						task.wait()
						newhum.WalkSpeed = speed_WalkSpeed
					end)
				end)

				oldSpeed = humanoid.WalkSpeed

				if not loop then
					loop = Service.RunService.Heartbeat:Connect(function(dt)
						task.wait()
						humanoid.WalkSpeed = speed_WalkSpeed
					end)
				else
					loop:Disconnect()
					loop = nil
				end
			else
				local humanoid = Character:FindFirstChildOfClass("Humanoid")

				if loop then
					loop:Disconnect()
					loop = nil
				end
				task.wait()
				humanoid.WalkSpeed = oldSpeed
			end
		end
	})
	Speed:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 500,
		Default = 16,
		Callback = function(callback)
			if callback then
				speed_WalkSpeed = callback
			end
		end
	})
end)

spawn(function()
	local touchPos, loop , oldSpeed = 16, nil, nil
	local Speed = Tabs.Move:CreateToggle({
		Name = "Freecam",
		ToolTipText = "Look outside of your body.",
		Callback = function(callback)
			if callback then
				local cam = workspace.CurrentCamera
				local UIS = game:GetService("UserInputService")
				local RS = game:GetService("RunService")
				local onMobile = not UIS.KeyboardEnabled
				local keysDown = {}
				local rotating = false

				oldSpeed = Character:FindFirstChildOfClass("Humanoid").WalkSpeed

				if not game:IsLoaded() then game.Loaded:Wait() end

				cam.CameraType = Enum.CameraType.Scriptable

				local speed = 50
				local sens = .3

				Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 0

				speed /= 10
				if onMobile then sens*=2 end

				local function renderStepped()
					if rotating then
						local delta = UIS:GetMouseDelta()
						local cf = cam.CFrame
						local yAngle = cf:ToEulerAngles(Enum.RotationOrder.YZX)
						local newAmount = math.deg(yAngle)+delta.Y
						if newAmount > 65 or newAmount < -65 then
							if not (yAngle<0 and delta.Y<0) and not (yAngle>0 and delta.Y>0) then
								delta = Vector2.new(delta.X,0)
							end 
						end
						cf *= CFrame.Angles(-math.rad(delta.Y),0,0)
						cf = CFrame.Angles(0,-math.rad(delta.X),0) * (cf - cf.Position) + cf.Position
						cf = CFrame.lookAt(cf.Position, cf.Position + cf.LookVector)
						if delta ~= Vector2.new(0,0) then cam.CFrame = cam.CFrame:Lerp(cf,sens) end
						UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
					else
						UIS.MouseBehavior = Enum.MouseBehavior.Default
					end

					if keysDown["Enum.KeyCode.W"] then
						cam.CFrame *= CFrame.new(Vector3.new(0,0,-speed))
					end
					if keysDown["Enum.KeyCode.A"] then
						cam.CFrame *= CFrame.new(Vector3.new(-speed,0,0))
					end
					if keysDown["Enum.KeyCode.S"] then
						cam.CFrame *= CFrame.new(Vector3.new(0,0,speed))
					end
					if keysDown["Enum.KeyCode.D"] then
						cam.CFrame *= CFrame.new(Vector3.new(speed,0,0))
					end
				end

				loop = RS.RenderStepped:Connect(renderStepped)

				local validKeys = {"Enum.KeyCode.W","Enum.KeyCode.A","Enum.KeyCode.S","Enum.KeyCode.D"}

				UIS.InputBegan:Connect(function(Input)
					for i, key in pairs(validKeys) do
						if key == tostring(Input.KeyCode) then
							keysDown[key] = true
						end
					end
					if Input.UserInputType == Enum.UserInputType.MouseButton2 or (Input.UserInputType == Enum.UserInputType.Touch and UIS:GetMouseLocation().X>(cam.ViewportSize.X/2)) then
						rotating = true
					end
					if Input.UserInputType == Enum.UserInputType.Touch then
						if Input.Position.X < cam.ViewportSize.X/2 then
							touchPos = Input.Position
						end
					end
				end)

				UIS.InputEnded:Connect(function(Input)
					for key, v in pairs(keysDown) do
						if key == tostring(Input.KeyCode) then
							keysDown[key] = false
						end
					end
					if Input.UserInputType == Enum.UserInputType.MouseButton2 or (Input.UserInputType == Enum.UserInputType.Touch and UIS:GetMouseLocation().X>(cam.ViewportSize.X/2)) then
						rotating = false
					end
					if Input.UserInputType == Enum.UserInputType.Touch and touchPos then
						if Input.Position.X < cam.ViewportSize.X/2 then
							touchPos = nil
							keysDown["Enum.KeyCode.W"] = false
							keysDown["Enum.KeyCode.A"] = false
							keysDown["Enum.KeyCode.S"] = false
							keysDown["Enum.KeyCode.D"] = false
						end
					end
				end)

				UIS.TouchMoved:Connect(function(input)
					if touchPos then
						if input.Position.X < cam.ViewportSize.X/2 then
							if input.Position.Y < touchPos.Y then
								keysDown["Enum.KeyCode.W"] = true
								keysDown["Enum.KeyCode.S"] = false
							else
								keysDown["Enum.KeyCode.W"] = false
								keysDown["Enum.KeyCode.S"] = true
							end
							if input.Position.X < (touchPos.X-15) then
								keysDown["Enum.KeyCode.A"] = true
								keysDown["Enum.KeyCode.D"] = false
							elseif input.Position.X > (touchPos.X+15) then
								keysDown["Enum.KeyCode.A"] = false
								keysDown["Enum.KeyCode.D"] = true
							else
								keysDown["Enum.KeyCode.A"] = false
								keysDown["Enum.KeyCode.D"] = false
							end
						end
					end
				end)
			else
				camera.CameraType = Enum.CameraType.Custom
				local humanoid = Character:FindFirstChildOfClass("Humanoid")
				camera.CameraSubject = humanoid
				camera.CFrame = Character.PrimaryPart.CFrame

				if loop then
					loop:Disconnect()
					loop = nil
				end
				task.wait()
				humanoid.WalkSpeed = oldSpeed
			end
		end
	})
end)

spawn(function()
	local Brightness, ClockTime, FogEnd, GlobalShadows, OutdoorAmbient = nil, nil ,nil, nil, nil
	local FullBright = Tabs.Visual:CreateToggle({
		Name = "FullBright",
		ToolTipText = "Have the power to see anything in the darkness.",
		Callback = function(callback)
			if callback then
				local Lighting = Service.Lighting

				Brightness = Lighting.Brightness
				ClockTime = Lighting.ClockTime
				FogEnd = Lighting.FogEnd
				GlobalShadows = Lighting.GlobalShadows
				OutdoorAmbient = Lighting.OutdoorAmbient

				Lighting.Brightness = 2
				Lighting.ClockTime = 14
				Lighting.FogEnd = 100000
				Lighting.GlobalShadows = false
				Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
			else
				local Lighting = Service.Lighting

				Lighting.Brightness = Brightness
				Lighting.ClockTime = ClockTime
				Lighting.FogEnd = FogEnd
				Lighting.GlobalShadows = GlobalShadows
				Lighting.OutdoorAmbient = OutdoorAmbient
			end
		end
	})
end)

spawn(function()
	local OldTime, NewTime = Service.Lighting.ClockTime, nil
	local Loop = nil
	local TimeChanger = Tabs.World:CreateToggle({
		Name = "Time Changer",
		ToolTipText = "Change the time of the lighting.",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = Service.RunService.Heartbeat:Connect(function()
						task.wait()
						Service.Lighting.ClockTime = NewTime
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				Service.Lighting.ClockTime = OldTime
			end
		end
	})
	local TimeChangerClock = TimeChanger:CreateSlider({
		Name = "Time",
		Min = 0,
		Max = 24,
		Default = 3,
		Callback = function(callback)
			if callback then
				NewTime = callback
			end
		end
	})
end)

spawn(function()
	local ToolStealer = Tabs.Exploit:CreateToggle({
		Name = "Steal tools",
		ToolTipText = "Steal all dropped tools.",
		Callback = function(callback)
			if callback then
				for _, child in ipairs(workspace:GetDescendants()) do
					if child:IsA("BackpackItem") and callback then
						Character:FindFirstChildOfClass("Humanoid"):EquipTool(child)
					end
				end

				Service.Workspace.DescendantAdded:Connect(function(descendant)
					if descendant:IsA("BackpackItem") and callback then
						Character:FindFirstChildOfClass("Humanoid"):EquipTool(descendant)
					end
				end)	
			else

			end
		end
	})
end)

spawn(function()
	local NoTextures = Tabs.Visual:CreateToggle({
		Name = "Disable Textures",
		ToolTipText = "Disables all textures for better preformance.",
		Callback = function(callback)
			if callback then
				for _, Texture in pairs(workspace:GetDescendants()) do
					if Texture:IsA("Texture") or Texture:IsA("Decal") then
						Texture:SetAttribute("OldTextureadsjijudhu35utu34irewfdsfdgd", Texture.Texture)
						task.wait()
						Texture.Texture = "rbxassetid://0"
					end
				end
			else
				for _, Texture in pairs(workspace:GetDescendants()) do
					if Texture:IsA("Texture") or Texture:IsA("Decal") then
						task.wait()
						if Texture:GetAttribute("OldTextureadsjijudhu35utu34irewfdsfdgd") then
							Texture.Texture = Texture:GetAttribute("OldTextureadsjijudhu35utu34irewfdsfdgd")
						end
					end
				end
			end
		end
	})
end)


spawn(function()
	local PlayerEsp = Tabs.Visual:CreateToggle({
		Name = "Player Esp",
		ToolTipText = "Know the postion of players at all times.",
		Callback = function(callback)
			if callback then
				task.wait()

				game.Players.PlayerAdded:Connect(function(player)
					local character = Character
					local highlight = Instance.new("Highlight", character)
					highlight.Adornee = character
					highlight.Enabled = true
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.FillColor = Color3.fromRGB(55,255,0)
					highlight.FillTransparency = .5
					highlight.OutlineTransparency = .9
					highlight:SetAttribute("ABcfdsjoigirw4ty954y0ku4tv98urfusfhiowdwc3ewcfjbhujdokasfjgbuiorbt", true)
					highlight.OutlineColor = Color3.fromRGB(255,255,255)
				end)

				for _, player in pairs(Service.Players:GetPlayers()) do
					if player ~= LocalPlayer then
						local character = player.Character or player.CharacterAdded:Wait()
						local highlight = Instance.new("Highlight", character)
						highlight.Adornee = character
						highlight.Enabled = true
						highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						highlight.FillColor = Color3.fromRGB(55,255,0)
						highlight.FillTransparency = .5
						highlight.OutlineTransparency = .9
						highlight:SetAttribute("ABcfdsjoigirw4ty954y0ku4tv98urfusfhiowdwc3ewcfjbhujdokasfjgbuiorbt", true)
						highlight.OutlineColor = Color3.fromRGB(255,255,255)
					end
				end
			else
				for _, player in pairs(Service.Players:GetPlayers()) do
					if player ~= LocalPlayer then
						local character = player.Character or player.CharacterAdded:Wait()
						if character:FindFirstChildOfClass("Highlight") then
							if character:FindFirstChildOfClass("Highlight"):GetAttribute('ABcfdsjoigirw4ty954y0ku4tv98urfusfhiowdwc3ewcfjbhujdokasfjgbuiorbt') then
								character:FindFirstChildOfClass("Highlight"):Destroy()
							end
						end
					end
				end
			end
		end
	})
end)

spawn(function()
	local Tracers = {}
	local PlayerEsp = Tabs.Visual:CreateToggle({
		Name = "Npc Esp",
		ToolTipText = "Know the postion of Npcs at all times.",
		Callback = function(callback)
			if callback then
				task.wait()

				Service.Workspace.DescendantAdded:Connect(function(npc)
					if npc:IsA("Model") then
						if npc:FindFirstChildOfClass("Humanoid") then
							if not IfModelIsACharacter(npc) then
								local character = npc
								local highlight = Instance.new("Highlight", character)
								highlight.Adornee = character
								highlight.Enabled = true
								highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
								highlight.FillColor = Color3.fromRGB(0, 255, 255)
								highlight.FillTransparency = .5
								highlight.OutlineTransparency = .9
								highlight:SetAttribute("ABcfdsjoigirw4ty954y0ku4tv98urfusfhiowdwc3ewcfjbhujdokasfjgbuiorbt", true)
								highlight.OutlineColor = Color3.fromRGB(255,255,255)
							end
						end
					end
				end)

				for _, npc in pairs(Service.Workspace:GetDescendants()) do
					if npc:IsA("Model") then
						if npc:FindFirstChildOfClass("Humanoid") then
							if not IfModelIsACharacter(npc) then
								local character = npc
								local highlight = Instance.new("Highlight", character)
								highlight.Adornee = character
								highlight.Enabled = true
								highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
								highlight.FillColor = Color3.fromRGB(0, 255, 255)
								highlight.FillTransparency = .5
								highlight.OutlineTransparency = .9
								highlight:SetAttribute("ABcfdsjoigirw4ty954y0ku4tv98urfusfhiowdwc3ewcfjbhujdokasfjgbuiorbt", true)
								highlight.OutlineColor = Color3.fromRGB(255,255,255)
							end
						end
					end
				end
			else
				--for i,v in ipairs(Tracers) do
				--	if Tracers[i] then
				--		Tracers[i].Remove()
				--		Tracers[i] = nil
				--	end
				--end
				for _, npc in pairs(Service.Workspace:GetDescendants()) do
					if npc:IsA("Model") then
						if npc:FindFirstChildOfClass("Humanoid") then
							if not IfModelIsACharacter(npc) then
								local character = npc
								if character:FindFirstChildOfClass("Highlight") then
									if character:FindFirstChildOfClass("Highlight"):GetAttribute('ABcfdsjoigirw4ty954y0ku4tv98urfusfhiowdwc3ewcfjbhujdokasfjgbuiorbt') then
										character:FindFirstChildOfClass("Highlight"):Destroy()
									end
								end
							end
						end

					end
				end
			end
		end
	})
end)

spawn(function()
	local Loop = nil
	local PlayerEsp = Tabs.Move:CreateToggle({
		Name = "Infinite Jump",
		ToolTipText = "Jump as many times as you want.",
		Callback = function(callback)
			if callback then
				task.wait()
				local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				if Loop then
					Loop:Disconnect() 
					Loop = nil 
				end
				Loop = Service.UserInputService.JumpRequest:Connect(function()
					LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
				end)
			end
		end
	})
end)

spawn(function()
	local PlayerEsp = Tabs.Visual:CreateToggle({
		Name = "Item Esp",
		ToolTipText = "Know the postion of Items at all times.",
		Callback = function(callback)
			if callback then
				task.wait()

				Service.Workspace.DescendantAdded:Connect(function(Item)
					if Item:IsA("Tool") then
						local character = Item
						local highlight = Instance.new("Highlight", character)
						highlight.Adornee = character
						highlight.Enabled = true
						highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						highlight.FillColor = Color3.fromRGB(255,0,0)
						highlight.FillTransparency = .5
						highlight.OutlineTransparency = .9
						highlight:SetAttribute("ABcfdsjoigirw4ty954y0ku4tv98urfusfhiowdwc3ewcfjbhujdokasfjgbuiorbt", true)
						highlight.OutlineColor = Color3.fromRGB(255,255,255)
					end
				end)

				for _, Item in pairs(Service.Workspace:GetDescendants()) do
					if Item:IsA("Tool") then
						local character = Item
						local highlight = Instance.new("Highlight", character)
						highlight.Adornee = character
						highlight.Enabled = true
						highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						highlight.FillColor = Color3.fromRGB(255,0,0)
						highlight.FillTransparency = .5
						highlight.OutlineTransparency = .9
						highlight:SetAttribute("ABcfdsjoigirw4ty954y0ku4tv98urfusfhiowdwc3ewcfjbhujdokasfjgbuiorbt", true)
						highlight.OutlineColor = Color3.fromRGB(255,255,255)
					end
				end
			else
				for _, Item in pairs(Service.Workspace:GetDescendants()) do
					if Item:IsA("Tool") then
						local character = Item
						if character:FindFirstChildOfClass("Highlight") then
							if character:FindFirstChildOfClass("Highlight"):GetAttribute('ABcfdsjoigirw4ty954y0ku4tv98urfusfhiowdwc3ewcfjbhujdokasfjgbuiorbt') then
								character:FindFirstChildOfClass("Highlight"):Destroy()
							end
						end
					end
				end
			end
		end
	})
end)

--// Hey dylan how awesome is this section me when zombie control :money: \\--

if game.PlaceId == 89044126694575 then
	local WZombies = workspace:WaitForChild("WZombies")

	spawn(function()
		local Connection, Tool, Loop, Loop2, Target = nil, nil, nil, nil, nil
		local ZombieFarmer = Tabs.Exploit:CreateToggle({
			Name = "Zombie Farmer",
			ToolTipText = "Kill every zombie (have a item equipped).",
			Callback = function(callback)
				if callback then
					if Connection then Connection:Disconnect() Connection = nil end
					if Loop then Loop:Disconnect() Loop = nil end
					if Loop2 then Loop2:Disconnect() Loop2 = nil end

					if not Loop then
						Loop = Service.RunService.Heartbeat:Connect(function(dt)
							Service.RunService.RenderStepped:Wait()
							task.wait(.1)
							if Tool and Tool:IsA("Tool") then
								task.wait()
								Tool:Activate()
							else
								if Character:FindFirstChildOfClass("Tool") then
									Tool = Character:FindFirstChildOfClass('Tool')

									print("tool set to "..Tool.Name)
									Tool.Unequipped:Connect(function()
										if Tool then
											Tool = nil
											print("unequipped")
										end
									end)
									task.wait()
									Tool:Activate()
								end
							end

							if Target ~= nil then
								if Target:IsA("Model") then
									local Humanoid = Target:FindFirstChildOfClass("Humanoid")
									if Humanoid then
										if Character then
											if Humanoid.Health ~= 0 then
												Character:MoveTo(Target.PrimaryPart.Position)
											else
												Target = nil
											end
										else
											Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
										end
									end
								end
							end
						end)
					end

					for _, Zombie in pairs(WZombies:GetChildren()) do
						Target = Zombie
						repeat task.wait() until Target ~= Zombie
					end

					Connection = WZombies.DescendantAdded:Connect(function(Zombie)
						Target = Zombie
						repeat task.wait() until Target ~= Zombie
					end)

				else
					if Connection then
						Connection:Disconnect() 
						Connection = nil
					end

					if Loop then
						Loop:Disconnect()
						Loop = nil
					end

					if Loop2 then
						Loop2:Disconnect()
						Loop2 = nil
					end
				end
			end

		})
	end)

	spawn(function()
		local Connection = nil
		local TpZombies = Tabs.Exploit:CreateToggle({
			Name = "Zombie Tp",
			ToolTipText = "Tps every zombie to you.",
			Callback = function(callback)
				if callback then
					if Connection then Connection:Disconnect() Connection = nil end

					Connection = Service.RunService.RenderStepped:Connect(function(dt)
						local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

						for _, zombie in pairs(WZombies:GetChildren()) do
							if zombie:IsA("Model") then
								zombie:MoveTo(Character.PrimaryPart.Position)
							end
						end
					end)
				else
					if Connection then
						Connection:Disconnect() 
						Connection = nil
					end
				end
			end
		})
	end)

	spawn(function()
		local Connection = nil
		local BreakGame = Tabs.Exploit:CreateButton()({
			Name = "Game break",
			ToolTipText = "Break the game :money:.",
			Callback = function(callback)
				if Connection then Connection:Disconnect() Connection = nil end

				Connection = Service.RunService.Heartbeat:Connect(function(dt)
					task.wait(0.3)
					local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

					for _, zombie in pairs(WZombies:GetChildren()) do
						if zombie:IsA("Model") then
							zombie:Remove()
						end
					end
				end)
			end
		})
	end)
end
