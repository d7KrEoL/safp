#include <a_samp>
/*
If you have old pawn compiler ver.
#define SSCANF_NO_NICE_FEATURES
*/
#include <sscanf2>
#include "file.inc"


#include "safp.inc"

public OnFilterScriptInit()
{
	print("\n");
	print("  |---------------------------------------------------");
	print("  |");
	print("  |    San Andreas Flight Plan Include Demo Test");
	print("  |");
    print("  |    https://github.com/d7KrEoL/safp");
	print("  |    Author: d7.KrEoL");
    print("  |    05th September 2024");
    print("  |");
	print("  |---------------------------------------------------");

	print("\n\nPreparing for tests...");
	new totalTests = 0;
	new successTests = 0;

	//File we'll be working with
	new filePath[128] = "test.safp";

	//Will use generated data for this tests
	new data[127][FlightPlanData];
	for (new i = 0; i < sizeof(data); i++)
	{
	    data[i][number] = i;
	    data[i][posX] = 15 + i;
	    data[i][posY] = 17 + i;
	    data[i][posZ] = 0.03 + i;
	}


	print("\n-----------");
	//Just to know if you have sscanf installed and working correctly
	print("Test sscanf\n");
	new testNumber;
	new Float: x;
	new Float: y;
	new Float: z;
	sscanf("-1 1.444 3.44 5.12", "dfff", testNumber, x, y, z);
	totalTests++;
	new sscanfString[48];
	if (testNumber == -1 && floatabs(x - 1.444) < 0.1 && floatabs(y - 3.44) < 0.1 && floatabs(z - 5.12) < 0.1)
	{
		format(sscanfString, sizeof(sscanfString), "result: %d %f %f %f (OK)", testNumber, x, y, z);
		successTests++;
	}
	else
	    format(sscanfString, sizeof(sscanfString), "result: %d %f %f %f (FAILED)", testNumber, x, y, z);
	print(sscanfString);

	print("-----------");
	print("Test 1 - Write data\n");

	/*
	This function saving data into file
	bool SaveFile(string filePath, FlightPlanData data, int dataSize);
	it returns true if file was saved successfully and false if not
	*/
	new result = SaveFlightPlan(filePath, data, sizeof(data));
	//--------------------------------------------------

	new stringResult[128];
	if (result)
	{
		format(stringResult, sizeof(stringResult), "Done: %d (OK)", result);
		successTests++;
	}
	else
	    format(stringResult, sizeof(stringResult), "Done: %d (FAILED)", result);
 	totalTests++;
	print(stringResult);
	print("-----------");

	print("Test 2 - Read data\n");

	//Will save data into this var
	new totalData[128][FlightPlanData];
	/*
	    This function loading flight plan data from file
	    FlightPlanData[128] LoadFile(string filePath)
	    It returns maximum 127 points.
	    If number of returned points less then 127, first unactive point
	    will have [number] field equal to -1, like:
				totalData[15][number] == -1
	*/
	totalData = LoadFlightPlan(filePath);
	//-----------------------------

	for (new i = 0; i < sizeof(totalData); i++)
	{
	    if(totalData[i][number] == -1) break;
	    if(totalData[i][number] == data[i][number] &&
		floatabs(totalData[i][posX] - data[i][posX]) < 0.1 &&
		floatabs(totalData[i][posY] - data[i][posY]) < 0.1 &&
		floatabs(totalData[i][posZ] - data[i][posZ]) < 0.1)
		{
			format(stringResult, sizeof(stringResult), "Total[%d]: %d %f %f %f (OK)", i, totalData[i][number], totalData[i][posX], totalData[i][posY], totalData[i][posZ]);
			successTests++;
		}
		else
		    format(stringResult, sizeof(stringResult), "Total[%d]: %d %f %f %f (FAILED)", i, totalData[i][number], totalData[i][posX], totalData[i][posY], totalData[i][posZ]);
		totalTests++;
		print(stringResult);
	}
	print("-----------");
	format(filePath, sizeof(filePath), "Total tests: %d, Success: %d, Failed: %d\n", totalTests, successTests, totalTests-successTests);
	print(filePath);
	return 1;
}
