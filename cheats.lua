-- War Tycoon Hub v16 | Bind: J | Delta + Xeno
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local HS=game:GetService("HttpService")
local LP=Players.LocalPlayer
local Camera=Workspace.CurrentCamera

local parentGui
local okHui,hui=pcall(function() return gethui() end)
if okHui and hui then parentGui=hui else
    local okCore,core=pcall(function() return game:GetService("CoreGui") end)
    if okCore and core then parentGui=core else parentGui=LP:WaitForChild("PlayerGui") end
end

local CONFIG_LAST="wt_last.json"
local CONFIG_LIST="wt_list.json"
local Lang="EN"

local T={
RU={
tab_combat="Бой",tab_visual="Визуал",tab_move="Движение",tab_tp="Телепорт",tab_settings="Настройки",
sec_aim="ПРИЦЕЛ",sec_hitbox="ХИТБОКС",sec_esp="ESP ИГРОКОВ",sec_chams="ПОДСВЕТКА",sec_vesp="ТЕХНИКА",
sec_veh="ТЕХНИКА",sec_player="ИГРОК",sec_tp_player="К ИГРОКУ",sec_tp_objects="К ОБЪЕКТАМ",sec_tp_marks="МЕТКИ",
sec_colors="ЦВЕТА ТЕМЫ",sec_size="РАЗМЕР МЕНЮ",sec_lang="ЯЗЫК",sec_config="КОНФИГ",sec_world="МИР",sec_help="СПРАВКА",
aim="Аимбот (центр)",team="Проверка команды",wall="Проверка стен",fov="Радиус захвата",
hitbox="Увеличение хитбокса",hitbox_size="Размер хитбокса",
esp="ESP игроков",box="Квадрат",name="Никнейм",hp="Здоровье",dist="Дистанция",esp_team="Проверка команды (ESP)",
chams="Подсветка сквозь стены",world="ESP техники",veh_fly="Полёт техники",
fly="Полёт",fly_speed="Скорость полёта",noclip="Сквозь стены",
walk="Своя скорость",walk_speed="Скорость ходьбы",jump="Свой прыжок",jump_power="Сила прыжка",
select_player="Выберите игрока",no_players="Нет других игроков",
tp_player="Телепорт к игроку",tp_airdrop="К аирдропу",tp_oil="К нефти",tp_capture="К точке захвата",
tp_veh="К технике",save_pos="Сохранить позицию",load_pos="Вернуться",
red="Красный",blue="Синий",purple="Фиолет",green="Зелёный",cyan="Голубой",orange="Оранж",yellow="Жёлтый",pink="Розовый",
scale="Масштаб",apply="Применить",save_cfg="Сохранить под именем",load_cfg="Загрузить по имени",
list_cfgs="Список конфигов",reset_move="Сбросить движение",cfg_name="Имя конфига",
fullbright="Полная яркость",lang_ru="🇷🇺 Русский",lang_en="🇬🇧 English",
on="ВКЛ",off="ВЫКЛ",bind_ph="—",bind_sub="Escape — отмена",bind_for="Бинд: ",
help="/aim /esp /fly /noclip\n/chams /world /fb /menu\n/hitbox /reset /save /load",
},
EN={
tab_combat="Combat",tab_visual="Visuals",tab_move="Movement",tab_tp="Teleport",tab_settings="Settings",
sec_aim="AIM",sec_hitbox="HITBOX",sec_esp="PLAYER ESP",sec_chams="CHAMS",sec_vesp="VEHICLES",
sec_veh="VEHICLE",sec_player="PLAYER",sec_tp_player="TO PLAYER",sec_tp_objects="TO OBJECTS",sec_tp_marks="WAYPOINTS",
sec_colors="THEME COLORS",sec_size="MENU SIZE",sec_lang="LANGUAGE",sec_config="CONFIG",sec_world="WORLD",sec_help="HELP",
aim="Aimbot (centered)",team="Team Check",wall="Wall Check",fov="FOV",
hitbox="Hitbox Extender",hitbox_size="Hitbox Size",
esp="Player ESP",box="Box",name="Name",hp="Health",dist="Distance",esp_team="Team Check (ESP)",
chams="Chams",world="Vehicle ESP",veh_fly="Vehicle Fly",
fly="Fly",fly_speed="Fly Speed",noclip="Noclip",
walk="Custom WalkSpeed",walk_speed="WalkSpeed",jump="Custom JumpPower",jump_power="JumpPower",
select_player="Select player",no_players="No other players",
tp_player="Teleport to player",tp_airdrop="To Airdrop",tp_oil="To Oil Rig",tp_capture="To Capture",
tp_veh="To Vehicle",save_pos="Save position",load_pos="Return",
red="Red",blue="Blue",purple="Purple",green="Green",cyan="Cyan",orange="Orange",yellow="Yellow",pink="Pink",
scale="Scale",apply="Apply",save_cfg="Save as",load_cfg="Load by name",
list_cfgs="List configs",reset_move="Reset movement",cfg_name="Config name",
fullbright="Fullbright",lang_ru="🇷🇺 Русский",lang_en="🇬🇧 English",
on="ON",off="OFF",bind_ph="—",bind_sub="Escape — cancel",bind_for="Bind: ",
help="/aim /esp /fly /noclip\n/chams /world /fb /menu\n/hitbox /reset /save /load",
}}

local Config={
AccentR=108,AccentG=92,AccentB=231,
Bg=Color3.fromRGB(16,16,20),Bg2=Color3.fromRGB(22,22,28),Panel=Color3.fromRGB(28,28,36),
Divider=Color3.fromRGB(40,40,50),Text=Color3.fromRGB(230,230,240),TextDim=Color3.fromRGB(150,150,165),
Scale=1,Aim=false,FOV=150,TeamCheck=true,WallCheck=false,
Hitbox=false,HitboxSize=3,
ESP=false,ESPBox=true,ESPName=true,ESPHealth=true,ESPDist=true,ESPTeam=false,Chams=false,
WorldESP=false,VehicleFly=false,Fly=false,FlySpeed=60,Noclip=false,
WalkSpeed=false,WalkSpeedVal=32,JumpPower=false,JumpPowerVal=65,
Fullbright=false,Lang="EN"}
Config.Accent=Color3.fromRGB(Config.AccentR,Config.AccentG,Config.AccentB)

local Binds={Aim=nil,ESP=nil,Chams=nil,WorldESP=nil,Fly=nil,Noclip=nil,WalkSpeed=nil,JumpPower=nil,Hitbox=nil,Fullbright=nil,VehicleFly=nil}

local function listConfigs()
    if not isfile or not readfile or not isfile(CONFIG_LIST) then return {} end
    local ok,res=pcall(function() return HS:JSONDecode(readfile(CONFIG_LIST)) end)
    return ok and res or {}
end
local function addToConfigList(name)
    local list=listConfigs()
    if not table.find(list,name) then
        table.insert(list,name)
        pcall(function() writefile(CONFIG_LIST,HS:JSONEncode(list)) end)
    end
end
local function saveConfigAs(name)
    if not writefile then return end
    local data={config={},binds={}}
    for k,v in pairs(Config) do
        if type(v)=="boolean" or type(v)=="number" or type(v)=="string" then data.config[k]=v end
    end
    for k,v in pairs(Binds) do if v then data.binds[k]=v end end
    pcall(function() writefile("wt_"..name..".json",HS:JSONEncode(data)) end)
    addToConfigList(name)
    pcall(function() writefile(CONFIG_LAST,name) end)
