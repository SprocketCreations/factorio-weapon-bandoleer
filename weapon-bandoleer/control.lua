-- Detects when a weapon is added or removed from the weapon bar
--script.on_event(defines.events.on_player_gun_inventory_changed, function(event) end);

-- Detects when ammo is added or removed from the ammo bar
--script.on_event(defines.events.on_player_ammo_inventory_changed, function()end);

script.on_event("weapon-bandoleer-input-weapon-1", function(event) JumpToIndex(event, 1); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);
script.on_event("weapon-bandoleer-input-weapon-2", function(event) JumpToIndex(event, 2); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);
script.on_event("weapon-bandoleer-input-weapon-3", function(event) JumpToIndex(event, 3); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);
script.on_event("weapon-bandoleer-input-weapon-4", function(event) JumpToIndex(event, 4); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);
script.on_event("weapon-bandoleer-input-weapon-5", function(event) JumpToIndex(event, 5); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);
script.on_event("weapon-bandoleer-input-weapon-6", function(event) JumpToIndex(event, 6); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);
script.on_event("weapon-bandoleer-input-weapon-7", function(event) JumpToIndex(event, 7); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);
script.on_event("weapon-bandoleer-input-weapon-8", function(event) JumpToIndex(event, 8); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);
script.on_event("weapon-bandoleer-input-weapon-9", function(event) JumpToIndex(event, 9); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);
script.on_event("weapon-bandoleer-input-weapon-0", function(event) JumpToIndex(event, 0); game.get_player(event.player_index).play_sound({path = "utility/switch_gun",}); end);

-- Detects when the player cycles their gun forwards
script.on_event("weapon-bandoleer-input-next-weapon",
	function(event)
		local player = game.get_player(event.player_index);
		if(player.vehicle == nil) then
			RotateCW(event);
	--[[else
		local gun_index = player.vehicle.selected_gun_index;
			gun_index = gun_index + 1;
			local number_of_gun_slots = #player.vehicle.prototype.indexed_guns;
			if(gun_index > number_of_gun_slots) then gun_index = gun_index - number_of_gun_slots; end
			player.vehicle.selected_gun_index = gun_index;]]
		end
		--player.play_sound({path = "utility/switch_gun",});
	end
);

-- Detects when the player cycles their gun back
script.on_event("weapon-bandoleer-input-previous-weapon",
	function(event)
		local player = game.get_player(event.player_index);
		if(player.vehicle == nil) then
			RotateCCW(event);
			player.play_sound({path = "utility/switch_gun",});
		else
			--[[] ]
			From: https://lua-api.factorio.com/latest/LuaEntityPrototype.html#LuaEntityPrototype.indexed_guns
				| indexed_guns :: array[LuaItemPrototype]? Read 
				| A vector of the gun prototypes of this car, spider vehicule, or artillery wagon or turret.
				| Can only be used if this is Car or SpiderVehicle or ArtilleryTurret or ArtilleryWagon
			--[ ]]
			local player_in_vehicle_with_guns = player.vehicle.prototype.type == "car"
		--[[ Yes I know that the player ]]	 or player.vehicle.prototype.type == "spider-vehicle"
		--[[ cant enter arty. But maybe ]]	 or player.vehicle.prototype.type == "artillery-turret"
		--[[ a mod adds that so I check ]]	 or player.vehicle.prototype.type == "artillery-wagon";

			if(player_in_vehicle_with_guns and player.vehicle.prototype.indexed_guns ~= nil) then
				local gun_index = player.vehicle.selected_gun_index - 1;
				local number_of_gun_slots = #player.vehicle.prototype.indexed_guns;
				if(gun_index <= 0) then gun_index = number_of_gun_slots - gun_index; end
				player.vehicle.selected_gun_index = gun_index;

				player.play_sound({path = "utility/switch_gun",});
			end
		end
	end
);

