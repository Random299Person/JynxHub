local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local placeName = MarketplaceService:GetProductInfo(game.PlaceId).Name
local isJynx = jynx
local loadingText = "by the Jynx team"
if isJynx then
   loadingText = "Hello, fellow jynx-er!"
end

local supportedGames = {893973440}
if not table.find(supportedGames, game.PlaceId) then
   Rayfield:Notify({
      Title = "Jynx Loading Error",
      Content = "JynxHub does not support " .. placeName .. " at this time.",
      Duration = 6.5,
      Image = 12230941634,
      Actions = { -- Notification Buttons
         Ignore = {
            Name = "Close"
         },
      },
   })
   return
end

local Window = Rayfield:CreateWindow({
   Name = "JynxHub - " .. placeName,
   LoadingTitle = "JynxHub v1.0 is loading",
   LoadingSubtitle = loadingText,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "JynxHubBeta", -- Create a custom folder for your hub/game
      FileName = "game-" .. game.PlaceId
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

if game.PlaceId == 893973440 then
   local ui_Visual = Window:CreateTab("Visual", 13321848342) -- Title, Image
   local ui_Visual_ESP = ui_Visual:CreateSection("ESP")

   --Player ESP
   local playerESP = {}
   local ui_Visual_ESP_Players = ui_Visual:CreateDropdown({
      Name = "Players",
      Options = {"Off", "Beast only", "All"},
      CurrentOption = {"Off"},
      MultipleOptions = false,
      Flag = "visual.esp.players", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
      Callback = function(Option)
         for _, espPart in pairs(playerESP) do
            if espPart.FillColor == Color3.new(1, 0, 0) then
               espPart.Enabled = Option ~= "Off"
            else
               espPart.Enabled = Option == "All"
            end
         end
      end,
   })

   function newCharacter(player, character)
      if player == localPlayer then
         localCharacter = character
      else
         local espPart = Instance.new("Highlight", character)
         espPart.Name = "ESP"
         espPart.FillColor = Color3.new(0, 0, 1)
         espPart.OutlineColor = Color3.new(1, 1, 1)
         espPart.FillTransparency = 0.5
         espPart.OutlineTransparency = 0.5
         espPart.Enabled = ui_Visual_ESP_Players.CurrentValue == "All"
         character.ChildAdded:Connect(function(child)
               if child:IsA("Tool") then
                  espPart.FillColor = Color3.new(1, 0, 0)
                  espPart.OutlineColor = Color3.new(1, 0, 0)
                  espPart.Enabled = ui_Visual_ESP_Players.CurrentValue ~= "Off"
               end
         end)
         character.ChildRemoved:Connect(function(child)
               if child:IsA("Tool") then
                  espPart.FillColor = Color3.new(0, 0, 1)
                  espPart.OutlineColor = Color3.new(1, 1, 1)
                  espPart.Enabled = ui_Visual_ESP_Players.CurrentValue == "All"
               end
         end)

         playerESP[player] = espPart

         espPart.Destroying:Wait()
         if playerESP[player] == espPart then
            playerESP[player] = nil
         end
      end
   end

   function newPlayer(player)
      if player.Character then
         newCharacter(player, player.Character)
      end
      player.CharacterAdded:Connect(function(character)
         newCharacter(player, character)
      end)
   end

   for _, a in ipairs(Players:GetPlayers()) do
      newPlayer(a)
   end
   Players.PlayerAdded:Connect(newPlayer)

   --Computer ESP
   local computerESP = {}
   local ui_Visual_ESP_Computers
   ui_Visual_ESP_Computers = ui_Visual:CreateDropdown({
      Name = "Computers",
      Options = {"Off", "Hide hacked", "On"},
      CurrentOption = {"Off"},
      MultipleOptions = false,
      Flag = "visual.esp.computers", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
      Callback = function(Value)
         for _, espPart in pairs(computerESP) do
            if espPart.FillColor == Color3.fromRGB(40, 127, 71) then
               espPart.Enabled = Value == "On"
            else
               espPart.Enabled = Value ~= "Off"
            end
         end
      end,
   })
   workspace.DescendantAdded:Connect(function(child)
      if child.Name == "Screen" and child.Parent.Name == "ComputerTable" then
         local espPart = Instance.new("Highlight", child.Parent)
         espPart.Name = "ESP"
         espPart.FillColor = child.Color
         espPart.Enabled = ui_Visual_ESP_Computers.CurrentValue ~= "Off"
         espPart.FillTransparency = 0.5
         espPart.OutlineTransparency = 1
         child:GetPropertyChangedSignal("Color"):Connect(function()
               espPart.FillColor = child.Color
               if child.Color == Color3.fromRGB(40, 127, 71) then
                  espPart.Enabled = ui_Visual_ESP_Computers.CurrentValue == "On"
               else
                  espPart.Enabled = ui_Visual_ESP_Computers.CurrentValue ~= "Off"
               end
         end)
         computerESP[child.Parent] = espPart

         espPart.Destroying:Wait()
         computerESP[child.Parent] = nil
      end
   end)
end