end
local function loadConfigAs(name)
    if not isfile or not readfile then return end
    pcall(function()
        local path="wt_"..name..".json"
        if not isfile(path) then return end
        local data=HS:JSONDecode(readfile(path))
        if data.config then
            for k,v in pairs(data.config) do
                if Config[k]~=nil and (type(v)=="boolean" or type(v)=="number" or type(v)=="string") then Config[k]=v end
            end
        end
        if data.binds then
            for k,v in pairs(data.binds) do
                if Binds[k]~=nil and type(v)=="string" then Binds[k]=v end
            end
        end
        if Config.AccentR then Config.Accent=Color3.fromRGB(Config.AccentR,Config.AccentG,Config.AccentB) end
        Lang=Config.Lang or "EN"
        pcall(function() writefile(CONFIG_LAST,name) end)
    end)
end
local function saveConfig()
    if not writefile then return end
    local lastName="default"
    if isfile and readfile and isfile(CONFIG_LAST) then
        pcall(function() lastName=readfile(CONFIG_LAST) end)
    end
    saveConfigAs(lastName)
end

if isfile and readfile and isfile(CONFIG_LAST) then
    local lastName
    pcall(function() lastName=readfile(CONFIG_LAST) end)
    if lastName and lastName~="" then loadConfigAs(lastName) end
end

local SG=Instance.new("ScreenGui")
SG.Name="WarTycoonHub"
SG.ResetOnSpawn=false
SG.IgnoreGuiInset=true
SG.DisplayOrder=999999
SG.Parent=parentGui

local vp=Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
local autoScale=math.min((vp.X-60)/860,(vp.Y-100)/500,1.0)
Config.Scale=autoScale

local Main=Instance.new("Frame",SG)
Main.Size=UDim2.fromOffset(860,500)
Main.AnchorPoint=Vector2.new(0.5,0.5)
Main.Position=UDim2.new(0.5,0,0.5,0)
Main.BackgroundColor3=Config.Bg
Main.BorderSizePixel=0
Main.Active=true
Main.Draggable=true
Main.ZIndex=10
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,10)
local MainScale=Instance.new("UIScale",Main)
MainScale.Scale=autoScale

local Header=Instance.new("Frame",Main)
Header.Size=UDim2.new(1,0,0,42)
Header.BackgroundColor3=Config.Bg
Header.BorderSizePixel=0
Header.ZIndex=11
Instance.new("UICorner",Header).CornerRadius=UDim.new(0,10)

local HeaderLine=Instance.new("Frame",Header)
HeaderLine.Size=UDim2.new(1,0,0,1)
HeaderLine.Position=UDim2.new(0,0,1,-1)
HeaderLine.BackgroundColor3=Config.Divider
HeaderLine.BorderSizePixel=0
HeaderLine.ZIndex=12

local Title=Instance.new("TextLabel",Header)
Title.Position=UDim2.fromOffset(18,0)
Title.Size=UDim2.fromOffset(300,42)
Title.BackgroundTransparency=1
Title.Text="WAR TYCOON"
Title.Font=Enum.Font.GothamBold
Title.TextSize=15
Title.TextColor3=Config.Text
Title.TextXAlignment=Enum.TextXAlignment.Left
Title.ZIndex=12

local CloseBtn=Instance.new("TextButton",Header)
CloseBtn.Size=UDim2.fromOffset(30,30)
CloseBtn.Position=UDim2.new(1,-38,0,6)
CloseBtn.BackgroundColor3=Color3.fromRGB(35,35,45)
CloseBtn.Text="✕"
CloseBtn.TextColor3=Color3.fromRGB(220,100,100)
CloseBtn.Font=Enum.Font.GothamBold
CloseBtn.TextSize=14
CloseBtn.BorderSizePixel=0
CloseBtn.Active=true
CloseBtn.Selectable=false
CloseBtn.ZIndex=12
Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(0,6)
CloseBtn.MouseButton1Click:Connect(function() SG.Enabled=false end)
CloseBtn.TouchTap:Connect(function() SG.Enabled=false end)

local Sidebar=Instance.new("Frame",Main)
Sidebar.Size=UDim2.fromOffset(200,458)
Sidebar.Position=UDim2.fromOffset(0,42)
Sidebar.BackgroundColor3=Config.Bg
Sidebar.BorderSizePixel=0
Sidebar.ZIndex=11

local SidebarLine=Instance.new("Frame",Sidebar)
SidebarLine.Size=UDim2.new(0,1,1,0)
SidebarLine.Position=UDim2.new(1,-1,0,0)
SidebarLine.BackgroundColor3=Config.Divider
SidebarLine.BorderSizePixel=0
SidebarLine.ZIndex=12

local Content=Instance.new("Frame",Main)
Content.Size=UDim2.new(1,-200,1,-42)
Content.Position=UDim2.fromOffset(200,42)
Content.BackgroundTransparency=1
Content.ZIndex=11

local acc={sliders={},toggles={},sections={},buttons={},tabs={}}
local labels={}

local function applyAccent(c)
    Config.Accent=c
    Config.AccentR=math.floor(c.R*255)
    Config.AccentG=math.floor(c.G*255)
    Config.AccentB=math.floor(c.B*255)
    for _,t in ipairs(acc.tabs) do if t.active then t.btn.TextColor3=c end end
    for _,t in ipairs(acc.toggles) do if t.state then t.btn.BackgroundColor3=c end end
    for _,f in ipairs(acc.sliders) do f.BackgroundColor3=c end
    if fovCircle then fovCircle.Color=c end
    if chamsObjects then
        for _,hl in pairs(chamsObjects) do hl.FillColor=c;hl.OutlineColor=c end
    end
    saveConfig()
end

-- ХЕЛПЕРЫ UI
local function section(p,t,labelKey)
    local holder=Instance.new("Frame",p)
    holder.Size=UDim2.new(1,0,0,26)
    holder.BackgroundTransparency=1
    holder.ZIndex=13
    local l=Instance.new("TextLabel",holder)
    l.Size=UDim2.new(1,0,1,0)
    l.BackgroundTransparency=1
    l.Text=t
    l.Font=Enum.Font.GothamBold
    l.TextSize=11
    l.TextColor3=Config.TextDim
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextYAlignment=Enum.TextYAlignment.Center
    l.ZIndex=14
    if labelKey then table.insert(labels,{obj=l,key=labelKey}) end
    local line=Instance.new("Frame",holder)
    line.Size=UDim2.new(1,0,0,1)
    line.Position=UDim2.new(0,0,1,0)
    line.BackgroundColor3=Config.Divider
    line.BorderSizePixel=0
    line.ZIndex=13
    return l
end

