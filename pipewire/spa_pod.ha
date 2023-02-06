use rt;

export type spa_command = void; // opaque

export def SPA_POD_BUILDER_FLAG_BODY: u32 = 1 << 0;
export def SPA_POD_BUILDER_FLAG_FIRST: u32 = 1 << 1;

export type spa_pod = struct {
	sz: u32,
	type_: u32,
};

export type spa_pod_builder_state = struct {
	offset_: u32,
	flags: u32,
	frame: *spa_pod_frame,
};

export type spa_pod_builder = struct {
	data: nullable *void,
	sz: u32,
	_padding: u32,
	state: spa_pod_builder_state,
	callbacks: spa_callbacks,
};

export type spa_pod_frame = struct {
	pod: spa_pod,
	parent: *spa_pod_frame,
	offset_: u32,
	flags: u32,
};

export type spa_pod_object_body = struct {
	type_: u32,
	id: u32,
};

export type spa_pod_object = struct {
	pod: spa_pod,
	body: spa_pod_object_body,
};

fn spa_pod_builder_add(
	builder: *spa_pod_builder,
	args: (u32 | *char | spa_format | spa_media_type | spa_media_subtype |
		int | [SPA_AUDIO_MAX_CHANNELS]u32)...,
) int = {
	return 0;
};

fn spa_pod_size(pod: *spa_pod) u32 = {
	return size(spa_pod): u32 + pod.sz;
};

fn spa_pod_builder_frame(
	builder: *spa_pod_builder,
	frame: *spa_pod_frame,
) nullable *spa_pod = {
	if (frame.offset_ + spa_pod_size(&frame.pod) <= builder.sz) {
		return (builder.data: uintptr + frame.offset_: uintptr): *spa_pod;
	};
	return null;
};

fn spa_round_mask(num: u32, mask: u32) u32 = {
	return mask - 1;
};

fn spa_round_up_n(num: u32, align: u32) u32 = {
	return ((num - 1) | spa_round_mask(num, align)) + 1;
};

fn spa_pod_builder_pad(
	builder: *spa_pod_builder,
	sz: u32,
) int = {
	const zeroes = 0u64;
	sz = spa_round_up_n(sz, 8u32) - sz;
	if (sz == 0) {
		return 0;
	};
	return spa_pod_builder_raw(builder, &zeroes, sz);
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
