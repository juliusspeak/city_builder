function update_city()
    update_house_list_of("work")
    update_house_connects_to("work")
    update_house_list_of("shop")
    update_house_connects_to("shop")

    if hour >= 6 and hour < 12 then
        go_to_build("work")
        pay_for_work()
    elseif hour >= 12 and hour < 14 then
        go_to_home("work")
    elseif hour >= 14 and hour < 20 then
        go_to_build("shop")
        sell_goods()
    elseif hour > 20 then
        go_to_home("shop")
    end
end


function go_to_build(bld_name)
    local hr_name = connect_types[bld_name]["hr_name"]
    local ppl_name = connect_types[bld_name]["ppl_name"]
    local max_ppl = connect_types[bld_name]["max_ppl"]
    local houses = get_houses_with(bld_name)
    if #houses == 0 then
        return
    end

    for house in all(houses) do
        local part = ceil(house["max tenants"]/house[hr_name])
        local bld = get_nearest(house,bld_name)

        if bld != nil and bld[ppl_name] < bld[max_ppl] and house["tenants"] > 0 then
            local remain = bld_increase_people(bld, min(house["tenants"],part))
            house_reduce_tenats(house, remain)
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
        local from_bld
        
        part = ceil(house["max tenants"]/house[hr_name])
        from_bld = get_nearest(house,from)

        if from_bld != nil and from_bld[ppl_name] > 0 and house["tenants"] < house["max tenants"] then
            local remain = house_increase_tenats(house, min(from_bld[ppl_name],part))
            bld_reduce_people(from_bld, remain)
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