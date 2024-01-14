local Translations = {
    notify = {
        ydhk = 'この車両の鍵を持っていません',
        nonear = '近くに鍵を渡せる人がいません',
        vlock = '車両をロックした!',
        vunlock = '車両のロックを解除した!',
        vlockpick = 'ドアの鍵を開けるのに成功した!',
        fvlockpick = '鍵が見つけられなかった。苛立ちを感じる',
        vgkeys = '鍵を渡した',
        vgetkeys = '車両の鍵を手に入れた!',
        fpid = 'プレイヤーIDとプレートを引数に入力してください',
        cjackfail = 'カージャックに失敗してしまった!',
        vehclose = '近くに車両が無い!',
    },
    progress = {
        takekeys = 'ボディから鍵を探す...',
        hskeys = '車両の鍵を探している...',
        acjack = 'カージャック中...',
    },
    info = {
        skeys = '~g~[H]~w~ - 鍵を探す',
        tlock = '車両のロックを切り替え',
        palert = '車両盗難発生。 種類: ',
        engine = 'エンジンスイッチ',
    },
    addcom = {
        givekeys = '他のプレイヤーに鍵を渡します。IDを指定しなかった場合は近くに居る人か、車内にいる全員に渡します',
        givekeys_id = 'id',
        givekeys_id_help = 'プレイヤーID',
        addkeys = '他人に渡すために車両のスペアキーを増やします',
        addkeys_id = 'id',
        addkeys_id_help = 'プレイヤーID',
        addkeys_plate = 'plate',
        addkeys_plate_help = 'プレート',
        rkeys = '他人に渡すために作った車両のスペアキーを破棄します',
        rkeys_id = 'id',
        rkeys_id_help = 'プレイヤーID',
        rkeys_plate = 'plate',
        rkeys_plate_help = 'プレート',
    }

}

if GetConvar('qb_locale', 'en') == 'ja' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
