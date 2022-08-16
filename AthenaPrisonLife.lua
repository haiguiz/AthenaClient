---@diagnostic disable: undefined-global
-- watch as kin skids this all (if she can find it ever)

local ui, settings = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/GFXTI/AthenaClient/main/MainUi.lua"))()
local lib = ui:Library()
local combat = lib:Window("Combat")
local player = lib:Window("Player")
local misc   = lib:Window("Misc")

local sv = setmetatable({}, {__index = function(_, a) return game.GetService(game, a) end})
local lp = sv.Players.LocalPlayer
local cam = workspace.CurrentCamera
local clientenv
local remotes = {
    Replicate = sv.ReplicatedStorage.ReplicateEvent,
    Sound = sv.ReplicatedStorage.SoundEvent,
    Shoot = sv.ReplicatedStorage.ShootEvent,
    Melee = sv.ReplicatedStorage.meleeEvent,
    Reload = sv.ReplicatedStorage.ReloadEvent,
    Load = workspace.Remote.loadchar,
    Taze = workspace.Remote.tazePlayer,
    Arrest = workspace.Remote.arrest,
    Item = workspace.Remote.ItemHandler,
    Team = workspace.Remote.TeamEvent
}
local map = {}
local shields = {}
local loopkilltable = {}
local whitelist = {}

local togs = {
    GunMods = {
        Toggled = false;
        Automatic = false;
        InfiniteAmmo = false;
        FireRate = 0;
        Range = 5000;
        OneShotGuns = false;
        CustomFireate = false;
        CustomRange = false;
        Wallbang = false;
        SilentGun = false;
        InvisBullets = false;
        NoSpread = false;
    };
    Loopkill = {
        Toggled = false;
        Whitelist = false;
        Neutral = false;
        Custom = false;
        Inmates = false;
        Guards = false;
        Criminals = false;
    };
    CCB = {
        Toggled = false;
        R = 255;
        G = 255;
        B = 255;
        Rainbow = false;
    };
    GunOrder = {
        [1] = "M9";
        [2] = "M4A1";
        [3] = "Remington 870";
        [4] = "AK-47";
    };
    AutoRespawn = {
        Toggled = false;
        EquipOldWeapon = false;
    };
    CustomTeam = {
        R = 255;
        G = 255;
        B = 255;
    };
    AntiArmorSpam = false;
    AntiShield = false;
    ClickKill = false;
    AntiTaze = false;
    FastPunch = false;
    OnePunch = false;
    InfiniteStamina = false;
    Thorns = false;
}

local function SaveData(ba) 
	local b = ba
	for i,v in pairs(b) do
		if type(v) == "table" then
			for i2,v2 in pairs(v) do
				if i2 == "Key" and type(v2) ~= "string" then
					b[i][i2] = tostring(v2):sub(14)
				end
			end
		end
	end

	local encode = sv.HttpService:JSONEncode(b)
    writefile("athenaplconfig.json", encode)
end

local function LoadData()
	if not isfile("athenaplconfig.json") then
		writefile("athenaplconfig.json", "")
		return
	end

    local data = sv.HttpService:JSONDecode(readfile("athenaplconfig.json"))
	for i,v in pairs(data) do
		if type(v) == "table" then
			for i2,v2 in pairs(v) do
				if i2 == "Key" then
					data[i][i2] = Enum.KeyCode[v2]
				end
			end
		end
	end

	togs = data
end

local function getgun(order)
    for i,v in pairs(order) do
        remotes.Item:InvokeServer(workspace.Prison_ITEMS.giver[v].ITEMPICKUP)
        repeat task.wait() until lp.Backpack:FindFirstChild(v) or lp.Character:FindFirstChild(v)
    end
end

local function findgun()
    for i,v in pairs(lp.Character:GetChildren() and lp.Backpack:GetChildren()) do
        if v:IsA("Tool") and table.find({"M4A1", "M9", "AK-47", "Remington 870"}, v.Name) then
            return v
        end
    end

    getgun({"M9"})
    repeat task.wait() until lp.Backpack:FindFirstChild("M9") or lp.Character:FindFirstChild("M9")
    return lp.Backpack:FindFirstChild("M9") or lp.Character:FindFirstChild("M9")
end

local function respawn(Color)
    Color = Color and Color.Color or lp.TeamColor.Color
    local Saved1, Saved2 = lp.Character:GetPivot(), cam.CFrame
    remotes.Load:InvokeServer(nil, Color)
    lp.Character:PivotTo(Saved1)
    task.wait(.01)
    cam.CFrame = Saved2
end