_G.WT_BINDING=false
local function openBindPicker(bindKey,labelTxt,updateLabel)
    if _G.WT_BINDING then return end
    _G.WT_BINDING=true
    local picker=Instance.new("Frame",SG)
    picker.Size=UDim2.fromOffset(340,120)
    picker.AnchorPoint=Vector2.new(0.5,0.5)
    picker.Position=UDim2.new(0.5,0,0.5,0)
    picker.BackgroundColor3=Config.Bg2
    picker.BorderSizePixel=0
    picker.ZIndex=100
    Instance.new("UICorner",picker).CornerRadius=UDim.new(0,10)
    local bst=Instance.new("UIStroke",picker)
    bst.Color=Config.Accent
    bst.Thickness=1.5

    local lt=Instance.new("TextLabel",picker)
    lt.Size=UDim2.new(1,-20,0,30)
    lt.Position=UDim2.new(0,10,0,15)
    lt.BackgroundTransparency=1
    lt.Text=T[Lang].bind_for..labelTxt
    lt.TextColor3=Config.Text
    lt.Font=Enum.Font.GothamBold
    lt.TextSize=13
    lt.ZIndex=101

    local sub=Instance.new("TextLabel",picker)
    sub.Size=UDim2.new(1,-20,0,20)
    sub.Position=UDim2.new(0,10,0,42)
    sub.BackgroundTransparency=1
    sub.Text=T[Lang].bind_sub
    sub.TextColor3=Config.TextDim
    sub.Font=Enum.Font.Gotham
    sub.TextSize=11
    sub.ZIndex=101

    local cancel=Instance.new("TextButton",picker)
    cancel.Size=UDim2.new(1,-20,0,28)
    cancel.Position=UDim2.new(0,10,1,-38)
    cancel.BackgroundColor3=Color3.fromRGB(40,40,50)
    cancel.Text="✕"
    cancel.TextColor3=Color3.fromRGB(220,100,100)
    cancel.Font=Enum.Font.GothamBold
    cancel.TextSize=14
    cancel.BorderSizePixel=0
    cancel.Active=true
    cancel.Selectable=false
    cancel.ZIndex=101
    Instance.new("UICorner",cancel).CornerRadius=UDim.new(0,6)

    local closed=false
    local function close()
        if closed then return end
        closed=true
        picker:Destroy()
        _G.WT_BINDING=false
    end
    cancel.MouseButton1Click:Connect(close)
    cancel.TouchTap:Connect(close)

    -- ЛОВИМ ЛЮБУЮ КЛАВИАТУРУ (в т.ч. мобильную Delta)
    local conn
    conn=UIS.InputBegan:Connect(function(input,gpe)
        if closed then conn:Disconnect() return end
        if input.UserInputType==Enum.UserInputType.Keyboard then
            if input.KeyCode==Enum.KeyCode.Escape then
                close();conn:Disconnect();return
            end
            Binds[bindKey]=input.KeyCode.Name
            saveConfig()
            updateLabel(input.KeyCode.Name)
            close();conn:Disconnect();return
        end
        if input.UserInputType==Enum.UserInputType.MouseWheel then
            local wn=(input.Position.Z>0) and "WheelUp" or "WheelDown"
            Binds[bindKey]=wn
            saveConfig()
            updateLabel(wn)
            close();conn:Disconnect();return
        end
    end)
end

local toggleRefs={}
local function toggle(p,t,d,cb,bindKey,labelKey)
    local c=Instance.new("Frame",p)
    c.Size=UDim2.new(1,0,0,40)
    c.BackgroundTransparency=1
    c.ZIndex=13

    local l=Instance.new("TextLabel",c)
    if bindKey then l.Size=UDim2.new(1,-180,1,0) else l.Size=UDim2.new(1,-70,1,0) end
    l.BackgroundTransparency=1
    l.Text=t
    l.TextColor3=Config.Text
    l.Font=Enum.Font.GothamMedium
    l.TextSize=12
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.ZIndex=14
    if labelKey then table.insert(labels,{obj=l,key=labelKey}) end

    if bindKey then
        local bTxt=Binds[bindKey] or T[Lang].bind_ph
        local bindBtn=Instance.new("TextButton",c)
        bindBtn.Size=UDim2.fromOffset(56,22)
        bindBtn.Position=UDim2.new(1,-112,0.5,-11)
        bindBtn.BackgroundColor3=Color3.fromRGB(35,35,45)
        bindBtn.Text=bTxt
        bindBtn.TextColor3=Config.TextDim
        bindBtn.Font=Enum.Font.GothamBold
        bindBtn.TextSize=10
        bindBtn.BorderSizePixel=0
        bindBtn.Active=true
        bindBtn.Selectable=false
        bindBtn.ZIndex=14
        Instance.new("UICorner",bindBtn).CornerRadius=UDim.new(0,6)
        bindBtn.MouseButton1Click:Connect(function()
            openBindPicker(bindKey,l.Text,function(k) bindBtn.Text=k end)
        end)
        bindBtn.TouchTap:Connect(function()
            openBindPicker(bindKey,l.Text,function(k) bindBtn.Text=k end)
        end)
    end

    local st=d
    local b=Instance.new("TextButton",c)
    b.Size=UDim2.fromOffset(48,22)
    b.Position=UDim2.new(1,-50,0.5,-11)
    b.BackgroundColor3=st and Config.Accent or Color3.fromRGB(45,45,55)
    b.Text=st and T[Lang].on or T[Lang].off
    b.TextColor3=Color3.fromRGB(255,255,255)
    b.Font=Enum.Font.GothamBold
    b.TextSize=10
    b.BorderSizePixel=0
    b.Active=true
    b.Selectable=false
    b.ZIndex=14
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)

    local ref
    ref={state=st,btn=b,set=function(v)
        st=v
        ref.state=v
        b.BackgroundColor3=v and Config.Accent or Color3.fromRGB(45,45,55)
        b.Text=v and T[Lang].on or T[Lang].off
        pcall(cb,v)
        saveConfig()
    end}
    table.insert(acc.toggles,ref)
    if bindKey then toggleRefs[bindKey]=ref end

    local function flip()
        st=not st
        ref.state=st
        b.BackgroundColor3=st and Config.Accent or Color3.fromRGB(45,45,55)
        b.Text=st and T[Lang].on or T[Lang].off
        pcall(cb,st)
        saveConfig()
    end
    b.MouseButton1Click:Connect(flip)
    b.TouchTap:Connect(flip)
    return ref
end