script.on_init(
	function()
		global.players = {};


		for _, player in pairs(game.players) do
			InitializeMod(player);
		end
	end
);
script.on_event(defines.events.on_player_joined_game,
	function(event)
		local player = game.get_player(event.player_index);
		InitializeMod(player);
	end
);

script.on_event(defines.events.on_player_removed,
	function(event)
		global.players[event.player_index] = nil
	end
);

script.on_configuration_changed(
	function(data)
		if(data.mod_changes["weapon-bandoleer"]) then
			DeinitializeMod();
			for _, player in pairs(game.players) do
				InitializeMod(player);
			end
		end
	end
);

script.on_event(defines.events.on_gui_opened,
	function (event)
		if(event.gui_type == defines.gui_type.item) then
			if(event.item ~= nil and event.item.prototype.subgroup.name == "bandoleer") then
				-- This code is run whenever the bandoleer's inventory is opened
				local player_globals = global.players[event.player_index];
				player_globals.previewed_bandoleer = event.item.item_number;

				local bandoleer_active = false;
				if(player_globals.previewed_bandoleer == player_globals.active_bandoleer) then
					local player = game.get_player(event.player_index);
					MoveAllToBandoleer(player, event.item);
					bandoleer_active = true;
				end


				local bandoleer = event.item;
				if(bandoleer.label == nil) then bandoleer.label = "Weapon Bandoleer [1/0]"; end
				local reversed_label = string.reverse(bandoleer.label);
				local index_of_bracket = string.find(reversed_label, "%[");
				local forward_index_of_bracket = #bandoleer.label - index_of_bracket - 1;
				bandoleer.label = string.sub(event.item.label, 1, forward_index_of_bracket);
				bandoleer.allow_manual_label_change = true;

				local player = game.get_player(event.player_index);
				local frame = player.gui.relative.weapon_bandoleer_activate_bandoleer_frame;
				frame.visible = FindBandoleerByID(player.get_main_inventory(), bandoleer.item_number) ~= nil;

				--change button text
				frame.frame.weapon_bandoleer_activate_bandoleer_button.caption = bandoleer_active and {"gui.deactivate-bandoleer"} or {"gui.activate-bandoleer"};
				frame.frame.weapon_bandoleer_activate_bandoleer_button.tooltip = bandoleer_active and {"gui.deactivate-bandoleer-tooltip"} or {"gui.activate-bandoleer-tooltip"};
				
				--change label text
				frame.frame.label.caption = bandoleer_active and {"gui.bandoleer_label_active"} or {"gui.bandoleer_label_inactive"};
			
			end
		end
	end
);

script.on_event(defines.events.on_gui_closed,
	function (event)
		if(event.gui_type == defines.gui_type.item) then
			if(event.item ~= nil and event.item.prototype.subgroup.name == "bandoleer") then
				-- This code is run whenever the bandoleer's inventory is closed
				local player_globals = global.players[event.player_index];

				local bandoleer = event.item;
				bandoleer.health = 1.0 / 10000000.0;
				local selected_gun_index = 1.0;
				local number_of_guns = 0;

				local bandoleer_inventory = bandoleer.get_inventory(defines.inventory.item_main);
				local slots = #bandoleer_inventory;
				local rows = slots / 10;
				for row = 0, rows - 1, 2 do
					for col = 1, 10, 1 do
						local gun_slot_index = (row * 10) + col;
						if(bandoleer_inventory[gun_slot_index].valid_for_read and bandoleer_inventory[gun_slot_index].type == "gun") then
							number_of_guns = number_of_guns + 1;
						end
					end
				end

				bandoleer.label = event.item.label .. string.format(" [%i/%i]", selected_gun_index, number_of_guns);
				bandoleer.allow_manual_label_change = false;

				local player = game.get_player(event.player_index);
				if(player_globals.previewed_bandoleer == player_globals.active_bandoleer) then
					player_globals.gun_1_home = nil;
					player_globals.gun_2_home = nil;
					player_globals.gun_3_home = nil;
					EquipBandoleerWeapons(player, event.item);
				end

				player_globals.previewed_bandoleer = nil;
				local frame = player.gui.relative.weapon_bandoleer_activate_bandoleer_frame;
				frame.visible = false;
			end
		end
	end
);

