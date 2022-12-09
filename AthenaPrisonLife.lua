local DEBUGGING_MODE = true

--[[
    https://discord.gg/ng8yFn2zX6  -- Our discord, come report bugs and help development.
    Credits:
        D-C Team -- trolling those skiddies that say they know lua (Kin, Dis, JNRaid, etc...)
        sawd#2906 -- all the scripting + ui lib
        FATE#8209 -- helpin with humanoid stuff (i never touched it before)
        Swaggered#8967 -- he tells me to do shit idk
	    dm me (sawd) if u want credit here
    TODO:
        fuckin no clue
]]

-- feel free to LEARN from this, not straight up steal it.

-- Variables used basically 2 or more places not in the same do end
-- General Purpose
local sv =    setmetatable({}, {__index = function(_, a) return game.GetService(game, a) end})
local lp =    sv.Players.LocalPlayer
local isv2 =  ({identifyexecutor()})[2]:find("v2")
local HasM4 = sv.MarketplaceService:UserOwnsGamePassAsync(lp.UserId, 96651)
local ffalse = isv2 and 0 or false
local cam = workspace.CurrentCamera

-- Created Instances
local ChatLogs =  Instance.new("ScreenGui", sv.CoreGui)
local workspacedrawingobjects = Instance.new("Model", workspace)

-- Tables (holy shit)
local chatticks,
allowedtools,
brickcolors,
drawingobjects,
loopkilltable,
map,
shields,
athenausers,
connections,
giventhorns,
givenantitouch,
givenoneshot,
givenkillaura,
Commandstbl,
notes,
givenantipunch,
oldctrl, tools, remotes, positions, togs = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{w = 0, s = 0, a = 0, d = 0}, 
{
    ["M4A1"] =          workspace.Prison_ITEMS.giver.M4A1.ITEMPICKUP;
    ["AK-47"] =         workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP;
    ["Remington 870"] = workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP;
    ["M9"] =            workspace.Prison_ITEMS.giver.M9.ITEMPICKUP;
    ["Riot Shield"] =   workspace.Prison_ITEMS.giver["Riot Shield"].ITEMPICKUP;
    ["Crude Knife"] =   workspace.Prison_ITEMS.single["Crude Knife"].ITEMPICKUP;
    ["Hammer"] =        workspace.Prison_ITEMS.single.Hammer.ITEMPICKUP;
},
{
    Replicate = sv.ReplicatedStorage.ReplicateEvent,
    Sound =     sv.ReplicatedStorage.SoundEvent,
    Shoot =     sv.ReplicatedStorage.ShootEvent,
    Melee =     sv.ReplicatedStorage.meleeEvent,
    Reload =    sv.ReplicatedStorage.ReloadEvent,
    Load =      workspace.Remote.loadchar,
    Taze =      workspace.Remote.tazePlayer,
    Arrest =    workspace.Remote.arrest,
    Item =      workspace.Remote.ItemHandler,
    Team =      workspace.Remote.TeamEvent,
    Weld =      sv.ReplicatedStorage.weldEvent
},
{
    ["Nexus"] =     CFrame.new(953.729492, 101.462059, 2357.59204, -0.0105626266, 0.00707700523, 0.999919176, -9.5477144e-06, 0.999974966, -0.00707750069, -0.99994421, -8.43010639e-05, -0.0105622951),
    ["Cells"] =     CFrame.new(916.91394, 101.473854, 2456.18604, -0.999888539, 5.29824283e-05, -0.0149285085, -1.79755625e-05, 0.999988735, 0.00475434074, 0.0149285914, 0.00475407997, -0.999877274),
    ["Armory"] =    CFrame.new(837.355896, 101.472763, 2266.63647, 0.999749184, -8.90113733e-05, 0.0223938301, -1.8733137e-05, 0.999988437, 0.00481109042, -0.0223939978, -0.00481030252, 0.99973762),
    ["Wall"] =      CFrame.new(823.160522, 131.507324, 2569.33813, 1, 1.38536689e-06, -5.78099862e-05, -1.36256517e-06, 0.999999821, 0.000549363845, 5.78106847e-05, -0.000549363845, 0.999999821),
    ["Yard"] =      CFrame.new(736.615173, 99.6887665, 2512.97119, 0.999997199, -3.40389306e-06, -0.00238491991, -4.46612347e-07, 0.999998689, -0.00161580928, 0.00238492223, 0.00161580567, 0.999995887),
    ["Sky wall"] =  CFrame.new(823.119202, 397.705841, 2672.00366, 0.999975801, 2.95520476e-05, 0.00695856567, 6.81028922e-08, 0.99999094, -0.0042566075, -0.00695862854, 0.00425650505, 0.999966741),
    ["Front"] =     CFrame.new(504.223053, 126.521599, 2421.09814, -0.00433305278, -0.0047102836, 0.999979556, -1.8185101e-05, 0.999988914, 0.00471024914, -0.999990642, 2.21143955e-06, -0.00433309004),
    ["Crim base"] = CFrame.new(-860.264526, 95.9438858, 2085.03564, 0.0224340688, -0.00536062894, -0.999733925, -3.02877697e-06, 0.999985635, -0.00536204642, 0.99974829, 0.000123324076, 0.0224337298),
    ["Crim pad"] =  CFrame.new(-977.83075, 110.823158, 2053.60034, -0.00541115459, -0.000807852659, -0.99998498, -1.53944185e-07, 0.999999642, -0.000807863718, 0.999985337, -4.22384346e-06, -0.00541115273)
}, 
{ -- yeah it should be "settings" but you are a little ni
    GunMods = {
        Toggled =           false;
        Automatic =         false;
        InfiniteAmmo =      false;
        OneShotGuns =       false;
        CustomFireate =     false;
        CustomRange =       false;
        Wallbang =          false;
        SilentGun =         false;
        InvisBullets =      false;
        NoSpread =          false;
        FireRate =          0;
        Range =             5000;
    };
    Loopkill = {
        Toggled =           false;
        Neutral =           false;
        Custom =            false;
        Inmates =           false;
        Guards =            false;
        Criminals =         false;
    };
    Killaura = {
        Toggled =           false;
        Neutral =           false;
        Custom =            false;
        Inmates =           false;
        Guards =            false;
        Criminals =         false;
    };
    CCB = {
        Toggled =           false;
        Rainbow =           false;
        R =                 255;
        G =                 255;
        B =                 255;
    };
    GunOrder = {
        [1] =               "M9";
        [2] =               "M4A1";
        [3] =               "Remington 870";
        [4] =               "AK-47";
    };
    AutoRespawn = {
        Toggled =           false;
        EquipOldWeapon =    false;
        ForceField =        false;
    };
    CustomTeam = {
        R =                 255;
        G =                 255;
        B =                 255;
    };
    Noclip = {
        Toggled =           false;
    };
    Drawing = {
        Toggled =           false;
        Delete =            false;
        InstaKill =         false;
        Refresh =           0.2;
        Gun =               "AK-47";
    };
    Fly = {
        Toggled =           false;
        Speed =             5;
    };
    SilentAim = {
        Toggled =           false;
        Punch =             false;
        DeadCheck =         false;
        Wallcheck =         false;
        ShowFov =           false;
        Spread =            false;
        Radius =            500;
        Range =             800;
        HitPart =           "Head";
    };
    Whitelist = { -- sum friends
                            "MrGFXTI",
                            "Shadows_Overlord",
                            "PpScoped",
                            "romefalls",
                            "Darkgirlsilence",
                            "TheSon99",
                            "Crucifixations"
    };
    Admin = {
        Prefix =            "-";
        FocusKey =          Enum.KeyCode.Semicolon;
        Admins =            {}
    };
    AntiShield =            false;
    ClickKill =             false;
    AntiTaze =              false;
    TazeAura =              false;
    FastPunch =             false;
    OnePunch =              false;
    InfiniteStamina =       false;
    Thorns =                false;
    SpamArrestAura =        false;
    AntiBring =             false;
    AntiCrash =             false;
    AntiArrest =            false;
    AntiCriminal =          false;
    AntiPunch =             false;
    NoFade =                false;
    AntiTouch =             false;
    SpamPunch =             false;
    Godmode =               false;
    EDN =                   false;
    ADHRP =                 false;
    AGK =                   false;
    SpamArrestPower =       10;
    BringTool =             "Hammer";
}

-- Nils
local breaksa, staying, cs, punchfunc, selected, viewing

-- Functions
-- Math

local function V2toV3(vec)
    return Vector3.new(vec.X, vec.Y, 0)
end

local function V3toV2(vec)
    return Vector2.new(vec.X, vec.Y)
end

local function Ease(x)
    return 1 - math.pow(1 - x, 5)
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function ProperRay(From, To, ...)
    return workspace.FindPartOnRayWithIgnoreList(workspace, Ray.new(From, (To - From).unit * (From - To).magnitude), ...)
end

local function GetClosestToMousePos(ignore, wallcheck, range, radius, deadcheck, hitpart)
    local position, hit

    for i,v in pairs(sv.Players.GetPlayers(sv.Players)) do
        if v ~= lp and v.TeamColor ~= lp.TeamColor and lp.Character and lp.Character.FindFirstChild(lp.Character, "Head") and not table.find(togs.Whitelist, v.Name) and v.Character and v.Character.FindFirstChild(v.Character, "Humanoid") and v.Character.FindFirstChild(v.Character, hitpart) and ((deadcheck and v.Character.Humanoid.Health == 0) or true) then
            local hpos = v.Character[hitpart].CFrame
            local pos, vis = cam.WorldToViewportPoint(cam, hpos.p)
            local disfromc = lp.DistanceFromCharacter(lp, hpos.p)

            if vis and disfromc < range then
                local mpos = lp.GetMouse(lp)
                local dis = (Vector2.new(pos.X, pos.Y) - Vector2.new(mpos.X, mpos.Y)).magnitude

                if dis < radius then
                    if wallcheck then
                        local ignores = cam.GetPartsObscuringTarget(cam, {hpos.p}, {lp.Character})

                        if #ignores ~= 0 then
                            continue
                        end
                    end

                    radius = dis
                    hit = v.Character[hitpart]
                    position = hpos.p
                end
            end
        end
    end

    return position, hit
end

-- Data

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
    if not isfolder("AthenaSchematics") then
        makefolder("AthenaSchematics")
        makefolder("AthenaSchematics/Saved")
    end

	if not isfile("athenaplconfig.json") then
		writefile("athenaplconfig.json", sv.HttpService:JSONEncode(togs))
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

    for i,v in pairs(togs) do
        if type(v) == "table" then
            if not data[i] then
                data[i] = v
                
                continue
            end

            for i2,v2 in pairs(v) do
                if not data[i][i2] then 
                    data[i][i2] = v2
                end
            end
        else
            if not data[i] then
                data[i] = v
            end
        end
    end

	togs = data
end

-- Drawing library

local function OutlinedBox(props) -- some drawing stuff since im planning to convert a bunch of shit to it lol
    local d = setmetatable({["M"] = Drawing.new("Square")}, {
        __index = function(t, k)
            return props[k]
        end,
        
        __newindex = function(t, k, v)
            if #k == 1 then
                v.Visible = true
                v.ZIndex = props.ZIndex or 0
                v.Color = props.OutlineColor or Color3.new()
                v.Thickness = props.Thickness or 2
                
                rawset(t, k, v)
                
                return
            end
            
            props[k] = v
            
            if k == "Color" then
                for i,v2 in next, t do
                    if #i ~= 1 then continue end
                    
                    v2.Color = v
                end
            end
            
            t.Resize(props.Pos, props.Size)
            t.Edit(props)
        end
    })

    rawset(d, "Remove", function()
        table.foreach(d, function(_, v)
            pcall(function()
                v:Remove()
            end)
        end)
    end)
    
    rawset(d, "Resize", function(pos, size)
        d.T.From = pos
        d.T.To   = pos + Vector2.new(size.X, 0)
        d.B.From = pos - Vector2.new(0, size.Y)
        d.B.To   = pos + Vector2.new(size.X, -size.Y)
        d.L.From = pos
        d.L.To   = pos - Vector2.new(0, size.Y)
        d.R.From = pos + Vector2.new(size.X, 0)
        d.R.To   = pos + Vector2.new(size.X, -size.Y)
        d.M.Size = size
        d.M.Position = pos - Vector2.new(0, size.Y)
    end)

    rawset(d, "Edit", function(props)
        for i, v in next,  props do
            for _, v2 in next, d do
                if type(v2) ~= "table" or not pcall(function() v2[i] = v2[i] end) then continue end

                v2[i] = v
            end
        end
    end)

    d["T"] = Drawing.new("Line")
    d["B"] = Drawing.new("Line")
    d["L"] = Drawing.new("Line")
    d["R"] = Drawing.new("Line")

    d.M.Visible = true
    d.M.ZIndex = props.ZIndex and props.ZIndex - 1 or -1
    d.M.Color = props.Color or Color3.new()
    d.M.Filled = true
    d.M.Transparency = props.Visibility or 1
    
    d.Resize(props.Pos, props.Size)

    return d
end

local function Text(props)
    local d = setmetatable({}, {
        __index = function(t, k)
            return props[k]
        end,
        
        __newindex = function(t, k, v)
            if #k == 1 then -- default shit
                v.Visible = true
                v.ZIndex = props.ZIndex or 0
                v.Color = props.Color or Color3.new()
                v.Center = props.Centered ~= nil and props.Centered or false
                v.Text = props.Text or ""
                v.Outline = true
                v.Size = props.Size and props.Size or 18
                v.Font = props.Font or Drawing.Fonts.System
                v.Transparency = props.Visibility or 1
                
                rawset(t, k, v)
                
                return
            end
            
            props[k] = v
            
            t.Edit(props)
        end
    })

    rawset(d, "Remove", function()
        d.T:Remove()
    end)
    
    rawset(d, "Edit", function(props)
        for i, v in next,  props do
            for _, v2 in next, d do
                if type(v2) ~= "table" or not pcall(function() v2[i] = v2[i] end) then continue end

                v2[i] = v
            end
        end
    end)
    
    d["T"]       = Drawing.new("Text")
    d.T.Position = props.Pos or Vector2.new()
    
    return d
end

