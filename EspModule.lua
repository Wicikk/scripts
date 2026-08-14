local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Esp = {
    Options = nil,
    Toggles = nil
}

local highlights = {}
local labels = {}

local colors = {
    Survivors = Color3.fromRGB(0, 170, 255),
    Killers = Color3.fromRGB(255, 60, 60),
    Traps = Color3.fromRGB(20, 50, 180),
    TemEggs = Color3.fromRGB(255, 255, 255)
}

local roleText = {
    Survivors = "SURVIVOR",
    Killers = "KILLER",
    Traps = "TRAP",
    TemEggs = "TEM EGG"
}

local function getTargets()
    local list = {}

    for _, m in ipairs(workspace:GetChildren()) do
        if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChildOfClass("Humanoid") then
            local player = Players:GetPlayerFromCharacter(m)
            if player == LocalPlayer then continue end

            local role = m:GetAttribute("Role")
            if role == "Hunter" then
                table.insert(list, { type = "Killers", model = m, part = m.HumanoidRootPart, name = player and player.Name or m.Name })
            elseif role == "Survivor" then
                table.insert(list, { type = "Survivors", model = m, part = m.HumanoidRootPart, name = player and player.Name or m.Name })
            end
        end
    end

    local trap = workspace:FindFirstChild("SpadeTrap")
    if trap and trap:IsA("BasePart") then
        table.insert(list, { type = "Traps", model = trap, part = trap, name = "Trap" })
    end

    local egg = workspace:FindFirstChild("TemEgg")
    if egg and egg:IsA("BasePart") then
        table.insert(list, { type = "TemEggs", model = egg, part = egg, name = "TemEgg" })
    end

    return list
end

local function clearEntry(id)
    if highlights[id] then
        highlights[id]:Destroy()
        highlights[id] = nil
    end

    if labels[id] then
        if labels[id].gui then labels[id].gui:Destroy() end
        labels[id] = nil
    end
end

local function updateTarget(target)
    local id = target.model
    local color = colors[target.type]
    local cam = workspace.CurrentCamera
    if not cam then return end

    local hlOn = Esp.Toggles and Esp.Toggles.Highlight and Esp.Toggles.Highlight.Value ~= false
    if hlOn then
        if not highlights[id] then
            local hl = Instance.new("Highlight")
            hl.FillColor = color
            hl.OutlineColor = Color3.new(0, 0, 0)
            hl.FillTransparency = 0.55
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = target.model
            highlights[id] = hl
        end
        highlights[id].FillColor = color
    elseif highlights[id] then
        highlights[id]:Destroy()
        highlights[id] = nil
    end

    local showNames = Esp.Toggles and Esp.Toggles.ShowNames and Esp.Toggles.ShowNames.Value ~= false
    if showNames then
        if not labels[id] then
            local bp = Instance.new("BillboardGui")
            bp.AlwaysOnTop = true
            bp.LightInfluence = 0
            bp.StudsOffset = Vector3.new(0, 3, 0)
            bp.Size = UDim2.new(0, 120, 0, 30)

            local nameTL = Instance.new("TextLabel")
            nameTL.BackgroundTransparency = 1
            nameTL.Size = UDim2.new(1, 0, 0, 14)
            nameTL.Position = UDim2.new(0, 0, 0, 0)
            nameTL.Font = Enum.Font.GothamBold
            nameTL.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameTL.TextStrokeColor3 = Color3.new(0, 0, 0)
            nameTL.TextStrokeTransparency = 0
            nameTL.TextScaled = false
            nameTL.TextSize = 12
            nameTL.Text = target.name
            nameTL.Parent = bp

            local roleTL = Instance.new("TextLabel")
            roleTL.BackgroundTransparency = 1
            roleTL.Size = UDim2.new(1, 0, 0, 10)
            roleTL.Position = UDim2.new(0, 0, 0, 14)
            roleTL.Font = Enum.Font.Gotham
            roleTL.TextColor3 = color
            roleTL.TextStrokeColor3 = Color3.new(0, 0, 0)
            roleTL.TextStrokeTransparency = 0
            roleTL.TextScaled = false
            roleTL.TextSize = 9
            roleTL.Text = roleText[target.type]
            roleTL.Parent = bp

            bp.Parent = target.part

            labels[id] = { gui = bp, name = nameTL, role = roleTL }
        end

        local dist = (cam.CFrame.Position - target.part.Position).Magnitude
        local scale = math.clamp(150 / dist, 0.5, 2)
        local baseSize = Esp.Options and Esp.Options.EspSize and Esp.Options.EspSize.Value or 14

        local nameSize = math.clamp(baseSize * scale, 8, baseSize * 2)
        local roleSize = math.clamp(baseSize * scale * 0.7, 6, baseSize * 1.5)

        labels[id].name.TextSize = nameSize
        labels[id].role.TextSize = roleSize
        labels[id].gui.Size = UDim2.new(0, nameSize * 8, 0, nameSize + roleSize)
        labels[id].role.Position = UDim2.new(0, 0, 0, nameSize)
    elseif labels[id] then
        labels[id].gui:Destroy()
        labels[id] = nil
    end
end

local function syncEsp()
    local targets = getTargets()
    local activeIds = {}

    for _, t in ipairs(targets) do
        local enabled = Esp.Toggles and Esp.Toggles[t.type] and Esp.Toggles[t.type].Value
        if enabled then
            activeIds[t.model] = true
            pcall(updateTarget, t)
        else
            clearEntry(t.model)
        end
    end

    for id in pairs(highlights) do
        if not activeIds[id] then clearEntry(id) end
    end
    for id in pairs(labels) do
        if not activeIds[id] then clearEntry(id) end
    end
end

function Esp.Init(options, toggles)
    Esp.Options = options
    Esp.Toggles = toggles

    RunService.RenderStepped:Connect(function()
        pcall(syncEsp)
    end)
end

return Esp
