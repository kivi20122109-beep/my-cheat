--==============================================================
-- NEBULA HUB  |  v1.0
-- Бинд меню: J
-- Панель настроек справа
--==============================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- GUI парентим в gethui (скрыт от игры)
local parentGui
local okHui, hui = pcall(function() return gethui() end)
if okHui and hui then parentGui = hui else parentGui = LocalPlayer:WaitForChild("PlayerGui") end

local function safe(fn, ...)
    local ok, res = pcall(fn, ...)
    if not ok then warn("[Nebula]", res) end
    return ok, res
end

--==============================================================
-- КОНФИГ
--==============================================================
local Config = {
    MenuKey = Enum.KeyCode.J,

    -- Цвета GUI (пресеты)
    AccentColor = Color3.fromRGB(170, 0, 255),
    AccentDark = Color3.fromRGB(100, 0, 160),
    BgColor = Color3.fromRGB(18, 18, 24),
    PanelColor = Color3.fromRGB(25, 25, 35),
    GUIScale = 1,

    -- Aimbot
    AimEnabled = false,
    AimKey = Enum.KeyCode.E,
    AimPart = "Head",
    AimFOV = 120,
    AimSmooth = 0.15,
    WallCheck = false,
    AimTeamCheck = true,
    ShowFOV = true,

    -- ESP
    ESPEnabled = false,
    BoxESP = true,
    BoxFill = true,
    NameTags = true,
    HealthBars = true,
    Distance = true,
    Tracers = true,
    HeadDot = true,
    Chams = true,
    ESPTeamCheck = false,
    EnemyColor = Color3.fromRGB(255, 60, 60),
    AllyColor = Color3.fromRGB(60, 255, 120),

    -- Movement
    FlyEnabled = false,
    FlySpeed = 60,
    FlyJump = false,
    FlyJumpPower = 80,
    Noclip = false,
    InfiniteJump = false,
    WalkSpeedEnabled = false,
    WalkSpeed = 32,
    JumpPowerEnabled = false,
    JumpPower = 65,

    -- World
    Fullbright = false,
    CameraFOV = 70,
    Freecam = false,

    MenuVisible = true,
}

--==============================================================
-- GUI
--==============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Enabled = Config.MenuVisible
ScreenGui.Parent = parentGui

-- Главное окно (используем Scale для изменения размера GUI)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(760, 460)
Main.Position = UDim2.new(0.5, -380, 0.5, -230)
Main.BackgroundColor3 = Config.BgColor
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ZIndex = 10
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Config.AccentColor
MainStroke.Thickness = 2

-- Применение масштаба через UIScale
local MainScale = Instance.new("UIScale", Main)
MainScale.Scale = Config.GUIScale

-- Заголовок
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = Config.PanelColor
Header.BorderSizePixel = 0
Header.ZIndex = 11
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel", Header)
Title.Position = UDim2.fromOffset(20, 0)
Title.Size = UDim2.fromOffset(300, 46)
Title.BackgroundTransparency = 1
Title.Text = "NEBULA"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Config.AccentColor
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12

local Subtitle = Instance.new("TextLabel", Header)
Subtitle.Position = UDim2.fromOffset(115, 4)
Subtitle.Size = UDim2.fromOffset(200, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "HUB  •  [J]"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 11
Subtitle.TextColor3 = Color3.fromRGB(140, 140, 160)
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 12

-- Кнопки сверху справа (свернуть / закрыть)
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.fromOffset(34, 30)
CloseBtn.Position = UDim2.new(1, -42, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    Config.MenuVisible = false
    ScreenGui.Enabled = false
end)

--==============================================================
-- ЛЕВАЯ ПАНЕЛЬ (ВКЛАДКИ)
--==============================================================
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.fromOffset(150, 402)
TabBar.Position = UDim2.fromOffset(8, 50)
TabBar.BackgroundColor3 = Config.PanelColor
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 11
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.Padding = UDim.new(0, 5)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabPad = Instance.new("UIPadding", TabBar)
TabPad.PaddingTop = UDim.new(0, 8)

--==============================================================
-- ЦЕНТР (КОНТЕНТ)
--==============================================================
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -318, 1, -60)
Content.Position = UDim2.fromOffset(166, 50)
Content.BackgroundTransparency = 1
Content.ZIndex = 11

