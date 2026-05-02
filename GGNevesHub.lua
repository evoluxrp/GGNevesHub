-- ╔══════════════════════════════════════════════╗
-- ║         GG NEVES HUB | Blox Fruits          ║
-- ║     UI Custom | Grid 2x2 | Dark Neon Verde  ║
-- ╚══════════════════════════════════════════════╝
 
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local HttpService       = game:GetService("HttpService")
local Lighting          = game:GetService("Lighting")
local TeleportService   = game:GetService("TeleportService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
 
local plr    = Players.LocalPlayer
local mouse  = plr:GetMouse()
local char   = plr.Character or plr.CharacterAdded:Wait()
local Root   = char:WaitForChild("HumanoidRootPart")
local Hum    = char:WaitForChild("Humanoid")
local RS     = ReplicatedStorage
local Remotes = RS:WaitForChild("Remotes")
local CommF  = Remotes:WaitForChild("CommF_")
local CommE  = Remotes:WaitForChild("CommE")
 
plr.CharacterAdded:Connect(function(c)
    char = c
    Root = c:WaitForChild("HumanoidRootPart")
    Hum  = c:WaitForChild("Humanoid")
end)
 
-- ========================================
-- CORES
-- ========================================
local C = {
    LIME        = Color3.fromRGB(163, 230, 53),
    LIME_DARK   = Color3.fromRGB(77,  124, 15),
    LIME_MID    = Color3.fromRGB(101, 163, 13),
    LIME_DIM    = Color3.fromRGB(40,  70,  10),
    BG          = Color3.fromRGB(8,   11,  8),
    BG2         = Color3.fromRGB(13,  19,  13),
    BG3         = Color3.fromRGB(18,  28,  18),
    BG4         = Color3.fromRGB(24,  38,  20),
    TILE        = Color3.fromRGB(16,  26,  14),
    TILE_HOV    = Color3.fromRGB(24,  42,  18),
    TILE_ACT    = Color3.fromRGB(30,  55,  12),
    BORDER      = Color3.fromRGB(45,  85,  20),
    BORDER2     = Color3.fromRGB(60, 110,  25),
    TEXT        = Color3.fromRGB(220, 255, 200),
    TEXT2       = Color3.fromRGB(130, 175, 100),
    TEXT3       = Color3.fromRGB(70,  110,  50),
    RED         = Color3.fromRGB(255,  70,  70),
    WHITE       = Color3.fromRGB(255, 255, 255),
    BLACK       = Color3.fromRGB(0,   0,   0),
}
 
-- ========================================
-- SAVE
-- ========================================
local SF = "GGNevesHub2"
local SP = SF .. "/cfg.json"
local S  = {}
if makefolder and not isfolder(SF) then makefolder(SF) end
local function Save()
    pcall(function() if writefile then writefile(SP, HttpService:JSONEncode(S)) end end)
end
local function Load()
    pcall(function()
        if isfile and isfile(SP) then
            local ok, d = pcall(function() return HttpService:JSONDecode(readfile(SP)) end)
            if ok and d then S = d end
        end
    end)
end
local function Get(k, def) return S[k] ~= nil and S[k] or def end
Load()
 
-- ========================================
-- WORLD DETECTION
-- ========================================
local pid   = game.PlaceId
local World1 = pid == 2753915549 or pid == 85211729168715
local World2 = pid == 4442272183 or pid == 79091703265657
local World3 = pid == 7449423635 or pid == 100117331123089
local WorldName = World1 and "Sea 1" or World2 and "Sea 2" or World3 and "Sea 3" or "???"
 
-- ========================================
-- FULL BRIGHT
-- ========================================
Lighting.Ambient           = Color3.new(1,1,1)
Lighting.ColorShift_Bottom = Color3.new(1,1,1)
Lighting.ColorShift_Top    = Color3.new(1,1,1)
Lighting.Brightness        = 2
Lighting.FogEnd            = 1e10
 
-- ========================================
-- AUTO KEN
-- ========================================
_G.AutoKen = true
task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.AutoKen then
            pcall(function()
                if not (char and CollectionService:HasTag(char,"Ken")) then
                    CommE:FireServer("Ken", true)
                end
            end)
        end
    end
end)
 
-- ========================================
-- UI BUILDER HELPERS
-- ========================================
local function New(cls, props, children)
    local obj = Instance.new(cls)
    for k,v in pairs(props or {}) do obj[k] = v end
    for _,c in pairs(children or {}) do c.Parent = obj end
    return obj
end
 
local function Corner(r, parent)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
    return c
end
 
local function Stroke(color, thick, parent)
    local s = Instance.new("UIStroke")
    s.Color = color or C.BORDER
    s.Thickness = thick or 1
    s.Parent = parent
    return s
end
 
local function Tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), props):Play()
end
 
local function MakeShadow(parent)
    local s = New("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 6),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0,0,0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49,49,450,450),
    })
    s.Parent = parent
    return s
end
 
-- ========================================
-- NOTIFICAÇÃO
-- ========================================
local NotifHolder
local function ShowNotif(title, msg, dur)
    pcall(function()
        if not NotifHolder or not NotifHolder.Parent then return end
        local box = New("Frame", {
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundColor3 = C.BG3,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ClipsDescendants = true,
        }, {})
        Corner(10, box)
        Stroke(C.LIME, 1, box)
 
        New("TextLabel", {
            Size = UDim2.new(1,-12,0,22),
            Position = UDim2.new(0,10,0,6),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = C.LIME,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = box,
        })
        New("TextLabel", {
            Size = UDim2.new(1,-12,0,22),
            Position = UDim2.new(0,10,0,28),
            BackgroundTransparency = 1,
            Text = msg,
            TextColor3 = C.TEXT2,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = box,
        })
 
        -- Barra de progresso
        local bar = New("Frame", {
            Size = UDim2.new(1,0,0,2),
            Position = UDim2.new(0,0,1,-2),
            BackgroundColor3 = C.LIME,
            BorderSizePixel = 0,
            Parent = box,
        })
 
        box.Parent = NotifHolder
        Tween(bar, dur or 4, {Size = UDim2.new(0,0,0,2)})
        task.delay(dur or 4, function()
            Tween(box, 0.3, {BackgroundTransparency = 1})
            task.wait(0.3)
            pcall(function() box:Destroy() end)
        end)
    end)