script.on_event(defines.events.on_gui_click,
	function(event)
		if(event.element.name == "weapon_bandoleer_activate_bandoleer_button" and event.button == defines.mouse_button_type.left) then
			local player_globals = global.players[event.player_index];
			local player = game.get_player(event.player_index);
			if(player.character ~= nil) then
				local deactivating_current_bandoleer = false;
				local first_bandoleer = false;
				if(player_globals.active_bandoleer == player_globals.previewed_bandoleer) then
					deactivating_current_bandoleer = true;
				end
				
				--change button text
				event.element.caption = deactivating_current_bandoleer and {"gui.activate-bandoleer"} or {"gui.deactivate-bandoleer"};
				event.element.tooltip = deactivating_current_bandoleer and {"gui.activate-bandoleer-tooltip"} or {"gui.deactivate-bandoleer-tooltip"};
			--change label text
			event.element.parent.label.caption = deactivating_current_bandoleer and {"gui.bandoleer_label_inactive"} or {"gui.bandoleer_label_active"};
			
			if(player_globals.active_bandoleer == nil) then
				--No bandoleer equiped
				--Kick items from weapon bar to bandoleer
				first_bandoleer = true;
				
				local selection = player_globals.weapon_alignment + 2;
				player.character.selected_gun_index = selection;
				
			elseif(not (player_globals.active_bandoleer == player_globals.previewed_bandoleer)) then
				--Deactivate old bandoleer
				local bandoleer = FindBandoleerByID(player.get_main_inventory(), player_globals.active_bandoleer);
				MoveAllToBandoleer(player, bandoleer);
			end
			
			if(deactivating_current_bandoleer) then
				player_globals.active_bandoleer = nil;
				player.character.selected_gun_index = 1;
			else
				player_globals.active_bandoleer = player_globals.previewed_bandoleer;
				--Activate new bandoleer
				local bandoleer = FindBandoleerByID(player.get_main_inventory(), player_globals.active_bandoleer);
				
				if(first_bandoleer) then
					local gun_inventory = player.get_inventory(defines.inventory.character_guns);
					local ammo_inventory = player.get_inventory(defines.inventory.character_ammo);
					for i = 1, 3, 1 do
						AppendGunAndAmmoToBandoleer(gun_inventory[i], ammo_inventory[i], bandoleer);
					end
				end
			end
			end
		end
	end
);

script.on_event(defines.events.on_pre_player_died,
	function(event)
		local player_globals = global.players[event.player_index];
		if(player_globals.active_bandoleer ~= nil) then
			local player = game.get_player(event.player_index);
			local bandoleer = FindBandoleerByID(player.get_main_inventory(), player_globals.active_bandoleer);
			MoveAllToBandoleer(player, bandoleer);
			player_globals.active_bandoleer = nil;
			player_globals.previewed_bandoleer = nil;
			player_globals.gun_1_home = nil;
			player_globals.gun_2_home = nil;
			player_globals.gun_3_home = nil;
		end
	end
);
 -- Doesnt work lol
 --[[]
script.on_event(defines.events.on_player_fast_transferred,
	function(event)
		local bandoleer_id = global.players[event.player_index].active_bandoleer;
		if(event.from_player and bandoleer_id ~= nil) then
			OnBandoleerMovedFromInventory(game.get_player(event.player_index), FindBandoleerByID(event.entity.chest, bandoleer_id));
		end
	end
);]]

