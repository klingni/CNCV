RegisterServerEvent('cnc:baseevents:onPlayerDied')
RegisterServerEvent('cnc:baseevents:onPlayerKilled')
RegisterServerEvent('cnc:baseevents:onPlayerWasted')
RegisterServerEvent('cnc:baseevents:enteringVehicle')
RegisterServerEvent('cnc:baseevents:enteringAborted')
RegisterServerEvent('cnc:baseevents:enteredVehicle')
RegisterServerEvent('cnc:baseevents:leftVehicle')

AddEventHandler('cnc:baseevents:onPlayerKilled', function(killedBy, data)
	local victim = source

	RconLog({msgType = 'playerKilled', victim = victim, attacker = killedBy, data = data})
	print('PlayerKilled: VICTIM:'.. victim .. " // ATTACKER: " .. killedBy)
end)


AddEventHandler('cnc:baseevents:onPlayerDied', function(killedBy, pos)
	local victim = source

	RconLog({msgType = 'playerDied', victim = victim, attackerType = killedBy, pos = pos})
	print('PlayerDied: VICTIM:'.. victim .. " // KILLED BY: " .. killedBy)

end)


AddEventHandler("cnc:baseevents:onPlayerDied", function()
    print("CNC BaseEvent DIED")
end)


AddEventHandler("cnc:baseevents:onPlayerWasted", function()
    print("CNC BaseEvent WASTED")
end)

AddEventHandler("cnc:baseevents:enteredVehicle", function()
	print("CNC BaseEvent ENTERED Vehicle")
	TriggerClientEvent("cnc:baseevents:enteredVehicle:checked", source)
end)

AddEventHandler("cnc:baseevents:leftVehicle", function()
	print("CNC BaseEvent LEFT Vehicle")
	TriggerClientEvent("cnc:baseevents:leftVehicle:checked", source)
end)