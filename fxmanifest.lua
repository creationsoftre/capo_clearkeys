fx_version 'cerulean'
game 'gta5'

name 'capo-clearkeys'
description 'Clear QS vehicle key items with framework + locale support'
author 'You'
version '1.3.0'

lua54 'yes'

shared_scripts {
  '@ox_lib/init.lua',
  'config/config.lua',
  'config/locales.lua',
  'shared/framework.lua',
  'shared/inventory.lua'
}

client_scripts {
  'client/client.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/server.lua'
}
