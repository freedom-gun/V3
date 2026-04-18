_G.BodySize = 30
_G.BodyTransparency = 0.5
_G.BodyEnabled = false

_G.HeadSize = 30
_G.HeadTransparency = 0.5
_G.HeadEnabled = false

_G.Running = true
_G.AimbotEnabled = false
_G.AimbotPart = "Head"
_G.CrosshairVisible = false
_G.NoClipEnabled = false
_G.AutoTPEenabled = false
_G.GlobalTransparency = 0          -- kept for backward compatibility (unused)
_G.GuiTransparency = 0             -- NEW: controls only GUI see‑through

_G.ESPMobsEnabled = false
local ESPFolder = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

local currentPage = "main"
local pages = {}

-- ====== UNIVERSAL DETECTION ======
local function isEnemyMob(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local player = Players:GetPlayerFromCharacter(model)
    if player then return false end
    
    local myChar = LocalPlayer.Character
    if model == myChar then return false end
    
    local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    if hrp then
        local velocity = hrp.Velocity.Magnitude
        if velocity < 0.1 and humanoid.WalkSpeed < 1 then return false end
    end
    
    return humanoid.Health > 0
end

-- ====== GUI FUNCTIONS ======
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

local function createGradient(parent)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 69, 90)),   -- soft lavender
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 27, 43))    -- dark base
    }
    gradient.Rotation = 45
    gradient.Parent = parent
    return gradient
end

local function createStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 2
    stroke.Color = color or Color3.fromRGB(108, 158, 254)   -- neon accent
    stroke.Transparency = 0.5
    stroke.Parent = parent
    return stroke
end

-- ====== MAIN GUI ======
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Hamimsfy V3"
gui.ResetOnSpawn = false

-- MAIN FRAME
pages.main = Instance.new("Frame", gui)
local mainFrame = pages.main
mainFrame.Size = UDim2.new(0,220,0,300)
mainFrame.Position = UDim2.new(0,100,0,100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,27,43)   -- dark base
mainFrame.BackgroundTransparency = _G.GuiTransparency * 0.3
mainFrame.Active = true
mainFrame.Draggable = true
createCorner(mainFrame, 18)
createGradient(mainFrame)
createStroke(mainFrame, 2, Color3.fromRGB(108,158,254))

-- SUN BUTTON
local sunBtn = Instance.new("TextButton", mainFrame)
sunBtn.Size = UDim2.new(0,24,0,24)
sunBtn.Position = UDim2.new(0,8,0,8)
sunBtn.Text = "☀"
sunBtn.BackgroundColor3 = Color3.fromRGB(255,200,0)
sunBtn.TextColor3 = Color3.fromRGB(30,30,30)
sunBtn.TextSize = 16
sunBtn.Font = Enum.Font.GothamBold
sunBtn.BackgroundTransparency = 0.3
sunBtn.TextTransparency = 0.3
createCorner(sunBtn, 12)
createStroke(sunBtn, 2, Color3.fromRGB(255,150,0))

-- SCROLL FRAME
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(1,-10,1,-60)
scrollFrame.Position = UDim2.new(0,5,0,35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(108,158,254)
scrollFrame.CanvasSize = UDim2.new(0,0,0,400)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Hamimsfy V3"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextTransparency = _G.GuiTransparency * 0.3
title.TextSize = 16
title.Font = Enum.Font.GothamBold

local mini = Instance.new("TextButton", mainFrame)
mini.Size = UDim2.new(0,24,0,24)
mini.Position = UDim2.new(1,-48,0,2)
mini.Text = "−"
mini.BackgroundColor3 = Color3.fromRGB(60,60,70)
mini.TextColor3 = Color3.fromRGB(255,255,255)
mini.TextSize = 18
mini.Font = Enum.Font.GothamBold
mini.BackgroundTransparency = 0.3
mini.TextTransparency = 0.3
createCorner(mini, 8)
createStroke(mini, 1)

local close = Instance.new("TextButton", mainFrame)
close.Size = UDim2.new(0,24,0,24)
close.Position = UDim2.new(1,-22,0,2)
close.Text = "✕"
close.BackgroundColor3 = Color3.fromRGB(220,50,50)
close.TextColor3 = Color3.fromRGB(255,255,255)
close.TextSize = 16
close.Font = Enum.Font.GothamBold
close.BackgroundTransparency = 0.3
close.TextTransparency = 0.3
createCorner(close, 8)

-- ICON (NO OPACITY EFFECT - FIXED)
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,100,0,100)
icon.Text = "H"
icon.Visible = false
icon.BackgroundColor3 = Color3.fromRGB(40,40,50)
icon.TextColor3 = Color3.fromRGB(255,255,255)
icon.TextSize = 24
icon.Font = Enum.Font.GothamBold
icon.BackgroundTransparency = 0.5 -- FIXED: Fixed transparency
icon.TextTransparency = 0.5 -- FIXED: Fixed transparency
icon.Active = true
icon.Draggable = true
createCorner(icon, 20)
createStroke(icon, 2, Color3.fromRGB(108,158,254))