local LoaderUpdate do -- drawing looks like 5x better on syn v3
	local Loads = {
		[1] = "Ui setup";
		[2] = "Connections";
		[3] = "Loops";
		[4] = "Finished loading"
	}
	local i = 0

	local MBP, LTP, LITP = Instance.new("Vector3Value"), Instance.new("Vector3Value"), Instance.new("Vector3Value")
	MBP.Value = V2toV3(Vector2.new(cam.ViewportSize.X / 2 - 150, -100))
	LTP.Value = V2toV3(Vector2.new(cam.ViewportSize.X / 2, -190))
	LITP.Value = V2toV3(Vector2.new(cam.ViewportSize.X / 2, -125))

	local MainBox = OutlinedBox({
		OutlineColor = Color3.new(), -- outline color
		Color = Color3.fromRGB(38, 38, 38), -- box color
		Thickness = 2, -- outline thickness
		Visibility = .5, -- Opacity / Transparency / Visibility
		Size = Vector2.new(300, 100), -- size
		Pos = V3toV2(MBP.Value), -- pos
		ZIndex = 0 -- Zindex
	})

	local LoadText = Text({
		Text = "Athena Loader",
		Pos = V3toV2(LTP.Value),
		Size = isv2 and 22 or 18,
		Font = Drawing.Fonts.System,
		Color = Color3.fromRGB(33, 57, 129),
		ZIndex = 2,
		Centered = true
	})

	local LoadInfoText = Text({
		Text = "Functions",
		Pos = V3toV2(LITP.Value),
		Size = isv2 and 19 or 15,
		Font = Drawing.Fonts.System,
		Color = Color3.new(1, 1, 1),
		ZIndex = 2,
		Centered = true
	})

	local MBPS, LTPS, LITPS; MBPS = MBP.Changed:Connect(function(vec)
		MainBox.Pos = V3toV2(vec)
	end)

	LTPS = LTP.Changed:Connect(function(vec)
		LoadText.T.Position = V3toV2(vec)
	end)

	LITPS = LITP.Changed:Connect(function(vec)
		LoadInfoText.T.Position = V3toV2(vec)
	end)

	local AB = Vector3.new(0, math.round(cam.ViewportSize.Y / 2) + 195, 0)
	sv.TweenService:Create(MBP, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Value = MBP.Value + AB}):Play()
	sv.TweenService:Create(LTP, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Value = LTP.Value + AB}):Play()
	sv.TweenService:Create(LITP, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Value = LITP.Value + AB}):Play()
	task.wait(1.6)

	local LoaderBox = OutlinedBox({
		OutlineColor = Color3.new(), -- outline color
		Color = Color3.fromRGB(33, 57, 129), -- box color
		Thickness = 2, -- outline thickness
		Visibility = 1, -- Opacity / Transparency / Visibility
		Size = Vector2.new(0, 30), -- size
		Pos = Vector2.new(cam.ViewportSize.X / 2 - 130, math.round(cam.ViewportSize.Y / 2) + 60), -- pos
		ZIndex = 0 -- Zindex
	})

	function LoaderUpdate()
		i += 1
		LoadInfoText.Text = Loads[i]

		for _ = 1, 65 do
			task.wait()
			LoaderBox.Size += Vector2.new(1, 0)
		end

		if i > 3 then
			task.wait(1)
			LoaderBox.Remove()
			MainBox.Remove()
			LoadInfoText.Remove()
			LoadText.Remove()
			LTPS:Disconnect()
			MBPS:Disconnect()
			LITPS:Disconnect()
		end
	end
end

