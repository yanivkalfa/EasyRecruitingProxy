EasyRecruitingProxy.Utils.Table = {};

-- extending table functionality 
function EasyRecruitingProxy.Utils.Table.slice(tbl, startPos, endPos)
  if(type(tbl) ~= "table") then 
    return false;
  end
  local length = table.getn(tbl);
  startPos = startPos or 1;
  endPos = endPos or length;
  local newTbl = {};
  if(type(startPos) == "number" and startPos <= -0 ) then
    startPos = 1;
  end
  
  if(type(endPos) == "number" and endPos <= -0 ) then
    endPos = length;
  end
  
  if(type(endPos) == "number" and endPos > length) then
    endPos = length
  end
  
  for i=startPos, endPos do
    table.insert(newTbl, table.getn(newTbl)+1,  tbl[i] );
  end
  return newTbl;
end

function EasyRecruitingProxy.Utils.Table.find(tbl, test)
  if(type(tbl) ~= "table") then
		error("bad argument #1 to 'findIndex' (table expected, got "..type(tbl)..")");
	end
	if(type(test) ~= "function") then
		error("bad argument #2 to 'findIndex' (function expected, got "..type(tbl)..")");
	end
	for index, value in pairs(tbl) do
		if (test(index, value)) then
      return value;
		end
	end
	return false;
end

function EasyRecruitingProxy.Utils.Table.map(tbl, map)
	if(type(tbl) ~= "table") then
		error("bad argument #1 to 'map' (table expected, got "..type(tbl)..")");
	end
	if(type(map) ~= "function") then
		error("bad argument #2 to 'map' (function expected, got "..type(tbl)..")");
	end
	local newTbl = {};
	for index, value in pairs(tbl) do
		newTbl[index] = map(index, value);
	end

	return newTbl;
end

function EasyRecruitingProxy.Utils.Table.findIndex(tbl, test)
  if(type(tbl) ~= "table") then
		error("bad argument #1 to 'findIndex' (table expected, got "..type(tbl)..")");
	end
	if(type(test) ~= "function") then
		error("bad argument #2 to 'findIndex' (function expected, got "..type(tbl)..")");
	end
	for index, value in pairs(tbl) do
		if (test(index, value)) then
      return index;
		end
	end
	return 0;
end

function EasyRecruitingProxy.Utils.Table.indexOf(tbl, item)
	if(type(tbl) ~= "table") then
		error("bad argument #1 to 'indexOf' (table expected, got "..type(tbl)..")");
	end
	if(not item) then
		error("bad argument #2 to 'indexOf' (function anything, got "..type(tbl)..")");
	end
	for index, value in pairs(tbl) do
		if(value == item) then
			return index;
		end
	end;
  return 0;
end

function EasyRecruitingProxy.Utils.Table.filter(tbl, filter)
	if(type(tbl) ~= "table") then
		error("bad argument #1 to 'filter' (table expected, got "..type(tbl)..")");
	end
	if(type(filter) ~= "function") then
		error("bad argument #2 to 'filter' (function expected, got "..type(tbl)..")");
	end
	local newTbl = {};
	for index, value in pairs(tbl) do
		if (not filter(index, value)) then
			local pos = table.getn(newTbl)+1;
			table.insert(newTbl, pos, value);
		end
	end

	return newTbl;
end
