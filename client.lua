local PlayerData              = {}
local isInMarker              = false



ESX                           = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end

  while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

  ESX.PlayerData = ESX.GetPlayerData()

end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	Citizen.Wait(5000)
end)


Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

            local coords = GetEntityCoords(GetPlayerPed(-1))

  
            for k,v in pairs(Config.Marker) do
                if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) and Config.EnableJob and (ESX.PlayerData.job and ESX.PlayerData.job.name == Config.Job.name) then

                  DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)

                elseif (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) and not Config.EnableJob then

                  DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)

                end
              
            end
          
    end
end)



AddEventHandler('easyteleport:teleport', function(position)
  if IsPedInAnyVehicle(GetPlayerPed(-1), true) and Config.EnableVehicleTeleport then
    SetEntityCoords(GetVehiclePedIsUsing(GetPlayerPed(-1)), position.x, position.y, position.z)
    SetEntityHeading(GetVehiclePedIsUsing(GetPlayerPed(-1)), heading.heading)
  else

    SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
    SetEntityHeading(GetPlayerPed(-1), heading.heading)
  end  

end)


Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      local coords      = GetEntityCoords(GetPlayerPed(-1))
      local position    = nil
      local zone        = nil
  
      
          for k,v in pairs(Config.Marker) do
            if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) and Config.EnableJob and (ESX.PlayerData.job and ESX.PlayerData.job.name == Config.Job.name) then

              isInMarker = true
              position = v.Teleport
              heading = v.Teleport
              zone = v

              SetTextComponentFormat("STRING")
              AddTextComponentString(Config.MSG)
              DisplayHelpTextFromStringLabel(0,0,1,-1)    

              break
            elseif (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) and not Config.EnableJob then
              isInMarker = true
              position = v.Teleport
              heading = v.Teleport
              zone = v

              SetTextComponentFormat("STRING")
              AddTextComponentString(Config.MSG)
              DisplayHelpTextFromStringLabel(0,0,1,-1)    

              break
            else
              isInMarker  = false
            end
          end
  
          if IsControlJustReleased(1, 38) and isInMarker then
            TriggerEvent('easyteleport:teleport', position)
          end
  
  
  
    end
end)


  

