function visual_pointer()
	local x
	local y
	if cur_window == "" then
		x = min(mouse_cell.x,120)
		y = min(mouse_cell.y,120)
		if cur_menu_line == "" then
			draw_cursor(x,y,0)
		elseif cur_menu_line ==
		"demolish" then
			draw_cursor(x,y,3)
		else
			draw_cursor(x,y,2)
		end
	else
		x = mouse_x
		y = mouse_y
		draw_cursor(x,y,1)
	end
end

function spr_map_draw()
	for y=0,15 do
		for x=0,15 do
			if spr_map[y][x] != 0 then
				spr(spr_map[y][x],x*8,y*8)
			end
		end
	end
end

function draw_cursor(x,y,n)
--default
	if n == 0 then
		rect(x,y+1,x+6,y+7,4)
		rect(x+1,y,x+7,y+6,9)
	end
--small
	if n == 1 then
		rect(x-1,y-1,x+1,y+1,9)
	end
--hammer
	if n == 2 then
		if cur_menu_line != "road" and cur_menu_line != "bridge" then
			if can_build(x/8,y/8,bld_price[cur_menu_line],cur_menu_line) then
				rect(x,y,x+16,y+16,6)
			else
				rect(x,y,x+16,y+16,8)
			end
		end
		spr(25,x,y)
	end
--buildozer
	if n ==3 then
		spr(41,x,y)
	end
end

function game_info()
	rectfill(0,121,127,127,8)
	color(7)
	print("$"..money.." 웃:"..population.." ★:"..goods.." d:"..day.." h:"..ceil(hour).." ".. debug,0,122)
end

function ui_instruments()
	spr(41,120,111)
	speed_sprite(112,111)
	spr(44,104,111)
end

function speed_sprite(x,y)
	if speed == 0.1 then
		spr(17,x,y)
	elseif speed == 1 then
		spr(33,x,y)
	else
		spr(49,x,y)
	end
end

function daytime()
	if hour >= 18 or hour <= 5 then
		pal(1,-15,1)
		pal(2,-14,1)
		pal(3,-13,1)
		pal(4,-12,1)
		pal(5,-11,1)
		pal(6,-10,1)
		pal(7,-9,1)
		pal(8,-8,1)
		pal(9,-7,1)
		pal(10,-6,1)
		pal(11,-5,1)
		pal(12,-4,1)
		pal(13,-3,1)
		pal(14,-2,1)
		pal(15,-1,1)
	else
		pal(-15,1,1)
		pal(-14,2,1)
		pal(-13,3,1)
		pal(-12,4,1)
		pal(-11,5,1)
		pal(-10,6,1)
		pal(-9,7,1)
		pal(-8,8,1)
		pal(-7,9,1)
		pal(-6,10,1)
		pal(-5,11,1)
		pal(-4,12,1)
		pal(-3,13,1)
		pal(-2,14,1)
		pal(-1,15,1)
	end
end

function is_work_mark(bld)
	no_mark_list = {"bridge"}
	local x,y = bld.x*8, bld.y*8
	
	local mark = false
	if bld.sprite == "house" do
		if bld["has work"] == "yes" do
			mark = true
		end
	end
	if bld.sprite == "work" do
		if bld["workers"] > 0 do
			mark = true
		end
	end
	if bld.sprite == "shop" do
		if bld["buyers"] > 0 do
			mark = true
		end
	end
	
	if has(no_mark_list, bld.sprite) then
		return
	end

	if mark == true do
		rectfill(x+13,y+1,x+14,y+2,11)
	else
		rectfill(x+13,y+1,x+14,y+2,8)
	end
end

function update_marks()
	for bld in all(builds) do
		is_work_mark(bld)
	end
end

function add_text_particle(_txt,_x,_y,_col,_t)
	add(particles,{txt=_txt,x=_x,y=_y,col=_col,t=_t})
end

function process_particle()
	if #particles == 0 then
		return
	end

	for p in all(particles) do
		print(p.txt,p.x+1,ceil(p.y),0)
		print(p.txt,p.x-1,ceil(p.y),0)
		print(p.txt,p.x,ceil(p.y)+1,0)
		print(p.txt,p.x,ceil(p.y)-1,0)
		print(p.txt,p.x+1,ceil(p.y)+1,0)
		print(p.txt,p.x-1,ceil(p.y)+1,0)
		print(p.txt,p.x+1,ceil(p.y)-1,0)
		print(p.txt,p.x-1,ceil(p.y)-1,0)

		print(p.txt,p.x,ceil(p.y),p.col)
		p.y -= 0.3
		p.t -= 1
		if p.t <= 0 then
			del(particles,p)
		end
	end
