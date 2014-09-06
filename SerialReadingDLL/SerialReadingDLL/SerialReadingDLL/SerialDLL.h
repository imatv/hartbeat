// Inclusion guard
#ifndef _DLLTUT_DLL_H_
#define _DLLTUT_DLL_H_

// If DLL_EXPORT is defined in a file then DECLDIR does export
// otherwise DECLDIR will do an import
#if defined DLL_EXPORT
#define DECLDIR __declspec(dllexport)
#else
#define DECLDIR __declspec(dllimport)
#endif

// Specify "C" linkage so that we don't have to deal with C++ name mangeling
extern "C"
{
	// Declare our functions
	DECLDIR void startReadingSerialData();
	DECLDIR int getPulseRate();
	DECLDIR int getPulseStatus();
	DECLDIR int getBreathingSpeed();
}

// End the inclusion guard
#endif