
function ui()
	windows()
	game_info()
	ui_instruments()
	visual_pointer()
end

function windows()
	if cur_window == "" then
		return
	end
	if cur_window == "info" then
		show_info()
		return
	end

	local title
	title = cur_window
	local w = 50
	local h = (#building_names-1) * 7 + 7
	if cur_window != "build" then
		win_x, win_y = 8, 8
		w, h = 108, 108
	end

	draw_square(w,h)
	highlighte_menu_line()
	menu_lines = {}
	if cur_window == "build" then
		draw_build_lines(win_x,win_y)
	else
		draw_building_menu_lines(win_x,win_y)
	end

    print(title,win_x+3, win_y+3,5)
end

function draw_square(w,h)
	local x = win_x
	local y = win_y
	
	rectfill(x+1,y+1,x+w-1,y+h-1,6)
	rect(x-1,y+1,x+w,y+h+1,4)
	rect(x,y,x+w+1,y+h,9)
end

function draw_build_lines(x,y)
	menu_line(x+3,y+12,"road")
	menu_line(x+3,y+18,"bridge")
	menu_line(x+3,y+24,"house")
	menu_line(x+3,y+30,"power")
	menu_line(x+3,y+36,"work")
	menu_line(x+3,y+42,"shop")
	menu_line(x+3,y+48,"farm")
	menu_line(x+3,y+54,"field")
	--menu_line(x+3,y+60,"clinic")
end

function menu_line(_x,_y,name)
	local price = bld_price[name]
	if price != nil then
		price = "$"..price
	else
		price = ""
	end

	print(name.." "..price,_x,_y,5)
	menu_lines[name] = {
		x = _x,
		y = _y,
		len = #name
	}
end

function draw_building_menu_lines(x,y)
	local bld = last_bld
	if bld == nil then
		return
	end

	local n = 1
	for name, data in pairs(bld:get_info()) do
		local line = name
		local line2 = tostr(data)
		local col2 = 1
		if line2 == "yes" then
			col2 = 3
		elseif line2 == "no" then
			col2 = -8
		end
		print(line,x+3,y+6+6*n,5)
		print(line2,x+3+#line*4,y+6+6*n,col2)
		menu_lines[line] = {
			x = x+3,
			y = y+6+6*n,
			len = #line
		}
		n += 1
	end
end

function highlighte_menu_line()
	cur_menu_line = ""
	for name, data in pairs(menu_lines) do
		local x = mouse_x
		local y = mouse_y
		local rx1 = data.x
		local rx2 = rx1 + data.len*4
		local ry1 = data.y
		local ry2 = ry1 + 5
		
		if dot_in_rec(x,y,rx1,ry1,rx2,ry2) then
			rectfill(rx1-1,ry1-1,rx2,ry2,7)
			cur_menu_line = name		
		end
	end
end

function show_info()
	win_x, win_y = 8, 8

	draw_square(104,104)
    print("full info",win_x+3, win_y+3,5)
    print("money: $"..money,win_x+3, win_y+3+7*2,5)
    print("population: "..population,win_x+3, win_y+3+7*3,5)
    print("goods: "..goods,win_x+3, win_y+3+7*4,5)
	
	local n = 1
	for b in all(building_names) do
		print(b..": "..tostr(#get_blds(b)),win_x+3, (win_y-10)+7*(6+n),5)
		n += 1
	end
    --print("houses: "..tostr(#get_blds("house")),win_x+3, win_y+3+7*6,5)
    --print("works: "..tostr(#get_blds("work")),win_x+3, win_y+3+7*7,5)
    --print("shops: "..tostr(#get_blds("shop")),win_x+3, win_y+3+7*8,5)
end