function set_globals()
	debug = ""
--mouse------------------------
	mouse_x = 0
	mouse_y = 0
	pseudo_x = 0
	pseudo_y = 0
	old_m_x = 0
	old_m_y = 0
	mouse_cell = {
		x = 0,
		y = 0
	}
	
	lmb = 1
	btn_delay = 0
	cursor_input = "btn"
--ui---------------------------
	cur_window = ""
	win_x = 0
	win_y = 0
	
	menu_lines = {}
	cur_menu_line = ""

	particles = {}
	flow_pattern_delay = 0
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
		power = 1000,
		farm = 500,
		field = 100,
		--clinic = 200,
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
--city-------------------------
	powered = {}
    for x=-1,16 do
        powered[x] = {}
        for y=-1,16 do
            powered[x][y] = false
        end
    end
	
    connect_types = {
        work = {
            dict = "works",
            var_name = "has work",
            hr_name = "work hr",
			ppl_name = "workers",
			max_ppl = "max workers",
        },
        shop = {
            dict = "shops",
            var_name = "has shop",
            hr_name = "shop hr",
			ppl_name = "buyers",
			max_ppl = "max buyers",
        },
        house = {
			ppl_name = "tenants",
			max_ppl = "max tenants",
        },
		farm = {
            dict = "farms",
            var_name = "has farm",
            hr_name = "farm hr",
			ppl_name = "farmers",
			max_ppl = "max farmers",
		}
    }
	
end

function update_globals()
	pseudo_mouse_x = stat(32)
	pseudo_mouse_y = stat(33)
	if cursor_input == "mouse" then
		mouse_x = stat(32)
		mouse_y = stat(33)
		mouse_cell.x = ceil(mouse_x/8) * 8
		mouse_cell.y = ceil(mouse_y/8) * 8
	end

	if old_m_x != pseudo_mouse_x and old_m_y != pseudo_mouse_y then
		old_m_x = pseudo_mouse_x
		old_m_y = pseudo_mouse_y
		cursor_input = "mouse"
	end
	
	
	if speed != 0 then
		sec += 1
	end
	if sec >= 30  then
		sec = 0
		hour += speed
		daytime()
		update_city()
		count_people()
	end
	if hour >= 24 then
		day += 1
		hour = 0
	end
end

function count_people()
	local total_ppl = 0
	for b,v in all(builds) do
		if connect_types[b.sprite] then
			local people_name = connect_types[b.sprite]["ppl_name"]
			total_ppl += b[people_name]
		end
	end
	population = total_ppl
end
