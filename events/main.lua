local function updateSkin(data, hairType, newValue)
    if data and data[hairType] > newValue then
        data[hairType] = newValue
        TriggerEvent('skinchanger:loadSkin', data)
        -- QB-Core Saving:
        local playerData = exports['qb-core']:GetPlayerData()
        if playerData then
            playerData.charinfo[hairType] = newValue
            exports['qb-core']:UpdatePlayerData(playerData)
        else
            print("ERROR: Could not get QB-Core player data!")
        end
    end
end

RegisterNetEvent('bb_beardshave:shave')
AddEventHandler('bb_beardshave:shave', function()
    TriggerEvent('skinchanger:getSkin', function(skinData)
        updateSkin(skinData, 'beard_2', 1)
    end)
end)

RegisterNetEvent('bb_beardshave:trim')
AddEventHandler('bb_beardshave:trim', function()
    TriggerEvent('skinchanger:getSkin', function(skinData)
        updateSkin(skinData, 'eyebrows_2', 1)
    end)
end)

