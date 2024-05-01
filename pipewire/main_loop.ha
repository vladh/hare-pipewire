export type pw_main_loop = opaque;
export type pw_loop = opaque;
export type spa_dict = opaque;

export @symbol("pw_main_loop_new") fn pw_main_loop_new(
	props: nullable *spa_dict,
) nullable *pw_main_loop;

export @symbol("pw_main_loop_get_loop") fn pw_main_loop_get_loop(
	loop: nullable *pw_main_loop,
) nullable *pw_loop;

export @symbol("pw_main_loop_run") fn pw_main_loop_run(
	loop: *pw_main_loop
) int;

export @symbol("pw_main_loop_destroy") fn pw_main_loop_destroy(
	loop: *pw_main_loop
) void;
