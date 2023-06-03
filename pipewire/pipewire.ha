use types::c;

export @symbol("pw_init") fn pw_init(
	argc: *int,
	argc: nullable * nullable **c::char,
) void;
