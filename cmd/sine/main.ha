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
	let params: []nullable *pw::spa_pod = [null: *pw::spa_pod];
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

	params[0] = pw::spa_format_audio_raw_build(&b,
		pw::spa_param_type::SPA_PARAM_EnumFormat,
		&pw::spa_audio_info_raw {
			format = pw::spa_audio_format::SPA_AUDIO_FORMAT_S16,
			channels = DEFAULT_CHANNELS,
			rate = DEFAULT_RATE,
			...
		});

	fmt::printfln("hello")!;
};
