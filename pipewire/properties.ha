export type pw_properties = void; // opqaue

export @symbol("pw_properties_new") fn pw_properties_new(
	key: nullable *char, ...
) nullable *pw_properties;
