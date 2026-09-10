--[[
    XENO HUB v7.1 — продвинутый ESP + Chams
    Меню видно сразу. Бинд J — скрыть/показать.
--]]

-- ============================================================
-- СЕРВИСЫ
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- КОНФИГ
-- ============================================================
local Config = {
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
    ChamsFillColor = Color3.fromRGB(255, 0, 100),
    ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
    ESPTeamCheck = false,
    EnemyColor = Color3.fromRGB(255, 60, 60),
    AllyColor = Color3.fromRGB(60, 255, 120),
    ESPColor = Color3.fromRGB(170, 0, 255),

    -- Aimbot
    AimbotEnabled = false,
    AimbotKey = Enum.KeyCode.E,
    AimbotPart = "Head",
    FOV = 120,
    Smoothing = 0.15,
    WallCheck = false,
    AimbotTeamCheck = true,
    ShowFOVCircle = true,

    -- Fly
    FlyEnabled = false,
    FlySpeed = 50,

    MenuKey = Enum.KeyCode.J,
    MenuVisible = true,  -- МЕНЮ ВИДНО СРАЗУ
}

-- ============================================================
-- GUI
-- ============================================================
local parentGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Enabled = Config.MenuVisible
ScreenGui.Parent = parentGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Config.ESPColor
mainStroke.Thickness = 2
mainStroke.Transparency = 0.2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Заголовок
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 10
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "XENO HUB  |  1.3.60   [J]"
TitleLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 11

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 11
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    Config.MenuVisible = false
    ScreenGui.Enabled = false
end)

-- Вкладки
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 46)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex = 8
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Контент
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -100)
ContentFrame.Position = UDim2.new(0, 10, 0, 88)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 2

-- ============================================================
-- УТИЛИТЫ UI
-- ============================================================
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

local function createToggle(parent, text, default, callback)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1, -10, 0, 32)
    c.BackgroundTransparency = 1
    c.ZIndex = 3

    local label = Instance.new("TextLabel", c)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4

    local state = default
    local btn = Instance.new("TextButton", c)
    btn.Size = UDim2.new(0, 50, 0, 22)
    btn.Position = UDim2.new(1, -50, 0.5, -11)
    btn.BackgroundColor3 = state and Color3.fromRGB(120, 60, 200) or Color3.fromRGB(50, 50, 65)
    btn.Text = state and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.ZIndex = 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(120, 60, 200) or Color3.fromRGB(50, 50, 65)
        btn.Text = state and "ON" or "OFF"
        pcall(callback, state)
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1, -10, 0, 40)
    c.BackgroundTransparency = 1
    c.ZIndex = 3

    local label = Instance.new("TextLabel", c)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4

    local bg = Instance.new("Frame", c)
    bg.Size = UDim2.new(1, -10, 0, 6)
    bg.Position = UDim2.new(0, 5, 0, 25)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    bg.BorderSizePixel = 0
    bg.ZIndex = 4
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 5
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * rel
        fill.Size = UDim2.new(rel, 0, 1, 0)
        label.Text = text .. ": " .. string.format("%.1f", value)
        pcall(callback, value)
    end
    bg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(i) end
    end)
    bg.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
    end)
end

