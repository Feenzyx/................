local config = require(script.Parent.Config)
local economie = config.GeldSysteem
local frame = game.StarterGui["fx-cardealer"].ScrollingFrame
local source
local keys = "lol"

if config.Key == keys then
	print("Valid Key")
else
	print("Invalid Key")
end


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

