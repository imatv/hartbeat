------------------------------------------------------------------------------
SerialPort project (Hartbeat\SerialReadingDLL\SerialPort)
------------------------------------------------------------------------------
This project simply reads data from the specified serial port.
1) Open the "SerialPortTest.sln" file.
2) Change the string "COM6" to your specific COM port in "HANDLE hSerial = CreateFile("COM6", GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);"
3) Compile and run.

------------------------------------------------------------------------------
SerialReadingDLL project (Hartbeat\SerialReadingDLL\SerialReadingDLL)
------------------------------------------------------------------------------
This project contains the code for the dll file. 
1) Open the "SerialReadingDLL.sln" file.
2) Build the code.
3) Go to the Debug folder (Hartbeat\SerialReadingDLL\SerialReadingDLL\Debug) and you should find here the .dll and .lib. These are the files that we will be using.

The dll file will be used in our Unreal Engine Game and both these files will be used in our C++ program that tests the functionality of the dll file.

------------------------------------------------------------------------------
TestDLL project (Hartbeat\SerialReadingDLL\TestDLL)
------------------------------------------------------------------------------
This project contains the code for the dll test program.
1) Before running this program, copy the dll and lib files we compiled in the SerialReadingDLL project into the following directory (Hartbeat\SerialReadingDLL\TestDLL\TestDLL)
2) Open the "TestDLL.sln" file.
3) Compile and run.

------------------------------------------------------------------------------
For the functionality of each project and the logic behind its code, read the comments of the code.
------------------------------------------------------------------------------