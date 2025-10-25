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