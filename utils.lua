function dot_in_rec(x1,y1,
rx1,ry1,rx2,ry2)
	if x1 >= rx1 then
		if x1 <= rx2 then
			if y1 >= ry1 then
				if y1 <= ry2 then
					return true
				end
			end	
		end
	end
	return false
end

function has(tbl, val)
	for key,_val in pairs(tbl) do
		if val == _val then
			return true
		end
	end
	return false
end

function merge(a1, a2)
	for val in all(a2) do
		add(a1, val)
	end
	return a1
end

function dict_size(dict)
	local n = 0
	for k,v in pairs(dict) do
		if v != nil then
			n += 1
		end
	end
	return n
end
