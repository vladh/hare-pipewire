use fmt;
use sp = spapod;

def DEFAULT_RATE: u32 = 44100;
def DEFAULT_CHANNELS: u32 = 2;

export fn main() void = {
	let buf: []u32 = alloc([0...], 1024);
	let b: sp::builder = sp::builder { ... };
	sp::push_object(&buf, &b,
		sp::spa_type::OBJECT_Format,
		sp::spa_param_type::EnumFormat: u32);
	sp::add_prop(&buf, &b, sp::spa_format::mediaType: u32, 0);
	sp::add_id(&buf, &b, sp::spa_media_type::audio);
	sp::add_prop(&buf, &b, sp::spa_format::mediaSubtype: u32, 0);
	sp::add_id(&buf, &b, sp::spa_media_subtype::raw);
	sp::add_prop(&buf, &b, sp::spa_format::AUDIO_format: u32, 0);
	sp::add_id(&buf, &b, sp::spa_audio_format::S16);
	sp::add_prop(&buf, &b, sp::spa_format::AUDIO_rate: u32, 0);
	sp::add_int(&buf, &b, DEFAULT_RATE: i32);
	sp::add_prop(&buf, &b, sp::spa_format::AUDIO_channels: u32, 0);
	sp::add_int(&buf, &b, DEFAULT_CHANNELS: i32);
	sp::add_prop(&buf, &b, sp::spa_format::AUDIO_position: u32, 0);
	sp::push_array(&buf, &b, sp::spa_type::Id, size(u32): u32);
	sp::add_array_val(&buf, &b, 69);
	sp::add_array_val(&buf, &b, 420);
	sp::pop(&buf, &b);
	sp::pop(&buf, &b);
	sp::print_buffer(&buf, &b);
};
