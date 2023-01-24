local DEBUGGING_MODE = true

--[[
    https://discord.gg/ng8yFn2zX6  -- Our discord, come report bugs and help development.

    Credits:
        D-C Team -- trolling those skiddies that say they know lua
        sawd#2906 -- all the scripting + ui lib
        FATE#8209 -- helpin with humanoid stuff (i never touched it before)
        t0xic_waste9807#2444 -- being a dumb retard who doesnt shut the fuck up
	    dm me (sawd) if u want credit here
    TODO:
        fuckin no clue
]]

-- feel free to LEARN from this, not straight up steal it.

-- Variables used basically 2 or more places not in the same do end
-- General Purpose
local sv =     setmetatable({}, {__index = function(_, a) return game.GetService(game, a) end})
local req =    (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local lp =     sv.Players.LocalPlayer
local isv2 =   KRNL_LOADED or ({identifyexecutor()})[2]:find("v2")
local HasM4 =  sv.MarketplaceService:UserOwnsGamePassAsync(lp.UserId, 96651)
local ffalse = isv2 and 0 or false
local cam =    workspace.CurrentCamera

-- Created Instances
local ChatLogs =  Instance.new("ScreenGui", sv.CoreGui)
local workspacedrawingobjects = Instance.new("Model", workspace)

-- Functions vars
local Log

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
givenantipunch,
PlayerESPDrawings,
oldctrl,
tools,
remotes,
positions,
trusted, 
togs = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {},
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
    ["Base"] = CFrame.new(-860.264526, 95.9438858, 2085.03564, 0.0224340688, -0.00536062894, -0.999733925, -3.02877697e-06, 0.999985635, -0.00536204642, 0.99974829, 0.000123324076, 0.0224337298),
    ["Pad"] =  CFrame.new(-977.83075, 110.823158, 2053.60034, -0.00541115459, -0.000807852659, -0.99998498, -1.53944185e-07, 0.999999642, -0.000807863718, 0.999985337, -4.22384346e-06, -0.00541115273),
    ["Slide"] =     CFrame.new(-134.624069, 321.450897, 3625.00415, 0.0220788661, 0.0105385808, 0.999700665, 2.42649165e-11, 0.999944448, -0.0105411503, -0.999756217, 0.000232736682, 0.0220776387)
},
{
    [2513042154] = "GFX",
    [521510355]  = "FATE",
    [451785325]  = "FATE",
    [3763951536] = "Dis",
    [2506979623] = "Air Conditioner",
    [1980195146] = "Jess",
    [4189672133] = "Shortest being",
    [4218694845] = "Shortest being",
    [160458279]  = "Hack Admin Dev",
    [225482815]  = "Furry gunclanner",
    [2413365536] = "Midnight",
    [1884661572] = "Silence",
    [1437457246] = "Pedophile",
    [275535162]  = "Hack Admin Dev",
    [1364211018] = "Signus",
    [1993374243] = "Romie", -- :troll:
    [502511191]  = "Annoying cunt",
    [3465019018] = "JJ",
    [3888471680] = "Gay ass furry"

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
        [5] =               "Hammer";
        [6] =               "Crude Knife";
        [7] =               "Riot Shield";
    };
    AutoRespawn = {
        Toggled =           false;
        EquipOldWeapon =    false;
        ForceField =        false;
        GFF =               false;
    };
    CustomTeam = {
        R =                 255;
        G =                 255;
        B =                 255;
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
                            "TheSon99"
    };
    Admin = {
        Prefix =            "-";
        FocusKey =          Enum.KeyCode.Semicolon;
        Admins =            {}
    };
    Keybinds = { -- paa best keybinds
        Respawn =           Enum.KeyCode.Q;
        BurstKillaura =     Enum.KeyCode.G;
        GetGuns =           Enum.KeyCode.Z;
        Noclip =            Enum.KeyCode.E
    };
    ESP =                   false;
    Noclip =                false;
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
    HardendAntiBring =      false;
    NoFade =                false;
    AntiTouch =             false;
    SpamPunch =             false;
    Godmode =               false;
    ADHRP =                 false;
    AGK =                   false;
    SpamArrestPower =       10;
    BringTool =             "Hammer";
    KillGun =               "M9";
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

local function getmousepos()
    local mouse = lp:GetMouse()
    return Vector2.new(mouse.X, mouse.Y) + sv.GuiService:GetGuiInset()
end

local function IsInFrame(MousePos, gPos, gSize) -- https://devforum.roblox.com/t/detect-if-a-guiobject-is-inside-a-frame/1124412/10
    return ((MousePos.X < (gPos.X + gSize.X) and MousePos.X > gPos.X) and (MousePos.Y < (gPos.Y + gSize.Y) and MousePos.Y > gPos.Y))
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
		writefile("athenaplconfig.json", sv.HttpService:JSONEncode({}))
	end

    if not isfile("athenacustomcommands.lua") then
        writefile("athenacustomcommands.lua", "return {}")
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

local DrawingStruct = {}
DrawingStruct.__index = DrawingStruct

function DrawingStruct.new(parent, dtype, name, props) -- will not be used for loader or notes cuz dont need to remake those again
	local self = setmetatable({Parent = parent; Obj = Drawing.new(dtype); Name = name}, {__index = DrawingStruct; __newindex = function(_, k, v)
		if isv2 then -- really shit edge casing
			if pcall(function(a) return a.Obj[k] end, _) then
				_.Obj[k] = v
			else
				rawset(_, k, v)
			end
		else
			if _.Obj[k] then
				_.Obj[k] = v
			else
				rawset(_, k, v)
			end
		end
	end, __tostring = function()
		return name
	end})

	for i,v in next, props do
		self.Obj[i == "Outlined" and "Outline" or i] = v
	end

	if parent then
		parent[name] = self
	end

	return self
end

function DrawingStruct.children(self)
	local children = {}

	for i, v in next, self do
		if i ~= "Obj" and i ~= "Parent" and i ~= "Name" then
			children[i] = v
		end
	end

	return children
end

function DrawingStruct.ancestors(self)
	local ancestors = {}

	repeat table.insert(ancestors, self.Parent) until not self.Parent or not task.wait()

	return ancestors
end

local function MakeBoxedFrame(pos, size, parent, mboxp)
	local elements = {}

	elements.Main = DrawingStruct.new(parent, "Square", "MainP", {
		Position = pos,
		Size = size,
	})

	elements.T = DrawingStruct.new(elements.Main, "Line", "T", {
		Thickness = 2,
		Color = Color3.new(),
		ZIndex = 1,
		From = pos,
		To = pos + Vector2.new(size.X, 0)
	})

	elements.B = DrawingStruct.new(elements.Main, "Line", "B", {
		Thickness = 2,
		Color = Color3.new(),
		ZIndex = 1,
		From = pos + Vector2.new(0, size.Y),
		To = pos + Vector2.new(size.X, size.Y)
	})

	elements.L = DrawingStruct.new(elements.Main, "Line", "L", {
		Thickness = 2,
		Color = Color3.new(),
		ZIndex = 1,
		From = pos,
		To = pos + Vector2.new(0, size.Y)
	})

	elements.R = DrawingStruct.new(elements.Main, "Line", "R", {
		Thickness = 2,
		Color = Color3.new(),
		ZIndex = 1,
		From = pos + Vector2.new(size.X, 0),
		To = pos + Vector2.new(size.X, size.Y)
	})

	for i,v in next, mboxp do
		elements.Main.Obj[i] = v
	end

	return elements
end

local LoaderUpdate do
    local drawingobjs = {
        -- Box
        T = Drawing.new("Line");
        B = Drawing.new("Line");
        L = Drawing.new("Line");
        R = Drawing.new("Line");
        M = Drawing.new("Square");
        -- Bar
        T2 = Drawing.new("Line");
        L2 = Drawing.new("Line");
        R2 = Drawing.new("Line");
        B2 = Drawing.new("Line");
        M2 = Drawing.new("Square");
        -- Info
        TE = Drawing.new("Text");
        TE2 = Drawing.new("Text")
    }
    local texti = {
        [0] = "Interface";
        [1] = "Hooks";
        [2] = "Loops";
        [3] = "Commands"
    }
    local pos = Vector2.new(cam.ViewportSize.X / 2 - 150, cam.ViewportSize.Y / 2)
    local npos = pos + Vector2.new(20, 30)
    local i = 0

    for i2,v in pairs(drawingobjs) do
        if tostring(v) == "Line" then
            v.Thickness = 2
            v.Color = Color3.new()
            v.ZIndex = 1
        end

        if tostring(v) == "Square" then
            local em = i2 == "M"

            v.Color = em and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(22, 120, 19)
            v.Transparency = em and .5 or 1
            v.Size = em and Vector2.new(300, 100) or Vector2.new(0, 40)
            v.Position = em and pos or npos
            v.Filled = true
        end

        if tostring(v) == "Text" then
            local e2 = i2 == "TE2"

            v.Size = e2 and 18 or 22
            v.Color = e2 and Color3.new(1,1,1) or Color3.fromRGB(22, 120, 19)
            v.Center = true
            v.Outline = true
            v.Position = pos + Vector2.new(150, e2 and 75 or 5)
            v.Text = e2 and "Functions" or "Athena Client"
        end

        v.Visible = not isv2
    end

    drawingobjs.T.From = pos
    drawingobjs.B.From = pos + Vector2.new(0, 100)
    drawingobjs.L.From = pos
    drawingobjs.R.From = pos + Vector2.new(300, 0)

    drawingobjs.T.To = pos + Vector2.new(300, 0)
    drawingobjs.B.To = pos + Vector2.new(300, 100)
    drawingobjs.L.To = pos + Vector2.new(0, 100)
    drawingobjs.R.To = pos + Vector2.new(300, 100)

    task.wait(1)

    function LoaderUpdate()
        if isv2 then return end

        local lposx, oposx = (260 / 3) * i, drawingobjs.M2.Size.X
        drawingobjs.TE2.Text = texti[i]

        task.spawn(function()
            for i2 = 0, 1, .01 do
                local nlposx = Lerp(oposx, lposx, Ease(i2))

                drawingobjs.T2.From = npos
                drawingobjs.B2.From = npos + Vector2.new(0, 40)
                drawingobjs.L2.From = npos
                drawingobjs.R2.From = npos + Vector2.new(nlposx, 0)

                drawingobjs.T2.To = npos + Vector2.new(nlposx, 0)
                drawingobjs.B2.To = npos + Vector2.new(nlposx, 40)
                drawingobjs.L2.To = npos + Vector2.new(0, 40)
                drawingobjs.R2.To = npos + Vector2.new(nlposx, 40)

                drawingobjs.M2.Size = Vector2.new(nlposx, 40)
                task.wait()
            end
        end)

        i += 1
    end
end

