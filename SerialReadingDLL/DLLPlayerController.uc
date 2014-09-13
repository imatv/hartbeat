class TestDLLPlayer extends PlayerController

DLLBind(SerialReader);

dllimport final function startReadingSerialData();
dllimport final function int getPulseRate();
dllimport final function int getPulseStatus();
dllimport final function int getBreathingSpeed();

exec function Banana()
{
	local int pulseR;
	local int pulseS;
	local int breathingSpeed;
	say("Starting DLL!");
	startReadingSerialData();
	pulseR = getPulseRate();
	pulseS = getPulseStatus();
	pulseS = getBreathingSpeed();
	say("Pulse rate reading was: "$pulseR);
	say("Pulse status was: "$pulseS);
	say("Breathing speed was: "$breathingSpeed);
}
