#include "stdafx.h"
#include <stdio.h>

// Provides access to cout and string libraries
#include <iostream>

// Allows us to easily use iostream functions
using namespace std;

// We open the COM6 serial port for reading
HANDLE hSerial = CreateFile("COM6", GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

// Global variables for easy access to our pulse and breathing data
int breathingSpeed = -100, bpm = -100, pulse = -100;
// Length of time interval that we want to analyze
int timeInterval = 3000;
// Number of indexes that our breathing data array will have based on the amount of time of data we want to store
// (200 in this case is the delay between each reading)
int totalIndexes = timeInterval / 200;
// Declare array that will hold breathing data collected in the past timeInterval
int breathingData[150];
// Integer that will tell us at what point of the breathing data collection we are at
int index = 0;

// Set DCB struct with our specific parameters
void setupDCB(DCB &dcb)
{
	dcb.DCBlength = sizeof(dcb);
	dcb.BaudRate = CBR_115200;
	dcb.ByteSize = 8;
	dcb.StopBits = ONESTOPBIT;
	dcb.Parity = NOPARITY;
}

// Set serial timeout times
void setupTimeOuts(COMMTIMEOUTS &timeouts)
{
	timeouts.ReadIntervalTimeout = 50;
	timeouts.ReadTotalTimeoutConstant = 50;
	timeouts.ReadTotalTimeoutMultiplier = 10;

	// If we are unable to set these, provide an error
	if (!SetCommTimeouts(hSerial, &timeouts))
	{
		cout << "timeout error";
	}
}

// Test if we are able to get and set comm states
void testComStates(DCB &dcb)
{
	if (!GetCommState(hSerial, &dcb))
	{
		cout << "getting state error" << endl;
	}

	if (!SetCommState(hSerial, &dcb))
	{
		cout << "setting serial port state error" << endl;
	}
}

// Analysis now being done in arduino code
DWORD WINAPI analyzeBreathingData(LPVOID lpParam)
{
	// Calculate the average of our current breathing data
	int total = 0;
	for (int ind = 0; ind < totalIndexes; ind++)
		total += breathingData[ind];
	int average = total / totalIndexes;

	// Calc if wave starts from above
	/*boolean above = (breathingData[0] > average);

	// variable to store breathing speed
	int tempBreathingSpeed = 0;

	// store what the last index was when a breath was counted so that we don't count breaths too frequently
	int lastChangeIndex = -2;

	// Loop through array
	for (int ind = 0; ind < totalIndexes; ind++)
	{
		// If the current index crosses the average and the last counted breath was not very recent, count a breath
		if (((above && breathingData[ind] < average) || (!above && breathingData[ind] > average)) && lastChangeIndex < (ind - 4))
		{
			tempBreathingSpeed++;
			lastChangeIndex = ind;
			above != above;
		}
	}

	// Update breathing speed data
	breathingSpeed = tempBreathingSpeed;
	*/
	return 1;
}

// Stores the data parsed from the breathing sensor
void addBreathingForceData(int breath)
{
	// If the breathing sensor data is not valid, the function does not store it
	if (breath < 0)
		return;

	// Stores the breathing sensor data
	breathingData[index%totalIndexes] = breath;

	// Checks if the array is full
	if (index%totalIndexes == (totalIndexes - 1))
	{
		//Create thread to analyze data
		CreateThread(
			NULL,                   // default security attributes
			0,                      // use default stack size  
			analyzeBreathingData,       // thread function name
			NULL,          // argument to thread function 
			0,                      // use default creation flags 
			NULL);
	}

	index++;
}

// Parses the serial data that we recieve from the comm port
void parseCommData(char* charArray)
{
	// Converts the char array into a string
	string line(charArray);

	// Finds the location of the two commas
	string::size_type pos1 = line.find_first_of(',');
	string::size_type pos2 = line.find(',', pos1 + 1);

	// Converts the specific substring into integers and stores them
	addBreathingForceData(atoi(line.substr(0, pos1).c_str()));
	bpm = atoi(line.substr(pos1 + 1, pos2).c_str());
	pulse = atoi(line.substr(pos2 + 1).c_str());
}

// This is the main function to read and save serial data
DWORD WINAPI readSerial(LPVOID lpParam)
{
	// Set up the serial port
	DCB dcbSerialParams = { 0 };
	setupDCB(dcbSerialParams);

	testComStates(dcbSerialParams);

	COMMTIMEOUTS timeouts = { 0 };
	setupTimeOuts(timeouts);

	// Set up the buffer for the serial reading
	int n = 25;
	char szBuff[25 + 1] = { 0 };
	DWORD dwBytesRead = 0;

	// Read forever
	while (true){
		// If it is unable to read the data, throw an error
		if (!ReadFile(hSerial, szBuff, n, &dwBytesRead, NULL)){
			cout << "serial read error";
			return 0;
		}
		else{
			// Parse the line that was recieved in the serial port
			parseCommData(szBuff);
		}
	}

	// Close the serial port once done
	CloseHandle(hSerial);

	return 1;
}


extern "C"
{
	struct FVector
	{
		float x,y,z;
	};

	__declspec(dllexport) void startReadingSerialData()
	{
		CreateThread(
			NULL,                   // default security attributes
			0,                      // use default stack size  
			readSerial,       // thread function name
			NULL,          // argument to thread function 
			0,                      // use default creation flags 
			NULL);
		return;
	}

	__declspec(dllexport) int getPulseRate()
	{
		return bpm;
	}

	__declspec(dllexport) int getPulseStatus()
	{
		return pulse;
	}

	__declspec(dllexport) int getBreathingSpeed()
	{
		return breathingSpeed;
	}
}