local function team(Color)
    if table.find({"Bright orange", "Medium stone grey", "Bright yellow"}, Color) then
        remotes.Team:FireServer(Color)
        return
    end

    if Color == 'Bright blue' and #sv.Teams.Guards:GetPlayers() < 8 then
        remotes.Team:FireServer(Color)
        return
    end

    respawn(BrickColor.new(Color))
end

local function kill(tru, weapon)
    local args = {}
    local gun = weapon or findgun()
    
    for i,v in pairs(tru) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 then
            if v.TeamColor == lp.TeamColor then
                respawn(BrickColor.random())
                getgun({(gun and gun.Name) or "M9"})
                gun = findgun()
            end
            
            for i = 1, math.ceil(v.Character.Humanoid.Health / 10) do
                table.insert(args, {
                    ["RayObject"] = Ray.new(),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = v.Character.Head
                })
            end
        end
    end
    
    if gun and args[1] then
        remotes.Reload:FireServer(gun)
        remotes.Shoot:FireServer(args, gun)
        remotes.Reload:FireServer(gun)
    end
end

local function GetPlayer(a)
    if type(a) == "string" then
        a = a:lower()
        for i,v in pairs(sv.Players:GetPlayers()) do
            if v.Name:lower():find(a) or v.DisplayName:lower():find(a) then
                return v
            end
        end
    end

    if typeof(a) == "Instance" then
        local charmodel = a:FindFirstAncestorOfClass("Model", true)
        if charmodel then
            return sv.Players:GetPlayerFromCharacter(charmodel)
        end
    end
end

local function OnCharacterAdded(char)
    task.wait()
    local hum, clientenv = char:WaitForChild("Humanoid"), getsenv(char:WaitForChild("ClientInputHandler"))
    repeat task.wait() until not lp.Character or hum.Health == 0 or getconnections(remotes.Taze.OnClientEvent)[1] and getconnections(hum.Changed)[1]

    if not lp.Character or hum.Health == 0 then
        return
    end

    local taze, jump = getconnections(remotes.Taze.OnClientEvent)[1], getconnections(hum.Changed)[1]
    taze[togs.AntiTaze and "Disable" or "Enable"](taze)
    
    for i,v in pairs(debug.getupvalues(jump.Function)) do
        if type(v) ~= "number" or v == 5 then continue end
        debug.setupvalue(jump.Function, i, togs.InfiniteStamina and math.huge or 12)
    end

    local rs; rs = sv.RunService.RenderStepped:Connect(function()
        if togs.FastPunch then
            clientenv.cs.isRunning = false
            clientenv.cs.isFighting = false
        end
    end)

    local hd; hd = hum.Died:Connect(function()
        hd:Disconnect()
        rs:Disconnect()
        if togs.AutoRespawn.Toggled then
            local tool = char:FindFirstChildOfClass("Tool")
            local isgun = table.find({"M4A1", "M9", "AK-47", "Remington 870"}, tool and tool.Name or "")
            respawn()
            if togs.GunSpawn then
                print()
                getgun(togs.GunOrder)
            end

            if togs.AutoRespawn.EquipOldWeapon then
                local newtool = isgun and tool.Name
                if newtool then
                    print()
                    getgun(togs.GunOrder)
                    local item = lp.Backpack:WaitForChild(newtool, 10)
                    item.Parent = lp.Character
                end
            end
        end
    end)
end

local function PlayerCharacterAdded(plr)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local vests = {}
    char:WaitForChild("Humanoid")

    char.DescendantAdded:Connect(function(part)
        if part.Name == "vest" then
            table.insert(vests, part)
            if #vests > 1 and togs.AntiArmorSpam then
                table.foreach(vests, function(_, v)
                    if _ == 1 then return end
                    v:Destroy()
                end)
            end
        end

        if part.Name == "shield" then
            table.insert(shields, part)
        end
    end)
end

local function PlayerAdded(plr)
    PlayerCharacterAdded(plr)
    plr.CharacterAdded:Connect(function() -- CharacterAppearanceLoaded
        PlayerCharacterAdded(plr)
    end)
end

LoadData()

local thing = combat:ToggleDropdown("Gun mods", togs.GunMods.Toggled, function(a)
    togs.GunMods.Toggled = a
end)

thing:Toggle("Automatic", togs.GunMods.Automatic, function(a)
    togs.GunMods.Automatic = a
end)

thing:Toggle("One shot guns", togs.GunMods.OneShotGuns, function(a)
    togs.GunMods.OneShotGuns = a
end)

