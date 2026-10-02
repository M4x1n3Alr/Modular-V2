-- Modern Modular UI System (ModuleScript)
--------------------------------------------------------------------------------
-- HOW TO USE
--   1. Put this ModuleScript inside a LocalScript (as a child).
--   2. In that LocalScript:
--
--        local UI = require(script:WaitForChild("Modern Modular UI System"))
--
--        local Window = UI.new({
--            Title     = "Admin",          -- optional, defaults to "..."
--            Theme     = UI.Theme.Cyberpunk, -- optional, defaults to DarkSleek
--            ShowClock = true,             -- optional, defaults to true
--        })
--      (Theme also accepts the shortcut UI.Cyberpunk or the raw string "Cyberpunk")
--
--        local tab = Window:AddTab("Main")
--        tab:AddToggle("Fly", false, function(on) print(on) end)
--
--   3. Multi-window: call UI.new() as many times as you like. Each window keeps
--      its OWN theme/state and is auto-offset so overlapping windows cascade.
--      UI.getWindowCount() returns how many have been created.
--
--   4. Toggle the live clock any time with:  Window:SetClockVisible(false)
--
--   5. Notifications: pop a message in the bottom-right corner any time with
--        UI.notify("Title", "Body text", duration, playSound)
--
--   6. Top-right status bar: local time, FPS, ping, then the settings gear.
--      The gear opens a Settings panel with a theme selector and a keybind
--      dropdown to choose a key that shows/hides the window.
--------------------------------------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = game.CoreGui

--------------------------------------------------------------------------------
-- 1. THEME CONFIGURATIONS
--------------------------------------------------------------------------------
local Themes = {
    -- Your Original Themes
    --[[
    DarkSleek     │ Replaced flat, washed-out grays with a modern deep zinc/obsidian palette (20, 21, 26), clear card surface elevation (30, 32, 40), a vibrant
     		 │ modern blue accent (59, 130, 246), and refined modern toggle indicators.
	MinimalLight  │ Fixed the inverted hierarchy where cards were darker than the background. Now features elevated pure white component cards (255, 255, 255) on
     		 │ a clean light gray canvas (248, 249, 251) with sharp ink-black typography (24, 24, 27).
		Dracula       │ Balanced surface contrast so that MutedText (120, 135, 185) remains clearly legible inside components (52, 55, 70), while preserving
		 │ authentic Dracula palette tokens.
       SolarizedDark │ Aligned with official Solarized specs: moved component backgrounds to canonical base02 (7, 54, 66), used crisp Solarized Blue (38, 139, 210)
                     │ as the accent instead of murky yellow, and enhanced text contrast with base1 (147, 161, 161).
       OceanBreeze   │ Replaced muddy grayish-cyan tints with airy sea-mist (240, 248, 252), deep navy typography (15, 42, 74), and separated ToggleOn into a
                     │ distinct tropical seafoam teal (20, 184, 166) so it no longer conflicts with the blue accent.
       MatchaForest  │ Created an organic Japanese tea garden aesthetic: deep evergreen base (26, 33, 30), vibrant fresh matcha accent (158, 204, 82), soothing
                     │ washi cream text (240, 245, 235), tender sprout green for active toggles, and autumn terracotta for off states.
       HighContrast  │ Upgraded uncalibrated raw primaries (which caused harsh visual vibration) to calibrated high-contrast tones: pitch-black base (0, 0, 0),
      			│ brilliant amber-gold accent (255, 215, 0), pure white text, and WCAG AAA compliant muted text (180, 180, 180).
       PastelDream   │ Fixed low-contrast washed-out elements: raised the rose accent (238, 125, 160) so buttons and active states are clearly visible on white
                     │ cards, and switched text to a velvety plum-charcoal (75, 55, 70) for harmonious aesthetic readability.
       Cyberpunk     │ Left unchanged as requested.
       Synthwave     │ Left unchanged as requested.
	]]--
	DarkSleek = {
		Background = Color3.fromRGB(20, 21, 26),
		Sidebar = Color3.fromRGB(14, 15, 19),
		Accent = Color3.fromRGB(59, 130, 246),
		Text = Color3.fromRGB(245, 247, 250),
		MutedText = Color3.fromRGB(140, 148, 163),
		ComponentBg = Color3.fromRGB(30, 32, 40),
		ToggleOn = Color3.fromRGB(34, 197, 94),
		ToggleOff = Color3.fromRGB(239, 68, 68)
	},
	Cyberpunk = {
		Background = Color3.fromRGB(10, 10, 16),
		Sidebar = Color3.fromRGB(5, 5, 8),
		Accent = Color3.fromRGB(255, 0, 128),
		Text = Color3.fromRGB(0, 255, 240),
		MutedText = Color3.fromRGB(0, 180, 180),
		ComponentBg = Color3.fromRGB(20, 20, 30),
		ToggleOn = Color3.fromRGB(0, 255, 128),
		ToggleOff = Color3.fromRGB(255, 0, 50)
	},
	MinimalLight = {
		Background = Color3.fromRGB(248, 249, 251),
		Sidebar = Color3.fromRGB(240, 242, 246),
		Accent = Color3.fromRGB(24, 24, 27),
		Text = Color3.fromRGB(24, 24, 27),
		MutedText = Color3.fromRGB(113, 113, 122),
		ComponentBg = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(34, 197, 94),
		ToggleOff = Color3.fromRGB(239, 68, 68)
	},

	-- 7 New Themes
	Dracula = {
		Background = Color3.fromRGB(40, 42, 54),
		Sidebar = Color3.fromRGB(30, 31, 41),
		Accent = Color3.fromRGB(189, 147, 249),
		Text = Color3.fromRGB(248, 248, 242),
		MutedText = Color3.fromRGB(120, 135, 185),
		ComponentBg = Color3.fromRGB(52, 55, 70),
		ToggleOn = Color3.fromRGB(80, 250, 123),
		ToggleOff = Color3.fromRGB(255, 85, 85)
	},
	SolarizedDark = {
		Background = Color3.fromRGB(0, 43, 54),
		Sidebar = Color3.fromRGB(0, 33, 42),
		Accent = Color3.fromRGB(38, 139, 210),
		Text = Color3.fromRGB(147, 161, 161),
		MutedText = Color3.fromRGB(88, 110, 117),
		ComponentBg = Color3.fromRGB(7, 54, 66),
		ToggleOn = Color3.fromRGB(133, 153, 0),
		ToggleOff = Color3.fromRGB(220, 50, 47)
	},
	Synthwave = {
		Background = Color3.fromRGB(36, 23, 52),
		Sidebar = Color3.fromRGB(25, 16, 36),
		Accent = Color3.fromRGB(255, 108, 17),
		Text = Color3.fromRGB(255, 255, 255),
		MutedText = Color3.fromRGB(178, 140, 214),
		ComponentBg = Color3.fromRGB(45, 27, 78),
		ToggleOn = Color3.fromRGB(13, 245, 227),
		ToggleOff = Color3.fromRGB(247, 3, 141)
	},
	OceanBreeze = {
		Background = Color3.fromRGB(240, 248, 252),
		Sidebar = Color3.fromRGB(226, 240, 248),
		Accent = Color3.fromRGB(2, 132, 199),
		Text = Color3.fromRGB(15, 42, 74),
		MutedText = Color3.fromRGB(82, 120, 150),
		ComponentBg = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(20, 184, 166),
		ToggleOff = Color3.fromRGB(244, 98, 124)
	},
	MatchaForest = {
		Background = Color3.fromRGB(26, 33, 30),
		Sidebar = Color3.fromRGB(19, 24, 22),
		Accent = Color3.fromRGB(158, 204, 82),
		Text = Color3.fromRGB(240, 245, 235),
		MutedText = Color3.fromRGB(130, 158, 145),
		ComponentBg = Color3.fromRGB(37, 47, 43),
		ToggleOn = Color3.fromRGB(135, 195, 75),
		ToggleOff = Color3.fromRGB(214, 90, 80)
	},
	HighContrast = {
		Background = Color3.fromRGB(0, 0, 0),
		Sidebar = Color3.fromRGB(12, 12, 12),
		Accent = Color3.fromRGB(255, 215, 0),
		Text = Color3.fromRGB(255, 255, 255),
		MutedText = Color3.fromRGB(180, 180, 180),
		ComponentBg = Color3.fromRGB(24, 24, 24),
		ToggleOn = Color3.fromRGB(46, 230, 120),
		ToggleOff = Color3.fromRGB(255, 75, 75)
	},
	PastelDream = {
		Background = Color3.fromRGB(253, 246, 248),
		Sidebar = Color3.fromRGB(248, 236, 241),
		Accent = Color3.fromRGB(238, 125, 160),
		Text = Color3.fromRGB(75, 55, 70),
		MutedText = Color3.fromRGB(155, 135, 150),
		ComponentBg = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(160, 225, 145),
		ToggleOff = Color3.fromRGB(245, 145, 165)
	}
}


--------------------------------------------------------------------------------
-- 2. PER-WINDOW THEME TRACKING
-- Every window keeps its own theme + tracked elements, so re-theming one window
-- never touches another.  `w` is the window instance (the state table).
--------------------------------------------------------------------------------
local function registerElement(w, instance, themeProperty, themeKey)
	local entry = { instance = instance, prop = themeProperty, key = themeKey }
	table.insert(w.trackedElements, entry)

	local perInstance = w.elementLookup[instance]
	if not perInstance then
		perInstance = {}
		w.elementLookup[instance] = perInstance
	end
	perInstance[themeProperty] = entry

	instance[themeProperty] = w.currentTheme[themeKey]
end

