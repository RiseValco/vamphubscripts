-- https://www.roblox.com/games/4483381587/a-literal-baseplate
-- [[ 
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RiseValco/vamphubscripts/main/Library.lua'))()
local Flags = Library.Flags

local request = http_request or request or HttpPost or syn.request
local options = {Url = "https://raw.githubusercontent.com/RiseValco/vamphubscripts/main/anc.txt", Method = "GET"}
local res = request(options)

local Window = Library:Window({
    Text = "Baseplate - VampHub | "..res.Body
})

local LocalTab = Window:Tab({
    Text = "Main"
})

local LocalPlayerSection = LocalTab:Section({
    Text = "Local Player"
})

local MiscSection = LocalTab:Section({
    Text = "Misc",
    Side = "Right"
})

local LightingSection = LocalTab:Section({
    Text = "Lighting",
    Side = "Right"
})

local http = game:GetService("HttpService")

local plr = game:GetService("Players").LocalPlayer

local Hook = {
    WalkSpeed,
    JumpPower,
}


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

LocalPlayerSection:Label({
    Text = "Headless (NOT FE)",
    Tooltip = "Gives your character headless (NOT FE)"
})

LocalPlayerSection:Toggle({
    Text = "Headless",
    Callback = function(e)
        if e then
           pcall(function()
            plr.Character.Head.Transparency = 1
            plr.Character.Head.face.Transparency = 1
           end) 
        else
         pcall(function()
            plr.Character.Head.Transparency = 0
            plr.Character.Head.face.Transparency = 0
         end) 
        end
    end
})

LocalTab:Select()

MiscSection:Button({
    Text = "Rejoin",
    Callback = function(e) 
        game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
    end
})

LightingSection:Dropdown({
    Text = "Time of day",
    List = {"Morning", "Afternoon", "Night"},
    Flag = "Choosen",
    Callback = function(e)
       if e == "Morning" then
           game:getService("Lighting").TimeOfDay = "07:00:00"
            else if e == "Afternoon" then
            game:getService("Lighting").TimeOfDay = "14:00:00"
            else if e == "Night" then
                game:getService("Lighting").TimeOfDay = "20:00:00"
            end
            end   
        end
    end
})

LightingSection:Slider({
    Text = "Brightness",
    Default = 2,
    Minimum = 2,
    Maximum = 50,
    Color = Color3.fromRGB(217, 97, 99),
    Callback = function(v)
        game:GetService("Lighting").Brightness = v
    end
})

request({
			Url = 'http://127.0.0.1:6463/rpc?v=1',
			Method = 'POST',
			Headers = {
				['Content-Type'] = 'application/json',
				Origin = 'https://discord.com'
			},
			Body = http:JSONEncode({
				cmd = 'INVITE_BROWSER',
				nonce = http:GenerateGUID(false),
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
