Config = {}

-- Zet dit op true om debug berichten in de console te zien
Config.Debug = false

-- Hoe lang spelers moeten wachten tussen reports (in seconden)
Config.Cooldown = 60

-- Permissie instellingen
-- Als false, moet je zelf code toevoegen voor framework integratie (ESX/QBCore) in server.lua
Config.UseAcePerms = true

-- De ace permission die nodig is om reports te zien
-- Voeg dit toe aan je server.cfg: add_ace group.admin command.report_notify allow
Config.AcePerm = 'command.report_notify'

-- Discord Webhook Instellingen
Config.EnableWebhook = true -- Zet op false om uit te schakelen
Config.WebhookURL = '' -- Plak hier je Discord Webhook URL
Config.BotName = 'Server Reports' -- Naam van de bot die het bericht stuurt
Config.BotAvatar = '' -- (Optioneel) URL naar een afbeelding voor de bot


-- Berichten (Translations)
Config.Lang = {
    ['report_sent'] = 'Je report is verzonden naar de admins!',
    ['report_cooldown'] = 'Wacht nog %s seconden voordat je een nieuw report stuurt.',
    ['report_received'] = '^1[REPORT]^7 [^3%s^7] ^5%s^7: %s',
    ['usage'] = 'Gebruik: /report [reden]',
    ['no_reason'] = 'Je moet een reden opgeven.',
}
