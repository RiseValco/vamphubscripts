--[[
db    db  .d8b.  .88b  d88. d8888b. db   db db    db d8888b. 
88    88 d8' `8b 88'YbdP`88 88  `8D 88   88 88    88 88  `8D 
Y8    8P 88ooo88 88  88  88 88oodD' 88ooo88 88    88 88oooY' 
`8b  d8' 88~~~88 88  88  88 88~~~   88~~~88 88    88 88~~~b. 
 `8bd8'  88   88 88  88  88 88      88   88 88b  d88 88   8D 
   YP    YP   YP YP  YP  YP 88      YP   YP ~Y8888P' Y8888P'
]]--
-- [[ GNU General Public License @ 2022 Vamp Hub ]]--
-- https://www.roblox.com/games/10198661638/Farm-Factory-Tycoon
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RiseValco/vamphubscripts/main/Library.lua'))()
local Flags = Library.Flags

local request = http_request or request or HttpPost or syn.request
local options = {Url = "https://raw.githubusercontent.com/RiseValco/vamphubscripts/main/anc.txt", Method = "GET"}
local res = request(options)

local Window = Library:Window({
    Text = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." - VampHub | "..res.Body
})

local MainTab = Window:Tab({
    Text = "Main"
})

local MGSection = MainTab:Section({
    Text = "MONEY GIVER"
})

local LPSection = MainTab:Section({
    Text = "LOCAL PLAYER"
})

local SSection = MainTab:Section({
    Text = "SERVER"
})

local ABBSection = MainTab:Section({
    Text = "AUTO BUY BUTTONS",
    Side = "Right"
})

local ACMSection = MainTab:Section({
    Text = "AUTO CLAIM MISSIONS",
    Side = "Right"
})

local AIKSection = MainTab:Section({
    Text = "ANTI-IDLE KICK",
    Side = "Right"
})

local HTTP = game:GetService("HttpService")
local plr = game:GetService("Players").LocalPlayer

function GetTycoon()
   local Tycoon = nil
   for _,v in pairs(game:GetService("Workspace").Tycoon:GetChildren()) do
     if tostring(v.Onwer.Value) == plr.Name then
        Tycoon = v
        break
      end
   end
   return Tycoon
end

local GetMoneySpeed = 0.1
local GetMoneyTimes = 2
getgenv().GetMoney = false
local GetMoney = getgenv().GetMoney
MGSection:Toggle({
    Text = "Enable",
    Callback = function(v)
        GetMoney = v
        if v == true then
            repeat
            for x = 1,GetMoneyTimes do
            game:GetService("ReplicatedStorage").Remote.Event.Offline["[S-C]TryGetFreeReward"]:FireServer()
            end
            wait(GetMoneySpeed)
            until GetMoney == false
        end
    end
})

MGSection:Toggle({
    Text = "No Cash Effect (UI)",
    Callback = function(v)
     plr.PlayerGui.Hud.Main.Cash.Effect.Visible = v == false
    end
})

MGSection:Slider({
    Text = "Delay (MS)",
    Default = 100,
    Minimum = 10,
    Maximum = 1000,
    Tooltip = "TIP: this is in milliseconds",
    Callback = function(v)
        GetMoneySpeed = v / 1000
    end
})

MGSection:Label({
    Text = "MoneyGiver X (NUMBER)"
})

MGSection:Input({
    Placeholder = "(MAX 200)",
    Tooltip = "EXAMPLE: MoneyGiver x 2",
    Callback = function(v)
         v = tonumber(v)
        if v and v <= 200 then
          GetMoneyTimes = v
        end
    end
})

ABBSection:Label({
    Text = "Cash Auto Buyer"
})

function GetCheapestButton(Data)
    local CheapeastPrice = 9999999999999999999999999999999999999999999999
    local Button
    local Tycoon = Data.Tycoon
    if Data.Type == "Cash" then
        for _,v in pairs(Tycoon.Buttons:GetChildren()) do
            local Price = tonumber(v.Price.Value)
            if Price < CheapeastPrice then
            Button = v
            CheapeastPrice = Price
            end
        end    
    else if Data.Type == "Gems" then
        for _,v in pairs(Tycoon.PayButtons:GetChildren()) do
            local Price = tonumber(v.Head.TitleGui.Title.MoneyText.Text)
            if Price < CheapeastPrice then
            Button = v
            CheapeastPrice = Price
            end
        end   
        end
    end
    return {Button = Button, Price = CheapeastPrice}
end
getgenv().AutoBuyButtonsCash = false
local AutoBuyButtonsCash = getgenv().AutoBuyButtonsCash
ABBSection:Toggle({
    Text = "Enable",
    Callback = function(v)
        AutoBuyButtonsCash = v
        if v == true then
            local Tycoon = GetTycoon()
            repeat
               
                local Data = GetCheapestButton({Type = "Cash", Tycoon = Tycoon})
                if tonumber(plr.Eco.cash.Value) >= Data.Price then
                firetouchinterest(plr.Character.HumanoidRootPart, Data.Button.Head, 0) 
                firetouchinterest(plr.Character.HumanoidRootPart, Data.Button.Head, 1) 
                end
                wait()
            until AutoBuyButtonsCash == false
        end
    end
})


ABBSection:Label({
    Text = "Gems Auto Buyer"
})

getgenv().AutoBuyButtonsGems = false
local AutoBuyButtonsGems = getgenv().AutoBuyButtonsGems
ABBSection:Toggle({
    Text = "Enable",
    Callback = function(v)
        AutoBuyButtonsGems = v
        if v == true then
            repeat
                local Data = GetCheapestButton({Type = "Gems", Tycoon = Tycoon})
                if tonumber(plr.Eco.cash.Value) >= Data.Price then
                firetouchinterest(plr.Character.HumanoidRootPart, Data.Button.Head, 0) 
                firetouchinterest(plr.Character.HumanoidRootPart, Data.Button.Head, 1) 
                end
                wait()
            until AutoBuyButtonsGems == false
        end
    end
})

getgenv().AutoCollectMissions = false
local AutoCollectMissions = getgenv().AutoCollectMissions
ACMSection:Toggle({
    Text = "Enable",
    Callback = function(v) 
        AutoCollectMissions = v
        if v == true then
            repeat
                for _,v in pairs(plr.PlayerGui.ScreenMisson.Frame.bg.Main:GetChildren()) do
                    if v:IsA("Frame") then
                        if v.Reward.Go.BackgroundColor3 == Color3.fromRGB(109, 195, 254) then
                        game:GetService("ReplicatedStorage").Remote.Event.Misson["[C-S]TryGetMissonReward"]:FireServer(v.Name)
                        end
                    end
                end
            wait(1)
            until AutoCollectMissions == false
        end
    end
})

getgenv().AntiIdleKick = false
local AntiIdleKick = getgenv().AntiIdleKick
AIKSection:Toggle({
    Text = "Enable",
    Callback = function(v) 
        AntiIdleKick = v
    end
})


LPSection:Slider({
    Text = "WalkSpeed",
    Default = 16,
    Minimum = 16,
    Maximum = 100,
    Callback = function(v)
        pcall(function() plr.Character.Humanoid.WalkSpeed = v end)
    end
})

SSection:Button({
    Text = "Rejoin",
    Callback = function(e) 
        game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
    end
})


MainTab:Select()

local Hook = {
    WalkSpeed
}

Hook.WalkSpeed = hookmetamethod(game, "__index", function(self, ...)
    if ... == "WalkSpeed" then
        return 16
    end
    return Hook.WalkSpeed(self, ...) 
end)

pcall(function()
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
end)

local VU = game:GetService("VirtualUser")
plr.Idled:connect(function()
	if AntiIdleKick == true then
    	VU:Button2Down(Vector2.new(0,0), game:GetService("workspace").CurrentCamera.CFrame)
    	wait(1)
        VU:Button2Up(Vector2.new(0,0), game:GetService("workspace").CurrentCamera.CFrame)
	end
end)