-- TRANSPARENCY PAGE
pages.transparency = Instance.new("Frame", gui)
local transFrame = pages.transparency
transFrame.Size = UDim2.new(0,220,0,300)
transFrame.Position = mainFrame.Position
transFrame.BackgroundColor3 = Color3.fromRGB(30,27,43)
transFrame.BackgroundTransparency = _G.GuiTransparency
transFrame.Visible = false
transFrame.Active = true
transFrame.Draggable = true
createCorner(transFrame, 18)
createGradient(transFrame)
createStroke(transFrame, 2, Color3.fromRGB(108,158,254))

local transTitle = Instance.new("TextLabel", transFrame)
transTitle.Size = UDim2.new(1,0,0,30)
transTitle.BackgroundTransparency = 1
transTitle.Text = "Transparency"
transTitle.TextColor3 = Color3.fromRGB(255,255,255)
transTitle.TextTransparency = _G.GuiTransparency
transTitle.TextSize = 16
transTitle.Font = Enum.Font.GothamBold

local backBtn = Instance.new("TextButton", transFrame)
backBtn.Size = UDim2.new(0,24,0,24)
backBtn.Position = UDim2.new(0,8,0,8)
backBtn.Text = "←"
backBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
backBtn.TextColor3 = Color3.fromRGB(255,255,255)
backBtn.TextSize = 16
backBtn.Font = Enum.Font.GothamBold
backBtn.BackgroundTransparency = 0.5
backBtn.TextTransparency = 0.5
createCorner(backBtn, 8)
createStroke(backBtn, 1.5)

-- TRANSPARENCY CONTROLS
local transScrollFrame = Instance.new("ScrollingFrame", transFrame)
transScrollFrame.Size = UDim2.new(1,-10,1,-60)
transScrollFrame.Position = UDim2.new(0,5,0,35)
transScrollFrame.BackgroundTransparency = 1
transScrollFrame.ScrollBarThickness = 8
transScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(108,158,254)
transScrollFrame.CanvasSize = UDim2.new(0,0,0,150)

local opacityLabel = Instance.new("TextLabel", transScrollFrame)
opacityLabel.Size = UDim2.new(1,0,0,25)
opacityLabel.Position = UDim2.new(0,10,0,10)
opacityLabel.BackgroundTransparency = 1
opacityLabel.Text = "Opacity: 100%"
opacityLabel.TextColor3 = Color3.fromRGB(255,255,255)
opacityLabel.TextTransparency = _G.GuiTransparency
opacityLabel.TextSize = 16
opacityLabel.Font = Enum.Font.GothamBold

local opacityUpBtn = Instance.new("TextButton", transScrollFrame)
opacityUpBtn.Size = UDim2.new(0,85,0,30)
opacityUpBtn.Position = UDim2.new(0,10,0,40)
opacityUpBtn.Text = "+ Up"
opacityUpBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
opacityUpBtn.TextColor3 = Color3.fromRGB(255,255,255)
opacityUpBtn.TextSize = 14
opacityUpBtn.Font = Enum.Font.GothamBold
opacityUpBtn.BackgroundTransparency = _G.GuiTransparency * 0.7
opacityUpBtn.TextTransparency = _G.GuiTransparency * 0.7
createCorner(opacityUpBtn, 10)
createStroke(opacityUpBtn, 2)

