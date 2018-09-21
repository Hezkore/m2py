#Import "<std>"
Using std..

#Import "../m2py"
Using python..

#Import "assets/stdout.py@/.."

' Capture STDOUT and STDERR with our own functions

Function OurPrint( text:String )
	
	libc.fputs( text, libc.stdout )
	libc.fflush( libc.stdout )
End

Function OurError( text:String )
	
	libc.fputs( text, libc.stdout )
	libc.fflush( libc.stdout )
	
	libc.fputs( text, libc.stderr )
	libc.fflush( libc.stderr )
End

Function Main()
	
	Local program := Py_DecodeLocale( AppArgs()[0] , Null )
	If Not program Then
		
		Print "Fatal error: cannot decode " + AppArgs()[0]
		Return
	Endif
	
	Local file := "stdout" ' File to load
	Local callFunc := "multiply" ' Function to call ( and always our new own )
	Local funcParam := New Int[]( 3, 2 ) ' Parameters to pass the function
	
	Local pName:PyObject Ptr, pModule:PyObject Ptr, pFunc:PyObject Ptr
	Local pArgs:PyObject Ptr, pValue:PyObject Ptr
	Local i:Int
	
	M2Py_Initialize( OurPrint, OurError )
	
	' The rest is pretty much the same as the 'Pure Embedding' example
	pName = PyUnicode_DecodeFSDefault( file )
	' Error checking of pName left out
	
	pModule = PyImport_Import( pName )
	Py_DECREF( pName )
	
	If pModule Then
		pFunc = PyObject_GetAttrString( pModule, callFunc )
		
		If pFunc And PyCallable_Check( pFunc ) Then
			
			pArgs = PyTuple_New( funcParam.Length )
			For i = 0 Until funcParam.Length
				
				pValue = PyLong_FromLong( funcParam[i] )
				
				If Not pValue Then
					
					Py_DECREF( pArgs )
					Py_DECREF( pModule )
					Print( "Cannot convert argument" )
					Sleep( 10 )
					
					Return
				End
				
				' pValue reference stolen here:
				PyTuple_SetItem( pArgs, i, pValue )
			Next
			
			pValue = PyObject_CallObject( pFunc, pArgs )
			Py_DECREF(pArgs)
			
			If pValue Then
				
				Print( "Result of call: " + PyLong_AsLong( pValue ) )
				Py_DECREF(pValue)
				
				Sleep( 10 )
			Else
				
				Py_DECREF(pFunc)
				Py_DECREF(pModule)
				PyErr_Print()
				Print( "Call failed" )
				Sleep( 10 )
				
				Return
			Endif
		Else
			
			If PyErr_Occurred() Then PyErr_Print()
			Print( "Cannot find function " + callFunc + " in ~q" + file + ".py~q" )
			Sleep( 10 )
			
			Return
		Endif
		
		Py_XDECREF(pFunc)
		Py_DECREF(pModule)
	Else
		PyErr_Print()
		Print( "Failed to load script ~q" + file + ".py~q" )
		Sleep( 10 )
		
		Return
	Endif
End