local Note do
    local notes = {}
    local t = Drawing.new("Text")

    local function GetTextSize(msg, size, font)
        t.Font = font
        t.Size = size
        t.Text = msg

        return t.TextBounds
    end

    local function NoteWrapper(msg, err)
        local drawingobjs = {
            T = Drawing.new("Line");
            B = Drawing.new("Line");
            L = Drawing.new("Line");
            R = Drawing.new("Line");
            ML = Drawing.new("Line");
            H = Drawing.new("Square");
            M = Drawing.new("Square");
            TE = Drawing.new("Text");
            IUp = 0
        }

        notes[#notes+1] = drawingobjs
        local inote = #notes - 1

        local textlen = GetTextSize(msg, 20, Drawing.Fonts.UI) + Vector2.new(8, 0)

        for i,v in pairs(drawingobjs) do
            if type(v) == "number" then continue end

            if tostring(v) == "Line" then
                v.Thickness = 2
                v.Color = Color3.new()
                v.ZIndex = 1
            end

            if tostring(v) == "Square" then
                local ih = i == "H"

                v.Color = ih and (err and Color3.new(.7, 0, 0) or Color3.fromRGB(22, 120, 19)) or Color3.new(.2, .2, .2)
                v.Size = ih and Vector2.new(15, 30) or Vector2.new(0, 30)
                v.Filled = true
            end

            v.Visible = true
        end

        local spos = Vector2.new(-textlen.X - 37, cam.ViewportSize.Y - 105 - ((inote - 1) * 45))

        drawingobjs.T.From = spos
        drawingobjs.B.From = spos + Vector2.new(0, 30)
        drawingobjs.L.From = spos
        drawingobjs.R.From = spos + Vector2.new(15, 0)

        drawingobjs.T.To = spos + Vector2.new(15, 0)
        drawingobjs.B.To = spos + Vector2.new(15, 30)
        drawingobjs.L.To = spos + Vector2.new(0, 30)
        drawingobjs.R.To = spos + Vector2.new(15, 30)

        drawingobjs.ML.From = spos + Vector2.new(15, 0)
        drawingobjs.ML.To = spos + Vector2.new(15, 30)

        drawingobjs.H.Position = spos
        drawingobjs.H.Filled = true

        drawingobjs.M.Position = spos + Vector2.new(16)

        drawingobjs.TE.Text = msg
        drawingobjs.TE.Outline = true
        drawingobjs.TE.Size = 20
        drawingobjs.TE.Position = spos + Vector2.new(20, 4)
        drawingobjs.TE.Color = Color3.new(1,1,1)
        drawingobjs.TE.Font = Drawing.Fonts.UI
        drawingobjs.TE.Transparency = 0

        local r = {}

        for i,v in next, drawingobjs do
            if type(v) == "number" then continue end

            r[i] = {type = tostring(v)}

            if r[i].type == "Line" then
                r[i].To = v.To
                r[i].From = v.From

                continue
            end

            r[i].Position = v.Position
        end

        for i = 0, 1, .005 do
            for _,v in next, drawingobjs do
                if type(v) == "number" then continue end

                if tostring(v) == "Line" then
                    v.From = Vector2.new(r[_].From.X + Lerp(spos.X, textlen.X + 57, Ease(i)), v.From.Y)
                    v.To = Vector2.new(r[_].To.X + Lerp(spos.X, textlen.X + 57, Ease(i)), v.To.Y)

                    continue
                end

                v.Position = Vector2.new(r[_].Position.X + Lerp(spos.X, textlen.X + 57, Ease(i)), spos.Y + (_ == "TE" and 3 or 0))
            end

            task.wait()
        end

        task.wait(.5)

        spos = Vector2.new(20, cam.ViewportSize.Y - 105 - ((inote - 1) * 45))

        for i = 0, 1, .008 do
            local pos = Lerp(15, 2 + textlen.X, Ease(i))

            drawingobjs.B.To = spos + Vector2.new(15 + pos, 30)
            drawingobjs.T.To = spos + Vector2.new(15 + pos)

            drawingobjs.R.From = spos + Vector2.new(15 + pos)
            drawingobjs.R.To = spos + Vector2.new(15 + pos, 30)

            drawingobjs.M.Size = Vector2.new(pos, 30)

            task.wait()
        end

        for i = 0, 1, .01 do
            drawingobjs.TE.Transparency = i
            task.wait()
        end

        drawingobjs.IUp = 1

        task.wait(8)

        for i = 1, 0, -.01 do
            for _,v in next, drawingobjs do
                if type(v) == "number" then continue end

                v.Transparency = i
            end

            task.wait()
        end

        table.remove(notes, table.find(notes, drawingobjs))
    end

    function Note(...)
        if isv2 then return end
        return task.defer(NoteWrapper, ...)
    end
end

local MessageBox do
    function MessageBox(title, info)
        local event = Instance.new("BindableEvent")

        local Confirm = Instance.new("Frame")
        local b = Instance.new("UIStroke")
        local a = Instance.new("UICorner")
        local Label = Instance.new("TextLabel")
        local Info = Instance.new("TextLabel")
        local Accept = Instance.new("TextButton")
        local a_2 = Instance.new("UICorner")
        local Decline = Instance.new("TextButton")
        local a_3 = Instance.new("UICorner")

        Confirm.Name = "Confirm"
        Confirm.Parent = ChatLogs
        Confirm.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
        Confirm.BorderColor3 = Color3.fromRGB(40, 40, 40)
        Confirm.Position = UDim2.new(0.5, -175, 0.5, -75)
        Confirm.Size = UDim2.new(0, 350, 0, 150)

        a.CornerRadius = UDim.new(0, 2)
        a.Name = "a"
        a.Parent = Confirm

        b.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        b.Color = Color3.fromRGB(40, 40, 40)
        b.LineJoinMode = Enum.LineJoinMode.Round
        b.Thickness = 2
        b.Transparency = 0
        b.Enabled = true
        b.Name = "b"
        b.Parent = Confirm

        Label.Name = "Label"
        Label.Parent = Confirm
        Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Label.BackgroundTransparency = 1.000
        Label.Position = UDim2.new(0.0285714287, 0, 0.0666666701, 0)
        Label.Size = UDim2.new(0, 330, 0, 27)
        Label.Font = Enum.Font.SourceSans
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 20.000
        Label.Text = title

        Info.Name = "Info"
        Info.Parent = Confirm
        Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Info.BackgroundTransparency = 1.000
        Info.Position = UDim2.new(0.0285714287, 0, 0.286666662, 0)
        Info.Size = UDim2.new(0, 330, 0, 35)
        Info.Font = Enum.Font.SourceSans
        Info.Text = info
        Info.TextColor3 = Color3.fromRGB(255, 255, 255)
        Info.TextSize = 17.000
        Info.TextYAlignment = Enum.TextYAlignment.Top

        Accept.Name = "Accept"
        Accept.Parent = Confirm
        Accept.BackgroundColor3 = Color3.fromRGB(49, 218, 46)
        Accept.BackgroundTransparency = 0.320
        Accept.Position = UDim2.new(0.0571428575, 0, 0.706666648, 0)
        Accept.Size = UDim2.new(0, 135, 0, 24)
        Accept.AutoButtonColor = false
        Accept.Font = Enum.Font.SourceSans
        Accept.Text = "Accept"
        Accept.TextColor3 = Color3.fromRGB(255, 255, 255)
        Accept.TextSize = 21.000

        a_2.CornerRadius = UDim.new(0, 2)
        a_2.Name = "a"
        a_2.Parent = Accept

        Decline.Name = "Decline"
        Decline.Parent = Confirm
        Decline.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Decline.Position = UDim2.new(0.557142854, 0, 0.706666648, 0)
        Decline.Size = UDim2.new(0, 135, 0, 24)
        Decline.AutoButtonColor = false
        Decline.Font = Enum.Font.SourceSans
        Decline.Text = "Decline"
        Decline.TextColor3 = Color3.fromRGB(255, 255, 255)
        Decline.TextSize = 18.000

        a_3.CornerRadius = UDim.new(0, 2)
        a_3.Name = "a"
        a_3.Parent = Decline

        Decline.MouseButton1Up:Connect(function() 
            event:Fire()
        end)

        Accept.MouseButton1Up:Connect(function() 
            event:Fire(true)
        end)

        event.Event:Once(function()
            Confirm:Destroy()
        end)

        return event.Event:Wait()
    end
end

-- String functions

local function GetPlayer(a)
    if not a then return end

    if type(a) == "string" then
        a = a:lower()

        for i,v in pairs(sv.Players.GetPlayers(sv.Players)) do
            if v.Name:lower():match("^"..a) or v.DisplayName:lower():match("^"..a) then
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

local function GetBool(a)
    if not a then return true end
    return table.find({"on", "true", "1"}, a:lower()) and true or false
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

local function GetPing()
    return sv.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
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

local function Goto(pos)
    if not lp.Character then return end

    workspace:WaitForChild(lp.Name):PivotTo(pos)
    local tw = select(2, pcall(sv.TweenService.Create, sv.TweenService,  lp.Character:FindFirstChild("HumanoidRootPart") or lp.Character:FindFirstChild("Torso"), TweenInfo.new(0), {CFrame = pos}))
    pcall(tw.Play, tw)
end

local function GetGun(order)
    lp:WaitForChild("Backpack")

    for i,v in pairs(order) do
        if v == "None" then continue end
        if v == "M4A1" and not HasM4 then v = "AK-47" end
        if table.find({"Crude Knife", "Hammer"}, v) and lp.Team == sv.Teams.Guards then
            remotes.Team:FireServer("Medium stone grey")
            lp.Backpack.ChildAdded:Once(function()
                remotes.Team:FireServer("Bright blue")
            end)
        end
        if v == "Riot Shield" and lp.Team ~= sv.Teams.Guards then
            local otc = lp.TeamColor
            local switch = lp.Team ~= nil and lp.Team ~= sv.Teams.Criminals and #sv.Teams.Guards:GetPlayers() < 8 and HasM4
            if not switch then continue end

            remotes.Team:FireServer("Bright blue")
            lp.Backpack.ChildAdded:Once(function()
                remotes.Team:FireServer(otc.Name)
            end)
        end

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

    if Color == BrickColor.new("Medium stone grey").Color then
        Color = BrickColor.new("Bright orange").Color

        lp.CharacterAdded:Once(function()
            task.wait(.05)
            remotes.Team:FireServer("Medium stone grey")
        end)
    end

    task.spawn(function()
        pcall(remotes.Load.InvokeServer, remotes.Load, lp, Color)
        workspace:WaitForChild(lp.Name):PivotTo(Saved1)
    end)

    lp.CharacterAdded:Wait()
    lp.Character:PivotTo(Saved1)
    workspace:WaitForChild(lp.Name):PivotTo(Saved1)
    task.wait(1/30)
    cam.CFrame = Saved2

    if Saved1.Y < 0 then
        Goto(positions["Nexus"])
    end

    task.delay(.2, function()
        if lp:DistanceFromCharacter(Saved1.p) > 10 or (Saved1.Z == 0 and Saved1.X == 0) then
            Goto(Saved1)
        end
    end)
end

function Team(Color)
    if table.find({"Bright orange", "Medium stone grey", "Bright yellow", "Bright blue"}, Color) then
        remotes.Team:FireServer(Color)
        return
    end

    if Color == "Bright red" then
        if lp.Team == sv.Teams.Guards then
            Team("Bright orange")
        end

        firetouchinterest(game.SpawnLocation, lp.Character.Torso, ffalse)

        return
    end

    Respawn(BrickColor.new(Color))
end

local function AddPlayer(plr)
    local ToAdd, con = {}

    ToAdd.Name = Drawing.new("Text")
    ToAdd.Name.Center = true
    ToAdd.Name.Outline = true
    ToAdd.Name.Text = trusted[plr.UserId] and ("%s\n[%s]"):format(plr.Name, trusted[plr.UserId]) or plr.Name
    ToAdd.Name.Size = 19
    ToAdd.Name.Font = Drawing.Fonts.UI

    ToAdd.Info = Drawing.new("Text")
    ToAdd.Info.Center = true
    ToAdd.Info.Outline = true
    ToAdd.Info.Text = ""
    ToAdd.Info.Size = 17
    ToAdd.Info.Font = Drawing.Fonts.UI
    ToAdd.Info.Color = Color3.new(.8, .8, .8)

    PlayerESPDrawings[plr.Name] = ToAdd

    con = game.Players.PlayerRemoving:Connect(function(player)
        if player ~= plr then return end

        PlayerESPDrawings[plr.Name] = nil
        con:Disconnect()
    end)
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
    c:WaitForChild"Humanoid".Name = 1
    local cl = c["1"]:Clone()
    cl.Name = "Humanoid"
    cl.Parent = c
    task.wait(.02)
    c["1"]:Destroy()
    pcall(function()
        c.Animate.Disabled = true
    end)
    cam.CameraSubject = cl
end

local function Kill(tru, weapon)
    local args = {}
    local oc = lp.TeamColor
    local gun = weapon or (function() -- lmao
        GetGun{togs.KillGun}
        return lp.Backpack:FindFirstChild(togs.KillGun) or lp.Character:FindFirstChild(togs.KillGun) or lp.Backpack:WaitFirstChild(togs.KillGun, 60)
    end)()

    for i,v in pairs(tru) do
        if v ~= lp and not table.find(togs.Whitelist, v.Name) and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 then
            if v.TeamColor == lp.TeamColor then
                Team(lp.Team ~= nil and (v.TeamColor.Name ~= "Medium stone grey" and "Medium stone grey" or v.TeamColor == "Medium stone grey" and "Bright orange") or BrickColor.random().Name)
                GetGun{togs.KillGun}
                gun = lp.Backpack:FindFirstChild(togs.KillGun) or lp.Character:FindFirstChild(togs.KillGun) or lp.Backpack:WaitFirstChild(togs.KillGun, 60)
            end
            
            if lp.Team == sv.Teams.Guards and v.Status.isHostile.Value == false then
                workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isHostile})
            end

            for i = 1, math.ceil(v.Character.Humanoid.Health / (require(gun.GunStates)).Damage * 1.5) do
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

    if oc ~= lp.TeamColor then
        Team(oc.Name)
    end
end

local function MeleeKill(tbl)
    for i,v in pairs(tbl) do
        if lp.Team == sv.Teams.Guards and v.Status.isHostile.Value == false then
            workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isHostile})
        end

        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and lp:DistanceFromCharacter(v.Character:GetPivot().p) < 10 then
            for i = 1, math.ceil(v.Character.Humanoid.Health / 24) do
                remotes.Melee:FireServer(v, tools["Crude Knife"].Parent)
            end
        end
    end
end

local function Delay(amount)
    amount *= 100
    remotes.Load:InvokeServer(tools.M9)
    local tool = lp.Backpack:WaitForChild"M9"
    sv.ReplicatedStorage.EquipEvent:FireServer(tool)
    for i = 1, amount do
        remotes.Shoot:FireServer({}, tool)
    end
end