thing:Toggle("Silent gun", togs.GunMods.SilentGun, function(a)
    togs.GunMods.SilentGun = a
end)

thing:Toggle("Invisible bullets", togs.GunMods.InvisBullets, function(a)
    togs.GunMods.InvisBullets = a
end)

thing:Toggle("Wallbang", togs.GunMods.Wallbang, function(a)
    togs.GunMods.Wallbang = a
end)

thing:Toggle("No spread", togs.GunMods.NoSpread, function(a)
    togs.GunMods.NoSpread = a
end)

thing:Toggle("Infinite ammo", togs.GunMods.InfiniteAmmo, function(a)
    togs.GunMods.InfiniteAmmo = a
end)

thing:Toggle("Custom firerate", togs.GunMods.CustomFireate, function(a)
    togs.GunMods.CustomFireate = a
end)

thing:Toggle("Custom range", togs.GunMods.CustomRange, function(a)
    togs.GunMods.CustomRange = a
end)

thing:Slider("Range", 0, 5000, togs.GunMods.Range, false, function(a)
    togs.GunMods.Range = a
end)

thing:Slider("Fire rate", 0, 1, togs.GunMods.FireRate, true, function(a)
    togs.GunMods.FireRate = a
end)

local thing, loopkillselected = combat:ToggleDropdown("Loopkill", togs.Loopkill.Toggled, function(a)
    togs.Loopkill.Toggled = a
end)

thing:Toggle("Whitelist", togs.Loopkill.Whitelist, function(a)
    togs.Loopkill.Whitelist = a
end)

for i,v in next, {"Neutral", "Inmates", "Guards", "Criminals", "Custom"} do
    thing:Toggle(v, togs.Loopkill[v], function(a)
        togs.Loopkill[v] = a
        if a then
            if v ~= "Custom" then
                local b = sv.Teams:FindFirstChild(v)
                if b then
                    kill(b:GetPlayers())
                end
            else
                for i,v in pairs(sv.Players:GetPlayers()) do
                    if v ~= lp and not v.Team and (togs.Loopkill.Whitelist and not table.find(whitelist, v.Name) or not togs.Loopkill.Whitelist) then
                        task.spawn(function()
                            local char = v.Character
                            repeat task.wait() until not char:FindFirstChild("ForceField") and char:FindFirstChild("Humanoid")
                            kill({v})
                        end)
                    end
                end
            end
        end
    end)
end

thing:Button("Add/Remove", function()
    if loopkillselected and loopkillselected.Parent == sv.Players then
        local a = table.find(loopkilltable, loopkillselected.Name)

        if a then
            table.remove(loopkilltable, a)
        else
            table.insert(loopkilltable, loopkillselected.Name)
            local plr = loopkillselected
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health ~= 0 then
                repeat task.wait() until not plr.Character or not plr.Character:FindFirstChild("ForceField")
                kill({plr})
            end
        end
    end
end)

thing:TextBox("Loopkill", "players", function(a)
    loopkillselected = GetPlayer(a)
end)

local thing = combat:ToggleDropdown("Custom color bullets", togs.CCB.Toggled, function(a)
    togs.CCB.Toggled = a
end)

thing:Slider("R", 0, 255, togs.CCB.R, false, function(a)
    togs.CCB.R = a
end)

thing:Slider("G", 0, 255, togs.CCB.G, false, function(a)
    togs.CCB.G = a
end)

thing:Slider("B", 0, 255, togs.CCB.B, false, function(a)
    togs.CCB.B = a
end)

thing:Toggle("Rainbow", togs.CCB.Rainbow, function(a)
    togs.CCB.Rainbow = a
end)

combat:Toggle("Anti shield", togs.AntiShield, function(a)
    togs.AntiShield = a
end)

combat:Toggle("Fast punch", togs.FastPunch, function(a)
    togs.FastPunch = a
end)

combat:Toggle("One punch", togs.OnePunch, function(a)
    togs.OnePunch = a
end)

combat:Toggle("Thorns", togs.Thorns, function(a)
    togs.Thorns = a
end)

combat:Toggle("Gun spawn", togs.GunSpawn, function(a)
    togs.GunSpawn = a
end)

combat:Button("Get swat items", function()
    local oldteam
    if lp.Team ~= sv.Teams.Guards then
        oldteam = lp.TeamColor.Name
        if #sv.Teams.Guards:GetPlayers() < 8 then
            if lp.Team ~= sv.Teams.Criminals then
                team("Bright blue")
            else
                respawn(BrickColor.new("Bright blue"))
            end
        else
            lib:Note("Athena Client", "Guard team is full!", true)
            return
        end
    end

    remotes.Item:InvokeServer(workspace.Prison_ITEMS.clothes:FindFirstChild("Riot Police").ITEMPICKUP)
    remotes.Item:InvokeServer(workspace.Prison_ITEMS.giver:FindFirstChild("Riot Shield").ITEMPICKUP)
    
    if oldteam then
        team(oldteam)
    end
end)

