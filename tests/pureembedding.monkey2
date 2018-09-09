#Import "<std>"
Using std..

#Import "../m2py"
Using python..

#Import "assets/multiply.py@/.."

' Remember that Python's print function is rarely visible in Ted2Go
' So make sure to run the actual executable and not via Ted!

' Example from:
' https://docs.python.org/3/extending/embedding.html#pure-embedding

Function Main()
	
	Global program := Py_DecodeLocale( "myProgram" )
	Py_SetProgramName( program )
	
	Local callFunc := "multiply" ' File to load & function to call
	Local funcParam := New Int[]( 3, 2 ) ' Parameters to pass the function
	
	Local pName:PyObject Ptr, pModule:PyObject Ptr, pFunc:PyObject Ptr
	Local pArgs:PyObject Ptr, pValue:PyObject Ptr
	Local i:Int
	
	Py_Initialize()
	
	pName = PyUnicode_DecodeFSDefault( callFunc )
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
			Print( "Cannot find function " + callFunc + " in ~q" + callFunc + ".py~q" )
			Sleep( 10 )
			
			Return
		Endif
		
		Py_XDECREF(pFunc)
		Py_DECREF(pModule)
	Else
		
		PyErr_Print()
		Print( "Failed to load script ~q" + callFunc + ".py~q" )
		Sleep( 10 )
		
		Return
	Endif
End