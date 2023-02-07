use fmt;

export type builder_container = struct {
	type_: spa_type,
	start_idx: size,
};

export type builder = struct {
	stack: []builder_container,
	idx: size,
};

export fn add(
	buffer: *[_]u32,
	builder: *builder,
	value: u32,
) void = {
	buffer[builder.idx] = value;
	builder.idx += 1;
};

export fn add_padding(
	buffer: *[_]u32,
	builder: *builder,
) void = {
	add(buffer, builder, 0);
};

export fn record_bytelen(
	buffer: *[_]u32,
	builder: *builder,
	value: u32,
) void = {
	const last_container = builder.stack[len(builder.stack) - 1];
	buffer[last_container.start_idx] += value;
};

export fn push_struct(
	buffer: *[_]u32,
	builder: *builder,
) void = {
	append(builder.stack, builder_container {
		type_ = spa_type::Struct,
		start_idx = builder.idx,
	});
	add(buffer, builder, 0); // bytelen
	add(buffer, builder, spa_type::Struct); // type
};

export fn pop(
	buffer: *[_]u32,
	builder: *builder,
) void = {
	void;
};

export fn add_int(
	buffer: *[_]u32,
	builder: *builder,
	value: i32,
) void = {
	const gross_bytelen = (size(u32) * 4): u32;
	const net_bytelen = (size(u32) * 1): u32;
	record_bytelen(buffer, builder, gross_bytelen);
	add(buffer, builder, net_bytelen); // bytelen
	add(buffer, builder, spa_type::Int); // type
	add(buffer, builder, value: u32); // value
	add_padding(buffer, builder); // padding
};

export fn print_buffer(
	buffer: *[_]u32,
	builder: *builder,
) void = {
	for (let i = 0z; i < builder.idx; i += 1) {
		fmt::printf("{} ", buffer[i])!;
	};
	fmt::println("")!;
};