--==============================================================
-- ПРАВАЯ ПАНЕЛЬ (НАСТРОЙКИ)
--==============================================================
local SettingsPanel = Instance.new("Frame", Main)
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.fromOffset(150, 402)
SettingsPanel.Position = UDim2.new(1, -158, 0, 50)
SettingsPanel.BackgroundColor3 = Config.PanelColor
SettingsPanel.BorderSizePixel = 0
SettingsPanel.ZIndex = 11
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 10)

local SettingsScroll = Instance.new("ScrollingFrame", SettingsPanel)
SettingsScroll.Size = UDim2.new(1, -10, 1, -10)
SettingsScroll.Position = UDim2.fromOffset(5, 5)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.BorderSizePixel = 0
SettingsScroll.ScrollBarThickness = 3
SettingsScroll.ScrollBarImageColor3 = Config.AccentColor
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 600)
SettingsScroll.ZIndex = 12

local SettingsLayout = Instance.new("UIListLayout", SettingsScroll)
SettingsLayout.Padding = UDim.new(0, 6)
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder

--==============================================================
-- UI ХЕЛПЕРЫ
--==============================================================
local function createSection(parent, text)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, -10, 0, 22)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextColor3 = Config.AccentColor
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 13
end

local function createButton(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(220, 220, 240)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.BorderSizePixel = 0
    b.ZIndex = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Config.AccentDark end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(30, 30, 42) end)
    b.MouseButton1Click:Connect(function() safe(callback) end)
    return b
end

local function createToggle(parent, text, default, callback)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1, -10, 0, 28)
    c.BackgroundTransparency = 1
    c.ZIndex = 13

    local lbl = Instance.new("TextLabel", c)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(210, 210, 230)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 14

    local state = default
    local btn = Instance.new("TextButton", c)
    btn.Size = UDim2.fromOffset(42, 20)
    btn.Position = UDim2.new(1, -42, 0.5, -10)
    btn.BackgroundColor3 = state and Config.AccentColor or Color3.fromRGB(50, 50, 65)
    btn.Text = state and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.ZIndex = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Config.AccentColor or Color3.fromRGB(50, 50, 65)
        btn.Text = state and "ON" or "OFF"
        safe(callback, state)
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1, -10, 0, 34)
    c.BackgroundTransparency = 1
    c.ZIndex = 13

    local lbl = Instance.new("TextLabel", c)
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. string.format("%.1f", default)
    lbl.TextColor3 = Color3.fromRGB(210, 210, 230)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 14

    local bg = Instance.new("Frame", c)
    bg.Size = UDim2.new(1, 0, 0, 5)
    bg.Position = UDim2.new(0, 0, 0, 22)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    bg.BorderSizePixel = 0
    bg.ZIndex = 14
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.AccentColor
    fill.BorderSizePixel = 0
    fill.ZIndex = 15
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - bg.AbsolutePosition.X) / math.max(bg.AbsoluteSize.X, 1), 0, 1)
        local val = min + (max - min) * rel
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lbl.Text = text .. ": " .. string.format("%.1f", val)
        safe(callback, val)
    end

    bg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(i)
        end
    end)
    bg.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
    end)
end

local function createColorButton(parent, text, defaultColor, callback)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1, -10, 0, 26)
    c.BackgroundTransparency = 1
    c.ZIndex = 13

    local lbl = Instance.new("TextLabel", c)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(210, 210, 230)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 14

    local btn = Instance.new("TextButton", c)
    btn.Size = UDim2.fromOffset(28, 20)
    btn.Position = UDim2.new(1, -28, 0.5, -10)
    btn.BackgroundColor3 = defaultColor
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    -- Клик по кнопке открывает редактирование через 3 слайдера R/G/B
    btn.MouseButton1Click:Connect(function()
        safe(callback)
    end)
end

--==============================================================
-- ВКЛАДКИ
--==============================================================
local pages = {}
local currentPage

local function createTab(name, order)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1, -16, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(190, 190, 210)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.ZIndex = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Config.AccentColor
    page.CanvasSize = UDim2.new(0, 0, 0, 500)
    page.Visible = false
    page.ZIndex = 12

    local l = Instance.new("UIListLayout", page)
    l.Padding = UDim.new(0, 6)
    l.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        if currentPage then currentPage.Visible = false end
        for _, b in ipairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                b.TextColor3 = Color3.fromRGB(190, 190, 210)
            end
        end
        btn.BackgroundColor3 = Config.AccentColor
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
        currentPage = page
    end)

    pages[name] = {page = page, button = btn}
    return page
