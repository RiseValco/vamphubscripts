--[[
db    db  .d8b.  .88b  d88. d8888b. db   db db    db d8888b. 
88    88 d8' `8b 88'YbdP`88 88  `8D 88   88 88    88 88  `8D 
Y8    8P 88ooo88 88  88  88 88oodD' 88ooo88 88    88 88oooY' 
`8b  d8' 88~~~88 88  88  88 88~~~   88~~~88 88    88 88~~~b. 
 `8bd8'  88   88 88  88  88 88      88   88 88b  d88 88   8D 
   YP    YP   YP YP  YP  YP 88      YP   YP ~Y8888P' Y8888P'
]]--
-- [[ GNU General Public License @ 2022 Vamp Hub ]]--
-- https://www.roblox.com/games/10726371567/Find-The-Simpsons-171
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RiseValco/vamphubscripts/main/Library.lua'))()
local Flags = Library.Flags

local request = http_request or request or HttpPost or syn.request
local options = {Url = "https://raw.githubusercontent.com/RiseValco/vamphubscripts/main/anc.txt", Method = "GET"}
local res = request(options)

local Window = Library:Window({
    Text = "Find The Simpsons - VampHub | "..res.Body
})

local MainTab = Window:Tab({
    Text = "Main"
})

local OPSection = MainTab:Section({
    Text = "OP"
})

local LocalPlayerSection = MainTab:Section({
    Text = "Local Player",
})

local MiscSection = MainTab:Section({
    Text = "Misc",
    Side = "Right"
})

local HTTP = game:GetService("HttpService")
local plr = game:GetService("Players").LocalPlayer

local Hook = {
    WalkSpeed,
    JumpPower,
}



OPSection:Button({
    Text = "Collect all Simpsons",
    Callback = function()
        local NumFound = #plr.Creatures:GetChildren()
        for _,v in pairs(game:GetService("Workspace").Creatures:GetChildren()) do
            if plr.Creatures:FindFirstChild(v.Name) == nil then
            repeat
                pcall(function()
                firetouchinterest(plr.Character.HumanoidRootPart, v, 0)
                firetouchinterest(plr.Character.HumanoidRootPart, v, 1)
                end)
                wait()
            until NumFound < #plr.Creatures:GetChildren()
            NumFound = #plr.Creatures:GetChildren() 
                
            end
        end
    end
})


MiscSection:Button({
    Text = "Rejoin",
    Callback = function(e) 
        game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
    end
})

LocalPlayerSection:Label({
    Text = "Walk Speed",
    Tooltip = "Walk Speed of your character"
})
LocalPlayerSection:Input({
    Text = "WalkSpeed",
    Placeholder = "16",
    Callback = function(e)
        if typeof(tonumber(e)) == typeof(1) then
        pcall(function() plr.Character.Humanoid.WalkSpeed = e end)
        end
    end
})
LocalPlayerSection:Label({
    Text = "Jump Power",
    Tooltip = "Jump Power of your character"
})
LocalPlayerSection:Input({
    Text = "JumpPower",
    Placeholder = "50",
    Callback = function(e)
        if typeof(tonumber(e)) == typeof(1) then
        pcall(function() plr.Character.Humanoid.JumpPower = e end)
        end
    end
})

MainTab:Select()

request({
			Url = 'http://127.0.0.1:6463/rpc?v=1',
			Method = 'POST',
			Headers = {
				['Content-Type'] = 'application/json',
				Origin = 'https://discord.com'
			},
			Body = HTTP:JSONEncode({
				cmd = 'INVITE_BROWSER',
				nonce = HTTP:GenerateGUID(false),
				args = {code = Library.Discord}
			})
		})

Hook.WalkSpeed = hookmetamethod(game, "__index", function(self, ...)
    if ... == "WalkSpeed" then
        return 16
    end
    return Hook.WalkSpeed(self, ...) 
end)

Hook.JumpPower = hookmetamethod(game, "__index", function(self, ...)
    if ... == "JumpPower" then
        return 50
    end
    return Hook.JumpPower(self, ...) 
end)

