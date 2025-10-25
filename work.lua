function die_at_work()
    for w in all(get_blds("work")) do
        if w["workers"] > 1 then
            local chance = 0
            if w["has power"] == "yes" then
                chance = 3
            else
                chance = 5
            end

            if flr(rnd(chance)) == 0 then
                w["workers"] -= 1
            end
        end
    end
end