local function createDropdown(parent, text, optionsFn, callback)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1, -10, 0, 60)
    c.BackgroundTransparency = 1
    c.ZIndex = 3

    local label = Instance.new("TextLabel", c)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4

    local sel = Instance.new("TextButton", c)
    sel.Size = UDim2.new(1, 0, 0, 28)
    sel.Position = UDim2.new(0, 0, 0, 22)
    sel.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    sel.Text = "Выберите..."
    sel.TextColor3 = Color3.fromRGB(220, 220, 240)
    sel.Font = Enum.Font.Gotham
    sel.TextSize = 12
    sel.BorderSizePixel = 0
    sel.ZIndex = 4
    Instance.new("UICorner", sel).CornerRadius = UDim.new(0, 8)

    local list = Instance.new("Frame", c)
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 1, 2)
    list.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    list.BorderSizePixel = 0
    list.ClipsDescendants = true
    list.Visible = false
    list.ZIndex = 20
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 8)

    local isOpen = false
    sel.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        list.Visible = isOpen
        if isOpen then
            for _, ch in ipairs(list:GetChildren()) do
                if ch:IsA("TextButton") then ch:Destroy() end
            end
            local opts = optionsFn()
            for _, opt in ipairs(opts) do
                local b = Instance.new("TextButton", list)
                b.Size = UDim2.new(1, 0, 0, 24)
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                b.Text = opt
                b.TextColor3 = Color3.fromRGB(210, 210, 230)
                b.Font = Enum.Font.Gotham
                b.TextSize = 12
                b.BorderSizePixel = 0
                b.ZIndex = 21
                b.MouseButton1Click:Connect(function()
                    sel.Text = opt
                    list.Visible = false
                    isOpen = false
                    pcall(callback, opt)
                end)
            end
            list.Size = UDim2.new(1, 0, 0, math.min(#opts * 26, 150))
        end
    end)
end

-- ============================================================
-- ВКЛАДКИ
-- ============================================================
local currentPage = nil

local function createTab(name, order)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 92, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order or 0
    btn.ZIndex = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame", ContentFrame)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(120, 60, 200)
    page.Visible = false
    page.ZIndex = 3
    page.CanvasSize = UDim2.new(0, 0, 0, 400)
    page.ScrollingDirection = Enum.ScrollingDirection.Y

    local l = Instance.new("UIListLayout", page)
    l.Padding = UDim.new(0, 8)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment = Enum.HorizontalAlignment.Left

    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        if currentPage then currentPage.Visible = false end
        for _, b in ipairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                b.TextColor3 = Color3.fromRGB(180, 180, 200)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(60, 30, 100)
        btn.TextColor3 = Color3.fromRGB(220, 180, 255)
        page.Visible = true
        currentPage = page
    end)
    return page
end

-- COMBAT
local CombatTab = createTab("Combat", 1)
createToggle(CombatTab, "Aimbot", false, function(s) Config.AimbotEnabled = s end)
createToggle(CombatTab, "Wall Check", false, function(s) Config.WallCheck = s end)
createToggle(CombatTab, "Team Check", true, function(s) Config.AimbotTeamCheck = s end)
createSlider(CombatTab, "FOV", 20, 500, 120, function(v) Config.FOV = v end)
createSlider(CombatTab, "Smoothing", 0, 1, 0.15, function(v) Config.Smoothing = v end)
createDropdown(CombatTab, "Target Part", function() return {"Head", "HumanoidRootPart"} end, function(o) Config.AimbotPart = o end)

-- VISUALS
local VisualsTab = createTab("Visuals", 2)
createToggle(VisualsTab, "ESP Enabled", false, function(s) Config.ESPEnabled = s end)
createToggle(VisualsTab, "Box ESP", true, function(s) Config.BoxESP = s end)
createToggle(VisualsTab, "Box Fill", true, function(s) Config.BoxFill = s end)
createToggle(VisualsTab, "Name Tags", true, function(s) Config.NameTags = s end)
createToggle(VisualsTab, "Health Bars", true, function(s) Config.HealthBars = s end)
createToggle(VisualsTab, "Distance", true, function(s) Config.Distance = s end)
createToggle(VisualsTab, "Tracers", true, function(s) Config.Tracers = s end)
createToggle(VisualsTab, "Head Dot", true, function(s) Config.HeadDot = s end)
createToggle(VisualsTab, "Chams (Highlight)", true, function(s) Config.Chams = s end)
createToggle(VisualsTab, "Team Check (ESP)", false, function(s) Config.ESPTeamCheck = s end)
createToggle(VisualsTab, "FOV Circle", true, function(s) Config.ShowFOVCircle = s end)

-- MOVEMENT
local MovementTab = createTab("Movement", 3)
createToggle(MovementTab, "Fly", false, function(s)
    Config.FlyEnabled = s
    if not s then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("XenoFlyVelocity")
                if bv then bv:Destroy() end
                local bg = hrp:FindFirstChild("XenoFlyGyro")
                if bg then bg:Destroy() end
            end
        end
    end
end)
createSlider(MovementTab, "Fly Speed", 10, 200, 50, function(v) Config.FlySpeed = v end)

-- TELEPORTS
local TeleportTab = createTab("Teleports", 4)
local selectedPlayer = nil
createDropdown(TeleportTab, "Выберите игрока", function()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end, function(o) selectedPlayer = o end)

