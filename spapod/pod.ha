use fmt;

def U32_SIZE: u32 = 4;

export type builder_container = struct {
	type_: spa_type,
	start_idx: size,
};

export type builder = struct {
	stack: []builder_container,
	idx: size,
	added_bytelen: size,
};

export fn add_nolen(
	buffer: *[]u32,
	builder: *builder,
	value: u32,
) void = {
	assert(builder.idx + 1 < len(buffer));
	buffer[builder.idx] = value;
	builder.idx += 1;
};

export fn add(
	buffer: *[]u32,
	builder: *builder,
	value: u32,
) void = {
	add_nolen(buffer, builder, value);
	builder.added_bytelen += U32_SIZE;
};

export fn add_padding_if_needed(
	buffer: *[]u32,
	builder: *builder,
) void = {
	if (builder.idx % 2 != 0) {
		add(buffer, builder, 0);
	};
};

export fn record_bytelen(
	buffer: *[]u32,
	builder: *builder,
) void = {
	const value = builder.added_bytelen: u32;
	const last_container = builder.stack[len(builder.stack) - 1];
	buffer[last_container.start_idx] += value;
	fmt::println(builder.added_bytelen)!;
	builder.added_bytelen = 0;
};

export fn push_struct(
	buffer: *[]u32,
	builder: *builder,
) void = {
	append(builder.stack, builder_container {
		type_ = spa_type::Struct,
		start_idx = builder.idx,
	});
	add(buffer, builder, 0); // bytelen
	add(buffer, builder, spa_type::Struct); // type
};

export fn push_object(
	buffer: *[]u32,
	builder: *builder,
	otype: spa_type,
	oid: u32,
) void = {
	append(builder.stack, builder_container {
		type_ = spa_type::Object,
		start_idx = builder.idx,
	});
	add_nolen(buffer, builder, 0); // bytelen
	add_nolen(buffer, builder, spa_type::Object); // type
	add(buffer, builder, otype: u32); // otype
	add(buffer, builder, oid); // oid
	record_bytelen(buffer, builder);
};

export fn pop(
	buffer: *[]u32,
	builder: *builder,
) void = {
	void;
};

export fn add_prop(
	buffer: *[]u32,
	builder: *builder,
	value: u32,
	flags: u32,
) void = {
	add(buffer, builder, value); // key
	add(buffer, builder, flags); // flags
	record_bytelen(buffer, builder);
};

export fn add_int(
	buffer: *[]u32,
	builder: *builder,
	value: i32,
) void = {
	add(buffer, builder, U32_SIZE); // bytelen
	add(buffer, builder, spa_type::Int); // type
	add(buffer, builder, value: u32); // value
	add_padding_if_needed(buffer, builder);
	record_bytelen(buffer, builder);
};

export fn print_buffer(
	buffer: *[]u32,
	builder: *builder,
) void = {
	for (let i = 0z; i < builder.idx; i += 1) {
		fmt::printf("{} ", buffer[i])!;
	};
	fmt::println("")!;
};