local function Note(txt, err)
    task.spawn(function()
        local ins = {}
        table.insert(notes, ins)
        local mainv, textv = Instance.new("Vector3Value"), Instance.new("Vector3Value")

        ins.Main = OutlinedBox({
            OutlineColor = Color3.new(), -- outline color
            Color = not err and Color3.fromRGB(38, 38, 38) or Color3.new(.5, 0, 0), -- box color
            Thickness = 2, -- outline thickness
            Visibility = .5, -- Opacity / Transparency / Visibility
            Size = Vector2.new(500, 40), -- size
            Pos = Vector2.new((cam.ViewportSize.X / 2) - 250, cam.ViewportSize.Y + 40), -- pos
            ZIndex = 0 -- Zindex
        })

        ins.Text = Text({
            Text = "",
            Pos = Vector2.new((cam.ViewportSize.X / 2) - 245, cam.ViewportSize.Y + 10),
            Size = isv2 and 18 or 22,
            Centered = false,
            Font = Drawing.Fonts.System,
            Color = Color3.new(1, 1, 1),
            ZIndex = 2,
        })

        ins.Mainv = mainv
        ins.Textv = textv

        mainv.Value, textv.Value = V2toV3(ins.Main.Pos), V2toV3(ins.Text.Pos)

        local mt = game:GetService("TweenService"):Create(mainv, TweenInfo.new(.5, Enum.EasingStyle.Quad), {Value = V2toV3(ins.Main.Pos - Vector2.new(0, 60) - (Vector2.new(0, 44 * (#notes - 1))))})
        local tt = game:GetService("TweenService"):Create(textv, TweenInfo.new(.5, Enum.EasingStyle.Quad), {Value = V2toV3(ins.Text.Pos - Vector2.new(0, 60) - (Vector2.new(0, 44 * (#notes - 1))))})
        mt:Play()
        tt:Play()

        local mc; mc = mainv.Changed:Connect(function(vec)
            ins.Main.Pos = V3toV2(vec)
        end)

        local tc; tc = textv.Changed:Connect(function(vec)
            ins.Text.T.Position = V3toV2(vec)
        end)

        mt.Completed:Wait()

        for i = 1, #txt do
            task.wait(math.random(3, 5) / 75)
            ins.Text.T.Text = txt:sub(1, i)
        end

        task.wait(3)

        task.spawn(function()
            for i = 1, 0, -.1 do
                task.wait()
                ins.Text.Visibility = i
            end

            ins.Text.Remove()
        end)

        local x = ins.Main.Size.X
        for i = 0, .7, .005 do
            task.wait()
            ins.Main.Size = Vector2.new(Lerp(x, 0, Ease(i)), ins.Main.Size.Y)
        end

        table.remove(notes, table.find(notes, ins))
        for i,v in pairs(notes) do
            game:GetService("TweenService"):Create(v.Mainv, TweenInfo.new(.5, Enum.EasingStyle.Quad), {Value = V2toV3(v.Main.Pos + Vector2.new(0, 44))}):Play()
            game:GetService("TweenService"):Create(v.Textv, TweenInfo.new(.5, Enum.EasingStyle.Quad), {Value = V2toV3(v.Text.Pos + Vector2.new(0, 44))}):Play()
        end
        tc:Disconnect()
        mc:Disconnect()
        ins.Main.Remove()
    end)
end

-- String functions

local function GetPlayer(a)
    if not a then return end

    if type(a) == "string" then
        a = a:lower()
        for i,v in pairs(sv.Players.GetPlayers(sv.Players)) do
            if v.Name:lower():find(a) or v.DisplayName:lower():find(a) then
                return v
            end
        end
    end

    if typeof(a) == "Instance" then
        local charmodel = a.FindFirstAncestorOfClass(a, "Model", true)

        if charmodel then
            return sv.Players.GetPlayerFromCharacter(sv.Players, charmodel)
        end
    end
end

local function AGetPlayer(str) -- its awful ik
    if table.find({"g", "guard", "guards"}, str:lower()) then return sv.Teams.Guards:GetPlayers() end
    if table.find({"c", "crim", "crims", "criminal", "criminal"}, str:lower()) then return sv.Teams.Criminals:GetPlayers() end
    if table.find({"p", "i", "inmate", "prisoner", "inmates", "prisoners"}, str:lower()) then return sv.Teams.Inmates:GetPlayers() end
    if table.find({"n", "neutral", "neutrals", "skid", "skids"}, str:lower()) then return sv.Teams.Neutral:GetPlayers() end
    if table.find({"all", "everyone"}, str:lower()) then return sv.Players:GetPlayers() end
    if table.find({"custom", "cu", "customs"}, str:lower()) then
        local customs = {}

        for i,v in pairs(sv.Players:GetPlayers()) do
            if not v.Team then
                table.insert(customs, v)
            end
        end

        return customs
    end

    return {GetPlayer(str)}
end

local function GetTeam(str) -- literally just the function above what am i doing with my life
    if table.find({"g", "guard", "guards"}, str:lower()) then return "Guards" end
    if table.find({"c", "crim", "crims", "criminal", "criminal"}, str:lower()) then return "Criminals" end
    if table.find({"p", "i", "inmate", "prisoner", "inmates", "prisoners"}, str:lower()) then return "Inmates" end
    if table.find({"n", "neutral", "neutrals", "skid", "skids"}, str:lower()) then return "Neutral" end
    if table.find({"custom", "cu", "customs"}, str:lower()) then return "Custom" end
end

local function RandomString(int)
	local charset = "QWERTYUIOPASDFGHJKLZXCVBNM1234567890"
	local fstr = ""

	for i = 1,int do
		local r = math.random(1, #charset)
		fstr = fstr..charset:sub(r, r)
	end

	return fstr
end

-- World

local function Goto(pos) -- since tweenservice actually makes shit go through appearently
    lp.Character:WaitForChild("HumanoidRootPart")

    sv.TweenService:Create(lp.Character.HumanoidRootPart, TweenInfo.new(0), {CFrame = pos}):Play()
end

local function GetGun(order)
    lp:WaitForChild("Backpack")

    for i,v in pairs(order) do
        if v == "None" then continue end
        if v == "M4A1" and not HasM4 then v = "AK-47" end

        remotes.Item:InvokeServer(tools[v])
        repeat task.wait() until (lp:FindFirstChild("Backpack") and lp.Backpack:FindFirstChild(v)) or lp.Character:FindFirstChild(v)
    end
end

local function FindGun()
    lp:WaitForChild("Backpack")

    for i,v in pairs(lp.Character:GetChildren() and lp.Backpack:GetChildren()) do
        if v:IsA("Tool") and table.find({"M4A1", "M9", "AK-47", "Remington 870"}, v.Name) then
            return v
        end
    end

    GetGun{"M9"}

    return lp.Backpack:FindFirstChild("M9") or lp.Character:FindFirstChild("M9")
end

local function Respawn(Color, pos)
    Color = Color and Color.Color or lp.TeamColor.Color
    local Saved1, Saved2 = pos or lp.Character:GetPivot(), cam.CFrame

    remotes.Load:InvokeServer(lp, Color)
    task.defer(coroutine.wrap(Goto), Saved1)
    task.defer(function()
        cam.CFrame = Saved2
    end)
end

local function Team(Color)
    if table.find({"Bright orange", "Medium stone grey", "Bright yellow"}, Color) then
        remotes.Team:FireServer(Color)
        return
    end

    if Color == "Bright blue" and #sv.Teams.Guards:GetPlayers() < 8 then
        remotes.Team:FireServer(Color)
        return
    end

    Respawn(BrickColor.new(Color))
end

local function Stay(pos, destroy)
    staying = not destroy
    pos = type(pos) ~= nil and pos or CFrame.new()
    task.spawn(function()
        local vel
        while staying and task.wait() do
            vel = lp.Character.HumanoidRootPart:FindFirstChild("BodyPosition") or Instance.new("BodyPosition", lp.Character.HumanoidRootPart)
            vel.Name = "BodyPosition"
            vel.Position = typeof(pos) == "CFrame" and pos.p or pos
            vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            vel.P = 1000000
            vel.D = 10
        end

        (vel or Instance.new("Model")):Destroy()
    end)
end

local function Anchorage(wt)
    if not lp.Character then repeat until not task.wait() or lp.Character end
    local anctbl = {}

    for i,v in pairs(lp.Character:GetDescendants()) do
        if not v:IsA("BasePart") then continue end

        table.insert(anctbl, v)
    end

    table.foreach(anctbl, function(_, v)
        v.Anchored = true
    end)

    task.wait(wt)

    table.foreach(anctbl, function(_, v)
        v.Anchored = false
    end)
end


local function CloneHumanoid()
    if not lp.Character then repeat until not task.wait() or lp.Character end
    local c = lp.Character
    cam.CameraSubject = c
    c.Humanoid.Name = "DH"
    local cl = c.DH:Clone()
    cl.Name = "Humanoid"
    cl.Parent = c
    task.wait(.1)
    c.DH:Destroy()
    c.Animate.Disabled = true
    cam.CameraSubject = cl
end

local function Kill(tru, weapon)
    local args = {}
    local gun = weapon or FindGun()
    
    for i,v in pairs(tru) do
        if v ~= lp and not table.find(togs.Whitelist, v.Name) and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 then
            if v.TeamColor == lp.TeamColor then
                Respawn(BrickColor.random())
                GetGun({(gun and gun.Name) or "M9"})
                gun = FindGun()
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

local function MeleeKill(tbl)
    for i,v in pairs(tbl) do
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and lp:DistanceFromCharacter(v.Character.HumanoidRootPart.CFrame.p) < 10 then
            for i = 1, math.ceil(v.Character.Humanoid.Health / 10) do
                remotes.Melee:FireServer(v)
            end
        end
    end
end

local function OnCharacterAdded(char)
    task.wait()

    local hum, rs, ca, hd, bp = char:WaitForChild("Humanoid")

    if togs.ADHRP and char:FindFirstChild("HumanoidRootPart") then
        char.Parent = nil
        char.HumanoidRootPart.Parent = nil
        char.Parent = workspace

        task.spawn(function()
            if char ~= workspace:FindFirstChild(lp.Name) then
                workspace:FindFirstChild(lp.Name):Destroy()
            end
        end)
    end

    if togs.Godmode then
        CloneHumanoid()
        hum = char:WaitForChild("Humanoid")
        task.delay(4.9, function()
            Respawn(nil, char.PrimaryPart.CFrame)
        end)
    end

    if togs.AutoRespawn.ForceField then
        Team("Medium stone grey")
        task.delay(6.9, function() -- function() end because .CFrame just teleports u to where u spawn
            Respawn(BrickColor.new("Really red"), char.PrimaryPart.CFrame)
        end)

        task.spawn(function()
            for i = 1, 50 do
                task.wait(.01)
                if lp.Team ~= sv.Teams.Neutral then
                    Team("Medium stone grey")
                end
            end
        end)
     end

    coroutine.wrap(function()
        local bap = lp:WaitForChild("Backpack")

        bp = bap.ChildAdded:Connect(function(item)
            table.insert(allowedtools, item)
            local a = table.find({"AK-47", "M4A1", "M9", "Remington 870", "Taser"}, item.Name) and item:FindFirstChild("GunStates")

            if a and togs.GunMods.Toggled then
                local mod = require(a)
                mod.AutoFire = togs.GunMods.Automatic or mod.AutoFire
                mod.FireRate = togs.GunMods.CustomFireate and togs.GunMods.FireRate or mod.FireRate
                mod.Range = togs.GunMods.CustomRange and togs.GunMods.Range or mod.Range
            end
        end)

        ca = char.ChildAdded:Connect(function(item)
            if not togs.AntiBring then return end

            task.spawn(Anchorage, .001)
            if not table.find(allowedtools, item) and item.ClassName == "Tool" then
                task.defer(item.Destroy, item)
                task.spawn(Anchorage, .1)
                pcall(item.Destroy, item)
            end
        end)

        for i,v in pairs(bap:GetChildren()) do
            table.insert(allowedtools, v)
        end

        if togs.GunSpawn then
            GetGun(togs.GunOrder)
        end
    end)()

    hd = hum.Died:Connect(function()
        if togs.Godmode or togs.AutoRespawn.ForceField then return end

        pcall(function()
            hd:Disconnect()
            rs:Disconnect()
            bp:Disconnect()
            ca:Disconnect()
        end)

        if togs.AutoRespawn.Toggled then
            local tool = char:FindFirstChildOfClass("Tool")
            local isgun = table.find({"M4A1", "M9", "AK-47", "Remington 870"}, tool and tool.Name or "")
            Respawn(nil, char.PrimaryPart.CFrame)

            if togs.AutoRespawn.EquipOldWeapon then
                local newtool = isgun and tool.Name
                if newtool then
                    GetGun(togs.GunOrder)
                    local item = lp.Backpack:WaitForChild(newtool, 10)
                    item.Parent = lp.Character
                end
            end
        end
    end)

    task.spawn(function()
        if togs.Godmode then return end

        char:WaitForChild("ClientInputHandler")
        task.wait(.1)

        for i,v in pairs(debug.getregistry()) do
            if v ~= nil and type(v) == "function" and getfenv(v).script == char.ClientInputHandler then
                cs = getfenv(v)["cs"] -- syn v3 does not have a good getsenv

                for i2,v2 in pairs(debug.getupvalues(v)) do
                    if type(v2) == "number" and v2 < 13 then
                        debug.setupvalue(v, i2, togs.InfiniteStamina and math.huge or v2)
                    end

                    if type(v2) == "function" then
						if debug.getinfo(v2).name == "fight" then
                            punchfunc = v2
                        end
					end
                end
            end
        end

        table.foreach(getconnections(remotes.Taze.OnClientEvent), function(_, a)
            a[togs.AntiTaze and "Disable" or "Enable"](a)
        end)

        rs = sv.RunService.RenderStepped:Connect(function()
            pcall(function()
                if togs.FastPunch then
                    cs.isRunning = false
                    cs.isFighting = false
                end
            end)
        end)
    end)

    char:WaitForChild("Torso").Touched:Connect(function(thing)
        local model = thing and thing:FindFirstAncestorOfClass("Model")
        local tplr = model and sv.Players:FindFirstChild(model.Name)

        if tplr and not table.find(togs.Whitelist, tplr.Name) and togs.AntiTouch then
            MeleeKill({tplr})
        end
    end)

    char:WaitForChild("Humanoid").Seated:Connect(function()
        if not togs.AntiSit then return end

        char.Humanoid.Sit = false
    end)
end

local function Region(plr)
    if not plr or not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health == 0 then return "nil" end
    local reg = require(sv.ReplicatedStorage.Modules_client.RegionModule_client).findRegion(plr.Character)

    return reg and reg.Name or ""
end

local function CanBeArrested(plr)
    if not plr or not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health == 0 then return end

    if plr.Team == sv.Teams.Inmates then
        local find = Region(plr)
        local findtbl = {}

        for i,v in pairs(sv.ReplicatedStorage.PermittedRegions:GetChildren()) do
            table.insert(findtbl, v.Value)
        end

        if not find or not table.find(findtbl, find) then
            return true
        end
    end

    return plr.Team == sv.Teams.Criminals
end

local function Bring(plr, tool, cframe) -- thanks fate for teaching me the humanoid cloning & deletion (ive never touched it before) (should probably be noted on the function above)
    if not lp.Character or not plr or not plr.Character or not plr.Character:FindFirstChild("Humanoid") or not tool or not cframe then return end
    if plr.Character.Humanoid.Sit then
        Kill{plr}
        repeat until not task.wait() or plr.Character
    end

    local saved = lp.Character.PrimaryPart.CFrame
    CloneHumanoid()
    tool.Parent = lp.Character
    lp.Character:PivotTo(cframe)

    if lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.Anchored = true
    end

    for i = 1, 500 do
        if not lp.Character or not plr.Character or not plr.Character.PrimaryPart or tool.Parent ~= lp.Character then break end

        task.wait()
        task.spawn(firetouchinterest, tool.Handle, plr.Character.PrimaryPart, ffalse)
        task.spawn(lp.Character.PivotTo, lp.Character, cframe)
    end

    task.wait(.1)

    remotes.Load:InvokeServer()
    lp.Character:PivotTo(saved)
end

local function Crim(plr) -- chaotic told me this method
    if not plr or not plr.Character or not lp.Character then return end
    local oldnt = togs.Noclip.Toggled
    togs.Noclip.Toggled = true
    local pad = workspace["Criminals Spawn"].SpawnLocation
    local padpos, oldpos = pad.CFrame, lp.Character.PrimaryPart.CFrame

    GetGun{togs.BringTool}
    local tool = lp.Backpack:WaitForChild(togs.BringTool)
    CloneHumanoid()
    tool.Parent = lp.Character
    pad.CanCollide = false
    if lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.Anchored = true
    end

    for i = 1, 500 do
        if not lp.Character or not plr.Character or not plr.Character.PrimaryPart or tool.Parent ~= lp.Character then break end
        
        task.wait()
        task.spawn(firetouchinterest, pad, plr.Character.PrimaryPart, ffalse)
        task.spawn(firetouchinterest, tool.Handle, plr.Character.PrimaryPart, ffalse)
        task.spawn(lp.Character.PivotTo, lp.Character, oldpos)
    end

    task.wait(.1)
    
    remotes.Load:InvokeServer()
    pad:PivotTo(padpos)
    Goto(oldpos)

    togs.Noclip.Toggled = oldnt
end

local function SendMsg(args)
    if not lp:FindFirstChild("Backpack") then lp:WaitForChild("Backpack") end

    local ev, unev, m9 = sv.ReplicatedStorage.EquipEvent, sv.ReplicatedStorage.UnequipEvent, lp.Backpack:FindFirstChild("M9") or lp.Character:FindFirstChild("M9")

    if not m9 then
        GetGun{"M9"}
        m9 = lp.Backpack:WaitForChild("M9")
    end

    for i,v in pairs(args) do
        v["Cframe"] = CFrame.new()
        v["RayObject"] = Ray.new()
        v["Distance"] = 0
    end

    ev.FireServer(ev, m9)
    remotes.Shoot.FireServer(remotes.Shoot, args, m9)
    remotes.Reload.FireServer(remotes.Reload, m9)
    unev.FireServer(unev, m9)
end

local function PlayerRemoved(plr)
    local athenauser = table.find(athenausers, plr.Name)
    if athenauser then
        table.remove(athenausers, athenauser)
        Note(("Athena user %s has left!"):format(plr.Name))
    end

    if plr == selected then
        Note("Selected user has left!")
        if viewing == selected then
            viewing = nil
            cam.CameraSubject = lp.Character or lp.CharacterAdded:Wait()
        end

        selected = nil
    end
end

local function PlayerCharacterAdded(plr)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local vests = {}
    local weldcrash
    local tt = tick()

    if viewing == plr then
        cam.CameraSubject = char
    end

    task.spawn(function()
        char:WaitForChild("Head").ChildAdded:Connect(function(gui)
            task.wait()
            if not togs.AntiCrash or not gui:IsA("BillboardGui") or not char:FindFirstChild("Head") or #char.Head:GetChildren() < 10 then return end

            gui:Destroy()
        end)

        char:WaitForChild("Torso").Touched:Connect(function(thing)
            if tick() - tt < .2 or not table.find(givenantitouch, plr.Name) then return end
            tt = tick()

            local model = thing and thing:FindFirstAncestorOfClass("Model")
            local tplr = model and sv.Players:FindFirstChild(model.Name)

            if tplr and not table.find({plr, lp}, tplr) and not table.find(togs.Whitelist, tplr.Name) then
                Kill({tplr})
            end
        end)
    end)

    task.spawn(function()
        char:WaitForChild("Humanoid").AnimationPlayed:Connect(function(an)
            if not table.find({"rbxassetid://484926359", "rbxassetid://484200742"}, an.Animation.AnimationId) then return end
            local pos = char:GetPivot()
            local base = workspace:FindPartOnRay(Ray.new(pos.p, pos.LookVector * 3), char) -- yea i just took it from pl :grin:

            if base and base:FindFirstAncestorOfClass("Model") and base:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                local hitplr = sv.Players:GetPlayerFromCharacter(base.Parent)
                if hitplr and table.find(givenantipunch, hitplr.Name) or (hitplr == lp and togs.AntiPunch) then
                    (hitplr == lp and MeleeKill or Kill){plr}
                end
            end
        end)
    end)

    char.DescendantAdded:Connect(function(part)
        task.wait()
        if togs.AntiCrash and part:IsA("Weld") and part.Parent and #part.Parent:GetChildren() > 300 then
            part.Parent:Destroy()

            if not weldcrash then
                Note(("%s is trying to weld crash!"):format(plr.Name))
            end

            weldcrash = true
        end

        if part.Name == "vest" then
            table.insert(vests, part)
            if #vests > 1 and togs.AntiCrash then
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

    task.spawn(function()
        for i,v in pairs(char:WaitForChild("Head"):GetChildren()) do
            if not togs.AntiCrash or v == v.Parent:FindFirstChildOfClass("BillboardGui") or not v:IsA("BillboardGui") then continue end
            
            v:Destroy()
        end
    end)
end

local function PlayerAdded(plr)
    PlayerCharacterAdded(plr)
    local bpcon, weldcrash

    plr.ChildAdded:Connect(function(thing)
        if thing.Name == "Backpack" then
            if bpcon then
                bpcon:Disconnect()
            end

            bpcon = thing.DescendantAdded:Connect(function(part)
                if togs.AntiCrash and part:IsA("Weld") and part.Parent and #part.Parent:GetChildren() > 300 then
                    part.Parent:Destroy()

                    if not weldcrash then
                        Note(("%s is trying to weld crash!"):format(plr.Name))
                    end

                    weldcrash = true
                end

                if part:IsA("Tool") then
                    pcall(function()
                        local con; con = part:WaitForChild("Handle", 5).Touched:Connect(function(bpart)
                            if not bpart or not bpart:IsDescendantOf(lp.Character) or tostring(part.Parent) ~= lp.Name or not plr.Character or not bpart.Name == "HumanoidRootPart" then return end

                            Note(("%s tried to bring you!"):format(plr.Name))
                        end)

                        local con2; con2 = part.AncestryChanged:Connect(function(Noneedforthisone, parent) 
                            if parent ~= nil then return end

                            con:Disconnect()
                            con2:Disconnect()
                        end)
                    end)
                end
            end)
        end
    end)

    plr.CharacterAdded:Connect(function() -- CharacterAppearanceLoaded
        PlayerCharacterAdded(plr)
    end)
end

local function SpamArrest(plr, power)
    if not plr or not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health == 0 or not plr.Character:FindFirstChild("Head") then return end

    if not CanBeArrested(plr) then
        repeat Crim(plr) until CanBeArrested(plr) or plr.Parent ~= sv.Players -- crim func yields dw
    end

    local arrests = 0
    local starttick = tick()

    local function Arrest()
        if remotes.Arrest:InvokeServer(plr.Character.Head) then
            arrests += 1
        end
    end

    while task.wait() and plr.Character and CanBeArrested(plr) and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health ~= 0 and not breaksa do
        local pp = plr.Character.PrimaryPart.CFrame
        Goto(pp + Vector3.new(0, 5, 0))
        Stay(pp.p + Vector3.new(0, 5, 0))

        for i = 1,power do
            coroutine.wrap(Arrest)()
        end
    end

    Stay(nil, true)

    Note(("Arrested with: %i arrests"):format(arrests))
    Note(("Arrested in: %.02f seconds"):format(tick() - starttick))
end

-- Roblox Uis

local function draggable(obj)
	obj.Active = true
	local mouse, minitial, initial, con = lp:GetMouse()
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			minitial = Vector2.new(input.Position.x, input.Position.Y)
			initial = obj.Position

			con = sv.RunService.Stepped:Connect(function()
				local delta = Vector2.new(mouse.X, mouse.Y) - minitial

				obj.Position = UDim2.new(initial.X.Scale, initial.X.Offset + delta.X, initial.Y.Scale, initial.Y.Offset + delta.Y)
			end)
		end
	end)

	obj.InputEnded:Connect(function(input)
		if not con or input.UserInputState ~= Enum.UserInputState.End then return end

		con:Disconnect()
	end)
end

local AddCommand, ChangeAdminPerms, HandleMessage do
	local Commands = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local Top = Instance.new("Frame")
	local Min = Instance.new("TextButton")
	local UIGradient_2 = Instance.new("UIGradient")
	local Commands_2 = Instance.new("TextLabel")
	local CommandList = Instance.new("ScrollingFrame")
	local UIGridLayout = Instance.new("UIGridLayout")
	local UIPadding = Instance.new("UIPadding")

	Commands.Name = "Commands"
	Commands.Parent = ChatLogs
	Commands.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Commands.BackgroundTransparency = 0.350
	Commands.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Commands.BorderSizePixel = 2
	Commands.Position = UDim2.new(0.0179149806, 0, 0.830674887, -264)
	Commands.Size = UDim2.new(0, 160, 0, 244)
	Commands.Visible = false

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 38, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
	UIGradient.Rotation = 90
	UIGradient.Parent = Commands

	Top.Name = "Top"
	Top.Parent = Commands
	Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Top.BackgroundTransparency = 0.650
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 2
	Top.Size = UDim2.new(0, 160, 0, 24)

	Min.Name = "Min"
	Min.Parent = Top
	Min.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Min.BorderColor3 = Color3.fromRGB(51, 51, 51)
	Min.BorderSizePixel = 2
	Min.Position = UDim2.new(0.879999995, -1, 0.125, 0)
	Min.Size = UDim2.new(0, 17, 0, 17)
	Min.Font = Enum.Font.SourceSans
	Min.LineHeight = 1.150
	Min.Text = "-"
	Min.TextColor3 = Color3.fromRGB(255, 255, 255)
	Min.TextSize = 39.000

	UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 38, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
	UIGradient_2.Rotation = 90
	UIGradient_2.Parent = Top

	Commands_2.Name = "Commands"
	Commands_2.Parent = Top
	Commands_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Commands_2.BackgroundTransparency = 1.000
	Commands_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Commands_2.BorderSizePixel = 0
	Commands_2.Position = UDim2.new(0.0450000018, 0, 0, 0)
	Commands_2.Size = UDim2.new(0, 95, 0, 24)
	Commands_2.Font = Enum.Font.SourceSansBold
	Commands_2.Text = "Commands"
	Commands_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	Commands_2.TextSize = 20.000
	Commands_2.TextStrokeTransparency = 0.500
	Commands_2.TextXAlignment = Enum.TextXAlignment.Left

    CommandList.Name = "CommandList"
    CommandList.Parent = Commands
    CommandList.Active = true
    CommandList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CommandList.BackgroundTransparency = 1.000
    CommandList.BorderSizePixel = 0
    CommandList.Position = UDim2.new(0, 0, 0, 30)
    CommandList.CanvasSize = UDim2.new()
    CommandList.Size = UDim2.new(0, 160, 0, 213)
    CommandList.ScrollBarThickness = 0

    UIGridLayout.Parent = CommandList
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.CellSize = UDim2.new(0, 154, 0, 20)

    UIPadding.Parent = CommandList
    UIPadding.PaddingBottom = UDim.new(0, 3)
    UIPadding.PaddingLeft = UDim.new(0, 3)
    UIPadding.PaddingRight = UDim.new(0, 3)
    UIPadding.PaddingTop = UDim.new(0, 3)

	local CommandBar = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local Text = Instance.new("TextBox")
	local BackText = Instance.new("TextLabel")
	local Top = Instance.new("Frame")
	local UIGradient_2 = Instance.new("UIGradient")
	local CommandsOpen = Instance.new("TextButton")
	local PrefixL = Instance.new("TextLabel")

	CommandBar.Name = "CommandBar"
	CommandBar.Parent = ChatLogs
	CommandBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CommandBar.BackgroundTransparency = 0.350
	CommandBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CommandBar.BorderSizePixel = 2
	CommandBar.Position = UDim2.new(0.0182509776, 0, 0.830674887, 0)
	CommandBar.Size = UDim2.new(0, 160, 0, 60)

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 38, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
	UIGradient.Rotation = 90
	UIGradient.Parent = CommandBar

	Text.Name = "Text"
	Text.Parent = CommandBar
	Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Text.BackgroundTransparency = 1.000
	Text.BorderColor3 = Color3.fromRGB(27, 42, 53)
	Text.Position = UDim2.new(0.0421073921, 0, 0.482758582, 0)
	Text.Size = UDim2.new(0, 148, 0, 31)
	Text.Font = Enum.Font.SourceSansSemibold
	Text.PlaceholderText = "Command Bar"
	Text.Text = ""
	Text.TextColor3 = Color3.fromRGB(255, 255, 255)
	Text.TextSize = 16.000
	Text.TextXAlignment = Enum.TextXAlignment.Left

	BackText.Name = "BackText"
	BackText.Parent = CommandBar
	BackText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BackText.BackgroundTransparency = 1.000
	BackText.BorderColor3 = Color3.fromRGB(27, 42, 53)
	BackText.Position = UDim2.new(0.0419998653, 0, 0.483142972, 0)
	BackText.Size = UDim2.new(0, 148, 0, 30)
	BackText.Font = Enum.Font.SourceSansSemibold
	BackText.Text = ""
	BackText.TextColor3 = Color3.fromRGB(255, 255, 255)
	BackText.TextSize = 16.000
	BackText.TextXAlignment = Enum.TextXAlignment.Left

	Top.Name = "Top"
	Top.Parent = CommandBar
	Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Top.BackgroundTransparency = 0.650
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 2
	Top.Size = UDim2.new(0, 160, 0, 24)

	UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 38, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
	UIGradient_2.Rotation = 90
	UIGradient_2.Parent = Top

	CommandsOpen.Name = "Commands"
	CommandsOpen.Parent = Top
	CommandsOpen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CommandsOpen.BackgroundTransparency = 1.000
	CommandsOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CommandsOpen.BorderSizePixel = 0
	CommandsOpen.Position = UDim2.new(0.0387500748, 0, 0, 0)
	CommandsOpen.Size = UDim2.new(0, 88, 0, 24)
	CommandsOpen.Font = Enum.Font.SourceSansBold
	CommandsOpen.Text = "Commands"
	CommandsOpen.TextColor3 = Color3.fromRGB(255, 255, 255)
	CommandsOpen.TextSize = 19.000
	CommandsOpen.TextStrokeTransparency = 0.500
	CommandsOpen.TextXAlignment = Enum.TextXAlignment.Left

	PrefixL.Name = "Prefix"
	PrefixL.Parent = Top
	PrefixL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PrefixL.BackgroundTransparency = 1.000
	PrefixL.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PrefixL.BorderSizePixel = 0
	PrefixL.Position = UDim2.new(0.632500052, 0, 0, 0)
	PrefixL.Size = UDim2.new(0, 51, 0, 24)
	PrefixL.Font = Enum.Font.SourceSansBold
	PrefixL.Text = "Prefix: "..togs.Admin.Prefix
	PrefixL.TextColor3 = Color3.fromRGB(255, 255, 255)
	PrefixL.TextSize = 19.000
	PrefixL.TextStrokeTransparency = 0.500
	PrefixL.TextXAlignment = Enum.TextXAlignment.Left

	local Frame = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local TextLabel = Instance.new("TextLabel")

	Frame.Parent = ChatLogs
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BackgroundTransparency = 0.350
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 2
	Frame.Position = UDim2.new(0,0,0,0)
	Frame.AutomaticSize = Enum.AutomaticSize.XY
	Frame.Visible = false

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 38, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
	UIGradient.Rotation = 90
	UIGradient.Parent = Frame

	TextLabel.Parent = Frame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Size = UDim2.new(0, 200, 0, 50)
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 20.000
	TextLabel.TextStrokeTransparency = 0.500
	TextLabel.TextWrapped = true

    CommandList.ChildAdded:Connect(function(item)
		CommandList.CanvasSize += UDim2.new(0, 0, 0, 25)
    end)

	Min.Activated:Connect(function()
		Commands.Visible = false
	end)

	CommandsOpen.Activated:Connect(function()
		Commands.Visible = not Commands.Visible
	end)

	Text.FocusLost:Connect(function()
		HandleMessage(("%s%s"):format(togs.Admin.Prefix, Text.Text))
		Text.Text = ""
	end)

    sv.UserInputService.InputBegan:Connect(function(key, yourfatherfigureexists)
        if yourfatherfigureexists or key.KeyCode ~= togs.Admin.FocusKey then return end

        task.delay(.05, Text.CaptureFocus, Text)
    end)

	draggable(Commands)
	draggable(CommandBar)

    --[[
        AddCommand("print", {"cout"}, "Prints given arguments", true, false, function(args) print(unpack(args)) end)
    ]]

	function AddCommand(Command, Aliases, Info, RequiresArgs, IsUseableByOthers, Function)
		local Final = {}
		
		Final["Command"] = Command
		Final["Aliases"] = Aliases
		Final["Function"] = Function
		Final["RequiresArgs"] = RequiresArgs
		Final["IsUseableByOthers"] = IsUseableByOthers

		local Commandf = Instance.new("Frame")
		local UIGradient = Instance.new("UIGradient")
		local Label = Instance.new("TextButton")

		Commandf.Name = "Command"
		Commandf.Parent = CommandList
		Commandf.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Commandf.Size = UDim2.new(0, 100, 0, 100)

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(86, 87, 85)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(78, 77, 73))}
		UIGradient.Rotation = 90
		UIGradient.Parent = Commandf

		Label.Name = "Label"
		Label.Parent = Commandf
		Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Label.BackgroundTransparency = 1.000
		Label.Position = UDim2.new(0.0270000007, 1, 0, 0)
		Label.Size = UDim2.new(0, 148, 0, 20)
		Label.Font = Enum.Font.SourceSansBold
		Label.Text = Command
		Label.TextColor3 = Color3.fromRGB(255, 255, 255)
		Label.TextSize = 15.000
		Label.TextWrapped = true
		Label.TextXAlignment = Enum.TextXAlignment.Left

		local fstr = Info.."\nIs usable by others: "..tostring(IsUseableByOthers).."\nRequires arguments: "..tostring(RequiresArgs)
		if Aliases then
			fstr = fstr.."\nAliases: {"..(type(Aliases) == "table" and table.concat(Aliases, ", ") or Aliases).."}"
		end

		local con
		local size = sv.TextService:GetTextSize(fstr, 20, Enum.Font.SourceSansBold, Vector2.new(9e9, 9e9)) + Vector2.new(2, 0)

		Commandf.MouseEnter:Connect(function()
            local mouse = lp:GetMouse()
			con = sv.RunService.RenderStepped:Connect(function()
				if not Commands.Visible then
                    con:Disconnect()
                    Frame.Visible = false
                    return
                end

				TextLabel.Size = UDim2.new(0, size.X, 0, size.Y)
				TextLabel.Text = fstr
				Frame.Visible = true
				Frame.Position = UDim2.new(0, mouse.X + 4, 0, mouse.Y)
			end)
		end)

		Commandf.MouseLeave:Connect(function()
			pcall(function(hi)
				if con ~= nil and con.Connected then
					con:Disconnect()
				end

				unpack(hi)
			end, {})

			Frame.Visible = false
		end)

		table.insert(Commandstbl, Final)
	end

	function HandleMessage(msg, plr)
        if msg:sub(1, 1) ~= togs.Admin.Prefix then return end
        msg = msg:sub(2)

		if not plr or table.find(togs.Admin.Admins, plr) then
			local cmds = msg:split("&")

            for _, icmd in next, cmds do
                local args = icmd:split(" ")
                local cmd = args[1]
                table.remove(args, 1)

                for _, v in next, Commandstbl do
                    if (plr and not v.IsUseableByOthers) then continue end

                    if v.Command:lower() == cmd:lower() or (type(v.Aliases) == "string" and v.Aliases:lower() == cmd:lower()) then
                        task.spawn(v.Function, plr, unpack(args))

                        return
                    end

                    if type(v.Aliases) == "table" then
                        for _, alias in pairs(v.Aliases) do
                            if alias:lower() == cmd:lower() then
                                task.spawn(v.Function, plr, unpack(args))

                                return
                            end
                        end
                    end
                end
            end
		end
	end

	function ChangeAdminPerms(plr)
		local c = table.find(togs.Admin.Admins, plr)
		
		if not c then
			table.insert(togs.Admin.Admins, plr)
            sv.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(("/w %s You have been given admin! Use \"%scmds\" or \"%shelp\" to bring up a commands list."):format(plr, togs.Admin.Prefix, togs.Admin.Prefix), "All")
			Note(("Added %s to admins."):format(plr))
		else
			table.remove(togs.Admin.Admins, c)
            sv.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(("/w %s Your admin has been revoked. Cry about it."):format(plr), "All")
			Note(("Removed %s from admins."):format(plr))
		end
	end
end

local Log do
    local BoxAthena = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local Top = Instance.new("Frame")
    local UIGradient_2 = Instance.new("UIGradient")
    local Commands = Instance.new("TextLabel")
    local Min = Instance.new("TextButton")
    local frm = Instance.new("Frame")
    local ScrollingFrame = Instance.new("ScrollingFrame")
    local UIGridLayout = Instance.new("UIGridLayout")
    local UIPadding = Instance.new("UIPadding")

    BoxAthena.Name = "ExploiterDetect"
    BoxAthena.Parent = ChatLogs
    BoxAthena.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BoxAthena.BackgroundTransparency = 0.350
    BoxAthena.BorderSizePixel = 2
    BoxAthena.Position = UDim2.new(0.5, 0, 0.595761478, 0)
    BoxAthena.Size = UDim2.new(0, 514, 0, 274)
    BoxAthena.Visible = false

    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 38, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    UIGradient.Rotation = 90
    UIGradient.Parent = BoxAthena

    Top.Name = "Top"
    Top.Parent = BoxAthena
    Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Top.BackgroundTransparency = 0.650
    Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Top.BorderSizePixel = 2
    Top.Size = UDim2.new(0, 514, 0, 24)

    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 38, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    UIGradient_2.Rotation = 90
    UIGradient_2.Parent = Top

    Commands.Name = "Commands"
    Commands.Parent = Top
    Commands.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Commands.BackgroundTransparency = 1.000
    Commands.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Commands.BorderSizePixel = 0
    Commands.Position = UDim2.new(0.0170279779, 0, 0, 0)
    Commands.Size = UDim2.new(0, 150, 0, 24)
    Commands.Font = Enum.Font.SourceSansBold
    Commands.Text = "Exploiter Detection"
    Commands.TextColor3 = Color3.fromRGB(255, 255, 255)
    Commands.TextSize = 20.000
    Commands.TextStrokeTransparency = 0.500
    Commands.TextXAlignment = Enum.TextXAlignment.Left

    Min.Name = "Min"
    Min.Parent = Top
    Min.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Min.BorderColor3 = Color3.fromRGB(51, 51, 51)
    Min.BorderSizePixel = 2
    Min.Position = UDim2.new(0.955875456, -1, 0.125, 0)
    Min.Size = UDim2.new(0, 17, 0, 17)
    Min.Font = Enum.Font.SourceSans
    Min.LineHeight = 1.150
    Min.Text = "-"
    Min.TextColor3 = Color3.fromRGB(255, 255, 255)
    Min.TextSize = 39.000

    frm.Name = "frm"
    frm.Parent = BoxAthena
    frm.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frm.BackgroundTransparency = 1.000
    frm.BorderColor3 = Color3.fromRGB(27, 42, 53)
    frm.Position = UDim2.new(0, 0, 0.0875912383, 0)
    frm.Size = UDim2.new(0, 389, 0, 250)

    ScrollingFrame.Parent = frm
    ScrollingFrame.Active = true
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.BackgroundTransparency = 1.000
    ScrollingFrame.Size = UDim2.new(0, 180, 0, 250)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, 0)
    ScrollingFrame.ScrollBarThickness = 0

    UIGridLayout.Parent = ScrollingFrame
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.CellSize = UDim2.new(0, 176, 0, 20)

    UIPadding.Parent = ScrollingFrame
    UIPadding.PaddingBottom = UDim.new(0, 2)
    UIPadding.PaddingLeft = UDim.new(0, 2)
    UIPadding.PaddingRight = UDim.new(0, 2)
    UIPadding.PaddingTop = UDim.new(0, 8)

    local exploiterlogs = {}

    function Log(plr, reason)
        local newtbl = {}

        if exploiterlogs[plr.Name] then
            newtbl = exploiterlogs[plr.Name]
        end

        if table.find(newtbl, reason) then return end

        table.insert(newtbl, reason)
        exploiterlogs[plr.Name] = newtbl
    end

    local function UpdateLogs()
        for i,v in pairs(exploiterlogs) do
            if BoxAthena:FindFirstChild(i) then
                BoxAthena[i].Info.Text = table.concat(v, "\n")
                
                continue
            end

            if togs.EDN then 
                Note(("Exploit detection caught %s!"):format(i))
            end

            local ExFrame = Instance.new("Frame")
            local Name = Instance.new("TextLabel")
            local Avatar = Instance.new("ImageLabel")
            local Info = Instance.new("TextLabel")

            local Button = Instance.new("Frame")
            local UIGradient1 = Instance.new("UIGradient")
            local UIListLayout = Instance.new("UIListLayout")
            local TextButton = Instance.new("TextButton")

            Button.Name = i
            Button.Parent = ScrollingFrame
            Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundTransparency = 0.200
            Button.BorderColor3 = Color3.fromRGB(23, 25, 52)
            Button.Position = UDim2.new(-0.020833334, 0, 0.00840336177, 0)
            Button.Size = UDim2.new(0, 153, 0, 20)

            UIGradient1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(86, 87, 85)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(78, 77, 73))}
            UIGradient1.Rotation = 90
            UIGradient1.Parent = Button

            UIListLayout.Parent = Button
            UIListLayout.FillDirection = Enum.FillDirection.Horizontal
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            TextButton.Parent = Button
            TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.BackgroundTransparency = 1.000
            TextButton.Size = UDim2.new(1, 0, 1, 0)
            TextButton.Font = Enum.Font.SourceSansBold
            TextButton.Text = i
            TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            TextButton.TextSize = 20.000
            TextButton.TextStrokeTransparency = 0.500

            ExFrame.Name = i
            ExFrame.Parent = BoxAthena
            ExFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ExFrame.BackgroundTransparency = 1.000
            ExFrame.Position = UDim2.new(0.357976645, 0, 0.0875912383, 0)
            ExFrame.Size = UDim2.new(0, 330, 0, 250)
            ExFrame.Visible = false

            Name.Name = "Name"
            Name.Parent = ExFrame
            Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Name.BackgroundTransparency = 1.000
            Name.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Name.Position = UDim2.new(0.375514328, 0, 0.0320000015, 0)
            Name.Size = UDim2.new(0, 205, 0, 64)
            Name.Font = Enum.Font.SourceSansBold
            Name.Text = ("%s\n(%s)"):format(i, sv.Players:FindFirstChild(i) and sv.Players[i].DisplayName or "Unknown")
            Name.TextColor3 = Color3.fromRGB(255, 255, 255)
            Name.TextSize = 20.000
            Name.TextStrokeTransparency = 0.500

            Avatar.Name = "Avatar"
            Avatar.Parent = ExFrame
            Avatar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Avatar.BackgroundTransparency = 1.000
            Avatar.Position = UDim2.new(0.121463276, 0, 0.0320000015, 0)
            Avatar.Size = UDim2.new(0, 64, 0, 64)
            Avatar.Image = sv.Players:GetUserThumbnailAsync(sv.Players:GetUserIdFromNameAsync(i), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

            Info.Name = "Info"
            Info.Parent = ExFrame
            Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Info.BackgroundTransparency = 1.000
            Info.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Info.Position = UDim2.new(0.0424079672, 0, 0.324000001, 0)
            Info.Size = UDim2.new(0, 314, 0, 169)
            Info.Font = Enum.Font.SourceSansBold
            Info.TextWrapped = true
            Info.Text = table.concat(v, "\n")
            Info.TextColor3 = Color3.fromRGB(255, 255, 255)
            Info.TextSize = 20.000
            Info.TextStrokeTransparency = 0.500
            Info.TextXAlignment = Enum.TextXAlignment.Left
            Info.TextYAlignment = Enum.TextYAlignment.Top

            TextButton.Activated:Connect(function()
                for i2,v2 in pairs(BoxAthena:GetChildren()) do
                    if not table.find({"frm", "Top"}, v2.Name) and v2:IsA("Frame") then
                        v2.Visible = false
                    end
                end

                BoxAthena[i].Visible = true
            end)
        end
    end
    
    Min.Activated:Connect(function()
        BoxAthena.Visible = false
    end)

    draggable(BoxAthena)

    task.spawn(function()
        while task.wait(2) do
            for i,v in pairs(sv.Players:GetPlayers()) do
                if v == game.Players.LocalPlayer then continue end

                if v.Character and v.Character:FindFirstChild("Humanoid") then
                    if v.Character.Humanoid:GetState() == Enum.HumanoidStateType.PlatformStanding then
                        Log(v, "Flying")
                    end
                end

                if v.TeamColor == BrickColor.new("Really black") then
                    Log(v, "Septex or XTheMasterX admin")
                end

                if ((v:FindFirstChild("Backpack") and v.Backpack:FindFirstChild("AK-47")) or (v.Character and v.Character:FindFirstChild("AK-47"))) and table.find({game.Teams.Inmates, game.Teams.Neutral}, v.Team) then
                    Log(v, "Gun spawn")
                end

                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and not v.Character:FindFirstChild("Torso") then
                    Log(v, "Invisible Fling")
                end

                if v.Character and not v.Character:FindFirstChild("Humanoid") and not v.Character:FindFirstChild("ForceField") then
                    Log(v, "God mode or bringing")
                end
            end

            UpdateLogs()
        end
    end)
end

local ChatLogAdd do
    local AthenaChat = Instance.new("Frame")
    local Top = Instance.new("Frame")
    local Min = Instance.new("TextButton")
    local UIGradient = Instance.new("UIGradient")
    local Commands = Instance.new("TextLabel")
    local UIGradient_2 = Instance.new("UIGradient")
    local Logs = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local TextBox = Instance.new("TextBox")

    ChatLogs.Name = "ChatLogs"

    AthenaChat.Parent = ChatLogs
    AthenaChat.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AthenaChat.BackgroundTransparency = 0.350
    AthenaChat.BorderColor3 = Color3.fromRGB(0, 0, 0)
    AthenaChat.BorderSizePixel = 2
    AthenaChat.Position = UDim2.new(0.274984151, 0, 0.597905636, 0)
    AthenaChat.Size = UDim2.new(0, 371, 0, 214)
    AthenaChat.Name = "AthenaChat"
    AthenaChat.Visible = false

    Top.Name = "Top"
    Top.Parent = AthenaChat
    Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Top.BackgroundTransparency = 0.650
    Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Top.BorderSizePixel = 2
    Top.Position = UDim2.new(0, 0, -0.00165289803, 0)
    Top.Size = UDim2.new(0, 371, 0, 24)

    Min.Name = "Min"
    Min.Parent = Top
    Min.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Min.BorderColor3 = Color3.fromRGB(51, 51, 51)
    Min.BorderSizePixel = 2
    Min.Position = UDim2.new(0.936603725, -1, 0.125, 0)
    Min.Size = UDim2.new(0, 17, 0, 17)
    Min.Font = Enum.Font.SourceSans
    Min.LineHeight = 1.150
    Min.Text = "-"
    Min.TextColor3 = Color3.fromRGB(255, 255, 255)
    Min.TextSize = 39.000

    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 38, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    UIGradient.Rotation = 90
    UIGradient.Parent = Top

    Commands.Name = "Commands"
    Commands.Parent = Top
    Commands.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Commands.BackgroundTransparency = 1.000
    Commands.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Commands.BorderSizePixel = 0
    Commands.Position = UDim2.new(0.0306459349, 0, -0.0416666679, 0)
    Commands.Size = UDim2.new(0, 95, 0, 24)
    Commands.Font = Enum.Font.SourceSansBold
    Commands.Text = "Athena chat"
    Commands.TextColor3 = Color3.fromRGB(255, 255, 255)
    Commands.TextSize = 20.000
    Commands.TextStrokeTransparency = 0.500
    Commands.TextXAlignment = Enum.TextXAlignment.Left

    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(38, 38, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    UIGradient_2.Rotation = 90
    UIGradient_2.Parent = AthenaChat

    Logs.Name = "Logs"
    Logs.Parent = AthenaChat
    Logs.Active = true
    Logs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logs.BackgroundTransparency = 1.000
    Logs.BorderSizePixel = 0
    Logs.Position = UDim2.new(0, 0, 0.110496446, 0)
    Logs.Size = UDim2.new(0, 371, 0, 157)
    Logs.ScrollBarThickness = 2
    Logs.CanvasSize = UDim2.new()

    UIListLayout.Parent = Logs
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    UIPadding.Parent = Logs
    UIPadding.PaddingLeft = UDim.new(0, 5)

    TextBox.Parent = AthenaChat
    TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.BackgroundTransparency = 1.000
    TextBox.Position = UDim2.new(0.0134770889, 0, 0.846330047, 0)
    TextBox.Size = UDim2.new(0, 366, 0, 32)
    TextBox.Font = Enum.Font.SourceSansBold
    TextBox.PlaceholderText = "Send a message!"
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 15.000
    TextBox.TextWrapped = true
    TextBox.TextStrokeTransparency = 0.500
    TextBox.TextXAlignment = Enum.TextXAlignment.Left

    TextBox.FocusLost:Connect(function(enter)
        if not enter then return end
        local idmsg = {["ACC_IDENTIFIER"] = lp.UserId / 9.98}
        local msg = {}

        table.foreach(TextBox.Text:reverse():split(""), function(_, v)
            msg["ACC_".._] = string.byte(v) / .052
            idmsg["ACC_"..RandomString(math.random(4, 16))] = math.random(1, 73821) + math.random(0, 1)
        end)
        
        SendMsg({
            [1] = idmsg,
            [2] = msg
        })
    
        ChatLogAdd(lp.UserId, TextBox.Text, tick())

        TextBox.Text = ""
    end)

    Min.Activated:Connect(function()
		AthenaChat.Visible = false
	end)

	Logs.ChildAdded:Connect(function(item)
        task.wait()
		local os = Logs.AbsoluteCanvasSize
		local op = Logs.CanvasPosition
		Logs.CanvasSize += UDim2.new(0, 0, 0, item.Size.Y.Offset + 1)

		if math.round(os.Y - 157) == op.Y then
			Logs.CanvasPosition = Logs.AbsoluteCanvasSize
		end
	end)

	draggable(AthenaChat)

	function ChatLogAdd(user, msg, tic)
        local ctuser = chatticks[user]

        if ctuser and tic - ctuser < .5 then
            return
        end

        chatticks[user] = tic
		local Text = Instance.new("TextLabel")
        local name = sv.Players:GetNameFromUserIdAsync(user)
		local size = sv.TextService:GetTextSize(name..": "..msg:sub(1, 300), 15, "SourceSansBold", Vector2.new(360, 1 / 0)).Y

		Text.Name = "Text"
        Text.Parent = Logs
        Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Text.BackgroundTransparency = 1.000
        Text.Position = UDim2.new(0, 0, -0.00700934557, 0)
        Text.Size = UDim2.new(0, 360, 0, size)
        Text.Font = Enum.Font.SourceSansBold
        Text.Text = name..": "..msg:sub(1, 300)
        Text.TextColor3 = Color3.fromRGB(255, 255, 255)
        Text.TextSize = 15.000
        Text.TextStrokeTransparency = 0.500
        Text.TextWrapped = true
        Text.TextXAlignment = Enum.TextXAlignment.Left
	end
end

LoadData()

for i = 1,127 do table.insert(brickcolors, BrickColor.palette(i).Name) end

task.spawn(LoaderUpdate)

-- Ui library stuff

do
    local ui, settings = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/GFXTI/AthenaClient/main/MainUi.lua", true))()
    local lib =          ui:Library()

    -- Combat window
    do
        local combat = lib:Window("Combat")

        -- Gun mods
        do
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
        end

        -- Broken ass silent aim
        do
            local thing = combat:ToggleDropdown("Silent aim", togs.SilentAim.Toggled, function(a)
                togs.SilentAim.Toggled = a
            end)

            thing:Toggle("Show fov", togs.SilentAim.ShowFov, function(a)
                togs.SilentAim.ShowFov = a
            end)

            thing:Toggle("Dead check", togs.SilentAim.DeadCheck, function(a)
                togs.SilentAim.DeadCheck = a
            end)

            thing:Toggle("Wall check", togs.SilentAim.Wallcheck, function(a)
                togs.SilentAim.Wallcheck = a
            end)

            thing:Toggle("Hit torso", togs.SilentAim.HitPart == "Torso", function(a)
                togs.SilentAim.HitPart = a and "Torso" or "Head"
            end)

            thing:Toggle("Spread", togs.SilentAim.Spread, function(a)
                togs.SilentAim.Spread = a
            end)

            thing:Toggle("Punch", togs.SilentAim.Punch, function(a)
                togs.SilentAim.Punch = a
            end)

            thing:Slider("Range", 1, 5000, togs.SilentAim.Range, false, function(a)
                togs.SilentAim.Range = a
            end)

            thing:Slider("Radius", 1, 1000, togs.SilentAim.Radius, false, function(a)
                togs.SilentAim.Radius = a
            end)
        end

        -- Loopkill
        do
            local thing = combat:ToggleDropdown("Loopkill", togs.Loopkill.Toggled, function(a)
                togs.Loopkill.Toggled = a
            end)

            for i,v in next, {"Neutral", "Inmates", "Guards", "Criminals", "Custom"} do
                thing:Toggle(v, togs.Loopkill[v], function(a)
                    togs.Loopkill[v] = a
                    if a then
                        if v ~= "Custom" then
                            local b = sv.Teams:FindFirstChild(v)
                            if b then
                                Kill(b:GetPlayers())
                            end
                        else
                            for i,v in pairs(sv.Players:GetPlayers()) do
                                if v ~= lp and not v.Team and not table.find(togs.Whitelist, v.Name) then
                                    task.spawn(function()
                                        local char = v.Character
                                        repeat task.wait() until not char:FindFirstChild("ForceField") and char:FindFirstChild("Humanoid")
                                        Kill({v})
                                    end)
                                end
                            end
                        end
                    end
                end)
            end
        end

        -- Killaura
        do
            local thing = combat:ToggleDropdown("Killaura", togs.Killaura.Toggled, function(a)
                togs.Killaura.Toggled = a
            end)

            for i,v in next, {"Neutral", "Inmates", "Guards", "Criminals", "Custom"} do
                thing:Toggle(v, togs.Killaura[v], function(a)
                    togs.Killaura[v] = a
                end)
            end
        end

        -- Colored Bullets
        do
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
        end

        combat:Toggle("Tase aura", togs.TazeAura, function(a) 
            togs.TazeAura = a
        end)

        combat:Toggle("Anti shield", togs.AntiShield, function(a)
            togs.AntiShield = a
        end)

        combat:Toggle("Fast punch", togs.FastPunch, function(a)
            togs.FastPunch = a
        end)

        combat:Toggle("Spam punch", togs.SpamPunch, function(a)
            togs.SpamPunch = a
            if a then
                while task.wait() and togs.SpamPunch do
                    if sv.UserInputService:IsKeyDown(Enum.KeyCode.F) and not sv.UserInputService:GetFocusedTextBox() and punchfunc then
                        coroutine.resume(coroutine.create(punchfunc))
                    end
                end
            end
        end)

        combat:Toggle("One punch", togs.OnePunch, function(a)
            togs.OnePunch = a
        end)

        combat:Toggle("Thorns", togs.Thorns, function(a)
            togs.Thorns = a
        end)

        combat:Toggle("Anti touch", togs.AntiTouch, function(a)
            togs.AntiTouch = a
        end)

        combat:Toggle("Anti punch", togs.AntiPunch, function(a)
            togs.AntiPunch = a
        end)

        combat:Toggle("Gun spawn", togs.GunSpawn, function(a)
            togs.GunSpawn = a
        end)

        combat:Button("Get swat items", function()
            if not HasM4 then Note("You must have the swat gamepass", true); return end

            local oldteam
            if lp.Team ~= sv.Teams.Guards then
                oldteam = lp.TeamColor.Name
                if #sv.Teams.Guards:GetPlayers() < 8 then
                    if lp.Team ~= sv.Teams.Criminals then
                        Team("Bright blue")
                    else
                        Respawn(BrickColor.new("Bright blue"))
                    end
                else
                    Note("Guard team is full!", true)

                    return
                end
            end

            remotes.Item:InvokeServer(workspace.Prison_ITEMS.clothes:FindFirstChild("Riot Police").ITEMPICKUP)
            GetGun{"Riot Shield"}

            Note("Given swat items")

            if oldteam then
                Team(oldteam)
            end
        end)

        combat:Button("Get guns", function()
            GetGun(togs.GunOrder)
            Note("Guns given")
        end)

        for i = 1, 4 do
            combat:Dropdown("Gun slot "..tostring(i), {"M4A1", "M9", "Remington 870", "AK-47", "None"}, function(a)
                togs.GunOrder[i] = a
            end)
        end
    end
    
    -- LocalPlayer Window
    do
        local player = lib:Window("Player")

        -- Auto Respawn
        do
            local thing = player:ToggleDropdown("Auto respawn", togs.AutoRespawn.Toggled, function(a)
                togs.AutoRespawn.Toggled = a
            end)

            thing:Toggle("Equip old weapon", togs.AutoRespawn.EquipOldWeapon, function(a)
                togs.AutoRespawn.EquipOldWeapon = a
            end)

            thing:Toggle("Force field", togs.AutoRespawn.ForceField, function(a)
                togs.AutoRespawn.ForceField = a
            end)
        end

        -- Fly
        do
            local thing = player:ToggleDropdown("Fly", togs.Fly.Toggled, function(a)
                togs.Fly.Toggled = a
            end)

            thing:Slider("Speed", .1, 100, togs.Fly.Speed, true, function(a)
                togs.Fly.Speed = a
            end)
        end

        -- Teams
        do
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

            thing:TextBox("BrickColor name", brickcolors, function(a)
                if not table.find(brickcolors, a) then return end

                Respawn(BrickColor.new(a))
            end)

            thing:Button("Custom team",  function()
                local color = BrickColor.new(Color3.fromRGB(togs.CustomTeam.R, togs.CustomTeam.G, togs.CustomTeam.B))
                Respawn(color)
                Note(("Changed to team %s"):format(color.Name))
            end)

            for i,v in next, {"Neutral", "Inmates", "Criminals"} do
                thing:Button(v, function()
                    Team(sv.Teams[v].TeamColor.Name)
                    Note(("Changed team to %s"):format(v))
                end)
            end

            thing:Button("Guards", function()
                if #sv.Teams.Guards:GetPlayers() < 8 then
                    if lp.Team ~= sv.Teams.Criminals then
                        Team("Bright blue")
                    else
                        Respawn(BrickColor.new("Bright blue"))
                    end

                    Note("Changed team to Guards")
                else
                    Note("Guard team is full!", true)
                end
            end)
        end

        player:Toggle("Anti taze", togs.AntiTaze, function(a)
            togs.AntiTaze = a
            local taze = getconnections(remotes.Taze.OnClientEvent)[1]
            if taze then
                taze[a and "Disable" or "Enable"](taze)
            end
        end)

        player:Toggle("Infinite stamina", togs.InfiniteStamina, function(a)
            togs.InfiniteStamina = a
        end)

        player:Toggle("Anti sit", togs.AntiSit, function(a) 
            togs.AntiSit = a
        end)

        -- Teleports
        do
            local thing = player:ToggleDropdown("Teleport to", false, print)

            for i,v in pairs(positions) do
                thing:Button(i, function()
                    if not lp.Character then return end

                    Goto(v)
                end)
            end
        end

        player:Toggle("God mode", togs.Godmode, function(a)
            togs.Godmode = a
            if a then
                CloneHumanoid()
            end
        end)

        player:Toggle("Auto delete HRP", togs.ADHRP, function(a) 
            togs.ADHRP = a

            if a then
                local c = lp.Character
                c.Parent = nil
                c.HumanoidRootPart.Parent = nil
                c.Parent = workspace
            end
        end)

        player:Button("Delete HRP", function() 
            local c = lp.Character
            c.Parent = nil
            c.HumanoidRootPart.Parent = nil
            c.Parent = workspace
        end)

        player:Toggle("Noclip", togs.Noclip.Toggled, function(a)
            togs.Noclip.Toggled = a
        end)

        player:Button("Rejoin", function()
            if not DEBUGGING_MODE then
                syn.queue_on_teleport(("game.Loaded:Wait()\nloadstring(game:HttpGet(\"https://raw.githubusercontent.com/GFXTI/AthenaClient/main/AthenaPrisonLife.lua\", true), \"Main\")({Color = %s, Position = %s, GivenThorns = %s, GivenOneShot = %s, GivenKillAura = %s, Selected = %s, LoopkillTable = %s, DrawingObjects = \"%s\"})"):format(
                    ("BrickColor.new(\"%s\")"):format(lp.TeamColor.Name),
                    ("CFrame.new(%s)"):format(tostring(lp.Character:GetPivot())),
                    ("{%s}"):format(table.concat(givenoneshot, ",")),
                    ("{%s}"):format(table.concat(givenoneshot, ",")),
                    ("{%s}"):format(table.concat(givenkillaura, ",")),
                    tostring(selected),
                    ("{%s}"):format(table.concat(loopkilltable, ",")),
                    sv.HttpService:JSONEncode(drawingobjects)
                ))
            end

            sv.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end)

        player:Button("Copy join", function()
            setclipboard(("game:GetService\"TeleportService\":TeleportToPlaceInstance(%i, \"%s\")"):format(game.PlaceId, game.JobId))
            Note("Set join script to clipboard")
        end)
    end

    -- World Window
    do
        local world = lib:Window("World")

        world:Button("Crash V1", function()
            GetGun{"Remington 870"}
            local rem = lp.Backpack:WaitForChild("Remington 870")
            for i = 1,4000 do
                remotes.Weld.FireServer(remotes.Weld, rem)
            end
            task.wait(2)
            rem.Parent = lp.Character
            task.wait()
            rem.Parent = lp.Backpack
            Note("Successfully sent weld crash")
        end)

        world:Button("Timeout V1", function()
            GetGun{"M9"}
            local gun = lp.Backpack:FindFirstChild("M9") or lp.Character:FindFirstChild("M9")

            for i = 1, math.random(1500, 2000) do
                remotes.Shoot:FireServer({}, gun)
            end

            Note("Successfully sent timeout")
        end)

        world:Button("Teleport cars", function()
            local oldpos = lp.Character:GetPivot()
            local squadcars = {}

            for i,v in pairs(workspace.Prison_ITEMS.buttons:GetChildren()) do
                if v.Name == "Car Spawner" and v["Car Spawner"].type.Value == "Squad" then
                    table.insert(squadcars, v)
                end
            end

            for i,v in pairs(squadcars) do
                task.spawn(remotes.Item.InvokeServer, remotes.Item, v["Car Spawner"])
                local car = workspace.CarContainer.ChildAdded:Wait()
                repeat
                    car:WaitForChild("Body"):WaitForChild("VehicleSeat"):Sit(lp.Character.Humanoid)
                until not lp.Character or not lp.Character:FindFirstChild("Humanoid") or lp.Character.Humanoid.Sit or not task.wait()
                lp.Character:PivotTo(oldpos)
            end

            lp.Character.Humanoid.Sit = false
        end)

        world:Toggle("Stay", false, function(a)
            Stay(a and lp.Character.PrimaryPart.CFrame or not a)
        end)

        world:Toggle("Spam arrest aura", togs.SpamArrestAura, function(a)
            togs.SpamArrestAura = a
        end)

        -- Drawing
        do
            local thing = world:ToggleDropdown("Drawing", togs.Drawing.Toggled, function(a)
                togs.Drawing.Toggled = a
            end)

            local DrawingName = "Example"
            thing:TextBox("Drawing Name", {}, function(a)
                DrawingName = a
            end)

            thing:Button("Save schematic", function()
                local save = {}

                for i,v in pairs(drawingobjects) do
                    local s = tostring(v.Origin):gsub(" ", "") -- gsub returns a tuple so
                    local e = tostring(v.End):gsub(" ", "")
                    save[#save + 1] = {
                        Origin = s,
                        End = e
                    }
                end

                writefile("AthenaSchematics/Saved/"..DrawingName..".txt", sv.HttpService:JSONEncode(save))
                Note(("Saved schematic %s"):format(DrawingName))
            end)

            thing:Slider("Refresh rate", 0.2, 2, togs.Drawing.Refresh, true, function(a)
                togs.Drawing.Refresh = a
            end)

            thing:Button("Clear", function()
                drawingobjects = {}
                workspacedrawingobjects:ClearAllChildren()
                Note("Cleared all drawing objects")
            end)

            thing:Toggle("Instant kill", togs.Drawing.InstaKill, function(a)
                togs.Drawing.InstaKill = a
            end)

            thing:Toggle("Delete mode", togs.Drawing.Delete, function(a)
                togs.Drawing.Delete = a
            end)

            thing:Toggle("Edit mode", togs.Drawing.Edit, function(a)
                togs.Drawing.Edit = a
            end)

            thing:Toggle("Place mode", togs.Drawing.Place, function(a)
                togs.Drawing.Place = a
            end)
        end

        world:Toggle("Auto grab keycard", togs.AGK, function(a)
            togs.AGK = a
            local key = workspace.Prison_ITEMS.single:FindFirstChild("Key card")
            if a and key then
                remotes.Item:InvokeServer(key:WaitForChild"ITEMPICKUP")
            end
        end)
    end

    -- Player Window
    do
        local misc = lib:Window("Players")

        misc:TextBox("Player", "players", function(a)
            selected = GetPlayer(a)
        end)

        -- Player Toggles
        do
            local thing = misc:ToggleDropdown("Toggles", false, print)

            thing:Button("Whitelist", function()
                if not selected then return end

                local a = table.find(togs.Whitelist, selected.Name)
                table[a and "remove" or "insert"](togs.Whitelist, a or selected.Name)
                Note((a and "Removed %s from whitelist" or "Added %s to whitelist"):format(selected.Name))
            end)

            thing:Button("Admin", function()
                if not selected then return end

                ChangeAdminPerms(selected.Name)
            end)

            thing:Button("Loopkill", function()
                if not selected then return end

                local a = table.find(loopkilltable, selected.Name)
                table[a and "remove" or "insert"](loopkilltable, a or selected.Name)
                Note((a and "Removed %s from loopkill" or "Added %s to loopkill"):format(selected.Name))
            end)

            thing:Button("Give killaura", function()
                if not selected then return end

                local a = table.find(givenkillaura, selected.Name)
                table[a and "remove" or "insert"](givenkillaura, a or selected.Name)
                Note((a and "Gave %s killaura" or "Removed %s's killaura"):format(selected.Name))
            end)

            thing:Button("Anti punch", function()
                if not selected then return end

                local a = table.find(givenantipunch, selected.Name)
                table[a and "remove" or "insert"](givenantipunch, a or selected.Name)
                Note((a and "Gave %s anti punch" or "Removed %s's anti punch"):format(selected.Name))
            end)

            thing:Button("Thorns", function()
                if not selected then return end

                local a = table.find(giventhorns, selected.Name)
                table[a and "remove" or "insert"](giventhorns, a or selected.Name)
                Note((a and "Gave %s thorns" or "Removed %s's thorns"):format(selected.Name))
            end)

            thing:Button("Anti touch", function()
                if not selected then return end

                local a = table.find(givenantitouch, selected.Name)
                table[a and "remove" or "insert"](givenantitouch, a or selected.Name)
                Note((a and "Gave %s anti touch" or "Removed %s's anti touch"):format(selected.Name))
            end)

            thing:Button("One shot guns", function()
                if not selected then return end

                local a = table.find(givenoneshot, selected.Name)
                table[a and "remove" or "insert"](givenoneshot, a or selected.Name)
                Note((a and "Gave %s one shot guns" or "Removed %s's one shot guns"):format(selected.Name))
            end)

            thing:Button("Spam auto team", function()
                if not selected then return end
                if connections["SpamTeam"] then
                    connections["SpamTeam"]:Disconnect()
                    connections["SpamTeam"] = nil
                    Note("Stopped spamming auto team")
                    return
                end

                local t = tick()
                connections["SpamTeam"] = sv.RunService.Heartbeat:Connect(function()
                    if tick() - t < .2 then return end
                    if not selected then
                        connections["SpamTeam"]:Disconnect()
                        connections["SpamTeam"] = nil
                        Note(("%s has left, disconnected spam auto team"):format(selected.Name))
                    end

                    if lp.TeamColor ~= selected.TeamColor then
                        t = tick()
                        Respawn(selected.TeamColor)
                    end
                end)
            end)

            thing:Button("View", function()
                if not selected then return end

                if viewing then
                    viewing = nil
                    cam.CameraSubject = lp.Character or lp.CharacterAdded:Wait()
                    Note("No longer viewing")
                else
                    viewing = selected
                    cam.CameraSubject = selected.Character or selected.CharacterAdded:Wait()
                    Note(("Viewing %s"):format(selected.Name))
                end
            end)
        end

        -- Player Buttons
        do
            local thing = misc:ToggleDropdown("Buttons", false, print)

            thing:Button("Copy team color", function()
                if not selected then return end

                Respawn(selected.TeamColor)
            end)

            thing:Button("Bring", function()
                if not selected or not selected.Character or not lp.Character then return end

                GetGun{togs.BringTool}
                Bring(selected, lp.Backpack:WaitForChild(togs.BringTool), lp.Character.PrimaryPart.CFrame)
                Note(("Brung %s"):format(selected.Name))
            end)

            thing:Button("Goto", function()
                if not selected or not selected.Character or not lp.Character then return end

                Goto(selected.Character.PrimaryPart.CFrame)
            end)

            thing:Button("Fling", function()
                if not selected or not selected.Character or not lp.Character then return end
                local nt, op = togs.Noclip.Toggled, lp.Character.PrimaryPart.CFrame
                togs.Noclip.Toggled = true

                local bg = Instance.new("BodyAngularVelocity", lp.Character.HumanoidRootPart)
                local bp = Instance.new("BodyPosition", lp.Character.HumanoidRootPart)
                bg.P = 9e9
                bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.AngularVelocity = Vector3.new(9e9, 9e9, 9e9)
                bp.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bp.D = 10
                bp.P = 9e9
                for i = 1, 300 do
                    if not lp.Character or not selected or not selected.Character then break end

                    bp.Position = selected.Character:GetPivot().p
                    task.wait()
                end

                bg:Destroy()
                lp.Character:PivotTo(op)
                togs.Noclip.Toggled = nt
                Note(("Flung %s"):format(selected.Name))
            end)

            thing:Button("Crim", function()
                if not selected or not selected.Character or not lp.Character then return end

                Crim(selected)
                Note(("Made %s criminal"):format(selected.Name))
            end)

            thing:Button("Arrest", function()
                if not selected or not selected.Character or not lp.Character then return end

                local oldpos = lp.Character.PrimaryPart.CFrame

                if not CanBeArrested(selected) then
                    Crim(selected)
                end

                Goto(selected.Character.PrimaryPart.CFrame)
                task.spawn(remotes.Arrest.InvokeServer, remotes.Arrest, selected.Character.Head)
                selected.Character.Head:WaitForChild("handcuffedGui", 1/0)
                Goto(oldpos)
                Note(("Arrested %s"):format(selected.Name))
            end)

            thing:Button("Spam arrest", function()
                if not selected or not selected.Character or not lp.Character then return end

                SpamArrest(selected, togs.SpamArrestPower)
            end)

            thing:Button("Kill", function()
                if not selected or not selected.Character or not lp.Character then return end

                repeat task.wait() until not selected.Character or not selected.Character:FindFirstChild("ForceField")

                Kill{selected}
                Note(("Killed %s"):format(selected.Name))
            end)

            thing:Button("Give current item", function() 
                if not selected or not selected.Character or not lp.Character then return end
                local tool = lp.Character:FindFirstChildOfClass("Tool")

                if not tool then
                    Note("Please equip an item to give.", true)
                    return
                end

                tool.Parent = lp.Backpack
                Bring(selected, lp.Character:FindFirstChildOfClass("Tool"), lp.Character:GetPivot())
                Note(("Gave %s your weapon"):format(selected.Name))
            end)
        end
    end

    -- Settings Window
    do
        local setting = lib:Window("Settings")

        setting:Dropdown("Drawing gun", {"M9", "Remington 870", "M4A1", "AK-47"}, function(a)
            togs.Drawing.Gun = a
        end)

        setting:Dropdown("Bring tool", {"M9", "Remington 870", "M4A1", "AK-47", "Hammer", "Crude Knife"}, function(a)
            togs.BringTool = a
        end)

        setting:Slider("Spam arrest power", 1, 100, togs.SpamArrestPower, false, function(a)
            togs.SpamArrestPower = a
        end)

        setting:Button("Break spam arrest", function()
            breaksa = true
            task.wait(.1)
            breaksa = false
            Note("Broke current spam arrest")
        end)

        setting:Button("Athena chat", function()
            ChatLogs.AthenaChat.Visible = true
        end)

        setting:Button("Exploiter detections", function()
            ChatLogs.ExploiterDetect.Visible = true
        end)

        setting:Toggle("Notify on detect", togs.EDN, function(a)
            togs.EDN = a
        end)

        setting:Toggle("No fade ui", togs.NoFade, function(a)
            togs.NoFade = a
            lp.PlayerGui.Home.fadeFrame.Visible = not a
        end)

        setting:Toggle("Anti bring V1", togs.AntiBring, function(a)
            togs.AntiBring = a
        end)

        setting:Toggle("Anti arrest V1", togs.AntiArrest, function(a)
            togs.AntiArrest = a
        end)

        setting:Toggle("Anti criminal", togs.AntiCriminal, function(a)
            togs.AntiCriminal = a
        end)

        setting:Toggle("Anti crash/lag", togs.AntiCrash, function(a)
            togs.AntiCrash = a
        end)

        setting:TextBox("Admin Prefix", {}, function(a) 
            togs.Admin.Prefix = a:sub(1, 1)
        end)

        setting:Keybind("Cmd Focus Key", togs.Admin.FocusKey, function(a) 
            togs.Admin.FocusKey = a
        end)

        setting:Toggle("Ui blur", true, function(a)
            settings.blur = a
        end)

        setting:Toggle("Ui disable chat", true, function(a)
            settings.disablechat = a
        end)
    end

    -- Schematics Window (no do end since end of segment)

    local schem = lib:Window("Schematics")

    for i,v in pairs(listfiles"AthenaSchematics") do
        local thing = schem:ToggleDropdown(v:sub(18), false, print)

        for i2,v2 in pairs(listfiles(v)) do
            local noext = v2:split(".")[1]:split("\\")[3]

            thing:Button(noext, function()
                local json = readfile(v2)

                for i,v3 in pairs(sv.HttpService:JSONDecode(json)) do
                    local ss = v3.Origin:split(",")
                    local es = v3.End:split(",")
                    local s = Vector3.new(tonumber(ss[1]), tonumber(ss[2]), tonumber(ss[3]))
                    local e =  Vector3.new(tonumber(es[1]), tonumber(es[2]), tonumber(es[3]))
                    local mag = (s - e).magnitude
                    local object = Instance.new("Part", workspacedrawingobjects)

                    object.Name = "DrawingPart"
                    object.Material = Enum.Material.Neon
                    object.BrickColor = BrickColor.Yellow()
                    object.CanCollide = false
                    object.Anchored = true
                    object.Transparency = .5
                    object.Size = Vector3.new(.2, .2, mag)
                    object.CFrame = CFrame.new(s, e) * CFrame.new(0, 0, -mag * .5)
                    drawingobjects[object] = {Origin = s, End = e}
                end

                Note(("Loaded schematic %s"):format(noext))
            end)
        end 
    end
end

task.spawn(LoaderUpdate)

-- Hooks
do
    local namecall; namecall = hookmetamethod(game, "__namecall", function(s, ...)
        local args = {...}
        local method = getnamecallmethod()
        local calling = getcallingscript()

        if not checkcaller() then
            if method == "SetCoreGuiEnabled" and args[1] == Enum.CoreGuiType.Backpack then
                return
            end
            
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

                if togs.SilentAim.Toggled and table.find({"TaserInterface", "GunInterface"}, tostring(calling)) then
                    local CPP, hit = GetClosestToMousePos(ignore, togs.SilentAim.Wallcheck, togs.SilentAim.Range, togs.SilentAim.Radius, togs.SilentAim.DeadCheck, togs.SilentAim.HitPart)

                    if hit then
                        local headp = lp.Character and lp.Character.FindFirstChild(lp.Character, "Head") and lp.Character.Head.Position

                        if headp then
                            local spread = require(lp.Character.FindFirstChildOfClass(lp.Character, "Tool").GunStates).Spread / (headp - CPP).magnitude
                            CPP += togs.SilentAim.Spread and Vector3.new(math.random(-spread, spread), math.random(-spread, spread), math.random(-spread, spread)) or Vector3.zero -- math.random spam but what can ya do

                            return hit, CPP
                        end
                    end
                end

                if table.find({"TaserInterface", "GunInterface"}, tostring(calling)) then
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
                    if table.find(togs.Whitelist, args[1].Name) then
                        return
                    end

                    if togs.OnePunch then
                        for i = 1, math.ceil(args[1].Character.Humanoid.Health / 10) do
                            namecall(s, ...)
                        end
                    end
                end

                if s == remotes.Shoot then
                    for i,v in pairs(args[1]) do
                        if not v.Hit then continue end

                        local plr = GetPlayer(v.Hit)
                        if table.find(togs.Whitelist, plr) then
                            v["Hit"] = nil
                        end
                    end

                    if togs.GunMods.Toggled then
                        if togs.GunMods.InfiniteAmmo then
                            remotes.Reload.FireServer(remotes.Reload, args[2])
                            local gunstates = require(args[2].GunStates)
                            gunstates.CurrentAmmo = gunstates.MaxAmmo + 1
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
                                local hitmodel = a1.Hit.FindFirstAncestorOfClass(a1.Hit, "Model")
                                local plr = sv.Players.GetPlayerFromCharacter(sv.Players, hitmodel)
                                if plr and hitmodel.FindFirstChild(hitmodel, "Humanoid") and hitmodel.Humanoid.Health ~= 0 and plr.TeamColor ~= lp.TeamColor then
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

    local BrickColorHook; BrickColorHook = hookfunction(getrenv().BrickColor.Yellow, function()
        if checkcaller() or not tostring(getcallingscript()):find("Interface") then return BrickColorHook() end
        local a = togs.CCB

        return a.Rainbow and BrickColor.random() or BrickColor.new(a.R, a.G, a.B)
    end)

    local RandomHook; RandomHook = hookfunction(math.random, function(a, b)
        if checkcaller() or not tostring(getcallingscript()):find("Interface") then return RandomHook(a, b) end

        return togs.GunMods.NoSpread and 0 or RandomHook(a, b)
    end)

    for i,v in pairs(getgc()) do
		if type(v) == "function" and getfenv(v).script == lp.PlayerScripts.ClientGunReplicator then -- i fucking hate syn v2
            local old; old = hookfunction(v, function(bullets, istaser)
                if not togs.AntiCrash then return ReplicateHook(bullets, istaser) end
                for i,v in pairs(bullets) do
                    if not v.RayObject or not v.Cframe or not v.Distance or v.Distance > 800 or v.Distance == 0 then
                        return
                    end
                end
    
                return old(bullets, istaser)
            end)
            
			break
		end
    end
end
-- Connections
do
    workspace.Remote.arrestPlayer.OnClientEvent:Connect(function()
        if not togs.AntiArrest or not lp.Character or not lp.Character:FindFirstChild("Humanoid") then return end

        local oldc, oldar, oldpos = lp.TeamColor, togs.AutoRespawn.Toggled, lp.Character:GetPivot()
        togs.AutoRespawn.Toggled = false
        lp.Character:BreakJoints()
        lp.CharacterAdded:Wait()
        task.spawn(Respawn, oldc, oldpos)
        togs.AutoRespawn.Toggled = oldar
    end)

    remotes.Replicate.OnClientEvent:Connect(function(bullets) -- became a new message handler
        local plr = bullets[1] and bullets[1]["https://discord.gg/ng8yFn2zX6"]
        if plr and plr:IsA("Player") and not table.find(athenausers, plr.Name) then
            table.insert(athenausers, plr.Name)
            table.insert(togs.Whitelist, plr.Name)
            Note(plr.Name.." is using Athena!")

            SendMsg({
                [1] = {
                    ["https://discord.gg/ng8yFn2zX6"] = lp
                }
            })

            return
        end

        if bullets[1] and bullets[1]["ACC_IDENTIFIER"] then
            local fnlmsg = {""}

            table.foreach(bullets[2], function(_, v)
                if _:sub(1, 3) == "ACC" then
                    fnlmsg[tonumber(_:sub(5))] = string.char(v * .052)
                end
            end)

            ChatLogAdd(bullets[1]["ACC_IDENTIFIER"] * 9.98, table.concat(fnlmsg):reverse(), tick())

            return
        end

        if not togs.Thorns then return end

        local shots = {}

        for i,v in pairs(bullets) do
            local dis, plr = math.huge

            for i,v2 in pairs(sv.Players:GetPlayers()) do
                if v2 ~= lp and v2.Character and v2.Character:FindFirstChild("Humanoid") then
                    local tool = v2.Character:FindFirstChildOfClass("Tool")

                    if tool and table.find({"AK-47", "M4A1", "M9", "Remington 870", "Taser"}, tool.Name) and tool:FindFirstChild("Muzzle") then
                        local dbraymuzzle = (v.RayObject.Origin - tool.Muzzle.CFrame.p).magnitude

                        if dbraymuzzle < dis then
                            dis, plr = dbraymuzzle, v2
                        end
                    end
                end
            end

            if plr then
                table.insert(shots, {
                    ["Player"] = plr,
                    ["Hit"] = GetPlayer(v.Hit)
                })
            end
        end

        for i,v in pairs(shots) do
            if not v.Hit or not v.Player then continue end
            
            if ((table.find(giventhorns, v.Hit.Name)) or (togs.Thorns and v.Hit == lp)) and not table.find(togs.Whitelist, v.Player.Name) and v.Hit.TeamColor ~= v.Player.TeamColor then
                Kill{v.Player}

                return
            end

            if table.find(givenoneshot, v.Player.Name) and not table.find(togs.Whitelist, v.Hit.Name) and v.Hit.TeamColor ~= v.Player.TeamColor then
                Kill{v.Hit}
            end
        end
    end)

    local isdrawing, object, from
    lp:GetMouse().Button1Down:Connect(function()
        if not togs.Drawing.Toggled then return end

        local hit, pos = lp:GetMouse().Target, lp:GetMouse().Hit.p

        if hit and hit.Name == "DrawingPart" then
            if togs.Drawing.Delete then
                hit:Destroy()
                drawingobjects[hit] = nil

                return
            end

            if togs.Drawing.Edit then
                lp:GetMouse().TargetFilter = workspacedrawingobjects
                local obj = drawingobjects[hit]
                from = (pos - obj.Origin).magnitude > (pos - obj.End).magnitude and "Origin" or "End"
                object = hit
                isdrawing = true

                return
            end
        end

        if togs.Drawing.Place then
            lp:GetMouse().TargetFilter = workspacedrawingobjects
            isdrawing = true
            object = Instance.new("Part", workspacedrawingobjects)
            object.Name = "DrawingPart"
            object.Transparency = .5
            object.Material = Enum.Material.Neon
            object.BrickColor = BrickColor.Yellow()
            object.CanCollide = false
            object.Anchored = true
            object.Size = Vector3.new(.2, .2, .2)
            object.CFrame = CFrame.new(pos, pos)
            from = "Origin"
            drawingobjects[object] = {
                ["Origin"] = pos,
                ["End"] = pos
            }
        end
    end)

    lp:GetMouse().Move:Connect(function()
        if isdrawing and object and drawingobjects[object] then
            local ending = from == "Origin" and "End" or "Origin"
            local pos, origin = lp:GetMouse().Hit.p, drawingobjects[object][from]
            drawingobjects[object] = {
                [from] = origin,
                [ending] = pos
            }

            object.CFrame = CFrame.new(origin, pos) * CFrame.new(0, 0, -(pos - origin).magnitude * .5)
            object.Size = Vector3.new(.2, .2, (pos - origin).magnitude)
        end
    end)

    lp:GetMouse().Button1Up:Connect(function()
        lp:GetMouse().TargetFilter = nil
        isdrawing = false
        object = nil
        from = nil
    end)

    sv.RunService.Stepped:Connect(function()
        if not togs.Noclip.Toggled then return end
        
        for i,v in pairs(workspace.CarContainer:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

        for i,v in pairs(sv.Players:GetPlayers()) do
            if v.Character then
                for i2,v2 in pairs(v.Character:GetDescendants()) do
                    if v2:IsA("BasePart") then
                        v2.CanCollide = false
                    end
                end
            end
        end
    end)

    workspace.Prison_ITEMS.single.ChildAdded:Connect(function(a)
        if a.Name ~= "Key card" or not togs.AGK then return end

        remotes.Item:InvokeServer(a:WaitForChild"ITEMPICKUP")
    end)

    sv.Players.PlayerRemoving:Connect(PlayerRemoved)
    sv.Players.PlayerAdded:Connect(PlayerAdded)
    lp.Chatted:Connect(HandleMessage)
    OnCharacterAdded(lp.Character)
    lp.CharacterAdded:Connect(OnCharacterAdded)
    sv.ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(msgdata)
        if msgdata.FromSpeaker == lp.Name then return end

        if table.find(togs.Admin.Admins, msgdata.FromSpeaker) and msgdata.Message:sub(1, 1) == togs.Admin.Prefix then
            if table.find({"help", "cmds"}, msgdata.Message:lower():sub(2, 5)) then
                sv.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(("/w %s Prefix is %s | Your commands list: "):format(msgdata.FromSpeaker, togs.Admin.Prefix), "All")
                local msg = ""
                local msgs = {}
                for i,v in pairs(Commandstbl) do
                    if v.IsUseableByOthers then
                        msg = ("%s %s (%s),"):format(msg, v.Command, not v.Aliases and "" or type(v.Aliases) == "table" and table.concat(v.Aliases, ", ") or v.Aliases)
                    end
                end

                for i = 1, math.ceil(#msg / 250) do
                    table.insert(msgs, msg:sub(i ~= 1 and (i - 1) * 250 or 1, i * 250))
                end

                for i,v in pairs(msgs) do
                    sv.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(("/w %s %s"):format(msgdata.FromSpeaker, v), "All")
                    task.wait(.5)
                end
                
                return
            end

            HandleMessage(msgdata.Message, msgdata.FromSpeaker)
        end
    end)
end

task.spawn(LoaderUpdate)

-- lots of loops

do
    task.spawn(function()
        while task.wait() do
            if lp.Team == sv.Teams.Criminals and togs.AntiCriminal then
                for i = 1, 50 do
                    if lp.Team == sv.Teams.Criminals then
                        Respawn(sv.Teams.Guards.TeamColor, positions["Nexus"])
                    end
                    
                    task.wait()
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait() do
            pcall(function()
                if togs.Fly.Toggled then
                    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") or not lp.Character:FindFirstChild("Humanoid") or sv.UserInputService:GetFocusedTextBox() ~= nil then return end
                    local hrp = lp.Character.HumanoidRootPart
                    local fv = hrp:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity", hrp)
                    local fg = hrp:FindFirstChild("BodyGyro") or Instance.new("BodyGyro", hrp)
                    local uis = sv.UserInputService
                    local kd = sv.UserInputService.IsKeyDown -- i rly dont wanna type this every time
                    local speed = togs.Fly.Speed * 10
                    local curdown = {
                        w = kd(uis, Enum.KeyCode.W) and speed or oldctrl.w * .9,
                        s = kd(uis, Enum.KeyCode.S) and -speed or oldctrl.s * .9,
                        a = kd(uis, Enum.KeyCode.A) and -speed or oldctrl.a * .9,
                        d = kd(uis, Enum.KeyCode.D) and speed or oldctrl.d * .9
                    }
                    local velocity = (cam.CFrame.LookVector * (curdown.w + curdown.s)) + (cam.CFrame.RightVector * (curdown.d + curdown.a))

                    fv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    fg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

                    fv.P = togs.Fly.Speed * 1000
                    fg.P = togs.Fly.Speed * 1000
                    fg.D = togs.Fly.Speed * 10

                    fv.Velocity = velocity
                    fg.CFrame = cam.CFrame

                    oldctrl = curdown

                    lp.Character.Humanoid.PlatformStand = true
                else
                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid") then
                        (lp.Character.HumanoidRootPart:FindFirstChild("BodyGyro") or Instance.new("Model")):Destroy();
                        (lp.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") or Instance.new("Model")):Destroy()
                        lp.Character.Humanoid.PlatformStand = false
                    end
                end
            end)
        end
    end)

    task.spawn(function()
        while task.wait() do
            if togs.SpamArrestAura then
                for i,v in pairs(sv.Players:GetPlayers()) do
                    if v ~= lp and CanBeArrested(v) and not table.find(togs.Whitelist, v.Name) and v.Character and v.Character.PrimaryPart then
                        if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("Head") and lp:DistanceFromCharacter(v.Character.PrimaryPart.Position) <= 12 then
                            for i = 1,togs.SpamArrestPower do
                                task.spawn(remotes.Arrest.InvokeServer, remotes.Arrest, v.Character.Head)
                            end
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(2) do
            if togs.TazeAura then
                local tt = {}

                for i,v in pairs(sv.Players:GetPlayers()) do
                    if v ~= lp and not table.find(togs.Whitelist, v.Name) and v.Character and v.Character.PrimaryPart and lp.Character and (lp.Character:FindFirstChild("Taser") or lp.Backpack:FindFirstChild("Taser")) then
                        if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("Head") and lp:DistanceFromCharacter(v.Character.PrimaryPart.Position) <= 12 then
                            table.insert(tt, v)
                        end
                    end
                end 

                if tt[1] then
                    local senttbl = {}
                    local gun = lp.Character:FindFirstChild("Taser") or lp.Backpack:FindFirstChild("Taser")

                    for i,v in pairs(tt) do
                        table.insert(senttbl, {
                            ["RayObject"] = Ray.new(),
                            ["Distance"] = 0,
                            ["Cframe"] = CFrame.new(),
                            ["Hit"] = v.Character.Head
                        })
                    end

                    remotes.Reload:FireServer(gun)
                    remotes.Shoot:FireServer(tt, gun)
                    remotes.Reload:FireServer(gun)
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(.1) do
            if togs.Loopkill.Toggled then
                local kt = {}

                for i, v in pairs(sv.Players:GetPlayers()) do
                    if v ~= lp and table.find(loopkilltable, v.Name) or (togs.Loopkill.Custom and not v.Team) or togs.Loopkill[tostring(v.Team)] and not table.find(togs.Whitelist, v.Name) then
                        if v.Character and not v.Character:FindFirstChild("ForceField") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 then
                            table.insert(kt, v)
                        end
                    end
                end

                if kt[1] then
                    task.spawn(Kill, kt)
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(.2) do
            if togs.Killaura.Toggled then
                local kt, mkt = {}, {}
                
                for i,v in pairs(sv.Players:GetPlayers()) do
                    if v == lp or table.find(togs.Whitelist, v.Name) or not v.Character then continue end

                    if (togs.Loopkill.Custom and not v.Team) or togs.Loopkill[tostring(v.Team)] then
                        if lp.Character and lp:DistanceFromCharacter(v.Character:GetPivot().p) <= 10 then
                            table.insert(mkt, v)
                            continue
                        end
                        
                        for i,v2 in pairs(givenkillaura) do
                            local plr = sv.Players:FindFirstChild(v2)
                            if plr and plr.Character and plr:DistanceFromCharacter(v.Character:GetPivot().p) <= 10 then
                                table.insert(kt, v)
                            end
                        end
                    end
                end
                
                if kt[1] then
                    task.spawn(Kill, kt)
                end

                if mkt[1] then
                    task.spawn(MeleeKill, mkt)
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(togs.Drawing.Refresh) do
            if togs.Drawing.Toggled then
                pcall(function() -- kept getting an error about the gun property being something idfk
                    local tool = lp.Backpack:FindFirstChild(togs.Drawing.Gun)

                    if tool then
                        local args = {}

                        for i,v in pairs(drawingobjects) do
                            local distance = (v.Origin - v.End).magnitude
                            local Hit = ProperRay(v.Origin, v.End, map)

                            if Hit then
                                local ancestor = Hit:FindFirstAncestorOfClass("Model")
                                local plr = ancestor and sv.Players:GetPlayerFromCharacter(ancestor)

                                if plr then
                                    if table.find(togs.Whitelist, plr.Name) then
                                        Hit = nil
                                    end

                                    if Hit and togs.Drawing.InstaKill then
                                        Kill{plr}
                                    end
                                end
                            end

                            table.insert(args, {
                                ["RayObject"] = Ray.new(v.Origin, v.End),
                                ["Distance"] = distance,
                                ["Cframe"] = CFrame.new(v.Origin, v.End) * CFrame.new(0, 0, -distance * .5),
                                ["Hit"] = Hit
                            })
                        end

                        if args[1] then
                            sv.ReplicatedStorage.EquipEvent:FireServer(tool)
                            remotes.Shoot:FireServer(args, tool)
                            remotes.Reload:FireServer(tool)
                        end
                    end
                end)
            end
        end
    end)

    task.spawn(function()
        while task.wait(2) do
            SaveData(togs)
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
end

-- Loadstring tpdata and random stuff
do
    workspacedrawingobjects.Name = "AthenaDrawingObjects"

    task.wait(math.random(0, 1))

    SendMsg({
        [1] = {
            ["https://discord.gg/ng8yFn2zX6"] = lp
        }
    })

    getgenv().SendMsg = SendMsg

    local Tpdata = {...}

    if Tpdata["Color"] then
        Respawn(Tpdata.Color, Tpdata.Position)

        giventhorns = Tpdata.GivenThorns
        givenoneshot = Tpdata.GivenOneShot
        givenantitouch = Tpdata.GivenAntiTouch
        givenkillaura = Tpdata.GivenKillAura
        selected = sv.Players:FindFirstChild(Tpdata.Selected)
        loopkilltable = Tpdata.LoopkillTable

        for i,v in pairs(sv.HttpService:JSONDecode(Tpdata.DrawingObjects)) do
            local mag = (v.Start - v.End).magnitude
            local object = Instance.new("Part", workspacedrawingobjects)

            object.Name = "DrawingPart"
            object.Material = Enum.Material.Neon
            object.BrickColor = BrickColor.Yellow()
            object.CanCollide = false
            object.Anchored = true
            object.Transparency = .5
            object.Size = Vector3.new(.2, .2, mag)
            object.CFrame = CFrame.new(v.Start, v.End) * CFrame.new(0, 0, -mag * .5)
            drawingobjects[object] = {Origin = v.Start, End = v.End}
        end
    end
end

-- everyones favorite part (not fucking mine), COMMANDS!

do
    AddCommand("Kill", "k", "Kills given players or team", true --[[requiresargs]], true --[[IsUseableByOthers]], function(plr, ...)
        local kt = {}

        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if v2 == lp then continue end

                table.insert(kt, v2)
            end
        end

        if kt[1] then
            Kill(kt)
        end
    end)

    AddCommand("Loopkill", "lk", "Loopkills given players or team", true, true, function(plr, ...)
        for i,v in pairs({...}) do
            local t = GetTeam(v) or GetPlayer(v)
            if t == lp then continue end
            if not t then continue end

            if type(t) == "string" then
                togs.Loopkill[t] = true

                return
            end

            table.insert(loopkilltable, t.Name)
        end
    end)

    AddCommand("Respawn", {"Re", "Reload"}, "Reloads your character", false, false, function(plr, ...)
        Respawn()
    end)

    AddCommand("Getswatitems", {"Getswat", "Gsi"}, "Gets swat items", false, false, function(plr, ...)
        local oldteam
        if lp.Team ~= sv.Teams.Guards then
            oldteam = lp.TeamColor.Name
            if #sv.Teams.Guards:GetPlayers() < 8 then
                if lp.Team ~= sv.Teams.Criminals then
                    Team("Bright blue")
                else
                    Respawn(BrickColor.new("Bright blue"))
                end
            else
                Note("Guard team is full!", true)

                return
            end
        end

        remotes.Item:InvokeServer(workspace.Prison_ITEMS.clothes:FindFirstChild("Riot Police").ITEMPICKUP)
        GetGun{"Riot Shield"}

        if oldteam then
            Team(oldteam)
        end
    end)

    AddCommand("Getguns", "Guns", "Gets your guns in gun order", false, false, function(plr, ...)
        GetGun(togs.GunOrder)
    end)

    AddCommand("Athenachat", "Ach", "Opens the athena server chat", false, false, function(plr, ...)
        ChatLogs.AthenaChat.Visible = true
    end)

    AddCommand("Exploiterdetections", {"exploitlogs", "elogs"}, "Opens the exploiter detections", false, false, function(plr, ...)
        ChatLogs.ExploiterDetect.Visible = true
    end)

    AddCommand("Breakspamarrest", {"Breaksa", "Breakspam", "Bsa"}, "Breaks spam arrest", false, false, function(plr, ...)
        breaksa = true
        task.wait(.1)
        breaksa = false
    end)

    AddCommand("Cleardrawing", "Cleard", "Clears all drawing objects", false, false, function(plr, ...)
        drawingobjects = {}
        workspacedrawingobjects:ClearAllChildren()
    end)

    AddCommand("Arrest", "ar", "Arrests player", true, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if v2 == lp then continue end
                local oldpos = lp.Character.PrimaryPart.CFrame

                if not CanBeArrested(v2) then
                    Crim(v2)
                end

                Goto(v2.Character.PrimaryPart.CFrame)
                task.spawn(remotes.Arrest.InvokeServer, remotes.Arrest, v2.Character.Head)
                v2.Character.Head:WaitForChild("handcuffedGui", 1/0)
                Goto(oldpos)
            end
        end
    end)

    AddCommand("Copyteamcolor", {"ctc", "ct"}, "Copies player team color", true, false, function(plr, one)
        local splr = GetPlayer(one)
        if not splr then return end

        Respawn(splr.TeamColor)
    end)

    AddCommand("Goto", {"to", "teleport"}, "Teleports player to player (only 1 argument accepted)", true, true, function(plr, one)
        local splr = GetPlayer(one)
        if not splr then return end

        if not plr then
            Goto(splr.Character:GetPivot())

            return
        end

        GetGun{togs.BringTool}
        Bring(sv.Players[plr], lp.Backpack:WaitForChild(togs.BringTool), splr.Character:GetPivot())
    end)

    AddCommand("Rejoin", "Rj", "Rejoins the server", false, false, function(plr, ...)
        sv.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end)

    AddCommand("Copygameteleport", {"Copytp", "Copygametp", "Ctp"}, "Get the games teleport", false, false, function(plr, ...)
        setclipboard(("game:GetService\"TeleportService\":TeleportToPlaceInstance(%i, \"%s\")"):format(game.PlaceId, game.JobId))
    end)

    AddCommand("Timeout", "Disconnect", "Timeouts the server", false, false, function(plr, ...)
        GetGun{"M9"}
        local gun = lp.Backpack:FindFirstChild("M9") or lp.Character:FindFirstChild("M9")

        for i = 1, math.random(1500, 2000) do
            remotes.Shoot:FireServer({}, gun)
        end
    end)

    AddCommand("Weldcrash", "Crash", "Crashes the server using welds", false, false, function(plr, ...)
        GetGun{"Remington 870"}
        local rem = lp.Backpack:WaitForChild("Remington 870")

        for i = 1,4000 do
            remotes.Weld.FireServer(remotes.Weld, rem)
        end

        task.wait(2)
        rem.Parent = lp.Character
        task.wait()
        rem.Parent = lp.Backpack
    end)

    AddCommand("Saveschematic", {"Save", "Saveschem"}, "Saves all your drawing objects into a file with the name given", true, false, function(plr, ...)     
        local save = {}

        for i,v in pairs(drawingobjects) do
            local s = tostring(v.Origin):gsub(" ", "") -- gsub returns a tuple so
            local e = tostring(v.End):gsub(" ", "")
            table.insert(save, {
                Origin = s,
                End = e
            })
        end

        writefile("AthenaSchematics/Saved/"..table.concat({...})..".txt", sv.HttpService:JSONEncode(save))
    end)

    AddCommand("Admin", "Rank", "Admins given player", true, false, function(plr, ...)
        for i,v in pairs({...}) do
            local splr = GetPlayer(v)
            if not splr then continue end

            ChangeAdminPerms(splr.Name)
        end
    end)

    AddCommand("Bring", nil, "Brings player to you or an admin", true, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if v2 == lp then continue end

                GetGun{togs.BringTool}
                Bring(v2, lp.Backpack:FindFirstChild(togs.BringTool), plr and sv.Players[plr].Character:GetPivot() or lp.Character:GetPivot())
            end
        end
    end)

    AddCommand("Criminal", "Crim", "Criminals given players", true, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if v2 == lp then continue end

                GetGun{togs.BringTool}
                Crim(v2)
            end
        end
    end)

    AddCommand("Spamarrest", "sa", "Spam arrests given players", true, false, function(plr, ...)
        local plr, power = ...
        local aplr = GetPlayer(plr)

        if not aplr then return end
        SpamArrest(aplr, power or togs.SpamArrestPower)
    end)

    AddCommand("Unloopkill", "Unlk", "Unloopkills given players", true, true, function(plr, ...)
        for i,v in pairs({...}) do
            local t = GetTeam(v) or GetPlayer(v)
            if not t then continue end

            if type(t) == "string" then
                togs.Loopkill[t] = false

                return
            end

            local f = table.find(loopkilltable, t.Name)

            if f then
                table.remove(loopkilltable, f)
            end
        end
    end)
end

--[[AddCommand("Admin", {"Rank"}, "Admins given player", true, false, function(plr, ...)
    for i,v in pairs({...}) do
        local plr = GetPlayer(v)
        if not plr then continue end

        ChangeAdminPerms(plr.Name)
    end
end)

AddCommand("Admin", {"Rank"}, "Admins given player", true, false, function(plr, ...)
    for i,v in pairs({...}) do
        local plr = GetPlayer(v)
        if not plr then continue end

        ChangeAdminPerms(plr.Name)
    end
end)

AddCommand("Admin", {"Rank"}, "Admins given player", true, false, function(plr, ...)
    for i,v in pairs({...}) do
        local plr = GetPlayer(v)
        if not plr then continue end

        ChangeAdminPerms(plr.Name)
    end
end)]]

task.spawn(LoaderUpdate)
Note("Press Right Control to open")
