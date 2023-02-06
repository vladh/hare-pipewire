export type pw_properties = struct {
	dict: spa_dict,
	flags: u32,
};

export @symbol("pw_properties_new") fn pw_properties_new(
	key: nullable *char, ...
) nullable *pw_properties;
