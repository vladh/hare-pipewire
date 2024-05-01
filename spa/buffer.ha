export type spa_chunk_flag = enum u32 {
	SPA_CHUNK_FLAG_NONE = 0,
	SPA_CHUNK_FLAG_CORRUPTED = 1 << 0,
	SPA_CHUNK_FLAG_EMPTY = 1 << 1,
};

export type spa_data_flag = enum u32 {
	SPA_DATA_FLAG_NONE = 0b000,
	SPA_DATA_FLAG_READABLE = 0b001,
	SPA_DATA_FLAG_WRITABLE = 0b010,
	SPA_DATA_FLAG_DYNAMIC = 0b100,
	SPA_DATA_FLAG_READWRITE	= 0b111,
};

export type spa_meta = struct {
	type_: u32,
	sz: u32,
	data: nullable *opaque,
};

export type spa_chunk = struct {
	offset_: u32,
	sz: u32,
	stride: i32,
	flags: u32,
};

export type spa_data = struct {
	type_: u32,
	flags: u32,
	fd: i64,
	mapoffset: u32,
	maxsize: u32,
	data: *opaque,
	chunk: *spa_chunk,
};

export type spa_buffer = struct {
	n_metas: u32,
	n_datas: u32,
	metas: nullable *spa_meta,
	datas: nullable *spa_data,
};
