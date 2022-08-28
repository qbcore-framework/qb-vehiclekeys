local Translations = {
    notify = {
        ydhk = 'Sie haben keine Schlüssel für das Fahrzeug.',
        nonear = 'Es ist niemand in der Nähe, der den Schlüssel nehmen könnte',
        vlock = 'Fahrzeug verriegelt!',
        vunlock = 'Fahrzeug entriegelt!',
        vlockpick = 'Du hast es geschafft, das Türschloss zu knacken!',
        fvlockpick = 'Sie können die Schlüssel nicht finden und sind frustriert.',
        vgkeys = 'Sie geben die Schlüssel ab.',
        vgetkeys = 'Sie erhalten die Schlüssel für das Fahrzeug!',
        fpid = 'Füllen Sie die Argumente für die Bürger-ID und das Kennzeichen aus.',
        cjackfail = 'Carjacking fehlgeschlagen!',
    },
    progress = {
        takekeys = 'Fahrzeugschlüssel abnehmen...',
        hskeys = 'Suche nach Fahrzeugschlüssel...',
        acjack = 'Versuchter Autodiebstahl...',
    },
    info = {
        skeys = '~g~[H]~w~ - Schlüssel suchen',
        tlock = 'Motor ein und ausschalten',
        palert = 'Fahrzeugdiebstahl im Gange. Typ: ',
        engine = 'Motor ein und ausschalten',
    },
    addcom = {
        givekeys = 'Übergeben Sie die Schlüssel an jemanden. Wenn Sie keinen Ausweis haben, geben Sie ihn der nächstgelegenen Person oder allen Personen im Fahrzeug.',
        givekeys_id = 'id',
        givekeys_id_help = 'Bürger ID',
        addkeys = 'Fügt Schlüssel zu einem Fahrzeug für jemanden hinzu.',
        addkeys_id = 'id',
        addkeys_id_help = 'Bürger ID',
        addkeys_plate = 'kennzeichen',
        addkeys_plate_help = 'Kennzeichen',
        rkeys = 'Entfernen Sie die Schlüssel eines Fahrzeugs für jemanden.',
        rkeys_id = 'id',
        rkeys_id_help = 'BürgerID',
        rkeys_plate = 'kennzeichen',
        rkeys_plate_help = 'Kennzeichen',
    }

}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
