local Translations = {
    notify = {
        ydhk = 'Você não tem chaves deste veículo.',
        nonear = 'Não há ninguém por perto para entregar as chaves.',
        vlock = 'Veículo trancado!',
        vunlock = 'Veículo destrancado!',
        vlockpick = 'Você conseguiu abrir a fechadura da porta com uma ferramenta!',
        fvlockpick = 'Você não consegue encontrar as chaves e fica frustrado.',
        vgkeys = 'Você entrega as chaves.',
        vgetkeys = 'Você pega as chaves do veículo!',
        fpid = 'Preencha o ID do jogador e os argumentos da placa',
        cjackfail = 'Tentativa de roubo de carro falhou!',
        vehclose = 'Não há veículo próximo!',
    },
    progress = {
        takekeys = 'Retirando as chaves do corpo...',
        hskeys = 'Procurando pelas chaves do carro...',
        acjack = 'Tentando roubar o carro...',
    },
    info = {
        skeys = '~g~[H]~w~ - Procurar Chaves',
        tlock = 'Alternar Trava do Veículo',
        palert = 'Roubo de veículo em andamento. Tipo: ',
        engine = 'Ligar/Desligar Motor',
    },
    addcom = {
        givekeys = 'Entrega as chaves para alguém. Se nenhum ID for fornecido, entrega para a pessoa mais próxima ou todos no veículo.',
        givekeys_id = 'id',
        givekeys_id_help = 'ID do Jogador',
        addkeys = 'Adiciona chaves a um veículo para alguém.',
        addkeys_id = 'id',
        addkeys_id_help = 'ID do Jogador',
        addkeys_plate = 'plate',
        addkeys_plate_help = 'Placa',
        rkeys = 'Remove as chaves de um veículo de alguém.',
        rkeys_id = 'id',
        rkeys_id_help = 'ID do Jogador',
        rkeys_plate = 'plate',
        rkeys_plate_help = 'Placa',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
