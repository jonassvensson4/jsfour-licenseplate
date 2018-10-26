local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local ESX	  = nil
local plate = nil

-- ESX
Citizen.CreateThread(function()
  SetNuiFocus(false, false)

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Menu
RegisterNetEvent('jsfour-licenseplate')
AddEventHandler('jsfour-licenseplate', function()
  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'licenseplate_menu',
	{
		title    = 'Licenseplate menu',
    align    = 'bottom-right',
		elements = {
			{label = 'Change number', value = 'change'},
			{label = 'Apply to car', value = 'apply'},
		}
	},
	function(data, menu)
		local val = data.current.value

		if val == 'change' then
      SetNuiFocus(true, true)
      SendNUIMessage({
        action = "open"
      })
    else
      if plate ~= nil then
        local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

        if distance ~= -1 and distance <= 3.0 then
          local oldplate = GetVehicleNumberPlateText(vehicle)

          ESX.TriggerServerCallback('jsfour-licenseplate:update', function( cb )
            if cb == 'found' then
              ESX.UI.Menu.CloseAll()
              SetVehicleNumberPlateText(vehicle, plate)
              plate = nil
            elseif cb == 'error' then
              ESX.ShowNotification('You couldnt apply the license plate')
            end
          end, oldplate, plate)
        else
          ESX.ShowNotification('No vehicle nearby')
        end
      else
        ESX.ShowNotification('Cant apply empty plate')
      end
		end
	end,
	function(data, menu)
		menu.close()
	end
)
end)

-- NUI Callback - close
RegisterNUICallback('escape', function(data, cb)
  plate = data.number
	SetNuiFocus(false, false)
end)
