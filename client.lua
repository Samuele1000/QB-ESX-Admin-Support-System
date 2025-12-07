RegisterCommand('report', function(source, args, rawCommand)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openReportForm'
    })
end, false)

RegisterCommand('reports', function(source, args, rawCommand)
    -- Trigger server event to check permission and get reports
    TriggerServerEvent('admin_reports:openAdminPanel')
end, false)

RegisterNetEvent('admin_reports:openAdminUI')
AddEventHandler('admin_reports:openAdminUI', function(reports)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openAdminPanel',
        reports = reports
    })
end)

RegisterNetEvent('admin_reports:updateReports')
AddEventHandler('admin_reports:updateReports', function(reports)
    SendNUIMessage({
        action = 'updateReports',
        reports = reports
    })
end)

RegisterNUICallback('submitReport', function(data, cb)
    SetNuiFocus(false, false)
    if data.reason then
        TriggerServerEvent('admin_reports:sendReport', data.reason)
    end
    cb('ok')
end)

RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('tpToPlayer', function(data, cb)
    if data.targetId then
        TriggerServerEvent('admin_reports:teleportTo', data.targetId)
    end
    cb('ok')
end)

RegisterNUICallback('concludeReport', function(data, cb)
    if data.reportId then
        TriggerServerEvent('admin_reports:concludeReport', data.reportId)
    end
    cb('ok')
end)

TriggerEvent('chat:addSuggestion', '/report', 'Open the report menu', {})
TriggerEvent('chat:addSuggestion', '/reports', 'Open the admin report panel', {})
