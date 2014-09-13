class TestDLLPlayer extends PlayerController

DLLBind(SerialReader);

dllimport final function startReadingSerialData();
dllimport final function int getPulseRate();
dllimport final function int getPulseStatus();
dllimport final function int getBreathingSpeed();

exec function Test()
{
	say("Starting DLL!");
	startReadingSerialData();
	local int pulseR;
	pulseR = getPulseRate();
	local int pulseS;
	pulseS = getPulseStatus();
	local int breathingSpeed;
	pulseS = getBreathingSpeed();
	say("Pulse rate reading was: "$pulseR);
	say("Pulse status was: "$pulseS);
	say("Breathing speed was: "$breathingSpeed);
}