end

function all_particles()
	if last_money < money then
		add_text_particle("+$"..tostr(money-last_money),5,115,11,40)
	elseif last_money > money then
		add_text_particle("-$"..tostr(last_money-money),5,115,-8,40)
	end
	
	if last_goods < goods then
		add_text_particle("+"..tostr(goods-last_goods),55,115,11,40)
	elseif last_goods > goods then
		add_text_particle("-"..tostr(last_goods-goods),55,115,-8,40)
	end
	last_goods = goods
	last_money = money
	process_particle()
end

function draw_river(x,y)
	local rvr_spr = 37
	spr_map[y][x] = rvr_spr

	local visited = {}
	for x=-1,16 do
		visited[x] = {}
		for y=-1,16 do
			visited[x][y] = false
		end
	end 
	visited[x][y] = true

	local need_visit = get_next_river_tiles(x,y,rvr_spr)

	while #need_visit > 0 do
		x = need_visit[1][1]
		y = need_visit[1][2]

		if x >= 16 then
			break
		end

		
		rvr_spr = choose_river_spr(x,y)
		spr_map[y][x] = rvr_spr
		
		local new_tiles = get_next_river_tiles(x,y,rvr_spr)
		if #new_tiles != 0 then
			for t in all(new_tiles) do
				local tx,ty = t[1],t[2]
				if tx >= 0 and tx <= 16 and ty >= 0 and ty <= 14 then
					if visited[t[1]][t[2]] == false then
						visited[tx][ty] = true
						add(need_visit,t)
					end
				end
			end
		end
		deli(need_visit,1)

		if #need_visit == 0 then
			if x < 16 then
				if rvr_spr == 38 then
					if y == 14 then
						rvr_spr = 37
					else
						rvr_spr = 36
					end
				end
				if rvr_spr == 52 then
					if y == 0 then
						rvr_spr = 36
					elseif y == 14 then
						rvr_spr = 53
					end
				end
				if rvr_spr == 53 then
					if y == 0 then
						rvr_spr = 36
					elseif y == 14 then
						rvr_spr = 53
					end
				end
				if rvr_spr == 54 then
					if y == 0 then
						rvr_spr = 37
					else
						rvr_spr = 53
					end
				end
				spr_map[y][x] = rvr_spr
				x = x+1
				if x <= 16 then
					visited[x][y] = true
					add(need_visit, {x, y})
				end
			end
		end
	end
end

function get_next_river_tiles(x,y,n)
	local tiles = {}
	if n == 36 then
		add(tiles,{x+1,y})
		add(tiles,{x,y+1})
	end
	if n == 37 then
		add(tiles,{x+1,y})
		add(tiles,{x-1,y})
	end
	if n == 38 then
		add(tiles,{x-1,y})
		add(tiles,{x,y+1})
	end
	if n == 52 then
		add(tiles,{x,y-1})
		add(tiles,{x,y+1})
	end
	if n == 53 then
		add(tiles,{x,y-1})
		add(tiles,{x+1,y})
	end
	if n == 54 then
		add(tiles,{x-1,y})
		add(tiles,{x,y-1})
	end
	return tiles
end

function choose_river_spr(x,y)
	local n = has(river_sprites,get_tile(x,y-1))
	local s = has(river_sprites,get_tile(x,y+1))
	local w = has(river_sprites,get_tile(x-1,y))
	local e = has(river_sprites,get_tile(x+1,y))
	local sprites = {}
	if not (n or s or w or e) then return 52 end
	if not n and s and w and not e then
		add(sprites,38)
	end
	if n and not s and w and not e then
		add(sprites,54)
	end
	if n and not s and not w and e then
		add(sprites,53)
	end
	if not n and s and not w and e then
		add(sprites,36)
	end
	if n and s and not w and not e then
		add(sprites,52)
	end
	if not n and not s and w and e then
		add(sprites,37)
	end
	if n and not s and not w and not e then
		add(sprites,52)
		add(sprites,53)
	end
	if not n and not s and not w and e then
		add(sprites,37)
		add(sprites,36)
		add(sprites,53)
	end
	if not n and s and not w and not e then
		add(sprites,52)
		add(sprites,36)
	end
	if not n and not s and w and not e then
		add(sprites,37)
		add(sprites,38)
		add(sprites,54)
	end
	return sprites[flr(rnd(#sprites))+1]
end

function map_preporation()
	draw_river(0,flr(rnd(5))+5)
	fix_roads()
end