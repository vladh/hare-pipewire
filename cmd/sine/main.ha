use fmt;
use math;
use os;
use pw = pipewire;

type state = struct {
	loop: nullable *pw::pw_main_loop,
	stream: nullable *pw::pw_stream,
	accumulator: f64,
};

def TWO_PI: f64 = math::PI;
def DEFAULT_RATE: u32 = 44100;
def DEFAULT_CHANNELS: u32 = 2;
def DEFAULT_VOLUME: f32 = 0.7;

fn process(data: nullable *void) void = {
	void;
};

def STREAM_EVENTS: pw::pw_stream_events = pw::pw_stream_events {
	version = pw::PW_VERSION_STREAM_EVENTS,
	process = &process,
	...
};

export fn main() void = {
	let state = state { ... };
	let buffer: [1024]u8 = [0...];
	let b: pw::spa_pod_builder = pw::spa_pod_builder {
		data = &buffer[0]: nullable *void,
		sz = (size(u8) * 1024): u32,
		...
	};
	const argc: int = 0;
	const argv: nullable **char = null;
	pw::pw_init(&argc, &argv);
	state.loop = pw::pw_main_loop_new(null);
	state.stream = pw::pw_stream_new_simple(
		pw::pw_main_loop_get_loop(state.loop),
		pw::strtoc("audio-src\0"),
		pw::pw_properties_new(
			pw::strtoc(pw::PW_KEY_MEDIA_TYPE), pw::strtoc("Audio\0"),
			pw::strtoc(pw::PW_KEY_MEDIA_CATEGORY), pw::strtoc("Playback\0"),
			pw::strtoc(pw::PW_KEY_MEDIA_ROLE), pw::strtoc("Music\0"),
			null),
		&STREAM_EVENTS,
		&state);

	let params: []*pw::spa_pod = [
		pw::spa_format_audio_raw_build(&b,
			pw::spa_param_type::SPA_PARAM_EnumFormat,
			&pw::spa_audio_info_raw {
				format = pw::spa_audio_format::SPA_AUDIO_FORMAT_S16,
				channels = DEFAULT_CHANNELS,
				rate = DEFAULT_RATE,
				...
			}) as *pw::spa_pod,
	];

	const stream = state.stream as *pw::pw_stream;
	const loop = state.loop as *pw::pw_main_loop;

	pw::pw_stream_connect(stream,
		pw::pw_direction::PW_DIRECTION_OUTPUT,
		pw::PW_ID_ANY,
		pw::pw_stream_flags::PW_STREAM_FLAG_AUTOCONNECT |
		pw::pw_stream_flags::PW_STREAM_FLAG_MAP_BUFFERS |
		pw::pw_stream_flags::PW_STREAM_FLAG_RT_PROCESS,
		&params[0],
		1);

	pw::pw_main_loop_run(loop);

	pw::pw_stream_destroy(stream);
	pw::pw_main_loop_destroy(loop);
};
