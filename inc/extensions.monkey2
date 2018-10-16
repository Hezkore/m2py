Namespace python

Function M2Py_Initialize( stdOutFunc:Void( text:String ), stdErrFunc:Void( text:String ) )
	
	M2Py_StdOutFunc = stdOutFunc
	M2Py_StdErrFunc = stdErrFunc
	
	PyImport_AppendInittab( ToConstCharTPtr( "__monkey2__" ), M2PyInit_monkey2 )
	
	Py_Initialize()
	
	M2Py_RedirectStd()
End

Function M2Py_SetSysPath( paths:String )
	
	paths = paths.Replace( "/", "\" )
	
	PySys_SetPath( paths )
End

Function M2Py_AppendPath( paths:String )
	
	paths = paths.Replace( "/", "\" )
	
	Local sys := PyImport_ImportModule( "sys" )
	
	Local path := PyObject_GetAttrString( sys, "path" )
	
	Local newPaths := PyUnicode_Split( PyUnicode_FromWideChar( paths, -1 ), PyUnicode_FromWideChar( ":", 1 ), -1 )
	
	For Local i:Int=0 Until PyList_Size( newPaths )
		
		PyList_Append( path, PyList_GetItem( newPaths, i ) )
	Next
End

Function M2Py_GetSysPath:String()
	
	Local sys := PyImport_ImportModule( "sys" )
	
	Local path := PyObject_GetAttrString( sys, "path" )
	
	Local newlist := PyUnicode_Join( PyUnicode_FromWideChar( ":", -1 ), path )
	
	Return PyUnicode_AsWideCharString( newlist, Null )
End

Class M2Py_SimpleModule
	
	Field Name:String
	Field Module:PyModuleDef
	Field Methods:PyMethodDef[]
	
	Method New( moduleName:String )
		
		Name = moduleName
		
		Methods = New PyMethodDef[1]
		
		Module = New PyModuleDef
		Module.m_base = PyModuleDef_HEAD_INIT
		Module.m_name = ToConstCharTPtr( Name )
		Module.m_doc = ToConstCharTPtr( "Simple Class Module" )
		Module.m_size = -1
	End
	
	Function Init:PyObject Ptr() Virtual
		
		RuntimeError( "Please create your own Init function" )
		
		Return Null
	End
	
	Method Append( func:PyObject Ptr() )
		
		PyImport_AppendInittab( ToConstCharTPtr( Name ), func )
	End
	
	Method AddFunction( funcName:String, funcPtr:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr ) )
		
		Methods = Methods.Resize( Methods.Length + 1 )
		
		Methods[Methods.Length-2].ml_name = ToConstCharTPtr( funcName )
		Methods[Methods.Length-2].ml_meth = funcPtr
		Methods[Methods.Length-2].ml_flags = METH_VARARGS
		Methods[Methods.Length-2].ml_doc = ToConstCharTPtr( "Simple Class Function" )
		
		Module.m_methods = Varptr Methods[0]
	End
End

Private
	
	Global M2Py_StdOutFunc:Void( text:String )
	Global M2Py_StdErrFunc:Void( text:String )
	
	Function M2Py_RedirectStd( moduleName:String = "__monkey2__", stdoutFunc:String = "print", stderrFunc:String = "error" )
		
		PyRun_SimpleString( "import sys, " + moduleName + "
		~nclass CatchStdout:
		~n~tdef write(self, txt):
		~n~t~t" + moduleName + "." + stdoutFunc + "(txt)
		~n~tdef flush(self):
		~n~t~tpass
		~nclass CatchStderr:
		~n~tdef write(self, txt):
		~n~t~t" + moduleName + "." + stderrFunc + "(txt)
		~n~tdef flush(self):
		~n~t~tpass
		~nCatchStdout = CatchStdout()
		~nCatchStderr = CatchStderr()
		~nsys.stdout = CatchStdout
		~nsys.stderr = CatchStderr" )
	End
	
	Function M2PyInit_monkey2:PyObject Ptr()
		
		' Create methods array
		' VERY IMPORTANT!!
		' ALWAYS END WITH AN EMPTY SLOT IN THE ARRAY!!
		Global Monkey2Methods := New PyMethodDef[3]
		
		' Print method
		Monkey2Methods[0].ml_name = ToConstCharTPtr( "print" )
		Monkey2Methods[0].ml_meth = monkey2_print
		Monkey2Methods[0].ml_flags = METH_O
		Monkey2Methods[0].ml_doc = ToConstCharTPtr( "Print to Monkey 2" )
		
		' Error method
		Monkey2Methods[1].ml_name = ToConstCharTPtr( "error" )
		Monkey2Methods[1].ml_meth = monkey2_error
		Monkey2Methods[1].ml_flags = METH_O
		Monkey2Methods[1].ml_doc = ToConstCharTPtr( "Print Error to Monkey 2" )
		
		' Our own module called __monkey2__
		Global Monkey2Module := New PyModuleDef
		Monkey2Module.m_base = PyModuleDef_HEAD_INIT
		Monkey2Module.m_name = ToConstCharTPtr( "__monkey2__" )
		Monkey2Module.m_doc = ToConstCharTPtr( "Monkey 2 internal" )
		Monkey2Module.m_size = -1
		Monkey2Module.m_methods = Varptr Monkey2Methods[0]
		
		' Return PyObject containing module and methods
		Return PyModule_Create( Varptr Monkey2Module )
	End
	
	Function monkey2_print:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
		
		If Not args Then Return PyErr_SetFromErrno( PyExc_Exception )
		
		Local temp_bytes := PyUnicode_AsEncodedString( args )
		
		If Not PyBytes_Check( temp_bytes ) Then Return PyErr_SetFromErrno( PyExc_Exception )
		
		M2Py_StdOutFunc( PyBytes_AsString( temp_bytes ) )
		
		Return temp_bytes
	End
	
	Function monkey2_error:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
		
		If Not args Then Return PyErr_SetFromErrno( PyExc_Exception )
		
		Local temp_bytes := PyUnicode_AsEncodedString( args )
		
		If Not PyBytes_Check( temp_bytes ) Then Return PyErr_SetFromErrno( PyExc_Exception )
		
		M2Py_StdErrFunc( PyBytes_AsString( temp_bytes ) )
		
		Return temp_bytes
	End