local function updateRegisteredElement(w, instance, themeProperty, themeKey)
	local perInstance = w.elementLookup[instance]
	local entry = perInstance and perInstance[themeProperty]
	if entry then
		entry.key = themeKey
		instance[themeProperty] = w.currentTheme[themeKey]
		return
	end

	registerElement(w, instance, themeProperty, themeKey)
end

-- Stop theming an element that is about to be destroyed (dynamic list rows)
local function unregisterElement(w, instance)
	w.elementLookup[instance] = nil
	for index = #w.trackedElements, 1, -1 do
		if w.trackedElements[index].instance == instance then
			table.remove(w.trackedElements, index)
		end
	end
end

local function applyTheme(w, themeName)
	if not Themes[themeName] then return end
	w.currentTheme = Themes[themeName]
	for _, data in ipairs(w.trackedElements) do
		if data.instance and data.instance.Parent then
			data.instance[data.prop] = w.currentTheme[data.key]
		end
	end
end

--------------------------------------------------------------------------------
-- 2.5 NOTIFICATION SYSTEM (global, shared across every window)
-- Call UI.notify("Title", "Body text", duration, playSound):
--   title    -> bold heading (defaults to "Notification")
--   content  -> body text (wraps automatically)
--   duration -> seconds the popup stays before sliding away (defaults to 3)
--   sound    -> boolean; play a short pop sound when true
-- Popups appear stacked in the BOTTOM-RIGHT corner of the screen.
--------------------------------------------------------------------------------
local notifyTheme = Themes.DarkSleek        -- styling used by notifications
local notifyGui, notifyContainer            -- created lazily on first notify

local NOTIFY_SOUND_ID = "rbxassetid://12221967" -- soft UI "pop"

local function ensureNotifyContainer()
	if notifyGui and notifyGui.Parent then return end

	notifyGui = Instance.new("ScreenGui")
	notifyGui.Name = "ModularUI_Notifications"
	notifyGui.ResetOnSpawn = false
	notifyGui.IgnoreGuiInset = true
	notifyGui.DisplayOrder = 9999
	notifyGui.Parent = playerGui

	notifyContainer = Instance.new("Frame")
	notifyContainer.Name = "NotifyContainer"
	notifyContainer.AnchorPoint = Vector2.new(1, 1)
	notifyContainer.Position = UDim2.new(1, -20, 1, -20)
	notifyContainer.Size = UDim2.new(0, 300, 1, -40)
	notifyContainer.BackgroundTransparency = 1
	notifyContainer.Parent = notifyGui

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = notifyContainer
end

local function showNotification(title, content, duration, sound)
	ensureNotifyContainer()

	title = title or "Notification"
	content = content or ""
	duration = duration or 3

	local Card = Instance.new("Frame")
	Card.Name = "Notification"
	Card.Size = UDim2.new(1, 0, 0, 0)
	Card.AutomaticSize = Enum.AutomaticSize.Y
	Card.BackgroundColor3 = notifyTheme.ComponentBg
	Card.BackgroundTransparency = 1 -- starts invisible, fades in below
	Card.Parent = notifyContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = Card

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 10)
	pad.PaddingBottom = UDim.new(0, 10)
	pad.PaddingLeft = UDim.new(0, 14)
	pad.PaddingRight = UDim.new(0, 12)
	pad.Parent = Card

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 4)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = Card

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Size = UDim2.new(1, 0, 0, 18)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 15
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextColor3 = notifyTheme.Accent
	TitleLabel.TextTransparency = 1
	TitleLabel.LayoutOrder = 1
	TitleLabel.Parent = Card

	local Body = Instance.new("TextLabel")
	Body.Name = "Body"
	Body.Size = UDim2.new(1, 0, 0, 0)
	Body.AutomaticSize = Enum.AutomaticSize.Y
	Body.BackgroundTransparency = 1
	Body.Text = content
	Body.Font = Enum.Font.Gotham
	Body.TextSize = 13
	Body.TextWrapped = true
	Body.TextXAlignment = Enum.TextXAlignment.Left
	Body.TextColor3 = notifyTheme.Text
	Body.TextTransparency = 1
	Body.LayoutOrder = 2
	Body.Parent = Card

	if sound then
		local s = Instance.new("Sound")
		s.SoundId = NOTIFY_SOUND_ID
		s.Volume = 0.5
		s.Parent = notifyGui
		s:Play()
		task.delay(5, function()
			if s and s.Parent then s:Destroy() end
		end)
	end

	-- Fade in
	local inInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	TweenService:Create(Card, inInfo, {BackgroundTransparency = 0}):Play()
	TweenService:Create(TitleLabel, inInfo, {TextTransparency = 0}):Play()
	TweenService:Create(Body, inInfo, {TextTransparency = 0}):Play()

	-- Fade out after the duration, then destroy
	task.delay(duration, function()
		if not Card or not Card.Parent then return end
		local outInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		TweenService:Create(Card, outInfo, {BackgroundTransparency = 1}):Play()
		TweenService:Create(TitleLabel, outInfo, {TextTransparency = 1}):Play()
		local outTween = TweenService:Create(Body, outInfo, {TextTransparency = 1})
		outTween:Play()
		outTween.Completed:Connect(function()
			if Card then Card:Destroy() end
		end)
	end)
end

--------------------------------------------------------------------------------
-- 3. INTERNAL GENERATORS (all take the window `w` as first argument)
--------------------------------------------------------------------------------

-- Create a setting page
local function createPage(w, pageName)
	local Page = Instance.new("ScrollingFrame")
	Page.Name = pageName .. "Page"
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.ScrollBarThickness = 3
	Page.ScrollingDirection = Enum.ScrollingDirection.Y
	Page.CanvasSize = UDim2.new(0, 0, 0, 0)
	Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Page.Visible = false
	Page.Parent = w.contentContainer

	local PageLayout = Instance.new("UIListLayout")
	PageLayout.Padding = UDim.new(0, 8)
	PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	PageLayout.Parent = Page

	local PagePadding = Instance.new("UIPadding")
	PagePadding.PaddingTop = UDim.new(0, 10)
	PagePadding.PaddingBottom = UDim.new(0, 10)
	PagePadding.Parent = Page

	w.pages[pageName] = Page
	return Page
end

-- Light up the active tab button (accent glow) and dim the rest
local function highlightActiveTab(w, activeName)
	for name, entry in pairs(w.tabButtons) do
		local isActive = (name == activeName)
		TweenService:Create(entry.stroke, TweenInfo.new(0.15), {
			Transparency = isActive and 0 or 1,
		}):Play()
	end
end

-- Switch tab navigation: simple visibility toggle (no fade)
local function switchTab(w, pageName)
	local targetPage = w.pages[pageName]
	if not targetPage then return end

	-- Clicking any tab closes the settings panel so the tab's page is revealed
	if w.settingsPanel then
		w.settingsPanel.Visible = false
	end

	if targetPage == w.activePage then return end

	if w.activePage then
		w.activePage.Visible = false
	end

	w.activePage = targetPage
	targetPage.Visible = true
	highlightActiveTab(w, pageName)
end

-- Create modular navigational buttons on the left sidebar
local function createTabButton(w, name)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Name = name .. "Tab"
	TabBtn.Size = UDim2.new(0, 160, 0, 35)
	TabBtn.BorderSizePixel = 0
	TabBtn.Text = name
	TabBtn.Font = Enum.Font.GothamMedium
	TabBtn.TextSize = 14
	registerElement(w, TabBtn, "BackgroundColor3", "ComponentBg")
	registerElement(w, TabBtn, "TextColor3", "Text")
	TabBtn.Parent = w.sidebar

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 6)
	BtnCorner.Parent = TabBtn

	-- Accent "light" outline used to mark the active tab (hidden until active)
	local BtnStroke = Instance.new("UIStroke")
	BtnStroke.Thickness = 1.5
	BtnStroke.Transparency = 1
	BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	registerElement(w, BtnStroke, "Color", "Accent")
	BtnStroke.Parent = TabBtn

	w.tabButtons[name] = { button = TabBtn, stroke = BtnStroke }

	-- Hover & Click FX
	TabBtn.MouseEnter:Connect(function()
		TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
	end)
	TabBtn.MouseLeave:Connect(function()
		TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
	end)
	TabBtn.MouseButton1Click:Connect(function()
		switchTab(w, name)
	end)
end

-- Per-window component keybinds. A list is intentionally used instead of a
-- key-to-action dictionary because several components may share the same key.
local refreshKeybindEntry
local finishKeybindCapture
local activeKeybindCaptureWindow

local function releaseHeldKeybind(entry)
	if not entry.held then return end
	entry.held = false
	if entry.actions.holdEnded then
		entry.actions.holdEnded()
	end
end

local function notifyKeybindConflict(keyName)
	showNotification(
		"Keybind conflict",
		keyName .. " is already used to show/hide this window.",
		4,
		false
	)
end

local function setComponentKeybind(w, entry, keyName)
	keyName = keyName or "None"

	if keyName ~= "None" and keyName == w.toggleKeyName then
		notifyKeybindConflict(keyName)
		return false
	end

	if entry.keyName ~= keyName then
		releaseHeldKeybind(entry)
		entry.keyName = keyName
	end

	refreshKeybindEntry(w, entry)
	return true
end

local function beginKeybindCapture(w, entry)
	if activeKeybindCaptureWindow and activeKeybindCaptureWindow ~= w then
		finishKeybindCapture(activeKeybindCaptureWindow, nil)
	end
	if w.activeKeyCapture then
		finishKeybindCapture(w, nil)
	end

	if w.openKeybindModeMenu then
		w.openKeybindModeMenu.Visible = false
		w.openKeybindModeMenu = nil
	end

	w.activeKeyCapture = { entry = entry }
	activeKeybindCaptureWindow = w
	setComponentKeybind(w, entry, "None")
	refreshKeybindEntry(w, entry)
