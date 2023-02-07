use fmt;
use sp = spapod;

export fn main() void = {
	let buffer: [1024]u32 = [0...];
	let builder: sp::builder = sp::builder { ... };
	sp::push_struct(&buffer, &builder);
	sp::add_int(&buffer, &builder, 69);
	sp::add_int(&buffer, &builder, 69);
	sp::pop(&buffer, &builder);
	sp::print_buffer(&buffer, &builder);
};
