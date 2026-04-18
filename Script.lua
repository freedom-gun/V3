_G.BodySize = 20
_G.BodyTransparency = 0.5
_G.BodyEnabled = false

_G.HeadSize = 20
_G.HeadTransparency = 0.5
_G.HeadEnabled = false

_G.Running = true
_G.AimbotEnabled = false
_G.AimbotPart = "Head"
_G.CrosshairVisible = false

-- OPTIMIZED ESP VARS
_G.ESPMobsEnabled = false
local ESPFolder = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera

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
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
    }
    gradient.Rotation = 45
    gradient.Parent = parent
    return gradient
end

local function createStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 2
    stroke.Color = color or Color3.fromRGB(100, 150, 255)
    stroke.Transparency = 0.5
    stroke.Parent = parent
    return stroke
end

-- ====== MAIN GUI ======
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Hamimsfy V3"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,220,0,320)
main.Position = UDim2.new(0,100,0,100)
main.BackgroundColor3 = Color3.fromRGB(30,30,40)
main.Active = true
main.Draggable = true
createCorner(main, 16)
createGradient(main)
createStroke(main, 2, Color3.fromRGB(100,150,255))

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,28)
title.BackgroundTransparency = 1
title.Text = "Hamimsfy V3"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold

local mini = Instance.new("TextButton", main)
mini.Size = UDim2.new(0,24,0,24)
mini.Position = UDim2.new(1,-48,0,2)
mini.Text = "−"
mini.BackgroundColor3 = Color3.fromRGB(60,60,70)
mini.TextColor3 = Color3.fromRGB(255,255,255)
mini.TextSize = 18
mini.Font = Enum.Font.GothamBold
createCorner(mini, 8)
createStroke(mini, 1)

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,24,0,24)
close.Position = UDim2.new(1,-22,0,2)
close.Text = "✕"
close.BackgroundColor3 = Color3.fromRGB(220,50,50)
close.TextColor3 = Color3.fromRGB(255,255,255)
close.TextSize = 16
close.Font = Enum.Font.GothamBold
createCorner(close, 8)

-- ====== FIXED DRAGGABLE ICON ======
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,100,0,100)
icon.Text = "H"
icon.Visible = false
icon.BackgroundColor3 = Color3.fromRGB(40,40,50)
icon.TextColor3 = Color3.fromRGB(255,255,255)
icon.TextSize = 24
icon.Font = Enum.Font.GothamBold
icon.Active = true
icon.Draggable = true -- FIXED DRAG
createCorner(icon, 20)
createStroke(icon, 2, Color3.fromRGB(100,150,255))

local function label(text,y,size)
    local l = Instance.new("TextLabel", main)
    l.Size = UDim2.new(0.45,0,0,18) -- HALF WIDTH
    l.Position = UDim2.new(0,10,0,y)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(200,200,210)
    l.Text = text
    l.TextSize = size or 13 -- BIGGER TEXT
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    return l
end

local function btn_small(text,x,y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0,85,0,20) -- SLIGHTLY SMALLER
    b.Position = UDim2.new(0,x,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,60)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextSize = 11
    b.Font = Enum.Font.GothamSemibold
    createCorner(b, 8)
    createStroke(b, 1.5)
    return b
end

