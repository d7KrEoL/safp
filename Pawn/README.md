### Include for pawn. Allows to do same things as lib. for moonloader.
#### Dependencies: [sscanf2](https://github.com/Y-Less/sscanf/releases)

### Usage:
To save data as san andreas flight plan file use:
```C++
SaveFlightPlan(const filePath[], const Data[][FlightPlanData], dataSize)
```
To load data from san andreas flight plan file use:
```C++
FlightPlanData[] LoadFlightPlan(const filePath[])
```
Flight plan data contains in:
```C++
enum FlightPlanData
{
	number,
	Float: posX,
	Float: posY,
	Float: posZ,
};
```
Example:
```C++
#include "safp.inc"

new _fp_data[SAFP_BUFFER_SIZE][FlightPlanData];

//...
//Load data from file
_fp_data = LoadFlightPlan(filePath);
//...
//Save data to file
new result = SaveFlightPlan(filePath, _fp_data, sizeof(_fp_data));
//...
```

#### [Test and code example](https://github.com/d7KrEoL/safp/blob/update-05.09/Pawn/filterscripts/FlightPlanTests.pwn)
