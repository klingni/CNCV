

RegisterNetEvent("CNC:showNotification")

Citizen.CreateThread(function()
	AddEventHandler("CNC:showNotification", function(text)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(text)
		DrawNotification(0,1)
	end)
end)