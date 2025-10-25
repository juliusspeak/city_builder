function fix_roads()
	local fixed = {}
	local n,s,e,w = false,false,false,false
	for x=0,15 do
		for y=0,15 do
			if has(road_sprites, spr_map[y][x]) then
					n = has(road_sprites, spr_map[y-1][x])
					s = has(road_sprites, spr_map[y+1][x])
					e = has(road_sprites, spr_map[y][x-1])
					w = has(road_sprites, spr_map[y][x+1])
					set_sides(n,s,e,w,x,y)
			end
		end
	end
end


function build_road()
	local x = mouse_cell.x/8
	local y = mouse_cell.y/8
	local price = bld_price["road"]
	if has(road_sprites, spr_map[y][x]) then
		spr_map[y][x] = 0
		money += flr(bld_price["road"]/2)
	elseif spr_map[y][x] == 0 and money >= price then
		spr_map[y][x] = 9
		money -= price
		sfx(0)
	end
	fix_roads()
	
end

function set_sides(n,s,e,w,x,y)
	local spr_n
	if not n and not s and e and w then
		spr_n = 9
	end
	if n and s and not e and not w then
		spr_n = 24
	end
	if not n and not s and	not e and w then
		spr_n = 9
	end
	if not n and not s and	e and not w then
		spr_n = 9
	end
	if n and not s and	not e and not w then
		spr_n = 24
	end
	if not n and s and	not e and not w then
		spr_n = 24
	end
	if n and s and e and w then
		spr_n = 13
	end
	if not n and s and e and w then
		spr_n = 11
	end
	if n and s and e and not w then
		spr_n = 12
	end
	if n and s and not e and w then
		spr_n = 27
	end
	if n and not s and e and w then
		spr_n = 28
	end
	if not n and not e and w and s then
		spr_n = 8
	end
	if not n and e and not w and s then
		spr_n = 10
	end
	if n and not e and w and not s then
		spr_n = 40
	end
	if n and e and not w and not s then
		spr_n = 42
	end
	if spr_n == nil then
    	spr_n = 9
	end
	if spr_map[y][x] != 43 and spr_map[y][x] != 59 then
		spr_map[y][x] = spr_n
	end
end

function get_near_roads(tx,ty)
	local tiles = {}
	if has(road_sprites, spr_map[ty][tx-1]) then
		add(tiles,{tx-1,ty})
	end
	if has(road_sprites, spr_map[ty][tx+1]) then
		add(tiles,{tx+1,ty})
	end
	if has(road_sprites, spr_map[ty-1][tx]) then
		add(tiles,{tx,ty-1})
	end
	if has(road_sprites, spr_map[ty+1][tx]) then
		add(tiles,{tx,ty+1})
	end
	return tiles
end

function is_connected(x1,y1,x2,y2)
	if not has(road_sprites,spr_map[y1][x1] ) then
		return false
	end
	
	local visited = {}
	for x=-1,16 do
		visited[x] = {}
		for y=-1,16 do
			visited[x][y] = false
		end
	end
	
	local cur_x, cur_y = x1,y1
	local need_visit = {{cur_x,cur_y}}
	
	while #need_visit != 0 do
		cur_x = need_visit[1][1]
		cur_y = need_visit[1][2]
		
		if visited[cur_x][cur_y] == false then
			if cur_x == x2 and cur_y == y2 then
				return true
			end

			visited[cur_x][cur_y] = true

			local new_tiles = get_near_roads(cur_x,cur_y)
			if #new_tiles != 0 then
				need_visit = merge(need_visit,new_tiles)
			end
		end
		deli(need_visit,1)
	end

	return false
end

function dist(x1,y1,x2,y2)
	local distance = {}

	for x=-1,16 do
		distance[x] = {}
		for y=-1,16 do
			distance[x][y] = -1
		end
	end

	local cur_x, cur_y, cur_d
	local need_visit = {{x2,y2}}
	distance[x2][y2] = 0

	while #need_visit > 0 do
		cur_x = need_visit[1][1]
		cur_y = need_visit[1][2]
		cur_d = distance[cur_x][cur_y]

		local new_tiles = get_near_roads(cur_x,cur_y)
		if #new_tiles != 0 then
			for tile in all(new_tiles) do
				if distance[tile[1]][tile[2]] == -1 then
					distance[tile[1]][tile[2]] = cur_d + 1
					add(need_visit, tile)
				end
			end
		end
		deli(need_visit,1)
	end
	return distance[x1][y1]
end