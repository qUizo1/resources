fx_version 'cerulean'
game 'gta5'

shared_script {
  "@vrp/lib/utils.lua"
}

client_scripts {
    'client.lua'
}

server_scripts {
    "server.lua",
}

ui_page 'index/index.html'

files {
    'index/index.html',
    'index/css/*.css',
    'index/js/*.js'
}

export 'ShowTextUI'
export 'HideTextUI'