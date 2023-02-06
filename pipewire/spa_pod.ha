export type spa_command = void; // opaque

export def SPA_POD_BUILDER_FLAG_BODY: u32 = 1 << 0;
export def SPA_POD_BUILDER_FLAG_FIRST: u32 = 1 << 1;

export type spa_pod = struct {
	sz: u32,
	type_: u32,
};

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

export type spa_pod_frame = struct {
	pod: spa_pod,
	parent: *spa_pod_frame,
	offset_: u32,
	flags: u32,
};

export type spa_pod_object_body = struct {
	type_: u32,
	id: u32,
};

export type spa_pod_object = struct {
	pod: spa_pod,
	body: spa_pod_object_body,
};