-- ====== FIXED TOGGLE BUTTONS ======
local function createToggleBtn(text, posY)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0,180,0,26)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(220,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    createCorner(btn, 10)
    createStroke(btn, 2)
    return btn
end

-- BODY SECTION (REPOSITIONED LABELS)
local bodyToggle = createToggleBtn("BODY OFF", 35)
local bodySizeLabel = label("Body: ".._G.BodySize, 65, 13)
local bodyTransLabel = label("Trans: "..string.format("%.1f",_G.BodyTransparency), 65, 13)
bodyTransLabel.Position = UDim2.new(0.55,0,0,65) -- RIGHT SIDE
local bPlus = btn_small("Size +",10,88)
local bMinus = btn_small("Size −",100,88)
local btPlus = btn_small("Trans +",10,113)
local btMinus = btn_small("Trans −",100,113)

-- HEAD SECTION (REPOSITIONED LABELS)
local headToggle = createToggleBtn("HEAD OFF", 142)
local headSizeLabel = label("Head: ".._G.HeadSize, 172, 13)
local headTransLabel = label("Trans: "..string.format("%.1f",_G.HeadTransparency), 172, 13)
headTransLabel.Position = UDim2.new(0.55,0,0,172) -- RIGHT SIDE
local hPlus = btn_small("Size +",10,194)
local hMinus = btn_small("Size −",100,194)
local htPlus = btn_small("Trans +",10,219)
local htMinus = btn_small("Trans −",100,219)

-- AIMBOT & ESP (FIXED POSITIONS)
local aimbotToggle = createToggleBtn("AIMBOT OFF", 245)
aimbotToggle.Size = UDim2.new(0,100,0,26)
aimbotToggle.Position = UDim2.new(0,10,0,245)

local espToggle = Instance.new("TextButton", main)
espToggle.Size = UDim2.new(0,100,0,26)
espToggle.Position = UDim2.new(0,115,0,245)
espToggle.Text = "ESP MOBS OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(220,50,50)
espToggle.TextColor3 = Color3.fromRGB(255,255,255)
espToggle.TextSize = 9
espToggle.Font = Enum.Font.GothamBold
createCorner(espToggle, 10)
createStroke(espToggle, 2)

-- ====== FIXED CROSSHAIR ======
local crosshair = Instance.new("Frame", gui)
crosshair.AnchorPoint = Vector2.new(0.5,0.5)
crosshair.Size = UDim2.new(0,60,0,60)
crosshair.Position = UDim2.new(0.5,0,0.5,0)
crosshair.BackgroundTransparency = 1
crosshair.Visible = false
crosshair.ZIndex = 1000

local crosshairCircle = Instance.new("Frame", crosshair)
crosshairCircle.Size = UDim2.new(1,0,1,0)
crosshairCircle.BackgroundColor3 = Color3.fromRGB(0,255,150)
crosshairCircle.BackgroundTransparency = 0.4
createCorner(crosshairCircle, 30)
createStroke(crosshairCircle, 3, Color3.fromRGB(0,255,150))

-- ====== ESP FUNCTIONS ======
local function clearAllESP()
    for target, data in pairs(ESPFolder) do
        pcall(function()
            if data and data.box then data.box:Destroy() end
            if data and data.name then data.name:Destroy() end
        end)
    end
    ESPFolder = {}
end

local function createBoxESP(target)
    if ESPFolder[target] then return end
    
    local hrp = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
    if not hrp then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "BoxESP"
    box.Parent = hrp
    box.Adornee = hrp
    box.Size = hrp.Size + Vector3.new(0.5, 3, 0.5)
    box.Color3 = Color3.fromRGB(0, 255, 0)
    box.Transparency = 0.3
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
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0,0,0)
    
    ESPFolder[target] = {box = box, name = nameTag}
end

local function updateBoxESP()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myHRP = myChar.HumanoidRootPart
    
    for target, data in pairs(ESPFolder) do
        if not _G.ESPMobsEnabled or not target.Parent or not isEnemyMob(target) then
            pcall(function()
                if data.box then data.box:Destroy() end
                if data.name then data.name:Destroy() end
            end)
            ESPFolder[target] = nil
            continue
        end
        
        local hrp = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
        if hrp then
            local dist = (myHRP.Position - hrp.Position).Magnitude
            if dist > 250 then
                pcall(function()
                    if data.box then data.box:Destroy() end
                    if data.name then data.name:Destroy() end
                end)
                ESPFolder[target] = nil
            end
        end
    end
end

-- ====== HITBOX ======
local function resetBody(v)
    local hrp = v:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Size = Vector3.new(2,2,1)
        hrp.Transparency = 1
        hrp.Material = Enum.Material.Plastic
    end
end

local function resetHead(v)
    local head = v:FindFirstChild("Head")
    if head then
        head.Size = Vector3.new(2,1,1)
        head.Transparency = 0
        head.Material = Enum.Material.Plastic
    end
end

-- ====== TOGGLES ======
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

espToggle.MouseButton1Click:Connect(function()
    _G.ESPMobsEnabled = not _G.ESPMobsEnabled
    espToggle.Text = _G.ESPMobsEnabled and "ESP MOBS ON" or "ESP MOBS OFF"
    espToggle.BackgroundColor3 = _G.ESPMobsEnabled and Color3.fromRGB(50,200,100) or Color3.fromRGB(220,50,50)
    
    if not _G.ESPMobsEnabled then
        clearAllESP()
    end
end)

-- SIZE CONTROLS
bPlus.MouseButton1Click:Connect(function() _G.BodySize = math.clamp(_G.BodySize+5,5,100) bodySizeLabel.Text = "Body: ".._G.BodySize end)
bMinus.MouseButton1Click:Connect(function() _G.BodySize = math.clamp(_G.BodySize-5,5,100) bodySizeLabel.Text = "Body: ".._G.BodySize end)
btPlus.MouseButton1Click:Connect(function() _G.BodyTransparency = math.clamp(_G.BodyTransparency+0.1,0.1,0.9) bodyTransLabel.Text = "Trans: "..string.format("%.1f",_G.BodyTransparency) end)
btMinus.MouseButton1Click:Connect(function() _G.BodyTransparency = math.clamp(_G.BodyTransparency-0.1,0.1,0.9) bodyTransLabel.Text = "Trans: "..string.format("%.1f",_G.BodyTransparency) end)
hPlus.MouseButton1Click:Connect(function() _G.HeadSize = math.clamp(_G.HeadSize+5,5,100) headSizeLabel.Text = "Head: ".._G.HeadSize end)
hMinus.MouseButton1Click:Connect(function() _G.HeadSize = math.clamp(_G.HeadSize-5,5,100) headSizeLabel.Text = "Head: ".._G.HeadSize end)
htPlus.MouseButton1Click:Connect(function() _G.HeadTransparency = math.clamp(_G.HeadTransparency+0.1,0.1,0.9) headTransLabel.Text = "Trans: "..string.format("%.1f",_G.HeadTransparency) end)
htMinus.MouseButton1Click:Connect(function() _G.HeadTransparency = math.clamp(_G.HeadTransparency-0.1,0.1,0.9) headTransLabel.Text = "Trans: "..string.format("%.1f",_G.HeadTransparency) end)