end
 
-- ========================================
-- MAIN UI
-- ========================================
-- Remove hub anterior se existir
pcall(function()
    if CoreGui:FindFirstChild("GGNevesHub") then
        CoreGui.GGNevesHub:Destroy()
    end
end)
 
local ScreenGui = New("ScreenGui", {
    Name = "GGNevesHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = (syn and syn.protect_gui) and syn.protect_gui(Instance.new("ScreenGui")) or CoreGui,
})
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui
 
-- Notif holder (canto inferior direito)
NotifHolder = New("Frame", {
    Name = "NotifHolder",
    AnchorPoint = Vector2.new(1,1),
    Position = UDim2.new(1,-16,1,-16),
    Size = UDim2.new(0,280,1,-32),
    BackgroundTransparency = 1,
    Parent = ScreenGui,
})
New("UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding = UDim.new(0,6),
    Parent = NotifHolder,
})
 
-- Janela principal
local MainFrame = New("Frame", {
    Name = "MainFrame",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 680, 0, 480),
    BackgroundColor3 = C.BG,
    BorderSizePixel = 0,
    ClipsDescendants = false,
    Parent = ScreenGui,
})
Corner(14, MainFrame)
Stroke(C.LIME, 1.5, MainFrame)
MakeShadow(MainFrame)
 
-- ── TOPBAR ──────────────────────────────
local TopBar = New("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = C.BG2,
    BorderSizePixel = 0,
    Parent = MainFrame,
})
Corner(14, TopBar)
-- cobre cantos inferiores do topbar
New("Frame", {
    Size = UDim2.new(1, 0, 0.5, 0),
    Position = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3 = C.BG2,
    BorderSizePixel = 0,
    Parent = TopBar,
})
 
-- Linha separadora topbar
New("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = C.BORDER,
    BorderSizePixel = 0,
    Parent = TopBar,
})
 
-- Logo dot
New("Frame", {
    Size = UDim2.new(0, 10, 0, 10),
    Position = UDim2.new(0, 14, 0.5, -5),
    BackgroundColor3 = C.LIME,
    BorderSizePixel = 0,
    Parent = TopBar,
})
Corner(999, TopBar:FindFirstChildOfClass("Frame"))
 
-- Título
New("TextLabel", {
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 30, 0, 0),
    BackgroundTransparency = 1,
    Text = "GG Neves Hub",
    TextColor3 = C.LIME,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar,
})
 
-- Sub-título
New("TextLabel", {
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 155, 0, 0),
    BackgroundTransparency = 1,
    Text = "| Blox Fruits",
    TextColor3 = C.TEXT3,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar,
})
 
-- World badge
local WorldBadge = New("TextLabel", {
    Size = UDim2.new(0, 80, 0, 22),
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -120, 0.5, 0),
    BackgroundColor3 = C.LIME_DIM,
    Text = WorldName,
    TextColor3 = C.LIME,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    Parent = TopBar,
})
Corner(6, WorldBadge)
 
-- Botão minimizar
local MinBtn = New("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -44, 0.5, 0),
    BackgroundColor3 = C.BG3,
    Text = "−",
    TextColor3 = C.TEXT2,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BorderSizePixel = 0,
    Parent = TopBar,
})
Corner(6, MinBtn)
Stroke(C.BORDER, 1, MinBtn)
 
-- Botão fechar
local CloseBtn = New("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    BackgroundColor3 = Color3.fromRGB(120, 20, 20),
    Text = "✕",
    TextColor3 = C.WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BorderSizePixel = 0,
    Parent = TopBar,
})
Corner(6, CloseBtn)
 
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, 0.3, {Size = UDim2.new(0,680,0,0), Position = UDim2.new(0.5,0,0.5,-240)})
    task.wait(0.3)
    ScreenGui:Destroy()
end)
 
-- Minimizar toggle
local minimized = false
local fullSize = UDim2.new(0, 680, 0, 480)
local miniSize = UDim2.new(0, 680, 0, 40)
 
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MinBtn.Text = minimized and "+" or "−"
    Tween(MainFrame, 0.2, {Size = minimized and miniSize or fullSize})
end)
 
-- ── DRAG ────────────────────────────────
do
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = inp.Position
            startPos  = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
 
-- ── BODY ────────────────────────────────
local Body = New("Frame", {
    Size = UDim2.new(1, 0, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = MainFrame,
})
 
-- ── SIDEBAR (grid 2x2) ──────────────────
local Sidebar = New("ScrollingFrame", {
    Size = UDim2.new(0, 190, 1, 0),
    BackgroundColor3 = C.BG2,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = C.LIME_DARK,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = Body,
})
 
-- Linha separadora sidebar
New("Frame", {
    Size = UDim2.new(0, 1, 1, 0),
    Position = UDim2.new(1, -1, 0, 0),
    BackgroundColor3 = C.BORDER,
    BorderSizePixel = 0,
    Parent = Sidebar,
})
 
-- Grid 2x2 container
local GridPad = New("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.Y,
    Parent = Sidebar,
})
New("UIGridLayout", {
    CellSize = UDim2.new(0.5, -6, 0, 62),
    CellPadding = UDim2.new(0, 4, 0, 4),
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = GridPad,
})
New("UIPadding", {
    PaddingTop    = UDim.new(0, 8),
    PaddingLeft   = UDim.new(0, 6),
    PaddingRight  = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 8),
    Parent = GridPad,
})
 
