
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
