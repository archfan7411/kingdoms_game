---------------------------------------------------------------------------------------
-- simple anvil that can be used to repair tools
---------------------------------------------------------------------------------------
-- * can be used to repair tools
-- * the hammer gets dammaged a bit at each repair step
---------------------------------------------------------------------------------------
-- License of the hammer picture: CC-by-SA; done by GloopMaster; source:
--   https://github.com/GloopMaster/glooptest/blob/master/glooptest/textures/glooptest_tool_steelhammer.png


-- the hammer for the anvil
minetest.register_tool("anvil:hammer", {
   description = "Steel hammer for repairing tools on the anvil",
   image = "glooptest_tool_steelhammer.png",
   inventory_image = "glooptest_tool_steelhammer.png",
   wear_represents = "unrepairable",
   tool_capabilities = {full_punch_interval = 0.8,
      max_drop_level=1,
      groupcaps = {
			-- about equal to a stone pick (it's not intended as a tool)
         cracky = {times={[2]=2.00, [3]=1.20}, uses=30, maxlevel=1},
      },
      damage_groups = {fleshy=6},
   }
})



minetest.register_node("anvil:anvil", {
	drawtype = "nodebox",
	description = "anvil",
   is_ground_content = false,
	tiles = {"default_stone.png"}, -- TODO default_steel_block.png,  default_obsidian.png are also nice
	paramtype  = "light",
   paramtype2 = "facedir",
	groups = {cracky=2},
	-- the nodebox model comes from realtest
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
			{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
			{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
			{-0.35,-0.1,-0.2,0.35,0.1,0.2},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
			{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
			{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
			{-0.35,-0.1,-0.2,0.35,0.1,0.2},
		}
	},
	on_construct = function(pos)
      local meta = minetest.env:get_meta(pos);
      meta:set_string("infotext", "Anvil");
      local inv = meta:get_inventory();
      inv:set_size("input",    1);
   end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos);
		meta:set_string("owner", placer:get_player_name() or "");
		meta:set_string("formspec",
			"size[8,6]"..
			"list[context;input;3.5,0.5;1,1;]"..
			"label[0,0.7;Insert damaged tool here:]"..
			"list[current_player;main;0,2;8,4;]");
   end,

   can_dig = function(pos,player)
      local meta  = minetest.get_meta(pos);
      local inv   = meta:get_inventory();
      if not inv:is_empty("input") or not player then
         return false;
		end
		if not inv:is_empty("hammer") then
			for _, stack in pairs(inv:get_list("hammer")) do
				minetest.item_drop(stack, "", pos)
			end
		end
      return true;
   end,

	allow_metadata_inventory_move = function(_, _, _, _, _, count)
		return count;
	end,

	allow_metadata_inventory_put = function(_, listname, _, stack)
		if listname=='input' and stack:get_wear() == 0 then
			return 0;
      end
		return stack:get_count()
	end,

	allow_metadata_inventory_take = function(_, _, _, stack)
		return stack:get_count()
	end,

	on_punch = function(pos, node, puncher)
		if ( not( pos ) or not( node ) or not( puncher )) then
			return;
		end
		-- only punching with the hammer is supposed to work
		local wielded = puncher:get_wielded_item();
		if( not( wielded ) or not( wielded:get_name() ) or wielded:get_name() ~= 'anvil:hammer') then
         return;
		end
      local meta = minetest.env:get_meta(pos);
      local inv  = meta:get_inventory();
		local input = inv:get_stack('input',1);

		-- only tools can be repaired
		if( not( input ) or input:is_empty() ) then
            minetest.sound_play("hammerhitsoft.ogg", {
                pos = pos,
                max_hear_distance = 20,
                gain = 1,
            })
			return;
		end

		local inputdef = minetest.registered_items[input:get_name()]
		local mechanical = not inputdef.wear_represents or inputdef.wear_represents == "mechanical_wear"
		if not mechanical then
			return
		end

		-- tell the player when the job is done
		if input:get_wear() == 0 then
         minetest.sound_play("hammerhitsoft", {
            pos = pos,
            max_hear_distance = 50,
            gain = 1,
         })
			return;
		end

		-- do the actual repair
		input:add_wear(-5000); -- equals to what technic toolshop does in 5 seconds
		inv:set_stack("input", 1, input)

      minetest.sound_play("hammerhithard", {
         pos = pos,
         max_hear_distance = 100,
         gain = 1,
      })

		-- damage the hammer slightly
		wielded:add_wear( 500 );
		puncher:set_wielded_item( wielded );

	end,
})



---------------------------------------------------------------------------------------
-- crafting receipes
---------------------------------------------------------------------------------------
minetest.register_craft({
	output = "anvil:anvil",
	recipe = {
      {'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
      {'',                   'default:steel_ingot',''                   },
      {'default:steel_ingot','default:steel_ingot','default:steel_ingot'} },
})

minetest.register_craft({
	output = "anvil:hammer",
	recipe = {
      {'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
      {'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
      {'',                   'default:stick',      ''                   }
   }
})
