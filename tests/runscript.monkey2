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
	
	Local program := Py_DecodeLocale( AppArgs()[0] , Null )
	If Not program Then
		
		Print "Fatal error: cannot decode " + AppArgs()[0]
		Return
	Endif
	
	Local file :=  AppArgs()[1]
	
	Print "Running: " + file
	
	Py_Initialize()
	
	PyRun_SimpleString( LoadString( file ) )
	
	Sleep( 20 )
	
	Py_FinalizeEx()
	PyMem_RawFree( Varptr program )
	
	Return
End