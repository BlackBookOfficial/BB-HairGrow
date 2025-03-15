local Config = require("config")
local Notifications = require("notifications")

local currentSkinData = {}

Citizen.CreateThread(function()
    local skinData = nil
    while true do
        local waitTime = (Config.beardEnabled and Config.beardMinutes or 100000000) --Extremely long if disabled.
        Citizen.Wait(math.min(waitTime, (Config.enableNotifications and Config.notifyInterval or 100000000) * 60000))

        if Config.beardEnabled then
            TriggerEvent('skinchanger:getSkin', function(data)
                skinData = data
            end)

            if skinData then
                if not currentSkinData['beard_2'] then
                    currentSkinData['beard_2'] = skinData['beard_2']
                end

                local needsSave = false

                -- Grow Process
                if skinData['beard_2'] > 1 and skinData['beard_2'] < 10 then
                    skinData['beard_2'] = skinData['beard_2'] + 1
                    needsSave = true
                    currentSkinData['beard_2'] = skinData['beard_2']
                end

                -- Notification Process (only if enabled)
                if Config.enableNotifications then
                    local beard = skinData['beard_2']
                    local notificationMessage = Notifications.beard[beard]

                    if beard == 10 then
                        notificationMessage = Notifications.level10.beard[math.random(1, 2)]
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