end

finishKeybindCapture = function(w, keyName)
	local capture = w.activeKeyCapture
	if not capture then return end

	w.activeKeyCapture = nil
	if keyName then
		setComponentKeybind(w, capture.entry, keyName)
	else
		setComponentKeybind(w, capture.entry, "None")
	end
	refreshKeybindEntry(w, capture.entry)

	-- Keep the global capture guard until every window's InputBegan listener
	-- has seen the current event, so assigning in one window cannot trigger a
	-- shortcut in another window during the same key press.
	task.defer(function()
		if activeKeybindCaptureWindow == w and not w.activeKeyCapture then
			activeKeybindCaptureWindow = nil
		end
	end)
end

local function setToggleKeybindMode(w, entry, mode)
	if mode ~= "Toggle" and mode ~= "Hold" then return end
	if entry.mode == mode then return end

	releaseHeldKeybind(entry)
	entry.mode = mode
	refreshKeybindEntry(w, entry)
end

-- Visually this is a textbox, while a transparent button on top gives exact
-- control over left/right clicks without Roblox inserting typed characters.
local function createKeybindBox(w, parent, entry, size, position, zIndex)
	local KeyBox = Instance.new("TextBox")
	KeyBox.Name = "KeybindInput"
	KeyBox.Size = size
	KeyBox.Position = position
	KeyBox.BorderSizePixel = 0
	KeyBox.ClearTextOnFocus = false
	KeyBox.TextEditable = false
	KeyBox.Text = "None"
	KeyBox.Font = Enum.Font.GothamMedium
	KeyBox.TextSize = 11
	KeyBox.TextTruncate = Enum.TextTruncate.AtEnd
	KeyBox.ZIndex = zIndex
	registerElement(w, KeyBox, "BackgroundColor3", "Sidebar")
	registerElement(w, KeyBox, "TextColor3", "Text")
	KeyBox.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = KeyBox

	local ClickTarget = Instance.new("TextButton")
	ClickTarget.Name = "ClickTarget"
	ClickTarget.Size = UDim2.new(1, 0, 1, 0)
	ClickTarget.BackgroundTransparency = 1
	ClickTarget.BorderSizePixel = 0
	ClickTarget.Text = ""
	ClickTarget.AutoButtonColor = false
	ClickTarget.ZIndex = zIndex + 1
	ClickTarget.Parent = KeyBox

	local boxData = { textBox = KeyBox }
	table.insert(entry.boxes, boxData)

	ClickTarget.MouseButton1Click:Connect(function()
		beginKeybindCapture(w, entry)
	end)

	if entry.kind == "Toggle" then
		local ModeMenu = Instance.new("Frame")
		ModeMenu.Name = "KeybindModeMenu"
		ModeMenu.Size = UDim2.new(0, 90, 0, 56)
		ModeMenu.Position = UDim2.new(1, -90, 1, 4)
		ModeMenu.BorderSizePixel = 0
		ModeMenu.Visible = false
		ModeMenu.ZIndex = zIndex + 10
		registerElement(w, ModeMenu, "BackgroundColor3", "ComponentBg")
		ModeMenu.Parent = KeyBox

		local menuCorner = Instance.new("UICorner")
		menuCorner.CornerRadius = UDim.new(0, 5)
		menuCorner.Parent = ModeMenu

		local menuLayout = Instance.new("UIListLayout")
		menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
		menuLayout.Parent = ModeMenu

		boxData.modeMenu = ModeMenu
		boxData.modeButtons = {}

		for order, mode in ipairs({ "Toggle", "Hold" }) do
			local ModeButton = Instance.new("TextButton")
			ModeButton.Name = mode
			ModeButton.Size = UDim2.new(1, 0, 0, 28)
			ModeButton.BorderSizePixel = 0
			ModeButton.Text = mode
			ModeButton.Font = Enum.Font.Gotham
			ModeButton.TextSize = 12
			ModeButton.LayoutOrder = order
			ModeButton.ZIndex = zIndex + 11
			registerElement(w, ModeButton, "BackgroundColor3", "Sidebar")
			registerElement(w, ModeButton, "TextColor3", "Text")
			ModeButton.Parent = ModeMenu
			boxData.modeButtons[mode] = ModeButton

			ModeButton.MouseButton1Click:Connect(function()
				setToggleKeybindMode(w, entry, mode)
				ModeMenu.Visible = false
				if w.openKeybindModeMenu == ModeMenu then
					w.openKeybindModeMenu = nil
				end
			end)
		end

		ClickTarget.MouseButton2Click:Connect(function()
			if w.activeKeyCapture then
				finishKeybindCapture(w, nil)
			end

			if w.openKeybindModeMenu and w.openKeybindModeMenu ~= ModeMenu then
				w.openKeybindModeMenu.Visible = false
			end

			ModeMenu.Visible = not ModeMenu.Visible
			w.openKeybindModeMenu = ModeMenu.Visible and ModeMenu or nil
		end)
	end

	refreshKeybindEntry(w, entry)
	return KeyBox
end

local function createKeybindSettingsRow(w, entry)
	local Row = Instance.new("Frame")
	Row.Name = "Keybind_" .. entry.id
	Row.Size = UDim2.new(1, 0, 0, 40)
	Row.LayoutOrder = entry.id
	Row.Visible = false
	Row.ZIndex = 16
	registerElement(w, Row, "BackgroundColor3", "ComponentBg")
	Row.Parent = w.keybindSettingsList
	entry.settingsRow = Row

	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0, 6)
	rowCorner.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -120, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = entry.title
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextTruncate = Enum.TextTruncate.AtEnd
	Label.ZIndex = 17
	registerElement(w, Label, "TextColor3", "Text")
	Label.Parent = Row

	createKeybindBox(
		w,
		Row,
		entry,
		UDim2.new(0, 90, 0, 28),
		UDim2.new(1, -102, 0.5, -14),
		17
	)
end

refreshKeybindEntry = function(w, entry)
	local isCapturing = w.activeKeyCapture and w.activeKeyCapture.entry == entry
	local displayText = isCapturing and "" or entry.keyName

	for _, boxData in ipairs(entry.boxes) do
		local KeyBox = boxData.textBox
		if KeyBox and KeyBox.Parent then
			KeyBox.Text = displayText
			updateRegisteredElement(
				w,
				KeyBox,
				"BackgroundColor3",
				isCapturing and "Accent" or "Sidebar"
			)
		end

		if boxData.modeButtons then
			for mode, ModeButton in pairs(boxData.modeButtons) do
				updateRegisteredElement(
					w,
					ModeButton,
					"BackgroundColor3",
					entry.mode == mode and "Accent" or "Sidebar"
				)
			end
		end
	end

	if entry.settingsRow then
		entry.settingsRow.Visible = entry.keyName ~= "None" or isCapturing
	end
end

local function registerComponentKeybind(w, title, kind, actions)
	w.nextKeybindId += 1
	local entry = {
		id = w.nextKeybindId,
		title = title,
		kind = kind,
		keyName = "None",
		mode = "Toggle",
		held = false,
		actions = actions,
		boxes = {},
	}

	table.insert(w.keybindEntries, entry)
	createKeybindSettingsRow(w, entry)
	return entry
end

-- Modular UI Component: A functional Toggle switch frame
local function createToggleSetting(w, parentPage, featureName, defaultState, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Name = featureName .. "Toggle"
	ToggleFrame.Size = UDim2.new(0, 440, 0, 45)
	registerElement(w, ToggleFrame, "BackgroundColor3", "ComponentBg")
	ToggleFrame.Parent = parentPage

	local TFCorner = Instance.new("UICorner")
	TFCorner.CornerRadius = UDim.new(0, 6)
	TFCorner.Parent = ToggleFrame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0, 200, 1, 0)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = featureName
	Title.Font = Enum.Font.Gotham
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	registerElement(w, Title, "TextColor3", "Text")
	Title.Parent = ToggleFrame

	-- Status Indicator Text (On/Off)
	local StatusIndicator = Instance.new("TextLabel")
	StatusIndicator.Size = UDim2.new(0, 60, 1, 0)
	StatusIndicator.Position = UDim2.new(1, -125, 0, 0)
	StatusIndicator.BackgroundTransparency = 1
	StatusIndicator.Font = Enum.Font.GothamBold
	StatusIndicator.TextSize = 12
	StatusIndicator.TextXAlignment = Enum.TextXAlignment.Right
	StatusIndicator.Parent = ToggleFrame

	-- Interactive Toggle Box Button
	local Hitbox = Instance.new("TextButton")
	Hitbox.Size = UDim2.new(0, 45, 0, 22)
	Hitbox.Position = UDim2.new(1, -55, 0.5, -11)
	Hitbox.Text = ""
	Hitbox.Parent = ToggleFrame

	local HitboxCorner = Instance.new("UICorner")
	HitboxCorner.CornerRadius = UDim.new(1, 0)
	HitboxCorner.Parent = Hitbox

	local Toggled = defaultState

	local function updateToggleVisuals()
		if Toggled then
			StatusIndicator.Text = "ENABLED"
			updateRegisteredElement(w, StatusIndicator, "TextColor3", "ToggleOn")
			updateRegisteredElement(w, Hitbox, "BackgroundColor3", "ToggleOn")
		else
			StatusIndicator.Text = "DISABLED"
			updateRegisteredElement(w, StatusIndicator, "TextColor3", "ToggleOff")
			updateRegisteredElement(w, Hitbox, "BackgroundColor3", "ToggleOff")
		end
	end

	local function setToggled(newState, forceCallback)
		if Toggled == newState then
			if forceCallback and callback then callback(newState) end
			return
		end
		Toggled = newState
		updateToggleVisuals()
		if callback then callback(Toggled) end
	end

	local function toggleState()
		setToggled(not Toggled)
	end

	Hitbox.MouseButton1Click:Connect(function()
		toggleState()
	end)

	local keybindEntry = registerComponentKeybind(w, featureName, "Toggle", {
		toggle = toggleState,
		holdBegan = function()
			setToggled(true, true)
		end,
		holdEnded = function()
			setToggled(false, true)
		end,
	})

	createKeybindBox(
		w,
		ToggleFrame,
		keybindEntry,
		UDim2.new(0, 52, 0, 28),
		UDim2.new(1, -187, 0.5, -14),
		2
	)

	updateToggleVisuals() -- Run initial state setup
