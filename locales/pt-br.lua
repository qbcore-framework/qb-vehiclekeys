local Translations = {
    notify = {
        ydhk = 'Você não tem chaves deste veículo.',
        nonear = 'Não há ninguém por perto para entregar as chaves',
        vlock = 'Veículo trancado!',
        vunlock = 'Veículo destrancado!',
        vlockpick = 'Você conseguiu abrir a fechadura da porta!',
        fvlockpick = 'Você não consegue encontrar as chaves e fica frustrado.',
        vgkeys = 'Você entrega as chaves.',
        vgetkeys = 'Você pegou as chaves do veículo!',
        fpid = 'Preencha o ID do jogador e os argumentos da placa',
        cjackfail = 'Falha na tentativa de roubo de carro!',
        vehclose = 'Não há veículo próximo!',
    },
    progress = {
        takekeys = 'Pegando as chaves do corpo...',
        hskeys = 'Procurando as chaves do carro...',
        acjack = 'Tentando roubo de carro...',
    },
    info = {
        skeys = '~g~[H]~w~ - Procurar Chaves',
        tlock = 'Alternar Trancamento do Veículo',
        palert = 'Roubo de veículo em andamento. Tipo: ',
        engine = 'Ligar/Desligar o Motor',
    },
    addcom = {
        givekeys = 'Entrega as chaves a alguém. Se nenhum ID for fornecido, entrega para a pessoa mais próxima ou todos no veículo.',
        givekeys_id = 'id',
        givekeys_id_help = 'ID do jogador',
        addkeys = 'Adiciona chaves a um veículo para alguém.',
        addkeys_id = 'id',
        addkeys_id_help = 'ID do jogador',
        addkeys_plate = 'plate',
        addkeys_plate_help = 'Placa',
        rkeys = 'Remove as chaves de um veículo para alguém.',
        rkeys_id = 'id',
        rkeys_id_help = 'ID do jogador',
        rkeys_plate = 'plate',
        rkeys_plate_help = 'Placa',
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
