function _init()
	set_globals()
	poke(0x5f2d, 0x1)
	map_preporation()
end

function _update()
	--if stat(57) == false then
	--	music(0, 500)
	--end
	update_globals()
	input()
end

function _draw()
	cls()
	map()
	spr_map_draw()
	visuals()
	ui()
end