Namespace python

Function Py_Initialize( stdOutFunc:Void( text:String ), stdErrFunc:Void( text:String ) )
	
	Py_StdOutFunc = stdOutFunc
	Py_StdErrFunc = stdErrFunc
	
	PyImport_AppendInittab( ToConstCharTPtr( "__monkey2__" ), PyInit_monkey2 )
	
	Py_Initialize()
	
	Py_RedirectStd()
End

Private
	
	Global Py_StdOutFunc:Void( text:String )
	Global Py_StdErrFunc:Void( text:String )
	
	Function Py_RedirectStd( moduleName:String = "__monkey2__", stdoutFunc:String = "print", stderrFunc:String = "error" )
		
		PyRun_SimpleString( "import sys, " + moduleName + "
		~nclass CatchStdout:
		~n~tdef write(self, txt):
		~n~t~t" + moduleName + "." + stdoutFunc + "(txt)
		~n~tdef flush(self):
		~n~t~t" + moduleName + "." + stdoutFunc + "('')
		~nclass CatchStderr:
		~n~tdef write(self, txt):
		~n~t~t" + moduleName + "." + stderrFunc + "(txt)
		~n~tdef flush(self):
		~n~t~t" + moduleName + "." + stdoutFunc + "('')
		~nCatchStdout = CatchStdout()
		~nCatchStderr = CatchStderr()
		~nsys.stdout = CatchStdout
		~nsys.stderr = CatchStderr" )
	End
	
	Function PyInit_monkey2:PyObject Ptr()
		
		' Create methods array
		' VERY IMPORTANT!!
		' ALWAYS END WITH AN EMPTY SLOT IN THE ARRAY!!
		Global Monkey2Methods := New PyMethodDef[3]
		
		' First method
		Monkey2Methods[0].ml_name = ToConstCharTPtr( "print" )
		Monkey2Methods[0].ml_meth = monkey2_print
		Monkey2Methods[0].ml_flags = METH_O
		Monkey2Methods[0].ml_doc = ToConstCharTPtr( "Print to Monkey 2" )
		
		' Second method
		Monkey2Methods[1].ml_name = ToConstCharTPtr( "error" )
		Monkey2Methods[1].ml_meth = monkey2_error
		Monkey2Methods[1].ml_flags = METH_O
		Monkey2Methods[1].ml_doc = ToConstCharTPtr( "Print Error to Monkey 2" )
		
		' Our own module called M2
		Global Monkey2Module := New PyModuleDef
		Monkey2Module.m_base = PyModuleDef_HEAD_INIT
		Monkey2Module.m_name = ToConstCharTPtr( "__monkey2__" )
		Monkey2Module.m_doc = ToConstCharTPtr( "Monkey 2 internal" )
		Monkey2Module.m_size = -1
		Monkey2Module.m_methods = Varptr Monkey2Methods[0]
		
		' Return PyObject containing module and methods
		Return PyModule_Create( Varptr Monkey2Module )
	End
	
	' Our first own method
	Function monkey2_print:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
		
		If Not args Then Return PyErr_SetFromErrno( PyExc_Exception )
		
		Local temp_bytes := PyUnicode_AsEncodedString( args )
		
		If Not PyBytes_Check( temp_bytes ) Then Return PyErr_SetFromErrno( PyExc_Exception )
		
		Py_StdOutFunc( PyBytes_AsString( temp_bytes ) )
		
		Return temp_bytes
	End
	
	' Our second own method
	Function monkey2_error:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
		
		If Not args Then Return PyErr_SetFromErrno( PyExc_Exception )
		
		Local temp_bytes := PyUnicode_AsEncodedString( args )
		
		If Not PyBytes_Check( temp_bytes ) Then Return PyErr_SetFromErrno( PyExc_Exception )
		
		Py_StdErrFunc( PyBytes_AsString( temp_bytes ) )
		
		Return temp_bytes
	End
