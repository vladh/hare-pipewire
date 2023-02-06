export type pw_main_loop = void; // opaque
export type pw_loop = void; // opaque

export @symbol("pw_main_loop_new") fn pw_main_loop_new(
	props: nullable *spa_dict,
) nullable *pw_main_loop;

export @symbol("pw_main_loop_get_loop") fn pw_main_loop_get_loop(
	loop: nullable *pw_main_loop,
) nullable *pw_loop;
