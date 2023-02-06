use rt;

def SPA_AUDIO_MAX_CHANNELS: uint = 64;
def SPA_AUDIO_FLAG_NONE: u32 = 0;
def SPA_AUDIO_FLAG_UNPOSITIONED: u32 = 1 << 0;
export type spa_audio_format = enum {
	SPA_AUDIO_FORMAT_UNKNOWN,
	SPA_AUDIO_FORMAT_ENCODED,
	SPA_AUDIO_FORMAT_START_Interleaved = 0x100,
	SPA_AUDIO_FORMAT_S8,
	SPA_AUDIO_FORMAT_U8,
	SPA_AUDIO_FORMAT_S16_LE,
	SPA_AUDIO_FORMAT_S16_BE,
	SPA_AUDIO_FORMAT_U16_LE,
	SPA_AUDIO_FORMAT_U16_BE,
	SPA_AUDIO_FORMAT_S24_32_LE,
	SPA_AUDIO_FORMAT_S24_32_BE,
	SPA_AUDIO_FORMAT_U24_32_LE,
	SPA_AUDIO_FORMAT_U24_32_BE,
	SPA_AUDIO_FORMAT_S32_LE,
	SPA_AUDIO_FORMAT_S32_BE,
	SPA_AUDIO_FORMAT_U32_LE,
	SPA_AUDIO_FORMAT_U32_BE,
	SPA_AUDIO_FORMAT_S24_LE,
	SPA_AUDIO_FORMAT_S24_BE,
	SPA_AUDIO_FORMAT_U24_LE,
	SPA_AUDIO_FORMAT_U24_BE,
	SPA_AUDIO_FORMAT_S20_LE,
	SPA_AUDIO_FORMAT_S20_BE,
	SPA_AUDIO_FORMAT_U20_LE,
	SPA_AUDIO_FORMAT_U20_BE,
	SPA_AUDIO_FORMAT_S18_LE,
	SPA_AUDIO_FORMAT_S18_BE,
	SPA_AUDIO_FORMAT_U18_LE,
	SPA_AUDIO_FORMAT_U18_BE,
	SPA_AUDIO_FORMAT_F32_LE,
	SPA_AUDIO_FORMAT_F32_BE,
	SPA_AUDIO_FORMAT_F64_LE,
	SPA_AUDIO_FORMAT_F64_BE,
	SPA_AUDIO_FORMAT_ULAW,
	SPA_AUDIO_FORMAT_ALAW,
	SPA_AUDIO_FORMAT_START_Planar = 0x200,
	SPA_AUDIO_FORMAT_U8P,
	SPA_AUDIO_FORMAT_S16P,
	SPA_AUDIO_FORMAT_S24_32P,
	SPA_AUDIO_FORMAT_S32P,
	SPA_AUDIO_FORMAT_S24P,
	SPA_AUDIO_FORMAT_F32P,
	SPA_AUDIO_FORMAT_F64P,
	SPA_AUDIO_FORMAT_S8P,
	SPA_AUDIO_FORMAT_START_Other = 0x400,
	SPA_AUDIO_FORMAT_DSP_S32 = SPA_AUDIO_FORMAT_S24_32P,
	SPA_AUDIO_FORMAT_DSP_F32 = SPA_AUDIO_FORMAT_F32P,
	SPA_AUDIO_FORMAT_DSP_F64 = SPA_AUDIO_FORMAT_F64P,
	// Fields from here on are specific to little endian
	// TODO: big endian
	SPA_AUDIO_FORMAT_S16 = SPA_AUDIO_FORMAT_S16_LE,
	SPA_AUDIO_FORMAT_U16 = SPA_AUDIO_FORMAT_U16_LE,
	SPA_AUDIO_FORMAT_S24_32 = SPA_AUDIO_FORMAT_S24_32_LE,
	SPA_AUDIO_FORMAT_U24_32 = SPA_AUDIO_FORMAT_U24_32_LE,
	SPA_AUDIO_FORMAT_S32 = SPA_AUDIO_FORMAT_S32_LE,
	SPA_AUDIO_FORMAT_U32 = SPA_AUDIO_FORMAT_U32_LE,
	SPA_AUDIO_FORMAT_S24 = SPA_AUDIO_FORMAT_S24_LE,
	SPA_AUDIO_FORMAT_U24 = SPA_AUDIO_FORMAT_U24_LE,
	SPA_AUDIO_FORMAT_S20 = SPA_AUDIO_FORMAT_S20_LE,
	SPA_AUDIO_FORMAT_U20 = SPA_AUDIO_FORMAT_U20_LE,
	SPA_AUDIO_FORMAT_S18 = SPA_AUDIO_FORMAT_S18_LE,
	SPA_AUDIO_FORMAT_U18 = SPA_AUDIO_FORMAT_U18_LE,
	SPA_AUDIO_FORMAT_F32 = SPA_AUDIO_FORMAT_F32_LE,
	SPA_AUDIO_FORMAT_F64 = SPA_AUDIO_FORMAT_F64_LE,
	SPA_AUDIO_FORMAT_S16_OE = SPA_AUDIO_FORMAT_S16_BE,
	SPA_AUDIO_FORMAT_U16_OE = SPA_AUDIO_FORMAT_U16_BE,
	SPA_AUDIO_FORMAT_S24_32_OE = SPA_AUDIO_FORMAT_S24_32_BE,
	SPA_AUDIO_FORMAT_U24_32_OE = SPA_AUDIO_FORMAT_U24_32_BE,
	SPA_AUDIO_FORMAT_S32_OE = SPA_AUDIO_FORMAT_S32_BE,
	SPA_AUDIO_FORMAT_U32_OE = SPA_AUDIO_FORMAT_U32_BE,
	SPA_AUDIO_FORMAT_S24_OE = SPA_AUDIO_FORMAT_S24_BE,
	SPA_AUDIO_FORMAT_U24_OE = SPA_AUDIO_FORMAT_U24_BE,
	SPA_AUDIO_FORMAT_S20_OE = SPA_AUDIO_FORMAT_S20_BE,
	SPA_AUDIO_FORMAT_U20_OE = SPA_AUDIO_FORMAT_U20_BE,
	SPA_AUDIO_FORMAT_S18_OE = SPA_AUDIO_FORMAT_S18_BE,
	SPA_AUDIO_FORMAT_U18_OE = SPA_AUDIO_FORMAT_U18_BE,
	SPA_AUDIO_FORMAT_F32_OE = SPA_AUDIO_FORMAT_F32_BE,
	SPA_AUDIO_FORMAT_F64_OE = SPA_AUDIO_FORMAT_F64_BE,
};
export type spa_audio_info_raw = struct {
	format: spa_audio_format,
	flags: u32,
	rate: u32,
	channels: u32,
	position: [SPA_AUDIO_MAX_CHANNELS]u32,
};

