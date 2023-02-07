export type spa_callbacks = struct {
	funcs: nullable *void,
	data: nullable *void,
};

export type spa_dict_item = struct {
	key: nullable *char,
	value: nullable *char,
};

export type spa_dict = struct {
	flags: u32,
	n_items: u32,
	items: nullable *spa_dict_item,
};

export type spa_direction = enum {
	SPA_DIRECTION_INPUT = 0,
	SPA_DIRECTION_OUTPUT = 1,
};
export type pw_direction = enum {
	PW_DIRECTION_INPUT = 0,
	PW_DIRECTION_OUTPUT = 1,
};
