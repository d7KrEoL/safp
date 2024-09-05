
/*
	This is San Andreas Flight Plan files read/write include for Pawn.
	Author: d7.KrEoL
	https://vk.com/d7kreol
	https://discord.gg/QSKkNhZrTh
	Project's GitHub Page: https://github.com/d7KrEoL/safp
	San Andreas Flight Plans Editor: http://sampmap.ru/samap
*/


enum FlightPlanData
{
	number,
	Float: posX,
	Float: posY,
	Float: posZ,
};

forward SplitLine(const strsrc[], strdest[][], delimiter);

stock ReplaceSymb(stringReplace[], from, to)
{
	for (new i = 0; i < strlen(stringReplace); i++)
	{
		if(stringReplace[i] == from)
		    stringReplace[i] = to;
	}
}

public SplitLine(const strsrc[], strdest[][], delimiter)
{
        new i, li;
        new aNum;
        new len;
        while(i <= strlen(strsrc))
        {
            if(strsrc[i]==delimiter || i==strlen(strsrc))
            {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
            }
            i++;
        }
        return 1;
}

stock SaveFile(const filePath[], const Data[][FlightPlanData], dataSize)
{
	new File: nFile = fopen(filePath, io_write);
	if (nFile == File:0)
	{
	    print("Unable to open file");
	    return false;
	}

	fwrite(nFile, "San Andreas Flight Plan file encoder ver. 5.8.24-pawn\n");
	fwrite(nFile, "This file can be read by SAMP Avionics LUA script: https://github.com/d7KrEoL/avionics\n");
	fwrite(nFile, "You can simply edit this file at online flight plan editor: http://sampmap.ru/samap\n");
	new stringWrite[128];
	for (new i = 0; i < dataSize; i++)
	{
		if (Data[i][number] == -1)
		    break;
		format(stringWrite, sizeof(stringWrite), "{Waypoint=%d;PosX=%.2f;PosY=%.2f;PosZ=%.2f}\n", Data[i][number], Data[i][posX], Data[i][posY], Data[i][posZ]);
		fwrite(nFile, stringWrite);
	}
	fclose(nFile);
	return true;
}

stock FPCountFile(const filePath[])
{
	new File: nFile = fopen(filePath, io_read);
	if (nFile == File:0)
	{
	    print("Unable to open file");
	    return 0;
	}
	new count = 0;
	new buffer[128];
	while (fread(nFile, buffer))
	{
		count++;
	}
	return count;
}

stock FPReadLine(const line[])
{
    new resultData[FlightPlanData];
	new bigParts[4][48];
	new smallParts[2][24];
    SplitLine(line, bigParts, ';');
    for (new i = 0; i < 4; i++)
    {
		SplitLine(bigParts[i], smallParts, '=');
		if(!strcmp(smallParts[0], "{Waypoint"))
		    sscanf(smallParts[1], "d", resultData[number]);
		else if(!strcmp(smallParts[0], "PosX"))
		    sscanf(smallParts[1], "f", resultData[posX]);
		else if(!strcmp(smallParts[0], "PosY"))
		    sscanf(smallParts[1], "f", resultData[posY]);
		else if(!strcmp(smallParts[0], "PosZ"))
		{
		    ReplaceSymb(smallParts[1], '}', '0');
		    sscanf(smallParts[1], "f", resultData[posZ]);
		}
    }
    return resultData;
}

stock LoadFile(const filePath[])
{
    new File: nFile = fopen(filePath, io_read);
    new resultData[128][FlightPlanData];
	if (nFile == File:0)
	{
	    print("Unable to open file");
	    return resultData;
	}
	new buffer[128];
	new count = 0;
	while (fread(nFile, buffer))
	{
	    if (buffer[0] != '{')
	        continue;
		resultData[count] = FPReadLine(buffer);
		count++;
	}
	if (count < 512)
	    resultData[count][number] = -1;
	fclose(nFile);
 	return resultData;
}