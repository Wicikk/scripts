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

local function getTargets()
    local list = {}

    for _, m in ipairs(workspace:GetChildren()) do
        if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChildOfClass("Humanoid") then
            local role = m:GetAttribute("Role")
            local player = Players:GetPlayerFromCharacter(m)
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
    if tracers[id] then tracers[id]:Destroy() tracers[id] = nil end
    if labels[id] then labels[id]:Destroy() labels[id] = nil end
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

    if Esp.Toggles and Esp.Toggles.Tracers and Esp.Toggles.Tracers.Value and not tracers[id] then
        local beam = Instance.new("Beam")
        local a0 = Instance.new("Attachment")
        local a1 = Instance.new("Attachment")
        a0.Parent = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        a1.Parent = target.part
        beam.Attachment0 = a0
        beam.Attachment1 = a1
        beam.Color = ColorSequence.new(color)
        beam.Width0 = 0.05
        beam.Width1 = 0.05
        beam.Transparency = NumberSequence.new(0.5)
        beam.Parent = target.model
        tracers[id] = { beam = beam, a0 = a0, a1 = a1 }
    elseif (not Esp.Toggles or not Esp.Toggles.Tracers or not Esp.Toggles.Tracers.Value) and tracers[id] then
        tracers[id].beam:Destroy()
        if tracers[id].a0 then tracers[id].a0:Destroy() end
        if tracers[id].a1 then tracers[id].a1:Destroy() end
        tracers[id] = nil
    end

    if not labels[id] then
        local bp = Instance.new("BillboardGui")
        bp.Size = UDim2.new(0, 100, 0, 20)
        bp.AlwaysOnTop = true
        bp.LightInfluence = 0
        local tl = Instance.new("TextLabel")
        tl.BackgroundTransparency = 1
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.Font = Enum.Font.Gotham
        tl.TextColor3 = color
        tl.TextStrokeTransparency = 0.5
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
            local scale = math.clamp(200 / dist, 0.4, 2)
            entry.gui.Size = UDim2.new(0, size * scale * 6, 0, size * scale)
            entry.label.TextSize = math.clamp(size * scale, 8, size * 2)
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
