# San Andreas Flight Plan Reading Library for [moonloader](https://www.blast.hk/threads/13305/)
This library allows you to read flight waypoints data from San Andreas Flight Plan (*.safp) files.

## Installation and use.
To install library to your San Andreas game you need to place safp.lua file into your game directory -> moonloader -> lib

To use library in your script you need to load it by using:

```local safp = require 'safp' ```

Then you can use a code like this to load waypoints data from any safp file: 

```
function loadSafp(filePath)

  --Check if file exists
  local checkFile=io.open(filePath,"r")
  if checkFile~=nil then
    io.close(checkFile)
  else
    print("Flight plan not found (" .. filePath .. ")")
    return
  end

  --Loading waypoints data from file using moonloader library "safp"
  local wpData = safp.Load(filePath)

  --Now you can simply use wpData as a list of waypoint elements
  yourGetWaypointDataFunc(wpData)

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

wpData looks like this:

```
wpData = {wpid, pos = {x, y, z}} 
```

where:

```
wpid is number (id) of waypoint
pos.x - longitude of waypoint position
pos.y - latitude of waypoint position
pos.z - altitude of waypoint position
```

You can easily generate flight plan files using [this site](http://sampmap.ru/samap)
