export type spa_buffer = void; // opaque
export type spa_buffer = struct {
	n_metas: u32,
	n_datas: u32,
	metas: nullable *spa_meta,
	datas: nullable *spa_datas,
};
