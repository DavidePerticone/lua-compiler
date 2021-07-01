
	--Tables used to represent sets


	Set = {}

	--a.x = 10    -- same as a["x"] = 10

	Set.mt = {}    -- metatable for sets
	--Set["mt"]={} Equivalent

    --Set contains a set generator
    function Set.new (t)
      local set = {}
	  setmetatable(set, Set.mt) --set the same metatable for each set
	  for index, l in ipairs(t) do
		set[l] = true --set set["setElement"]=true
	  end
      return set
    end

	-- computes union of two sets
    function Set.union (a,b)
      local res = Set.new{}
      for k in pairs(a) do res[k] = true end
      for k in pairs(b) do res[k] = true end
      return res
    end

    --computes intersection of two sets
    function Set.intersection (a,b)
      local res = Set.new{}
      for k in pairs(a) do
        res[k] = b[k] --If element present in a but not in b, it is set to null
      end
      return res
    end

	--convert set into a string
	function Set.tostring (set)
      local s = "{"
      local sep = ""
      for e in pairs(set) do
        s = s .. sep .. e
        sep = ", "
      end
      return s .. "}"
    end

	--print a set using Set.tostring
    function Set.print (s)
      print(Set.tostring(s))
    end




	s1 = Set.new({10, 20, 30, 50})
    s2 = Set.new({30, 1})
    print(getmetatable(s1))          --Print the same metatable for both
    print(getmetatable(s2))


	--set the method Set.union as add operator
	Set.mt.__add = Set.union

	 s3 = s1 + s2
    Set.print(s3)  --> {1, 10, 20, 30, 50}

	--set the method Set.intersection as mul operator
	Set.mt.__mul = Set.intersection
    Set.print((s1 + s2)*s1)     --> {10, 20, 30, 50}
