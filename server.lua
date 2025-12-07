local cooldowns = {}
local activeReports = {}
local reportCount = 0

RegisterNetEvent('admin_reports:sendReport')
AddEventHandler('admin_reports:sendReport', function(reason)
    local _source = source
    local playerName = GetPlayerName(_source)

    if not reason or reason == '' then
        return
    end

    -- Cooldown check
    if cooldowns[_source] and os.time() - cooldowns[_source] < Config.Cooldown then
        local remaining = Config.Cooldown - (os.time() - cooldowns[_source])
        TriggerClientEvent('chat:addMessage', _source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", string.format(Config.Lang['report_cooldown'], remaining)}
        })
        return
    end

    cooldowns[_source] = os.time()
    reportCount = reportCount + 1

    -- Store report
    local newReport = {
        id = reportCount,
        source = _source,
        name = playerName,
        reason = reason,
        time = os.date("%H:%M")
    }
    table.insert(activeReports, newReport)

    -- Notify Admins and Sync
    SyncParams()

    -- Send confirmation to user
    TriggerClientEvent('chat:addMessage', _source, {
        color = {0, 255, 0},
        multiline = true,
        args = {"System", Config.Lang['report_sent']}
    })

    -- Log to Webhook
    if Config.EnableWebhook and Config.WebhookURL ~= '' then
        SendDiscordWebhook(_source, playerName, reason)
    end

    if Config.Debug then
        print(string.format("Report received from %s [%s]: %s", playerName, _source, reason))
    end
end)

RegisterNetEvent('admin_reports:openAdminPanel')
AddEventHandler('admin_reports:openAdminPanel', function()
    local _source = source
    if IsPlayerAdmin(_source) then
        TriggerClientEvent('admin_reports:openAdminUI', _source, activeReports)
    else
        TriggerClientEvent('chat:addMessage', _source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "You do not have permission."}
        })
    end
end)

RegisterNetEvent('admin_reports:teleportTo')
AddEventHandler('admin_reports:teleportTo', function(targetId)
    local _source = source
    if IsPlayerAdmin(_source) then
        -- Basic TP logic
        local targetPed = GetPlayerPed(targetId)
        local sourcePed = GetPlayerPed(_source)
        if targetPed and DoesEntityExist(targetPed) then
            local coords = GetEntityCoords(targetPed)
            SetEntityCoords(sourcePed, coords.x, coords.y, coords.z, false, false, false, false)
        else
            TriggerClientEvent('chat:addMessage', _source, {args={"System", "Player not found."}})
        end
    end
end)

RegisterNetEvent('admin_reports:concludeReport')
AddEventHandler('admin_reports:concludeReport', function(reportId)
    local _source = source
    if IsPlayerAdmin(_source) then
        for i, report in ipairs(activeReports) do
            if report.id == reportId then
                -- Notify User
                TriggerClientEvent('chat:addMessage', report.source, {
                    color = {0, 255, 0},
                    multiline = true,
                    args = {"System", "Your report has been concluded by an admin."}
                })
                
                table.remove(activeReports, i)
                SyncParams()
                break
            end
        end
    end
end)

function SyncParams()
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        if IsPlayerAdmin(playerId) then
            -- Optional: Alert them via chat if it's a new report
            TriggerClientEvent('admin_reports:updateReports', playerId, activeReports)
        end
    end
end

function SendDiscordWebhook(source, name, reason)
    local embed = {
        {
            ["color"] = 16711680, -- Red color
            ["title"] = "New Admin Report",
            ["description"] = "**Player:** " .. name .. " [" .. source .. "]\n**Reason:** " .. reason,
            ["footer"] = {
                ["text"] = "Server Reports • " .. os.date("%Y-%m-%d %H:%M:%S"),
            },
        }
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({
        username = Config.BotName,
        avatar_url = Config.BotAvatar,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

function IsPlayerAdmin(playerId)
    if Config.UseAcePerms then
        return IsPlayerAceAllowed(playerId, Config.AcePerm)
    else
        -- Add your ESX/QBCore check here if needed
        -- Example for simple ID check:
        -- return true 
        print("^1[Admin Reports] Warning: Config.UseAcePerms is false but no custom check is implemented!^7")
        return false
    end
end