end

-- Modular UI Component: A button that runs its callback every click
local function createActionButton(w, parentPage, buttonText, callback)
	local ButtonFrame = Instance.new("Frame")
	ButtonFrame.Name = buttonText .. "ButtonRow"
	ButtonFrame.Size = UDim2.new(0, 440, 0, 40)
	ButtonFrame.BackgroundTransparency = 1
	ButtonFrame.Parent = parentPage

	local ActionBtn = Instance.new("TextButton")
	ActionBtn.Name = buttonText .. "Button"
	ActionBtn.Size = UDim2.new(1, -60, 1, 0)
	ActionBtn.BorderSizePixel = 0
	ActionBtn.Text = buttonText
	ActionBtn.Font = Enum.Font.GothamMedium
	ActionBtn.TextSize = 14
	registerElement(w, ActionBtn, "BackgroundColor3", "ComponentBg")
	registerElement(w, ActionBtn, "TextColor3", "Text")
	ActionBtn.Parent = ButtonFrame

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 6)
	BtnCorner.Parent = ActionBtn

	local function runAction()
		if callback then callback() end
	end

	ActionBtn.MouseButton1Click:Connect(function()
		runAction()
	end)

	local keybindEntry = registerComponentKeybind(w, buttonText, "Button", {
		press = runAction,
	})

	createKeybindBox(
		w,
		ButtonFrame,
		keybindEntry,
		UDim2.new(0, 52, 0, 28),
		UDim2.new(1, -52, 0.5, -14),
		2
	)
end

-- Global slider drag manager: a SINGLE shared input connection drives every
-- slider across ALL windows (only one slider is ever dragged at a time), instead
-- of each slider adding its own global UIS listeners that fire on every mouse move.
local activeSliderDrag = nil

UserInputService.InputChanged:Connect(function(input)
	if activeSliderDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		activeSliderDrag(input.Position.X)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		activeSliderDrag = nil
	end
end)

-- Modular UI Component: A slider that adjusts a numeric value
local function createSliderSetting(w, parentPage, settingName, minValue, maxValue, defaultValue, callback)
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Name = settingName .. "Slider"
	SliderFrame.Size = UDim2.new(0, 440, 0, 55)
	registerElement(w, SliderFrame, "BackgroundColor3", "ComponentBg")
	SliderFrame.Parent = parentPage

	local SFCorner = Instance.new("UICorner")
	SFCorner.CornerRadius = UDim.new(0, 6)
	SFCorner.Parent = SliderFrame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -30, 0, 24)
	Title.Position = UDim2.new(0, 15, 0, 3)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.Gotham
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	registerElement(w, Title, "TextColor3", "Text")
	Title.Parent = SliderFrame

	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(1, -30, 0, 6)
	Bar.Position = UDim2.new(0, 15, 1, -18)
	Bar.BorderSizePixel = 0
	registerElement(w, Bar, "BackgroundColor3", "Sidebar")
	Bar.Parent = SliderFrame

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = Bar

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.new(0, 0, 1, 0)
	Fill.BorderSizePixel = 0
	registerElement(w, Fill, "BackgroundColor3", "Accent")
	Fill.Parent = Bar

	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = Fill

	local DragButton = Instance.new("TextButton")
	DragButton.Size = UDim2.new(1, 0, 1, 16)
	DragButton.Position = UDim2.new(0, 0, 0.5, -8)
	DragButton.BackgroundTransparency = 1
	DragButton.Text = ""
	DragButton.Parent = Bar

	local currentValue = math.clamp(defaultValue, minValue, maxValue)

	local function setValueFromPercent(percent)
		percent = math.clamp(percent, 0, 1)
		currentValue = math.floor(minValue + (maxValue - minValue) * percent)
		Title.Text = settingName .. ": " .. currentValue
		Fill.Size = UDim2.new(percent, 0, 1, 0)
		if callback then callback(currentValue) end
	end

	local function setValueFromX(mouseX)
		local percent = (mouseX - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X
		setValueFromPercent(percent)
	end

	DragButton.MouseButton1Down:Connect(function()
		activeSliderDrag = setValueFromX
		setValueFromX(UserInputService:GetMouseLocation().X)
	end)

	setValueFromPercent((currentValue - minValue) / (maxValue - minValue))
end

-- Modular UI Component: A textbox that fires when focus is lost
local function createTextboxSetting(w, parentPage, settingName, placeholderText, callback)
	local TextboxFrame = Instance.new("Frame")
	TextboxFrame.Name = settingName .. "Textbox"
	TextboxFrame.Size = UDim2.new(0, 440, 0, 50)
	registerElement(w, TextboxFrame, "BackgroundColor3", "ComponentBg")
	TextboxFrame.Parent = parentPage

	local TFCorner = Instance.new("UICorner")
	TFCorner.CornerRadius = UDim.new(0, 6)
	TFCorner.Parent = TextboxFrame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0, 150, 1, 0)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = settingName
	Title.Font = Enum.Font.Gotham
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	registerElement(w, Title, "TextColor3", "Text")
	Title.Parent = TextboxFrame

	local Input = Instance.new("TextBox")
	Input.Size = UDim2.new(0, 240, 0, 30)
	Input.Position = UDim2.new(1, -255, 0.5, -15)
	Input.BorderSizePixel = 0
	Input.PlaceholderText = placeholderText or "Type here..."
	Input.Text = ""
	Input.Font = Enum.Font.Gotham
	Input.TextSize = 14
	registerElement(w, Input, "BackgroundColor3", "Sidebar")
	registerElement(w, Input, "TextColor3", "Text")
	registerElement(w, Input, "PlaceholderColor3", "MutedText")
	Input.Parent = TextboxFrame

	local InputCorner = Instance.new("UICorner")
	InputCorner.CornerRadius = UDim.new(0, 6)
	InputCorner.Parent = Input

	Input.FocusLost:Connect(function()
		if callback then callback(Input.Text) end
	end)
end

