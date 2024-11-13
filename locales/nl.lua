local Translations = {
    notify = {
        ydhk = 'Je hebt de sleutels niet.',
        nonear = 'Er is niemand in de buurt om te sluiten aan te geven',
        vlock = 'Voertuig vergrendeld',
        vunlock = 'Voertuig ontgrendeld',
        vlockpick = 'Het is gelukt om het voertuig open te breken',
        fvlockpick = 'Het is niet gelukt',
        vgkeys = 'Je hebt de sleutels afgegeven',
        vgetkeys = 'Je hebt de sleutels gekregen',
        fpid = 'Vul het burgerID en plak argumentatie',
        cjackfail = 'Carjacking mislukt!',
        vehclose = 'Er is geen voertuig in de buurt',
    },
    progress = {
        takekeys = 'Steel de sleutels van het lijk..',
        hskeys = 'Doorzoekt het voertuig voor sleutels..',
        acjack = 'Probeert te carjacken..',
    },
    info = {
        skeys = '~g~[H]~w~ - Zoek naar sleutels',
        tlock = 'Gebruik de vergrendeling',
        palert = 'Voertuigdiefstal bezig. Type: ',
        engine = 'Motor aan/uitzetten',
    },
    addcom = {
        givekeys = 'Geef de sleutels door, indien geen ID gaat de sleutel naar de dichtbijzijnde persoon of iedereen in het voertuig.',
        givekeys_id = 'id',
        givekeys_id_help = 'Burger ID',
        addkeys = 'Voegt sleutels toe aan een voertuig voor iemand.',
        addkeys_id = 'id',
        addkeys_id_help = 'Burger ID',
        addkeys_plate = 'Nummerplak',
        addkeys_plate_help = 'Nummerplak',
        rkeys = 'Verwijder sleutels van een voertuig voor iemand.',
        rkeys_id = 'id',
        rkeys_id_help = 'Burger ID',
        rkeys_plate = 'Nummerplak',
        rkeys_plate_help = 'Nummerplak',
    }

}

if GetConvar('qb_locale', 'en') == 'nl' then
    Lang = Lang or Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end

