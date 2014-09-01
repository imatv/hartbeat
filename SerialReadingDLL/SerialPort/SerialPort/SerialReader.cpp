// Test serial reading

#include<iostream>
#include <windows.h>

using namespace std;

void readSerial();
void setupDCB(DCB &dcb);
void setupTimeOuts(COMMTIMEOUTS &timeouts);
void testComStates(DCB &dcb);

HANDLE hSerial = CreateFile("COM6", GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
int bpm = 0, breathingForce = 0;

int main()
{
	readSerial();
	return 1;
}

void readSerial()
{
	DCB dcbSerialParams = { 0 };
	setupDCB(dcbSerialParams);

	testComStates(dcbSerialParams);

	COMMTIMEOUTS timeouts = { 0 };
	setupTimeOuts(timeouts);

	int n = 25;
	char szBuff[25 + 1] = { 0 };
	DWORD dwBytesRead = 0;

	while (true){
		if (!ReadFile(hSerial, szBuff, n, &dwBytesRead, NULL)){
			cout << "serial read error";
			return;
		}else{
			cout << szBuff << endl;
		}
	}

	CloseHandle(hSerial);
}

void parseCommData(char* charArray)
{
	string line(charArray);

	string::size_type pos = line.find_first_of(',');
	bpm = atoi(line.substr(0, pos).c_str());
	breathingForce = atoi(line.substr(pos).c_str());
}

void setupDCB(DCB &dcb)
{
	dcb.DCBlength = sizeof(dcb);
	dcb.BaudRate = CBR_115200;
	dcb.ByteSize = 8;
	dcb.StopBits = ONESTOPBIT;
	dcb.Parity = NOPARITY;
}

void setupTimeOuts(COMMTIMEOUTS &timeouts)
{
	timeouts.ReadIntervalTimeout = 50;
	timeouts.ReadTotalTimeoutConstant = 50;
	timeouts.ReadTotalTimeoutMultiplier = 10;

	if (!SetCommTimeouts(hSerial, &timeouts))
	{
		cout << "timeout error";
	}
}

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