# San Andreas Flight Plan Reading Library for [moonloader](https://www.blast.hk/threads/13305/)
This library allows you to read waypoints data from San Andreas Flight Plan (*.safp) files.

[<img src="https://github.com/user-attachments/assets/2f5ef873-bfea-435d-b243-36fb2ca114ed" width="20">](README_RUS.md)![Russian language ReadMe]()


## Installation and use.
To install library to your San Andreas game you need to place safp.lua file into your game directory -> moonloader -> lib

To use library in your script you need to load it by using:

```lua
local safp = require 'safp'
```

Then you can use a code like this to load waypoints data from any safp file: 

```lua
function loadSafp(filePath)

  --Check if file exist
  local checkFile=io.open(filePath,"r")
  if checkFile~=nil then
    io.close(checkFile)
  else
    print("Flight plan not found (" .. filePath .. ")")
    return
  end

  --Loading waypoints data from file using moonloader library "safp"
  local wpData = safp.Load(filePath)

  --Now you can simply use wpData as a list of waypoint elements in your function
  yourGetWaypointDataFunc(safp.Waypoints)

  --Or iterate it like:
  for i = 1, #safp.Waypoints do

    --And add each waypoint from file using some function that adds waypoints into your scrip:
    yourAddWaypointFunc(safp.Waypoints[i].wpid,
                        safp.Waypoints[i].pos.x,
                        safp.Waypoints[i].pos.y,
                        safp.Waypoints[i].pos.z))
  end
end
```

Waypoints data struct looks like this:

```lua
Waypoints = {wpid, pos = {x, y, z}} 
```

where:

```lua
(int) wpid - number (id) of waypoint
(float) pos.x - longitude of waypoint position
(float) pos.y - latitude of waypoint position
(float) pos.z - altitude of waypoint position
```

You can easily generate flight plan files using [this site](http://sampmap.ru/samap)