createButton(TeleportTab, "Teleport к игроку", function()
    if not selectedPlayer then return end
    local target = Players:FindFirstChild(selectedPlayer)
    if not target or not target.Character then return end
    local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local mHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if tHRP and mHRP then
        mHRP.CFrame = tHRP.CFrame + Vector3.new(3, 0, 3)
    end
end)

-- SETTINGS
local SettingsTab = createTab("Settings", 5)
createButton(SettingsTab, "Уничтожить GUI", function() ScreenGui:Destroy() end)

CombatTab.Visible = true
currentPage = CombatTab
for _, b in ipairs(TabBar:GetChildren()) do
    if b:IsA("TextButton") and b.Text == "Combat" then
        b.BackgroundColor3 = Color3.fromRGB(60, 30, 100)
        b.TextColor3 = Color3.fromRGB(220, 180, 255)
    end
end

-- ============================================================
-- БИНД J
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Config.MenuKey then
        Config.MenuVisible = not Config.MenuVisible
        ScreenGui.Enabled = Config.MenuVisible
    end
end)

-- ============================================================
-- CHAMS
-- ============================================================
local chamsObjects = {}

local function ensureChams(plr)
    if plr == LocalPlayer then return end
    if chamsObjects[plr] then return end
    local hl = Instance.new("Highlight")
    hl.Name = "XenoChams"
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = nil
    hl.Parent = ScreenGui
    chamsObjects[plr] = hl
end

local function updateChams()
    for plr, hl in pairs(chamsObjects) do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not Config.ESPEnabled or not Config.Chams or not char or not hum or hum.Health <= 0 then
            hl.Enabled = false
            continue
        end
        if Config.ESPTeamCheck and plr.Team == LocalPlayer.Team then
            hl.Enabled = false
            continue
        end
        hl.Adornee = char
        hl.Enabled = true
        if plr.Team == LocalPlayer.Team then
            hl.FillColor = Config.AllyColor
            hl.OutlineColor = Config.AllyColor
        else
            hl.FillColor = Config.ChamsFillColor
            hl.OutlineColor = Config.ChamsOutlineColor
        end
    end
end

for _, p in ipairs(Players:GetPlayers()) do ensureChams(p) end
Players.PlayerAdded:Connect(function(p) task.wait(1) ensureChams(p) end)
Players.PlayerRemoving:Connect(function(p)
    local hl = chamsObjects[p]
    if hl then hl:Destroy() chamsObjects[p] = nil end
end)

-- ============================================================
-- ESP
-- ============================================================
local espObjects = {}
local hasDrawing = (type(Drawing) == "table" and Drawing.new ~= nil)

local function newESP()
    local objs = {}
    objs.BoxOutline = Drawing.new("Square")
    objs.BoxOutline.Thickness = 3
    objs.BoxOutline.Filled = false
    objs.BoxOutline.Transparency = 1
    objs.BoxOutline.Visible = false

    objs.BoxInner = Drawing.new("Square")
    objs.BoxInner.Thickness = 1
    objs.BoxInner.Filled = false
    objs.BoxInner.Color = Color3.fromRGB(0, 0, 0)
    objs.BoxInner.Transparency = 1
    objs.BoxInner.Visible = false

    objs.BoxFill = Drawing.new("Square")
    objs.BoxFill.Thickness = 1
    objs.BoxFill.Filled = true
    objs.BoxFill.Transparency = 0.85
    objs.BoxFill.Visible = false

    objs.Tracer = Drawing.new("Line")
    objs.Tracer.Thickness = 1.5
    objs.Tracer.Transparency = 1
    objs.Tracer.Visible = false

    objs.HeadDot = Drawing.new("Circle")
    objs.HeadDot.Thickness = 2
    objs.HeadDot.Filled = true
    objs.HeadDot.Transparency = 0.4
    objs.HeadDot.NumSides = 20
    objs.HeadDot.Radius = 5
    objs.HeadDot.Visible = false

    objs.NameOutline = Drawing.new("Text")
    objs.NameOutline.Size = 15
    objs.NameOutline.Center = true
    objs.NameOutline.Outline = true
    objs.NameOutline.Color = Color3.fromRGB(0, 0, 0)
    objs.NameOutline.Visible = false

    objs.Name = Drawing.new("Text")
    objs.Name.Size = 15
    objs.Name.Center = true
    objs.Name.Outline = false
    objs.Name.Color = Color3.fromRGB(255, 255, 255)
    objs.Name.Visible = false

    objs.HPText = Drawing.new("Text")
    objs.HPText.Size = 13
    objs.HPText.Center = true
    objs.HPText.Outline = true
    objs.HPText.Color = Color3.fromRGB(180, 255, 180)
    objs.HPText.Visible = false

    objs.DistText = Drawing.new("Text")
    objs.DistText.Size = 13
    objs.DistText.Center = true
    objs.DistText.Outline = true
    objs.DistText.Color = Color3.fromRGB(200, 200, 220)
    objs.DistText.Visible = false

    objs.HealthBg = Drawing.new("Line")
    objs.HealthBg.Thickness = 4
    objs.HealthBg.Color = Color3.fromRGB(30, 30, 30)
    objs.HealthBg.Visible = false

    objs.HealthFg = Drawing.new("Line")
    objs.HealthFg.Thickness = 4
    objs.HealthFg.Visible = false

    return objs