fn spa_pod_builder_add(
	builder: *spa_pod_builder,
	args: (u32 | *char | spa_format | spa_media_type | spa_media_subtype |
		int | [SPA_AUDIO_MAX_CHANNELS]u32)...,
) int = {
	return 0;
};

fn spa_pod_builder_frame(
	builder: *spa_pod_builder,
	frame: *spa_pod_frame,
) nullable *spa_pod = {
	return null;
};

fn spa_pod_builder_pad(
	builder: *spa_pod_builder,
	sz: u32,
) int = {
	return 0;
};

export fn spa_format_audio_raw_build(
	builder: *spa_pod_builder,
	id: u32,
	info: *spa_audio_info_raw,
) nullable *spa_pod = {
	let f: spa_pod_frame = spa_pod_frame { ... };
	spa_pod_builder_push_object(builder, &f,
		spa_type::SPA_TYPE_OBJECT_Format, id);
	spa_pod_builder_add(builder,
		spa_format::SPA_FORMAT_mediaType,
		strtoc("I\0"), spa_media_type::SPA_MEDIA_TYPE_audio,
		spa_format::SPA_FORMAT_mediaSubtype,
		strtoc("I\0"), spa_media_subtype::SPA_MEDIA_SUBTYPE_raw,
		0);
	if (info.format != spa_audio_format::SPA_AUDIO_FORMAT_UNKNOWN) {
		spa_pod_builder_add(builder,
			spa_format::SPA_FORMAT_AUDIO_format,
			strtoc("I\0"), info.format, 0);
	};
	if (info.rate != 0) {
		spa_pod_builder_add(builder,
			spa_format::SPA_FORMAT_AUDIO_rate,
			strtoc("i\0"), info.rate, 0);
	};
	if (info.channels != 0) {
		spa_pod_builder_add(builder,
			spa_format::SPA_FORMAT_AUDIO_channels,
			strtoc("i\0"), info.channels, 0);
		if (
			info.flags & SPA_AUDIO_FLAG_UNPOSITIONED ==
				SPA_AUDIO_FLAG_UNPOSITIONED
		) {
			spa_pod_builder_add(builder,
				spa_format::SPA_FORMAT_AUDIO_position,
				strtoc("a\0"),
				size(u32): u32,
				spa_type::SPA_TYPE_Id,
				info.channels,
				info.position,
				0);
		};
	};
	return spa_pod_builder_pop(builder, &f): nullable *spa_pod;
};