local opacityDownBtn = Instance.new("TextButton", transScrollFrame)
opacityDownBtn.Size = UDim2.new(0,85,0,30)
opacityDownBtn.Position = UDim2.new(0,105,0,40)
opacityDownBtn.Text = "- Down"
opacityDownBtn.BackgroundColor3 = Color3.fromRGB(220,50,50)
opacityDownBtn.TextColor3 = Color3.fromRGB(255,255,255)
opacityDownBtn.TextSize = 14
opacityDownBtn.Font = Enum.Font.GothamBold
opacityDownBtn.BackgroundTransparency = _G.GuiTransparency * 0.7
opacityDownBtn.TextTransparency = _G.GuiTransparency * 0.7
createCorner(opacityDownBtn, 10)
createStroke(opacityDownBtn, 2)

-- ====== MAIN PAGE ELEMENTS ======
local function label(parent, text,y,size)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(0.45,0,0,18)
    l.Position = UDim2.new(0,10,0,y)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(200,200,210)
    l.Text = text
    l.TextTransparency = _G.GuiTransparency * 0.3
    l.TextSize = size or 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    return l
end

local function btn_small(parent, text,x,y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,85,0,20)
    b.Position = UDim2.new(0,x,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,60)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BackgroundTransparency = 0.3
    b.TextTransparency = 0.3
    b.TextSize = 11
    b.Font = Enum.Font.GothamSemibold
    createCorner(b, 8)
    createStroke(b, 1.5)
    return b
end