end

local function ensureESP(plr)
    if plr == LocalPlayer then return end
    if espObjects[plr] then return end
    if not hasDrawing then return end
    espObjects[plr] = newESP()
end

local function hideESP(objs)
    for _, o in pairs(objs) do
        pcall(function() o.Visible = false end)
    end
end

for _, p in ipairs(Players:GetPlayers()) do ensureESP(p) end
Players.PlayerAdded:Connect(function(p) task.wait(1) ensureESP(p) end)
Players.PlayerRemoving:Connect(function(p)
    local objs = espObjects[p]
    if objs then
        for _, o in pairs(objs) do pcall(function() o:Remove() end) end
        espObjects[p] = nil
    end
end)

local function getESPColor(plr)
    if plr.Team == LocalPlayer.Team then return Config.AllyColor end
    return Config.EnemyColor
end

local function updateESP()
    if not Config.ESPEnabled or not hasDrawing then
        for _, objs in pairs(espObjects) do hideESP(objs) end
        return
    end

    for plr, objs in pairs(espObjects) do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not hrp or not hum or hum.Health <= 0 then
            hideESP(objs)
            continue
        end
        if Config.ESPTeamCheck and plr.Team == LocalPlayer.Team then
            hideESP(objs)
            continue
        end

        local sp, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then
            hideESP(objs)
            continue
        end

        local color = getESPColor(plr)

        local topPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.5, 0))
        local botPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
        local boxH = math.abs(topPos.Y - botPos.Y)
        local boxW = boxH * 0.55
        local boxX = sp.X - boxW / 2
        local boxY = sp.Y - boxH / 2

        if Config.BoxESP then
            objs.BoxOutline.Size = Vector2.new(boxW, boxH)
            objs.BoxOutline.Position = Vector2.new(boxX, boxY)
            objs.BoxOutline.Color = color
            objs.BoxOutline.Visible = true

            objs.BoxInner.Size = Vector2.new(boxW - 2, boxH - 2)
            objs.BoxInner.Position = Vector2.new(boxX + 1, boxY + 1)
            objs.BoxInner.Visible = true

            if Config.BoxFill then
                objs.BoxFill.Size = Vector2.new(boxW - 4, boxH - 4)
                objs.BoxFill.Position = Vector2.new(boxX + 2, boxY + 2)
                objs.BoxFill.Color = color
                objs.BoxFill.Visible = true
            else
                objs.BoxFill.Visible = false
            end
        else
            objs.BoxOutline.Visible = false
            objs.BoxInner.Visible = false
            objs.BoxFill.Visible = false
        end

        if Config.HeadDot and head then
            local headPos = Camera:WorldToViewportPoint(head.Position)
            objs.HeadDot.Position = Vector2.new(headPos.X, headPos.Y)
            objs.HeadDot.Color = color
            objs.HeadDot.Visible = true
        else
            objs.HeadDot.Visible = false
        end

        if Config.NameTags then
            objs.NameOutline.Text = plr.Name
            objs.NameOutline.Position = Vector2.new(sp.X, boxY - 20)
            objs.NameOutline.Visible = true
            objs.Name.Text = plr.Name
            objs.Name.Position = Vector2.new(sp.X, boxY - 20)
            objs.Name.Visible = true
        else
            objs.NameOutline.Visible = false
            objs.Name.Visible = false
        end

        if Config.HealthBars then
            local hp = math.floor(hum.Health)
            local maxHp = math.floor(hum.MaxHealth)
            objs.HPText.Text = hp .. " / " .. maxHp
            objs.HPText.Position = Vector2.new(sp.X, boxY + boxH + 4)
            objs.HPText.Color = Color3.fromRGB(180 + 75 * (1 - hum.Health / hum.MaxHealth), 255, 180)
            objs.HPText.Visible = true
        else
            objs.HPText.Visible = false
        end

        if Config.Distance then
            local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            objs.DistText.Text = "[" .. dist .. "m]"
            objs.DistText.Position = Vector2.new(sp.X, boxY + boxH + 20)
            objs.DistText.Visible = true
        else
            objs.DistText.Visible = false
        end

        if Config.Tracers then
            local origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            objs.Tracer.From = origin
            objs.Tracer.To = Vector2.new(sp.X, boxY)
            objs.Tracer.Color = color
            objs.Tracer.Visible = true
        else
            objs.Tracer.Visible = false
        end

        if Config.HealthBars then
            local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barX = boxX - 7
            objs.HealthBg.From = Vector2.new(barX, boxY)
            objs.HealthBg.To = Vector2.new(barX, boxY + boxH)
            objs.HealthBg.Visible = true
            objs.HealthFg.From = Vector2.new(barX, boxY + boxH * (1 - hpPct))
            objs.HealthFg.To = Vector2.new(barX, boxY + boxH)
            local r = 1 - hpPct
            local g = hpPct
            objs.HealthFg.Color = Color3.new(r, g, 0)
            objs.HealthFg.Visible = true
        else
            objs.HealthBg.Visible = false
            objs.HealthFg.Visible = false
        end
    end
