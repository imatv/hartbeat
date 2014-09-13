#include <iostream>
#include <windows.h>
#include "SerialDLL.h" 

using namespace std;

int main()
{
	// Start serial data reader/parser thread
	startReadingSerialData();

	// Data format should be fsr,bpm,pulse
	while (true)
	{
		// Print results
		cout << "Breathing Force: " << getBreathingForce() << endl;
		cout << "Beats Per Minute: " << getPulseRate() << endl;
		cout << "Pulse: " << getPulseStatus() << endl;
		Sleep(100);
		// Clear terminal
		system("CLS");
	}

	return(1);
}