-- ── CONTENT AREA ────────────────────────
local ContentHolder = New("Frame", {
    Size = UDim2.new(1, -190, 1, 0),
    Position = UDim2.new(0, 190, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = Body,
})
 
-- ========================================
-- TAB SYSTEM
-- ========================================
local Tabs       = {}
local TabBtns    = {}
local ActiveTab  = nil
 
local function MakeTabBtn(name, icon, order)
    local btn = New("TextButton", {
        LayoutOrder = order,
        BackgroundColor3 = C.TILE,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = GridPad,
    })
    Corner(10, btn)
    Stroke(C.BORDER, 1, btn)
 
    -- Ícone (emoji)
    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = C.LIME,
        Font = Enum.Font.Gotham,
        TextSize = 22,
        Parent = btn,
    })
    -- Label
    New("TextLabel", {
        Size = UDim2.new(1, -4, 0, 18),
        Position = UDim2.new(0, 2, 1, -22),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = C.TEXT2,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = btn,
    })
 
    -- Hover
    btn.MouseEnter:Connect(function()
        if ActiveTab ~= name then
            Tween(btn, 0.12, {BackgroundColor3 = C.TILE_HOV})
            local str = btn:FindFirstChildOfClass("UIStroke")
            if str then Tween(str, 0.12, {Color = C.LIME_MID}) end
        end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveTab ~= name then
            Tween(btn, 0.12, {BackgroundColor3 = C.TILE})
            local str = btn:FindFirstChildOfClass("UIStroke")
            if str then Tween(str, 0.12, {Color = C.BORDER}) end
        end
    end)
 
    return btn
end
 
local function MakeTabContent()
    local scroll = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.LIME_DARK,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = ContentHolder,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 6),
        Parent = scroll,
    })
    New("UIPadding", {
        PaddingTop    = UDim.new(0, 10),
        PaddingLeft   = UDim.new(0, 12),
        PaddingRight  = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 10),
        Parent = scroll,
    })
    return scroll
end
 
local function SetActiveTab(name)
    if ActiveTab == name then return end
    ActiveTab = name
 
    -- Esconde todos, mostra o certo
    for n, content in pairs(Tabs) do
        content.Visible = (n == name)
    end
 
    -- Estiliza botões
    for n, btn in pairs(TabBtns) do
        local isActive = (n == name)
        Tween(btn, 0.15, {BackgroundColor3 = isActive and C.TILE_ACT or C.TILE})
        local str = btn:FindFirstChildOfClass("UIStroke")
        if str then Tween(str, 0.15, {Color = isActive and C.LIME or C.BORDER}) end
        local labels = btn:GetChildren()
        for _, lbl in ipairs(labels) do
            if lbl:IsA("TextLabel") and lbl.TextSize == 10 then
                Tween(lbl, 0.15, {TextColor3 = isActive and C.LIME or C.TEXT2})
            end
        end
    end
end
 
local function AddTab(name, icon, order)
    local btn     = MakeTabBtn(name, icon, order)
    local content = MakeTabContent()
    Tabs[name]    = content
    TabBtns[name] = btn
    btn.MouseButton1Click:Connect(function() SetActiveTab(name) end)
    return content
end
 
-- ========================================
-- UI COMPONENT BUILDERS
-- ========================================
local function Section(parent, title)
    local frame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Parent = parent,
    })
    New("TextLabel", {
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundTransparency = 1,
        Text = title:upper(),
        TextColor3 = C.LIME,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })
    New("Frame", {
        Size = UDim2.new(1, -130, 0, 1),
        Position = UDim2.new(0, 126, 0.5, 0),
        BackgroundColor3 = C.BORDER,
        BorderSizePixel = 0,
        Parent = frame,
    })
    return frame
end
 
local function Toggle(parent, labelText, default, onChange)
    local val = default or false
 
    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = C.BG3,
        BorderSizePixel = 0,
        Parent = parent,
    })
    Corner(8, row)
    Stroke(C.BORDER, 1, row)
 
    New("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = C.TEXT,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })
 
    -- Switch container
    local switchBg = New("Frame", {
        Size = UDim2.new(0, 40, 0, 22),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        BackgroundColor3 = val and C.LIME_DARK or C.BG4,
        BorderSizePixel = 0,
        Parent = row,
    })
    Corner(999, switchBg)
    Stroke(val and C.LIME or C.BORDER, 1, switchBg)
 
    local knob = New("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = val and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
        BackgroundColor3 = val and C.LIME or C.TEXT3,
        BorderSizePixel = 0,
        Parent = switchBg,
    })
    Corner(999, knob)
 
    local function UpdateSwitch(v)
        val = v
        Tween(switchBg, 0.15, {BackgroundColor3 = v and C.LIME_DARK or C.BG4})
        Tween(knob, 0.15, {
            Position = v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
            BackgroundColor3 = v and C.LIME or C.TEXT3,
        })
        local str = switchBg:FindFirstChildOfClass("UIStroke")
        if str then Tween(str, 0.15, {Color = v and C.LIME or C.BORDER}) end
        if onChange then onChange(v) end
    end
 
    -- Clique na linha inteira liga/desliga
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = row,
    })
    btn.MouseButton1Click:Connect(function() UpdateSwitch(not val) end)
    btn.MouseEnter:Connect(function() Tween(row, 0.12, {BackgroundColor3 = C.BG4}) end)
    btn.MouseLeave:Connect(function() Tween(row, 0.12, {BackgroundColor3 = C.BG3}) end)
 
    return {
        Frame = row,
        Set = UpdateSwitch,
        Get = function() return val end,
    }
end
 
