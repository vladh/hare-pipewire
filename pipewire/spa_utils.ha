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
