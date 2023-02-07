def U32_SIZE: u32 = 4;

export type builder_container = struct {
	ctype: spa_type,
	start_idx: size,
};

export type builder = struct {
	stack: []builder_container,
	idx: size,
	added_bytelen: size,
	added_container_bytelen: size,
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

export fn add_clen(
	buffer: *[]u32,
	builder: *builder,
	value: u32,
) void = {
	add_nolen(buffer, builder, value);
	builder.added_container_bytelen += U32_SIZE;
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
	builder.added_bytelen = 0;
};

export fn push_struct(
	buffer: *[]u32,
	builder: *builder,
) void = {
	append(builder.stack, builder_container {
		ctype = spa_type::Struct,
		start_idx = builder.idx,
	});
	add(buffer, builder, 0); // bytelen
	add(buffer, builder, spa_type::Struct); // type
};

export fn push_object(
	buffer: *[]u32,
	builder: *builder,
	otype: u32,
	oid: u32,
) void = {
	append(builder.stack, builder_container {
		ctype = spa_type::Object,
		start_idx = builder.idx,
	});
	add_clen(buffer, builder, 0); // bytelen
	add_clen(buffer, builder, spa_type::Object); // type
	add(buffer, builder, otype); // otype
	add(buffer, builder, oid); // oid
	record_bytelen(buffer, builder);
};

export fn push_array(
	buffer: *[]u32,
	builder: *builder,
	atype: u32,
	atypelen: u32,
) void = {
	append(builder.stack, builder_container {
		ctype = spa_type::Array,
		start_idx = builder.idx,
	});
	add_clen(buffer, builder, 0); // bytelen
	add_clen(buffer, builder, spa_type::Array); // type
	add(buffer, builder, atypelen); // atypelen
	add(buffer, builder, atype); // atype
	record_bytelen(buffer, builder);
};

export fn pop(
	buffer: *[]u32,
	builder: *builder,
) void = {
	if (len(builder.stack) == 1) {
		return;
	};
	const last_container = builder.stack[len(builder.stack) - 1];
	const parent_container = builder.stack[len(builder.stack) - 2];
	buffer[parent_container.start_idx] +=
		buffer[last_container.start_idx] +
		builder.added_container_bytelen: u32;
	delete(builder.stack[len(builder.stack) - 1]);
	add_padding_if_needed(buffer, builder);
	builder.added_container_bytelen = 0;
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
	const last_container = builder.stack[len(builder.stack) - 1];
	add(buffer, builder, U32_SIZE); // bytelen
	add(buffer, builder, spa_type::Int); // type
	add(buffer, builder, value: u32); // value
	add_padding_if_needed(buffer, builder);
	record_bytelen(buffer, builder);
};

export fn add_id(
	buffer: *[]u32,
	builder: *builder,
	value: u32,
) void = {
	const last_container = builder.stack[len(builder.stack) - 1];
	add(buffer, builder, U32_SIZE); // bytelen
	add(buffer, builder, spa_type::Id); // type
	add(buffer, builder, value: u32); // value
	add_padding_if_needed(buffer, builder);
	record_bytelen(buffer, builder);
};

export fn add_array_val(
	buffer: *[]u32,
	builder: *builder,
	value: u32,
) void = {
	const last_container = builder.stack[len(builder.stack) - 1];
	add(buffer, builder, value);
	record_bytelen(buffer, builder);
};
