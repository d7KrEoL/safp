--Can read *.safp flight plan data
--You can easily generate flight plan here: http://sampmap.ru/samap

local wpData = {wpid, pos = {x, y, z}}

function LoadFile(path)
	for rw in ipairs(wpData) do
		wpData[rw] = nil;
	end
  
	local rsline = getFileDataLines(path)
	parseData(rsline)
	return wpData
end

function doesFileExist(path)
	local f = io.open(path, "rb")
	if f then f:close() end
	return f ~= nil
end

function getFileDataLines(path)
	if not doesFileExist(path) then return {} end
	local lines = {}
	for line in io.lines(path) do
		table.insert(lines, line)
	end
	return lines
end

function parseData(lines)
	
	local splitstring, params
	local lineType = -1
	local count = 0
	
	for i = 1, #lines do
		lines[i] = replace(lines[i], "}", "")
		splitstring = split(lines[i], ';')
		if #splitstring > 2 then
			count = count + 1
			table.insert(wpData, {wpid = 0, pos = {x = 0, y = 0, z = 0}})
			for j = 1, #splitstring do
				lineType = parseLine(splitstring[j], lineType, count)
			end
		end
	end
end

function parseLine(splitstring, lineType, index)
	params = split(splitstring, '=')
	if (#params < 2) then return lineType end 
	if (string.find(splitstring, "{Waypoint") or lineType == 0) then
		lineType = 0
		if string.find(params[1],"{Waypoint") then 
			wpData[index].wpid = params[2]
		elseif (string.find(params[1], "PosX")) then
			wpData[index].pos.x = tonumber(replace(params[2], ',', '.'))
		elseif (string.find(params[1], "PosY")) then
			wpData[index].pos.y = tonumber(replace(params[2], ',', '.'))
		elseif (string.find(params[1], "PosZ")) then
			wpData[index].pos.z = tonumber(replace(params[2], ',', '.'))
			lineType = -1
		else
			lineType = -1
		end
	end
	return lineType
end

function split (inputstr, sep)
  if sep == nil then
          sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, str)
  end
  return t
end

function replace (inputstr, from, to)
	if (inputstr == nil) or (from == nil) then 
    print("Replace null exception: ", inputstr, from, to) 
    return 
  end
	local res = string.gsub(inputstr, from, to)
	return res
end

return { Load = LoadFile, Waypoints = wpData }