combat:Button("Get guns", function()
    getgun(togs.GunOrder)
end)

for i = 1, 4 do
    combat:Dropdown("Gun slot "..tostring(i), {"M4A1", "M9", "Remington 870", "AK-47"}, function(a)
        togs.GunOrder[i] = a
    end)
end

local thing = player:ToggleDropdown("Auto respawn", togs.AutoRespawn.Toggled, function(a)
    togs.AutoRespawn.Toggled = a
end)

thing:Toggle("Equip old weapon", togs.AutoRespawn.EquipOldWeapon, function(a)
    togs.AutoRespawn.EquipOldWeapon = a
end)

local thing = player:ToggleDropdown("Teams", false, print)

thing:Slider("R", 0, 255, togs.CustomTeam.R, false, function(a)
    togs.CustomTeam.R = a
end)

thing:Slider("G", 0, 255, togs.CustomTeam.G, false, function(a)
    togs.CustomTeam.G = a
end)

thing:Slider("B", 0, 255, togs.CustomTeam.B, false, function(a)
    togs.CustomTeam.B = a
end)

thing:Button("Custom team",  function()
    respawn(BrickColor.new(Color3.fromRGB(togs.CustomTeam.R, togs.CustomTeam.G, togs.CustomTeam.B)))
end)

for i,v in next, {"Neutral", "Inmates", "Criminals"} do
    thing:Button(v, function()
        team(sv.Teams[v].TeamColor.Name)
    end)
end

thing:Button("Guards", function()
    if #sv.Teams.Guards:GetPlayers() < 8 then
        if lp.Team ~= sv.Teams.Criminals then
            team("Bright blue")
        else
            respawn(BrickColor.new("Bright blue"))
        end
    else
        lib:Note("Athena Client", "Guard team is full!", true)
    end
end)

player:Toggle("Anti taze", togs.AntiTaze, function(a)
    togs.AntiTaze = a
    local taze = getconnections(remotes.Taze.OnClientEvent)[1]
    if taze then
        taze[a and "Disable" or "Enable"](taze)
    end
end)

player:Toggle("Infinite stamina", togs.InfiniteStamina, function(a)
    togs.InfiniteStamina = a
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local jump = getconnections(lp.Character.Humanoid.Changed)[1]

        for i,v in pairs(debug.getupvalues(jump.Function)) do
            if type(v) ~= "number" or v == 5 then continue end
            debug.setupvalue(jump.Function, i, a and math.huge or 12)
        end
    end
end)

misc:Button("Crash V1", function()
    loadfile("CrashV1.lua")()
end)

misc:Toggle("Anti armor spam", togs.AntiArmorSpam, function(a)
    togs.AntiArmorSpam = a
end)

