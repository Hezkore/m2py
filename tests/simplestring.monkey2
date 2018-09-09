#Import "<std>"
Using std..

#Import "../m2py"
Using python..

' Remember that Python's print function is rarely visible in Ted2Go
' So make sure to run the actual executable and not via Ted!

' Example from:
' https://docs.python.org/3/extending/embedding.html#very-high-level-embedding

Function Main()
	
	Local program := Py_DecodeLocale( AppArgs()[0] , Null )
	If Not program Then
		
		Print "Fatal error: cannot decode " + AppArgs()[0]
		Return
	Endif
	
	Py_SetProgramName( program )
	Py_Initialize()
	
	Print "Python says:"
	PyRun_SimpleString( "print( 1 + 2 )" )
	
	If Py_FinalizeEx() < 0 Then Return
	
	PyMem_RawFree( Varptr program )
End