end

-- ============================================================
-- AIMBOT
-- ============================================================
local fovCircle
if hasDrawing then
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1
    fovCircle.Color = Config.ESPColor
    fovCircle.Filled = false
    fovCircle.Transparency = 0.5
    fovCircle.NumSides = 60
    fovCircle.Visible = false
end

local function getClosest()
    local closest, shortest = nil, Config.FOV
    local mp = UserInputService:GetMouseLocation()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if Config.AimbotTeamCheck and plr.Team == LocalPlayer.Team then continue end
        local char = plr.Character
        if not char then continue end
        local part = char:FindFirstChild(Config.AimbotPart) or char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not part or not hum or hum.Health <= 0 then continue end

        if Config.WallCheck then
            local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 500)
            local hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
            if not hit or not hit:IsDescendantOf(char) then continue end
        end

        local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end
        local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
        if d < shortest then
            shortest = d
            closest = part
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if fovCircle and Config.ShowFOVCircle and Config.AimbotEnabled then
        fovCircle.Position = UserInputService:GetMouseLocation()
        fovCircle.Radius = Config.FOV
        fovCircle.Visible = true
        fovCircle.Color = Config.ESPColor
    elseif fovCircle then
        fovCircle.Visible = false
    end

    if Config.AimbotEnabled and UserInputService:IsKeyDown(Config.AimbotKey) then
        local target = getClosest()
        if target then
            local sp = Camera:WorldToViewportPoint(target.Position)
            local mp = UserInputService:GetMouseLocation()
            local dx = (sp.X - mp.X) * (1 - Config.Smoothing)
            local dy = (sp.Y - mp.Y) * (1 - Config.Smoothing)
            if mousemoverel then
                pcall(function() mousemoverel(dx, dy) end)
            end
        end
    end

    updateESP()
    updateChams()
end)

-- ============================================================
-- FLY
-- ============================================================
local flyBV, flyBG
RunService.RenderStepped:Connect(function()
    if not Config.FlyEnabled then
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        return
    end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not flyBV or flyBV.Parent ~= hrp then
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "XenoFlyVelocity"
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBV.Velocity = Vector3.zero
        flyBV.Parent = hrp
        flyBG = Instance.new("BodyGyro")
        flyBG.Name = "XenoFlyGyro"
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.P = 1000
        flyBG.D = 50
        flyBG.Parent = hrp
    end

    local move = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end

    if move.Magnitude > 0 then
        flyBV.Velocity = move.Unit * Config.FlySpeed
    else
        flyBV.Velocity = Vector3.zero
    end
    flyBG.CFrame = Camera.CFrame
end)

print("[XENO HUB] Загружен. Меню видно. Бинд J — скрыть/показать.")