local function Slider(parent, labelText, min, max, default, suffix, onChange)
    local val = default or min
 
    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = C.BG3,
        BorderSizePixel = 0,
        Parent = parent,
    })
    Corner(8, row)
    Stroke(C.BORDER, 1, row)
 
    local topRow = New("Frame", {
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Parent = row,
    })
    New("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = C.TEXT,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topRow,
    })
    local valLabel = New("TextLabel", {
        Size = UDim2.new(0, 60, 1, 0),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(val) .. (suffix or ""),
        TextColor3 = C.LIME,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = topRow,
    })
 
    local track = New("Frame", {
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 0, 38),
        BackgroundColor3 = C.BG4,
        BorderSizePixel = 0,
        Parent = row,
    })
    Corner(999, track)
 
    local pct = (val - min) / (max - min)
    local fill = New("Frame", {
        Size = UDim2.new(pct, 0, 1, 0),
        BackgroundColor3 = C.LIME_MID,
        BorderSizePixel = 0,
        Parent = track,
    })
    Corner(999, fill)
 
    local knob2 = New("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(pct, 0, 0.5, 0),
        BackgroundColor3 = C.LIME,
        BorderSizePixel = 0,
        Parent = track,
    })
    Corner(999, knob2)
 
    local sliding = false
    local function UpdateSlider(x)
        local abs = track.AbsolutePosition.X
        local width = track.AbsoluteSize.X
        local p = math.clamp((x - abs) / width, 0, 1)
        val = math.floor(min + (max - min) * p)
        valLabel.Text = tostring(val) .. (suffix or "")
        Tween(fill, 0.05, {Size = UDim2.new(p, 0, 1, 0)})
        Tween(knob2, 0.05, {Position = UDim2.new(p, 0, 0.5, 0)})
        if onChange then onChange(val) end
    end
 
    local sliderBtn = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = track,
    })
    sliderBtn.MouseButton1Down:Connect(function()
        sliding = true
        UpdateSlider(mouse.X)
    end)
    RunService.RenderStepped:Connect(function()
        if sliding then
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                sliding = false
            else
                UpdateSlider(mouse.X)
            end
        end
    end)
 
    return {Frame = row, Get = function() return val end}
end
 
local function Dropdown(parent, labelText, options, default, onChange)
    local selected = default or options[1]
    local open = false
 
    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = C.BG3,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        ZIndex = 5,
        Parent = parent,
    })
    Corner(8, row)
    Stroke(C.BORDER, 1, row)
 
    New("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = C.TEXT,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = row,
    })
 
    local selLabel = New("TextLabel", {
        Size = UDim2.new(0, 120, 1, 0),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -36, 0, 0),
        BackgroundTransparency = 1,
        Text = selected,
        TextColor3 = C.LIME,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
        Parent = row,
    })
 
    local arrow = New("TextLabel", {
        Size = UDim2.new(0, 24, 1, 0),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -6, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = C.LIME,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        ZIndex = 5,
        Parent = row,
    })
 
    -- Dropdown list
    local listFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = C.BG3,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 10,
        Visible = false,
        Parent = row,
    })
    Corner(8, listFrame)
    Stroke(C.LIME, 1, listFrame)
 
    local listLayout = New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 2),
        Parent = listFrame,
    })
    New("UIPadding", {
        PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4),
        PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4),
        Parent = listFrame,
    })
 
    local optBtns = {}
    for _, opt in ipairs(options) do
        local ob = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = C.BG4,
            Text = opt,
            TextColor3 = opt == selected and C.LIME or C.TEXT2,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            BorderSizePixel = 0,
            ZIndex = 11,
            Parent = listFrame,
        })
        Corner(6, ob)
        ob.MouseEnter:Connect(function() Tween(ob, 0.1, {BackgroundColor3 = C.TILE_HOV}) end)
        ob.MouseLeave:Connect(function() Tween(ob, 0.1, {BackgroundColor3 = C.BG4}) end)
        ob.MouseButton1Click:Connect(function()
            selected = opt
            selLabel.Text = opt
            for _, b in ipairs(optBtns) do
                b.TextColor3 = C.TEXT2
            end
            ob.TextColor3 = C.LIME
            if onChange then onChange(opt) end
            -- Fecha
            open = false
            arrow.Text = "▼"
            Tween(listFrame, 0.15, {Size = UDim2.new(1,0,0,0)})
            task.wait(0.15)
            listFrame.Visible = false
        end)
        table.insert(optBtns, ob)
    end
 
    local totalH = #options * 30 + 8
 
    local openBtn = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 6,
        Parent = row,
    })
    openBtn.MouseButton1Click:Connect(function()
        open = not open
        arrow.Text = open and "▲" or "▼"
        if open then
            listFrame.Visible = true
            listFrame.Size = UDim2.new(1, 0, 0, 0)
            Tween(listFrame, 0.18, {Size = UDim2.new(1, 0, 0, totalH)})
        else
            Tween(listFrame, 0.15, {Size = UDim2.new(1,0,0,0)})
            task.wait(0.15)
            listFrame.Visible = false
        end
    end)
 
    return {
        Frame = row,
        Get = function() return selected end,
        Set = function(v)
            selected = v
            selLabel.Text = v
        end,
    }
end
 
local function Button(parent, labelText, onClick)
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = C.LIME_DIM,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Parent = parent,
    })
    Corner(8, btn)
    Stroke(C.LIME_DARK, 1, btn)
 
    New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = C.LIME,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        Parent = btn,
    })
 
    btn.MouseEnter:Connect(function() Tween(btn, 0.12, {BackgroundColor3 = C.BG4}) end)
    btn.MouseLeave:Connect(function() Tween(btn, 0.12, {BackgroundColor3 = C.LIME_DIM}) end)
    btn.MouseButton1Click:Connect(function()
        Tween(btn, 0.05, {BackgroundColor3 = C.LIME_DARK})
        task.wait(0.1)
        Tween(btn, 0.1, {BackgroundColor3 = C.LIME_DIM})
        if onClick then onClick() end
    end)
 
    return btn
end
 
local function Label(parent, text)
    local lbl = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = C.BG3,
        Text = "  " .. text,
        TextColor3 = C.TEXT2,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BorderSizePixel = 0,
        Parent = parent,
    })
    Corner(6, lbl)
    return {
        Frame = lbl,
        Set = function(t) lbl.Text = "  " .. t end,
    }
end
 
-- ========================================
-- CRIAR ABAS
-- ========================================
local T = {}
T.Farm    = AddTab("Farming",    "⚔️",  1)
T.Boss    = AddTab("Boss Farm",  "💀",  2)
T.Fish    = AddTab("Fishing",    "🎣",  3)
T.Sea     = AddTab("Sea Event",  "🌊",  4)
T.Fruits  = AddTab("Fruits",     "🍎",  5)
T.Raid    = AddTab("Raid",       "⚡",  6)
T.Tele    = AddTab("Teleport",   "🌐",  7)
T.PvP     = AddTab("PvP/Player", "🎯",  8)
T.ESP     = AddTab("Esp/Stats",  "👁️", 9)
T.Set     = AddTab("Settings",   "⚙️", 10)
 
