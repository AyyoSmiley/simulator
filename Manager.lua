local Players = game:GetService("Players")
local player =  Players.LocalPlayer

local currencyGUI = script.Parent
local currencyHolderFrame = currencyGUI:FindFirstChild("CurrencyHolder")
local RubberbandsFrame =currencyHolderFrame:FindFirstChild("Rubberbands")
local CoinsFrame = currencyHolderFrame:FindFirstChild("Coins")



local function changeValue(name: string, amount: number)
	if name == "Rubberbands" then
		RubberbandsFrame.Amount.Text = amount.."/50"
		else if name == "Coins" then
	CoinsFrame.Amount.Text = amount
		end
		
	end
end

repeat wait(1) until player:FindFirstChild("leaderstats")

changeValue("Rubberbands", player.leaderstats.Rubberbands.Value)
changeValue("Coins", player.leaderstats.Coins.Value)

player.leaderstats.Coins.Changed:Connect(function()
	changeValue("Coins", player.leaderstats.Coins.Value)
end)

player.leaderstats.Rubberbands.Changed:Connect(function()
	changeValue("Rubberbands", player.leaderstats.Rubberbands.Value)
end)