local sliderRefs={}
local function slider(p,t,mn,mx,d,cb,labelKey)
    local c=Instance.new("Frame",p)
    c.Size=UDim2.new(1,0,0,46)
    c.BackgroundTransparency=1
    c.ZIndex=13
    local l=Instance.new("TextLabel",c)
    l.Size=UDim2.new(1,-80,0,20)
    l.BackgroundTransparency=1
    l.Text=t
    l.TextColor3=Config.Text
    l.Font=Enum.Font.GothamMedium
    l.TextSize=12
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.ZIndex=14
    if labelKey then table.insert(labels,{obj=l,key=labelKey,slider=true}) end
    local valLbl=Instance.new("TextLabel",c)
    valLbl.Size=UDim2.fromOffset(60,20)
    valLbl.Position=UDim2.new(1,-60,0,0)
    valLbl.BackgroundTransparency=1
    valLbl.Text=string.format("%.1f",d)
    valLbl.TextColor3=Config.Accent
    valLbl.Font=Enum.Font.GothamBold
    valLbl.TextSize=12
    valLbl.TextXAlignment=Enum.TextXAlignment.Right
    valLbl.ZIndex=14
    local bg=Instance.new("Frame",c)
    bg.Size=UDim2.new(1,0,0,5)
    bg.Position=UDim2.new(0,0,0,30)
    bg.BackgroundColor3=Color3.fromRGB(40,40,50)
    bg.BorderSizePixel=0
    bg.ZIndex=14
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)
    local f=Instance.new("Frame",bg)
    f.Size=UDim2.new((d-mn)/(mx-mn),0,1,0)
    f.BackgroundColor3=Config.Accent
    f.BorderSizePixel=0
    f.ZIndex=15
    Instance.new("UICorner",f).CornerRadius=UDim.new(1,0)
    table.insert(acc.sliders,f)
    local drag=false
    local ref
    ref={set=function(v)
        v=math.clamp(v,mn,mx)
        f.Size=UDim2.new((v-mn)/(mx-mn),0,1,0)
        valLbl.Text=string.format("%.1f",v)
        pcall(cb,v)
    end}
    if labelKey then sliderRefs[labelKey]=ref end
    local function upd(i)
        local r=math.clamp((i.Position.X-bg.AbsolutePosition.X)/math.max(bg.AbsoluteSize.X,1),0,1)
        local v=mn+(mx-mn)*r
        f.Size=UDim2.new(r,0,1,0)
        valLbl.Text=string.format("%.1f",v)
        pcall(cb,v)
    end
    bg.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true
            upd(i)
        end
    end)
    bg.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=false
            saveConfig()
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            upd(i)
        end
    end)
    return ref
end

local function colorBtn(p,t,col,cb,labelKey)
    local c=Instance.new("Frame",p)
    c.Size=UDim2.new(1,0,0,34)
    c.BackgroundTransparency=1
    c.ZIndex=13
    local l=Instance.new("TextLabel",c)
    l.Size=UDim2.new(1,-50,1,0)
    l.BackgroundTransparency=1
    l.Text=t
    l.TextColor3=Config.Text
    l.Font=Enum.Font.Gotham
    l.TextSize=12
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.ZIndex=14
    if labelKey then table.insert(labels,{obj=l,key=labelKey}) end
    local b=Instance.new("TextButton",c)
    b.Size=UDim2.fromOffset(24,24)
    b.Position=UDim2.new(1,-24,0.5,-12)
    b.BackgroundColor3=col
    b.Text=""
    b.BorderSizePixel=0
    b.Active=true
    b.Selectable=false
    b.ZIndex=14
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(function() pcall(cb) end)
    b.TouchTap:Connect(function() pcall(cb) end)
end

local function button(p,t,cb,labelKey)
    local b=Instance.new("TextButton",p)
    b.Size=UDim2.new(1,0,0,32)
    b.BackgroundColor3=Color3.fromRGB(35,35,45)
    b.Text=t
    b.TextColor3=Config.Text
    b.Font=Enum.Font.GothamMedium
    b.TextSize=12
    b.BorderSizePixel=0
    b.Active=true
    b.Selectable=false
    b.ZIndex=14
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    table.insert(acc.buttons,b)
    b.MouseButton1Click:Connect(function() pcall(cb) end)
    b.TouchTap:Connect(function() pcall(cb) end)
    if labelKey then table.insert(labels,{obj=b,key=labelKey}) end
    return b
end

local pages,currentPage={},nil

local function createTab(name,order,labelKey)
    local btn=Instance.new("TextButton",Sidebar)
    btn.Size=UDim2.new(1,-24,0,38)
    btn.Position=UDim2.fromOffset(12,12+(order-1)*42)
    btn.BackgroundColor3=Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency=1
    btn.Text=name
    btn.TextColor3=Config.TextDim
    btn.Font=Enum.Font.GothamMedium
    btn.TextSize=13
    btn.BorderSizePixel=0
    btn.TextXAlignment=Enum.TextXAlignment.Left
    btn.Active=true
    btn.Selectable=false
    btn.ZIndex=12
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    local pad=Instance.new("UIPadding",btn)
    pad.PaddingLeft=UDim.new(0,14)
    if labelKey then table.insert(labels,{obj=btn,key=labelKey,tab=true}) end

    local page=Instance.new("ScrollingFrame",Content)
    page.Size=UDim2.fromScale(1,1)
    page.BackgroundTransparency=1
    page.BorderSizePixel=0
    page.ScrollBarThickness=4
    page.ScrollBarImageColor3=Config.Accent
    page.CanvasSize=UDim2.new(0,0,0,700)
    page.Visible=false
    page.ZIndex=12
    local l=Instance.new("UIListLayout",page)
    l.Padding=UDim.new(0,4)
    l.SortOrder=Enum.SortOrder.LayoutOrder
    local pad2=Instance.new("UIPadding",page)
    pad2.PaddingLeft=UDim.new(0,14)
    pad2.PaddingRight=UDim.new(0,14)
    pad2.PaddingTop=UDim.new(0,6)
    pad2.PaddingBottom=UDim.new(0,14)

    local ref={btn=btn,active=false,key=labelKey}
    table.insert(acc.tabs,ref)

    local function select()
        if currentPage then currentPage.Visible=false end
        for _,r in ipairs(acc.tabs) do
            r.active=false
            r.btn.BackgroundTransparency=1
            r.btn.TextColor3=Config.TextDim
        end
        ref.active=true
        btn.BackgroundColor3=Config.Panel
        btn.BackgroundTransparency=0
        btn.TextColor3=Config.Accent
        page.Visible=true
        currentPage=page
    end
    btn.MouseButton1Click:Connect(select)
    btn.TouchTap:Connect(select)
    pages[labelKey or name]={page=page,button=btn,ref=ref}
    return page
end

local CombatTab=createTab(T[Lang].tab_combat,1,"tab_combat")
local VisualsTab=createTab(T[Lang].tab_visual,2,"tab_visual")
local MoveTab=createTab(T[Lang].tab_move,3,"tab_move")
local TPTab=createTab(T[Lang].tab_tp,4,"tab_tp")
local SettingsTab=createTab(T[Lang].tab_settings,5,"tab_settings")

-- БОЙ
section(CombatTab,T[Lang].sec_aim,"sec_aim")
toggle(CombatTab,T[Lang].aim,false,function(v) Config.Aim=v end,"Aim","aim")
toggle(CombatTab,T[Lang].team,true,function(v) Config.TeamCheck=v end,nil,"team")
toggle(CombatTab,T[Lang].wall,false,function(v) Config.WallCheck=v end,nil,"wall")
slider(CombatTab,T[Lang].fov,20,600,150,function(v) Config.FOV=v end,"fov")
section(CombatTab,T[Lang].sec_hitbox,"sec_hitbox")
toggle(CombatTab,T[Lang].hitbox,false,function(v) Config.Hitbox=v end,"Hitbox","hitbox")
slider(CombatTab,T[Lang].hitbox_size,1,10,3,function(v) Config.HitboxSize=v end,"hitbox_size")

