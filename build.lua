function build(bld)
	local x = mouse_cell.x/8
	local y = mouse_cell.y/8
	local price = bld_price[bld]
	
	if can_build(x,y,price,bld) then
		spr_build(bld,x,y)
		money -= price
		local building = building(bld,x,y)
		add(builds,building)
		sfx(1)
	end
end

function can_build(x,y,price,bld)
	local permit = true
	
	if bld == "bridge" then
		if not has({37,52},spr_map[y][x]) then
			permit = false
		end
	else
		if spr_map[y][x] != 0 or spr_map[y][x+1] != 0 or
		spr_map[y+1][x] != 0 or spr_map[y+1][x+1] != 0 then
			permit = false
		end
	end

	if money < price then
		permit = false
	end

	return permit
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
	elseif bld == "power" then
        spr = {45,46,61,62}
	elseif bld == "farm" then
        spr = {14,15,30,31}
	elseif bld == "field" then
        spr = {55,56,57,58}
	elseif bld == "bridge" then
		if spr_map[y][x] == 37 then
        	spr = {59}
		elseif spr_map[y][x] == 52 then
        	spr = {43}
		end
	end
    spr_map[y][x] = spr[1]
	if spr[2] != nil then
    	spr_map[y][x+1] = spr[2]
	end
	if spr[3] != nil then
    	spr_map[y+1][x] = spr[3]
	end
	if spr[4] != nil then
    	spr_map[y+1][x+1] = spr[4]
	end
end

function building(name,x,y)
	local obj = {
		x = x,
		y = y,
		sprite = name,
		info = {}
	}
	if name == "house" then
		obj["work hr"] = 0
		obj["shop hr"] = 0
		obj["farm hr"] = 0
		obj["has work"] = "no"
		obj["has shop"] = "no"
		obj["has farm"] = "no"
		obj["tenants"] = 100
		obj["works"] = {}
		obj["shops"] = {}
		obj["max tenants"] = 100
	elseif name == "work" then
		obj["workers"] = 0
		obj["max workers"] = 300
		obj["has power"] = "no"
	elseif name == "shop" then
		obj["buyers"] = 0
		obj["max buyers"] = 500
		obj["has power"] = "no"
	elseif name == "power" then
		obj["radius"] = 2
	elseif name == "farm" then
		obj["fields"] = 0
		obj["radius"] = 3
		obj["farmers"] = 0
		obj["max farmers"] = 1200
	elseif name == "field" then
		obj["has barn"] = 0
	end
	
	function obj:get_info()
		if name == "house" then
			obj["info"]["tenants:"] = self["tenants"].."/"..self["max tenants"]
			obj["info"]["connected to work:"] = self["has work"]
			obj["info"]["connected to shop:"] = self["has shop"]
			obj["info"]["connected to farm:"] = self["has farm"]
			obj["info"]["work travel:"] = self["work hr"].." hr"
			obj["info"]["shop travel:"] = self["shop hr"].." hr"
			obj["info"]["farm travel:"] = self["farm hr"].." hr"
		elseif name == "work" then
			obj["info"]["workers:"] = self["workers"].."/"..self["max workers"]
			obj["info"]["connect to power:"] = self["has power"]
		elseif name == "shop" then
			obj["info"]["buyers:"] = self["buyers"].."/"..self["max buyers"]
			obj["info"]["connect to power:"] = self["has power"]
		elseif name == "power" then
			obj["info"]["supply radius:"] = self["radius"].." tiles"
		elseif name == "farm" then
			obj["info"]["fields:"] = self["fields"]
			obj["info"]["gather radius:"] = self["radius"].." tiles"
			obj["info"]["farmers:"] = self["farmers"].."/"..self["max farmers"]
		end
		return obj["info"]
	end

	function obj:self_destroy()
		spr_map[self.y][self.x] = 0
		if self.sprite != "bridge" then
			spr_map[self.y][self.x+1] = 0
			spr_map[self.y+1][self.x] = 0
			spr_map[self.y+1][self.x+1] = 0
		end
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
			money += flr(bld_price[bld.sprite]/2)
		elseif has(road_sprites, spr_map[y][x]) then
			spr_map[y][x] = 0
			money += flr(bld_price["road"]/2)
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