-- Long rifle
projectiles.register_shooter("long_rifle", {
   description = "Long Rifle",
   texture = "projectiles_long_rifle.png",
   damage = 10,
   range = 100,
   ammo = "projectiles:rifle_cartridge",
   rounds = 1,
   reload_speed = 2,
   scale = {x = 3, y = 1, z = 1}
})

minetest.register_craftitem("projectiles:rifle_cartridge", {
   description = "Rifle Cartridge",
   inventory_image = "projectiles_rifle_cartridge.png",
})

-- Pistol (Six-shooter)
projectiles.register_shooter("pistol", {
   description = "Pistol",
   texture = "projectiles_pistol.png",
   damage = 4,
   range = 40,
   ammo = "projectiles:pistol_cartridge 6",
   rounds = 6,
   reload_speed = 4
})

minetest.register_craftitem("projectiles:pistol_cartridge", {
   definition = "Pistol Cartridge",
   inventory_image = "projectiles_pistol_cartridge.png",
})