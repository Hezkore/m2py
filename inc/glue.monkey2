Namespace python

' Function for converting a string to a libc.const_char_t (CString)
' By abakobo
Function ToConstCharTPtr:libc.const_char_t Ptr( str:String )
	
	Local mydata := New DataBuffer( str.Utf8Length + 1 )
	str.ToCString( mydata.Data, mydata.Length )
	
	Return Cast <const_char_t Ptr>( mydata.Data )
End

Function ToCharTPtr:libc.char_t Ptr( str:String )
	
	Local mydata := New DataBuffer( str.Utf8Length + 1 )
	str.ToCString( mydata.Data, mydata.Length )
	
	Return Cast <char_t Ptr>( mydata.Data )
End

'Function PyMethod_DefMeth:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
'	
'	Print "No method function pointer"
'	
'	Return PyBool_FromLong( True )
'End

'Function PyModule_FromM2Class:PyModuleDef Ptr( className:String, moduleName:String )
'	
'	Local type := TypeInfo.GetType( className )
'	
'	If Not type Then
'		
'		RuntimeError( "Unable to get class ~q" + className + "~q" )
'		
'		Return Null
'	Endif
'	
'	If Not type.Kind = "Class" Then
'		
'		RuntimeError( "~q" + className + "~q is not a class" )
'		
'		Return Null
'	End
'	
'	Local nCM := New M2ClassModule
'	
'	nCM.PyMethods = New PyMethodDef[0]
'	
'	For Local decl := Eachin type.GetDecls()
'		
'		If decl.Kind = "Function" Then
'			
'			nCM.PyMethods = nCM.PyMethods.Resize( nCM.PyMethods.Length + 1 )
'			
'			nCM.PyMethods[nCM.PyMethods.Length-1].ml_name = ToConstCharTPtr( decl.Name )
'			nCM.PyMethods[nCM.PyMethods.Length-1].ml_meth = PyMethod_DefMeth
'			
'			
''			nCM.PyMethods[nCM.PyMethods.Length-1].ml_meth = Lambda:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
''				
''				Print "RESIZE!"
''				
''				Return PyBool_FromLong( True )
''			End
'			
'			nCM.PyMethods[nCM.PyMethods.Length-1].ml_flags = METH_VARARGS
'			nCM.PyMethods[nCM.PyMethods.Length-1].ml_doc = ToConstCharTPtr( "Monkey 2 Class Function" )
'		Endif
'	Next
'	
'	' Null terminated
'	nCM.PyMethods = nCM.PyMethods.Resize( nCM.PyMethods.Length + 1 )
'	
'	nCM.PyModule = New PyModuleDef
'	nCM.PyModule.m_base = PyModuleDef_HEAD_INIT
'	nCM.PyModule.m_name = ToConstCharTPtr( moduleName )
'	nCM.PyModule.m_doc = ToConstCharTPtr( "Monkey 2 Class" )
'	nCM.PyModule.m_size = -1
'	nCM.PyModule.m_methods = Varptr nCM.PyMethods[0]
'	
'	M2ClassModule.Modules.Add( nCM )
'	
'	Return Varptr nCM.PyModule
'End
'
'Class M2ClassModule
'	
'	Global Modules := New Stack<M2ClassModule>
'	
'	Field PyModule:PyModuleDef
'	Field PyMethods:PyMethodDef[]
'End