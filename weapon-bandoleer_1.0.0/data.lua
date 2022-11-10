data:extend({
	{
		-- Custom Input
		key_sequence = "CONTROL + 1",
		consuming = "none",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-1",
		order = "ba",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + 2",
		consuming = "none",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-2",
		order = "bb",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + 3",
		consuming = "none",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-3",
		order = "bc",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + 4",
		consuming = "none",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-4",
		order = "bd",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + 5",
		consuming = "none",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-5",
		order = "be",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + 6",
		consuming = "none",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-6",
		order = "bf",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + 7",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-7",
		order = "bg",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + 8",
		consuming = "none",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-8",
		order = "bh",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + 9",
		consuming = "none",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-9",
		order = "bi",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + 0",
		consuming = "none",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-weapon-0",
		order = "bj",
	},
	{
		-- Custom Input
		key_sequence = "",
		linked_game_control = "next-weapon",
		consuming = "game-only",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-next-weapon",
		order = "a",
	},
	{
		-- Custom Input
		key_sequence = "CONTROL + TAB",
		consuming = "game-only",
		action = "lua",
		-- Base
		type = "custom-input",
		name = "weapon-bandoleer-input-previous-weapon",
		order = "ab",
	},
	{
		-- Subgroup
		group = "combat",
		-- Base
		type = "item-subgroup",
		name = "bandoleer",
		order = "bb", --Ammo is "b"
	},
	{
		--Item With Inventory
		inventory_size = 20,
		 -- this allows bots to satisfy logistics requests to the bandoleer's inventory
		extends_inventory_by_default = true,
		subgroup = "bandoleer",
		item_subgroup_filters = {"gun", "ammo"},
		--Item
		icon = "__weapon-bandoleer__/graphics/icons/item/weapon-bandoleer.png",
		icon_size = 32,
		stack_size = 1,
		--Base
		type = "item-with-inventory",
		name = "weapon-bandoleer",
		order = "n",
	},
	{
		--Recipe
		ingredients = {{"iron-plate", 4}, {"iron-stick", 4}, {"wood", 4}},
		enabled = false,
		result = "weapon-bandoleer",
		energy_required = 10.0,
		--Base
		type = "recipe",
		name = "weapon-bandoleer",
	},
	{
		--Technology
		icon = "__weapon-bandoleer__/graphics/icons/technology/weapon-bandoleer.png",
		icon_size = 256,
		unit = {
			count = 200,
			time = 30.0,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"military-science-pack", 1},
			},
		},
		prerequisites = {"military"},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "weapon-bandoleer",
			},
		},
		--Base
		type = "technology",
		name = "weapon-bandoleer",
	},
});