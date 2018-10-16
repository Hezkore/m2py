#Import "<std>"
Using std..

#Import "../m2py"
Using python..

Function Main()
	
	Local program := Py_DecodeLocale( AppArgs()[0] , Null )
	If Not program Then
		
		Print "Fatal error: cannot decode " + AppArgs()[0]
		Return
	Endif
	
	Py_SetProgramName( program )
	Py_Initialize()
	
	Local script := "import mymodule~nprint( mymodule.test() )~nprint( mymodule.test2() )"
	
	Print "Executing script:~n" + script
	Print "~nResult:"
	PyRun_SimpleString( script )
	
	Py_FinalizeEx()
	
	Sleep( 20 )
	
	PyMem_RawFree( Varptr program )
End

Class MySimpleModule Extends M2Py_SimpleModule
	
	Global Instance := New MySimpleModule
	
	Method New()
		
		Super.New( "mymodule" )
		
		AddFunction( "test", Test )
		AddFunction( "test2", Test2 )
		
		Append( Init )
	End
	
	Function Init:PyObject Ptr() Override
		
		Return PyModule_Create( Varptr Instance.Module )
	End
	
	Function Test:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
		
		Print "Simple modules are simple"
		
		Return PyUnicode_FromString( "Simple stuff!" )
	End
	
	Function Test2:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
		
		Print "Easy peasy"
		
		Return PyUnicode_FromString( "Yep yep" )
	End
End