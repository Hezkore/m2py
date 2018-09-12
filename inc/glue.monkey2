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
