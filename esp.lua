local ESPModule = {}

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

function ESPModule.Init(Window, folderName)
    folderName = folderName or "Animatronics"

    local AnimatronicsFolder = Workspace:WaitForChild(folderName)

    local Config = {
        Enabled = false,
        SelectedAnimatronics = {},
        OnlyWhenEnabled = false,
        ShowName = true,
        ShowTracers = true,
        ShowDistance = true,
        ESPColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        TracerThickness = 1,
        MaxDistance = 1500,
        TracerOrigin = "Bottom",
    }

    local function getAnimatronicList()
        local list = {}
        for _, model in ipairs(AnimatronicsFolder:GetChildren()) do
            if model:IsA("Model") then
                table.insert(list, model.Name)
            end
        end
        table.sort(list)
        return list
    end

    local animatronicNames = getAnimatronicList()

    local ESPTab = Window:AddTab("ESP", "Visual")

    ESPTab:AddSection("Animatronics")

    local AnimatronicsDropdown = ESPTab:AddDropdown({
        Name = "Select Animatronics",
        Options = animatronicNames,
        Multi = true,
        Default = {},
        Callback = function(selected)
            Config.SelectedAnimatronics = selected
        end
    })

    ESPTab:AddButton({
        Name = "Refresh List",
        Callback = function()
            animatronicNames = getAnimatronicList()
            AnimatronicsDropdown:SetOptions(animatronicNames)
            Window:Notification({
                Name = "Refreshed",
                Description = "Found: " .. #animatronicNames,
                Duration = 3,
                Type = "Notification"
            })
        end
    })

    ESPTab:AddToggle({
        Name = "Enable ESP",
        Default = false,
        Callback = function(state)
            Config.Enabled = state
            if not state then
                for _, obj in pairs(ESPObjects) do
                    if obj.Active then destroyESPObject(obj) end
                end
            end
        end
    })

    ESPTab:AddToggle({
        Name = "ESP Only When Enabled",
        Default = false,
        Callback = function(state) Config.OnlyWhenEnabled = state end
    })

    ESPTab:AddSection("ESP Settings")

    ESPTab:AddToggle({
        Name = "Name Tags",
        Default = true,
        Callback = function(state) Config.ShowName = state end
    })

    ESPTab:AddToggle({
        Name = "Tracers",
        Default = true,
        Callback = function(state) Config.ShowTracers = state end
    })

    ESPTab:AddToggle({
        Name = "Distance",
        Default = true,
        Callback = function(state) Config.ShowDistance = state end
    })

    ESPTab:AddColorPicker({
        Name = "Text Color",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(color) Config.ESPColor = color end
    })

    ESPTab:AddColorPicker({
        Name = "Tracer Color",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(color) Config.TracerColor = color end
    })

    ESPTab:AddSlider({
        Name = "Text Size",
        Min = 8,
        Max = 20,
        Default = 13,
        Callback = function(value) Config.TextSize = value end
    })

    ESPTab:AddSlider({
        Name = "Tracer Thickness",
        Min = 1,
        Max = 4,
        Default = 1,
        Callback = function(value) Config.TracerThickness = value end
    })

    ESPTab:AddSlider({
        Name = "Max Distance",
        Min = 50,
        Max = 5000,
        Default = 1500,
        Callback = function(value) Config.MaxDistance = value end
    })

    ESPTab:AddDropdown({
        Name = "Tracer Origin",
        Options = {"Bottom", "Center", "Mouse", "Top"},
        Default = "Bottom",
        Multi = false,
        Callback = function(selected) Config.TracerOrigin = selected end
    })

    local ESPObjects = {}

    local parentGui = CoreGui:FindFirstChild("AnimatronicsTracers")
    if parentGui then parentGui:Destroy() end

    local TracerGui = Instance.new("ScreenGui")
    TracerGui.Name = "AnimatronicsTracers"
    TracerGui.ResetOnSpawn = false
    TracerGui.IgnoreGuiInset = true
    TracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TracerGui.DisplayOrder = 9999
    local safeParent = (gethui and gethui()) or CoreGui
    TracerGui.Parent = safeParent

    local function createTracerLine()
        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BorderSizePixel = 0
        line.Visible = false
        line.BackgroundColor3 = Color3.new(1, 1, 1)
        line.ZIndex = 9999
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 0.8
        stroke.Transparency = 0.2
        stroke.Color = Color3.new(0, 0, 0)
        stroke.Parent = line
        line.Parent = TracerGui
        return line
    end

    local function getTargetModel(name)
        local m = AnimatronicsFolder:FindFirstChild(name)
        if m and m:IsA("Model") then return m end
        return nil
    end

    local function getModelData(model)
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if not hrp then hrp = model:FindFirstChild("Torso") end
        if not hrp then hrp = model:FindFirstChild("UpperTorso") end
        if not hrp then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then hrp = part break end
            end
        end
        local head = model:FindFirstChild("Head")
        if not head then head = model:FindFirstChild("head") end
        return hrp, head
    end

    local function createESPObject(name)
        local obj = {}
        obj.Name = name
        obj.Model = nil
        obj.Billboard = nil
        obj.NameLabel = nil
        obj.DistanceLabel = nil
        obj.Tracer = createTracerLine()
        obj.Active = false
        return obj
    end

    local function setupESPObject(obj, model)
        obj.Model = model

        local bb = Instance.new("BillboardGui")
        bb.Name = "AnimatronicESPTag"
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.Size = UDim2.new(0, 200, 0, 36)
        bb.StudsOffset = Vector3.new(0, 0, 0)
        bb.ResetOnSpawn = false
        bb.MaxDistance = Config.MaxDistance

        local container = Instance.new("Frame")
        container.Name = "Container"
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 1, 0)
        container.Parent = bb

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "NameLabel"
        nameLbl.BackgroundTransparency = 1
        nameLbl.Size = UDim2.new(1, 0, 0, 18)
        nameLbl.Position = UDim2.new(0, 0, 0, 0)
        nameLbl.Font = Enum.Font.GothamMedium
        nameLbl.TextSize = Config.TextSize
        nameLbl.TextColor3 = Config.ESPColor
        nameLbl.TextStrokeTransparency = 0
        nameLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLbl.Text = obj.Name
        nameLbl.Parent = container

        local distLbl = Instance.new("TextLabel")
        distLbl.Name = "DistanceLabel"
        distLbl.BackgroundTransparency = 1
        distLbl.Size = UDim2.new(1, 0, 0, 14)
        distLbl.Position = UDim2.new(0, 0, 0, 17)
        distLbl.Font = Enum.Font.Gotham
        distLbl.TextSize = math.max(Config.TextSize - 2, 8)
        distLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLbl.TextStrokeTransparency = 0
        distLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        distLbl.Text = ""
        distLbl.Parent = container

        bb.Parent = model
        obj.Billboard = bb
        obj.NameLabel = nameLbl
        obj.DistanceLabel = distLbl

        obj.Active = true
    end

    local function destroyESPObject(obj)
        if obj.Billboard then obj.Billboard:Destroy() obj.Billboard = nil end
        if obj.Tracer then obj.Tracer.Visible = false end
        obj.Model = nil
        obj.Active = false
    end

    local function getTracerOrigin()
        local viewport = Camera.ViewportSize
        if Config.TracerOrigin == "Bottom" then
            return Vector2.new(viewport.X / 2, viewport.Y)
        elseif Config.TracerOrigin == "Center" then
            return Vector2.new(viewport.X / 2, viewport.Y / 2)
        elseif Config.TracerOrigin == "Top" then
            return Vector2.new(viewport.X / 2, 0)
        elseif Config.TracerOrigin == "Mouse" then
            local mouseLoc = UserInputService:GetMouseLocation()
            return Vector2.new(mouseLoc.X, mouseLoc.Y)
        end
        return Vector2.new(viewport.X / 2, viewport.Y)
    end

    local function updateESP()
        if not Config.Enabled then return end

        for name, isSelected in pairs(Config.SelectedAnimatronics) do
            if isSelected then
                local model = getTargetModel(name)
                local obj = ESPObjects[name]
                if not obj then
                    obj = createESPObject(name)
                    ESPObjects[name] = obj
                end

                if model and model.Parent then
                    local isEnabled = model:GetAttribute("AnimatronicEnabled")
                    if Config.OnlyWhenEnabled and isEnabled ~= true then
                        if obj.Active then destroyESPObject(obj) end
                    else
                    if not obj.Active or obj.Model ~= model then
                        if obj.Active then destroyESPObject(obj) end
                        setupESPObject(obj, model)
                    end

                    local hrp, head = getModelData(model)
                    if hrp then
                        local camPos = Camera.CFrame.Position
                        local dist = (camPos - hrp.Position).Magnitude

                        if dist > Config.MaxDistance then
                            if obj.Billboard then obj.Billboard.Enabled = false end
                            if obj.Tracer then obj.Tracer.Visible = false end
                        else
                            if obj.Billboard then
                                obj.Billboard.Enabled = Config.ShowName or Config.ShowDistance
                                obj.Billboard.MaxDistance = Config.MaxDistance
                                obj.Billboard.Adornee = head or hrp

                                if head and head:IsA("BasePart") then
                                    obj.Billboard.StudsOffset = Vector3.new(0, head.Size.Y / 2 + 0.8, 0)
                                else
                                    obj.Billboard.StudsOffset = Vector3.new(0, 1.5, 0)
                                end

                                if obj.NameLabel then
                                    obj.NameLabel.Visible = Config.ShowName
                                    obj.NameLabel.TextColor3 = Config.ESPColor
                                    obj.NameLabel.TextSize = Config.TextSize
                                    obj.NameLabel.Text = obj.Name
                                end
                                if obj.DistanceLabel then
                                    obj.DistanceLabel.Visible = Config.ShowDistance
                                    obj.DistanceLabel.TextSize = math.max(Config.TextSize - 2, 8)
                                    obj.DistanceLabel.Text = math.floor(dist) .. " studs"
                                end
                            end

                            if obj.Tracer then
                                if Config.ShowTracers then
                                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                                    if onScreen then
                                        local origin = getTracerOrigin()
                                        local target = Vector2.new(screenPos.X, screenPos.Y)
                                        local distance = (target - origin).Magnitude
                                        if distance > 1 then
                                            local angle = math.atan2(target.Y - origin.Y, target.X - origin.X)
                                            local mid = (origin + target) / 2
                                            obj.Tracer.Size = UDim2.new(0, distance, 0, Config.TracerThickness)
                                            obj.Tracer.Position = UDim2.new(0, mid.X, 0, mid.Y)
                                            obj.Tracer.Rotation = math.deg(angle)
                                            obj.Tracer.BackgroundColor3 = Config.TracerColor
                                            obj.Tracer.Visible = true
                                        else
                                            obj.Tracer.Visible = false
                                        end
                                    else
                                        obj.Tracer.Visible = false
                                    end
                                else
                                    obj.Tracer.Visible = false
                                end
                            end
                        end
                    end
                    end
                else
                    if obj.Active then destroyESPObject(obj) end
                end
            else
                local obj = ESPObjects[name]
                if obj and obj.Active then destroyESPObject(obj) end
            end
        end

        for name, obj in pairs(ESPObjects) do
            if obj.Active and not Config.SelectedAnimatronics[name] then
                destroyESPObject(obj)
            end
        end
    end

    local lastUpdate = 0
    RunService.RenderStepped:Connect(function()
        local now = tick()
        if now - lastUpdate >= 0.03 then
            lastUpdate = now
            updateESP()
        end
    end)

    AnimatronicsFolder.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            task.wait(0.2)
            local found = false
            for _, n in ipairs(animatronicNames) do
                if n == child.Name then found = true break end
            end
            if not found then
                table.insert(animatronicNames, child.Name)
                table.sort(animatronicNames)
                AnimatronicsDropdown:SetOptions(animatronicNames)
            end
        end
    end)

    AnimatronicsFolder.ChildRemoved:Connect(function(child)
        if child:IsA("Model") then
            for i, n in ipairs(animatronicNames) do
                if n == child.Name then
                    table.remove(animatronicNames, i)
                    break
                end
            end
            AnimatronicsDropdown:SetOptions(animatronicNames)
            local obj = ESPObjects[child.Name]
            if obj and obj.Active then destroyESPObject(obj) end
            Config.SelectedAnimatronics[child.Name] = nil
        end
    end)

end

return ESPModule
