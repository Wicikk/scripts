return function(Window, Roaring)
    local LatestChangelog = {
        "21/8/2026",
        "<font color='rgb(0, 255, 0)'>+ Released Roaring script</font>",
        "<font color='rgb(0, 255, 0)'>+ Added Silent Aim (Sans + Tenna)</font>",
        "<font color='rgb(0, 255, 0)'>+ Added Spam Fake M1 (Knight, Jevil, Spamton, Flowery)</font>",
        "<font color='rgb(0, 255, 0)'>+ Added Auto Use Abilities</font>",
        "<font color='rgb(0, 255, 0)'>+ Added Kill All (auto TP behind survivor)</font>",
        "<font color='rgb(0, 255, 0)'>+ Added Bone / Scarlet Forest transparency</font>",
        "<font color='rgb(0, 255, 0)'>+ Added Berdly Eye Mark</font>",
        "<font color='rgb(0, 255, 0)'>+ Added No Spamton Ads / No Blind</font>",
        "<font color='rgb(0, 255, 0)'>+ Added Flowery Dash</font>",
        "<font color='rgb(0, 255, 0)'>+ Fixed Auto Block double hitbox bug</font>",
        "<font color='rgb(0, 255, 0)'>+ Auto Block converted from TabBox to Groupbox</font>",
    }

    local Environment = Roaring.Environment
    local Library = Roaring.Interface.Library

    local function CloneReference(Object)
        if Environment and Environment.cloneref then
            return Environment.cloneref(Object)
        end
        return Object
    end

    local Services = setmetatable({}, {
        __index = function(self, Name)
            return CloneReference(game:GetService(Name))
        end
    })

    local LocalPlayer = Services.Players.LocalPlayer
    local InfoTab = Window:AddTab("Info", "info")

    local User = InfoTab:AddLeftGroupbox("User Info")

    local ImageSize = Enum.ThumbnailSize.Size420x420
    local ImageType = Enum.ThumbnailType.HeadShot

    local Content = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, ImageType, ImageSize)

    User:AddImage("UserIcon", {
        Image = Content
    })

    User:AddLabel("Name: " .. LocalPlayer.Name, true)
    User:AddLabel("ID: " .. tostring(LocalPlayer.UserId), true)

    local Changelog = InfoTab:AddRightGroupbox("Changelog")
    Changelog:AddLabel("Script: Roaring", true)
    Changelog:AddLabel("Status: Released Script", true)
    Changelog:AddDivider()
    for Index, Change in pairs(LatestChangelog) do
        Changelog:AddLabel(Change, true)
    end

    local ExecutorName, ExecutorVersion = "Unknown", "N/A"
    if Environment and Environment.identifyexecutor then
        local ok, name, ver = pcall(Environment.identifyexecutor)
        if ok then
            ExecutorName = name or "Unknown"
            ExecutorVersion = ver or "N/A"
        end
    end

    local Executor = InfoTab:AddRightGroupbox("Executor Info")
    Executor:AddLabel("Name: " .. tostring(ExecutorName), true)
    Executor:AddLabel("Version: " .. tostring(ExecutorVersion), true)
    Executor:AddDivider()
    Executor:AddLabel("Test Result: ", true)

    if Environment and type(Environment.Results) == "table" then
        for Index, Result in pairs(Environment.Results) do
            if type(Result) == "string" then
                Result = Result:gsub("<", "(")
                Result = Result:gsub(">", ")")
                Executor:AddLabel(Result, true)
            end
        end
    end

    local Community = InfoTab:AddLeftGroupbox("Community")
    Community:AddButton("Copy Discord Invite", function()
        pcall(function()
            if toclipboard then
                toclipboard("https://dsc.gg/wicked")
                Library:Notify("Discord invite copied.")
            end
        end)
    end)
end

