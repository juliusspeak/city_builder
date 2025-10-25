function update_house_connects_to(bld_name)
    local connect_types = {
        work = {
            dict = "works",
            var_name = "has work",
            hr_name = "work hr"
        },
        shop = {
            dict = "shops",
            var_name = "has shop",
            hr_name = "shop hr"
        },
    }
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
    local connect_types = {
        work = {
            dict = "works",
            var_name = "has work",
            hr_name = "work hr"
        },
        shop = {
            dict = "shops",
            var_name = "has shop",
            hr_name = "shop hr"
        },
    }
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

function get_houses_with_work()
    local houses = get_blds("house")
    local del_list = {}

    for h in all(houses) do
        if h["has work"] == "no" then
            add(del_list,h)
        end
    end
    for h in all(del_list) do
        del(houses, h)
    end
    return houses
end

function house_increase_tenats(house, count)
    local tenants = house["tenants"]
    if tenants < 100 then
        count = min(100 - tenants,count)
        set_bld_val(house,"tenants",tenants+count)
    end
    return count
end
function house_reduce_tenats(house, count)
    local tenants = house["tenants"]
    count = min(count,tenants)
    set_bld_val(house,"tenants",tenants-count)
end

function get_houses_with_shop()
    local houses = get_blds("house")
    local del_list = {}

    for h in all(houses) do
        if h["has shop"] == "no" then
            add(del_list,h)
        end
    end
    for h in all(del_list) do
        del(houses, h)
    end
    return houses
end