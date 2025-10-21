
function work_increase_workers(work, count)
    local workers = work.info["workers"]
    if workers < 300 then
        count = min(300 - workers,count)
        set_info(work,"workers",workers+count)
    end
    return count
end

function work_reduce_workers(work, count)
    local workers = work.info["workers"]
    count = min(count,workers)
    set_info(work,"workers",workers-count)
end

function get_empty_works()
    local works = get_blds("work")
    local del_list = {}

    for w in all(works) do
        if w.info["workers"] >= 300 then
            add(del_list,w)
        end
    end
    for w in all(del_list) do
        del(works,w)
    end
    return works
end


function get_nearest_work(house)
    local work
    local hr = 999
    for _work, _hr in pairs(house.works) do
        if _hr < hr then
            hr = _hr
            work = _work
        end
    end 
    return work
end