-- Modular UI Component: Pick one item from a list, then run an action with it
local function createItemSelector(w, parentPage, settingName, items, callback)
	local SelectorFrame = Instance.new("Frame")
	SelectorFrame.Name = settingName .. "Selector"
	SelectorFrame.Size = UDim2.new(0, 440, 0, 50)
	registerElement(w, SelectorFrame, "BackgroundColor3", "ComponentBg")
	SelectorFrame.Parent = parentPage

	local SFCorner = Instance.new("UICorner")
	SFCorner.CornerRadius = UDim.new(0, 6)
	SFCorner.Parent = SelectorFrame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0, 140, 1, 0)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = settingName
	Title.Font = Enum.Font.Gotham
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	registerElement(w, Title, "TextColor3", "Text")
	Title.Parent = SelectorFrame

	local selectedIndex = 1
	local selectedItem = items[selectedIndex]

	local SelectBtn = Instance.new("TextButton")
	SelectBtn.Size = UDim2.new(0, 120, 0, 30)
	SelectBtn.Position = UDim2.new(1, -285, 0.5, -15)
	SelectBtn.BorderSizePixel = 0
	SelectBtn.Text = tostring(selectedItem)
	SelectBtn.Font = Enum.Font.Gotham
	SelectBtn.TextSize = 13
	registerElement(w, SelectBtn, "BackgroundColor3", "Sidebar")
	registerElement(w, SelectBtn, "TextColor3", "Text")
	SelectBtn.Parent = SelectorFrame

	local SelectCorner = Instance.new("UICorner")
	SelectCorner.CornerRadius = UDim.new(0, 6)
	SelectCorner.Parent = SelectBtn

	local Dropdown = Instance.new("ScrollingFrame")
	Dropdown.Size = UDim2.new(0, 120, 0, math.max(#items - 1, 1) * 28)
	Dropdown.Position = UDim2.new(1, -285, 1, 2)
	Dropdown.BorderSizePixel = 0
	Dropdown.Visible = false
	Dropdown.ZIndex = 10
	Dropdown.ScrollBarThickness = 2
	Dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
	Dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
	registerElement(w, Dropdown, "BackgroundColor3", "Sidebar")
	Dropdown.Parent = SelectorFrame

	local DropdownCorner = Instance.new("UICorner")
	DropdownCorner.CornerRadius = UDim.new(0, 6)
	DropdownCorner.Parent = Dropdown

	local DropdownLayout = Instance.new("UIListLayout")
	DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
	DropdownLayout.Parent = Dropdown

	local itemButtons = {}

	local function refreshDropdownList()
		for index, item in ipairs(items) do
			local ItemBtn = itemButtons[index]
			if ItemBtn then
				ItemBtn.Visible = index ~= selectedIndex
				ItemBtn.LayoutOrder = index
				ItemBtn.Text = tostring(item)
			end
		end
	end

	for index, item in ipairs(items) do
		local ItemBtn = Instance.new("TextButton")
		ItemBtn.Size = UDim2.new(1, 0, 0, 28)
		ItemBtn.BorderSizePixel = 0
		ItemBtn.Text = tostring(item)
		ItemBtn.Font = Enum.Font.Gotham
		ItemBtn.TextSize = 13
		ItemBtn.ZIndex = 11
		ItemBtn.LayoutOrder = index
		registerElement(w, ItemBtn, "BackgroundColor3", "Sidebar")
		registerElement(w, ItemBtn, "TextColor3", "Text")
		ItemBtn.Parent = Dropdown
		itemButtons[index] = ItemBtn

		ItemBtn.MouseButton1Click:Connect(function()
			selectedIndex = index
			selectedItem = item
			SelectBtn.Text = tostring(selectedItem)
			Dropdown.Visible = false
			refreshDropdownList()
			print(settingName .. " selected: " .. tostring(selectedItem))
		end)
	end

	refreshDropdownList()

	local RunBtn = Instance.new("TextButton")
	RunBtn.Size = UDim2.new(0, 88, 0, 30)
	RunBtn.Position = UDim2.new(1, -98, 0.5, -15)
	RunBtn.BorderSizePixel = 0
	RunBtn.Text = "Run"
	RunBtn.Font = Enum.Font.GothamBold
	RunBtn.TextSize = 13
	registerElement(w, RunBtn, "BackgroundColor3", "Accent")
	registerElement(w, RunBtn, "TextColor3", "Text")
	RunBtn.Parent = SelectorFrame

	local RunCorner = Instance.new("UICorner")
	RunCorner.CornerRadius = UDim.new(0, 6)
	RunCorner.Parent = RunBtn

	SelectBtn.MouseButton1Click:Connect(function()
		Dropdown.Visible = not Dropdown.Visible
	end)

	local function runSelectedItem()
		if callback then callback(selectedItem) end
	end

	RunBtn.MouseButton1Click:Connect(function()
		runSelectedItem()
	end)

	local keybindEntry = registerComponentKeybind(w, settingName, "Selector", {
		press = runSelectedItem,
	})

	createKeybindBox(
		w,
		SelectorFrame,
		keybindEntry,
		UDim2.new(0, 52, 0, 28),
		UDim2.new(1, -158, 0.5, -14),
		2
	)
end

-- Modular UI Component: Select any number of items and keep an output table updated.
-- The caller's items table is re-scanned on every interaction (open, select,
-- unselect, select all) and on handle:Refresh(), so entries added later appear
-- unselected and removed entries disappear from the UI and from outputList.
-- In instanceMode the items are Instances: rows show instance.Name, are keyed by
-- the instance itself, and destroyed instances (Parent == nil) are removed.
local function createSelectionList(w, parentPage, settingName, items, outputList, defaultSelected, callback, instanceMode)
	items = items or {}
	outputList = outputList or {}

	local rowHeight = 30
	local rowPadding = 4
	local collapsedHeight = 50
	local expandedHeight = collapsedHeight

	local SelectionFrame = Instance.new("Frame")
	SelectionFrame.Name = settingName .. "SelectionList"
	SelectionFrame.Size = UDim2.new(0, 440, 0, collapsedHeight)
	SelectionFrame.ClipsDescendants = true
	registerElement(w, SelectionFrame, "BackgroundColor3", "ComponentBg")
	SelectionFrame.Parent = parentPage

	local SFCorner = Instance.new("UICorner")
	SFCorner.CornerRadius = UDim.new(0, 6)
	SFCorner.Parent = SelectionFrame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0, 175, 0, 50)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = settingName
	Title.Font = Enum.Font.Gotham
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	registerElement(w, Title, "TextColor3", "Text")
	Title.Parent = SelectionFrame

	local SelectBtn = Instance.new("TextButton")
	SelectBtn.Size = UDim2.new(0, 230, 0, 30)
	SelectBtn.Position = UDim2.new(1, -245, 0, 10)
	SelectBtn.BorderSizePixel = 0
	SelectBtn.Font = Enum.Font.Gotham
	SelectBtn.TextSize = 13
	registerElement(w, SelectBtn, "BackgroundColor3", "Sidebar")
	registerElement(w, SelectBtn, "TextColor3", "Text")
	SelectBtn.Parent = SelectionFrame

	local SelectCorner = Instance.new("UICorner")
	SelectCorner.CornerRadius = UDim.new(0, 6)
	SelectCorner.Parent = SelectBtn

	-- The expanded list participates in the page layout instead of overlaying it.
	-- The tab's ScrollingFrame handles overflow when this full list is open.
	local ItemList = Instance.new("Frame")
	ItemList.Size = UDim2.new(1, -20, 0, rowHeight)
	ItemList.Position = UDim2.new(0, 10, 0, collapsedHeight)
	ItemList.BackgroundTransparency = 1
	ItemList.Visible = false
	ItemList.Parent = SelectionFrame

	local ItemLayout = Instance.new("UIListLayout")
	ItemLayout.Padding = UDim.new(0, rowPadding)
	ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ItemLayout.Parent = ItemList

	local rows = {} -- ordered { key, item, button, selected } records
	local rowByKey = {} -- index (plain lists) or the Instance itself (instanceMode)
	local selectedCount = 0
	local isOpen = false
	local initialized = false

	local function updateSelectButtonText()
		local arrow = isOpen and "^" or "v"
		SelectBtn.Text = string.format("%d/%d selected  %s", selectedCount, #rows, arrow)
	end

	local function setOpen(open)
		isOpen = open
		ItemList.Visible = open
		SelectionFrame.Size = UDim2.new(0, 440, 0, open and expandedHeight or collapsedHeight)
		updateSelectButtonText()
	end

	local function refreshRow(row)
		local label = instanceMode and row.item.Name or tostring(row.item)
		row.button.Text = (row.selected and "[x]  " or "[ ]  ") .. label
		updateRegisteredElement(w, row.button, "BackgroundColor3", row.selected and "Accent" or "Sidebar")
	end

	local selectAllButton = Instance.new("TextButton")

	local function refreshSelectAll()
		local allSelected = #rows > 0 and selectedCount == #rows
		if allSelected then
			selectAllButton.Text = "[x]  Select all"
		elseif selectedCount > 0 then
			selectAllButton.Text = "[-]  Select all"
		else
			selectAllButton.Text = "[ ]  Select all"
		end

		updateRegisteredElement(w, selectAllButton, "BackgroundColor3", allSelected and "Accent" or "Sidebar")
	end

	-- Rewrite the caller's table in place (in items order) so references stay valid
	local function writeOutput(shouldNotify)
		table.clear(outputList)
		selectedCount = 0

		for _, row in ipairs(rows) do
			if row.selected then
				selectedCount += 1
				table.insert(outputList, row.item)
			end
		end

		updateSelectButtonText()
		refreshSelectAll()
		if shouldNotify and callback then
			callback(outputList)
		end
	end

	local syncItems -- defined below; row buttons re-scan before toggling

	local function createRowButton(row)
		local ItemBtn = Instance.new("TextButton")
		ItemBtn.Name = (instanceMode and row.item.Name or tostring(row.item)) .. "SelectionButton"
		ItemBtn.Size = UDim2.new(1, 0, 0, rowHeight)
		ItemBtn.BorderSizePixel = 0
		ItemBtn.Font = Enum.Font.Gotham
		ItemBtn.TextSize = 13
		ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
		registerElement(w, ItemBtn, "BackgroundColor3", "Sidebar")
		registerElement(w, ItemBtn, "TextColor3", "Text")
		row.button = ItemBtn

		local ItemCorner = Instance.new("UICorner")
		ItemCorner.CornerRadius = UDim.new(0, 5)
		ItemCorner.Parent = ItemBtn

		local ItemPadding = Instance.new("UIPadding")
		ItemPadding.PaddingLeft = UDim.new(0, 10)
		ItemPadding.Parent = ItemBtn

		ItemBtn.MouseButton1Click:Connect(function()
			local changed = syncItems()
			-- The row may have just been removed (e.g. its instance was destroyed)
			if rowByKey[row.key] == row then
				row.selected = not row.selected
				refreshRow(row)
				changed = true
			end
			writeOutput(changed)
		end)

		ItemBtn.Parent = ItemList
	end

	do -- "Select all" row (hidden while the list is empty)
		selectAllButton.Name = "SelectAllButton"
		selectAllButton.Size = UDim2.new(1, 0, 0, rowHeight)
		selectAllButton.BorderSizePixel = 0
		selectAllButton.Font = Enum.Font.GothamMedium
		selectAllButton.TextSize = 13
		selectAllButton.TextXAlignment = Enum.TextXAlignment.Left
		selectAllButton.LayoutOrder = 1
		registerElement(w, selectAllButton, "BackgroundColor3", "Sidebar")
		registerElement(w, selectAllButton, "TextColor3", "Text")
		selectAllButton.Parent = ItemList

		local SelectAllCorner = Instance.new("UICorner")
		SelectAllCorner.CornerRadius = UDim.new(0, 5)
		SelectAllCorner.Parent = selectAllButton

		local SelectAllPadding = Instance.new("UIPadding")
		SelectAllPadding.PaddingLeft = UDim.new(0, 10)
		SelectAllPadding.Parent = selectAllButton

		selectAllButton.MouseButton1Click:Connect(function()
			syncItems()
			local shouldSelectAll = false
			for _, row in ipairs(rows) do
				if not row.selected then
					shouldSelectAll = true
					break
				end
			end
			for _, row in ipairs(rows) do
				row.selected = shouldSelectAll
				refreshRow(row)
			end
			writeOutput(true)
		end)
	end

	local EmptyLabel = Instance.new("TextLabel")
	EmptyLabel.Size = UDim2.new(1, 0, 0, rowHeight)
	EmptyLabel.BackgroundTransparency = 1
	EmptyLabel.Text = "No items"
	EmptyLabel.Font = Enum.Font.Gotham
	EmptyLabel.TextSize = 13
	EmptyLabel.LayoutOrder = 1
	registerElement(w, EmptyLabel, "TextColor3", "MutedText")
	EmptyLabel.Parent = ItemList

	-- Reconcile rows with the caller's items table. Existing rows keep their
	-- selection and refresh their label (picks up renamed instances); new rows
	-- start unselected (defaultSelected only applies to the first build); rows
	-- whose item is gone are destroyed. Returns true if a selected row was removed.
	syncItems = function()
		local nextRows = {}
		local seen = {}
		local removedSelected = false

		for index, item in ipairs(items) do
			local key = instanceMode and item or index
			local valid = not instanceMode or (typeof(item) == "Instance" and item.Parent ~= nil)
			if valid and not seen[key] then
				seen[key] = true
				local row = rowByKey[key]
				if not row then
					row = { key = key, item = item, selected = not initialized and defaultSelected == true }
					rowByKey[key] = row
					createRowButton(row)
				end
				row.item = item
				table.insert(nextRows, row)
			end
		end

		for key, row in pairs(rowByKey) do
			if not seen[key] then
				removedSelected = removedSelected or row.selected
				rowByKey[key] = nil
				unregisterElement(w, row.button)
				row.button:Destroy()
			end
		end

		rows = nextRows
		initialized = true
		for order, row in ipairs(rows) do
			row.button.LayoutOrder = order + 1
			refreshRow(row)
		end

		local hasRows = #rows > 0
		selectAllButton.Visible = hasRows
		EmptyLabel.Visible = not hasRows

		local listRowCount = hasRows and #rows + 1 or 1
		local listHeight = listRowCount * rowHeight + (listRowCount - 1) * rowPadding
		ItemList.Size = UDim2.new(1, -20, 0, listHeight)
		expandedHeight = collapsedHeight + listHeight + 10
		if isOpen then
			SelectionFrame.Size = UDim2.new(0, 440, 0, expandedHeight)
		end

		return removedSelected
	end

	SelectBtn.MouseButton1Click:Connect(function()
		writeOutput(syncItems())
		setOpen(not isOpen)
	end)

	-- Any other button in this tab collapses this list. Item buttons inside the
	-- list are excluded so several choices can be changed at once.
	local function closeOnOtherButton(descendant)
		if not descendant:IsA("GuiButton") then return end
		if descendant == SelectBtn or descendant:IsDescendantOf(ItemList) then return end
		descendant.Activated:Connect(function()
			setOpen(false)
		end)
	end

	for _, descendant in ipairs(parentPage:GetDescendants()) do
		closeOnOtherButton(descendant)
	end
	parentPage.DescendantAdded:Connect(closeOnOtherButton)

	-- Switching away hides the page; collapse now so it stays reduced on return.
	parentPage:GetPropertyChangedSignal("Visible"):Connect(function()
		if not parentPage.Visible then
			setOpen(false)
		end
	end)

	-- Build the rows and initialize the caller's table without firing a callback.
	syncItems()
	writeOutput(false)

	-- Handle for scripts: re-scan items (new/removed instances, renamed rows) on
	-- demand. The callback fires only if the scan removed a selected item.
	return {
		Refresh = function()
			writeOutput(syncItems())
		end,
	}
end

-- Modular UI Component: A button that switches THIS window to a given theme
local function createThemeButton(w, parentPage, themeName, displayName)
	local ThemeBtn = Instance.new("TextButton")
	ThemeBtn.Name = themeName .. "ThemeButton"
	ThemeBtn.Size = UDim2.new(0, 440, 0, 40)
	ThemeBtn.Text = "Switch to " .. displayName
	ThemeBtn.Font = Enum.Font.GothamMedium
	ThemeBtn.TextSize = 14
	registerElement(w, ThemeBtn, "BackgroundColor3", "ComponentBg")
	registerElement(w, ThemeBtn, "TextColor3", "Text")
	ThemeBtn.Parent = parentPage

	local TBCorner = Instance.new("UICorner")
	TBCorner.CornerRadius = UDim.new(0, 6)
	TBCorner.Parent = ThemeBtn

	ThemeBtn.MouseButton1Click:Connect(function()
		applyTheme(w, themeName)
	end)
end

-- Keys offered by the settings-panel keybind dropdown (all valid Enum.KeyCode
-- names, plus "None" to disable the toggle shortcut)
local KEYBIND_OPTIONS = {
	"None", "RightShift", "RightControl", "LeftAlt",
	"Insert", "F", "G", "H", "J", "K", "V", "B", "N",
}

local function setWindowToggleKey(w, keyName)
	keyName = keyName or "None"

	if keyName ~= "None" then
		for _, entry in ipairs(w.keybindEntries) do
			if entry.keyName == keyName then
				showNotification(
					"Keybind conflict",
					keyName .. " is already assigned to " .. entry.title .. ".",
					4,
					false
				)
				return false
			end
		end
	end

	w.toggleKeyName = keyName
	if w.updateToggleKeyDropdown then
		w.updateToggleKeyDropdown(keyName)
	end
	return true
end

-- A compact labeled dropdown used inside the settings panel. Unlike the public
-- selector it has no "Run" button: choosing an option fires onSelect immediately.
local function createSettingsDropdown(w, parent, labelText, options, currentValue, onSelect)
	local Row = Instance.new("Frame")
	Row.Name = labelText .. "Row"
	Row.Size = UDim2.new(1, 0, 0, 45)
	Row.ZIndex = 16
	registerElement(w, Row, "BackgroundColor3", "ComponentBg")
	Row.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 150, 1, 0)
	Label.Position = UDim2.new(0, 15, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = labelText
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 16
	registerElement(w, Label, "TextColor3", "Text")
	Label.Parent = Row

	local SelectBtn = Instance.new("TextButton")
	SelectBtn.Size = UDim2.new(0, 180, 0, 30)
	SelectBtn.Position = UDim2.new(1, -195, 0.5, -15)
	SelectBtn.BorderSizePixel = 0
	SelectBtn.Text = tostring(currentValue)
	SelectBtn.Font = Enum.Font.Gotham
	SelectBtn.TextSize = 13
	SelectBtn.ZIndex = 17
	registerElement(w, SelectBtn, "BackgroundColor3", "Sidebar")
	registerElement(w, SelectBtn, "TextColor3", "Text")
	SelectBtn.Parent = Row

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = SelectBtn

	local Dropdown = Instance.new("ScrollingFrame")
	Dropdown.Size = UDim2.new(0, 180, 0, math.min(#options, 5) * 28)
	Dropdown.Position = UDim2.new(1, -195, 1, 2)
	Dropdown.BorderSizePixel = 0
	Dropdown.Visible = false
	Dropdown.ZIndex = 30
	Dropdown.ScrollBarThickness = 3
	Dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
	Dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
	registerElement(w, Dropdown, "BackgroundColor3", "Sidebar")
	Dropdown.Parent = Row

	local ddCorner = Instance.new("UICorner")
	ddCorner.CornerRadius = UDim.new(0, 6)
	ddCorner.Parent = Dropdown

	local ddLayout = Instance.new("UIListLayout")
	ddLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ddLayout.Parent = Dropdown

	for _, option in ipairs(options) do
		local OptBtn = Instance.new("TextButton")
		OptBtn.Size = UDim2.new(1, 0, 0, 28)
		OptBtn.BorderSizePixel = 0
		OptBtn.Text = tostring(option)
		OptBtn.Font = Enum.Font.Gotham
		OptBtn.TextSize = 13
		OptBtn.ZIndex = 31
		registerElement(w, OptBtn, "BackgroundColor3", "Sidebar")
		registerElement(w, OptBtn, "TextColor3", "Text")
		OptBtn.Parent = Dropdown

		OptBtn.MouseButton1Click:Connect(function()
			Dropdown.Visible = false
			local accepted = true
			if onSelect then
				accepted = onSelect(option) ~= false
			end
			if accepted then
				SelectBtn.Text = tostring(option)
			end
		end)
	end

	SelectBtn.MouseButton1Click:Connect(function()
		Dropdown.Visible = not Dropdown.Visible
	end)

	local function updateSelection(value)
		SelectBtn.Text = tostring(value)
	end

	return Row, updateSelection
end

-- Builds the per-window settings overlay (opened by the topbar gear button).
-- Contains theme/window settings and a dynamic list of component keybinds.
local function createSettingsPanel(w)
	local Panel = Instance.new("ScrollingFrame")
	Panel.Name = "SettingsPanel"
	Panel.Size = UDim2.new(1, -180, 1, -50)
	Panel.Position = UDim2.new(0, 180, 0, 50)
	Panel.BorderSizePixel = 0
	Panel.ScrollBarThickness = 3
	Panel.ScrollingDirection = Enum.ScrollingDirection.Y
	Panel.CanvasSize = UDim2.new(0, 0, 0, 0)
	Panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Panel.Visible = false
	Panel.ZIndex = 15
	registerElement(w, Panel, "BackgroundColor3", "Background")
	Panel.Parent = w.mainFrame
	w.settingsPanel = Panel

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = Panel

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 15)
	pad.PaddingBottom = UDim.new(0, 15)
	pad.PaddingLeft = UDim.new(0, 15)
	pad.PaddingRight = UDim.new(0, 15)
	pad.Parent = Panel

	local Header = Instance.new("TextLabel")
	Header.Size = UDim2.new(1, 0, 0, 24)
	Header.BackgroundTransparency = 1
	Header.Text = "Settings"
	Header.Font = Enum.Font.GothamBold
	Header.TextSize = 18
	Header.TextXAlignment = Enum.TextXAlignment.Left
	Header.ZIndex = 16
	Header.LayoutOrder = 1
	registerElement(w, Header, "TextColor3", "Text")
	Header.Parent = Panel

	-- Theme selector: lists every theme alphabetically and applies on select
	local themeNames = {}
	for name in pairs(Themes) do
		table.insert(themeNames, name)
	end
	table.sort(themeNames)

	local ThemeRow = createSettingsDropdown(w, Panel, "Theme", themeNames, w.currentThemeName or "DarkSleek", function(themeName)
		applyTheme(w, themeName)
		w.currentThemeName = themeName
		notifyTheme = Themes[themeName] or notifyTheme -- keep popups matching
	end)
	ThemeRow.LayoutOrder = 2

	-- Keybind selector: choose a key that shows/hides this window's main frame
	local ToggleKeyRow, updateToggleKeyDropdown = createSettingsDropdown(
		w,
		Panel,
		"Toggle Keybind",
		KEYBIND_OPTIONS,
		w.toggleKeyName or "None",
		function(keyName)
			return setWindowToggleKey(w, keyName)
		end
	)
	ToggleKeyRow.LayoutOrder = 3
	w.updateToggleKeyDropdown = updateToggleKeyDropdown

	local Hint = Instance.new("TextLabel")
	Hint.Size = UDim2.new(1, 0, 0, 30)
	Hint.BackgroundTransparency = 1
	Hint.Text = "Press the chosen key to show/hide this window."
	Hint.Font = Enum.Font.Gotham
	Hint.TextSize = 12
	Hint.TextWrapped = true
	Hint.TextXAlignment = Enum.TextXAlignment.Left
	Hint.ZIndex = 16
	Hint.LayoutOrder = 4
	registerElement(w, Hint, "TextColor3", "MutedText")
	Hint.Parent = Panel

	local KeybindHeader = Instance.new("TextLabel")
	KeybindHeader.Size = UDim2.new(1, 0, 0, 22)
	KeybindHeader.BackgroundTransparency = 1
	KeybindHeader.Text = "Keybinds"
	KeybindHeader.Font = Enum.Font.GothamBold
	KeybindHeader.TextSize = 15
	KeybindHeader.TextXAlignment = Enum.TextXAlignment.Left
	KeybindHeader.ZIndex = 16
	KeybindHeader.LayoutOrder = 5
	registerElement(w, KeybindHeader, "TextColor3", "Text")
	KeybindHeader.Parent = Panel

	local KeybindList = Instance.new("Frame")
	KeybindList.Name = "KeybindList"
	KeybindList.Size = UDim2.new(1, 0, 0, 0)
	KeybindList.AutomaticSize = Enum.AutomaticSize.Y
	KeybindList.BackgroundTransparency = 1
	KeybindList.LayoutOrder = 6
	KeybindList.ZIndex = 16
	KeybindList.Parent = Panel
	w.keybindSettingsList = KeybindList

	local keybindLayout = Instance.new("UIListLayout")
	keybindLayout.Padding = UDim.new(0, 6)
	keybindLayout.SortOrder = Enum.SortOrder.LayoutOrder
	keybindLayout.Parent = KeybindList
end

--------------------------------------------------------------------------------
-- 4. WINDOW CONSTRUCTION
--------------------------------------------------------------------------------
-- Each new window cascades by this many pixels so overlapping windows stay visible
local WINDOW_OFFSET_STEP = 40

local function buildWindow(w, title, index)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ModularUI_" .. index
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = playerGui
	w.screenGui = ScreenGui

	-- Cascade offset so simultaneous windows don't stack perfectly on top
	local offset = index * WINDOW_OFFSET_STEP

	-- Main Frame Window (CanvasGroup so the whole window can fade in as one)
	local MainFrame = Instance.new("CanvasGroup")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 650, 0, 400)
	MainFrame.Position = UDim2.new(0.5, -325 + offset, 0.5, -200 + offset)
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true -- Allows players to move it around
	MainFrame.GroupTransparency = 1 -- starts invisible; fades in on first appear
	registerElement(w, MainFrame, "BackgroundColor3", "Background")
	MainFrame.Parent = ScreenGui
	w.mainFrame = MainFrame

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 12)
	MainCorner.Parent = MainFrame

	-- Topbar (Watermark + Title + Status + Settings + Profile)
	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 50)
	Topbar.BackgroundTransparency = 1
	Topbar.Parent = MainFrame

	-- Watermark greeting (kept by default)
	local Watermark = Instance.new("TextLabel")
	Watermark.Name = "Watermark"
	Watermark.Size = UDim2.new(0, 300, 1, 0)
	Watermark.Position = UDim2.new(0, 60, 0, 0)
	Watermark.BackgroundTransparency = 1
	Watermark.Text = "Hello, " .. player.DisplayName
	Watermark.Font = Enum.Font.GothamBold
	Watermark.TextSize = 16
	Watermark.TextXAlignment = Enum.TextXAlignment.Left
	registerElement(w, Watermark, "TextColor3", "Text")
	Watermark.Parent = Topbar

	-- Custom Window Title (centered) -- pass Title in UI.new to set it
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "WindowTitle"
	TitleLabel.Size = UDim2.new(1, 0, 1, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 18
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
	registerElement(w, TitleLabel, "TextColor3", "Text")
	TitleLabel.Parent = Topbar
	w.titleLabel = TitleLabel

	-- Top-right status labels, ordered left-to-right: time, FPS, ping, settings
	local ClockLabel = Instance.new("TextLabel")
	ClockLabel.Name = "Clock"
	ClockLabel.Size = UDim2.new(0, 90, 1, 0)
	ClockLabel.Position = UDim2.new(1, -272, 0, 0)
	ClockLabel.BackgroundTransparency = 1
	ClockLabel.Text = os.date("%H:%M:%S")
	ClockLabel.Font = Enum.Font.GothamMedium
	ClockLabel.TextSize = 14
	ClockLabel.TextXAlignment = Enum.TextXAlignment.Right
	registerElement(w, ClockLabel, "TextColor3", "MutedText")
	ClockLabel.Parent = Topbar
	w.clockLabel = ClockLabel

	local FPSLabel = Instance.new("TextLabel")
	FPSLabel.Name = "FPS"
	FPSLabel.Size = UDim2.new(0, 60, 1, 0)
	FPSLabel.Position = UDim2.new(1, -177, 0, 0)
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.Text = "-- FPS"
	FPSLabel.Font = Enum.Font.GothamMedium
	FPSLabel.TextSize = 14
	FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
	registerElement(w, FPSLabel, "TextColor3", "MutedText")
	FPSLabel.Parent = Topbar
	w.fpsLabel = FPSLabel

	local PingLabel = Instance.new("TextLabel")
	PingLabel.Name = "Ping"
	PingLabel.Size = UDim2.new(0, 65, 1, 0)
	PingLabel.Position = UDim2.new(1, -112, 0, 0)
	PingLabel.BackgroundTransparency = 1
	PingLabel.Text = "-- ms"
	PingLabel.Font = Enum.Font.GothamMedium
	PingLabel.TextSize = 14
	PingLabel.TextXAlignment = Enum.TextXAlignment.Right
	registerElement(w, PingLabel, "TextColor3", "MutedText")
	PingLabel.Parent = Topbar
	w.pingLabel = PingLabel

	-- Settings gear is anchored at the far-right edge
	local SettingsButton = Instance.new("TextButton")
	SettingsButton.Name = "SettingsButton"
	SettingsButton.Size = UDim2.new(0, 30, 0, 30)
	SettingsButton.Position = UDim2.new(1, -42, 0.5, -15)
	SettingsButton.BackgroundTransparency = 1
	SettingsButton.Text = "\u{2699}" -- gear glyph
	SettingsButton.Font = Enum.Font.GothamBold
	SettingsButton.TextSize = 22
	registerElement(w, SettingsButton, "TextColor3", "MutedText")
	SettingsButton.Parent = Topbar
	w.settingsButton = SettingsButton

	SettingsButton.MouseEnter:Connect(function()
		TweenService:Create(SettingsButton, TweenInfo.new(0.15), {TextTransparency = 0.35}):Play()
	end)
	SettingsButton.MouseLeave:Connect(function()
		TweenService:Create(SettingsButton, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
	end)
	SettingsButton.MouseButton1Click:Connect(function()
		if w.settingsPanel then
			w.settingsPanel.Visible = not w.settingsPanel.Visible
		end
	end)

	-- Player Thumbnail
	local AvatarImage = Instance.new("ImageLabel")
	AvatarImage.Name = "AvatarImage"
	AvatarImage.Size = UDim2.new(0, 36, 0, 36)
	AvatarImage.Position = UDim2.new(0, 12, 0, 7)
	AvatarImage.BackgroundTransparency = 1
	AvatarImage.Parent = Topbar

	local AvatarCorner = Instance.new("UICorner")
	AvatarCorner.CornerRadius = UDim.new(1, 0) -- Circle avatar
	AvatarCorner.Parent = AvatarImage

	-- Fetch actual Player Thumbnail safely
	task.spawn(function()
		local userId = player.UserId
		local thumbType = Enum.ThumbnailType.HeadShot
		local thumbSize = Enum.ThumbnailSize.Size420x420
		local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
		if isReady then
			AvatarImage.Image = content
		end
	end)

	-- Left Sidebar (Navigation)
	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 180, 1, -50)
	Sidebar.Position = UDim2.new(0, 0, 0, 50)
	Sidebar.BorderSizePixel = 0
	Sidebar.ScrollBarThickness = 2
	registerElement(w, Sidebar, "BackgroundColor3", "Sidebar")
	Sidebar.Parent = MainFrame
	w.sidebar = Sidebar

	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.Padding = UDim.new(0, 6)
	SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SidebarLayout.Parent = Sidebar

	local SidebarPadding = Instance.new("UIPadding")
	SidebarPadding.PaddingTop = UDim.new(0, 10)
	SidebarPadding.Parent = Sidebar

	-- Right Side Content Container
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, -180, 1, -50)
	ContentContainer.Position = UDim2.new(0, 180, 0, 50)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = MainFrame
	w.contentContainer = ContentContainer

	-- Settings overlay (theme selector + toggle-keybind selector)
	createSettingsPanel(w)

	-- One per-window dispatcher handles UI visibility and every component
	-- keybind. Capturing is checked first so the chosen key is never executed.
	w.inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if activeKeybindCaptureWindow then
			if activeKeybindCaptureWindow == w and w.activeKeyCapture then
				if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
					finishKeybindCapture(w, input.KeyCode.Name)
				elseif input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.MouseButton2
					or input.UserInputType == Enum.UserInputType.Touch then
					finishKeybindCapture(w, nil)
				end
			end
			return
		end

		if (input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.MouseButton2
			or input.UserInputType == Enum.UserInputType.Touch)
			and w.openKeybindModeMenu then
			local menuToClose = w.openKeybindModeMenu
			local menuPosition = menuToClose.AbsolutePosition
			local menuSize = menuToClose.AbsoluteSize
			local pointerPosition = input.Position
			local clickedInsideMenu = pointerPosition.X >= menuPosition.X
				and pointerPosition.X <= menuPosition.X + menuSize.X
				and pointerPosition.Y >= menuPosition.Y
				and pointerPosition.Y <= menuPosition.Y + menuSize.Y

			-- Let an option receive MouseButton1Click before it closes the menu.
			if not clickedInsideMenu then
				task.defer(function()
					if w.openKeybindModeMenu == menuToClose then
						menuToClose.Visible = false
						w.openKeybindModeMenu = nil
					end
				end)
			end
		end

		if gameProcessed then return end
		-- Don't fire component shortcuts while the player is typing elsewhere.
		if UserInputService:GetFocusedTextBox() then return end
		if not w.mainFrame or not w.mainFrame.Parent then return end
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

		local keyName = input.KeyCode.Name
		if w.toggleKeyName and w.toggleKeyName ~= "None" and keyName == w.toggleKeyName then
			w.mainFrame.Visible = not w.mainFrame.Visible
			return
		end

		for _, entry in ipairs(w.keybindEntries) do
			if entry.keyName == keyName then
				if entry.kind == "Toggle" then
					if entry.mode == "Hold" then
						if not entry.held then
							entry.held = true
							if entry.actions.holdBegan then
								entry.actions.holdBegan()
							end
						end
					elseif entry.actions.toggle then
						entry.actions.toggle()
					end
				elseif entry.actions.press then
					entry.actions.press()
				end
			end
		end
	end)

	-- Hold-mode toggles must release even if another textbox gains focus while
	-- the key is down, otherwise their callback could remain stuck on true.
	w.inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

		local keyName = input.KeyCode.Name
		for _, entry in ipairs(w.keybindEntries) do
			if entry.kind == "Toggle"
				and entry.mode == "Hold"
				and entry.held
				and entry.keyName == keyName then
				releaseHeldKeybind(entry)
			end
		end
	end)

	-- Measure rendered frames and refresh all status values once per second
	local elapsed = 0
	local renderedFrames = 0
	w.statsConnection = RunService.RenderStepped:Connect(function(deltaTime)
		elapsed += deltaTime
		renderedFrames += 1
		if elapsed >= 1 then
			FPSLabel.Text = string.format("%d FPS", math.floor(renderedFrames / elapsed + 0.5))
			PingLabel.Text = string.format("%d ms", math.floor(player:GetNetworkPing() * 1000 + 0.5))
			ClockLabel.Text = os.date("%H:%M:%S")
			elapsed = 0
			renderedFrames = 0
		end
	end)

	-- One-time fade-in the very first time this window is created
	TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		GroupTransparency = 0,
	}):Play()