-- ВИЗУАЛ
section(VisualsTab,T[Lang].sec_esp,"sec_esp")
toggle(VisualsTab,T[Lang].esp,false,function(v) Config.ESP=v end,"ESP","esp")
toggle(VisualsTab,T[Lang].box,true,function(v) Config.ESPBox=v end,nil,"box")
toggle(VisualsTab,T[Lang].name,true,function(v) Config.ESPName=v end,nil,"name")
toggle(VisualsTab,T[Lang].hp,true,function(v) Config.ESPHealth=v end,nil,"hp")
toggle(VisualsTab,T[Lang].dist,true,function(v) Config.ESPDist=v end,nil,"dist")
toggle(VisualsTab,T[Lang].esp_team,false,function(v) Config.ESPTeam=v end,nil,"esp_team")
section(VisualsTab,T[Lang].sec_chams,"sec_chams")
toggle(VisualsTab,T[Lang].chams,false,function(v) Config.Chams=v end,"Chams","chams")
section(VisualsTab,T[Lang].sec_vesp,"sec_vesp")
toggle(VisualsTab,T[Lang].world,false,function(v) Config.WorldESP=v end,"WorldESP","world")

-- ДВИЖЕНИЕ
section(MoveTab,T[Lang].sec_veh,"sec_veh")
toggle(MoveTab,T[Lang].veh_fly,false,function(v) Config.VehicleFly=v end,"VehicleFly","veh_fly")
section(MoveTab,T[Lang].sec_player,"sec_player")
toggle(MoveTab,T[Lang].fly,false,function(v) Config.Fly=v end,"Fly","fly")
slider(MoveTab,T[Lang].fly_speed,10,300,60,function(v) Config.FlySpeed=v end,"fly_speed")
toggle(MoveTab,T[Lang].noclip,false,function(v) Config.Noclip=v end,"Noclip","noclip")
toggle(MoveTab,T[Lang].walk,false,function(v) Config.WalkSpeed=v end,"WalkSpeed","walk")
slider(MoveTab,T[Lang].walk_speed,8,300,32,function(v) Config.WalkSpeedVal=v end,"walk_speed")
toggle(MoveTab,T[Lang].jump,false,function(v) Config.JumpPower=v end,"JumpPower","jump")
slider(MoveTab,T[Lang].jump_power,20,300,65,function(v) Config.JumpPowerVal=v end,"jump_power")

-- ТЕЛЕПОРТ
section(TPTab,T[Lang].sec_tp_player,"sec_tp_player")
local selectedPlayer=nil
local dd=Instance.new("TextButton",TPTab)
dd.Size=UDim2.new(1,0,0,32)
dd.BackgroundColor3=Color3.fromRGB(35,35,45)
dd.Text=T[Lang].select_player
dd.TextColor3=Config.Text
dd.Font=Enum.Font.GothamMedium
dd.TextSize=12
dd.BorderSizePixel=0
dd.Active=true
dd.Selectable=false
dd.ZIndex=14
Instance.new("UICorner",dd).CornerRadius=UDim.new(0,6)
table.insert(labels,{obj=dd,key="select_player"})

local lst=Instance.new("ScrollingFrame",TPTab)
lst.Size=UDim2.new(1,0,0,0)
lst.BackgroundColor3=Color3.fromRGB(22,22,28)
lst.BorderSizePixel=0
lst.ClipsDescendants=true
lst.Visible=false
lst.ZIndex=20
lst.ScrollBarThickness=4
lst.ScrollBarImageColor3=Config.Accent
lst.CanvasSize=UDim2.new(0,0,0,0)
lst.AutomaticCanvasSize=Enum.AutomaticSize.Y
Instance.new("UICorner",lst).CornerRadius=UDim.new(0,6)
local lstLayout=Instance.new("UIListLayout",lst)
lstLayout.Padding=UDim.new(0,2)
lstLayout.SortOrder=Enum.SortOrder.Name

