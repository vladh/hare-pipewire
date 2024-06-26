use spa;
use types::c;

export type pw_stream = opaque;
export type pw_stream_control = opaque;
export type pw_direction = enum {
	PW_DIRECTION_INPUT = 0,
	PW_DIRECTION_OUTPUT = 1,
};
export type pw_buffer = struct {
	buffer: *spa::spa_buffer,
	user_data: *opaque,
	sz: u64,
	requested: u64,
};
export def PW_VERSION_STREAM_EVENTS: u32 = 2;
export type pw_stream_state = enum {
	PW_STREAM_STATE_ERROR = -1,
	PW_STREAM_STATE_UNCONNECTED = 0,
	PW_STREAM_STATE_CONNECTING = 1,
	PW_STREAM_STATE_PAUSED = 2,
	PW_STREAM_STATE_STREAMING = 3,
};
export type pw_stream_flags = enum u32 {
	PW_STREAM_FLAG_NONE = 0,
	PW_STREAM_FLAG_AUTOCONNECT = (1 << 0),
	PW_STREAM_FLAG_INACTIVE = (1 << 1),
	PW_STREAM_FLAG_MAP_BUFFERS = (1 << 2),
	PW_STREAM_FLAG_DRIVER = (1 << 3),
	PW_STREAM_FLAG_RT_PROCESS = (1 << 4),
	PW_STREAM_FLAG_NO_CONVERT = (1 << 5),
	PW_STREAM_FLAG_EXCLUSIVE = (1 << 6),
	PW_STREAM_FLAG_DONT_RECONNECT = (1 << 7),
	PW_STREAM_FLAG_ALLOC_BUFFERS = (1 << 8),
	PW_STREAM_FLAG_TRIGGER = (1 << 9),
};

export type pw_stream_events = struct {
	version: u32,
	destroy: nullable *fn(data: nullable *opaque) void,
	state_changed: nullable *fn(data: nullable *opaque,
		old: pw_stream_state,
		state: pw_stream_state,
		error: nullable *c::char) void,
	control_info: nullable *fn(data: nullable *opaque,
		id: u32,
		control: nullable *pw_stream_control) void,
	io_changed: nullable *fn(data: nullable *opaque,
		id: u32,
		area: nullable *opaque,
		sz: u32) void,
	param_changed: nullable *fn(data: nullable *opaque,
		id: u32,
		param: nullable *spa::spa_pod) void,
	add_buffer: nullable *fn(data: nullable *opaque,
		buffer: nullable *pw_buffer) void,
	remove_buffer: nullable *fn(data: nullable *opaque,
		buffer: nullable *pw_buffer) void,
	process: nullable *fn(data: nullable *opaque) void,
	drained: nullable *fn(data: nullable *opaque) void,
	command: nullable *fn(data: nullable *opaque,
		command: nullable *spa::spa_command) void,
	trigger_done: nullable *fn(data: nullable *opaque) void,
};

export @symbol("pw_stream_new_simple") fn pw_stream_new_simple(
	loop: nullable *pw_loop,
	name: nullable *c::char,
	props: nullable *pw_properties,
	events: nullable *pw_stream_events,
	data: nullable *opaque,
) *pw_stream;

export @symbol("pw_stream_connect") fn pw_stream_connect(
	stream: *pw_stream,
	direction: pw_direction,
	target_id: u32,
	flags: pw_stream_flags,
	params: **spa::spa_pod,
	n_params: u32,
) int;

export @symbol("pw_stream_destroy") fn pw_stream_destroy(
	stream: *pw_stream,
) void;

export @symbol("pw_stream_dequeue_buffer") fn pw_stream_dequeue_buffer(
	stream: *pw_stream,
) nullable *pw_buffer;

export @symbol("pw_stream_queue_buffer") fn pw_stream_queue_buffer(
	stream: *pw_stream,
	buffer: *pw_buffer,
) int;