end

local CombatTab = createTab("Combat", 1)
local VisualsTab = createTab("Visuals", 2)
local MovementTab = createTab("Movement", 3)
local TeleportTab = createTab("Teleports", 4)
local WorldTab = createTab("World", 5)

--==============================================================
-- COMBAT
--==============================================================
createSection(CombatTab, "AIMBOT")
createToggle(CombatTab, "Aimbot", false, function(v) Config.AimEnabled = v end)
createToggle(CombatTab, "Wall Check", false, function(v) Config.WallCheck = v end)
createToggle(CombatTab, "Team Check", true, function(v) Config.AimTeamCheck = v end)
createSlider(CombatTab, "FOV", 20, 500, 120, function(v) Config.AimFOV = v end)
createSlider(CombatTab, "Smoothing", 0, 1, 0.15, function(v) Config.AimSmooth = v end)

--==============================================================
-- VISUALS
--==============================================================
createSection(VisualsTab, "ESP")
createToggle(VisualsTab, "ESP Enabled", false, function(v) Config.ESPEnabled = v end)
createToggle(VisualsTab, "Box ESP", true, function(v) Config.BoxESP = v end)
createToggle(VisualsTab, "Box Fill", true, function(v) Config.BoxFill = v end)
createToggle(VisualsTab, "Name Tags", true, function(v) Config.NameTags = v end)
createToggle(VisualsTab, "Health Bars", true, function(v) Config.HealthBars = v end)
createToggle(VisualsTab, "Distance", true, function(v) Config.Distance = v end)
createToggle(VisualsTab, "Tracers", true, function(v) Config.Tracers = v end)
createToggle(VisualsTab, "Head Dot", true, function(v) Config.HeadDot = v end)
createToggle(VisualsTab, "Chams", true, function(v) Config.Chams = v end)
createToggle(VisualsTab, "Team Check", false, function(v) Config.ESPTeamCheck = v end)

--==============================================================
-- MOVEMENT
--==============================================================
createSection(MovementTab, "FLY")
createToggle(MovementTab, "Fly", false, function(v) Config.FlyEnabled = v end)
createSlider(MovementTab, "Fly Speed", 10, 300, 60, function(v) Config.FlySpeed = v end)
createToggle(MovementTab, "Fly Jump (прыжок в полёте)", false, function(v) Config.FlyJump = v end)
createSlider(MovementTab, "Fly Jump Power", 30, 300, 80, function(v) Config.FlyJumpPower = v end)

createSection(MovementTab, "WALK")
createToggle(MovementTab, "Custom WalkSpeed", false, function(v) Config.WalkSpeedEnabled = v end)
createSlider(MovementTab, "WalkSpeed", 8, 200, 32, function(v) Config.WalkSpeed = v end)
createToggle(MovementTab, "Custom JumpPower", false, function(v) Config.JumpPowerEnabled = v end)
createSlider(MovementTab, "JumpPower", 20, 200, 65, function(v) Config.JumpPower = v end)
createToggle(MovementTab, "Noclip", false, function(v) Config.Noclip = v end)
createToggle(MovementTab, "Infinite Jump", false, function(v) Config.InfiniteJump = v end)

--==============================================================
-- TELEPORTS
--==============================================================
createSection(TeleportTab, "К ИГРОКУ")
local selectedPlayer = nil

local playerDropdown = Instance.new("TextButton", TeleportTab)
playerDropdown.Size = UDim2.new(1, -10, 0, 30)
playerDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
playerDropdown.Text = "Выберите игрока..."
playerDropdown.TextColor3 = Color3.fromRGB(220, 220, 240)
playerDropdown.Font = Enum.Font.Gotham
playerDropdown.TextSize = 12
playerDropdown.BorderSizePixel = 0
playerDropdown.ZIndex = 13
Instance.new("UICorner", playerDropdown).CornerRadius = UDim.new(0, 6)

local playerList = Instance.new("Frame", TeleportTab)
playerList.Size = UDim2.new(1, -10, 0, 0)
playerList.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
playerList.BorderSizePixel = 0
playerList.ClipsDescendants = true
playerList.Visible = false
playerList.ZIndex = 20
Instance.new("UICorner", playerList).CornerRadius = UDim.new(0, 6)