local function refreshList()
    for _,c in ipairs(lst:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local count=0
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            count=count+1
            local b=Instance.new("TextButton",lst)
            b.Size=UDim2.new(1,-6,0,24)
            b.BackgroundColor3=Color3.fromRGB(32,32,42)
            b.Text=count..". "..p.DisplayName.." (@"..p.Name..")"
            b.TextColor3=Config.Text
            b.Font=Enum.Font.Gotham
            b.TextSize=11
            b.BorderSizePixel=0
            b.Active=true
            b.Selectable=false
            b.ZIndex=21
            local function choose()
                dd.Text=p.Name
                lst.Visible=false
                selectedPlayer=p.Name
            end
            b.MouseButton1Click:Connect(choose)
            b.TouchTap:Connect(choose)
        end
    end
    if count==0 then
        local b=Instance.new("TextButton",lst)
        b.Size=UDim2.new(1,-6,0,24)
        b.BackgroundColor3=Color3.fromRGB(32,32,42)
        b.Text=T[Lang].no_players
        b.TextColor3=Config.TextDim
        b.Font=Enum.Font.Gotham
        b.TextSize=11
        b.BorderSizePixel=0
        b.ZIndex=21
    end
    local h=math.min(count*28+8,260)
    lst.Size=UDim2.new(1,0,0,h)
    lst.CanvasSize=UDim2.new(0,0,0,count*26+10)
end
local function toggleList()
    lst.Visible=not lst.Visible
    if lst.Visible then refreshList() end
end
dd.MouseButton1Click:Connect(toggleList)
dd.TouchTap:Connect(toggleList)
task.spawn(function()
    while task.wait(2) do if lst.Visible then refreshList() end end
end)
Players.PlayerAdded:Connect(function() task.wait(0.3) if lst.Visible then refreshList() end end)
Players.PlayerRemoving:Connect(function() task.wait(0.1) if lst.Visible then refreshList() end end)

button(TPTab,T[Lang].tp_player,function()
    if not selectedPlayer then return end
    local t=Players:FindFirstChild(selectedPlayer)
    if not t or not t.Character then return end
    local th=t.Character:FindFirstChild("HumanoidRootPart")
    if th then tpTo(th.Position) end
end,"tp_player")

section(TPTab,T[Lang].sec_tp_objects,"sec_tp_objects")
button(TPTab,T[Lang].tp_airdrop,function()
    local t=findClosest(isAirdrop)
    if t then tpTo(t.Position) end
end,"tp_airdrop")
button(TPTab,T[Lang].tp_oil,function()
    local t=findClosest(isOil)
    if t then tpTo(t.Position) end
end,"tp_oil")
button(TPTab,T[Lang].tp_capture,function()
    local t=findClosest(isCapture)
    if t then tpTo(t.Position) end
end,"tp_capture")
button(TPTab,T[Lang].tp_veh,function()
    local t=findClosest(isVeh)
    if t then tpTo(t.Position) end
end,"tp_veh")

section(TPTab,T[Lang].sec_tp_marks,"sec_tp_marks")
local savedPos
button(TPTab,T[Lang].save_pos,function()
    if Root then savedPos=Root.Position end
end,"save_pos")
button(TPTab,T[Lang].load_pos,function()
    if savedPos then tpTo(savedPos) end
end,"load_pos")

-- НАСТРОЙКИ
section(SettingsTab,T[Lang].sec_colors,"sec_colors")
colorBtn(SettingsTab,T[Lang].red,Color3.fromRGB(255,60,60),function() applyAccent(Color3.fromRGB(255,60,60)) end,"red")
colorBtn(SettingsTab,T[Lang].blue,Color3.fromRGB(0,140,255),function() applyAccent(Color3.fromRGB(0,140,255)) end,"blue")
colorBtn(SettingsTab,T[Lang].purple,Color3.fromRGB(108,92,231),function() applyAccent(Color3.fromRGB(108,92,231)) end,"purple")
colorBtn(SettingsTab,T[Lang].green,Color3.fromRGB(40,220,120),function() applyAccent(Color3.fromRGB(40,220,120)) end,"green")
colorBtn(SettingsTab,T[Lang].cyan,Color3.fromRGB(0,220,255),function() applyAccent(Color3.fromRGB(0,220,255)) end,"cyan")
colorBtn(SettingsTab,T[Lang].orange,Color3.fromRGB(255,140,40),function() applyAccent(Color3.fromRGB(255,140,40)) end,"orange")
colorBtn(SettingsTab,T[Lang].yellow,Color3.fromRGB(255,220,40),function() applyAccent(Color3.fromRGB(255,220,40)) end,"yellow")
colorBtn(SettingsTab,T[Lang].pink,Color3.fromRGB(255,80,200),function() applyAccent(Color3.fromRGB(255,80,200)) end,"pink")

section(SettingsTab,T[Lang].sec_lang,"sec_lang")
button(SettingsTab,T[Lang].lang_ru,function()
    Lang="RU";Config.Lang="RU"
    applyLang();saveConfig()
end,"lang_ru")
button(SettingsTab,T[Lang].lang_en,function()
    Lang="EN";Config.Lang="EN"
    applyLang();saveConfig()
end,"lang_en")

section(SettingsTab,T[Lang].sec_size,"sec_size")
local pendingScale=1
slider(SettingsTab,T[Lang].scale,0.4,1.5,1,function(v) pendingScale=v end,"scale")
button(SettingsTab,T[Lang].apply,function()
    Config.Scale=pendingScale
    MainScale.Scale=pendingScale
    saveConfig()
end,"apply")

section(SettingsTab,T[Lang].sec_config,"sec_config")
local nameBox=Instance.new("TextBox",SettingsTab)
nameBox.Size=UDim2.new(1,0,0,32)
nameBox.BackgroundColor3=Color3.fromRGB(35,35,45)
nameBox.Text="default"
nameBox.PlaceholderText=T[Lang].cfg_name
nameBox.TextColor3=Config.Text
nameBox.Font=Enum.Font.GothamMedium
nameBox.TextSize=12
nameBox.BorderSizePixel=0
nameBox.ClearTextOnFocus=false
nameBox.Active=true
nameBox.ZIndex=14
Instance.new("UICorner",nameBox).CornerRadius=UDim.new(0,6)

button(SettingsTab,T[Lang].save_cfg,function()
    local name=nameBox.Text:gsub("%s+","_")
    if name=="" then name="default" end
    saveConfigAs(name)
    print("[WT] Saved: "..name)
end,"save_cfg")
button(SettingsTab,T[Lang].load_cfg,function()
    local name=nameBox.Text:gsub("%s+","_")
    if name=="" then name="default" end
    loadConfigAs(name)
    applyLang()
    for _,key in ipairs({"Aim","ESP","Fly","Noclip","WalkSpeed","JumpPower","Chams","WorldESP","Hitbox","Fullbright","VehicleFly"}) do
        if toggleRefs[key] then toggleRefs[key].set(Config[key]) end
    end
    applyAccent(Config.Accent)
    print("[WT] Loaded: "..name)
end,"load_cfg")
button(SettingsTab,T[Lang].list_cfgs,function()
    local list=listConfigs()
    print("[WT] Saved configs:")
    for _,n in ipairs(list) do print("  - "..n) end
end,"list_cfgs")
button(SettingsTab,T[Lang].reset_move,function()
    Config.Fly=false;Config.Noclip=false
    Config.WalkSpeed=false;Config.JumpPower=false
    if toggleRefs.Fly then toggleRefs.Fly.set(false) end
    if toggleRefs.Noclip then toggleRefs.Noclip.set(false) end
    if toggleRefs.WalkSpeed then toggleRefs.WalkSpeed.set(false) end
    if toggleRefs.JumpPower then toggleRefs.JumpPower.set(false) end
    if Humanoid then
        Humanoid.WalkSpeed=16
        Humanoid.UseJumpPower=true
        Humanoid.JumpPower=50
    end
    saveConfig()
end,"reset_move")

section(SettingsTab,T[Lang].sec_world,"sec_world")
toggle(SettingsTab,T[Lang].fullbright,false,function(v)
    Config.Fullbright=v
    if v then
        Lighting.Brightness=3;Lighting.ClockTime=14
        Lighting.FogEnd=1e6;Lighting.GlobalShadows=false
    else
        Lighting.Brightness=2;Lighting.ClockTime=14
        Lighting.FogEnd=100000;Lighting.GlobalShadows=true
    end
end,"Fullbright","fullbright")

section(SettingsTab,T[Lang].sec_help,"sec_help")
local helpLbl=Instance.new("TextLabel",SettingsTab)
helpLbl.Size=UDim2.new(1,0,0,100)
helpLbl.BackgroundTransparency=1
helpLbl.Text=T[Lang].help
helpLbl.TextColor3=Config.TextDim
helpLbl.Font=Enum.Font.Gotham
helpLbl.TextSize=11
helpLbl.TextXAlignment=Enum.TextXAlignment.Left
helpLbl.TextYAlignment=Enum.TextYAlignment.Top
helpLbl.TextWrapped=true
helpLbl.ZIndex=13
table.insert(labels,{obj=helpLbl,key="help"})

local function applyLang()
    for _,item in ipairs(labels) do
        item.obj.Text=T[Lang][item.key] or item.obj.Text
    end
    for _,t in ipairs(acc.toggles) do
        t.btn.Text=t.state and T[Lang].on or T[Lang].off
    end
    nameBox.PlaceholderText=T[Lang].cfg_name
end
applyLang()

CombatTab.Visible=true
currentPage=CombatTab
for _,r in ipairs(acc.tabs) do
    if r.btn==pages.tab_combat.button then
        r.active=true
        r.btn.BackgroundColor3=Config.Panel
        r.btn.BackgroundTransparency=0
        r.btn.TextColor3=Config.Accent
    end
end

-- БИНД МЕНЮ (J)
UIS.InputBegan:Connect(function(i,gpe)
    if i.UserInputType~=Enum.UserInputType.Keyboard then return end
    if i.KeyCode==Enum.KeyCode.J then SG.Enabled=not SG.Enabled end
end)

-- CHARACTER
local Character,Humanoid,Root
local wasWalkSpeed,wasJumpPower=false,false
local function updateChar()
    Character=LP.Character
    if Character then
        Humanoid=Character:FindFirstChildOfClass("Humanoid")
        Root=Character:FindFirstChild("HumanoidRootPart")
    end
end
updateChar()
LP.CharacterAdded:Connect(function(c)
    Character=c
    Humanoid=c:WaitForChild("Humanoid",5)
    Root=c:WaitForChild("HumanoidRootPart",5)
end)

-- FOV CIRCLE
local hasDrawing=(type(Drawing)=="table" and Drawing.new~=nil)
local fovCircle
if hasDrawing then
    fovCircle=Drawing.new("Circle")
    fovCircle.Thickness=1
    fovCircle.Color=Config.Accent
    fovCircle.Filled=false
    fovCircle.Transparency=0.4
    fovCircle.NumSides=60
    fovCircle.Visible=false
end

-- ESP
local espObjects,chamsObjects={},{}
local function getColor(plr)
    if plr.Team==LP.Team then return Color3.fromRGB(60,255,120) end
    return Config.Accent
end
local function newESP()
    local o={}
    o.Box=Drawing.new("Square")
    o.Box.Thickness=2;o.Box.Filled=false;o.Box.Visible=false
    o.Name=Drawing.new("Text")
    o.Name.Size=14;o.Name.Center=true;o.Name.Outline=true;o.Name.Visible=false
    o.HP=Drawing.new("Text")
    o.HP.Size=12;o.HP.Center=true;o.HP.Outline=true;o.HP.Visible=false
    o.Dist=Drawing.new("Text")
    o.Dist.Size=12;o.Dist.Center=true;o.Dist.Outline=true;o.Dist.Visible=false
    return o
end
local function hideESP(o)
    for _,d in pairs(o) do pcall(function() d.Visible=false end) end
end
for _,p in ipairs(Players:GetPlayers()) do
    if p~=LP and hasDrawing then espObjects[p]=newESP() end
    if p~=LP then
        local hl=Instance.new("Highlight");hl.Enabled=false;hl.Parent=parentGui
        chamsObjects[p]=hl
    end
end
Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    if p~=LP and hasDrawing then espObjects[p]=newESP() end
    if p~=LP then
        local hl=Instance.new("Highlight");hl.Enabled=false;hl.Parent=parentGui
        chamsObjects[p]=hl
    end
end)
Players.PlayerRemoving:Connect(function(p)
    local o=espObjects[p]
    if o then for _,d in pairs(o) do pcall(function() d:Remove() end) end espObjects[p]=nil end
    local hl=chamsObjects[p]
    if hl then hl:Destroy();chamsObjects[p]=nil end
end)

