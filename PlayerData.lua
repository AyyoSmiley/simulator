local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local RunService = game:GetService("RunService")



local dataStore = DataStoreService:GetDataStore("test")

local function givePlayerCurrency(Player)
	
	while true do
		task.wait(1)
		Player.leaderstats.Rubberbands.Value += 1
		Player.leaderstats.Coins.Value += 1
	end
end

local function waitForRequestBudget(requestType)
	local currentBudget = DataStoreService:GetRequestBudgetForRequestType(requestType)
	while currentBudget < 1 do
		currentBudget = DataStoreService:GetRequestBudgetForRequestType(requestType)
		task.wait(5)
	end

local function setUpPlayerData(player)
	local UserId = player.UserId
	local key = "Player_"..UserId
	
	local leaderstats = Instance.new("Folder", player)
		leaderstats.Name  = "leaderstats"
		



		

	
	local Rubberbands = Instance.new("IntValue", leaderstats)
	Rubberbands.Name = "Rubberbands"
	Rubberbands.Value = "0"
	
	local Coins = Instance.new("IntValue", leaderstats)
	Coins.Name =  "Coins"
	Coins.Value = "0"
	
		local success, returnValue
		repeat
			waitForRequestBudget(Enum.DataStoreRequestType.GetAsync)
			success, returnValue = pcall(dataStore.getAsync, dataStore, key)
		until success or not Players:FindFirstChild(player.Name)
	
	if success then
		if returnValue == nil then
			returnValue = {
			Rubberbands = 0,
			Coins = 0,
		}
	end
		
		print(returnValue)
			Rubberbands.Value = if returnValue.Rubberbands ~= nil then returnValue.Rubberbands else 0
			Coins.Value = if returnValue.Coins ~= nil then returnValue.Coins else 0
		
		
else
		player:Kick("There was an error loading your Data! Roblox's DataStore might be down, try again later, or contact us through our Group!")
		print(player.Name.."Data Loading ERROR!!!")
end

	givePlayerCurrency(player)
	
end

local function save(player)
	local UserId = player.UserId
	local key = "Player_"..UserId
	
	local Rubberbands = player.leaderstats.Rubberbands.Value
	local coins = player.leaderstats.Coins.Value
	
	local dataTable = {
		Rubberbands = Rubberbands,
		Coins= coins,
	}
	print(dataTable)
		local success, returnValue
		repeat
			waitForRequestBudget(Enum.DataStoreRequestType.GetAsync)
		success, returnValue = pcall(dataStore.updateAsync, dataStore, key, function()
		return dataTable
		end)
		until success 
	
	if success then
		print("Data Saved!")
	else
		print("Data Saving Error!!!")
	end
	end


local function OnShutdown()
	if RunService:IsStudio() then
		task.wait(2)
	else
		local finished = Instance.new("BindableEvent")
		local allPlayers = Players:GetPlayers()
		local leftPlayers = #allPlayers
		
		for _, player in ipairs(allPlayers) do
			coroutine.wrap(function()
				save(player)
				leftPlayers -= 1
				if leftPlayers == 0 then
					finished:Fire()
				end
			end)()
		end
		finished.Event:Wait()
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	coroutine.wrap(setUpPlayerData)(player)
end

Players.PlayerAdded:Connect(setUpPlayerData)
Players.PlayerRemoving:Connect(save)
game:BindToClose(OnShutdown)

while true do
	task.wait(600)
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(save)(player)
		end
	end
end