local isOpen = false
playerDropdown.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    playerList.Visible = isOpen
    if isOpen then
        for _, c in ipairs(playerList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        for _, n in ipairs(names) do
            local b = Instance.new("TextButton", playerList)
            b.Size = UDim2.new(1, 0, 0, 24)
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            b.Text = n
            b.TextColor3 = Color3.fromRGB(210, 210, 230)
            b.Font = Enum.Font.Gotham
            b.TextSize = 11
            b.BorderSizePixel = 0
            b.ZIndex = 21
            b.MouseButton1Click:Connect(function()
                playerDropdown.Text = n
                playerList.Visible = false
                isOpen = false
                selectedPlayer = n
            end)
        end
        playerList.Size = UDim2.new(1, -10, 0, math.min(#names * 26, 150))
    end
end)

createButton(TeleportTab, "Teleport к игроку", function()
    if not selectedPlayer then return end
    local target = Players:FindFirstChild(selectedPlayer)
    if not target or not target.Character then return end
    local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local mHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if tHRP and mHRP then mHRP.CFrame = tHRP.CFrame + Vector3.new(3, 0, 3) end
end)

createSection(TeleportTab, "WAYPOINTS")
local savedPos
createButton(TeleportTab, "Save Position", function()
    local mHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if mHRP then savedPos = mHRP.CFrame end
end)
createButton(TeleportTab, "Load Position", function()
    local mHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if mHRP and savedPos then mHRP.CFrame = savedPos end
end)

--==============================================================
-- WORLD
--==============================================================
createSection(WorldTab, "CAMERA")
createSlider(WorldTab, "Camera FOV", 40, 120, 70, function(v)
    Config.CameraFOV = v
    if Camera then Camera.FieldOfView = v end
end)

createSection(WorldTab, "LIGHTING")
local origLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
}
createToggle(WorldTab, "Fullbright", false, function(v)
    Config.Fullbright = v
    if v then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e5
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = origLighting.Brightness
        Lighting.ClockTime = origLighting.ClockTime
        Lighting.FogEnd = origLighting.FogEnd
        Lighting.GlobalShadows = origLighting.GlobalShadows
    end
end)

--==============================================================
-- ПРАВАЯ ПАНЕЛЬ — НАСТРОЙКИ GUI
--==============================================================
local function applyAccent(color)
    Config.AccentColor = color
    Config.AccentDark = Color3.new(color.R * 0.6, color.G * 0.6, color.B * 0.6)
    MainStroke.Color = color
    Title.TextColor3 = color
    for _, t in pairs(pages) do
        if t.button.BackgroundColor3 == Color3.fromRGB(35, 35, 48) then
            -- не трогаем неактивные
        end
    end
    -- активная вкладка
    if currentPage then
        for name, t in pairs(pages) do
            if t.page == currentPage then
                t.button.BackgroundColor3 = color
            end
        end
    end
    FOVStroke.Color = color
end

createSection(SettingsScroll, "ЦВЕТА")
createColorButton(SettingsScroll, "Фиолетовый", Color3.fromRGB(170, 0, 255), function() applyAccent(Color3.fromRGB(170, 0, 255)) end)
createColorButton(SettingsScroll, "Синий", Color3.fromRGB(0, 140, 255), function() applyAccent(Color3.fromRGB(0, 140, 255)) end)
createColorButton(SettingsScroll, "Красный", Color3.fromRGB(255, 50, 80), function() applyAccent(Color3.fromRGB(255, 50, 80)) end)
createColorButton(SettingsScroll, "Зелёный", Color3.fromRGB(40, 220, 120), function() applyAccent(Color3.fromRGB(40, 220, 120)) end)
createColorButton(SettingsScroll, "Розовый", Color3.fromRGB(255, 80, 200), function() applyAccent(Color3.fromRGB(255, 80, 200)) end)
createColorButton(SettingsScroll, "Голубой", Color3.fromRGB(0, 220, 255), function() applyAccent(Color3.fromRGB(0, 220, 255)) end)
createColorButton(SettingsScroll, "Оранжевый", Color3.fromRGB(255, 140, 40), function() applyAccent(Color3.fromRGB(255, 140, 40)) end)

-- Кастомный цвет через R/G/B слайдеры
createSection(SettingsScroll, "СВОЙ ЦВЕТ (RGB)")
local customR, customG, customB = 170, 0, 255
local function applyCustom()
    applyAccent(Color3.fromRGB(customR, customG, customB))
end
createSlider(SettingsScroll, "R", 0, 255, 170, function(v) customR = math.floor(v) applyCustom() end)
createSlider(SettingsScroll, "G", 0, 255, 0, function(v) customG = math.floor(v) applyCustom() end)
createSlider(SettingsScroll, "B", 0, 255, 255, function(v) customB = math.floor(v) applyCustom() end)

createSection(SettingsScroll, "РАЗМЕР GUI")
createSlider(SettingsScroll, "Scale", 0.5, 1.5, 1, function(v)
    Config.GUIScale = v
    MainScale.Scale = v
end)

createSection(SettingsScroll, "ПРОЗРАЧНОСТЬ")
createSlider(SettingsScroll, "BG Transparency", 0, 0.9, 0, function(v)
    Main.BackgroundTransparency = v
end)

--==============================================================
-- БИНД J
--==============================================================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Config.MenuKey then
        Config.MenuVisible = not Config.MenuVisible
        ScreenGui.Enabled = Config.MenuVisible
    end
end)

