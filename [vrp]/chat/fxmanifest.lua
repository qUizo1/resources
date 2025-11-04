fx_version "cerulean"
game "gta5"
lua54 "yes"
auth "qUizo"
ui_page "html/index.html"
ui_page_preload "yes"

client_scripts({
	"cl_*.lua",
})

server_scripts({
	"@vrp/lib/utils.lua",
	"vrp.lua",
})

files({
	"html/**/*",
})