local function createToggleBtn(parent, text, posY, width)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, width or 85,0,26)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(220,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.3
    btn.TextTransparency = 0.3
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    createCorner(btn, 10)
    createStroke(btn, 2)
    return btn
end

-- BODY CONTROLS
local bodyToggle = createToggleBtn(scrollFrame, "BODY OFF", 5, 180)
local bodySizeLabel = label(scrollFrame, "Body: ".._G.BodySize, 35, 13)
local bodyTransLabel = label(scrollFrame, "Trans: "..string.format("%.1f",_G.BodyTransparency), 35, 13)
bodyTransLabel.Position = UDim2.new(0.55,0,0,35)
local bPlus = btn_small(scrollFrame, "Size +",10,58)
local bMinus = btn_small(scrollFrame, "Size −",100,58)
local btPlus = btn_small(scrollFrame, "Trans +",10,83)
local btMinus = btn_small(scrollFrame, "Trans −",100,83)

-- HEAD CONTROLS
local headToggle = createToggleBtn(scrollFrame, "HEAD OFF", 115, 180)
local headSizeLabel = label(scrollFrame, "Head: ".._G.HeadSize, 145, 13)
local headTransLabel = label(scrollFrame, "Trans: "..string.format("%.1f",_G.HeadTransparency), 145, 13)
headTransLabel.Position = UDim2.new(0.55,0,0,145)
local hPlus = btn_small(scrollFrame, "Size +",10,167)
local hMinus = btn_small(scrollFrame, "Size −",100,167)
local htPlus = btn_small(scrollFrame, "Trans +",10,192)
local htMinus = btn_small(scrollFrame, "Trans −",100,192)

-- TOGGLES
local aimbotToggle = createToggleBtn(scrollFrame, "AIMBOT OFF", 225, 85)
local espToggle = createToggleBtn(scrollFrame, "ESP OFF", 225, 85)
espToggle.Position = UDim2.new(0,100,0,225)

local noclipToggle = createToggleBtn(scrollFrame, "NOCLIP OFF", 265, 85)
local autoTpToggle = createToggleBtn(scrollFrame, "AUTO TP OFF", 265, 85)
autoTpToggle.Position = UDim2.new(0,100,0,265)

-- ====== PAGE NAVIGATION ======
local function showPage(pageName)
    for name, frame in pairs(pages) do
        frame.Visible = (name == pageName)
    end
    currentPage = pageName
end

sunBtn.MouseButton1Click:Connect(function()
    showPage("transparency")
end)

backBtn.MouseButton1Click:Connect(function()
    showPage("main")
end)

mini.MouseButton1Click:Connect(function()
    for _, frame in pairs(pages) do
        frame.Visible = false
    end
    icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
    icon.Visible = false
    showPage("main")
end)

-- ====== OPACITY CONTROLS ======
local function updateOpacityLabel()
    local percent = math.floor((1 - _G.GuiTransparency) * 100)
    opacityLabel.Text = "Opacity: " .. percent .. "%"
end

opacityUpBtn.MouseButton1Click:Connect(function()
    _G.GuiTransparency = math.max(0, _G.GuiTransparency - 0.1)
    updateAllGUI()
    updateOpacityLabel()
end)

opacityDownBtn.MouseButton1Click:Connect(function()
    _G.GuiTransparency = math.min(1, _G.GuiTransparency + 0.1)
    updateAllGUI()
    updateOpacityLabel()
end)

-- ====== TOGGLES (ALL FIXED) ======
local NoClipConnection, ESPConnection, AimbotConnection, AutoTPConnection

local function setCharacterCollision(character, state)
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = state
        end
    end
end

noclipToggle.MouseButton1Click:Connect(function()
    _G.NoClipEnabled = not _G.NoClipEnabled
    noclipToggle.Text = _G.NoClipEnabled and "NOCLIP ON" or "NOCLIP OFF"
    noclipToggle.BackgroundColor3 = _G.NoClipEnabled and Color3.fromRGB(50,200,100) or Color3.fromRGB(220,50,50)

    if NoClipConnection then
        NoClipConnection:Disconnect()
        NoClipConnection = nil
    end

    local character = LocalPlayer.Character

    if _G.NoClipEnabled then
        NoClipConnection = RunService.Stepped:Connect(function()
            if not _G.NoClipEnabled then return end
            setCharacterCollision(LocalPlayer.Character, false)
        end)
    else
        setCharacterCollision(character, true)
    end
end)

-- FIXED ESP Toggle
espToggle.MouseButton1Click:Connect(function()
    _G.ESPMobsEnabled = not _G.ESPMobsEnabled
    espToggle.Text = _G.ESPMobsEnabled and "ESP ON" or "ESP OFF"
    espToggle.BackgroundColor3 = _G.ESPMobsEnabled and Color3.fromRGB(50,200,100) or Color3.fromRGB(220,50,50)
    
    if not _G.ESPMobsEnabled then
        clearAllESP()
    end
end)

-- FIXED Aimbot Toggle (basic implementation)
aimbotToggle.MouseButton1Click:Connect(function()
    _G.AimbotEnabled = not _G.AimbotEnabled
    aimbotToggle.Text = _G.AimbotEnabled and "AIMBOT ON" or "AIMBOT OFF"
    aimbotToggle.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(50,200,100) or Color3.fromRGB(220,50,50)
    
    if _G.AimbotEnabled then
        AimbotConnection = RunService.Heartbeat:Connect(function()
            if not _G.AimbotEnabled then return end
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Head") then
                local target = nil
                local closestDist = math.huge
                
                for _, model in pairs(workspace:GetDescendants()) do
                    if model:IsA("Model") and isEnemyMob(model) then
                        local targetPart = model:FindFirstChild(_G.AimbotPart) or model:FindFirstChild("Head")
                        if targetPart then
                            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    target = targetPart
                                end
                            end
                        end
                    end
                end
                
                if target then
                    camera.CFrame = CFrame.lookAt(camera.CFrame.Position, target.Position)
                end
            end
        end)
    else
        if AimbotConnection then AimbotConnection:Disconnect() end
    end
end)

autoTpToggle.MouseButton1Click:Connect(function()
    _G.AutoTPEenabled = not _G.AutoTPEenabled
    autoTpToggle.Text = _G.AutoTPEenabled and "AUTO TP ON" or "AUTO TP OFF"
    autoTpToggle.BackgroundColor3 = _G.AutoTPEenabled and Color3.fromRGB(50,200,100) or Color3.fromRGB(220,50,50)
end)

-- ====== ESP FUNCTIONS ======
local function clearAllESP()
    for target, data in pairs(ESPFolder) do
        pcall(function()
            if data.box then data.box:Destroy() end
            if data.name then data.name:Destroy() end
        end)
    end
    ESPFolder = {}
end

local function createBoxESP(target)
    if ESPFolder[target] then return end
    
    local hrp = target:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "BoxESP"
    box.Parent = hrp
    box.Adornee = hrp
    box.Size = hrp.Size + Vector3.new(0.5, 3, 0.5)
    box.Color3 = Color3.fromRGB(0, 255, 0)
    box.Transparency = _G.GuiTransparency + 0.3   -- GUI transparency only
    box.AlwaysOnTop = true
    box.ZIndex = 10
    
    local nameTag = Instance.new("BillboardGui")
    nameTag.Name = "NameESP"
    nameTag.Parent = hrp
    nameTag.Size = UDim2.new(0, 80, 0, 18)
    nameTag.StudsOffset = Vector3.new(0, 4, 0)
    nameTag.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel", nameTag)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = target.Name
    nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    nameLabel.TextTransparency = _G.GuiTransparency + 0.3
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0,0,0)
    
    ESPFolder[target] = {box = box, name = nameTag}
