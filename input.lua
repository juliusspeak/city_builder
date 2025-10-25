function input()
	if stat(34) == 1 then
		if stat(34) != lmb then
			lmb_pressed()
		end
	else
		lmb = 0
	end
	
	if stat(34) == 2 then
		rmb_pressed()
	end

	if btnp(❎) then
		cursor_input = "btn"
		lmb_pressed()
	end
	if btnp(🅾️) then
		cursor_input = "btn"
		rmb_pressed()
	end
	if btnp(➡️) then
		change_mouse_pos("x",8)
	end
	if btnp(⬅️) then
		change_mouse_pos("x",-8)
	end
	if btnp(⬆️) then
		change_mouse_pos("y",-8)
	end
	if btnp(⬇️) then
		change_mouse_pos("y",8)
	end
end

function change_mouse_pos(type,vol)
	cursor_input = "btn"
	if cur_window == "" then
		mouse_cell[type] += vol
		mouse_cell[type] = mid(0,mouse_cell[type],120)
	else
		if type == "x" then
			mouse_x += vol/2
			mouse_x = mid(0,mouse_x,120)
		else
			mouse_y += vol/2
			mouse_y = mid(0,mouse_y,120)
		end
	end
end

function allow_button()
	btn_delay += 1
	if btn_delay >= 4 then
		btn_delay = 0
		return true
	else
		return false
	end
end
function lmb_pressed()
	check_lmb()
	set_win_coor()
	lmb = 1
	mouse_x = mouse_cell.x
	mouse_y = mouse_cell.y
end
function rmb_pressed()
	cur_window = ""
	cur_menu_line = ""
	mouse_cell.x = ceil(mouse_x/8) * 8
	mouse_cell.y = ceil(mouse_y/8) * 8
end
function check_lmb()
	local x
	local y
	x =	mid(0,mouse_cell.x/8,120)
	y = mid(0,mouse_cell.y/8,120)
	
	if x == 15 and y == 14 then
        cur_menu_line = "demolish"
		return
	end
	if x == 14 and y == 14 then
		if speed == 0.1 then
			speed = 1
		elseif speed == 1 then
			speed = 0
		else
			speed = 0.1
		end
		return
	end
	if x == 13 and y == 14 then
		cur_window = "info"
		return
	end

	if cur_menu_line == "" then		
		if spr_map[y][x] == 0 then
            cur_window = "build"
		else
			local bld = find_building(x,y)
			if bld != nil then
				last_bld = bld
				cur_window = bld.sprite
			end
		end
	elseif cur_menu_line == "road"
	then
		if cur_window == "" then
			build_road()
		end
		cur_window = ""
	elseif cur_menu_line ==	"demolish"	then
		demolish(x,y)
	elseif has(building_names,cur_menu_line) then
		if cur_window == "" then
			build(cur_menu_line)
		end
		cur_window = ""
	else
		cur_window = ""
		cur_menu_line = ""
	end

end

function set_win_coor()
	local x_size = #(cur_window .." ("	.. tostr(ceil(mouse_cell.x/8)) ..
	"," ..tostr(ceil(mouse_cell.y/8))..")") * 4 + 2
    
	if mouse_cell.x < 128-x_size then
		win_x = mouse_cell.x
	else
		win_x = mouse_cell.x-x_size
	end
	
	if mouse_cell.y < 40 then
		win_y = mouse_cell.y
	else
		win_y = 40
	end
	
	if win_x < 8 then
		win_x = 8
	end
	if win_y < 8 then
		win_y = 8
	end
end