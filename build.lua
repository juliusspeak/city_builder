function build(bld)
	local x = mouse_cell.x/8
	local y = mouse_cell.y/8
	local price = bld_price[bld]
	
	if can_build(x,y,price) then
		spr_build(bld,x,y)
		money -= price
		local building = building(bld,x,y)
		add(builds,building)
		
		sfx(1)
	end
end

function can_build(x,y,price)
	if spr_map[y][x] == 0 and
	spr_map[y][x+1] == 0 and
	spr_map[y+1][x] == 0 and
	spr_map[y+1][x+1] == 0 then
		if money >= price then
			return true
		else
			return false
		end
	else
		return false
	end
end

function spr_build(bld,x,y)
    local spr = {}
	if bld == "house" then
        spr = {2,3,18,19}
	elseif bld == "clinic" then
        spr = {4,5,20,21}
	elseif bld == "work" then
        spr = {6,7,22,23}
	elseif bld == "shop" then
        spr = {34,35,50,51}
	end
    spr_map[y][x] = spr[1]
    spr_map[y][x+1] = spr[2]
    spr_map[y+1][x] = spr[3]
    spr_map[y+1][x+1] = spr[4]
end

function building(name,x,y)
	local obj = {
		x = x,
		y = y,
		sprite = name,
		info = {}
	}
	if name == "house" then
		obj["info"]["tenants"] = 100
		obj["info"]["has work"] = "no"
		obj["info"]["has shop"] = "no"
		obj["info"]["work hr"] = 0
		obj["info"]["shop hr"] = 0
		obj["works"] = {}
		obj["shops"] = {}
	elseif name == "work" then
		obj["info"]["workers"] = 0
	elseif name == "shop" then
		obj["info"]["buyers"] = 0
	end
	
	function obj:self_destroy()
		spr_map[self.y][self.x] = 0
		spr_map[self.y][self.x+1] = 0
		spr_map[self.y+1][self.x] = 0
		spr_map[self.y+1][self.x+1] = 0
	end
	
	function obj:is_part(x,y)
		if x >= self.x and x <= self.x + 1 and
		y >= self.y and y <= self.y +1 then
			return true
		else
			return false
		end
	end
	
	return obj
end

function demolish(x,y)
	if	spr_map[y][x] == 0 then
		return
	else
		local bld = find_building(x,y)
		
		if bld != nil then
			bld:self_destroy()
			del(builds,bld)
			sfx(2)
		end
		
	end
end

function find_building(x,y)
	for b in all(builds) do
		if b:is_part(x,y) then
			return b
		end
	end
	return nil
end