script.on_event(defines.events.on_player_dropped_item,
	function(event)
		local bandoleer_id = global.players[event.player_index].active_bandoleer;
		local dropped_item = event.entity.stack;
		if(bandoleer_id ~= nil and bandoleer_id == dropped_item.item_number) then
			OnBandoleerMovedFromInventory(game.get_player(event.player_index), dropped_item);
		end
	end
);

script.on_event(defines.events.on_player_cursor_stack_changed,
	function(event)
		local player = game.get_player(event.player_index);
		local player_globals = global.players[event.player_index];
		if(player_globals.active_bandoleer ~= nil and player.is_cursor_empty()) then
			-- Player just dropped an item into a contianer
			local entity = player.selected;
			if(entity ~= nil) then
				local ent_inv = entity.get_inventory(defines.inventory.chest);
				if(ent_inv ~= nil) then
					local bandoleer = FindBandoleerByID(ent_inv, player_globals.active_bandoleer);
					if(bandoleer ~= nil) then
						OnBandoleerMovedFromInventory(player, bandoleer);
					end
				end
			end
		end
	end
);

script.on_event(defines.events.on_runtime_mod_setting_changed,
	function(event)
		if(event.setting == "weapon-bandoleer-weapon-alignment-setting") then
			-- Player changed alignment setting
			local globals = global.players[event.player_index];
			if(globals.active_bandoleer ~= nil) then
				local player = game.get_player(event.player_index);
				local bandoleer = FindBandoleerByID(player.get_main_inventory(), globals.active_bandoleer);
				MoveAllToBandoleer(player, bandoleer);
				globals.weapon_alignment = GetWeaponAlignment(player);
				EquipBandoleerWeapons(player, bandoleer);
				player.character.selected_gun_index = globals.weapon_alignment + 2;
			end
		end
	end
);

function OnBandoleerMovedFromInventory(player, bandoleer)
	local player_globals = global.players[player.index];
	MoveAllToBandoleer(player, bandoleer);
	player_globals.active_bandoleer = nil;
	player_globals.previewed_bandoleer = nil;
	player_globals.gun_1_home = nil;
	player_globals.gun_2_home = nil;
	player_globals.gun_3_home = nil;
end

function DeinitializeMod()
	for _, player in pairs(game.players) do
		local frame = player.gui.relative.weapon_bandoleer_activate_bandoleer_frame;
		if(frame ~= nil) then
			frame.destroy();
		end
	end
end

function InitializeMod(player)
	if( global.players[player.index] == nil) then
		global.players[player.index] = {
			previewed_bandoleer = nil,
			active_bandoleer = nil,
			gun_1_home = nil,
			gun_2_home = nil,
			gun_3_home = nil,

			weapon_alignment = GetWeaponAlignment(player);
		};
	end

	if(player.gui.relative.weapon_bandoleer_activate_bandoleer_frame == nil) then
		local main_frame = player.gui.relative.add({
			type = "frame",
			name = "weapon_bandoleer_activate_bandoleer_frame",
			direction = "vertical",
			visible = false,
			anchor = {
				gui = defines.relative_gui_type.item_with_inventory_gui,
				position = defines.relative_gui_position.right,
			}
		});
		local frame = main_frame.add({
			type = "frame",
			name = "frame",
			direction = "vertical",
			style = "inside_shallow_frame_with_padding",
		});
		frame.add({
			type = "label",
			name = "label",
			caption = {"gui.bandoleer_label_inactive"},
		});
		frame.add({
			type = "button",
			name = "weapon_bandoleer_activate_bandoleer_button",
			caption = {"gui.activate-bandoleer"},
			tooltip = {"gui.activate-bandoleer-tooltip"},
		});
	end
end

