function update_house_connects_to_works()
    for house in all(get_blds("house")) do
        
        if dict_size(house.works) > 0 then
            set_bld_val(house,"has work","yes")
            set_bld_val(house,"work hr",999)

            for work, hr in pairs(house.works) do
                if hr < house["work hr"] then
                   set_bld_val(house,"work hr",hr)
                end
            end 
            
        else
            set_bld_val(house,"has work","no")
            set_bld_val(house,"work hr",0)
        end
    end
end

function update_works_for_houses()
    local houses = get_blds("house")
    local works = get_blds("work")

    for h in all(houses) do
        h.works = {}
    end

    for work in all(works) do
        for house in all(houses) do
            local dist_to_work = dist(house.x,house.y+2,work.x,work.y+2)
            if dist_to_work > 0 then
                house.works[work] = dist_to_work
            else
                if has(house.works,work) then
                    house.works[work] = nil
                end
            end
        end
    end
end

function update_shops_for_houses()
    local houses = get_blds("house")
    local shops = get_blds("shop")

    for h in all(houses) do
        h.shops = {}
    end

    for shop in all(shops) do
        for house in all(houses) do
            local dist_to_shop = dist(house.x,house.y+2,shop.x,shop.y+2)
            if dist_to_shop > 0 then
                house.shops[shop] = dist_to_shop
            else
                if has(house.shops,shop) then
                    house.shops[shop] = nil
                end
            end
        end
    end
end

function update_house_connects_to_shops()
    for house in all(get_blds("house")) do
        
        if dict_size(house.shops) > 0 then
            set_bld_val(house,"has shop","yes")
            set_bld_val(house,"shop hr",999)

            for shop, hr in pairs(house.shops) do
                if hr < house["shop hr"] then
                   set_bld_val(house,"shop hr",hr)
                end
            end 
            
        else
            set_bld_val(house,"has shop","no")
            set_bld_val(house,"shop hr",0)
        end
    end
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