export fn spa_pod_builder_push_object(
	builder: *spa_pod_builder,
	frame: *spa_pod_frame,
	type_: u32,
	id: u32,
) int = {
	let p: spa_pod_object = spa_pod_object {
		pod = spa_pod {
			sz = size(spa_pod_object_body): u32,
			type_ = spa_type::SPA_TYPE_Object,
		},
		body = spa_pod_object_body {
			type_ = type_,
			id = id,
		},
	};
	const offset_: u32 = builder.state.offset_;
	const res: int = spa_pod_builder_raw(builder, &p,
		size(spa_pod_object): u32);
	spa_pod_builder_push(builder, frame, &p.pod, offset_);
	return res;
};

export fn spa_pod_builder_push(
	builder: *spa_pod_builder,
	frame: *spa_pod_frame,
	pod: *spa_pod,
	offset_: u32,
) void = {
	frame.pod = *pod;
	frame.offset_ = offset_;
	frame.parent = builder.state.frame;
	frame.flags = builder.state.flags;
	builder.state.frame = frame;

	if (
		frame.pod.type_ == spa_type::SPA_TYPE_Array ||
		frame.pod.type_ == spa_type::SPA_TYPE_Choice
	) {
		builder.state.flags = SPA_POD_BUILDER_FLAG_FIRST |
			SPA_POD_BUILDER_FLAG_BODY;
	};
};

export fn spa_pod_builder_pop(
	builder: *spa_pod_builder,
	frame: *spa_pod_frame,
) *void = {
	let pod: nullable *spa_pod = null;

	if (
		builder.state.flags & SPA_POD_BUILDER_FLAG_FIRST ==
			SPA_POD_BUILDER_FLAG_FIRST
	) {
		const p: spa_pod = spa_pod {
			sz = 0,
			type_ = spa_type::SPA_TYPE_None,
		};
		spa_pod_builder_raw(builder, &p, size(spa_pod): u32);
	};
	pod = spa_pod_builder_frame(builder, frame): nullable *spa_pod;
	if (pod != null) {
		let pod = pod: *spa_pod;
		*pod = frame.pod;
	};

	builder.state.frame = frame.parent;
	builder.state.flags = frame.flags;
	spa_pod_builder_pad(builder, builder.state.offset_);
	return pod: *void;
};

export fn spa_pod_builder_raw(
	builder: *spa_pod_builder,
	data: *void,
	sz: u32,
) int = {
	let res = 0;
	let f: nullable *spa_pod_frame = null;
	let offset_: u32 = builder.state.offset_;

	if (offset_ + sz > builder.sz) {
		res = -rt::ENOSPC;
		if (offset_ <= builder.sz) {
			// There is some annoying macro stuff that needs to
			// happen here, see spa/pod/builder.h.
			abort("not implemented");
		};
	};

	if (res == 0 && data != null) {
		rt::memcpy((builder.data: uintptr + offset_: uintptr): *void,
			data, sz);
	};

	builder.state.offset_ += sz;

	f = builder.state.frame;
	for (true) {
		if (f == null) {
			break;
		};
		const f_nonnull = f: *spa_pod_frame;
		f_nonnull.pod.sz += sz;
		f = f_nonnull.parent;
	};

	return res;
};