-- ====== AIMBOT ======
local AimConnection
local function startAimbot()
    if AimConnection then AimConnection:Disconnect() end
    
    AimConnection = RunService.RenderStepped:Connect(function()
        if not _G.AimbotEnabled then return end
        
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local myHRP = myChar.HumanoidRootPart
        
        local targetPart = nil
        local shortestDist = math.huge
        
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and isEnemyMob(obj) then
                local candidates = {obj:FindFirstChild("Head"), obj:FindFirstChild("HumanoidRootPart"), obj.PrimaryPart}
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                
                for _, part in pairs(candidates) do
                    if part and hrp then
                        local dist = (myHRP.Position - hrp.Position).Magnitude
                        if dist < shortestDist and dist < 400 then
                            shortestDist = dist
                            targetPart = part
                        end
                    end
                end
            end
        end
        
        if targetPart then
            local aimPosition = targetPart.Position
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.lookAt(currentCFrame.Position, aimPosition)
            camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.18)
        end
    end)
end

aimbotToggle.MouseButton1Click:Connect(function()
    _G.AimbotEnabled = not _G.AimbotEnabled
    crosshair.Visible = _G.AimbotEnabled
    aimbotToggle.Text = _G.AimbotEnabled and "AIMBOT ON" or "AIMBOT OFF"
    aimbotToggle.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(50,200,100) or Color3.fromRGB(220,50,50)
    
    if _G.AimbotEnabled then
        startAimbot()
    else
        if AimConnection then 
            AimConnection:Disconnect() 
            AimConnection = nil
        end
    end
end)

-- ====== MINIMIZE ======
mini.MouseButton1Click:Connect(function()
    main.Visible = false
    icon.Visible = true
    icon.Size = UDim2.new(0,48,0,48)
end)

icon.MouseButton1Click:Connect(function()
    local tweenIn = TweenService:Create(icon, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Size = UDim2.new(0,60,0,60),
        BackgroundColor3 = Color3.fromRGB(60,60,70)
    })
    tweenIn:Play()
    tweenIn.Completed:Connect(function()
        icon.Visible = false
        main.Visible = true
        icon.Size = UDim2.new(0,48,0,48)
        icon.BackgroundColor3 = Color3.fromRGB(40,40,50)
    end)
end)

-- ====== PROCESS ======
local function process(v)
    local humanoid = v:FindFirstChildOfClass("Humanoid")
    local player = Players:GetPlayerFromCharacter(v)

    if player then return end  

    if humanoid and humanoid.Health <= 0 then  
        resetBody(v)  
        resetHead(v)  
        if ESPFolder[v] then
            pcall(function()
                ESPFolder[v].box:Destroy()
                ESPFolder[v].name:Destroy()
            end)
            ESPFolder[v] = nil
        end
        return  
    end  

    local hrp = v:FindFirstChild("HumanoidRootPart")  
    local head = v:FindFirstChild("Head")  

    if hrp then  
        if _G.BodyEnabled then  
            hrp.Size = Vector3.new(_G.BodySize,_G.BodySize,_G.BodySize)  
            hrp.Transparency = _G.BodyTransparency  
            hrp.Material = Enum.Material.Neon  
        else  
            resetBody(v)  
        end  
    end  

    if head then  
        if _G.HeadEnabled then  
            head.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)  
            head.Transparency = _G.HeadTransparency  
            head.Material = Enum.Material.Neon  
        else  
            resetHead(v)  
        end
    end

    if _G.ESPMobsEnabled and humanoid and isEnemyMob(v) and not ESPFolder[v] then
        createBoxESP(v)
    end
end

-- ====== LOOPS ======
task.spawn(function()
    while _G.Running do
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") then process(v) end
        end
        task.wait(0.4)
    end
end)

task.spawn(function()
    while _G.Running do
        if _G.ESPMobsEnabled then updateBoxESP() end
        task.wait(0.15)
    end
end)

-- ====== CLOSE ======
close.MouseButton1Click:Connect(function()
    _G.Running = false
    _G.BodyEnabled = false
    _G.HeadEnabled = false
    _G.AimbotEnabled = false
    _G.ESPMobsEnabled = false
    
    if AimConnection then AimConnection:Disconnect() end
    clearAllESP()

    for _,v in pairs(workspace:GetDescendants()) do  
        if v:IsA("Model") then  
            resetBody(v)  
            resetHead(v)  
        end  
    end  

    gui:Destroy()
end)

print("🟢 Hamimsfy PERFECT - Draggable Icon + AIMBOT Fixed + Labels Repositioned!")
