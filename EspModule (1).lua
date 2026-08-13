local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Esp = {}
Esp.Options = nil
Esp.Toggles = nil

local highlights = {}
local tracers = {}
local labels = {}

local colors = {
    Survivors = Color3.fromRGB(0, 170, 255),
    Killers = Color3.fromRGB(255, 60, 60),
    Traps = Color3.fromRGB(20, 50, 180),
    TemEggs = Color3.fromRGB(255, 255, 255),
}

local function getLocalAttachPart()
    local char = LocalPlayer.Character
    if not char then return nil end
    local mode = Esp.Options and Esp.Options.TracersPosition and Esp.Options.TracersPosition.Value or "Head"
    if mode == "HumanoidRootPart" then
        return char:FindFirstChild("HumanoidRootPart")
    elseif mode == "Torso" then
        return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
    else
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    end
end

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
    if highlights[id] then highlights[id]:Destroy() highlights[id] = nil end
    if tracers[id] then
        if tracers[id].beam then tracers[id].beam:Destroy() end
        if tracers[id].a0 then tracers[id].a0:Destroy() end
        if tracers[id].a1 then tracers[id].a1:Destroy() end
        tracers[id] = nil
    end
    if labels[id] then
        if labels[id].gui then labels[id].gui:Destroy() end
        labels[id] = nil
    end
end

local function ensureEntry(id, target)
    local color = colors[target.type]
    if not highlights[id] then
        local hl = Instance.new("Highlight")
        hl.FillColor = color
        hl.OutlineColor = Color3.new(0, 0, 0)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = target.model
        highlights[id] = hl
    end

    local tracerOn = Esp.Toggles and Esp.Toggles.Tracers and Esp.Toggles.Tracers.Value
    if tracerOn then
        if not tracers[id] then
            local beam = Instance.new("Beam")
            local a0 = Instance.new("Attachment")
            local a1 = Instance.new("Attachment")
            local localPart = getLocalAttachPart()
            a0.Parent = localPart
            a1.Parent = target.part
            beam.Attachment0 = a0
            beam.Attachment1 = a1
            beam.Color = ColorSequence.new(color)
            beam.Width0 = 0.15
            beam.Width1 = 0.15
            beam.Transparency = NumberSequence.new(0.4)
            beam.Parent = target.model
            tracers[id] = { beam = beam, a0 = a0, a1 = a1 }
        else
            local localPart = getLocalAttachPart()
            if tracers[id].a0 and tracers[id].a0.Parent ~= localPart then
                tracers[id].a0.Parent = localPart
            end
            tracers[id].beam.Color = ColorSequence.new(color)
        end
    else
        if tracers[id] then
            tracers[id].beam:Destroy()
            if tracers[id].a0 then tracers[id].a0:Destroy() end
            if tracers[id].a1 then tracers[id].a1:Destroy() end
            tracers[id] = nil
        end
    end

    if not labels[id] then
        local bp = Instance.new("BillboardGui")
        bp.Size = UDim2.new(0, 60, 0, 12)
        bp.AlwaysOnTop = true
        bp.LightInfluence = 0
        bp.StudsOffset = Vector3.new(0, 2.5, 0)
        local tl = Instance.new("TextLabel")
        tl.BackgroundTransparency = 1
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.Font = Enum.Font.Gotham
        tl.TextColor3 = color
        tl.TextStrokeTransparency = 0.3
        tl.TextScaled = false
        tl.TextSize = 10
        tl.Text = target.name
        tl.Parent = bp
        bp.Parent = target.part
        labels[id] = { gui = bp, label = tl }
    end
end

local function syncEntries()
    local targets = getTargets()
    local seen = {}
    for _, t in ipairs(targets) do
        local enabled = Esp.Toggles and Esp.Toggles[t.type] and Esp.Toggles[t.type].Value
        if not enabled then
            local id = t.model
            if highlights[id] then clearEntry(id) end
        else
            seen[t.model] = true
            ensureEntry(t.model, t)
            if highlights[t.model] then
                highlights[t.model].FillColor = colors[t.type]
                if labels[t.model] then labels[t.model].label.TextColor3 = colors[t.type] end
                if tracers[t.model] then tracers[t.model].beam.Color = ColorSequence.new(colors[t.type]) end
            end
        end
    end
    for id in pairs(highlights) do
        if not seen[id] then clearEntry(id) end
    end
end

local function updateScale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local size = Esp.Options and Esp.Options.EspSize and Esp.Options.EspSize.Value or 14
    for id, entry in pairs(labels) do
        local target = highlights[id] and highlights[id].Parent
        if not target or not target.Parent then continue end
        local hrp = target:IsA("Model") and target:FindFirstChild("HumanoidRootPart") or target
        if hrp then
            local dist = (cam.CFrame.Position - hrp.Position).Magnitude
            local scale = math.clamp(120 / dist, 0.4, 1.6)
            entry.label.TextSize = math.clamp(size * scale * 0.7, 6, 16)
            entry.gui.Size = UDim2.new(0, 60 * scale, 0, 14 * scale)
        end
    end
end

function Esp.Init(options, toggles)
    Esp.Options = options
    Esp.Toggles = toggles
    task.spawn(function()
        while task.wait(0.2) do
            pcall(syncEntries)
        end
    end)
    RunService.RenderStepped:Connect(function()
        pcall(updateScale)
    end)
end

return Esp