local namecall; namecall = hookmetamethod(game, "__namecall", function(s, ...)
    local args = {...}
    local method = getnamecallmethod()
    local calling = getcallingscript()

    if not checkcaller() then
        if table.find({"TaserInterface", "GunInterface"}, tostring(calling)) then
            if method == "FindPartOnRay" then
                local ignore = {lp.Character}
                if togs.GunMods.Wallbang then
                    table.foreach(map, function(_, v)
                        table.insert(ignore, v)
                    end)
                end

                if togs.AntiShield then
                    table.foreach(shields, function(_, v)
                        if not v.Parent then return end
                        table.insert(ignore, v)
                    end)
                end

                return workspace.FindPartOnRayWithIgnoreList(workspace, args[1], ignore)
            end
        end

        if method == "FireServer" then
            if s == remotes.Sound then
                if togs.SilentGun then
                    return
                end
            end

            if s == remotes.Melee then
                if togs.OnePunch then
                    for i = 1, math.ceil(args[1].Character.Humanoid.Health / 10) do
                        namecall(s, ...)
                    end
                end
            end

            if s == remotes.Shoot then
                if togs.GunMods.Toggled then
                    if togs.GunMods.InfiniteAmmo then
                        remotes.Reload.FireServer(remotes.Reload, args[2])
                        local gunstates = require(args[2].GunStates)
                        gunstates.CurrentAmmo = gunstates.MaxAmmo
                    end

                    if togs.GunMods.InvisBullets then
                        for i,v in pairs(args[1]) do
                            v["RayObject"] = Ray.new()
                            v["Distance"] = 0
                            v["Cframe"] = CFrame.new()
                        end
                    end

                    if togs.GunMods.OneShotGuns then
                        local a1 = args[1][1]
                        if a1.Hit then
                            local hitmodel = a1.Hit.FindFirstAncestorOfClass(a1.Hit, "Model", true)
                            local plr = sv.Players.GetPlayerFromCharacter(sv.Players, hitmodel)
                            if plr and hitmodel.FindFirstChild(hitmodel, "Humanoid") and hitmodel.Humanoid.Health ~= 0 and plr.Team ~= lp.Team then
                                for i = 1, math.ceil(hitmodel.Humanoid.Health / 10) do
                                    table.insert(args[1], {
                                        ["RayObject"] = Ray.new(),
                                        ["Distance"] = 0,
                                        ["Cframe"] = CFrame.new(),
                                        ["Hit"] = a1.Hit
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return namecall(s, unpack(args))
end)

local BrickColorHook; BrickColorHook = hookfunction(getrenv().BrickColor.Yellow, function(...)
    if not togs.CCB.Toggled or not table.find({"TaserInterface", "GunInterface"}, tostring(getcallingscript())) then return BrickColorHook(...) end
    local a = togs.CCB

    return a.Rainbow and BrickColor.random() or BrickColor.new(Color3.fromRGB(a.R, a.G, a.B))
end)

local RandomHook; RandomHook = hookfunction(getrenv().math.random, function(...)
    if not table.find({"TaserInterface", "GunInterface"}, tostring(getcallingscript())) then return RandomHook(...) end

    return togs.NoSpread and 0 or RandomHook(...)
end)

remotes.Replicate.OnClientEvent:Connect(function(bullets)
    for i,v in pairs(bullets) do
        if togs.Thorns then
            local dis, plr = math.huge

            if v.Hit and v.Hit:IsDescendantOf(lp.Character) then
                for i,v2 in pairs(sv.Players:GetPlayers()) do
                    if v2 ~= lp and not table.find(whitelist, v2.Name) and v2.Character and v2.Character:FindFirstChild("Humanoid") and 1 ~= 0 and v2.Character.Humanoid.Health ~= 0 and not v2.Character:FindFirstChild("ForceField") then
                        local tool = v2.Character:FindFirstChildOfClass("Tool")
                        if tool and table.find({"AK-47", "M4A1", "M9", "Remington 870", "Taser"}, tool.Name) then
                            local dbraymuzzle = (v.RayObject.Origin - tool.Muzzle.CFrame.p).magnitude
                            if dbraymuzzle < dis then
                                dis, plr = dbraymuzzle, v2
                            end
                        end
                    end
                end
            end

            if plr then
                kill({plr})
            end
        end
    end
end)

for i,v in pairs(workspace:GetChildren()) do
    if not sv.Players:GetPlayerFromCharacter(v) then
        table.insert(map, v)
    end
end

for i,v in pairs(sv.Players:GetPlayers()) do
    if v ~= lp then
        PlayerAdded(v)
    end
end

task.spawn(function()
    while task.wait(.1) do
        if togs.Loopkill.Toggled then
            local kt = {}
            for i, plr in pairs(sv.Players:GetPlayers()) do
                if plr ~= lp and plr.Character and not plr.Character:FindFirstChild("ForceField") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health ~= 0 then
                    if (togs.Loopkill.Whitelist and not table.find(whitelist, plr.Name) or not togs.Loopkill.Whitelist) then
                        if table.find(loopkilltable, plr.Name) or (togs.Loopkill.Custom and not plr.Team) or togs.Loopkill[tostring(plr.Team)] then
                            table.insert(kt, plr)
                        end
                    end
                end
            end

            if kt[1] ~= nil then
                kill(kt)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        SaveData(togs)
    end
end)

sv.Players.PlayerAdded:Connect(PlayerAdded)

lp.Backpack.ChildAdded:Connect(function(item)
    print()
    local a = item:FindFirstChild("GunStates")
    if a and togs.GunMods.Toggled then
        local mod = require(a)
        mod.AutoFire = togs.GunMods.Automatic or mod.AutoFire
        mod.FireRate = togs.GunMods.CustomFireate and togs.GunMods.FireRate or mod.FireRate
        mod.Range = togs.GunMods.CustomRange and togs.GunMods.Range or mod.Range
    end
end)

OnCharacterAdded(lp.Character)
lp.CharacterAdded:Connect(OnCharacterAdded)
