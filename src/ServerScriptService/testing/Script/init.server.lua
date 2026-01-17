local a = {}
local b = {}
local c = {}


for x = -10, 10, 1  do
	table.insert(a, x)
	table.insert(b, x)
	table.insert(c, x)
end

local function removeDuplicates(tbl)
	local seen = {}
	local result = {}

	for _, value in ipairs(tbl) do
		if not seen[value] then
			seen[value] = true
			table.insert(result, value)
		end
	end

	return result
end

function narrowValues(values1, values2, formula, result)
	local newvalues1 = {}
	local newvalues2 = {}
	for _, x in pairs(values1) do
		for _, y in pairs(values2) do
			if math.round(formula(x,y)) == result then
				table.insert(newvalues1, x)
				table.insert(newvalues2, y)
			end
		end
	end
	--return newvalues1, newvalues2
	return removeDuplicates(newvalues1), removeDuplicates(newvalues2)
end

-- narrowing the values down

a,c = narrowValues(a,c,function(x,y) 
	return (1*x) - (-5*y)
end,1)

b,c = narrowValues(b,c,function(x,y) 
	return ((0.11*x) / (1*y)) + -0
end,1)

b,c = narrowValues(b,c,function(x,y) 
	return (1*x) + (-8*y)
end,1)

b,c = narrowValues(b,c,function(x,y) 
	return (-0.56*x) - (-6*y)
end,1)

a,c = narrowValues(a,c,function(x,y) 
	return (1*x) * (-0.25*y)
end,1)

print("j:",a, #a)
print("l:",b, #b)
print("u:",c, #c)
