use types::c;

export type pw_properties = opaque;

export @symbol("pw_properties_new") fn pw_properties_new(
	key: nullable *c::char, ...
) nullable *pw_properties;
