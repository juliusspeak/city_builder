function _init()
	set_globals()
	poke(0x5f2d, 0x1)
	draw_river(0,flr(rnd(5))+5)
	fix_roads()
end

function _update()
	update_globals()
	input()
end

function _draw()
	cls()
	map()
	spr_map_draw()
	update_marks()
	ui()
	all_particles()
end