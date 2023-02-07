use fmt;
use sp = spapod;

export fn main() void = {
	let buffer: []u32 = alloc([0...], 1024);
	let builder: sp::builder = sp::builder { ... };
	sp::push_struct(&buffer, &builder);
	sp::add_int(&buffer, &builder, 69);
	sp::add_int(&buffer, &builder, 69);
	sp::pop(&buffer, &builder);
	sp::print_buffer(&buffer, &builder);
};
