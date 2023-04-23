local all_ammo_items = data.raw["ammo"];
local all_gun_items = data.raw["gun"];
local bandoleer_item_whitelist = data.raw["item-with-inventory"]["weapon-bandoleer"].item_filters;

-- Add all the ammo items to the whitelist
for name, prototype in pairs(all_ammo_items) do
	table.insert(bandoleer_item_whitelist, name);
end

-- Add all the gun items to the whitelist
for name, prototype in pairs(all_gun_items) do
	table.insert(bandoleer_item_whitelist, name);
end