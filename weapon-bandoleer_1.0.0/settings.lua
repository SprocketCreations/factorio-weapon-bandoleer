data:extend({
    {
		-- Mod Setting
        default_value = "weapon-bandoleer-weapon-alignment-center-setting",
		allowed_values = {
			"weapon-bandoleer-weapon-alignment-left-setting",
			"weapon-bandoleer-weapon-alignment-center-setting",
			"weapon-bandoleer-weapon-alignment-right-setting"},
        setting_type = "runtime-per-user",
		-- Base
        type = "string-setting",
        name = "weapon-bandoleer-weapon-alignment-setting",
		order = "n",
    },
});