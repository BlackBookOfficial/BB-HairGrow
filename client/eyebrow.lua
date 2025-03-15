local Config = require("config")
local Notifications = require("notifications")

local currentSkinData = {}

Citizen.CreateThread(function()
    local skinData = nil
    while true do
        local waitTime = (Config.browEnabled and Config.browMinutes or 100000000)
        Citizen.Wait(math.min(waitTime, (Config.enableNotifications and Config.notifyInterval or 100000000) * 60000))

        if Config.browEnabled then
            TriggerEvent('skinchanger:getSkin', function(data)
                skinData = data
            end)

            if skinData then
                if not currentSkinData['eyebrows_2'] then
                    currentSkinData['eyebrows_2'] = skinData['eyebrows_2']
                end

                local needsSave = false

                -- Grow Process
                if skinData['eyebrows_2'] > 1 and skinData['eyebrows_2'] < 10 then
                    skinData['eyebrows_2'] = skinData['eyebrows_2'] + 1
                    needsSave = true
                    currentSkinData['eyebrows_2'] = skinData['eyebrows_2']
                end

                -- Notification Process (only if enabled)
                if Config.enableNotifications then
                    local brows = skinData['eyebrows_2']
                    local notificationMessage = Notifications.brow[brows]

                    if brows == 10 then
                        notificationMessage = Notifications.level10.brow[math.random(1, 2)]
                    end

                    if notificationMessage then
                        exports['mythic_notify']:DoHudText('inform', notificationMessage, 5000)
                    end
                end

                if needsSave then
                    TriggerEvent('skinchanger:loadSkin', skinData)
                    TriggerServerEvent('esx_skin:save', skinData)
                end
                skinData = nil
            end
        end
    end
end)