end

--------------------------------------------------------------------------------
-- 5. PUBLIC API
--------------------------------------------------------------------------------
local Tab = {}
Tab.__index = Tab

function Tab:AddToggle(featureName, defaultState, callback)
	createToggleSetting(self._window, self._page, featureName, defaultState, callback)
	return self
end

function Tab:AddButton(buttonText, callback)
	createActionButton(self._window, self._page, buttonText, callback)
	return self
end

function Tab:AddSlider(settingName, minValue, maxValue, defaultValue, callback)
	createSliderSetting(self._window, self._page, settingName, minValue, maxValue, defaultValue, callback)
	return self
end

function Tab:AddTextbox(settingName, placeholderText, callback)
	createTextboxSetting(self._window, self._page, settingName, placeholderText, callback)
	return self
end

function Tab:AddSelector(settingName, items, callback)
	createItemSelector(self._window, self._page, settingName, items, callback)
	return self
end

function Tab:AddSelectionList(settingName, items, outputList, defaultSelected, callback)
	createSelectionList(self._window, self._page, settingName, items, outputList, defaultSelected, callback)
	return self
end

-- Keep the spelling from the original feature request available as an alias.
Tab.AddSelectionListe = Tab.AddSelectionList

-- Like AddSelectionList, but items are Instances (rows show instance.Name) and
-- outputList receives the selected Instances themselves. The items table is
-- re-scanned on every interaction; instances added later start unselected and
-- removed/destroyed ones are dropped from the UI and from outputList.
-- Returns a handle: handle:Refresh() re-scans immediately from code.
function Tab:AddInstancesSelectionList(settingName, instances, outputList, defaultSelected, callback)
	return createSelectionList(self._window, self._page, settingName, instances, outputList, defaultSelected, callback, true)
