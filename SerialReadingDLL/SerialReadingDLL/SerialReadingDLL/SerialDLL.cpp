// Provides access to cout and string libraries
#include <iostream>
// Provides access to Serial I/O
#include <windows.h>

// Allows us to easily use iostream functions
using namespace std;

// DECLDIR will export the DLL
#define DLL_EXPORT

// DLL Header
#include "SerialDLL.h"

// We open the COM6 serial port for reading
HANDLE hSerial = CreateFile("COM6", GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

// Global variables for easy access to our pulse and breathing data
int breathingForce = -100, bpm = -100, pulse = -100;

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

// Parses the serial data that we recieve from the comm port
void parseCommData(char* charArray)
{
	// Converts the char array into a string
	string line(charArray);

	// Finds the location of the two commas
	string::size_type pos1 = line.find_first_of(',');
	string::size_type pos2 = line.find(',', pos1 + 1);

	// Converts the specific substring into integers and stores them
	bpm = atoi(line.substr(0, pos1).c_str());
	breathingForce = atoi(line.substr(pos1 + 1, pos2).c_str());
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

// Avoid name mangeling
extern "C"
{
	// Start getting data
	DECLDIR void startReadingSerialData()
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

	// Returns pulserate
	DECLDIR int getPulseRate()
	{
		return bpm;
	}

	DECLDIR int getPulseStatus()
	{
		return pulse;
	}

	// Returns the breathing force
	DECLDIR int getBreathingForce()
	{
		return breathingForce;
	}
}