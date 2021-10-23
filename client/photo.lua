-- Author: Xinerki (https://forum.fivem.net/t/release-cellphone-camera/43599)



-- QBCore = nil

local hasCinematic = false

local QBCore = exports['qb-core']:GetCoreObject()

phone = false
phoneId = 0

RegisterNetEvent('camera:open')
AddEventHandler('camera:open', function()
	CreateMobilePhone(1)
	CellCamActivate(true, true)
	phone = true
	-- ePhoneOutAnim()
end)

frontCam = false

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

TakePhoto = N_0xa67c35c56eb1bd9d
WasPhotoTaken = N_0x0d6ca79eeebd8ca3
SavePhoto = N_0x3dec726c25a11bac
ClearPhoto = N_0xd801cc02177fa3f1

function ResetHUD()
	SendNUIMessage({openCinema = false})
	QBCore.UI.HUD.SetDisplay(1.0)

	DisplayRadar(true)
end

Citizen.CreateThread(function()
	DestroyMobilePhone()
	while true do
		Citizen.Wait(0)
		
		if IsControlJustPressed(1, 27) or IsControlJustPressed(1, 177) and phone == true then -- CLOSE PHONE
			DestroyMobilePhone()
			phone = false
			
			CellCamActivate(false, false)
			if firstTime == true then
				firstTime = false
				Citizen.Wait(2500)
				displayDoneMission = true
			end
		end
		
		if IsControlJustPressed(1, 27) and phone == true then -- SELFIE MODE
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
		end
		
		if IsControlJustPressed(1, 176) and phone == true then -- TAKE.. PIC LEFT MOUSE BUTTON
			TakePhoto()
			if (WasPhotoTaken() and SavePhoto(-1)) then
				ClearPhoto()
			end
		end
		
		if phone == true then
			if IsControlJustPressed(1, 176) then
				QBCore.UI.HUD.SetDisplay(0.0)
				TriggerEvent('es:setMoneyDisplay', 0.0)
				TriggerEvent('QBCore_status:setDisplay', 0.0)
				TriggerEvent('ui:toggle', false)
				TriggerEvent('ui:togglespeedo')
				DisplayRadar(false)
				Citizen.Wait(250)
				ResetHUD()
				DestroyMobilePhone()
				phone = false
				
				CellCamActivate(false, false)
				if firstTime == true then
					firstTime = false
					Citizen.Wait(2500)
					displayDoneMission = true
				end
			end
		end
		
		-- ren = GetMobilePhoneRenderId()
		-- SetTextRenderId(ren)
		
		-- Everything rendered inside here will appear on your phone.
		
		-- SetTextRenderId(1) -- NOTE: 1 is default
	end
end)