end

function Tab:AddThemeButton(themeName, displayName)
	createThemeButton(self._window, self._page, themeName, displayName)
	return self
end

local Window = {}
Window.__index = Window

-- Add a navigation tab; the first tab added becomes the active page
function Window:AddTab(name)
	local page = createPage(self, name)
	createTabButton(self, name)
	if not self.activePage then
		switchTab(self, name)
	end
	return setmetatable({ _window = self, _page = page }, Tab)
end

function Window:ShowTab(name)
	switchTab(self, name)
end

function Window:SetTheme(themeName)
	applyTheme(self, themeName)
end

function Window:SetTitle(text)
	if self.titleLabel then
		self.titleLabel.Text = text
	end
end

-- Toggle the live clock on/off for this window
function Window:SetClockVisible(visible)
	self.clockEnabled = visible
	if self.clockLabel then
		self.clockLabel.Visible = visible
	end
end

-- Set (or clear with "None"/nil) the key that shows/hides this window.
-- keyName is an Enum.KeyCode name string, e.g. "RightShift".
function Window:SetToggleKey(keyName)
	return setWindowToggleKey(self, keyName)
end

-- Show a bottom-right notification popup (see UI.notify)
function Window:Notify(title, content, duration, sound)
	showNotification(title, content, duration, sound)