function RotateCW(event)
	local player = game.get_player(event.player_index);
	if(player.character ~= nil) then
		local selection = player.character.selected_gun_index;
		local globals = global.players[event.player_index];
		if(globals.active_bandoleer == nil) then
			--Vanilla Weapon Functionality
			--Leaving this in as a short circuit
			--selection = selection + 1;
		elseif(globals.previewed_bandoleer == nil) then
			Rotate(event, 1);
			selection = globals.weapon_alignment + 2;
			--to offset and counter the built in weapon selector trying to move the cursor
			selection = selection - 1;
			-- Wrap selection to range
			if(selection <= 0) then selection = 3 ;
			elseif(selection >= 4) then selection = 1; end
			player.character.selected_gun_index = selection;
		end
	end
end

function RotateCCW(event)
	local player = game.get_player(event.player_index);
	if(player.character ~= nil) then
		local selection = player.character.selected_gun_index;
		local globals = global.players[event.player_index];
		if(globals.active_bandoleer == nil) then
			--Vanilla+ Weapon Functionality
			selection = selection - 1;
		elseif(globals.previewed_bandoleer == nil) then
			Rotate(event, -1);
			selection = globals.weapon_alignment + 2;
		end

		-- Wrap selection to range
		if(selection <= 0) then selection = 3 ;
		elseif(selection >= 4) then selection = 1; end
		player.character.selected_gun_index = selection;
	end
end

function Rotate(event, delta)
	local player_globals = global.players[event.player_index];

	if(player_globals.active_bandoleer ~= nil) then
		local player = game.get_player(event.player_index);
		local active_bandoleer = FindBandoleerByID(player.get_main_inventory(), player_globals.active_bandoleer);

		if(active_bandoleer == nil) then
			local player_globals = global.players[player.index];
			player_globals.active_bandoleer = nil;
			player_globals.gun_1_home = nil;
			player_globals.gun_2_home = nil;
			player_globals.gun_3_home = nil;
	
			player.print("Error: Active Weapon Bandoleer Not Found - Unlinking.");
			return;
		end


		MoveAllToBandoleer(player, active_bandoleer);

		-- The first time the bandoleer is rotated, it's health will be the default 1.0
		if(active_bandoleer.health == 1.0) then	active_bandoleer.health = 1.0 / 10000000.0;	end

		-- Get the number of guns from the label of the bandoleer
		if(active_bandoleer.label == nil) then active_bandoleer.label = "Weapon Bandoleer [1/0]"; end
		local reversed_label = string.reverse(active_bandoleer.label);
		local index_of_bracket = string.find(reversed_label, "%[");
		local forward_index_of_bracket = #active_bandoleer.label - index_of_bracket - 1;
		local number_of_guns = tonumber(string.match(string.sub(active_bandoleer.label, forward_index_of_bracket), "%w*%/(%w*)"));
		active_bandoleer.label = string.sub(active_bandoleer.label, 1, forward_index_of_bracket);
		active_bandoleer.allow_manual_label_change = true;

		-- Weapon selected index is stored in the bandoleer's healthbar
		local weapon_select_index = math.floor(active_bandoleer.health * 10000000.0 + 0.5);
		weapon_select_index = weapon_select_index + delta;
		if(weapon_select_index <= 0) then weapon_select_index = number_of_guns ;
		elseif(weapon_select_index > number_of_guns) then weapon_select_index = 1; end
		active_bandoleer.health = math.floor(weapon_select_index + 0.5) / 10000000.0;
		active_bandoleer.label = active_bandoleer.label .. string.format(" [%i/%i]", weapon_select_index, number_of_guns);

		EquipBandoleerWeapons(player, active_bandoleer);
	end
end

