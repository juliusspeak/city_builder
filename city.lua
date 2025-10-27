function update_city()
    update_power_map()
    update_blds_with_power()
    update_farms_with_fields()

    update_house_list_of("work")
    update_house_connects_to("work")
    update_house_list_of("shop")
    update_house_connects_to("shop")
    update_house_list_of("farm")
    update_house_connects_to("farm")

    if hour >= 6 and hour < 12 then
        if flr(rnd(2)) == 0 then
            go_to_build("work")
        else
            go_to_build("farm")
        end
        die_at_work()
        breed_people()
        pay_for_work()
    elseif hour >= 12 and hour < 14 then
        go_to_home("work")
        go_to_home("farm")
    elseif hour >= 14 and hour < 20 then
        go_to_build("shop")
        sell_goods()
    elseif hour > 20 then
        go_to_home("shop")
    end
end


function go_to_build(bld_name)
    local dict_name = connect_types[bld_name]["dict"]
    local hr_name = connect_types[bld_name]["hr_name"]
    local ppl_name = connect_types[bld_name]["ppl_name"]
    local max_ppl = connect_types[bld_name]["max_ppl"]
    local houses = get_houses_with(bld_name)
    if #houses == 0 then
        return
    end

    for house in all(houses) do
        local part = ceil(house["max tenants"]/house[hr_name])
        local bld-- = get_nearest(house,bld_name)

        for bld,hr in pairs(house[dict_name]) do
            if bld != nil and bld[ppl_name] < bld[max_ppl] and house["tenants"] > 0 then
                local remain = bld_increase_people(bld, min(house["tenants"],part))
                bld_reduce_people(house, remain)
            end
        end
    end
end

function go_to_home(from)
    local houses = get_houses_with(from)
    local dict_name = connect_types[from]["dict"]
    local var_name = connect_types[from]["var_name"]
    local hr_name = connect_types[from]["hr_name"]
    local ppl_name = connect_types[from]["ppl_name"]

    if #houses == 0 then
        return
    end

    for house in all(houses) do
        local part
        --local from_bld = get_nearest(house,from)
        
        part = ceil(house["max tenants"]/house[hr_name])
        
        for from_bld,hr in pairs(house[dict_name]) do
            if from_bld != nil and from_bld[ppl_name] > 0 and house["tenants"] < house["max tenants"] then
                local remain = bld_increase_people(house, min(from_bld[ppl_name],part))
                bld_reduce_people(from_bld, remain)
            end
        end
    end
end

function pay_for_work()
    local works = get_blds("work")
    local workers = 0
    local local_goods = 0

    for w in all(works) do
        workers += w["workers"]
        if w["has power"] == "yes" then
            local_goods += workers/50
        else
            local_goods += workers/100
        end
    end
    local_goods = flr(local_goods)

    if money >= ceil(workers/10) then
        money -= ceil(workers/10)
        goods += local_goods
    end
end

function sell_goods()
    local shops = get_blds("shop")
    local buyers = 0
    local local_goods = 0
    
    for b in all(shops) do
        buyers += b["buyers"]
        if b["has power"] == "yes" then
            local_goods += (buyers/100) + (buyers/100*0.5)
        else
            local_goods += buyers/100
        end
    end

    if goods >= 0 then
        local sold = min(goods,local_goods)
        
        goods -= flr(sold)
        money += flr(sold * 15)
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