SetActiveTab("Farming")
 
-- ╔══════════════════════════════════════╗
-- ║            FARMING                   ║
-- ╚══════════════════════════════════════╝
Section(T.Farm, "Auto Farm")
 
Toggle(T.Farm, "Auto Farm Mobs", Get("AutoFarm", false), function(v)
    _G.AutoFarm = v; S["AutoFarm"] = v; Save()
end)
 
local farmRange = Get("FarmRange", 40)
Slider(T.Farm, "Alcance do Farm", 10, 200, farmRange, " studs", function(v)
    farmRange = v; S["FarmRange"] = v; Save()
end)
 
Toggle(T.Farm, "Anti AFK", Get("AntiAFK", true), function(v)
    _G.AntiAFK = v; S["AntiAFK"] = v; Save()
    if v then
        plr.Idled:Connect(function()
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end)
    end
end)
 
Section(T.Farm, "Coleta")
 
Toggle(T.Farm, "Auto Coletar Chest", Get("AutoChest", false), function(v)
    _G.AutoChest = v; S["AutoChest"] = v; Save()
end)
 
Toggle(T.Farm, "Auto Coletar Berry", Get("AutoBerry", false), function(v)
    _G.AutoBerry = v; S["AutoBerry"] = v; Save()
end)
 
-- Farm loops
task.spawn(function()
    while true do task.wait(0.15)
        pcall(function()
            if not _G.AutoFarm then return end
            local best, bd = nil, farmRange
            for _, e in ipairs(workspace.Enemies:GetChildren()) do
                local hrp = e:FindFirstChild("HumanoidRootPart")
                local hum2 = e:FindFirstChildOfClass("Humanoid")
                if hrp and hum2 and hum2.Health > 0 then
                    local d = (hrp.Position - Root.Position).Magnitude
                    if d < bd then bd = d; best = e end
                end
            end
            if best then
                Root.CFrame = best.HumanoidRootPart.CFrame * CFrame.new(0,0,3.5)
            end
        end)
    end
end)
 
task.spawn(function()
    while true do task.wait(1)
        pcall(function()
            if _G.AutoChest then
                for _, o in ipairs(workspace:GetDescendants()) do
                    if o.Name:lower():find("chest") and o:FindFirstChild("HumanoidRootPart") then
                        Root.CFrame = o.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                        task.wait(0.4)
                        CommF:InvokeServer("ChestInteract", o)
                    end
                end
            end
            if _G.AutoBerry then
                for _, o in ipairs(workspace:GetDescendants()) do
                    if (o.Name == "Berry" or o.Name == "Money") and o:IsA("BasePart") then
                        Root.CFrame = CFrame.new(o.Position + Vector3.new(0,3,0))
                        task.wait(0.15)
                    end
                end
            end
        end)
    end
end)
 
-- ╔══════════════════════════════════════╗
-- ║            BOSS FARM                 ║
-- ╚══════════════════════════════════════╝
Section(T.Boss, "Boss Farm")
 
local BossLists = {
    World1 = {"The Gorilla King","Bobby","The Saw","Yeti","Mob Leader","Vice Admiral","Saber Expert","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Greybeard"},
    World2 = {"Diamond","Jeremy","Fajita","Don Swan","Smoke Admiral","Awakened Ice Admiral","Tide Keeper","Darkbeard","Cursed Captain","Order"},
    World3 = {"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Cake Queen","Longma","Soul Reaper"},
}
local BossList = World1 and BossLists.World1 or World2 and BossLists.World2 or BossLists.World3
local SelBoss  = Get("SelBoss", BossList[1])
 
local bossDD = Dropdown(T.Boss, "Selecionar Boss", BossList, SelBoss, function(v)
    SelBoss = v; S["SelBoss"] = v; Save()
end)
 
Toggle(T.Boss, "Auto Farm Boss", Get("AutoBoss", false), function(v)
    _G.AutoBoss = v; S["AutoBoss"] = v; Save()
end)
 
Toggle(T.Boss, "Teleportar ao Boss", Get("TpBoss", false), function(v)
    _G.TpBoss = v; S["TpBoss"] = v; Save()
end)
 
Section(T.Boss, "Status")
local bossStatus = Label(T.Boss, "Boss: Aguardando...")
 
task.spawn(function()
    while true do task.wait(0.5)
        pcall(function()
            if not (_G.AutoBoss or _G.TpBoss) then
                bossStatus.Set("Boss: Desativado")
                return
            end
            local found = false
            for _, e in ipairs(workspace.Enemies:GetChildren()) do
                local hum2 = e:FindFirstChildOfClass("Humanoid")
                local hrp  = e:FindFirstChild("HumanoidRootPart")
                if e.Name == SelBoss and hum2 and hum2.Health > 0 and hrp then
                    found = true
                    bossStatus.Set("✔ " .. SelBoss .. " [" .. math.floor(hum2.Health) .. " HP]")
                    if _G.TpBoss then Root.CFrame = hrp.CFrame * CFrame.new(0,0,5) end
                    break
                end
            end
            if not found then bossStatus.Set("✘ " .. SelBoss .. " não spawnado") end
        end)
    end
end)
 
-- ╔══════════════════════════════════════╗
-- ║            AUTO FISHING              ║
-- ╚══════════════════════════════════════╝
Section(T.Fish, "Pesca Automática")
 
Toggle(T.Fish, "Auto Fishing", Get("AutoFish", false), function(v)
    _G.AutoFish = v; S["AutoFish"] = v; Save()
end)
 
Toggle(T.Fish, "Auto Coletar Peixe", Get("AutoCollFish", false), function(v)
    _G.AutoCollFish = v; S["AutoCollFish"] = v; Save()
end)
 
Section(T.Fish, "Status")
local fishStatus = Label(T.Fish, "Status: Desativado")
 
