function update_city()
    update_house_list_of("work")
    update_house_connects_to("work")
    update_house_list_of("shop")
    update_house_connects_to("shop")
    
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
        local part = ceil(house["max tenants"]/house["work hr"])
        local work = get_nearest_work(house)

        if work != nil and work["workers"] < work["max workers"] and house["tenants"] > 0 then
            local remain = work_increase_workers(work, min(house["tenants"],part))
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
        local part = ceil(house["max tenants"]/house["shop hr"])
        local shop = get_nearest_shop(house)

        if shop != nil and shop["buyers"] < shop["max buyers"] and house["tenants"] > 0 then
            local remain = shop_increase_buyers(shop, min(house["tenants"],part))
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
            part = ceil(house["max tenants"]/house["work hr"])
            from_bld = get_nearest_work(house)
            type = "workers"
        elseif from == "shop" then
            part = ceil(house["max tenants"]/house["work hr"])
            from_bld = get_nearest_shop(house)
            type = "buyers"
        end


        if from_bld != nil and from_bld[type] > 0 and house["tenants"] < house["max tenants"] then
            local remain = house_increase_tenats(house, min(from_bld[type],part))
            
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
        workers += w["workers"]
    end

    if money >= ceil(workers/10) then
        money -= ceil(workers/10)
        goods += ceil(workers/100)
    end
end

function sell_goods()
    local shops = get_blds("shop")
    local buyers = 0
    
    for b in all(shops) do
        buyers += b["buyers"]
    end

    if goods >= 0 then
        local sold = min(goods,ceil(buyers/100))
        
        goods -= sold
        money += sold * 15
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

function set_bld_val(bld,name,val)
    bld[name] = val
end