end

-- FIXED ESP Connection
ESPConnection = RunService.Heartbeat:Connect(function()
    if not _G.ESPMobsEnabled then 
        clearAllESP()
        return 
    end
    
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    
    -- Cleanup
    for target, data in pairs(ESPFolder) do
        if not target.Parent or not isEnemyMob(target) then
            pcall(function()
                if data.box then data.box:Destroy() end
                if data.name then data.name:Destroy() end
            end)
            ESPFolder[target] = nil
        end
    end
    
    -- Create new ESP
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and isEnemyMob(model) and not ESPFolder[model] then
            createBoxESP(model)
        end
    end
end)

-- ====== HITBOX CONTROLS (FIXED) ======
bodyToggle.MouseButton1Click:Connect(function()
    _G.BodyEnabled = not _G.BodyEnabled
    bodyToggle.Text = _G.BodyEnabled and "BODY ON" or "BODY OFF"
    bodyToggle.BackgroundColor3 = _G.BodyEnabled and Color3.fromRGB(50,200,100) or Color3.fromRGB(220,50,50)
end)

headToggle.MouseButton1Click:Connect(function()
    _G.HeadEnabled = not _G.HeadEnabled
    headToggle.Text = _G.HeadEnabled and "HEAD ON" or "HEAD OFF"
    headToggle.BackgroundColor3 = _G.HeadEnabled and Color3.fromRGB(50,200,100) or Color3.fromRGB(220,50,50)
end)

-- SIZE/TRANSPARENCY BUTTONS
bPlus.MouseButton1Click:Connect(function() 
    _G.BodySize = math.clamp(_G.BodySize+5,5,100) 
    bodySizeLabel.Text = "Body: ".._G.BodySize 
end)
bMinus.MouseButton1Click:Connect(function() 
    _G.BodySize = math.clamp(_G.BodySize-5,5,100) 
    bodySizeLabel.Text = "Body: ".._G.BodySize 
end)
btPlus.MouseButton1Click:Connect(function() 
    _G.BodyTransparency = math.clamp(_G.BodyTransparency+0.1,0.1,0.9) 
    bodyTransLabel.Text = "Trans: "..string.format("%.1f",_G.BodyTransparency) 
end)
btMinus.MouseButton1Click:Connect(function() 
    _G.BodyTransparency = math.clamp(_G.BodyTransparency-0.1,0.1,0.9) 
    bodyTransLabel.Text = "Trans: "..string.format("%.1f",_G.BodyTransparency) 
end)

hPlus.MouseButton1Click:Connect(function() 
    _G.HeadSize = math.clamp(_G.HeadSize+5,5,100) 
    headSizeLabel.Text = "Head: ".._G.HeadSize 
end)
hMinus.MouseButton1Click:Connect(function() 
    _G.HeadSize = math.clamp(_G.HeadSize-5,5,100) 
    headSizeLabel.Text = "Head: ".._G.HeadSize 
end)
htPlus.MouseButton1Click:Connect(function() 
    _G.HeadTransparency = math.clamp(_G.HeadTransparency+0.1,0.1,0.9) 
    headTransLabel.Text = "Trans: "..string.format("%.1f",_G.HeadTransparency) 
end)
htMinus.MouseButton1Click:Connect(function() 
    _G.HeadTransparency = math.clamp(_G.HeadTransparency-0.1,0.1,0.9) 
    headTransLabel.Text = "Trans: "..string.format("%.1f",_G.HeadTransparency) 
end)

