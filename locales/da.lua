local Translations = {
    notify = {
        ydhk = 'Du har ikke nøgler til denne bil.',
        nonear = 'Der er ingen i nærheden til at give nøgler til',
        vlock = 'Bil låst!',
        vunlock = 'Bil ulåst!',
        vlockpick = 'Du formåede at låse døren op med en låsepick!',
        fvlockpick = 'Du kunne ikke finde nøglerne og blev frustreret.',
        vgkeys = 'Du overgiver nøglerne.',
        vgetkeys = 'Du får nøgler til bilen!',
        fpid = 'Udfyld spillerens ID og nummerpladeargumenter',
        cjackfail = 'Biltyveri mislykkedes!',
        vehclose = 'Der er ingen bil i nærheden!',
    },
    progress = {
        takekeys = 'Tager nøgler fra liget...',
        hskeys = 'Søger efter bilnøgler...',
        acjack = 'Forsøger biltyveri...',
    },
    info = {
        skeys = '~g~[H]~w~ - Søg efter nøgler',
        tlock = 'Skift bilens låse',
        palert = 'Biltyveri i gang. Type: ',
        engine = 'Skift motor',
    },
    addcom = {
        givekeys = 'Overgiv nøglerne til nogen. Hvis der ikke er en ID, gives de til den nærmeste person eller alle i køretøjet.',
        givekeys_id = 'id',
        givekeys_id_help = 'Spillerens ID',
        addkeys = 'Tilføjer nøgler til en bil for nogen.',
        addkeys_id = 'id',
        addkeys_id_help = 'Spillerens ID',
        addkeys_plate = 'nummerplade',
        addkeys_plate_help = 'Nummerplade',
        rkeys = 'Fjerner nøgler til en bil for nogen.',
        rkeys_id = 'id',
        rkeys_id_help = 'Spillerens ID',
        rkeys_plate = 'nummerplade',
        rkeys_plate_help = 'Nummerplade',
    }
}


if GetConvar('qb_locale', 'en') == 'da' then
  Lang = Locale:new({
      phrases = Translations,
      warnOnMissing = true
  })
end
