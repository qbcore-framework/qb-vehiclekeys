fx_version 'cerulean'
game 'gta5'

description 'QB-VehicleKeys'
version '1.0.0'

server_script {
    'server/main.lua',
}

client_script {
    'client/main.lua',
    'config.lua',
}

dependencies {
    'qb-core',
    'qb-skillbar'
}