function JumpToIndex(event, index)
	local player_globals = global.players[event.player_index];

	if(player_globals.active_bandoleer ~= nil) then
		local player = game.get_player(event.player_index);
		local active_bandoleer = FindBandoleerByID(player.get_main_inventory(), player_globals.active_bandoleer);

		if(active_bandoleer == nil) then
			local player_globals = global.players[player.index];
			player_globals.active_bandoleer = nil;
			player_globals.gun_1_home = nil;
			player_globals.gun_2_home = nil;
			player_globals.gun_3_home = nil;
	
			player.print("Error: Active Weapon Bandoleer Not Found - Unlinking.");
			return;
		end

		MoveAllToBandoleer(player, active_bandoleer);

		-- Get the number of guns from the label of the bandoleer
		if(active_bandoleer.label == nil) then active_bandoleer.label = "Weapon Bandoleer [1/0]"; end
		local reversed_label = string.reverse(active_bandoleer.label);
		local index_of_bracket = string.find(reversed_label, "%[");
		local forward_index_of_bracket = #active_bandoleer.label - index_of_bracket - 1;
		local number_of_guns = tonumber(string.match(string.sub(active_bandoleer.label, forward_index_of_bracket), "%w*%/(%w*)"));
		active_bandoleer.label = string.sub(active_bandoleer.label, 1, forward_index_of_bracket);

		-- Weapon selected index is stored in the bandoleer's healthbar
		local weapon_select_index = index;
		if(weapon_select_index <= 0) then weapon_select_index = 1;
		elseif(weapon_select_index > number_of_guns) then weapon_select_index = number_of_guns; end
		active_bandoleer.health = math.floor(weapon_select_index + 0.5) / 10000000.0;
		active_bandoleer.label = active_bandoleer.label .. string.format(" [%i/%i]", weapon_select_index, number_of_guns);

		EquipBandoleerWeapons(player, active_bandoleer);
	end
end

-- Moves all weapons to the bandoleer's inventory according to the selected weapon index and display alignment
function MoveAllToBandoleer(player, bandoleer)
	ToggleBandoleerWeapons(player, bandoleer);
end

-- Moves 3 weapons to the bandoleer's inventory according to the selected weapon index and display alignment
function EquipBandoleerWeapons(player, bandoleer)
	ToggleBandoleerWeapons(player, bandoleer);
end