local function updateESP()
    if not hasDrawing then return end
    for plr,o in pairs(espObjects) do
        local c=plr.Character
        local hrp=c and c:FindFirstChild("HumanoidRootPart")
        local hum=c and c:FindFirstChildOfClass("Humanoid")
        if not Config.ESP or not hrp or not hum or hum.Health<=0 then
            hideESP(o)
        elseif Config.ESPTeam and plr.Team==LP.Team then
            hideESP(o)
        else
            local sp,onScreen=Camera:WorldToViewportPoint(hrp.Position)
            if not onScreen then
                hideESP(o)
            else
                local col=getColor(plr)
                local top=Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,2.5,0))
                local bot=Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))
                local bh=math.abs(top.Y-bot.Y)
                local bw=bh*0.55
                local bx=sp.X-bw/2
                local by=sp.Y-bh/2
                if Config.ESPBox then
                    o.Box.Size=Vector2.new(bw,bh)
                    o.Box.Position=Vector2.new(bx,by)
                    o.Box.Color=col
                    o.Box.Visible=true
                else o.Box.Visible=false end
                if Config.ESPName then
                    o.Name.Text=plr.DisplayName
                    o.Name.Position=Vector2.new(sp.X,by-20)
                    o.Name.Color=Color3.fromRGB(255,255,255)
                    o.Name.Visible=true
                else o.Name.Visible=false end
                if Config.ESPHealth then
                    o.HP.Text=math.floor(hum.Health).." / "..math.floor(hum.MaxHealth)
                    o.HP.Position=Vector2.new(sp.X,by+bh+2)
                    local pct=math.clamp(hum.Health/hum.MaxHealth,0,1)
                    o.HP.Color=Color3.fromRGB(255*(1-pct),255*pct,80)
                    o.HP.Visible=true
                else o.HP.Visible=false end
                if Config.ESPDist then
                    local d=math.floor((Camera.CFrame.Position-hrp.Position).Magnitude)
                    o.Dist.Text="["..d.."m]"
                    o.Dist.Position=Vector2.new(sp.X,by+bh+18)
                    o.Dist.Color=col
                    o.Dist.Visible=true
                else o.Dist.Visible=false end
            end
        end
    end
    for plr,hl in pairs(chamsObjects) do
        local c=plr.Character
        local hum=c and c:FindFirstChildOfClass("Humanoid")
        if Config.ESP and Config.Chams and c and hum and hum.Health>0 then
            hl.Adornee=c;hl.Enabled=true
            hl.FillColor=getColor(plr);hl.OutlineColor=getColor(plr)
            hl.FillTransparency=0.55;hl.OutlineTransparency=0
            hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        else hl.Enabled=false end
    end
end

-- ФИЛЬТРЫ
local function eachTop(fn)
    for _,a in ipairs(Workspace:GetChildren()) do
        fn(a)
        if a:IsA("Model") or a:IsA("Folder") then
            for _,b in ipairs(a:GetChildren()) do
                fn(b)
                if b:IsA("Model") or b:IsA("Folder") then
                    for _,c in ipairs(b:GetChildren()) do fn(c) end
                end
            end
        end
    end
end
local function getPath(inst)
    local parts={inst.Name}
    local p=inst.Parent
    local depth=0
    while p and p~=Workspace and depth<5 do
        table.insert(parts,1,p.Name)
        p=p.Parent
        depth=depth+1
    end
    return table.concat(parts,"."):lower()
end
local function getName(inst)
    local ok,n=pcall(function() return inst.Name:lower() end)
    return ok and n or ""
end
local function isAirdrop(m)
    return m.Name=="Airdrop Workspace" and getPath(m):find("game systems")~=nil
end
local function isOil(m)
    local n=getName(m)
    if n=="oil rig1" or n=="oil rig2" then return getPath(m):find("warehouses")~=nil end
    return n:find("spawner oil rig")~=nil
end
local function isCapture(m)
    return m.Name=="CapturePoint" and getPath(m):find("game systems")~=nil
end
local function isVeh(m)
    if not m:IsA("Model") then return false end
    local p=getPath(m)
    if not p:find("game systems") then return false end
    local par=m.Parent
    if not par then return false end
    local pn=par.Name
    if pn=="Helicopter Workspace" or pn=="Vehicle Workspace" or pn=="Plane Workspace" or pn=="Tank Workspace" or pn=="Submarine Workspace" then return true end
    return false
end

-- WORLD ESP
local worldObj={}
local function newWorld(col)
    local hl=Instance.new("Highlight")
    hl.FillColor=col;hl.OutlineColor=col
    hl.FillTransparency=0.7;hl.OutlineTransparency=0
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled=false;hl.Parent=parentGui
    return hl
end
local function updateWorld()
    for inst,hl in pairs(worldObj) do
        if not inst or not inst.Parent then hl:Destroy();worldObj[inst]=nil end
    end
    if not Config.WorldESP then
        for _,hl in pairs(worldObj) do hl.Enabled=false end
        return
    end
    eachTop(function(inst)
        if worldObj[inst] then
            worldObj[inst].Enabled=true;worldObj[inst].Adornee=inst
            return
        end
        if isVeh(inst) then worldObj[inst]=newWorld(Config.Accent) end
    end)
    for inst,hl in pairs(worldObj) do hl.Enabled=true;hl.Adornee=inst end
end

