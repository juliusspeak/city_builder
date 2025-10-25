function update_house_connects_to(bld_name)
    local dict_name = connect_types[bld_name]["dict"]
    local var_name = connect_types[bld_name]["var_name"]
    local hr_name = connect_types[bld_name]["hr_name"]

    for house in all(get_blds("house")) do
        if dict_size(house[dict_name]) > 0 then
            set_bld_val(house,var_name,"yes")
            set_bld_val(house,hr_name,999)

            for bld, hr in pairs(house[dict_name]) do
                if hr < house[hr_name] then
                   set_bld_val(house,hr_name,hr)
                end
            end 
            
        else
            set_bld_val(house,var_name,"no")
            set_bld_val(house,hr_name,0)
        end
    end
end


function update_house_list_of(bld_name)
    local dict_name = connect_types[bld_name]["dict"]
    local var_name = connect_types[bld_name]["var_name"]
    local hr_name = connect_types[bld_name]["hr_name"]

    local houses = get_blds("house")
    local blds = get_blds(bld_name)

    for h in all(houses) do
        h[dict_name]= {}
    end

    for bld in all(blds) do
        for house in all(houses) do
            local dist_to = dist(house.x,house.y+2,bld.x,bld.y+2)
            if dist_to > 0 then
                house[dict_name][bld] = get_real_dist(dist_to)
            else
                if has(house[dict_name][bld]) then
                    house[dict_name][bld] = nil
                end
            end
        end
    end
end


function get_real_dist(val)
    if flr(val/5) < 1 then
        val = 1
    else
        val = flr(val/5)
    end
    return val
end

function get_houses_with(bld_name)
    local houses = get_blds("house")
    local var_name = connect_types[bld_name]["var_name"]
    local del_list = {}

    for h in all(houses) do
        if h[var_name] == "no" then
            add(del_list,h)
        end
    end
    for h in all(del_list) do
        del(houses, h)
    end
    return houses
end

function get_nearest(house, bld_name)
    local bld
    local hr = 999
    local dict_name = connect_types[bld_name]["dict"]
    for _bld, _hr in pairs(house[dict_name]) do
        if _hr < hr then
            hr = _hr
            bld = _bld
        end
    end 
    return bld
end


function bld_increase_people(bld, count)
    local ppl_name = connect_types[bld.sprite]["ppl_name"]
    local max_ppl = connect_types[bld.sprite]["max_ppl"]
    local people = bld[ppl_name]

    if people < bld[max_ppl] then
        count = min(bld[max_ppl] - people,count)
        set_bld_val(bld,ppl_name,people+count)
    end
    return count
end

function bld_reduce_people(bld, count)
    local ppl_name = connect_types[bld.sprite]["ppl_name"]
    local max_ppl = connect_types[bld.sprite]["max_ppl"]
    local people = bld[ppl_name]
    
    count = min(count,people)
    set_bld_val(bld,ppl_name,people-count)
end