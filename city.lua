function update_city()
    update_works_for_houses()
    update_house_connects_to_works()
    update_shops_for_houses()
    update_house_connects_to_shops()
    if hour >= 6 and hour < 12 then
        go_to_work()
        pay_for_work()
    elseif hour >= 12 and hour < 14 then
        go_to_home("work")
    elseif hour >= 14 and hour < 20 then
        go_to_shop()
        sell_goods()
    elseif hour > 20 then
        go_to_home("shop")
    end
end


function go_to_work()
    local houses = get_houses_with_work()
    if #houses == 0 then
        return
    end

    for house in all(houses) do
        local part = ceil(100/house.info["work hr"])
        local work = get_nearest_work(house)

        if work != nil and work.info["workers"] < 300 and house.info["tenants"] > 0 then
            local remain = work_increase_workers(work, part)
            house_reduce_tenats(house, remain)
        end

    end
end

function go_to_shop()
    local houses = get_houses_with_shop()
    if #houses == 0 then
        return
    end

    for house in all(houses) do
        local part = ceil(100/house.info["shop hr"])
        local shop = get_nearest_shop(house)

        if shop != nil and shop.info["buyers"] < 500 and house.info["tenants"] > 0 then
            local remain = shop_increase_buyers(shop, part)
            house_reduce_tenats(house, remain)
        end

    end
end

function go_to_home(from)
    local houses
    if from == "work" then
        houses = get_houses_with_work()
    elseif from == "shop" then
        houses = get_houses_with_shop()
    end

    if #houses == 0 then
        return
    end

    for house in all(houses) do
        local part
        local from_bld
        local type
        if from == "work" then
            part = ceil(100/house.info["work hr"])
            from_bld = get_nearest_work(house)
            type = "workers"
        elseif from == "shop" then
            part = ceil(100/house.info["work hr"])
            from_bld = get_nearest_shop(house)
            type = "buyers"
        end


        if from_bld != nil and from_bld.info[type] > 0 and house.info["tenants"] < 100 then
            local remain = house_increase_tenats(house, part)
            if from == "work" then
                work_reduce_workers(from_bld, remain)
            elseif from == "shop" then
                shop_reduce_buyers(from_bld, remain)
            end
        end
    end
end

function pay_for_work()
    local works = get_blds("work")
    local workers = 0
    
    for w in all(works) do
        workers += w.info["workers"]
    end

    if money >= ceil(workers/10) then
        money -= ceil(workers/10)
        goods += ceil(workers)
    end
end

function sell_goods()
    local shops = get_blds("shop")
    local buyers = 0
    
    for b in all(shops) do
        buyers += b.info["buyers"]
    end

    if goods >= 0 then
        local sold = min(goods,buyers)
        
        goods -= sold
        money += ceil(sold/7)
    end
end
function get_blds(name)
    local blds = {}
    for bld in all(builds) do
        if bld.sprite == name then
            add(blds, bld)
        end
    end
    return blds
end

function set_info(bld,name,val)
    bld.info[name] = val
end