-- ====== UPDATE GUI (EXCLUDE ICON) ======
function updateAllGUI()
    mainFrame.BackgroundTransparency = _G.GuiTransparency * 0.3
    title.TextTransparency = _G.GuiTransparency * 0.3
    sunBtn.TextTransparency = _G.GuiTransparency * 0.3
    sunBtn.BackgroundTransparency = 0.3 -- Fixed: don't change sunBtn opacity
    mini.TextTransparency = _G.GuiTransparency * 0.3
    close.TextTransparency = _G.GuiTransparency * 0.3
    
    transFrame.BackgroundTransparency = _G.GuiTransparency
    transTitle.TextTransparency = _G.GuiTransparency
    opacityLabel.TextTransparency = _G.GuiTransparency
    opacityUpBtn.BackgroundTransparency = _G.GuiTransparency * 0.7
    opacityUpBtn.TextTransparency = _G.GuiTransparency * 0.7
    opacityDownBtn.BackgroundTransparency = _G.GuiTransparency * 0.7
    opacityDownBtn.TextTransparency = _G.GuiTransparency * 0.7
    backBtn.TextTransparency = _G.GuiTransparency * 0.5
    
    bodySizeLabel.TextTransparency = _G.GuiTransparency * 0.3
    bodyTransLabel.TextTransparency = _G.GuiTransparency * 0.3
    headSizeLabel.TextTransparency = _G.GuiTransparency * 0.3
    headTransLabel.TextTransparency = _G.GuiTransparency * 0.3
    
    bodyToggle.TextTransparency = _G.GuiTransparency * 0.3
    headToggle.TextTransparency = _G.GuiTransparency * 0.3
    aimbotToggle.TextTransparency = _G.GuiTransparency * 0.3
    espToggle.TextTransparency = _G.GuiTransparency * 0.3
    noclipToggle.TextTransparency = _G.GuiTransparency * 0.3
    autoTpToggle.TextTransparency = _G.GuiTransparency * 0.3
end

-- ====== MAIN LOOP (FIXED BODY/HEAD) ======
local function process(v)
    local humanoid = v:FindFirstChildOfClass("Humanoid")
    local player = Players:GetPlayerFromCharacter(v)

    if player then return end  

    if humanoid and humanoid.Health <= 0 then  
        local hrp = v:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Size = Vector3.new(2,2,1)
            hrp.Transparency = 1
            hrp.Material = Enum.Material.Plastic
        end
        local head = v:FindFirstChild("Head")
        if head then
            head.Size = Vector3.new(2,1,1)
            head.Transparency = 0
            head.Material = Enum.Material.Plastic
        end
        return  
    end  

    local hrp = v:FindFirstChild("HumanoidRootPart")  
    local head = v:FindFirstChild("Head")  

    -- FIXED: Only apply if toggles are enabled
    if hrp and _G.BodyEnabled then  
        hrp.Size = Vector3.new(_G.BodySize,_G.BodySize,_G.BodySize)  
        hrp.Transparency = _G.BodyTransparency   -- ONLY body transparency
        hrp.Material = Enum.Material.Neon  
    elseif hrp then
        -- Reset when disabled
        hrp.Size = Vector3.new(2,2,1)
        hrp.Transparency = 1
        hrp.Material = Enum.Material.Plastic
    end  

    if head and _G.HeadEnabled then  
        head.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)  
        head.Transparency = _G.HeadTransparency   -- ONLY head transparency
        head.Material = Enum.Material.Neon  
    elseif head then
        -- Reset when disabled
        head.Size = Vector3.new(2,1,1)
        head.Transparency = 0
        head.Material = Enum.Material.Plastic
    end
end

task.spawn(function()
    while _G.Running do
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") then process(v) end
        end
        task.wait(0.4)
    end
end)

-- ====== CLOSE ======
close.MouseButton1Click:Connect(function()
    _G.Running = false
    if NoClipConnection then NoClipConnection:Disconnect() end
    if ESPConnection then ESPConnection:Disconnect() end
    if AimbotConnection then AimbotConnection:Disconnect() end
    gui:Destroy()
end)

-- INIT
updateAllGUI()
updateOpacityLabel()