--==============================================================
-- CHARACTER TRACKING
--==============================================================
local Character, Humanoid, Root
local function updateChar()
    Character = LocalPlayer.Character
    if Character then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        Root = Character:FindFirstChild("HumanoidRootPart")
    end
end
updateChar()
LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid", 5)
    Root = c:WaitForChild("HumanoidRootPart", 5)
end)

--==============================================================
-- ESP
--==============================================================
local espObjects = {}
local hasDrawing = (type(Drawing) == "table" and Drawing.new ~= nil)

local function newESP()
    local o = {}
    o.BoxOutline = Drawing.new("Square")
    o.BoxOutline.Thickness = 3
    o.BoxOutline.Filled = false
    o.BoxOutline.Transparency = 1
    o.BoxOutline.Visible = false

    o.BoxInner = Drawing.new("Square")
    o.BoxInner.Thickness = 1
    o.BoxInner.Filled = false
    o.BoxInner.Color = Color3.fromRGB(0, 0, 0)
    o.BoxInner.Transparency = 1
    o.BoxInner.Visible = false

    o.BoxFill = Drawing.new("Square")
    o.BoxFill.Thickness = 1
    o.BoxFill.Filled = true
    o.BoxFill.Transparency = 0.85
    o.BoxFill.Visible = false

    o.Tracer = Drawing.new("Line")
    o.Tracer.Thickness = 1.5
    o.Tracer.Transparency = 1
    o.Tracer.Visible = false

    o.HeadDot = Drawing.new("Circle")
    o.HeadDot.Thickness = 2
    o.HeadDot.Filled = true
    o.HeadDot.Transparency = 0.4
    o.HeadDot.NumSides = 20
    o.HeadDot.Radius = 5
    o.HeadDot.Visible = false

    o.NameOutline = Drawing.new("Text")
    o.NameOutline.Size = 15
    o.NameOutline.Center = true
    o.NameOutline.Outline = true
    o.NameOutline.Color = Color3.fromRGB(0, 0, 0)
    o.NameOutline.Visible = false

    o.Name = Drawing.new("Text")
    o.Name.Size = 15
    o.Name.Center = true
    o.Name.Outline = false
    o.Name.Color = Color3.fromRGB(255, 255, 255)
    o.Name.Visible = false

    o.HPText = Drawing.new("Text")
    o.HPText.Size = 13
    o.HPText.Center = true
    o.HPText.Outline = true
    o.HPText.Color = Color3.fromRGB(180, 255, 180)
    o.HPText.Visible = false

    o.DistText = Drawing.new("Text")
    o.DistText.Size = 13
    o.DistText.Center = true
    o.DistText.Outline = true
    o.DistText.Color = Color3.fromRGB(200, 200, 220)
    o.DistText.Visible = false

    o.HealthBg = Drawing.new("Line")
    o.HealthBg.Thickness = 4
    o.HealthBg.Color = Color3.fromRGB(30, 30, 30)
    o.HealthBg.Visible = false

    o.HealthFg = Drawing.new("Line")
    o.HealthFg.Thickness = 4
    o.HealthFg.Visible = false

    return o
end

local function hideESP(o)
    for _, d in pairs(o) do pcall(function() d.Visible = false end) end
end

local function ensureESP(plr)
    if plr == LocalPlayer then return end
    if espObjects[plr] then return end
    if not hasDrawing then return end
    espObjects[plr] = newESP()
end

for _, p in ipairs(Players:GetPlayers())