local OnCharacterAdded do
    local function AOnCharacterAdded(char)
        task.wait()

        local hum, cons, char = char:WaitForChild("Humanoid"), {}, lp.Character or lp.CharacterAdded:Wait()

        if togs.GGS then
            task.wait(GetPing())
            local op = lp.Character:GetPivot()
            workspace:WaitForChild(lp.Name)
            Goto(op)
            task.wait(GetPing() * 1.5)
            lp.Character:BreakJoints()
            Respawn(nil, op)

            return
        end

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
            task.wait(.01)
            CloneHumanoid()
            hum = char:WaitForChild("Humanoid")
            task.delay(5 - GetPing(), function()
                local op = char:GetPivot()
                if lp.Character ~= char then return end
                Respawn(nil, op)
            end)
        end

        if togs.AutoRespawn.ForceField then
            Team("Medium stone grey")
            
            local thing; thing = char.ChildRemoved:Connect(function(part)
                if part:IsA("ForceField") then
                    thing:Disconnect()
                    Respawn(togs.AutoRespawn.GFF and BrickColor.new("Bright blue") or BrickColor.new("Really red"))
                end
            end)
        end

        coroutine.wrap(function()
            local bap = lp:WaitForChild("Backpack")

            cons['3'] = bap.ChildAdded:Connect(function(item)
                table.insert(allowedtools, item)
                local a = table.find({"AK-47", "M4A1", "M9", "Remington 870", "Taser"}, item.Name) and item:FindFirstChild("GunStates")

                if a and togs.GunMods.Toggled then
                    local mod = require(a)
                    mod.AutoFire = togs.GunMods.Automatic or mod.AutoFire
                    mod.FireRate = togs.GunMods.CustomFireate and togs.GunMods.FireRate or mod.FireRate
                    mod.Range = togs.GunMods.CustomRange and togs.GunMods.Range or mod.Range
                end
            end)

            cons["t"] = char.ChildAdded:Connect(function(item)
                if not togs.AntiBring then return end

                task.spawn(Anchorage, .001)
                if not table.find(allowedtools, item) and item.ClassName == "Tool" then
                    task.defer(item.Destroy, item)
                    task.spawn(Anchorage, .1)
                    pcall(item.Destroy, item)

                    if togs.NHA then
                        CloneHumanoid()
                        task.delay(.5, Respawn, nil, lp.Character:GetPivot())
                    end
                end
            end)

            for i,v in pairs(bap:GetChildren()) do
                table.insert(allowedtools, v)
            end

            if togs.GunSpawn then
                GetGun(togs.GunOrder)
            end
        end)()

        cons['h'] = hum.Died:Connect(function()
            if togs.Godmode or togs.AutoRespawn.ForceField then return end

            table.foreach(cons, function(_,v) 
                pcall(v.Disconnect, v)
            end)

            if togs.AutoRespawn.Toggled then
                local tool = char:FindFirstChildOfClass("Tool")
                local isgun = table.find({"M4A1", "M9", "AK-47", "Remington 870"}, tool and tool.Name or "")
                Respawn(nil, char:GetPivot())

                if togs.AutoRespawn.EquipOldWeapon then
                    local newtool = isgun and tool.Name
                    if newtool then
                        pcall(function()
                            GetGun(togs.GunOrder)
                            local item = lp.Backpack:WaitForChild(newtool, 10)
                            item.Parent = lp.Character
                        end)
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

            cons['l'] = sv.RunService.RenderStepped:Connect(function()
                pcall(function()
                    if togs.FastPunch then
                        cs.isRunning = false
                        cs.isFighting = false
                    end
                end)
            end)
        end)

        cons['m'] = char:WaitForChild("Head").ChildAdded:Connect(function(a)
            if a:IsA("BillboardGui") then
                task.defer(a.Destroy, a)
            end
        end)

        cons['p'] = char:WaitForChild("Torso").Touched:Connect(function(thing)
            local model = thing and thing:FindFirstAncestorOfClass("Model")
            local tplr = model and sv.Players:FindFirstChild(model.Name)

            if tplr and not table.find(togs.Whitelist, tplr.Name) and togs.AntiTouch then
                MeleeKill({tplr})
            end
        end)

        cons['v'] = char:WaitForChild("Humanoid").Seated:Connect(function()
            if not togs.AntiSit then return end

            char.Humanoid.Sit = false
        end)
    end

    function OnCharacterAdded(...)
        AOnCharacterAdded(...)
    end
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

local function Bring(plr, tool, cframe, second) -- thanks fate for teaching me the humanoid cloning & deletion (ive never touched it before) (should probably be noted on the clonehumanoid func)
    if not lp.Character or not plr or not plr.Character or not plr.Character.PrimaryPart or not plr.Character:FindFirstChild("Humanoid") or not tool or not cframe then return end
    if plr.Character.Humanoid.Sit then
        Kill{plr}
        repeat until not task.wait() or plr.Character
    end

    local saved, oldnc = lp.Character:GetPivot(), togs.Noclip
    togs.Noclip = false
    CloneHumanoid()
    tool.Parent = lp.Character
    Goto(cframe)

    if lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.Anchored = true
    end

    task.spawn(pcall, firetouchinterest, tool:FindFirstChild("Handle"), plr.Character.PrimaryPart, ffalse)
    tool.AncestryChanged:Once(function()
        for i = 1, 3 do
            task.wait(GetPing() / 4)
            lp.Character:PivotTo(lp.Character:GetPivot() * CFrame.Angles(math.rad(-20), 0, 0))
        end
    end)

    task.wait(math.clamp((second or 0) + (GetPing() * 2), 0, 4.5))
    togs.Noclip = oldnc
    Respawn(nil, saved)
end

