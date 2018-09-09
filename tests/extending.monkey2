#Import "<std>"
Using std..

#Import "../m2py"
Using python..

#Import "assets/extending.py@/.."

' Remember that Python's print function is rarely visible in Ted2Go
' So make sure to run the actual executable and not via Ted!

' Example is the same as 'Pure Embedding' but with our own added module and methods
' https://docs.python.org/3/extending/embedding.html#extending-embedded-python

' Our first own method
Function m2_first:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
	
	Print "Called our first function!"
	
	Return PyUnicode_FromString( "first Monkey 2 function" )
End

' Our second own method
Function m2_second:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
	
	Print "And second one!"
	
	Return PyUnicode_FromString( "second Monkey 2 function" )
End

Function PyInit_m2:PyObject Ptr()
	
	' Create methods array
	' VERY IMPORTANT!!
	' ALWAYS END WITH AN EMPTY SLOT IN THE ARRAY!!
	Global EmbMethods := New PyMethodDef[3]
	
	' First method
	EmbMethods[0].ml_name = ToConstCharTPtr( "first" )
	EmbMethods[0].ml_meth = m2_first
	EmbMethods[0].ml_flags = METH_VARARGS
	EmbMethods[0].ml_doc = ToConstCharTPtr( "No documentation" )
	
	' Second method
	EmbMethods[1].ml_name = ToConstCharTPtr( "second" ) ' null terminated
	EmbMethods[1].ml_meth = m2_second
	EmbMethods[1].ml_flags = METH_VARARGS
	EmbMethods[1].ml_doc = ToConstCharTPtr( "No documentation" )
	
	' Our own module called M2
	Global EmbModule := New PyModuleDef
	EmbModule.m_base = PyModuleDef_HEAD_INIT
	EmbModule.m_name = ToConstCharTPtr( "monkey2" ) ' Does not seem to be null terminated?
	EmbModule.m_doc = ToConstCharTPtr( "No documentation" )
	EmbModule.m_size = -1
	EmbModule.m_methods = Varptr EmbMethods[0] ' Pass our array as methods
	
	' Return PyObject containing module and methods
	Return PyModule_Create( Varptr EmbModule )
End

Function Main()
	
	Global program := "myProgram"
	Py_SetProgramName( program )
	
	Local file := "extending" ' File to load
	Local callFunc := "multiply" ' Function to call ( and always our new own )
	Local funcParam := New Int[]( 3, 2 ) ' Parameters to pass the function
	
	Local pName:PyObject Ptr, pModule:PyObject Ptr, pFunc:PyObject Ptr
	Local pArgs:PyObject Ptr, pValue:PyObject Ptr
	Local i:Int
	
	' Tell Python what function to call when importing "monkey2"
	' (our function with module and methods)
	PyImport_AppendInittab( ToConstCharTPtr( "monkey2" ), PyInit_m2 )
	
	' The rest is pretty much the same as the 'Pure Embedding' example
	Py_Initialize()
	
	
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