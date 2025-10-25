function update_farms_with_fields()
    for f in all(get_blds("farm")) do
        local r = f.radius
        local tx,ty = f.x,f.y
        local fields = {}
        for y=-r,r do
            for x=-r,r do
                if x^2 + y^2 <= r^2 then
                    local a = check_field_on_tile(mid(-1,tx+x,16),mid(-1,ty+y,16))
                    if not has(fields,a) then
                        add(fields,a)
                    end
                    local b = check_field_on_tile(mid(-1,tx+x+1,16),mid(-1,ty+y,16))
                    if not has(fields,b) then
                        add(fields,b)
                    end
                    local c = check_field_on_tile(mid(-1,tx+x,16),mid(-1,ty+y+1,16))
                    if not has(fields,c) then
                        add(fields,c)
                    end
                    local d = check_field_on_tile(mid(-1,tx+x+1,16),mid(-1,ty+y+1,16))
                    if not has(fields,d) then
                        add(fields,d)
                    end
                end
            end
        end
        f.fields = #fields
    end
end

function check_field_on_tile(x,y)
    local bld = find_building(x,y)
    if find_building(x,y) != nil then
        if bld.sprite == "field" then
            return bld
        end
    end
    return nil
end

function breed_people()
    for f in all(get_blds("farm")) do
        local farmers = flr(f["farmers"]/100)
        local fields = f["fields"]
        local try = min(farmers,fields)
        for i=0,try-1 do
            if flr(rnd(5)) == 0 then
                f["farmers"] += 1
            end
        end
    end
end