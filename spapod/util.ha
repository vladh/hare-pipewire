use fmt;

export fn print_buffer(
	buffer: *[]u32,
	builder: *builder,
) void = {
	for (let i = 0z; i < builder.idx; i += 1) {
		fmt::printf("{} ", buffer[i])!;
	};
	fmt::println("")!;
};