task.spawn(function()
    while true do task.wait(0.5)
        pcall(function()
            if not _G.AutoFish then fishStatus.Set("Status: Desativado") return end
            fishStatus.Set("🎣 Pescando...")
            local remote = Remotes:FindFirstChild("CastRod")
                or Remotes:FindFirstChild("FishCast")
            if remote then
                remote:FireServer()
            end
            task.wait(3)
            if _G.AutoCollFish then
                local reel = Remotes:FindFirstChild("ReelRod") or Remotes:FindFirstChild("CollectFish")
                if reel then reel:FireServer() end
            end
        end)
    end
end)
 
-- ╔══════════════════════════════════════╗
-- ║            SEA EVENT                 ║
-- ╚══════════════════════════════════════╝
Section(T.Sea, "Eventos do Mar")
 
Toggle(T.Sea, "Auto Sea Event", Get("AutoSea", false), function(v)
    _G.AutoSea = v; S["AutoSea"] = v; Save()
end)
 
Toggle(T.Sea, "Tyrant of the Skies", Get("AutoTyrant", false), function(v)
    _G.AutoTyrant = v; S["AutoTyrant"] = v; Save()
end)
 
Toggle(T.Sea, "Leviathan / Sea Beast", Get("AutoLevi", false), function(v)
    _G.AutoLevi = v; S["AutoLevi"] = v; Save()
end)
 
Section(T.Sea, "Status")
local seaStatus = Label(T.Sea, "Evento: Aguardando...")
 
task.spawn(function()
    while true do task.wait(1)
        pcall(function()
            if not _G.AutoSea then seaStatus.Set("Evento: Desativado") return end
            for _, o in ipairs(workspace:GetDescendants()) do
                local hum2 = o:FindFirstChildOfClass("Humanoid")
                local hrp  = o:FindFirstChild("HumanoidRootPart")
                if hum2 and hum2.Health > 0 and hrp then
                    local n = o.Name
                    if n == "Tyrant of the Skies" or n:find("Leviathan") or n:find("Sea Beast") or n:find("Plesiosaur") then
                        seaStatus.Set("⚔ " .. n .. " detectado!")
                        Root.CFrame = hrp.CFrame * CFrame.new(0,0,8)
                        break
                    end
                end
            end
        end)
    end
end)
 
-- ╔══════════════════════════════════════╗
-- ║            FRUITS                    ║
-- ╚══════════════════════════════════════╝
Section(T.Fruits, "Frutas")
 
Toggle(T.Fruits, "ESP Frutas", Get("FruitESP", false), function(v)
    _G.FruitESP = v; S["FruitESP"] = v; Save()
end)
 
Toggle(T.Fruits, "Auto Pegar Fruta", Get("AutoFruitGet", false), function(v)
    _G.AutoFruitGet = v; S["AutoFruitGet"] = v; Save()
end)
 
Toggle(T.Fruits, "Notificar Fruta Spawn", Get("FruitNotif", true), function(v)
    _G.FruitNotif = v; S["FruitNotif"] = v; Save()
end)
 
Section(T.Fruits, "Status")
local fruitCount = Label(T.Fruits, "Frutas no mapa: 0")
local fruitESPBills = {}
 
task.spawn(function()
    while true do task.wait(2)
        pcall(function()
            for _, b in ipairs(fruitESPBills) do pcall(function() b:Destroy() end) end
            fruitESPBills = {}
            local count = 0
            for _, o in ipairs(workspace:GetDescendants()) do
                if o:IsA("BasePart") and o.Name:find("Fruit") and not o.Name:find("Model") then
                    count += 1
                    if _G.FruitESP then
                        local bb = Instance.new("BillboardGui", o)
                        bb.Size = UDim2.new(0,140,0,36)
                        bb.AlwaysOnTop = true
                        bb.StudsOffset = Vector3.new(0,4,0)
                        local lbl2 = Instance.new("TextLabel", bb)
                        lbl2.Size = UDim2.new(1,0,1,0)
                        lbl2.BackgroundTransparency = 1
                        lbl2.Text = "🍎 " .. o.Name
                        lbl2.TextColor3 = C.LIME
                        lbl2.TextStrokeTransparency = 0
                        lbl2.Font = Enum.Font.GothamBold
                        lbl2.TextSize = 14
                        table.insert(fruitESPBills, bb)
                    end
                    if _G.AutoFruitGet then
                        Root.CFrame = CFrame.new(o.Position + Vector3.new(0,3,0))
                        task.wait(0.2)
                    end
                    if _G.FruitNotif and count == 1 then
                        ShowNotif("🍎 Fruta!", o.Name .. " spawnada no mapa!", 5)
                    end
                end
            end
            fruitCount.Set("Frutas no mapa: " .. count)
        end)
    end
end)
 
-- ╔══════════════════════════════════════╗
-- ║            RAID/DUNGEON              ║
-- ╚══════════════════════════════════════╝
Section(T.Raid, "Raid Automático")
 
Toggle(T.Raid, "Auto Raid", Get("AutoRaid", false), function(v)
    _G.AutoRaid = v; S["AutoRaid"] = v; Save()
end)
 
Toggle(T.Raid, "Skip Cutscenes", Get("SkipCut", true), function(v)
    S["SkipCut"] = v; Save()
end)
 
local raidDD = Dropdown(T.Raid, "Tipo de Raid", {
    "Elemental","Aura","Mihawk","Darkbeard","Dough King","Cake Prince","Dragon Talon"
}, Get("RaidType","Elemental"), function(v)
    S["RaidType"] = v; Save()
end)
 
Button(T.Raid, "▶  Iniciar Raid", function()
    pcall(function()
        CommF:InvokeServer("StartRaid", S["RaidType"] or "Elemental")
        ShowNotif("Raid", "Raid iniciado: " .. (S["RaidType"] or "Elemental"), 3)
    end)
end)
 
-- ╔══════════════════════════════════════╗
-- ║            TELEPORT                  ║
-- ╚══════════════════════════════════════╝
Section(T.Tele, "Teleporte — " .. WorldName)
 