local function Crim(plr, sec)
    if not plr or not plr.Character or not lp.Character then return end
    local pad, oldpos, oldnt, oldac = game.SpawnLocation, lp.Character:GetPivot(), togs.Noclip, togs.AntiCriminal
    togs.Noclip = false
    togs.AntiCriminal = false

    GetGun{togs.BringTool}
    local tool = lp.Backpack:WaitForChild(togs.BringTool)
    CloneHumanoid()
    tool.Parent = lp.Character
    task.wait(math.clamp(sec or 0, 0, 4.5))
    pad.CanCollide = false

    if not lp.Character or not plr.Character or not plr.Character.PrimaryPart or tool.Parent ~= lp.Character or plr.Team == sv.Teams.Criminals then
        togs.Noclip = oldnt
        Respawn(nil, oldpos)
    end

    for i = 1, 2 do
        if plr.Team == sv.Teams.Criminals then break end

        task.spawn(pcall, firetouchinterest, tool:FindFirstChild("Handle"), plr.Character.PrimaryPart, ffalse)
        task.defer(pcall, firetouchinterest, pad, plr.Character.PrimaryPart, ffalse)
        coroutine.wrap(Goto)(oldpos * CFrame.Angles(math.rad(90), 0, 0))
        task.wait(GetPing())
    end

    if plr.Team ~= sv.Teams.Criminals then
        lp.Character:PivotTo(lp.Character:GetPivot() * CFrame.Angles(math.rad(90), 0, 0))
        task.spawn(pcall, firetouchinterest, tool:FindFirstChild("Handle"), plr.Character.PrimaryPart, ffalse)
        task.defer(pcall, firetouchinterest, pad, plr.Character.PrimaryPart, ffalse)
        task.wait(GetPing() + .1)
    end

    togs.Noclip = oldnt
    togs.AntiCriminal = oldac
    Respawn(nil, oldpos)
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
    local cons = {}

    if viewing == plr then
        cam.CameraSubject = char
    end

    cons['g'] = char.AncestryChanged:Connect(function(a, parent)
        if parent == nil then
            task.wait(5)

            if char.Parent == nil then
                table.foreach(cons, function(_,v)
                    pcall(v.Disconnect, v)
                end)
            end
        end
    end)

    task.spawn(function()
        cons['a'] = char:WaitForChild("Head").ChildAdded:Connect(function(gui)
            task.wait()
            if not togs.AntiCrash or not gui:IsA("BillboardGui") or not char:FindFirstChild("Head") or #char.Head:GetChildren() < 10 then return end

            gui:Destroy()
        end)

        cons['b'] = char:WaitForChild("Torso").Touched:Connect(function(thing)
            if tick() - tt < .2 or not table.find(givenantitouch, plr.Name) then return end
            tt = tick()

            local model = thing and thing:FindFirstAncestorOfClass("Model")
            local tplr = model and sv.Players:FindFirstChild(model.Name)

            if tplr and not table.find({plr, lp}, tplr) and not table.find(togs.Whitelist, tplr.Name) then
                Kill{tplr}
            end
        end)

        cons['f'] = char:WaitForChild("Humanoid").Died:Connect(function()
            table.foreach(cons, function(_,v)
                pcall(v.Disconnect, v)
            end)
        end)
    end)

    cons['c'] = char:WaitForChild("Humanoid").AnimationPlayed:Connect(function(an)
        if not table.find({"rbxassetid://484926359", "rbxassetid://484200742", "rbxassetid://275012308"}, an.Animation.AnimationId) then return end
        local pos = char:GetPivot()
        local base = workspace:FindPartOnRay(Ray.new(pos.p, pos.LookVector * 5), char)

        if base and base:FindFirstAncestorOfClass("Model") and base:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
            local hitplr = sv.Players:GetPlayerFromCharacter(base.Parent)
            if hitplr and table.find(givenantipunch, hitplr.Name) or (hitplr == lp and togs.AntiPunch) then
                (hitplr == lp and MeleeKill or Kill){plr}
            end
        end
    end)

    cons['d'] = char.ChildRemoved:Connect(function(part)
        if part.Name == "Humanoid" and char.Parent ~= nil then
            cons['D'] = char.ChildAdded:Connect(function(t)
                if not t:IsA("Tool") then return end
            
                if togs.HardendAntiBring then
                    char:Destroy()
                    local op, ti = lp.Character:GetPivot(), tick()
                    sv.Debris:AddItem(lp.Character, 0)
                    repeat task.wait() until tick() - ti > 5 - GetPing() or char.Parent == nil
                    Respawn(nil, op)

                    return
                end

                if togs.TrollGodded then
                    if not t:IsA("Tool") then return end
                    firetouchinterest(t.Handle, lp.Character.PrimaryPart, ffalse)
                end
            end)
            
            if togs.HardendAntiBring and char:FindFirstChildOfClass("Tool") then
                char:ClearAllChildren()
                local op, t = lp.Character:GetPivot(), tick()
                sv.Debris:AddItem(lp.Character, 0)
                repeat task.wait() until tick() - t > 5 - GetPing() or char.Parent == nil
                Respawn(nil, op)
            end
        end
    end)

    cons['e'] = char.DescendantAdded:Connect(function(part)
        task.wait()
        if togs.AntiCrash and part:IsA("Weld") and part.Parent and #part.Parent:GetChildren() > 300 then
            part.Parent:Destroy()

            if not weldcrash then
                Note(("%s is trying to weld crash!"):format(plr.Name))
            end

            if togs.AntiBring then
                local op = lp.Character:GetPivot()
                sv.Debris:AddItem(lp.Character, 0)
                task.delay(.5, Respawn, nil, op)
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
    local cons, weldcrash = {}

    if trusted[plr.UserId] then
        Note(("%s (%s) is in your game!"):format(plr.Name, trusted[plr.UserId]))
    end

    if plr:IsFriendsWith(lp.UserId) then
        if not table.find(togs.Whitelist, plr.Name) then
            table.insert(togs.Whitelist, plr.Name)
        end

        Note(("Friend %s has been added to whitelist!"):format(plr.Name))
    end

    cons['a'] = plr.ChildAdded:Connect(function(thing)
        if thing.Name == "Backpack" then
            if cons['b'] then
                cons['b']:Disconnect()
            end

            cons['b'] = thing.DescendantAdded:Connect(function(part)
                if togs.AntiCrash and part:IsA("Weld") and part.Parent and #part.Parent:GetChildren() > 300 then
                    part.Parent:Destroy()

                    if not weldcrash then
                        Note(("%s is trying to weld crash!"):format(plr.Name))
                    end

                    if togs.AntiBring then
                        local op = lp.Character:GetPivot()
                        sv.Debris:AddItem(lp.Character, 0)
                        task.delay(2, Respawn, nil, op)
                    end

                    weldcrash = true
                end

                if part:IsA("Tool") then
                    pcall(function()
                        local con; con = part:WaitForChild("Handle", 5).Touched:Connect(function(bpart)
                            if not bpart or not bpart:IsDescendantOf(lp.Character) or tostring(part.Parent) ~= lp.Name or not plr.Character or not bpart.Name == "HumanoidRootPart" then return end

                            Note(("%s tried to bring you!"):format(plr.Name))
                        end)

                        local con2; con2 = part.AncestryChanged:Connect(function(a, parent)
                            if parent ~= nil then return end

                            con:Disconnect()
                            con2:Disconnect()
                        end)
                    end)
                end
            end)
        end
    end)

    cons['c'] = plr.CharacterAdded:Connect(function() -- CharacterAppearanceLoaded
        PlayerCharacterAdded(plr)
    end)

    cons['d'] = plr.AncestryChanged:Connect(function()
        table.foreach(cons, function(_, a)
            pcall(a.Disconnect, a)
        end)
    end)
end

local function SpamArrest(plr, power, d)
    if not plr or not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health == 0 or not plr.Character:FindFirstChild("Head") then return end
    assert(lp.Character:FindFirstChild("HumanoidRootPart"), "no hrp?")
    local pad, oldpos, oldnt, arrests, starttick, broken = game.SpawnLocation, lp.Character:GetPivot(), togs.Noclip, 0, tick()

    local function Arrest()
        if not d and (not CanBeArrested(plr)) then return end

        if remotes.Arrest:InvokeServer(plr.Character.Head) == true then
            arrests += 1
        end
    end

    for i = 0, 5 do
        if CanBeArrested(plr) then break end

        Crim(plr)
    end

    while task.wait() and not broken do
        if not CanBeArrested(plr) and plr.Team == sv.Teams.Inmates then break end
        local c, finished = plr.Character

        task.spawn(function() 
            while not finished and task.wait() do
                if breaksa then
                    broken = true
                    Note(("Arrested with: %i arrests"):format(arrests))
                    Note(("Arrested in: %.02f seconds"):format(tick() - starttick))

                    break
                end

                if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Head") then
                    for i = 0, power do
                        coroutine.wrap(lp.Character.PivotTo)(lp.Character, plr.Character:GetPivot() + plr.Character:GetPivot().LookVector * -2)
                        task.defer(coroutine.wrap(Arrest))
                    end
                end
            end
        end)

        GetGun{togs.BringTool}
        local tool = lp.Backpack:WaitForChild(togs.BringTool)
        if d then
            if d == 1 then
                for i = 1, 300 do
                    remotes.Weld:FireServer(tool)
                end
            else
                Delay(.5)
            end
        end
        CloneHumanoid()
        tool.Parent = lp.Character
        pad.CanCollide = false
        local c = plr.Character

        if not lp.Character or not plr.Character or not plr.Character.PrimaryPart or tool.Parent ~= lp.Character then
            togs.Noclip = oldnt
            Respawn(nil, plr.Character:GetPivot())
        end

        task.spawn(pcall, firetouchinterest, tool:FindFirstChild("Handle"), plr.Character.PrimaryPart, ffalse)
        task.defer(pcall, firetouchinterest, pad, plr.Character.PrimaryPart, ffalse)

        local t = tick()
        repeat
            task.wait()
            task.spawn(pcall, firetouchinterest, pad, plr.Character.PrimaryPart, ffalse)
        until tick() - t > 1 or (not d and not CanBeArrested(plr) and plr.Team == sv.Teams.Inmates) or broken or c ~= plr.Character

        Respawn(nil, lp.Character:GetPivot())
        finished = true
    end

    togs.Noclip = oldnt
    Respawn(nil, oldpos)
end

function CrashSA(plr, d)
    if not plr or not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health == 0 or not plr.Character:FindFirstChild("Head") then return end

    if d then
       Delay(d)
    end

    Goto(plr.Character:GetPivot())
    repeat
        Crim(plr)
    until CanBeArrested(plr)

    for i = 1, 100 do
        coroutine.wrap(function()
            for i = 1, 1000 do
                if i % 200 == 0 then task.wait() end
                coroutine.wrap(lp.Character.PivotTo)(lp.Character, plr.Character:GetPivot())
                coroutine.wrap(remotes.Arrest.InvokeServer)(remotes.Arrest, plr.Character.Head)
            end
        end)()
    end
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

local commands, AddCommand, ChangeAdminPerms, HandleMessage, CommandBar = {} do
    local ToggleCommandList do
        local CommandsList = Instance.new("Frame")
        local a = Instance.new("UICorner")
        local List = Instance.new("ScrollingFrame")
        local b = Instance.new("UIStroke")
        local c = Instance.new("UIGridLayout")
        local d = Instance.new("UIPadding")

        CommandsList.Name = "CommandsList"
        CommandsList.Parent = ChatLogs
        CommandsList.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
        CommandsList.BorderColor3 = Color3.fromRGB(40, 40, 40)
        CommandsList.Position = UDim2.new(1, -269, 1, -81) + UDim2.new(0, 0, 0, -179)
        CommandsList.Size = UDim2.new(0, 179, 0, 169)
        CommandsList.Visible = false

        a.CornerRadius = UDim.new(0, 2)
        a.Name = "a"
        a.Parent = CommandsList

        List.Name = "List"
        List.Parent = CommandsList
        List.Active = true
        List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        List.BackgroundTransparency = 1.000
        List.Size = UDim2.new(0, 179, 0, 169)
        List.ScrollBarThickness = 0
        List.CanvasSize = UDim2.new(0, 0, 0, 6)

        b.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        b.Color = Color3.fromRGB(40, 40, 40)
        b.LineJoinMode = Enum.LineJoinMode.Round
        b.Thickness = 2
        b.Transparency = 0
        b.Enabled = true
        b.Name = "b"
        b.Parent = CommandsList

        c.Name = "c"
        c.Parent = List
        c.SortOrder = Enum.SortOrder.LayoutOrder
        c.CellPadding = UDim2.new(0, 5, 0, 3)
        c.CellSize = UDim2.new(1, 0, 0, 30)

        d.Name = "d"
        d.Parent = List
        d.PaddingBottom = UDim.new(0, 3)
        d.PaddingLeft = UDim.new(0, 3)
        d.PaddingRight = UDim.new(0, 3)
        d.PaddingTop = UDim.new(0, 3)

        List.ChildAdded:Connect(function()
            task.wait()
            List.CanvasSize += UDim2.new(0, 0, 0, 33)
        end)

        function ToggleCommandList()
            CommandsList.Visible = not CommandsList.Visible
        end

        function AddCommand(Command, Aliases, Info, RequiresArgs, IsUseableByOthers, Function)
            local Final = {}

            Final["Command"] = Command
            Final["Aliases"] = Aliases
            Final["Function"] = Function
            Final["RequiresArgs"] = RequiresArgs
            Final["IsUseableByOthers"] = IsUseableByOthers
            Final["Info"] = Info

            local Cmd = Instance.new("TextButton")

            Cmd.Name = "Cmd"
            Cmd.Parent = List
            Cmd.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
            Cmd.BorderColor3 = Color3.fromRGB(40, 40, 40)
            Cmd.BorderSizePixel = 2
            Cmd.Text = Command
            Cmd.Size = UDim2.new(0, 179, 0, 50)
            Cmd.Font = Enum.Font.SourceSans
            Cmd.TextColor3 = Color3.fromRGB(255, 255, 255)
            Cmd.TextSize = 16.000

            --[[local fstr = Info.."\nIs usable by others: "..tostring(IsUseableByOthers).."\nRequires arguments: "..tostring(RequiresArgs)
            if Aliases then
                fstr = fstr.."\nAliases: {"..(type(Aliases) == "table" and table.concat(Aliases, ", ") or Aliases).."}"
            end]]

            table.insert(commands, Final)
        end
    end

    do
        CommandBar = Instance.new("Frame")
        local Prefix = Instance.new("TextButton")
        local Commands = Instance.new("TextLabel")
        local a = Instance.new("UICorner")
        local b = Instance.new("UIStroke")
        local Bar = Instance.new("TextBox")
        local BBar = Instance.new("TextLabel")

        CommandBar.Name = "CommandBar"
        CommandBar.Parent = ChatLogs
        CommandBar.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
        CommandBar.BorderColor3 = Color3.fromRGB(40, 40, 40)
        CommandBar.BorderSizePixel = 2
        CommandBar.Position = UDim2.new(1, -269, 1, -81)
        CommandBar.Size = UDim2.new(0, 179, 0, 54)

        Prefix.Name = "Prefix"
        Prefix.Parent = CommandBar
        Prefix.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Prefix.BackgroundTransparency = 1.000
        Prefix.BorderColor3 = Color3.fromRGB(52, 52, 52)
        Prefix.Position = UDim2.new(0, 3, 0, 3)
        Prefix.Size = UDim2.new(0, 75, 0, 22)
        Prefix.Font = Enum.Font.SourceSans
        Prefix.Text = "Commands"
        Prefix.TextColor3 = Color3.fromRGB(255, 255, 255)
        Prefix.TextSize = 16.000

        Commands.Name = "Commands"
        Commands.Parent = CommandBar
        Commands.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Commands.BackgroundTransparency = 1.000
        Commands.BorderColor3 = Color3.fromRGB(52, 52, 52)
        Commands.Position = UDim2.new(0.726251543, -3, 0, 3)
        Commands.Size = UDim2.new(0, 49, 0, 22)
        Commands.Font = Enum.Font.SourceSans
        Commands.Text = "Prefix: "..togs.Admin.Prefix
        Commands.TextColor3 = Color3.fromRGB(255, 255, 255)
        Commands.TextSize = 16.000

        a.CornerRadius = UDim.new(0, 2)
        a.Name = "a"
        a.Parent = CommandBar

        b.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        b.Color = Color3.fromRGB(40, 40, 40)
        b.LineJoinMode = Enum.LineJoinMode.Round
        b.Thickness = 2
        b.Transparency = 0
        b.Enabled = true
        b.Name = "b"
        b.Parent = CommandBar

        Bar.Name = "Bar"
        Bar.Parent = CommandBar
        Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Bar.BackgroundTransparency = 1.000
        Bar.Position = UDim2.new(0.0167597774, 0, 0.462962955, 0)
        Bar.Size = UDim2.new(0, 176, 0, 29)
        Bar.Font = Enum.Font.SourceSans
        Bar.PlaceholderText = "Enter command here"
        Bar.Text = ""
        Bar.TextColor3 = Color3.fromRGB(255, 255, 255)
        Bar.TextSize = 16.000
        Bar.TextXAlignment = Enum.TextXAlignment.Left

        BBar.Name = "BBar"
        BBar.Parent = CommandBar
        BBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BBar.BackgroundTransparency = 1.000
        BBar.Position = UDim2.new(0.0167597774, 0, 0.462962955, 0)
        BBar.Size = UDim2.new(0, 176, 0, 29)
        BBar.Font = Enum.Font.SourceSans
        BBar.Text = ""
        BBar.TextColor3 = Color3.fromRGB(255, 255, 255)
        BBar.TextSize = 16.000
        BBar.TextXAlignment = Enum.TextXAlignment.Left

        Bar.FocusLost:Connect(function()
            HandleMessage(togs.Admin.Prefix..Bar.Text)
            BBar.Text = ""
            Bar.Text = ""
        end)

        Bar.Changed:Connect(function()
            local cmd = Bar.Text:split(" ")[1] or Bar.Text
            local cmdtodisplay = ""
            if #cmd < 2 then
                BBar.Text = ""

                return
            end

            for _, v in next, commands do
                if cmdtodisplay ~= "" then break end

                if v.Command:lower():match("^"..cmd:lower()) then
                    cmdtodisplay = v.Command

                    break
                end

                if (type(v.Aliases) == "string" and v.Aliases:lower():match("^"..cmd:lower())) then
                    
                    break
                end

                if type(v.Aliases) == "table" then
                    for _, alias in pairs(v.Aliases) do
                        if alias:lower():match("^"..cmd:lower()) then
                            cmdtodisplay = alias

                            break
                        end
                    end
                end
            end

            BBar.Text = cmd..cmdtodisplay:sub(#cmd + 1)
        end)

        sv.UserInputService.InputBegan:Connect(function(key, n)
            Commands.Text = "Prefix: "..togs.Admin.Prefix
            if n then return end

            if key.KeyCode == togs.Admin.FocusKey then
                task.defer(Bar.CaptureFocus, Bar)
            end
        end)

        Prefix.Activated:Connect(ToggleCommandList)
    end

    --[[
        AddCommand("print", {"cout"}, "Prints given arguments", true, false, function(args) print(unpack(args)) end)
    ]]

	function HandleMessage(msg, plr)
        if msg:sub(1, #togs.Admin.Prefix) ~= togs.Admin.Prefix then return end
        msg = msg:sub(#togs.Admin.Prefix + 1)

		if not plr or table.find(togs.Admin.Admins, plr) then
			local cmds = msg:split("&")

            for _, icmd in next, cmds do
                local args = icmd:split(" ")
                local cmd = args[1]
                table.remove(args, 1)

                for _, v in next, commands do
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
        local idmsg = {["ACC_IDENTIFIER"] = lp}
        local msg = {}

        table.foreach(TextBox.Text:reverse():split(""), function(_, v)
            msg["ACC_".._] = string.byte(v)
            idmsg["ACC_"..RandomString(math.random(4, 16))] = math.random(1, 73821) + math.random(0, 1)
        end)
        
        SendMsg({
            [1] = idmsg,
            [2] = msg
        })
    
        ChatLogAdd(lp, TextBox.Text, tick())

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
        local name = user.Name
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
    local ui =           loadstring(req({Url = "https://raw.githubusercontent.com/GFXTI/d/main/PianoUI.lua"}).Body)()
    local lib =          ui.new("Athena")

    -- Combat window
    do
        local combattop = lib.WindowTab("Combat")

        -- Gun mods
        do
            local combat = combattop.SideTab("Gun mods", 1000).Section("Gun mods")

            combat.Toggle("Toggled", togs.GunMods.Toggled, function(a)
                togs.GunMods.Toggled = a
            end)

            combat.Toggle("Automatic", togs.GunMods.Automatic, function(a)
                togs.GunMods.Automatic = a
            end)

            combat.Toggle("One shot guns", togs.GunMods.OneShotGuns, function(a)
                togs.GunMods.OneShotGuns = a
            end)

            combat.Toggle("Silent gun", togs.GunMods.SilentGun, function(a)
                togs.GunMods.SilentGun = a
            end)

            combat.Toggle("Invisible bullets", togs.GunMods.InvisBullets, function(a)
                togs.GunMods.InvisBullets = a
            end)

            combat.Toggle("Wallbang", togs.GunMods.Wallbang, function(a)
                togs.GunMods.Wallbang = a
            end)

            combat.Toggle("No spread", togs.GunMods.NoSpread, function(a)
                togs.GunMods.NoSpread = a
            end)

            combat.Toggle("Infinite ammo", togs.GunMods.InfiniteAmmo, function(a)
                togs.GunMods.InfiniteAmmo = a
            end)

            combat.Toggle("Custom firerate", togs.GunMods.CustomFireate, function(a)
                togs.GunMods.CustomFireate = a
            end)

            combat.Toggle("Custom range", togs.GunMods.CustomRange, function(a)
                togs.GunMods.CustomRange = a
            end)

            combat.Slider("Range", 0, 5000, togs.GunMods.Range, false, function(a)
                togs.GunMods.Range = a
            end)

            combat.Slider("Fire rate", 0, 1, togs.GunMods.FireRate, true, function(a)
                togs.GunMods.FireRate = a
            end)
        end

        -- Broken ass silent aim
        do
            local combat = combattop.SideTab("Silent aim", 1000).Section("Silent aim")

            combat.Toggle("Silent aim", togs.SilentAim.Toggled, function(a)
                togs.SilentAim.Toggled = a
            end)

            combat.Toggle("Show fov", togs.SilentAim.ShowFov, function(a)
                togs.SilentAim.ShowFov = a
            end)

            combat.Toggle("Dead check", togs.SilentAim.DeadCheck, function(a)
                togs.SilentAim.DeadCheck = a
            end)

            combat.Toggle("Wall check", togs.SilentAim.Wallcheck, function(a)
                togs.SilentAim.Wallcheck = a
            end)

            combat.Toggle("Hit torso", togs.SilentAim.HitPart == "Torso", function(a)
                togs.SilentAim.HitPart = a and "Torso" or "Head"
            end)

            combat.Toggle("Spread", togs.SilentAim.Spread, function(a)
                togs.SilentAim.Spread = a
            end)

            combat.Toggle("Punch", togs.SilentAim.Punch, function(a)
                togs.SilentAim.Punch = a
            end)

            combat.Slider("Range", 1, 5000, togs.SilentAim.Range, false, function(a)
                togs.SilentAim.Range = a
            end)

            combat.Slider("Radius", 1, 1000, togs.SilentAim.Radius, false, function(a)
                togs.SilentAim.Radius = a
            end)
        end

        -- Loopkill
        do
            local combat = combattop.SideTab("Loopkill", 1000).Section("Loopkill")

            combat.Toggle("Loopkill", togs.Loopkill.Toggled, function(a)
                togs.Loopkill.Toggled = a
            end)

            for i,v in next, {"Neutral", "Inmates", "Guards", "Criminals", "Custom"} do
                combat.Toggle(v, togs.Loopkill[v], function(a)
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
                                        Kill{v}
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
            local combat = combattop.SideTab("Killaura", 1000).Section("Killaura")

            combat.Toggle("Killaura", togs.Killaura.Toggled, function(a)
                togs.Killaura.Toggled = a
            end)

            for i,v in next, {"Neutral", "Inmates", "Guards", "Criminals", "Custom"} do
                combat.Toggle(v, togs.Killaura[v], function(a)
                    togs.Killaura[v] = a
                end)
            end
        end

        -- Colored Bullets
        do
            local combat = combattop.SideTab("CCB", 1000).Section("Custom colored bullets")

            combat.Toggle("Custom color bullets", togs.CCB.Toggled, function(a)
                togs.CCB.Toggled = a
            end)

            combat.Slider("R", 0, 255, togs.CCB.R, false, function(t)
                togs.CCB.R = t
            end)

            combat.Slider("G", 0, 255, togs.CCB.G, false, function(t)
                togs.CCB.G = t
            end)

            combat.Slider("B", 0, 255, togs.CCB.B, false, function(t)
                togs.CCB.B = t
            end)
        end

        local combat = combattop.SideTab("Toggles", 1000).Section("Toggles & Buttons")

        combat.Toggle("Tase aura", togs.TazeAura, function(a)
            togs.TazeAura = a
        end)

        combat.Toggle("Anti shield", togs.AntiShield, function(a)
            togs.AntiShield = a
        end)

        combat.Toggle("Fast punch", togs.FastPunch, function(a)
            togs.FastPunch = a
        end)

        combat.Toggle("Spam punch", togs.SpamPunch, function(a)
            togs.SpamPunch = a

            if a then
                while task.wait() and togs.SpamPunch do
                    if sv.UserInputService:IsKeyDown(Enum.KeyCode.F) and not sv.UserInputService:GetFocusedTextBox() and punchfunc then
                        coroutine.resume(coroutine.create(punchfunc))
                    end
                end
            end
        end)

        combat.Toggle("One punch", togs.OnePunch, function(a)
            togs.OnePunch = a
        end)

        combat.Toggle("Thorns", togs.Thorns, function(a)
            togs.Thorns = a
        end)

        combat.Toggle("Anti touch", togs.AntiTouch, function(a)
            togs.AntiTouch = a
        end)

        combat.Toggle("Anti punch", togs.AntiPunch, function(a)
            togs.AntiPunch = a
        end)

        combat.Toggle("Gun spawn", togs.GunSpawn, function(a)
            togs.GunSpawn = a
        end)

        combat.Button("Get swat items", function()
            if not HasM4 then Note("You must have the swat gamepass", true); return end

            local oldteam
            if lp.Team ~= sv.Teams.Guards then
                oldteam = lp.TeamColor.Name
                Respawn(BrickColor.new("Bright blue"))
            end

            remotes.Item:InvokeServer(workspace.Prison_ITEMS.clothes:FindFirstChild("Riot Police").ITEMPICKUP)
            GetGun{"Riot Shield"}

            Note("Given swat items")

            if oldteam then
                Team(oldteam)
            end
        end)

        combat.Button("Get guns", function()
            GetGun(togs.GunOrder)
            Note("Guns given")
        end)

        local guns = combattop.SideTab("Guns", 1000).Section("Gun slots")

        for i = 1, 7 do
            guns.Dropdown("Gun slot "..tostring(i), {"M4A1", "M9", "Remington 870", "AK-47", "Crude Knife", "Hammer", "Riot Shield", "None"}, function(a)
                togs.GunOrder[i] = a
            end)
        end
    end
    
    -- LocalPlayer Window
    do
        local playertop = lib.WindowTab("LocalPlayer")

        -- Auto Respawn
        do
            local player = playertop.SideTab("Auto respawn", 1000).Section("Auto respawn")

            player.Toggle("Auto respawn", togs.AutoRespawn.Toggled, function(a)
                togs.AutoRespawn.Toggled = a
            end)

            player.Toggle("Equip old weapon", togs.AutoRespawn.EquipOldWeapon, function(a)
                togs.AutoRespawn.EquipOldWeapon = a
            end)

            player.Toggle("Force field", togs.AutoRespawn.ForceField, function(a)
                togs.AutoRespawn.ForceField = a
            end)

            player.Toggle("Use guard", togs.AutoRespawn.GFF, function(a)
                togs.AutoRespawn.GFF = a
            end)

            player.Toggle("Respawn key", togs.AutoRespawn.Key, function(a)
                togs.AutoRespawn.Key = a
            end)
        end

        -- Fly
        do
            local player = playertop.SideTab("Fly", 1000).Section("Fly")

            player.Toggle("Fly", togs.Fly.Toggled, function(a)
                togs.Fly.Toggled = a
            end)

            player.Slider("Speed", .1, 100, togs.Fly.Speed, true, function(a)
                togs.Fly.Speed = a
            end)
        end

        -- Teams
        do
            local player = playertop.SideTab("Teams", 1000).Section("Teams")

            player.Slider("R", 0, 255, togs.CustomTeam.R, false, function(t)
                togs.CustomTeam.R = t
            end)

            player.Slider("G", 0, 255, togs.CustomTeam.G, false, function(t)
                togs.CustomTeam.G = t
            end)

            player.Slider("B", 0, 255, togs.CustomTeam.B, false, function(t)
                togs.CustomTeam.B = t
            end)

            player.Box("BrickColor name", "full name", function(a)
                if not table.find(brickcolors, a) then return end

                Respawn(BrickColor.new(a))
            end)

            player.Button("Custom team",  function()
                local color = BrickColor.new(Color3.fromRGB(togs.CustomTeam.R, togs.CustomTeam.G, togs.CustomTeam.B))
                Respawn(color)
                Note(("Changed to team %s"):format(color.Name))
            end)

            for i,v in next, {"Neutral", "Inmates", "Criminals"} do
                player.Button(v, function()
                    Team(sv.Teams[v].TeamColor.Name)
                    Note(("Changed team to %s"):format(v))
                end)
            end

            player.Button("Guards", function()
                if lp.Team ~= sv.Teams.Criminals and #sv.Teams.Guards:GetPlayers() > 8 then
                    Team("Bright blue")
                else
                    Respawn(BrickColor.new("Bright blue"))
                end
            end)
        end

        do
            local t = playertop.SideTab("Teleports", 1000).Section("Teleports")

            for i,v in pairs(positions) do
                t.Button(i, function()
                    if not lp.Character then return end

                    Goto(v)
                end)
            end
        end

        local player = playertop.SideTab("Toggles", 1000).Section("Toggles & Buttons")

        player.Toggle("Anti taze", togs.AntiTaze, function(a)
            togs.AntiTaze = a
            local taze = getconnections(remotes.Taze.OnClientEvent)[1]
            if taze then
                taze[a and "Disable" or "Enable"](taze)
            end
        end)

        player.Toggle("Infinite stamina", togs.InfiniteStamina, function(a)
            togs.InfiniteStamina = a
        end)

        player.Toggle("Anti sit", togs.AntiSit, function(a)
            togs.AntiSit = a
        end)

        player.Toggle("God mode", togs.Godmode, function(a)
            togs.Godmode = a
            if a then
                CloneHumanoid()
            end
        end)

        player.Toggle("Auto delete HumanoidRootPart", togs.ADHRP, function(a)
            togs.ADHRP = a

            if a then
                local c = lp.Character
                c.Parent = nil
                c.HumanoidRootPart.Parent = nil
                c.Parent = workspace
            end
        end)

        player.Button("Delete HumanoidRootPart", function()
            local c = lp.Character
            c.Parent = nil
            c.HumanoidRootPart.Parent = nil
            c.Parent = workspace
        end)

        player.Toggle("Noclip", togs.Noclip, function(a)
            togs.Noclip = a
        end)

        player.KeyBind("Noclip key", togs.Keybinds.Noclip, function(a)
            togs.Keybinds.Noclip = a
        end)

        player.Button("Rejoin", function()
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

        player.Button("Copy join", function()
            setclipboard(("game:GetService\"TeleportService\":TeleportToPlaceInstance(%i, \"%s\")"):format(game.PlaceId, game.JobId))
            Note("Set join script to clipboard")
        end)
    end

    -- World Window
    do
        local worldtop = lib.WindowTab("World")

        do
            local antis = worldtop.SideTab("Value Editor", 1000).Section("Value Editor")

            antis.Toggle("Break doors", togs.BreakDoors, function(a)
                togs.BreakDoors = a

                if a then
                    while task.wait() and togs.BreakDoors do
                        for i,v in pairs(workspace.Doors:GetDescendants()) do
                            if v.Name ~= "isActive" or v.Value == true then continue end

                            workspace.Remote.toggleSiren:FireServer({isOn=v})
                            v.Changed:Wait()
                        end
                    end
                end
            end)

            antis.Toggle("Loop hostile all", togs.LHA, function(a)
                togs.LHA = a

                if a then
                    for i,v in pairs(sv.Players:GetPlayers()) do
                        if v.Status.isHostile.Value == true then continue end

                        workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isHostile})
                        v.Status.isHostile.Changed:Wait()
                    end

                    while task.wait(.1) and togs.LHA do
                        for i,v in pairs(sv.Players:GetPlayers()) do
                            if v.Status.isHostile.Value == true then continue end

                            workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isHostile})
                            v.Status.isHostile.Changed:Wait()
                        end
                    end
                end
            end)

            antis.Toggle("Loop freindly all", togs.LFA, function(a)
                togs.LFA = a

                if a then
                    for i,v in pairs(sv.Players:GetPlayers()) do
                        if v.Status.isHostile.Value == false then continue end

                        workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isHostile})
                        v.Status.isHostile.Changed:Wait()
                    end

                    while task.wait(.1) and togs.LFA do
                        for i,v in pairs(sv.Players:GetPlayers()) do
                            if v.Status.isHostile.Value == false then continue end

                            workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isHostile})
                            v.Status.isHostile.Changed:Wait()
                        end
                    end
                end
            end)

            antis.Toggle("Loop bad guard all", togs.LBGA, function(a)
                togs.LBGA = a

                if a then
                    for i,v in pairs(sv.Players:GetPlayers()) do
                        if v.Status.isBadGuard.Value == true then continue end

                        workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isBadGuard})
                        v.Status.isBadGuard.Changed:Wait()
                    end

                    while task.wait(.1) and togs.LBGA do
                        for i,v in pairs(sv.Players:GetPlayers()) do
                            if v.Status.isBadGuard.Value == true then continue end

                            workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isBadGuard})
                            v.Status.isBadGuard.Changed:Wait()
                        end
                    end
                end
            end)

            antis.Toggle("Loop good guard all", togs.LGGA, function(a)
                togs.LGGA = a

                if a then
                    while task.wait(.1) and togs.LGGA do
                        for i,v in pairs(sv.Players:GetPlayers()) do
                            if v.Status.isBadGuard.Value == false then continue end

                            workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isBadGuard})
                            v.Status.isBadGuard.Changed:Wait()
                        end

                        for i,v in pairs(sv.Players:GetPlayers()) do
                            if v.Status.isBadGuard.Value == false then continue end

                            workspace.Remote.toggleSiren:FireServer({isOn=v.Status.isBadGuard})
                            v.Status.isBadGuard.Changed:Wait()
                        end
                    end
                end
            end)

            antis.Toggle("Loop reset kills all", togs.LRKA, function(a) 
                togs.LRKA = a

                if a then
                    while task.wait(GetPing()) and togs.LRKA do
                        for i,v in pairs(sv.Players:GetPlayers()) do
                            workspace.Remote.toggleSiren:FireServer({isOn=v.Status.innocentKills})
                        end
                    end
                end
            end)

            antis.Toggle("Infinite cars", togs.InfiniteCars, function(a) 
                togs.InfiniteCars = a

                while task.wait(.1) and togs.InfiniteCars do
                    for i,v in pairs(workspace["Prison_ITEMS"].buttons:GetDescendants()) do
                        if v.Value then continue end

                        workspace.Remote.toggleSiren:FireServer({isOn=v})
                        v.Changed:Wait()
                    end
                end
            end)
        end

        -- Drawing
        do
            local world = worldtop.SideTab("Drawing", 1000).Section("Drawing")

            world.Toggle("Drawing", togs.Drawing.Toggled, function(a)
                togs.Drawing.Toggled = a
            end)

            local DrawingName = "Example"
            world.Box("Drawing Name", "name", function(a)
                DrawingName = a
            end)

            world.Button("Save schematic", function()
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

            world.Slider("Refresh rate", 0.2, 2, togs.Drawing.Refresh, true, function(a)
                togs.Drawing.Refresh = a
            end)

            world.Button("Clear", function()
                drawingobjects = {}
                workspacedrawingobjects:ClearAllChildren()
                Note("Cleared all drawing objects")
            end)

            world.Toggle("Instant kill", togs.Drawing.InstaKill, function(a)
                togs.Drawing.InstaKill = a
            end)

            world.Toggle("Delete mode", togs.Drawing.Delete, function(a)
                togs.Drawing.Delete = a
            end)

            world.Toggle("Edit mode", togs.Drawing.Edit, function(a)
                togs.Drawing.Edit = a
            end)

            world.Toggle("Place mode", togs.Drawing.Place, function(a)
                togs.Drawing.Place = a
            end)
        end

         do
            local schem = worldtop.SideTab("Schematics", 1000).Section("Schematics")

            for i,v in pairs(listfiles"AthenaSchematics") do
                schem.Label(v:sub(18))

                for i2,v2 in pairs(listfiles(v)) do
                    local noext = v2:split(".")[1]:split("\\")[3]

                    schem.Button(noext, function()
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

        do
            local world = worldtop.SideTab("Toggles", 1000).Section("Toggles & buttons")

            world.Toggle("Auto grab keycard", togs.AGK, function(a)
                togs.AGK = a
                local key = workspace.Prison_ITEMS.single:FindFirstChild("Key card")
                if a and key then
                    remotes.Item:InvokeServer(key:WaitForChild"ITEMPICKUP")
                end
            end)

            world.Button("Crash", function()
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

            world.Button("Timeout", function()
                GetGun{"M9"}
                local gun = lp.Backpack:FindFirstChild("M9") or lp.Character:FindFirstChild("M9")

                for i = 1, math.random(1500, 2000) do
                    remotes.Shoot:FireServer({}, gun)
                end

                Note("Successfully sent timeout")
            end)

            world.Button("Delay1", function()
                GetGun{"M9"}
                local gun = lp.Backpack:FindFirstChild("M9") or lp.Character:FindFirstChild("M9")

                for i = 1, 300 do
                    remotes.Shoot:FireServer({}, gun)
                end

                Note("Successfully sent delay1")
            end)

            world.Button("Delay2", function()
                GetGun{"Remington 870"}
                local rem = lp.Backpack:WaitForChild("Remington 870")
                for i = 1,300 do
                    remotes.Weld.FireServer(remotes.Weld, rem)
                end
                task.wait(2)
                rem.Parent = lp.Character
                task.wait()
                rem.Parent = lp.Backpack
                Note("Successfully sent delay2")
            end)

            world.Button("Teleport cars", function()
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
                    Goto(oldpos)
                end

                lp.Character.Humanoid.Sit = false
            end)

            world.Toggle("Stay", false, function(a)
                Stay(a and lp.Character:GetPivot() or not a)
            end)
            
            world.Toggle("Guard gun spam", togs.GGS, function(a)
                togs.GGS = a
                Respawn(BrickColor.new("Bright blue"), lp.Character:GetPivot())
            end)

            world.Toggle("Spam arrest aura", togs.SpamArrestAura, function(a)
                togs.SpamArrestAura = a
            end)

            world.Toggle("Player ESP", togs.ESP, function(a)
                togs.ESP = a

                if not a then
                    for i, v in next, PlayerESPDrawings do
                        v.Name.Visible = false
                        v.Info.Visible = false
                    end
                end
            end)

            world.Toggle("Troll godded", togs.TrollGodded, function(a)
                togs.TrollGodded = a
            end)
        end
        
        do
            local misc = worldtop.SideTab("Players", 1000).Section("Players")

            misc.Box("Player", "name", function(a)
                selected = GetPlayer(a)
            end)

            do
                misc.Label("Values")

                misc.Button("Toggle hostile", function()
                    if not selected then return end

                    workspace.Remote.toggleSiren:FireServer({isOn=selected.Status.isHostile})
                    selected.Status.isHostile.Changed:Wait()
                    Note(("%s hostility is now: %s"):format(selected.Name, tostring(selected.Status.isHostile.Value)))
                end)

                misc.Button("Toggle bad guard", function()
                    if not selected then return end

                    workspace.Remote.toggleSiren:FireServer({isOn=selected.Status.isBadGuard})
                    selected.Status.isBadGuard.Changed:Wait()
                    Note(("%s guard status: %s"):format(selected.Name, tostring(selected.Status.isBadGuard.Value)))
                end)

                misc.Button("Reset kills", function()
                    if not selected then return end

                    workspace.Remote.toggleSiren:FireServer({isOn=selected.Status.innocentKills})
                    Note(("Reset %s's kills"):format(selected.Name))
                end)

                misc.Button("Loop reset kills", function()
                    if not selected then return end
                    local plr = selected

                    if connections["LRK"..plr.Name] then
                        connections["LRK"..plr.Name]:Disconnect()
                        connections["LRK"..plr.Name] = nil
                        Note(("Stopped reseting %s's kills"):format(plr.Name))

                        return
                    end

                    local t = tick()
                    connections["LRK"..plr.Name] = sv.RunService.Heartbeat:Connect(function()
                        if tick() - t < .1 or not plr.Parent then return end

                        workspace.Remote.toggleSiren:FireServer({isOn=plr.Status.innocentKills.Value})
                    end)

                    Note(("Started reseting %s's kills"):format(plr.Name))
                end)
            end

            -- Player Toggles
            do
                misc.Label("Toggles")

                misc.Button("Whitelist", function()
                    if not selected then return end

                    local a = table.find(togs.Whitelist, selected.Name)
                    table[a and "remove" or "insert"](togs.Whitelist, a or selected.Name)
                    Note((a and "Removed %s from whitelist" or "Added %s to whitelist"):format(selected.Name))
                end)

                misc.Button("Admin", function()
                    if not selected then return end

                    ChangeAdminPerms(selected.Name)
                end)

                misc.Button("Loopkill", function()
                    if not selected then return end

                    local a = table.find(loopkilltable, selected.Name);
                    (a and table.remove or table.insert)(loopkilltable, a or selected.Name)
                    Note((a and "Removed %s from loopkill" or "Added %s to loopkill"):format(selected.Name))
                end)

                misc.Button("Give killaura", function()
                    if not selected then return end

                    local a = table.find(givenkillaura, selected.Name)
                    table[a and "remove" or "insert"](givenkillaura, a or selected.Name)
                    Note((not a and "Gave %s killaura" or "Removed %s's killaura"):format(selected.Name))
                end)

                misc.Button("Anti punch", function()
                    if not selected then return end

                    local a = table.find(givenantipunch, selected.Name)
                    table[a and "remove" or "insert"](givenantipunch, a or selected.Name)
                    Note((not a and "Gave %s anti punch" or "Removed %s's anti punch"):format(selected.Name))
                end)

                misc.Button("Thorns", function()
                    if not selected then return end

                    local a = table.find(giventhorns, selected.Name)
                    table[a and "remove" or "insert"](giventhorns, a or selected.Name)
                    Note((not a and "Gave %s thorns" or "Removed %s's thorns"):format(selected.Name))
                end)

                misc.Button("Anti touch", function()
                    if not selected then return end

                    local a = table.find(givenantitouch, selected.Name)
                    table[a and "remove" or "insert"](givenantitouch, a or selected.Name)
                    Note((not a and "Gave %s anti touch" or "Removed %s's anti touch"):format(selected.Name))
                end)

                misc.Button("One shot guns", function()
                    if not selected then return end

                    local a = table.find(givenoneshot, selected.Name)
                    table[a and "remove" or "insert"](givenoneshot, a or selected.Name)
                    Note((not a and "Gave %s one shot guns" or "Removed %s's one shot guns"):format(selected.Name))
                end)

                misc.Button("Spam auto team", function()
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

                            return
                        end

                        if lp.TeamColor ~= selected.TeamColor then
                            t = tick()
                            Respawn(selected.TeamColor)
                        end
                    end)
                end)

                misc.Button("Loop bring", function()
                    if not selected then return end
                    if connections["LoopBring"] then
                        connections["LoopBring"]:Disconnect()
                        connections["LoopBring"] = nil
                        Note("Stopped loop bring")
                        
                        return
                    end

                    local bringing
                    connections["LoopBring"] = sv.RunService.Heartbeat:Connect(function()
                        if bringing then return end
                        if not selected then
                            connections["LoopBring"]:Disconnect()
                            connections["LoopBring"] = nil
                            Note(("%s has left, disconnected loop bring"):format(selected.Name))
                            
                            return
                        end

                        bringing = true
                        GetGun{togs.BringTool}
                        Bring(selected, lp.Backpack:WaitForChild(togs.BringTool), lp.Character:GetPivot(), 5)
                        lp.CharacterAdded:Wait()
                        bringing = false
                    end)
                end)

                misc.Button("Loop criminal", function()
                    if not selected then return end
                    if connections["LoopCrim"] then
                        connections["LoopCrim"]:Disconnect()
                        connections["LoopCrim"] = nil
                        Note("Stopped loop criminal")
                        
                        return
                    end

                    local bringing
                    connections["LoopCrim"] = sv.RunService.Heartbeat:Connect(function()
                        if bringing then return end
                        if not selected then
                            connections["LoopCrim"]:Disconnect()
                            connections["LoopCrim"] = nil
                            Note(("%s has left, disconnected loop criminal"):format(selected.Name))
                            
                            return
                        end

                        bringing = true
                        Crim(selected)
                        task.wait(.4)
                        bringing = false
                    end)
                end)

                misc.Button("View", function()
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
                misc.Label("Buttons")

                misc.Button("Copy team color", function()
                    if not selected then return end

                    Respawn(selected.TeamColor)
                end)

                misc.Button("Bring", function()
                    if not selected or not selected.Character or not lp.Character then return end

                    GetGun{togs.BringTool}
                    Bring(selected, lp.Backpack:WaitForChild(togs.BringTool), lp.Character:GetPivot())
                    Note(("Brung %s"):format(selected.Name))
                end)

                misc.Button("Void", function()
                    if not selected or not selected.Character or not lp.Character then return end

                    GetGun{togs.BringTool}
                    Bring(selected, lp.Backpack:WaitForChild(togs.BringTool), CFrame.new(0, -495, 0))
                    Note(("Voided %s"):format(selected.Name))
                end)

                misc.Button("Slide", function()
                    if not selected or not selected.Character or not lp.Character then return end

                    GetGun{togs.BringTool}
                    Bring(selected, lp.Backpack:WaitForChild(togs.BringTool), positions["Slide"])
                    Note(("Slided %s"):format(selected.Name))
                end)

                misc.Button("Goto", function()
                    if not selected or not selected.Character or not lp.Character then return end

                    Goto(selected.Character:GetPivot())
                end)

                misc.Button("Fling", function()
                    if not selected or not selected.Character or not lp.Character then return end
                    local nt, op = togs.Noclip, lp.Character:GetPivot()
                    togs.Noclip = true

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
                    Goto(op)
                    togs.Noclip = nt
                    Note(("Flung %s"):format(selected.Name))
                end)

                misc.Button("Crim", function()
                    if not selected or not selected.Character or not lp.Character then return end

                    Crim(selected)
                    Note(("Made %s criminal"):format(selected.Name))
                end)

                misc.Button("Arrest", function()
                    if not selected or not selected.Character or not lp.Character then return end

                    local oldpos = lp.Character:GetPivot()

                    if not CanBeArrested(selected) then
                        Crim(selected)
                    end

                    Goto(selected.Character:GetPivot())
                    task.defer(remotes.Arrest.InvokeServer, remotes.Arrest, selected.Character.Head)
                    selected.Character.Head:WaitForChild("handcuffedGui", 1/0)
                    Goto(oldpos)
                    Note(("Arrested %s"):format(selected.Name))
                end)

                misc.Button("Spam arrest", function()
                    if not selected or not selected.Character or not lp.Character then return end

                    SpamArrest(selected, togs.SpamArrestPower)
                end)

                misc.Button("Crash spam arrest", function()
                    if not selected or not selected.Character or not lp.Character then return end

                    CrashSA(selected)
                end)

                misc.Button("Kill", function()
                    if not selected or not selected.Character or not lp.Character then return end

                    repeat task.wait() until not selected.Character or not selected.Character:FindFirstChild("ForceField")

                    Kill{selected}
                    Note(("Killed %s"):format(selected.Name))
                end)

                misc.Button("Give current item", function() 
                    if not selected or not selected.Character or not lp.Character then return end
                    local tool = lp.Character:FindFirstChildOfClass("Tool")

                    if not tool then
                        Note("Please equip an item to give.", true)
                        return
                    end

                    tool.Parent = lp.Backpack
                    Bring(selected, tool, lp.Character:GetPivot())
                    Note(("Gave %s your weapon"):format(selected.Name))
                end)
            end
        end
    end

    -- Settings Window
    do
        local settingtop = lib.WindowTab("Settings")

        do
            local setting = settingtop.SideTab("Settings", 1000).Section("Settings")

            setting.Dropdown("Drawing gun", {"M9", "Remington 870", "M4A1", "AK-47"}, function(a)
                togs.Drawing.Gun = a
            end)

            setting.Dropdown("Bring tool", {"M9", "Remington 870", "M4A1", "AK-47", "Hammer", "Crude Knife"}, function(a)
                togs.BringTool = a
            end)

            setting.Dropdown("Kill gun", {"M9", "Remington 870", "M4A1", "AK-47"}, function(a)
                togs.KillGun = a
            end)

            setting.Slider("Spam arrest power", 1, 100, togs.SpamArrestPower, false, function(a)
                togs.SpamArrestPower = a
            end)

            setting.Button("Break spam arrest", function()
                breaksa = true
                task.wait(.1)
                breaksa = false
                Note("Broke current spam arrest")
            end)

            setting.Button("Athena chat", function()
                ChatLogs.AthenaChat.Visible = true
            end)

            setting.Toggle("No fade ui", togs.NoFade, function(a)
                togs.NoFade = a
                lp.PlayerGui.Home.fadeFrame.Visible = not a
            end)

            setting.Toggle("Anti bring", togs.AntiBring, function(a)
                togs.AntiBring = a
            end)

            setting.Toggle("Harden anti bring", togs.HardendAntiBring, function(a)
                togs.HardendAntiBring = a
            end)

            setting.Toggle("Anti arrest", togs.AntiArrest, function(a)
                togs.AntiArrest = a
            end)

            setting.Toggle("Anti criminal", togs.AntiCriminal, function(a)
                togs.AntiCriminal = a
            end)

            setting.Toggle("Anti crash/lag", togs.AntiCrash, function(a)
                togs.AntiCrash = a
            end)

            setting.Toggle("No humanoid in Antis", togs.NHA, function(a)
                togs.NHA = a
            end)

            setting.Toggle("Silent commands", togs.Admin.Silent, function(a) 
                togs.Admin.Silent = a
            end)

            setting.Box("Admin Prefix", "prefix", function(a)
                togs.Admin.Prefix = a
            end)

            setting.KeyBind("Cmd Focus Key", togs.Admin.FocusKey, function(a)
                togs.Admin.FocusKey = a
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

        if method == "GetPivot" and sv.Players.FindFirstChild(sv.Players, tostring(s)) then
            local p = sv.Players[tostring(s)]
            return p.Character and p.Character.FindFirstChild(p, "HumanoidRootPart") and p.Character.HumanoidRootPart.CFrame or namecall(s, ...)
        end

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

            if method == "Play" then
                if tostring(s) == "FireSound" and togs.SilentGun then
                    return
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

                    if togs.OnePunch and args[1] and args[1].Character and args[1].Character.FindFirstChild(args[1].Character, "Humanoid") then
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
                                local hitmodel =  a1.Hit.FindFirstAncestorOfClass(a1.Hit, "Model")
                                local plr =       sv.Players.GetPlayerFromCharacter(sv.Players, hitmodel)
                                local gunstates = args[2].FindFirstChild(args[2], "GunStates")
                                if plr and gunstates and hitmodel.FindFirstChild(hitmodel, "Humanoid") and hitmodel.Humanoid.Health ~= 0 and plr.TeamColor ~= lp.TeamColor then
                                    for i = 1, math.ceil(hitmodel.Humanoid.Health / require(gunstates).Damage) do
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

        return a.Toggled and (a.Rainbow and BrickColor.random() or BrickColor.new(a.R, a.G, a.B)) or BrickColorHook()
    end)

    local RandomHook; RandomHook = hookfunction(math.random, function(a, b)
        if checkcaller() or not tostring(getcallingscript()):find("Interface") then return RandomHook(a, b) end

        return togs.GunMods.NoSpread and 0 or RandomHook(a, b)
    end)

    local ChatHook = require(lp.PlayerScripts.ChatScript.ChatMain.MessageSender).SendMessage

    require(lp.PlayerScripts.ChatScript.ChatMain.MessageSender).SendMessage = function(...)
        local args = {...}
        local cmd = args[2]

        if cmd:sub(1, #togs.Admin.Prefix) == togs.Admin.Prefix then
            HandleMessage(args[2])

            if togs.Admin.Silent then
                return
            end
        end

        return ChatHook(...)
    end

    for i,v in pairs(getgc()) do
		if type(v) == "function" and getfenv(v).script == lp.PlayerScripts.ClientGunReplicator then -- i fucking hate syn v2
            if debug.getinfo(v).currentline ~= 4 then continue end
            local oldfunc = v
            getgc()[i] = function(bullets, istaser)
                if #bullets > 15 or #bullets == 0 then
                    if togs.HardendAntiBring then
                        local op = lp.Character:GetPivot()
                        sv.Debris:AddItem(lp.Character, 0)
                        task.delay(.5, Respawn, nil, op)
                    end

                    return
                end

                if togs.AntiCrash then
                    for i,v in pairs(bullets) do
                        if not v.RayObject or not v.Cframe or not v.Distance or v.Distance > 800 or v.Distance == 0 then
                            return
                        end
                    end
                end
        
                oldfunc(bullets, istaser)
            end
		end
    end
end
-- Connections

do
    workspace.Remote.arrestPlayer.OnClientEvent:Connect(function()
        if togs.AntiArrest and lp.Character and lp.Character:FindFirstChild("Humanoid") then
            local oldc, oldar, oldpos = lp.TeamColor, togs.AutoRespawn.Toggled, lp.Character:GetPivot()
            togs.AutoRespawn.Toggled = false
            lp.Character:BreakJoints()
            lp.CharacterAdded:Wait()
            task.spawn(Respawn, oldc, oldpos)
            togs.AutoRespawn.Toggled = oldar
        end
    end)

    game:GetService"RunService".RenderStepped:Connect(function()
        if not togs.ESP then return end

        for i,v in next, PlayerESPDrawings do
            local plr = game.Players:FindFirstChild(i)

            if plr then
                local pos, vis = workspace.CurrentCamera:WorldToViewportPoint((plr.Character and plr.Character:GetPivot() or CFrame.new()).p)
                pos = Vector2.new(pos.X, pos.Y) - Vector2.new(0, 30)
                local hitm = plr.Character and lp:GetMouse().Target and lp:GetMouse().Target:IsDescendantOf(plr.Character)

                v.Name.Color = plr.TeamColor.Color

                v.Name.Visible = plr.Character ~= nil and vis and togs.ESP
                v.Info.Visible = plr.Character ~= nil and vis and togs.ESP

                v.Name.Transparency = hitm and .9 or .6
                v.Info.Transparency = hitm and .9 or .6

                v.Name.Position = pos
                v.Info.Position = pos + Vector2.new(0, v.Name.TextBounds.Y)

                v.Info.Text = ("[%i/%i]\nTool: %s"):format((plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health) or 0, (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.MaxHealth) or 0, tostring(plr.Character and plr.Character:FindFirstChildOfClass("Tool") or "nil"))
            end
        end
    end)

    lp:GetPropertyChangedSignal("Team"):Connect(function()
        local tc = lp.TeamColor

        if togs.AntiCriminal and tc == sv.Teams.Criminals.TeamColor then
            local oldar, oldp = togs.AutoRespawn.Toggled, lp.Character:GetPivot()
            togs.AutoRespawn.Toggled = false

            if togs.NHA then
                CloneHumanoid()
            else
                lp.Character:BreakJoints()
            end
                
            task.spawn(Respawn, BrickColor.new("Bright blue"), oldp)
            task.wait(1/30)
            togs.AutoRespawn.Toggled = oldar
        end
    end)

    sv.UserInputService.InputBegan:Connect(function(input, bjehrtgbiwsehjitrgbhwiesrhngejwrghwejlrfg)
        if bjehrtgbiwsehjitrgbhwiesrhngejwrghwejlrfg then return end
        
        if input.KeyCode == togs.Keybinds.Respawn then
            Respawn(nil, lp.Character:GetPivot())
        end

        if input.KeyCode == togs.Keybinds.GetGuns then
            GetGun(togs.GunOrder)
        end

        if input.KeyCode == togs.Keybinds.BurstKillaura then
            local kt = {}

            for i,v in pairs(sv.Players:GetPlayers()) do
                if v and v.Character and v:DistanceFromCharacter(v.Character:GetPivot().p) <= 10 and not table.find(togs.Whitelist, v.Name) then
                    table.insert(kt, v)
                end
            end

            MeleeKill(kt)
        end
    end)

    remotes.Replicate.OnClientEvent:Connect(function(bullets) -- became a new message handler
        local plr = bullets[1] and type(bullets[1]) == "table" and bullets[1]["https://discord.gg/ng8yFn2zX6"]
        if plr and plr:IsA("Player") and not table.find(athenausers, plr.Name) then
            table.insert(athenausers, plr.Name)
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
                    fnlmsg[tonumber(_:sub(5))] = string.char(v)
                end
            end)

            ChatLogAdd(bullets[1]["ACC_IDENTIFIER"], table.concat(fnlmsg):reverse(), tick())

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
        if not togs.Noclip and not sv.UserInputService:IsKeyDown(togs.Keybinds.Noclip) then return end
        
        for i,v in next, workspace.CarContainer:GetDescendants() do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

        for i,v in next, sv.Players:GetPlayers() do
            if v.Character then
                for i2,v2 in next, v.Character:GetDescendants() do
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
    sv.Players.PlayerAdded:Connect(AddPlayer)
    OnCharacterAdded(lp.Character)
    lp.CharacterAdded:Connect(OnCharacterAdded)
    sv.ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(msgdata)
        if msgdata.FromSpeaker == lp.Name then return end

        if table.find(togs.Admin.Admins, msgdata.FromSpeaker) and msgdata.Message:sub(1, 1) == togs.Admin.Prefix then
            if table.find({"help", "cmds"}, msgdata.Message:lower():sub(2, 5)) then
                sv.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(("/w %s Prefix is %s | Your commands list: "):format(msgdata.FromSpeaker, togs.Admin.Prefix), "All")
                task.wait(GetPing() * 4)
                local msg = ""
                local msgs = {}
                for i,v in pairs(commands) do
                    if v.IsUseableByOthers then
                        msg = ("%s %s (%s),"):format(msg, v.Command, not v.Aliases and "" or type(v.Aliases) == "table" and table.concat(v.Aliases, ", ") or v.Aliases)
                    end
                end

                for i = 1, math.ceil(#msg / 175) do
                    table.insert(msgs, msg:sub(i ~= 1 and (i - 1) * 175 or 1, i * 175))
                end

                for i,v in pairs(msgs) do
                    task.wait(1)
                    sv.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(("/w %s %s"):format(msgdata.FromSpeaker, v), "All")
                end

                return
            end

            HandleMessage(msgdata.Message, msgdata.FromSpeaker)
        end
    end)

    table.foreach(getconnections(sv.ReplicatedStorage.DefaultChatSystemChatEvents.OnNewSystemMessage.OnClientEvent), function(_,v)
        v:Disable()
    end)
end

task.spawn(LoaderUpdate)

-- lots of loops

do
    task.spawn(function()
        while task.wait() do
            if togs.Fly.Toggled then
                pcall(function()
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
                end)
            else
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid") then
                    (lp.Character.HumanoidRootPart:FindFirstChild("BodyGyro") or Instance.new("Model")):Destroy();
                    (lp.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") or Instance.new("Model")):Destroy()
                    lp.Character.Humanoid.PlatformStand = false
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait() do
            if togs.SpamArrestAura then
                for i,v in pairs(sv.Players:GetPlayers()) do
                    if v ~= lp and CanBeArrested(v) and not table.find(togs.Whitelist, v.Name) and v.Character and v.Character.PrimaryPart then
                        if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("Head") and lp:DistanceFromCharacter(v.Character.PrimaryPart.Position) <= 12 then
                            for _ = 1,togs.SpamArrestPower do
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

                    if togs.Killaura[tostring(v.Team)] or (togs.Killaura.Custom and not v.Team) then
                        if lp.Character and lp:DistanceFromCharacter(v.Character:GetPivot().p) <= 10 then
                            table.insert(mkt, v)

                            continue
                        end
                    end

                    for i,v2 in pairs(givenkillaura) do
                        local plr = sv.Players:FindFirstChild(v2)

                        if plr and plr.Character and plr:DistanceFromCharacter(v.Character:GetPivot().p) <= 10 then
                            table.insert(kt, v)
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
            task.spawn(PlayerAdded, v)
            AddPlayer(v)
        end
    end
end

-- Loadstring tpdata and random stuff
do
    local p1 = Instance.new("Part", workspace)
    local p2 = Instance.new("Part", workspace)
    local p3 = Instance.new("Part", workspace)
    local p4 = Instance.new("Part", workspace)

    p1.CFrame = CFrame.new(1000, -495, 2800)
    p2.CFrame = p1.CFrame - Vector3.new(2048)
    p3.CFrame = p1.CFrame - Vector3.new(0, 0, 2048)
    p4.CFrame = p1.CFrame - Vector3.new(2048, 0, 2048)
    p1.Size = Vector3.new(2048, 3, 2048)
    p2.Size = p1.Size
    p3.Size = p1.Size
    p4.Size = p1.Size
    p1.Anchored = true
    p2.Anchored = true
    p3.Anchored = true
    p4.Anchored = true
    p1.Color = BrickColor.new("Camo").Color
    p2.Color = p1.Color
    p3.Color = p1.Color
    p4.Color = p1.Color
    p1.Material = Enum.Material.Grass
    p2.Material = p1.Material
    p3.Material = p1.Material
    p4.Material = p1.Material

    workspacedrawingobjects.Name = "AthenaDrawingObjects"
    for i,v in pairs(workspace["Criminals Spawn"]:GetChildren()) do
        v.Parent = game
        v.Touched:Connect(function()
            if not togs.AntiCriminal then return end

            Respawn(sv.Teams.Guards.TeamColor, positions["Nexus"])
        end)
    end
    task.wait(math.random(0, 1))
    SendMsg({
        [1] = {
            ["https://discord.gg/ng8yFn2zX6"] = lp
        }
    })
    getgenv().SendMsg = SendMsg
    local Tpdata = ...

    if Tpdata then
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
            Respawn(BrickColor.new("Bright blue"))
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
                local oldpos = lp.Character:GetPivot()

                if not CanBeArrested(v2) then
                    Crim(v2)
                end

                Goto(v2.Character:GetPivot())
                task.wait(GetPing())
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

    AddCommand("Team", "t", "Puts you on team", false, false, function(plr, ...)
        local t = GetTeam(({...})[1])

        if t and t ~= "Custom" then
            Team(sv.Teams[t].TeamColor.Name)
            
            return
        end

        if not tonumber(({...})[1]) then
            Respawn(BrickColor.new(table.concat({...}, " ")))

            return
        end

        Respawn(BrickColor.new(...))
    end)

    AddCommand("Timeout", "Disconnect", "Timeouts the server", false, false, function(plr, ...)
        if not MessageBox("Confirm", "Are you sure you want timeout?") then return end

        GetGun{"M9"}
        local gun = lp.Backpack:FindFirstChild("M9") or lp.Character:FindFirstChild("M9")

        for i = 1, math.random(1500, 2000) do
            remotes.Shoot:FireServer({}, gun)
        end
    end)

    AddCommand("Weldcrash", "Crash", "Crashes the server using welds", false, false, function(plr, ...)
        if not MessageBox("Confirm", "Are you sure you want to weld crash?") then return end

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

    AddCommand("Admin", "Rank", "Admins given player", true, false, function(plr, ...)
        for i,v in pairs({...}) do
            local splr = GetPlayer(v)
            if not splr then continue end

            ChangeAdminPerms(splr.Name)
        end
    end)

    AddCommand("Bring", "b", "Brings player to you or an admin", true, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if v2 == lp then continue end

                GetGun{togs.BringTool}
                Bring(v2, lp.Backpack:FindFirstChild(togs.BringTool), plr and sv.Players[plr].Character:GetPivot() or lp.Character:GetPivot())
            end
        end
    end)

    AddCommand("Fling", nil, "Flings player", true, true, function(plr, fplr)
        local fplr = GetPlayer(fplr)

        if fplr == lp or not fplr or not fplr.Character or not lp.Character then return end
        local nt, op = togs.Noclip, lp.Character:GetPivot()
        togs.Noclip = true

        local bg = Instance.new("BodyAngularVelocity", lp.Character.HumanoidRootPart)
        local bp = Instance.new("BodyPosition", lp.Character.HumanoidRootPart)
        bg.P = 9e9
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.AngularVelocity = Vector3.new(9e9, 9e9, 9e9)
        bp.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bp.D = 10
        bp.P = 9e9
        for i = 1, 300 do
            if not lp.Character or not fplr or not fplr.Character then break end
            bp.Position = fplr.Character:GetPivot().p
            task.wait()
        end

        bg:Destroy()
        Goto(op)
        togs.Noclip = nt
        Note(("Flung %s"):format(fplr.Name))
    end)

    AddCommand("Slide", "sl", "Slides given players", true, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if v2 == lp then continue end

                GetGun{togs.BringTool}
                Bring(v2, lp.Backpack:FindFirstChild(togs.BringTool), positions["Slide"])
            end
        end
    end)

    AddCommand("Void", "v", "Voids given players", true, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if v2 == lp then continue end

                GetGun{togs.BringTool}
                Bring(v2, lp.Backpack:FindFirstChild(togs.BringTool), CFrame.new(0, -495, 0))
            end
        end
    end)

    AddCommand("Crashsa", "csa", "Very fast spam arrest", true, false, function(plr, ...)
        local plr, d = ...
        plr = GetPlayer(plr)
        if not plr then return end

        if MessageBox("Confirm", ("Are you sure you want to crash sa\n%s?"):format(plr.Name)) then
            CrashSA(plr, d)
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
        local plr, power, del = ...
        local aplr = GetPlayer(plr)

        if not aplr then return end

        if MessageBox("Confirm", ("Are you sure you want to spam arrest\n%s?"):format(aplr.Name)) then
            SpamArrest(aplr, tonumber(power) or togs.SpamArrestPower, tonumber(del))
        end
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

    AddCommand("grabswat", "gsw", "Grabs swat items", false, false, function()
        if not HasM4 then Note("You must have the swat gamepass", true); return end

        local oldteam = lp.TeamColor.Name
        if lp.Team ~= sv.Teams.Guards then
            oldteam = lp.TeamColor.Name
            Team(BrickColor.new("Bright blue"))
        end

        remotes.Item:InvokeServer(workspace.Prison_ITEMS.clothes:FindFirstChild("Riot Police").ITEMPICKUP)
        GetGun{"Riot Shield"}

        Note("Given swat items")

        if oldteam then
            Team(oldteam)
        end
    end)

    AddCommand("grabshield", "gs", "Grabs a shield off a random swat user if any", false, false, function()
        local s

        for i,v in pairs(sv.Players:GetPlayers()) do
            if v:FindFirstChild("Backpack") and (v.Backpack:FindFirstChild("Riot Shield") or v.Character and v.Character:FindFirstChild("Riot Shield")) then
                s = v.Backpack:FindFirstChild("Riot Shield") or v.Character:FindFirstChild("Riot Shield")
            end
        end

        for i = 1, 4 do
            workspace.Remote.equipShield:fireServer(s)
        end
    end)

    AddCommand("toggledoors", "td", "Breaks doors", false, true, function()
        for i,v in pairs(workspace.Doors:GetDescendants()) do
            if v.Name ~= "isActive" then continue end
            workspace.Remote.toggleSiren:FireServer({isOn=v})
        end
    end)

    AddCommand("hostile", "hos", "Hostiles player", false, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if v2 == lp or v2.Name == tostring(plr) or v2.Status.isHostile.Value then continue end

                workspace.Remote.toggleSiren:FireServer({isOn=v2.Status.isHostile})
            end
        end
    end)

    AddCommand("friendly", "fri", "Make player a friendly little goober", false, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if not v2.Status.isHostile.Value then continue end

                workspace.Remote.toggleSiren:FireServer({isOn=v2.Status.isHostile})
            end
        end
    end)

    AddCommand("badguard", "bg", "Makes player bad guard", false, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if v2 == lp or v2.Name == tostring(plr) or v2.Status.isBadGuard.Value then continue end

                workspace.Remote.toggleSiren:FireServer({isOn=v2.Status.isBadGuard})
            end
        end
    end)

    AddCommand("resetkills", "rk", "Reset players kills", false, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                workspace.Remote.toggleSiren:FireServer({isOn=v2.Status.innocentKills})
            end
        end
    end)

    AddCommand("goodguard", "gg", "Makes player good guard", false, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                if not v2.Status.isBadGuard.Value then continue end

                workspace.Remote.toggleSiren:FireServer({isOn=v2.Status.isBadGuard})
            end
        end
    end)

    AddCommand("infcars", "ic", "Makes anyone able to spam cars", false, true, function()
        for i,v in pairs(workspace["Prison_ITEMS"].buttons:GetDescendants()) do
            if v.Name ~= "deb" then continue end

            task.spawn(function()
                while task.wait() do
                    if v.Value then continue end

                    workspace.Remote.toggleSiren:FireServer({isOn=v})
                    v.Changed:Wait()
                end
            end)
        end
    end)

    AddCommand("spamresetkills", "srk", "Reset players kills", false, true, function(plr, ...)
        for i,v in pairs({...}) do
            for i, v2 in pairs(AGetPlayer(v)) do
                task.spawn(function()
                    while task.wait(.1) do
                        workspace.Remote.toggleSiren:FireServer({isOn=v2.Status.innocentKills})
                    end
                end)
            end
        end
    end)

    for i,v in pairs(positions) do
        AddCommand(i, i:sub(1, 3), ("Goes to %s"):format(i), false, true, function(plr)
            if plr then
                GetGun{togs.BringTool}
                Bring(sv.Players[plr], lp.Backpack:WaitForChild(togs.BringTool), v)

                return
            end

            Goto(v)
        end)
    end
end

task.spawn(LoaderUpdate)
Note("Press Right Control to open")
