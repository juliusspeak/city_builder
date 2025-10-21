function get_nearest_shop(house)
    local shop
    local hr = 999
    for _shop, _hr in pairs(house.shops) do
        if _hr < hr then
            hr = _hr
            shop = _shop
        end
    end 
    return shop
end

function shop_increase_buyers(shop, count)
    local buyers = shop.info["buyers"]
    if buyers < 500 then
        count = min(500 - buyers,count)
        set_info(shop,"buyers",buyers+count)
    end
    return count
end

function shop_reduce_buyers(shop, count)
    local buyers = shop.info["buyers"]
    count = min(count,buyers)
    set_info(shop,"buyers",buyers-count)
end