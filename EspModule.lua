local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Esp = {
    Options = nil,
    Toggles = nil
}

local highlights = {}
local labels = {}
local tracers = {}

local colors = {
    Survivors = Color3.fromRGB(0, 170, 255),
    Killers = Color3.fromRGB(255, 60, 60),
    Traps = Color3.fromRGB(20, 50, 180),
    TemEggs = Color3.fromRGB(255, 255, 255)
}

local hasDrawing = type(Drawing) == "table" and type(Drawing.new) == "function"

local function getOriginPosition()
    local cam = workspace.CurrentCamera
    if not cam then return Vector2.zero end

    local viewportSize = cam.ViewportSize
    local mode = Esp.Options and Esp.Options.TracersPosition and Esp.Options.TracersPosition.Value or "Bottom"

    if mode == "Mouse" then
        local mouse = LocalPlayer:GetMouse()
        return Vector2.new(mouse.X, mouse.Y)
    elseif mode == "Top" then
        return Vector2.new(viewportSize.X / 2, 0)
    elseif mode == "Center" then
        return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    else
        return Vector2.new(viewportSize.X / 2, viewportSize.Y)
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
    if highlights[id] then
        highlights[id]:Destroy()
        highlights[id] = nil
    end

    if labels[id] then
        if labels[id].gui then labels[id].gui:Destroy() end
        labels[id] = nil
    end

    if tracers[id] then
        if hasDrawing then
            tracers[id]:Remove()
        else
            tracers[id]:Destroy()
        end
        tracers[id] = nil
    end
end

local function createTracer()
    if hasDrawing then
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Transparency = 0.8
        return line
    else
        local folder = CoreGui:FindFirstChild("EspTracersFolder") or Instance.new("Folder")
        folder.Name = "EspTracersFolder"
        folder.Parent = CoreGui

        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BorderSizePixel = 0
        line.Parent = folder
        return line
    end
end

local function updateTracer(line, from, to, color)
    if hasDrawing then
        line.Color = color
        line.From = from
        line.To = to
        line.Visible = true
    else
        local distance = (to - from).Magnitude
        local center = (from + to) / 2
        local angle = math.atan2(to.Y - from.Y, to.X - from.X)

        line.BackgroundColor3 = color
        line.Position = UDim2.fromOffset(center.X, center.Y)
        line.Size = UDim2.fromOffset(distance, 1.5)
        line.Rotation = math.deg(angle)
        line.Visible = true
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
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.FillTransparency = 0.65
            hl.OutlineTransparency = 1
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = target.model
            highlights[id] = hl
        end
        highlights[id].FillColor = color
    elseif highlights[id] then
        highlights[id]:Destroy()
        highlights[id] = nil
    end

    if not labels[id] then
        local bp = Instance.new("BillboardGui")
        bp.Size = UDim2.new(0, 50, 0, 10)
        bp.AlwaysOnTop = true
        bp.LightInfluence = 0
        bp.StudsOffset = Vector3.new(0, 2.6, 0)

        local tl = Instance.new("TextLabel")
        tl.BackgroundTransparency = 1
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.Font = Enum.Font.Gotham
        tl.TextColor3 = Color3.fromRGB(255, 255, 255)
        tl.TextSize = 8
        tl.Text = target.name
        tl.Parent = bp
        bp.Parent = target.part

        labels[id] = { gui = bp, label = tl }
    end

    local dist = (cam.CFrame.Position - target.part.Position).Magnitude
    local scale = math.clamp(100 / dist, 0.4, 1.4)
    local baseSize = Esp.Options and Esp.Options.EspSize and Esp.Options.EspSize.Value or 14
    labels[id].label.TextSize = math.clamp(baseSize * scale * 0.5, 6, 12)
    labels[id].gui.Size = UDim2.new(0, 50 * scale, 0, 10 * scale)

    local tracerOn = Esp.Toggles and Esp.Toggles.Tracers and Esp.Toggles.Tracers.Value
    if tracerOn then
        local screenPos, onScreen = cam:WorldToViewportPoint(target.part.Position)
        if onScreen and screenPos.Z > 0 then
            if not tracers[id] then
                tracers[id] = createTracer()
            end
            updateTracer(tracers[id], getOriginPosition(), Vector2.new(screenPos.X, screenPos.Y), color)
        elseif tracers[id] then
            tracers[id].Visible = false
        end
    elseif tracers[id] then
        if hasDrawing then
            tracers[id]:Remove()
        else
            tracers[id]:Destroy()
        end
        tracers[id] = nil
    end
end

local function syncEsp()
    local targets = getTargets()
    local activeIds = {}

    for _, t in ipairs(targets) do
        local enabled = Esp.Toggles and Esp.Toggles[t.type] and Esp.Toggles[t.type].Value
        if enabled then
            activeIds[t.model] = true
            updateTarget(t)
        else
            clearEntry(t.model)
        end
    end

    for id in pairs(highlights) do
        if not activeIds[id] then clearEntry(id) end
    end
    for id in pairs(tracers) do
        if not activeIds[id] then clearEntry(id) end
    end
end

function Esp.Init(options, toggles)
    Esp.Options = options
    Esp.Toggles = toggles

    RunService.RenderStepped:Connect(function()
        syncEsp()
    end)
end

return Esp
