function set_globals()
	debug = ""
--mouse------------------------
	mouse_x = 0
	mouse_y = 0
	
	mouse_cell = {
		x = 0,
		y = 0
	}
	
	lmb = 1

--ui---------------------------
	cur_window = ""
	win_x = 0
	win_y = 0
	
	menu_lines = {}
	cur_menu_line = ""

	particles = {}
--sprites----------------------
	road_sprites = {8,9,10,11,12,13,24,27,28,40,42, 43,59}
	river_sprites = {36,37,38,52,53,54}
	spr_map = {}
	for y=-1,16 do
		spr_map[y] = {}
		for x=-1,16 do
			spr_map[y][x] = 0
		end
	end

--buildings--------------------
	builds = {}
	bld_price = {
		road = 10,
		bridge = 50,
		house = 100,
		clinic = 200,
		work = 300,
		shop = 500
	}
	building_names = {}
	for n,d in pairs(bld_price) do
		add(building_names,n)
	end	
	last_bld = nil
--info-------------------------
	money = 3000
	last_money = 0
	goods = 0
	last_goods = 0
	population = 0
	last_population = 0
	hour = 6
	day = 0
	sec = 0
	speed = 0.1
end

function update_globals()
	mouse_x = stat(32)
	mouse_y = stat(33)
	
	mouse_cell.x = ceil(mouse_x/8) * 8
	mouse_cell.y = ceil(mouse_y/8) * 8
	
	if speed != 0 then
		sec += 1
	end
	if sec >= 30  then
		sec = 0
		hour += speed
		daytime()
		update_city()
	end
	if hour >= 24 then
		day += 1
		hour = 0
	end
	
	count_people()
end

function count_people()
	population = #get_blds("house") * 100
end