end

-- Tear the window down and stop its listeners
function Window:Destroy()
	if self.activeKeyCapture then
		finishKeybindCapture(self, nil)
	end
	for _, entry in ipairs(self.keybindEntries) do
		releaseHeldKeybind(entry)
	end
	if self.inputConnection then
		self.inputConnection:Disconnect()
		self.inputConnection = nil
	end
	if self.inputEndedConnection then
		self.inputEndedConnection:Disconnect()
		self.inputEndedConnection = nil
	end
	if self.statsConnection then
		self.statsConnection:Disconnect()
		self.statsConnection = nil
	end
	if self.screenGui then
		self.screenGui:Destroy()
		self.screenGui = nil
	end
end

--------------------------------------------------------------------------------
-- 6. MODULE ENTRY POINT
--------------------------------------------------------------------------------
local UILib = {}

-- Theme "enum": use UI.Theme.Cyberpunk (or the shortcut UI.Cyberpunk) instead of
-- raw strings. Each value equals its string key, so raw strings still work too.
-- Generated from the Themes table, so new themes appear here automatically.
UILib.Theme = {}
for name in pairs(Themes) do
	UILib.Theme[name] = name -- e.g. UI.Theme.Cyberpunk == "Cyberpunk"
	UILib[name] = name       -- top-level shortcut, e.g. UI.Cyberpunk
end

-- Creation counter: how many windows have been made this session
local windowCount = 0

function UILib.getWindowCount()
	return windowCount
end

-- Global notification popup (bottom-right of the screen).
--   UI.notify("Title", "Body text", duration, playSound)
function UILib.notify(title, content, duration, sound)
	showNotification(title, content, duration, sound)
end

-- Change the color scheme used by notification popups (defaults to DarkSleek).
-- Accepts a theme name string, e.g. UI.Theme.Cyberpunk.
function UILib.setNotificationTheme(themeName)
	if Themes[themeName] then
		notifyTheme = Themes[themeName]
	end
end

function UILib.new(config)
	config = config or {}

	local title = config.Title or "..."
	local startingTheme = config.Theme or "DarkSleek"
	local showClock = config.ShowClock
	if showClock == nil then showClock = true end

	-- Each window owns its own state
	local w = setmetatable({
		index = windowCount,
		currentTheme = Themes[startingTheme] or Themes.DarkSleek,
		currentThemeName = Themes[startingTheme] and startingTheme or "DarkSleek",
		toggleKeyName = "RightShift",
		trackedElements = {},
		elementLookup = {},
		pages = {},
		tabButtons = {},
		keybindEntries = {},
		nextKeybindId = 0,
		activeKeyCapture = nil,
		openKeybindModeMenu = nil,
		activePage = nil,
		clockEnabled = showClock,
	}, Window)

	buildWindow(w, title, w.index)

	w.clockLabel.Visible = showClock

	windowCount += 1
	return w
end

return UILib