local Locs = {}
if World1 then
    Locs = {
        ["Ilha Inicial"]    = CFrame.new(975.8,127.3,1817.4),
        ["Marine Fortress"] = CFrame.new(-2138,63,1665),
        ["Jungle"]          = CFrame.new(-1580,37,176),
        ["Pirate Village"]  = CFrame.new(-1240,35,380),
        ["Desert"]          = CFrame.new(920,124,4162),
        ["Middle Town"]     = CFrame.new(-350,75,961),
        ["Frozen Village"]  = CFrame.new(1221,136,955),
        ["Marine Ford"]     = CFrame.new(-3045,35,3790),
        ["Skylands"]        = CFrame.new(-4838,895,-1303),
        ["Colosseum"]       = CFrame.new(-1321,35,3981),
    }
elseif World2 then
    Locs = {
        ["Crocodile Isle"]  = CFrame.new(703,15,5044),
        ["Graveyard"]       = CFrame.new(-4540,35,1262),
        ["Ice Castle"]      = CFrame.new(-5490,55,-611),
        ["Hot & Cold"]      = CFrame.new(-4927,55,-2282),
        ["Green Zone"]      = CFrame.new(-3000,60,-3100),
        ["Dark Arena"]      = CFrame.new(-8600,30,3100),
    }
else
    Locs = {
        ["Floating Turtle"] = CFrame.new(-13839,374,-8282),
        ["Haunted Castle"]  = CFrame.new(-11960,400,5430),
        ["Sea of Treats"]   = CFrame.new(8160,20,-7040),
        ["Hydra Island"]    = CFrame.new(-15900,15,-5800),
        ["Elf Island"]      = CFrame.new(1167,389,-15840),
    }
end
 
local locNames = {}
for k in pairs(Locs) do table.insert(locNames, k) end
table.sort(locNames)
 
local teleDD = Dropdown(T.Tele, "Selecionar Local", locNames, locNames[1], function(v)
    S["TeleLocal"] = v; Save()
end)
 
Button(T.Tele, "🌐  Teleportar!", function()
    local loc = S["TeleLocal"] or locNames[1]
    local cf  = Locs[loc]
    if cf then
        Root.CFrame = cf
        ShowNotif("Teleporte", "Teleportado: " .. loc, 3)
    end
end)
 
Section(T.Tele, "Trocar de World")
 
Button(T.Tele, "➜  Ir para Sea 1", function()
    pcall(function() TeleportService:Teleport(2753915549, plr) end)
end)
Button(T.Tele, "➜  Ir para Sea 2", function()
    pcall(function() TeleportService:Teleport(4442272183, plr) end)
end)
Button(T.Tele, "➜  Ir para Sea 3", function()
    pcall(function() TeleportService:Teleport(7449423635, plr) end)
end)
 
-- ╔══════════════════════════════════════╗
-- ║            PVP / PLAYER              ║
-- ╚══════════════════════════════════════╝
Section(T.PvP, "Aimbot")
 
Toggle(T.PvP, "Aimbot Cam Lock", Get("AimCam", false), function(v)
    _G.AimCam = v; S["AimCam"] = v; Save()
    if v then
        task.spawn(function()
            while _G.AimCam do
                pcall(function()
                    local cam = workspace.CurrentCamera
                    local closest, dist = nil, math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= plr and p.Character then
                            local hrp2 = p.Character:FindFirstChild("HumanoidRootPart")
                            local hum2 = p.Character:FindFirstChildOfClass("Humanoid")
                            if hrp2 and hum2 and hum2.Health > 0 then
                                local d = (hrp2.Position - Root.Position).Magnitude
                                if d < dist then dist = d; closest = p end
                            end
                        end
                    end
                    if closest and closest.Character then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Character.HumanoidRootPart.Position)
                    end
                end)
                task.wait()
            end
        end)
    end
end)
 
Toggle(T.PvP, "Silent Aim", Get("SilentAim", false), function(v)
    _G.SilentAim = v; S["SilentAim"] = v; Save()
end)
 
Toggle(T.PvP, "Ignorar Mesma Equipe", Get("NoAimTeam", true), function(v)
    _G.NoAimTeam = v; S["NoAimTeam"] = v; Save()
end)
 
Section(T.PvP, "Movimento")
 
local speedTog = Toggle(T.PvP, "WalkSpeed Customizado", Get("SpeedOn", false), function(v)
    _G.SpeedOn = v; S["SpeedOn"] = v; Save()
    if not v then pcall(function() Hum.WalkSpeed = 16 end) end
end)
 
Slider(T.PvP, "WalkSpeed", 16, 500, Get("SpeedVal", 60), "", function(v)
    S["SpeedVal"] = v; Save()
    if _G.SpeedOn then pcall(function() Hum.WalkSpeed = v end) end
end)
 
Toggle(T.PvP, "JumpPower Customizado", Get("JumpOn", false), function(v)
    _G.JumpOn = v; S["JumpOn"] = v; Save()
    if not v then pcall(function() Hum.JumpPower = 50 end) end
end)
 
Slider(T.PvP, "JumpPower", 50, 500, Get("JumpVal", 100), "", function(v)
    S["JumpVal"] = v; Save()
    if _G.JumpOn then pcall(function() Hum.JumpPower = v end) end
end)
 
RunService.Heartbeat:Connect(function()
    pcall(function()
        if _G.SpeedOn and Hum then Hum.WalkSpeed = S["SpeedVal"] or 60 end
        if _G.JumpOn  and Hum then Hum.JumpPower = S["JumpVal"]  or 100 end
    end)
end)
 
-- ╔══════════════════════════════════════╗
-- ║            ESP / STATS               ║
-- ╚══════════════════════════════════════╝
Section(T.ESP, "ESP")
 
Toggle(T.ESP, "ESP Jogadores", Get("PlrESP", false), function(v)
    _G.PlrESP = v; S["PlrESP"] = v; Save()
end)
 
Toggle(T.ESP, "ESP Inimigos/Mobs", Get("MobESP", false), function(v)
    _G.MobESP = v; S["MobESP"] = v; Save()
end)
 
Toggle(T.ESP, "Mostrar HP no ESP", Get("ESPHp", true), function(v)
    _G.ESPHp = v; S["ESPHp"] = v; Save()
end)
 
