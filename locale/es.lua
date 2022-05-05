local Translations = {
    error = {
        no_keys = 'No tienes llaves para este vehículo',
        nobody_nearby = 'No hay nadie cerca a quién darle las llaves.',
        you_failed = 'No pudiste encontrar las llaves y te has frustrado.'
    },
    success = {
        vehicle_unlocked = '¡Vehículo abierto!',
        door_lock_opened = '¡Lograste abrir el seguro de la puerta!',
        you_got_keys = '¡Obtuviste las llaves del vehículo!'
    },
    info = {
        taking_keys = 'Obteniendo las llaves del cuerpo...',
        search_keys = '[H] - Buscar las llaves',
        toggle_locks = 'Abrir/cerrar seguros',
        searching_keys = 'Buscando las llaves del auto...',
        carjacking_attempt = 'Intentando robar auto..',
        theft_in_progress = 'Robo de vehículo en progreso',
        handover_keys = 'Has entregado las llaves',
        toggle_engine = 'Encender/apagar motor',
        hand_over_keys = 'Entregar las llaves a alguien. Si no ingresas la ID, se les entrega a la persona mas cercana o todos en el vehículo.',
        add_keys = 'Agrega las llaves a un vehículo para alguien',
        fill_out = 'Ingresa la ID del jugador y los argumentos de la placa',
        remove_keys = 'Quitar las llaves de un vehículo para alguien'
    },
    warning = {
        vehicle_locked = '¡Vehículo cerrado!'
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
