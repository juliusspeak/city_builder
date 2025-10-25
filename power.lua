function update_power_map()
    local powers = get_blds("power")
    for x=-1,16 do
        for y=-1,16 do
            powered[x][y] = false
        end
    end

    for p in all(powers) do
        local r = p.radius
        local tx,ty = p.x,p.y
        for y=-r,r do
            for x=-r,r do
                if x^2 + y^2 <= r^2 then
                    powered[mid(-1,tx+x,16)][mid(-1,ty+y,16)] = true
                    powered[mid(-1,tx+x+1,16)][mid(-1,ty+y,16)] = true
                    powered[mid(-1,tx+x,16)][mid(-1,ty+y+1,16)] = true
                    powered[mid(-1,tx+x+1,16)][mid(-1,ty+y+1,16)] = true
                end
            end
	    end
    end
end


function update_blds_with_power()
    for bld in all(builds) do
        if bld["has power"] then
            bld["has power"] = "no"
            local x = bld.x
            local y = bld.y
            if powered[x][y] == true or
            powered[x+1][y] == true or
            powered[x][y+1] == true or
            powered[x+1][y+1] == true then
                bld["has power"] = "yes"
            end
        end
    end
end