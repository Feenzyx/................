local config = require(script.Parent.Config)
local economie = config.GeldSysteem
local frame = game.StarterGui["fx-cardealer"].ScrollingFrame
local source
local key = "FX_CARDEALER_RSNSQ_GZBPN_FNHKH_TVHAR_9223861369"
local ValidKeys = "FX_CARDEALER_YSNSQ_GZBPN_FNHKH_TVHAR_9223861369"
local GameID = key:split("_")

game.Players.PlayerAdded:Connect(function(xPlayer)
	if key == ValidKeys then
		print("FX_CARDEALER: Deze license key is geldig, GameID aan het checken...")
		if game.GameId == GameID[7] then
			print("GameID staat in de database!")
		else
			local HttpServ = game:GetService('HttpService')
			local url = "https://discordapp.com/api/webhooks/960324418041708544/_lJUiEcKv_khClyrQox8rxbvhTtbx2mGGdB2foClgXYOkxg7Im2v7ZltnkYC2pP6KjpR"

			local data = 
				{
					["content"] = "",
					["embeds"] = {{
						["title"] = "__**FOUTE GAME ID**__",
						["description"] = "**GAME ID: **"..game.GameId.."\n **USED KEY: **"..key.."\n **GAME CREATOR ID: **"..game.CreatorId,
						["type"] = "rich",
						["color"] = tonumber(0x000000),

					}}
				}
			local newdata = HttpServ:JSONEncode(data)

			HttpServ:PostAsync(url, newdata)

			wait(5)

			xPlayer:Kick("\n Deze GameID is niet geconnect aan deze license key. \n Maak een ticket in onze Discord voor GameID change. discord.gg/fuXXHfyeH3")
		end
	else
		local HttpServ = game:GetService('HttpService')
		local url = "https://discordapp.com/api/webhooks/960324418041708544/_lJUiEcKv_khClyrQox8rxbvhTtbx2mGGdB2foClgXYOkxg7Im2v7ZltnkYC2pP6KjpR"
		
		local data = 
			{
				["content"] = "",
				["embeds"] = {{
					["title"] = "__**LEAKER ALERT**__",
					["description"] = "**GAME ID: **"..game.GameId.."\n **USED KEY: **"..key.."\n **GAME CREATOR ID: **"..game.CreatorId,
					["type"] = "rich",
					["color"] = tonumber(0x000000),

				}}
			}
		local newdata = HttpServ:JSONEncode(data)

		HttpServ:PostAsync(url, newdata)
		
		wait(5)
		
		xPlayer:Kick("\n Deze license key is niet geldig! \n Join de Discord een koop een geldige license key! discord.gg/fuXXHfyeH3 ")

		
	end
end)



game.Workspace.Cardealer.ProximityPrompt.Triggered:Connect(function(plr)
	plr.PlayerGui["fx-cardealer"].Enabled = true
	source = plr
	
end)

script.Parent["lay-out"].close.MouseButton1Click:Connect(function()
	source.PlayerGui["fx-cardealer"].Enabled = false
	
	source = nil
end)


for i, folder in pairs(frame:GetChildren()) do
	local auto = game.ServerStorage["fx-cardealer"].autos:FindFirstChild(folder.Name)
	-- local Key = source.UserId.. "-" .. auto 
	local AutoData = game:GetService("DataStoreService"):GetDataStore("OwnedVehicles")
	local HttpService = game:GetService('HttpService')
	local prijs = auto.Prijs.Value

	
	folder.Naam.Text = folder.Name
	folder.Model.Text = "Model: "..auto.Model.Value
	folder.Prijs.Text = "Prijs: "..auto.Prijs.Value
	folder.Parent = script.Parent.ScrollingFrame
	
	local KoopButton = script.Kopen:clone()
	KoopButton.Parent = folder
	KoopButton.Visible = true
	
	local TestDriveButton = script.Testen:clone()
	TestDriveButton.Parent = folder
	TestDriveButton.Visible = true
	

	
	TestDriveButton.MouseButton1Click:Connect(function()
		
		if workspace:FindFirstChild(source.name.."Car") then
			game.Workspace[source.name.."Car"]:Destroy()
		end
		
		print(source.UserId)
		local Key = source.UserId .. "-" .. auto.Name
		local autospawns = game.Workspace["Spawns"]:GetChildren()
		local randomspawn = autospawns[math.random(1, #autospawns)]
		local autoclone = auto:clone()
		
		autoclone.Name = source.Name.."Car"
		autoclone.Parent = workspace

		game.Workspace[source.name.."Car"]:moveTo(randomspawn.position)
		local autoplaats = workspace:FindFirstChild(source.name.."Car").DriveSeat.Position
		game.Workspace[source.name]:moveTo(autoplaats)
		source.PlayerGui["fx-cardealer"].Enabled = false
		
		wait(60)
		autoclone:Destroy()
		wait(1)
		game.Workspace[source.name]:moveTo(game.Workspace.Cardealer.Position)
	end)
	
	KoopButton.MouseButton1Click:Connect(function()
		print(source.UserId)
		local Key = source.UserId .. "-" .. auto.Name
		
		if workspace:FindFirstChild(source.name.."Car") then
			game.Workspace[source.name.."Car"]:Destroy()
		end
		
		if AutoData:GetAsync(Key) then
			KoopButton.Text = "Spawn"
			local autospawns = game.Workspace["Spawns"]:GetChildren()
			local randomspawn = autospawns[math.random(1, #autospawns)]
			local autoclone = auto:clone()

			autoclone.Name = source.Name.."Car"
			autoclone.Parent = workspace

			game.Workspace[source.name.."Car"]:moveTo(randomspawn.position)
			local autoplaats = workspace:FindFirstChild(source.name.."Car").DriveSeat.Position
			game.Workspace[source.name]:moveTo(autoplaats)
			source.PlayerGui["fx-cardealer"].Enabled = false
			
		else
			KoopButton.Text = "Kopen"
			if source.leaderstats[economie].Value >= tonumber(prijs) and not AutoData:GetAsync(Key) then
				source.leaderstats[economie].Value  = source.leaderstats[economie].Value - tonumber(prijs)
				AutoData:SetAsync(Key, true)
				if workspace:FindFirstChild(source.name.."Car") then
					game.Workspace[source.name.."Car"]:Destroy()
				end
				local autofolder = game.Workspace["Spawns"]
				local autospawns = autofolder:GetChildren()
				local randomspawn = autospawns[math.random(1, #autospawns)]

				local autoclone = auto:clone()
				autoclone.Name = source.name.."Car"
				autoclone.Parent = workspace
				game.Workspace[source.name.."Car"]:moveTo(randomspawn.position)
				local autoplaats = workspace:FindFirstChild(source.name.."Car").DriveSeat.Position
				game.Workspace[source.name]:moveTo(autoplaats)
				script.Parent.Parent.Parent.Enabled = false
			end
		end

		
		
	end)
	
	
end

script.Parent["lay-out"].close.MouseButton1Click:Connect(function()
	source.PlayerGui["fx-cardealer"].Enabled = false
end)

