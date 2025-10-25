
function get_empty_works()
    local works = get_blds("work")
    local del_list = {}

    for w in all(works) do
        if w["workers"] >= 300 then
            add(del_list,w)
        end
    end
    for w in all(del_list) do
        del(works,w)
    end
    return works
end

function update_work_power()
    local works = get_blds("work")
    for w in all(works) do
        w["has power"] = "no"
        local x = w.x
        local y = w.y
        if powered[x][y] == true or
        powered[x+1][y] == true or
        powered[x][y+1] == true or
        powered[x+1][y+1] == true then
            w["has power"] = "yes"
        end
    end

end