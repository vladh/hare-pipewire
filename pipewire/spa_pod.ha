export type spa_command = void; // opaque

export type spa_pod = struct {
	sz: u32,
	type_: u32,
};

export type spa_pod_frame = void; // opaque

export type spa_pod_builder_state = struct {
	offset_: u32,
	flags: u32,
	frame: *spa_pod_frame,
};

export type spa_pod_builder = struct {
	data: nullable *void,
	sz: u32,
	_padding: u32,
	state: spa_pod_builder_state,
	callbacks: spa_callbacks,
};
