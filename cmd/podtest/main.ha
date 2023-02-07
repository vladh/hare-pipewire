use fmt;
use sp = spapod;

export fn main() void = {
	let buffer: []u32 = alloc([0...], 1024);
	let builder: sp::builder = sp::builder { ... };
	sp::push_object(&buffer, &builder,
		sp::spa_type::OBJECT_Format,
		sp::spa_param_type::EnumFormat: u32);
	sp::add_prop(&buffer, &builder,
		sp::spa_format::AUDIO_format: u32, 0);
	sp::add_int(&buffer, &builder, 69);
	sp::pop(&buffer, &builder);
	sp::print_buffer(&buffer, &builder);
};