-- AIMBOT
local function getClosest()
    local best,bd=nil,Config.FOV
    local mp=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr==LP then continue end
        if Config.TeamCheck and plr.Team==LP.Team then continue end
        local c=plr.Character
        if not c then continue end
        local part=c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
        local hum=c:FindFirstChildOfClass("Humanoid")
        if not part or not hum or hum.Health<=0 then continue end
        local sp,on=Camera:WorldToViewportPoint(part.Position)
        if not on then continue end
        local d=(Vector2.new(sp.X,sp.Y)-mp).Magnitude
        if d<bd then bd=d;best=part end
    end
    return best
end

-- HITBOX
local hitboxCache={}
local function updateHitbox()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr==LP then continue end
        local c=plr.Character
        if not c then continue end
        if Config.Hitbox then
            for _,part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name=="Head" or part.Name=="HumanoidRootPart") then
                    if not hitboxCache[part] then hitboxCache[part]={s=part.Size} end
                    part.Size=hitboxCache[part].s*Config.HitboxSize
                end
            end
        end
    end
    if not Config.Hitbox then
        for part,d in pairs(hitboxCache) do
            if part and part.Parent then part.Size=d.s end
            hitboxCache[part]=nil
        end
    end
end

-- PLAYER (Speed/Jump/Noclip)
local function updatePlayer()
    if Humanoid then
        if Config.WalkSpeed then
            Humanoid.WalkSpeed=Config.WalkSpeedVal
            wasWalkSpeed=true
        elseif wasWalkSpeed then
            Humanoid.WalkSpeed=16
            wasWalkSpeed=false
        end
        if Config.JumpPower then
            Humanoid.UseJumpPower=true
            Humanoid.JumpPower=Config.JumpPowerVal
            wasJumpPower=true
        elseif wasJumpPower then
            Humanoid.UseJumpPower=true
            Humanoid.JumpPower=50
            wasJumpPower=false
        end
    end
    if Config.Noclip and Character then
        for _,p in ipairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end

-- FLY через CFrame (работает в Delta)
local flyCF
local function updateFly(dt)
    if not Config.Fly then flyCF=nil return end
    if not Root or not Root.Parent then return end
    if not flyCF then flyCF=Root.CFrame end
    local speed=Config.FlySpeed*dt
    local move=Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then move=move+Camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then move=move-Camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then move=move-Camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then move=move+Camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then move=move+Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move=move-Vector3.new(0,1,0) end
    if move.Magnitude>0 then flyCF=flyCF+move.Unit*speed end
    Root.CFrame=flyCF
    Root.Velocity=Vector3.zero
end

-- VEHICLE FLY через CFrame
local vehCF
local function updateVehicle(dt)
    local seat=Humanoid and Humanoid.SeatPart
    local veh=seat and seat:FindFirstAncestorOfClass("Model")
    if not veh then vehCF=nil return end
    local base=veh.PrimaryPart or seat
    if Config.VehicleFly then
        if not vehCF then vehCF=base.CFrame end
        local dir=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
        if dir.Magnitude>0 then vehCF=vehCF+dir.Unit*100*dt end
        base.CFrame=vehCF
    else
        vehCF=nil
    end
end

-- TP
local function tpTo(pos)
    local r=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if r and pos then r.CFrame=CFrame.new(pos+Vector3.new(0,3,0)) end
end
local function findClosest(fn)
    local best,bd=nil,math.huge
    if not Root then return nil end
    eachTop(function(inst)
        if fn(inst) then
            local pp=inst:IsA("Model") and (inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart",true)) or inst
            if pp and pp:IsA("BasePart") then
                local d=(Root.Position-pp.Position).Magnitude
                if d<bd then bd=d;best=pp end
            end
        end
    end)
    return best
end

-- ЧАТ-КОМАНДЫ
local function chatCmd(msg)
    msg=msg:lower():gsub("^%s+",""):gsub("%s+$","")
    if msg=="/aim" then Config.Aim=not Config.Aim
        if toggleRefs.Aim then toggleRefs.Aim.set(Config.Aim) end
    elseif msg=="/esp" then Config.ESP=not Config.ESP
        if toggleRefs.ESP then toggleRefs.ESP.set(Config.ESP) end
    elseif msg=="/fly" then Config.Fly=not Config.Fly
        if toggleRefs.Fly then toggleRefs.Fly.set(Config.Fly) end
    elseif msg=="/noclip" then Config.Noclip=not Config.Noclip
        if toggleRefs.Noclip then toggleRefs.Noclip.set(Config.Noclip) end
    elseif msg=="/chams" then Config.Chams=not Config.Chams
        if toggleRefs.Chams then toggleRefs.Chams.set(Config.Chams) end
    elseif msg=="/world" then Config.WorldESP=not Config.WorldESP
        if toggleRefs.WorldESP then toggleRefs.WorldESP.set(Config.WorldESP) end
    elseif msg=="/hitbox" then Config.Hitbox=not Config.Hitbox
        if toggleRefs.Hitbox then toggleRefs.Hitbox.set(Config.Hitbox) end
    elseif msg=="/fb" then
        Config.Fullbright=not Config.Fullbright
        if Config.Fullbright then
            Lighting.Brightness=3;Lighting.ClockTime=14
            Lighting.FogEnd=1e6;Lighting.GlobalShadows=false
        else
            Lighting.Brightness=2;Lighting.ClockTime=14
            Lighting.FogEnd=100000;Lighting.GlobalShadows=true
        end
    elseif msg=="/menu" then SG.Enabled=not SG.Enabled
    elseif msg=="/save" then saveConfig()
    elseif msg=="/load" then loadConfigAs("default");applyLang()
    elseif msg=="/reset" then
        Config.Fly=false;Config.Noclip=false
        Config.WalkSpeed=false;Config.JumpPower=false
        if Humanoid then
            Humanoid.WalkSpeed=16
            Humanoid.UseJumpPower=true
            Humanoid.JumpPower=50
        end
    end
end
LP.Chatted:Connect(chatCmd)

-- БИНДЫ (ключ + мобильная клава Delta)
UIS.InputBegan:Connect(function(input,gpe)
    if _G.WT_BINDING then return end
    if input.UserInputType~=Enum.UserInputType.Keyboard then return end
    local k=input.KeyCode.Name
    for bindKey,keyName in pairs(Binds) do
        if keyName==k and toggleRefs[bindKey] then
            local ref=toggleRefs[bindKey]
            ref.set(not ref.state)
            break
        end
    end
end)

-- ГЛАВНЫЙ ЦИКЛ
local tWorld,tHit=0,0
RunService.RenderStepped:Connect(function(dt)
    if not Character or not Character.Parent then updateChar() end
    Camera=Workspace.CurrentCamera
    if not Camera then return end

    if fovCircle then
        if Config.Aim then
            fovCircle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
            fovCircle.Radius=Config.FOV
            fovCircle.Color=Config.Accent
            fovCircle.Visible=true
        else
            fovCircle.Visible=false
        end
    end

    if Config.Aim then
        local t=getClosest()
        if t then
            Camera.CFrame=CFrame.lookAt(Camera.CFrame.Position,t.Position)
        end
    end

    updatePlayer()
    updateFly(dt)
    updateVehicle(dt)
    updateESP()

    tWorld=tWorld+dt
    if tWorld>=2 then tWorld=0;updateWorld() end

    tHit=tHit+dt
    if tHit>=0.3 then tHit=0;updateHitbox() end
end)

print("[WAR TYCOON HUB v16] Loaded. Bind: J.")