Section(T.ESP, "Stats")
local statsLbl = Label(T.ESP, "Carregando...")
local levelLbl = Label(T.ESP, "Level: ...")
local beliLbl  = Label(T.ESP, "Beli: ...")
local fragLbl  = Label(T.ESP, "Fragments: ...")
 
task.spawn(function()
    while true do task.wait(2)
        pcall(function()
            local data = plr:FindFirstChild("Data")
            if data then
                levelLbl.Set("Level: " .. (data:FindFirstChild("Level") and data.Level.Value or "?"))
                beliLbl.Set("Beli: "  .. (data:FindFirstChild("Beli")  and tostring(data.Beli.Value) or "?"))
                fragLbl.Set("Fragments: " .. (data:FindFirstChild("Fragments") and tostring(data.Fragments.Value) or "?"))
            end
        end)
    end
end)
 
-- ESP loop
local ESPBills = {}
task.spawn(function()
    while true do task.wait(0.5)
        pcall(function()
            for k, b in pairs(ESPBills) do
                if not b.Parent then ESPBills[k] = nil end
            end
 
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= plr and p.Character then
                    local hrp2 = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum2 = p.Character:FindFirstChildOfClass("Humanoid")
                    local key  = tostring(p.UserId)
                    if _G.PlrESP and hrp2 and hum2 then
                        if not ESPBills[key] or not ESPBills[key].Parent then
                            local bb = Instance.new("BillboardGui", hrp2)
                            bb.Size = UDim2.new(0,130,0,30)
                            bb.AlwaysOnTop = true
                            bb.StudsOffset = Vector3.new(0,3.5,0)
                            local lbl2 = Instance.new("TextLabel",bb)
                            lbl2.Size = UDim2.new(1,0,1,0)
                            lbl2.BackgroundTransparency=1
                            lbl2.Font = Enum.Font.GothamBold
                            lbl2.TextSize = 13
                            lbl2.TextColor3 = C.LIME
                            lbl2.TextStrokeTransparency = 0
                            ESPBills[key] = bb
                        end
                        local lbl2 = ESPBills[key]:FindFirstChildOfClass("TextLabel")
                        if lbl2 then
                            local hp = _G.ESPHp and (" [" .. math.floor(hum2.Health) .. "]") or ""
                            lbl2.Text = p.Name .. hp
                        end
                    elseif ESPBills[key] then
                        pcall(function() ESPBills[key]:Destroy() end)
                        ESPBills[key] = nil
                    end
                end
            end
 
            for _, e in ipairs(workspace.Enemies:GetChildren()) do
                local hrp2 = e:FindFirstChild("HumanoidRootPart")
                local hum2 = e:FindFirstChildOfClass("Humanoid")
                local key  = e:GetFullName()
                if _G.MobESP and hrp2 and hum2 and hum2.Health > 0 then
                    if not ESPBills[key] or not ESPBills[key].Parent then
                        local bb = Instance.new("BillboardGui", hrp2)
                        bb.Size = UDim2.new(0,130,0,30)
                        bb.AlwaysOnTop = true
                        bb.StudsOffset = Vector3.new(0,3.5,0)
                        local lbl2 = Instance.new("TextLabel",bb)
                        lbl2.Size = UDim2.new(1,0,1,0)
                        lbl2.BackgroundTransparency = 1
                        lbl2.Font = Enum.Font.GothamBold
                        lbl2.TextSize = 13
                        lbl2.TextColor3 = C.RED
                        lbl2.TextStrokeTransparency = 0
                        ESPBills[key] = bb
                    end
                    local lbl2 = ESPBills[key]:FindFirstChildOfClass("TextLabel")
                    if lbl2 then
                        local hp = _G.ESPHp and (" [" .. math.floor(hum2.Health) .. "]") or ""
                        lbl2.Text = e.Name .. hp
                    end
                elseif ESPBills[key] then
                    pcall(function() ESPBills[key]:Destroy() end)
                    ESPBills[key] = nil
                end
            end
        end)
    end
end)
 
-- ╔══════════════════════════════════════╗
-- ║            SETTINGS                  ║
-- ╚══════════════════════════════════════╝
Section(T.Set, "Geral")
 
Toggle(T.Set, "Full Bright", Get("FullBright", true), function(v)
    S["FullBright"] = v; Save()
    if v then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.ColorShift_Bottom = Color3.new(1,1,1)
        Lighting.ColorShift_Top = Color3.new(1,1,1)
        Lighting.Brightness = 2
        Lighting.FogEnd = 1e10
    else
        Lighting.Ambient = Color3.new(0,0,0)
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
    end
end)
 
Toggle(T.Set, "Auto Ken (Observation Haki)", Get("AutoKenSet", true), function(v)
    _G.AutoKen = v; S["AutoKenSet"] = v; Save()
end)
 
Toggle(T.Set, "Auto Aceitar Aliados", Get("AcceptAlly", false), function(v)
    _G.AcceptAlly = v; S["AcceptAlly"] = v; Save()
    if v then
        task.spawn(function()
            while _G.AcceptAlly do
                pcall(function()
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p.Name ~= plr.Name then
                            CommF:InvokeServer("AcceptAlly", p.Name)
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)
 
Section(T.Set, "Info")
Label(T.Set, "GG Neves Hub | Blox Fruits")
Label(T.Set, "World detectado: " .. WorldName)
Label(T.Set, "UI: Custom Grid 2x2 | Dark Neon")
 
Button(T.Set, "🗑  Limpar Saves", function()
    S = {}; Save()
    ShowNotif("Settings", "Saves apagados! Reinicie o script.", 4)
end)
 
Button(T.Set, "✕  Fechar Hub", function()
    Tween(MainFrame, 0.3, {Size = UDim2.new(0,680,0,0)})
    task.wait(0.3)
    ScreenGui:Destroy()
end)
 
-- ========================================
-- NOTIFICAÇÃO INICIAL
-- ========================================
task.delay(1.5, function()
    ShowNotif("GG Neves Hub", "Carregado com sucesso! World: " .. WorldName, 5)
end)
 
