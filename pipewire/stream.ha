export type pw_stream = void; // opaque
export type pw_stream_control = void; // opaque
export type pw_buffer = void; // opaque
export def PW_VERSION_STREAM_EVENTS: u32 = 2;
export type pw_stream_state = enum {
	PW_STREAM_STATE_ERROR = -1,
	PW_STREAM_STATE_UNCONNECTED = 0,
	PW_STREAM_STATE_CONNECTING = 1,
	PW_STREAM_STATE_PAUSED = 2,
	PW_STREAM_STATE_STREAMING = 3,
};

export type pw_stream_events = struct {
	version: u32,
	destroy: *fn(data: nullable *void) void,
	state_changed: *fn(data: nullable *void,
		old: pw_stream_state,
		state: pw_stream_state,
		error: nullable *char) void,
	control_info: *fn(data: nullable *void,
		id: u32,
		control: nullable *pw_stream_control) void,
	io_changed: *fn(data: nullable *void,
		id: u32,
		area: nullable *void,
		sz: u32) void,
	param_changed: *fn(data: nullable *void,
		id: u32,
		param: nullable *spa_pod) void,
	add_buffer: *fn(data: nullable *void,
		buffer: nullable *pw_buffer) void,
	remove_buffer: *fn(data: nullable *void,
		buffer: nullable *pw_buffer) void,
	process: *fn(data: nullable *void) void,
	drained: *fn(data: nullable *void) void,
	command: *fn(data: nullable *void,
		command: nullable *spa_command) void,
	trigger_done: *fn(data: nullable *void) void,
};

export @symbol("pw_stream_new_simple") fn pw_stream_new_simple(
	loop: nullable *pw_loop,
	name: nullable *char,
	props: nullable *pw_properties,
	events: nullable *pw_stream_events,
	data: nullable *void,
) *pw_stream;