-- Swaps 3 weapons between the gunbar and the bandoleer
function ToggleBandoleerWeapons(player, bandoleer)
	if(bandoleer == nil) then
		local player_globals = global.players[player.index];
		player_globals.active_bandoleer = nil;
		player_globals.gun_1_home = nil;
		player_globals.gun_2_home = nil;
		player_globals.gun_3_home = nil;

		player.print("Error: Active Weapon Bandoleer Not Found - Unlinking.");
		return;
	end

	local bandoleer_inventory = bandoleer.get_inventory(defines.inventory.item_main);
	local globals = global.players[player.index];

	-- Construct an array with every weapon's index in it
	local slots = #bandoleer_inventory;
	local half_rows = slots / 20;
	local array_of_all_weapons = {};
	for row = 0, half_rows - 1, 1 do
		for col = 1, 10, 1 do
			local gun_slot_index = (row * 20) + col;
			local item_stack = bandoleer_inventory[gun_slot_index];
			if(
				gun_slot_index == globals.gun_1_home or
				gun_slot_index == globals.gun_2_home or
				gun_slot_index == globals.gun_3_home or
				item_stack.valid_for_read and item_stack.type == "gun")
			then
				table.insert(array_of_all_weapons, gun_slot_index);
			end
		end
	end

	if(#array_of_all_weapons == 0) then
		table.insert(array_of_all_weapons, 0);
	end
	if(#array_of_all_weapons == 1) then
		table.insert(array_of_all_weapons, 0);
	end
	if(#array_of_all_weapons == 2) then
		table.insert(array_of_all_weapons, 0);
	end

	-- Get settings and such
	if(bandoleer.health == 1.0) then bandoleer.health = 1.0 / 10000000.0; end
	local weapon_select_index = math.floor(bandoleer.health * 10000000.0 + 0.5);
	-- Map -1 -> 0, 0 -> -1, 1 -> -2
	local selection_offset = 0 - (globals.weapon_alignment + 1);

	-- Determine which weapons we will move
	local gun_slots = {};

	for i = 0, 2, 1 do
		local gun_index = weapon_select_index + i + selection_offset;
		if(gun_index <= 0) then gun_index = #array_of_all_weapons + gun_index;
		elseif(gun_index > #array_of_all_weapons) then gun_index = gun_index - #array_of_all_weapons; end
		
		gun_slots[i + 1] = array_of_all_weapons[gun_index];
	end

	globals.gun_1_home = gun_slots[1]; --3
	globals.gun_2_home = gun_slots[2]; --1
	globals.gun_3_home = gun_slots[3]; --2

	-- Move the guns and their ammo
	local gun_inventory = player.get_inventory(defines.inventory.character_guns);
	local ammo_inventory = player.get_inventory(defines.inventory.character_ammo);
	for gun_slot = 1, 3, 1 do
		local gun_index = gun_slots[gun_slot];

		if(gun_index ~= 0 and gun_index ~= nil) then
			local ammo_index = gun_index + 10;
			gun_inventory[gun_slot].swap_stack(bandoleer_inventory[gun_index]);
			ammo_inventory[gun_slot].swap_stack(bandoleer_inventory[ammo_index]);
		end
	end
end

function AppendGunAndAmmoToBandoleer(gun, ammo, bandoleer)
	local bandoleer_inventory = bandoleer.get_inventory(defines.inventory.item_main);
	local slots = #bandoleer_inventory;
	local rows = slots / 10;
	for row = 0, rows, 2 do
		for col = 1, 10, 1 do
			local gun_slot_index = (row * 10) + col;
			local ammo_slot_index = ((row + 1) * 10) + col;
			local gun_slot = bandoleer_inventory[gun_slot_index];
			local ammo_slot = bandoleer_inventory[ammo_slot_index];
			if(not gun_slot.valid_for_read and not ammo_slot.valid_for_read) then
				gun.swap_stack(gun_slot);
				ammo.swap_stack(ammo_slot);
				return;
			end
		end
	end
end

function MoveGunToBandoleer(gun, bandoleer, slot_index)
	gun.swap_stack(bandoleer.get_inventory(defines.inventory.item_main)[slot_index]);
end

function MoveAmmoToBandoleer(ammo, bandoleer, slot_index)
	ammo.swap_stack(bandoleer.get_inventory(defines.inventory.item_main)[slot_index]);
end

-- Configures the weapon bar for bandoleer control when a bandoleer is equiped
function CommisionBandoleerControlledWeaponBar(event)
	-- Add current weapons to bandoleer
	MoveAllToBandoleer(event);
	-- Equip bandoleer weapons
	EquipBandoleerWeapons(event);

	-- Set up sprites

end

function DecommisionBandoleerControlledWeaponBar(event)
	-- Return weapons to bandoleer
	MoveAllToBandoleer(event);

	-- Remove speciel ui elements
end

function FindBandoleerByID(inventory, bandoleer_id)
	local count = #inventory;
	for i = 1, count, 1 do
		local item_number = inventory[i].item_number;
		if(item_number ~= nil and item_number == bandoleer_id) then
			return inventory[i];
		end
	end
	return nil;
end

function GetWeaponAlignment(player)
	local alignment = 0;
	local alignment_setting = settings.get_player_settings(player.index)["weapon-bandoleer-weapon-alignment-setting"].value;
	if(alignment_setting == "weapon-bandoleer-weapon-alignment-left-setting") then
		alignment = -1;
	elseif(alignment_setting == "weapon-bandoleer-weapon-alignment-center-setting") then
		alignment = 0;
	elseif(alignment_setting == "weapon-bandoleer-weapon-alignment-right-setting") then
		alignment = 1;
	end
	return alignment;
end

function FadeFunction(t)
	return math.max(0, math.pow((t - 90.0) / 6.3, 2.0) * -0.5 + 100.0);
end