local Translations = {
    error = {
        no_keys = 'You don\'t have keys to this vehicle.',
        nobody_nearby = 'There is nobody nearby to hand keys to.',
        you_failed = 'You fail to find the keys and get frustrated.'
    },
    success = {
        vehicle_unlocked = 'Vehicle unlocked!',
        door_lock_opened = 'You managed to pick the door lock open!',
        you_got_keys = 'You get keys to the vehicle!'
    },
    info = {
        taking_keys = 'Taking keys from body...',
        search_keys = '[H] - Search for Keys',
        toggle_locks = 'Toggle Vehicle Locks',
        searching_keys = 'Searching for the car keys...',
        carjacking_attempt = 'Attempting Carjacking..',
        theft_in_progress = 'Vehicle theft in progress',
        handover_keys = 'You hand over the keys.',
        toggle_engine = 'Toggle Engine',
        hand_over_keys = 'Hand over the keys to someone. If no ID, gives to closest person or everyone in the vehicle.',
        add_keys = 'Adds keys to a vehicle for someone.',
        fill_out = 'Fill out the player ID and Plate arguments.',
        remove_keys = 'Remove keys to a vehicle for someone.'
    },
    warning = {
        vehicle_locked = 'Vehicle locked!'
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
