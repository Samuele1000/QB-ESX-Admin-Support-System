# Admin Reports Script 📝

Een eenvoudig en standalone admin report systeem voor FiveM servers. Spelers kunnen met `/report` een bericht sturen naar online admins, en optioneel kan dit ook naar een Discord kanaal gestuurd worden via een webhook.

## ✨ Features
*   **Standalone**: Geen afhankelijkheden van ESX of QBCore (werkt met Ace Permissions).
*   **Discord Logs**: Stuur reports direct door naar je Discord staff kanaal met mooie embeds.
*   **Cooldowns**: Voorkom spam door een instelbare wachttijd.
*   **Volledig Configurerbaar**: Pas alle teksten, kleuren en instellingen aan in `config.lua`.

## 📥 Installatie

1.  Download de bestanden en plaats de map `admin_reports` in je server `resources` map.
2.  Voeg het volgende toe aan je `server.cfg`:
    ```cfg
    ensure admin_reports
    ```

## ⚙️ Configuratie

### Permissies (Ace Perms)
Om admins reports te laten zien, moet je ze toestemming geven in je `server.cfg`.
Voeg de volgende regel toe voor je admin groep:

```cfg
add_ace group.admin command.report_notify allow
```

En zorg dat je spelers in de juiste groep zitten:
```cfg
add_principal identifier.steam:1100001xxxxxx group.admin
```
*(Vervang `identifier.steam:1100001xxxxxx` met de Steam Hex van de admin)*

### Discord Webhook
1.  Open `config.lua`.
2.  Maak een Webhook aan in je Discord server (Kanaal Instellingen -> Integraties -> Webhooks).
3.  Kopieer de URL en plak deze bij `Config.WebhookURL`.
4.  Zet `Config.EnableWebhook` op `true`.

## 🎮 Gebruik

*   `/report [reden]` - Verstuur een report naar de admins.

## 📄 Licentie
Dit project is gelicentieerd onder de [MIT License](LICENSE).
Je mag het vrij gebruiken, aanpassen en verspreiden, zolang je de copyright notice laat staan.
