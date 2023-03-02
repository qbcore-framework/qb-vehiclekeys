local Translations = {
    notify = {
        ydhk = 'Je hebt de sleutels niet van dit voertuig.',
        nonear = 'Er is niemand in de buurt om deze sleutels te geven',
        vlock = 'Voertuig op slot!',
        vunlock = 'Voertuig is open!',
        vlockpick = 'Het is je gelukt om het slot van de deur open te breken!',
        fvlockpick = 'Je kon de sleutels niet vinden en je wordt gefrustreerd.',
        vgkeys = 'Je hebt een 2de paar sleutels aan iemand gegeven.',
        vgetkeys = 'Je hebt een 2de paar sleutels van iemand gekregen!',
        fpid = 'Vul de gegevens van de Speler ID en nummerplaat in.',
        cjackfail = 'De auto stelen mislukte!',
        vehclose = 'Er is geen voertuig in de buurt!',
    },
    progress = {
        takekeys = 'Neemt de sleutels van de persoon...',
        hskeys = 'Zoekt voor die autosleutels...',
        acjack = 'Probeert de auto te stelen...',
    },
    info = {
        skeys = '~g~[H]~w~ - Zoek voor sleutels',
        tlock = 'Schakel voertuigsloten in/uit',
        palert = 'Autodiefstal is gaande. Type: ',
        engine = 'Schakel motor in/uit',
    },
    addcom = {
        givekeys = 'Overhandig de sleutels aan iemand. Als er geen ID is, geeft het de dichtbijzijnste persoon of iedereen in het voertuig de sleutel.',
        givekeys_id = 'id',
        givekeys_id_help = 'Speler ID',
        addkeys = 'Voegt sleutels toe aan een voertuig voor iemand.',
        addkeys_id = 'id',
        addkeys_id_help = 'Speler ID',
        addkeys_plate = 'plate',
        addkeys_plate_help = 'Nummerplaat',
        rkeys = 'Verwijder sleutels van een voertuig van iemand.',
        rkeys_id = 'id',
        rkeys_id_help = 'Speler ID',
        rkeys_plate = 'plate',
        rkeys_plate_help = 'Nummerplaat',
    }

}

if GetConvar('qb_locale', 'en') == 'nl' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
