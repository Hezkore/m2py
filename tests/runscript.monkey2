#Import "<std>"
Using std..

#Import "../m2py"
Using python..

' Remember that Python's print function is rarely visible in Ted2Go
' So make sure to run the actual executable and not via Ted!

Function Main()
	
	If AppArgs().Length < 2 Then
		
		Print "Drag a script file onto this executable to run the script"
		Sleep( 20 )
		exit_( 1 )
	Endif
	
	Global program := Py_DecodeLocale( "testProgram" )
	Py_SetProgramName( program )
	
	Local file :=  AppArgs()[1]
	
	Print "Running: " + file
	
	Py_Initialize()
	
	PyRun_SimpleString( LoadString( file ) )
	
	Sleep( 20 )
	
	Py_FinalizeEx()
	PyMem_RawFree( Varptr program )
	
	Return
End