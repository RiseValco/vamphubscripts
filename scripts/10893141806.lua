--[[
db    db  .d8b.  .88b  d88. d8888b. db   db db    db d8888b. 
88    88 d8' `8b 88'YbdP`88 88  `8D 88   88 88    88 88  `8D 
Y8    8P 88ooo88 88  88  88 88oodD' 88ooo88 88    88 88oooY' 
`8b  d8' 88~~~88 88  88  88 88~~~   88~~~88 88    88 88~~~b. 
 `8bd8'  88   88 88  88  88 88      88   88 88b  d88 88   8D 
   YP    YP   YP YP  YP  YP 88      YP   YP ~Y8888P' Y8888P'
]]--
-- [[ GNU General Public License @ 2022 Vamp Hub ]]--
-- https://www.roblox.com/games/10893141806/Truck-Factory-Tycoon
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RiseValco/vamphubscripts/main/Library.lua'))()
local Flags = Library.Flags

local request = http_request or request or HttpPost or syn.request
local options = {Url = "https://raw.githubusercontent.com/RiseValco/vamphubscripts/main/anc.txt", Method = "GET"}
local res = request(options)

local Window = Library:Window({
    Text = "Truck Factory Tycoon - VampHub | "..res.Body
})

local LocalTab = Window:Tab({
    Text = "Main"
})

local AutoFunctionsrSection = LocalTab:Section({
    Text = "Functions"
})

local TrollingSection = LocalTab:Section({
    Text = "Fun",
    Side = "Right"
})

local TeleportSection = LocalTab:Section({
    Text = "Teleport"
})

local MiscSection = LocalTab:Section({
    Text = "Misc",
    Side = "Right"
})

local HTTP = game:GetService("HttpService")
local plr = game:GetService("Players").LocalPlayer

function PrefixNumber(v)
  return tostring(math.floor(v)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end

function GetTycoon() 
local Tycoon = nil
 for _,v in pairs(game:GetService("Workspace").Tycoon.Tycoons:GetChildren()) do
  if tostring(v.TycoonInfo.Owner.Value) == plr.Name then
      Tycoon = v
  end
 end
 return Tycoon
end

function GetNextButton()
    local Tycoon = GetTycoon()
    local Button = nil
    local Price = 9e+8
    for _,v in pairs(Tycoon.Buttons:GetChildren()) do
        pcall(function()
        if v.Head.Transparency ~= 1 and v:FindFirstChild("Devproduct") == nil and v.Price.Value < Price then
            Button = v
            Price = v.Price.Value
        end
        end)
    end
    return Button
end

getgenv().AutoCollectCash = false
AutoFunctionsrSection:Toggle({
    Text = "Auto Collect Cash",
    Callback = function(v)
       if v == true then
           getgenv().AutoCollectCash = true
        else
            getgenv().AutoCollectCash = false
       end
    end
})

local Tycoon2 = GetTycoon()
Tycoon2.Essentials.DefaultCollector.CashCollector.Part.SurfaceGui.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
    if getgenv().AutoCollectCash == true then
    pcall(function()
    firetouchinterest(plr.Character.HumanoidRootPart, Tycoon2.Essentials.DefaultCollector.Trigger, 0)
    firetouchinterest(plr.Character.HumanoidRootPart, Tycoon2.Essentials.DefaultCollector.Trigger, 1)    
    end)
    end
end)

local AutoBuyButtonsDelay 
AutoFunctionsrSection:Slider({
    Text = "Auto Buy Buttons Delay",
    Default = 1,
    Minimum = 1,
    Maximum = 50,
    Tooltip = "TIP: this is in seconds",
    Callback = function(v)
        AutoBuyButtonsDelay = v
        print(v)
    end
})
getgenv().AutoBuyButtons = false
AutoFunctionsrSection:Toggle({
    Text = "Auto Buy Buttons",
    Tooltip = "TIP: Finds the cheapest button to buy",
    Callback = function(v) 
        if v == true then
           getgenv().AutoBuyButtons = true
           repeat
            task.wait(AutoBuyButtonsDelay)
            pcall(function()
                local Button = GetNextButton()
                print(plr.leaderstats.Money.Value, Button.Price.Value)
                if plr.leaderstats.Money.Value >= Button.Price.Value then
                firetouchinterest(plr.Character.HumanoidRootPart, Button.Head, 0)  
                firetouchinterest(plr.Character.HumanoidRootPart, Button.Head, 1)
                end
            end)
           until getgenv().AutoBuyButtons == false
           else
               getgenv().AutoBuyButtons = false
            
        end
    end
})

TrollingSection:Label({
    Text = "Set fake coins",
    Tooltip = "TIP: This sets a fake amount of coins on your GUI"
})

TrollingSection:Input({
    Placeholder = "9999999",
    Callback = function(v)
       pcall(function()plr.PlayerGui.ScreenGui.Money.Amount.Text = "$"..PrefixNumber(v)end) 
    end
})

TrollingSection:Label({
    Text = "Set fake coins (SIGN)",
    Tooltip = "TIP: This sets a fake amount of coins on your Starter SIGN"
})

local signFakeCash = 9999999
TrollingSection:Input({
    Text = "9999999",
    Placeholder = "9999999",
    Callback = function(v)
      signFakeCash = v
    end
})

getgenv().SetFakeCoinsSign = false
TrollingSection:Toggle({
    Text = "Set Fake Coins",
    Callback = function(v)
        if v == true then
           getgenv().SetFakeCoinsSign = true
           local Tycoon = GetTycoon()
           repeat
               task.wait()
               pcall(function()Tycoon.Essentials.DefaultCollector.CashCollector.Part.SurfaceGui.TextLabel.Text = "$"..PrefixNumber(signFakeCash)end)
           until getgenv().SetFakeCoinsSign == false
           else
            getgenv().SetFakeCoinsSign = false
        end
    end
})

TrollingSection:Toggle({
    Text = "Low Gravity",
    Tooltip = "TIP: Changes your gravity to low gravity",
    Callback = function(v)
        if v == true then
        game:GetService("Workspace").Gravity = 10
        else
            game:GetService("Workspace").Gravity = 196.2
        end
    end
})

function GetTycoons()
    local Tycoons = {}
    local PlrTycoon = GetTycoon()
    for _,v in pairs(game:GetService("Workspace").Tycoon.Tycoons:GetChildren()) do
        if v.Name == PlrTycoon.Name then
            table.insert(Tycoons, v.Name.." (YOURS)")
            else
            table.insert(Tycoons, v.Name)
        end
    end
    return Tycoons
end

local TycoonTeleports = TeleportSection:Dropdown({
    Text = "Tycoons",
    List =  GetTycoons(),
    Tooltip = "TIP: Teleports you to the tycoon you select",
    Flag = "Choosen",
    Callback = function(v)
       if string.find(v, "(YOURS)") then
         pcall(function()plr.Character.HumanoidRootPart.CFrame = GetTycoon().Essentials.Spawn.CFrame * CFrame.new(0, 2, 0);end)
        else
            pcall(function()plr.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Tycoon.Tycoons:FindFirstChild(v).Essentials.Spawn.CFrame * CFrame.new(0, 2, 0);end)
        end
    end
})

local OtherTeleports = TeleportSection:Dropdown({
    Text = "Other",
    List =  {"Gamepass Shop"},
    Tooltip = "TIP: Teleports you to the area you select",
    Flag = "Choosen",
    Callback = function(v)
       pcall(function()
        if v == "Gamepass Shop" then   
           plr.Character.HumanoidRootPart.CFrame = CFrame.new(-635, 90, -529)
        end
       end)
    end
})

MiscSection:Button({
    Text = "Rejoin",
    Callback = function(e) 
        game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
    end
})

LocalTab:Select()

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
