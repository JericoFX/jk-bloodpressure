fx_version("cerulean")
game("gta5")
author "JericoFX"
description("JK-BloodPressure")
version("1.0.0")
client_script("client/init.lua")
shared_script "@ox_lib/init.lua"
server_scripts({
    "config/sv_init.lua",
	"server/init.lua",
})
files({
	"config/cl_init.lua",
})
lua54("yes")
