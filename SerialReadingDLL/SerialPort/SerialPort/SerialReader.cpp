// Test serial reading

#include<iostream>
#include <windows.h>

using namespace std;

void readSerial();
void setupDCB(DCB &dcb);
void setupTimeOuts(COMMTIMEOUTS &timeouts);
void testComStates(DCB &dcb);
void parseCommData(char* charArray);

HANDLE hSerial = CreateFile("COM3", GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
int breathingForce = -100, bpm = -100, pulse = -100;

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
			//parseCommData(szBuff);
		}
	}

	CloseHandle(hSerial);
}

void parseCommData(char* charArray)
{
	string line(charArray);

	string::size_type pos1 = line.find_first_of(',');
	string::size_type pos2 = line.find(',', pos1+1);
	bpm = atoi(line.substr(0, pos1).c_str());
	cout << bpm;
	breathingForce = atoi(line.substr(pos1+1, pos2).c_str());
	cout << breathingForce;
	pulse = atoi(line.substr(pos2+1).c_str());
	cout << pulse << endl;
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