use fmt;
use math;
use pipewire;

type state = struct {
	loop: *pipewire::pw_main_loop,
	stream: *pipewire::pw_stream,
	accumulator: f64,
};

def TWO_PI: f64 = math::PI;
def DEFAULT_RATE: u32 = 44100;
def DEFAULT_CHANNELS: u32 = 2;
def DEFAULT_VOLUME: f32 = 0.7;

export fn main() void = {
	let state = state { ... };
	let params: []*pipewire::spa_pod = [null];
	fmt::println("hello")!;
};
