use fmt;
use rt;

export type spa_command = void; // opaque

export def SPA_POD_BUILDER_FLAG_BODY: u32 = 1 << 0;
export def SPA_POD_BUILDER_FLAG_FIRST: u32 = 1 << 1;

type spa_choice = enum u32 {
	SPA_CHOICE_None,
	SPA_CHOICE_Range,
	SPA_CHOICE_Step,
	SPA_CHOICE_Enum,
	SPA_CHOICE_Flags,
};

type spa_pod_choice_body = struct {
	type_: u32,
	flags: u32,
	child: spa_pod,
};

type spa_pod_choice = struct {
	pod: spa_pod,
	body: spa_pod_choice_body,
};

export type spa_pod = struct {
	sz: u32,
	type_: u32,
};

export type spa_pod_builder_state = struct {
	offset_: u32,
	flags: u32,
	frame: nullable *spa_pod_frame,
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
	parent: nullable *spa_pod_frame,
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

export type spa_pod_arg = (u32 | *char | spa_format | spa_media_type |
	spa_media_subtype | int | [SPA_AUDIO_MAX_CHANNELS]u32);

fn spa_pod_builder_add(
	builder: *spa_pod_builder,
	args: spa_pod_arg...,
) int = {
	let res: int = 0;
	const frame: nullable *spa_pod_frame = builder.state.frame;
	const ftype: u32 = if (frame == null) {
		yield spa_type::SPA_TYPE_None: u32;
	} else {
		const frame = frame: *spa_pod_frame;
		return frame.pod.type_: int;
	};

	let idx_args = 0z;
	for (true) :outer {
		let format: nullable *char = null;
		let n_values: int = 1;
		let f: spa_pod_frame = spa_pod_frame { ... };
		let choice: bool = false;

		switch (ftype) {
		case spa_type::SPA_TYPE_Object =>
			const key = args[idx_args]: u32;
			idx_args += 1;
			if (key == 0) {
				break :outer;
			};
			spa_pod_builder_prop(builder, key, 0);
		case spa_type::SPA_TYPE_Sequence =>
			const offset_ = args[idx_args]: u32;
			idx_args += 1;
			const type_ = args[idx_args]: u32;
			idx_args += 1;
			if (type_ == 0) {
				break :outer;
			};
			spa_pod_builder_control(builder, offset_, type_);
		case =>
			break;
		};
		format = args[idx_args]: *char;
		idx_args += 1;
		if (format == null) {
			break;
		};

		choice = switch (format) {
		case null =>
			yield false;
		case =>
			yield (*(format: *char)): u8 == '?': u8;
		};
		if (choice) {
			format = ((format: uintptr) + 1): *char;
			const format = format as *char;
			const type_: u32 = spa_choice_from_id(*format);
			const type_: u32 = 0;
			if ((*format): u8 != 0) {
				format = ((format: uintptr) + 1): *char;
			};

			spa_pod_builder_push_choice(builder, &f, type_, 0);

			let n_values: u32 = args[idx_args]: u32;
			idx_args += 1;
		};
		for (n_values > 0) {
			const format = format as *char;
			spa_pod_builder_collect(builder, *format, args);
			n_values -= 1;
		};

		if (choice) {
			spa_pod_builder_pop(builder, &f);
			void;
		};
	};

	return res;
};

export fn spa_pod_builder_collect(
	builder: *spa_pod_builder,
	type_: char,
	args: []spa_pod_arg,
) void = {
	// TODO
	switch (type_: u8) {
	case 'b': u8 =>
		// spa_pod_builder_bool(builder, !!va_arg(args, int));
		void;
	case 'I': u8 =>
		// spa_pod_builder_id(builder, va_arg(args, uint32_t));
		void;
	case 'i': u8 =>
		// spa_pod_builder_int(builder, va_arg(args, int));
		void;
	case 'l': u8 =>
		// spa_pod_builder_long(builder, va_arg(args, int64_t));
		void;
	case 'f': u8 =>
		// spa_pod_builder_float(builder, va_arg(args, double));
		void;
	case 'd': u8 =>
		// spa_pod_builder_double(builder, va_arg(args, double));
		void;
	case 's': u8 =>
		// char *strval = va_arg(args, char *);
		// if (strval != NULL) {
		// 	size_t len = strlen(strval);
		// 	spa_pod_builder_string_len(builder, strval, len);
		// }
		// else
		// 	spa_pod_builder_none(builder);
		void;
	case 'S': u8 =>
		// char *strval = va_arg(args, char *);
		// size_t len = va_arg(args, int);
		// spa_pod_builder_string_len(builder, strval, len);
		void;
	case 'y': u8 =>
		// void *ptr  = va_arg(args, void *);
		// int len = va_arg(args, int);
		// spa_pod_builder_bytes(builder, ptr, len);
		void;
	case 'R': u8 =>
		// struct spa_rectangle *rectval =
		// 	va_arg(args, struct spa_rectangle *);
		// spa_pod_builder_rectangle(builder,
		// 		rectval->width, rectval->height);
		void;
	case 'F': u8 =>
		// struct spa_fraction *fracval =
		// 	va_arg(args, struct spa_fraction *);
		// spa_pod_builder_fraction(builder, fracval->num, fracval->denom);\
		void;
	case 'a': u8 =>
		// int child_size = va_arg(args, int);
		// int child_type = va_arg(args, int);
		// int n_elems = va_arg(args, int);
		// void *elems = va_arg(args, void *);
		// spa_pod_builder_array(builder, child_size,
		// 		child_type, n_elems, elems);
		void;
	case 'p': u8 =>
		// int t = va_arg(args, uint32_t);
		// spa_pod_builder_pointer(builder, t, va_arg(args, void *));
		void;
	case 'h': u8 =>
		// spa_pod_builder_fd(builder, va_arg(args, int));
		void;
	case 'P': u8, 'O': u8, 'T': u8, 'V': u8 =>
		// struct spa_pod *pod = va_arg(args, struct spa_pod *);
		// if (pod == NULL)
		// 	spa_pod_builder_none(builder);
		// else
		// 	spa_pod_builder_primitive(builder, pod);
		void;
	};
	abort("spa_pod_builder_collect() not implemented");
};

export fn spa_pod_builder_push_choice(
	builder: *spa_pod_builder,
	frame: *spa_pod_frame,
	type_: u32,
	flags: u32,
) int = {
	const p: spa_pod_choice = spa_pod_choice {
		pod = spa_pod {
			sz = (size(spa_pod_choice_body) - size(spa_pod)): u32,
			type_ = spa_type::SPA_TYPE_Choice,
		},
		body = spa_pod_choice_body {
			type_ = type_,
			flags = flags,
			child = spa_pod { ... },
		},
	};
	const offset_: u32 = builder.state.offset_;
	const res = spa_pod_builder_raw(builder, &p,
		(size(spa_pod_choice) - size(spa_pod)): u32);
	spa_pod_builder_push(builder, frame, &p.pod, offset_);
	return res;
};

export fn spa_choice_from_id(id: char) u32 = {
	switch (id: u8) {
	case 'r': u8 =>
		return spa_choice::SPA_CHOICE_Range;
	case 's': u8 =>
		return spa_choice::SPA_CHOICE_Step;
	case 'e': u8 =>
		return spa_choice::SPA_CHOICE_Enum;
	case 'f': u8 =>
		return spa_choice::SPA_CHOICE_Flags;
	case 'n': u8 =>
		return spa_choice::SPA_CHOICE_None;
	case =>
		return spa_choice::SPA_CHOICE_None;
	};
};

type spa_pod_builder_prop_temp = struct {
	key: u32,
	flags: u32,
};

fn spa_pod_builder_prop(
	builder: *spa_pod_builder,
	key: u32,
	flags: u32,
) int = {
	const p: spa_pod_builder_prop_temp = spa_pod_builder_prop_temp {
		key = key,
		flags = flags,
	};
	return spa_pod_builder_raw(builder, &p, size(spa_pod_builder_prop_temp): u32);
};

type spa_pod_builder_control_temp = struct {
	offset_: u32,
	type_: u32,
};

fn spa_pod_builder_control(
	builder: *spa_pod_builder,
	offset_: u32,
	type_: u32,
) u32 = {
	const p: spa_pod_builder_control_temp = spa_pod_builder_control_temp {
		offset_ = offset_,
		type_ = type_,
	};
	return spa_pod_builder_raw(builder, &p, size(spa_pod_builder_control_temp): u32): u32;
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
			// TODO: There is some annoying macro stuff that needs
			// to happen here, see spa/pod/builder.h.
			abort("spa_pod_builder_raw branch not implemented");
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
