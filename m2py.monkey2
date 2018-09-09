Namespace python

' More info at:
' https://docs.python.org/3.7/c-api/index.html

#Import "<std>"
#Import "<libc>"
Using std..
Using libc..

#Import "Python-3.7.0\Include\Python.h"

#If __ARCH__="x86"
	#Import "Python-3.7.0\PCbuild\win32\python37.lib"
#Else
	#Import "Python-3.7.0\PCbuild\amd64\python37.lib"
#Endif

' Function for converting a string to a libc.const_char_t (CString)
' abakobo
Function ToConstCharTPtr:libc.const_char_t Ptr( str:String )
	
	Local mydata := New DataBuffer( str.Utf8Length + 1 )
	str.ToCString( mydata.Data, mydata.Length )
	
	Return Cast <const_char_t Ptr>( mydata.Data )
End

Extern
	
	Alias Py_ssize_t:libc.size_t
	
	' https://docs.python.org/3/c-api/structures.html#c.PyCFunction
	Alias PyCFunction:PyObject Ptr( this:PyObject Ptr, args:PyObject Ptr )
	
'	Alias visitproc:Int( o:PyObject Ptr, arg:Void )
'	Alias traverseproc:Int( this:PyObject Ptr, visit:visitproc, arg:Void )
'	Alias inquiry:Int( this:PyObject Ptr )
'	Alias freefunc:Void()
	
	' https://docs.python.org/3/c-api/structures.html#METH_VARARGS
	Global METH_VARARGS:Int
	Global METH_KEYWORDS:Int
	Global METH_NOARGS:Int
	Global METH_O:Int
	Global METH_CLASS:Int
	Global METH_STATIC:Int
	Global METH_COEXIST:Int
	
	Global PyModuleDef_HEAD_INIT:PyModuleDef_Base
	
	' https://docs.python.org/3/c-api/apiabiversion.html
	Global PY_VERSION:String
	Global PY_MAJOR_VERSION:Int
	Global PY_MINOR_VERSION:Int
	Global PY_MICRO_VERSION:Int
	Global PY_RELEASE_LEVEL:Int
	Global PY_RELEASE_SERIAL:Int
	
	' Initialization, Finalization, and Threads
	' https://docs.python.org/3/c-api/init.html#initialization-finalization-and-threads
	Function Py_Initialize:Void()
	'void Py_InitializeEx(int initsigs)
	'int Py_IsInitialized()
	Function Py_FinalizeEx:Int()
	'void Py_Finalize()
	'int Py_SetStandardStreamEncoding(const char *encoding, const char *errors)
	Function Py_SetProgramName:Void( program:WString )
	'wchar* Py_GetProgramName()
	'wchar_t* Py_GetPrefix()
	'wchar_t* Py_GetExecPrefix()
	'wchar_t* Py_GetProgramFullPath()
	'wchar_t* Py_GetPath()
	'void Py_SetPath(const wchar_t *)
	'const char* Py_GetVersion()
	'const char* Py_GetPlatform()
	'const char* Py_GetCopyright()
	'const char* Py_GetCompiler()
	'const char* Py_GetBuildInfo()
	'void PySys_SetArgvEx(int argc, wchar_t **argv, int updatepath)
	'void PySys_SetArgv(int argc, wchar_t **argv)
	'void Py_SetPythonHome(const wchar_t *home)
	'w_char* Py_GetPythonHome()
	
	' Operating System Utilities
	' https://docs.python.org/3/c-api/sys.html#operating-system-utilities
	'PyObject* PyOS_FSPath(PyObject *path)
	'int Py_FdIsInteractive(FILE *fp, const char *filename)
	'void PyOS_BeforeFork()
	'void PyOS_AfterFork_Parent()
	'void PyOS_AfterFork_Child()
	'void PyOS_AfterFork()
	'int PyOS_CheckStack()
	'PyOS_sighandler_t PyOS_getsig(int i)
	'PyOS_sighandler_t PyOS_setsig(int i, PyOS_sighandler_t h)
	Function Py_DecodeLocale:WString( arg:CString, size:Int = Null )
	'char* Py_EncodeLocale(const wchar_t *text, size_t *error_pos)
	'PyObject *PySys_GetObject(const char *name)
	'int PySys_SetObject(const char *name, PyObject *v)
	'void PySys_ResetWarnOptions()
	'void PySys_AddWarnOption(const wchar_t *s)
	'void PySys_AddWarnOptionUnicode(PyObject *unicode)
	'void PySys_SetPath(const wchar_t *path)
	'void PySys_WriteStdout(const char *format, ...)
	'void PySys_WriteStderr(const char *format, ...)
	'void PySys_FormatStdout(const char *format, ...)
	'void PySys_FormatStderr(const char *format, ...)
	'void PySys_AddXOption(const wchar_t *s)
	'PyObject *PySys_GetXOptions()
	'void Py_FatalError(const char *message)
	'void Py_Exit(int status)
	'int Py_AtExit(void (*func)())
	
	' The Very High Level Layer
	' https://docs.python.org/3/c-api/veryhigh.html#the-very-high-level-layer
	'int Py_Main(int argc, wchar_t **argv)
	'int PyRun_AnyFile(FILE *fp, const char *filename)
	'int PyRun_AnyFileFlags(FILE *fp, const char *filename, PyCompilerFlags *flags)
	'int PyRun_AnyFileEx(FILE *fp, const char *filename, int closeit)
	'int PyRun_AnyFileExFlags(FILE *fp, const char *filename, int closeit, PyCompilerFlags *flags)
	Function PyRun_SimpleString:Int( command:CString )
	'int PyRun_SimpleStringFlags(const char *command, PyCompilerFlags *flags)
	'int PyRun_SimpleFile(FILE *fp, const char *filename)
	'int PyRun_SimpleFileEx(FILE *fp, const char *filename, int closeit)
	'int PyRun_SimpleFileExFlags(FILE *fp, const char *filename, int closeit, PyCompilerFlags *flags)
	'int PyRun_InteractiveOne(FILE *fp, const char *filename)
	'int PyRun_InteractiveOneFlags(FILE *fp, const char *filename, PyCompilerFlags *flags)
	'int PyRun_InteractiveLoop(FILE *fp, const char *filename)
	'int PyRun_InteractiveLoopFlags(FILE *fp, const char *filename, PyCompilerFlags *flags)
	Global PyOS_InputHook:Int()
	Global PyOS_ReadlineFunctionPointer:char_t Ptr( in:FILE Ptr, out:FILE Ptr, prompt:const_char_t Ptr )
	'struct _node* PyParser_SimpleParseString(const char *str, int start)
	'struct _node* PyParser_SimpleParseStringFlags(const char *str, int start, int flags)
	'struct _node* PyParser_SimpleParseStringFlagsFilename(const char *str, const char *filename, int start, int flags)
	'struct _node* PyParser_SimpleParseFile(FILE *fp, const char *filename, int start)
	'struct _node* PyParser_SimpleParseFileFlags(FILE *fp, const char *filename, int start, int flags)
	'PyObject* PyRun_String(const char *str, int start, PyObject *globals, PyObject *locals)
	'PyObject* PyRun_StringFlags(const char *str, int start, PyObject *globals, PyObject *locals, PyCompilerFlags *flags)
	'PyObject* PyRun_File(FILE *fp, const char *filename, int start, PyObject *globals, PyObject *locals)
	' PyObject* PyRun_FileEx(FILE *fp, const char *filename, int start, PyObject *globals, PyObject *locals, int closeit)
	' PyObject* PyRun_FileFlags(FILE *fp, const char *filename, int start, PyObject *globals, PyObject *locals, PyCompilerFlags *flags)
	' PyObject* PyRun_FileExFlags(FILE *fp, const char *filename, int start, PyObject *globals, PyObject *locals, int closeit, PyCompilerFlags *flags)
	' PyObject* Py_CompileString(const char *str, const char *filename, int start)
	' PyObject* Py_CompileStringFlags(const char *str, const char *filename, int start, PyCompilerFlags *flags)
	' PyObject* Py_CompileStringObject(const char *str, PyObject *filename, int start, PyCompilerFlags *flags, int optimize)
	' PyObject* Py_CompileStringExFlags(const char *str, const char *filename, int start, PyCompilerFlags *flags, int optimize)
	' PyObject* PyEval_EvalCode(PyObject *co, PyObject *globals, PyObject *locals)
	' PyObject* PyEval_EvalCodeEx(PyObject *co, PyObject *globals, PyObject *locals, PyObject **args, int argcount, PyObject **kws, int kwcount, PyObject **defs, int defcount, PyObject *closure)
	' PyObject* PyEval_EvalFrame(PyFrameObject *f)
	' PyObject* PyEval_EvalFrameEx(PyFrameObject *f, int throwflag)
	'int PyEval_MergeCompilerFlags(PyCompilerFlags *cf)
	Global Py_eval_input:Int
	Global Py_file_input:Int
	Global Py_single_input:Int
	Global CO_FUTURE_DIVISION:Int
	
	' Memory Management
	' https://docs.python.org/3/c-api/memory.html#memory-management
	'void* PyMem_RawMalloc(size_t n)
	'void* PyMem_RawCalloc(size_t nelem, size_t elsize)
	'void* PyMem_RawRealloc(void *p, size_t n)
	Function PyMem_RawFree:Void( p:Void Ptr )
	'void* PyMem_Malloc(size_t n)
	'void* PyMem_Calloc(size_t nelem, size_t elsize)
	'void* PyMem_Realloc(void *p, size_t n)
	'void PyMem_Free(void *p)
	'TYPE* PyMem_New(TYPE, size_t n)
	'TYPE* PyMem_Resize(void *p, TYPE, size_t n)
	'void PyMem_Del(void *p)
	'void* PyObject_Malloc(size_t n)
	'void* PyObject_Calloc(size_t nelem, size_t elsize)
	'void* PyObject_Realloc(void *p, size_t n)
	'void PyObject_Free(void *p)
	'void PyMem_GetAllocator(PyMemAllocatorDomain domain, PyMemAllocatorEx *allocator)
	'void PyMem_SetAllocator(PyMemAllocatorDomain domain, PyMemAllocatorEx *allocator)
	'void PyMem_SetupDebugHooks(void)
	
	' File System Encoding
	' https://docs.python.org/3/c-api/unicode.html#file-system-encoding
	Function PyUnicode_DecodeFSDefault:PyObject Ptr( s:CString )
	
	' Importing Modules
	' https://docs.python.org/3/c-api/import.html#importing-modules
	Function PyImport_ImportModule:PyObject Ptr( name:CString )
	'PyObject* PyImport_ImportModuleNoBlock(const char *name)
	'PyObject* PyImport_ImportModuleEx(const char *name, PyObject *globals, PyObject *locals, PyObject *fromlist)
	'PyObject* PyImport_ImportModuleLevelObject(PyObject *name, PyObject *globals, PyObject *locals, PyObject *fromlist, int level)
	'PyObject* PyImport_ImportModuleLevel(const char *name, PyObject *globals, PyObject *locals, PyObject *fromlist, int level)
	Function PyImport_Import:PyObject Ptr( name:PyObject Ptr )
	'PyObject* PyImport_ReloadModule(PyObject *m)
	'PyObject* PyImport_AddModuleObject(PyObject *name)
	Function PyImport_AddModule:PyObject Ptr( name:CString )
	'PyObject* PyImport_ExecCodeModule(const char *name, PyObject *co)
	'PyObject* PyImport_ExecCodeModuleEx(const char *name, PyObject *co, const char *pathname)
	'PyObject* PyImport_ExecCodeModuleObject(PyObject *name, PyObject *co, PyObject *pathname, PyObject *cpathname)
	'PyObject* PyImport_ExecCodeModuleWithPathnames(const char *name, PyObject *co, const char *pathname, const char *cpathname)
	'long PyImport_GetMagicNumber()
	'const char * PyImport_GetMagicTag()
	'PyObject* PyImport_GetModuleDict()
	'PyObject* PyImport_GetModule(PyObject *name)
	'PyObject* PyImport_GetImporter(PyObject *path)
	'int PyImport_ImportFrozenModuleObject(PyObject *name)
	'int PyImport_ImportFrozenModule(const char *name)
	'const struct _frozen* PyImport_FrozenModules
	Function PyImport_AppendInittab:Int( name:libc.const_char_t Ptr, initfunc:PyObject Ptr() )
	'int PyImport_ExtendInittab(struct _inittab *newtab)
	
	' Reference Counting (Complete)
	' https://docs.python.org/3/c-api/refcounting.html#reference-counting
	Function Py_INCREF:Void( o:PyObject Ptr )
	Function Py_XINCREF:Void( o:PyObject Ptr )
	Function Py_DECREF:Void( o:PyObject Ptr )
	Function Py_XDECREF:Void( o:PyObject Ptr )
	Function Py_CLEAR:Void( o:PyObject Ptr )
	
	' Object Protocol
	' https://docs.python.org/3/c-api/object.html#object-protocol
	Function PyObject_GetAttrString:PyObject Ptr( o:PyObject Ptr, attr_name:CString )
	Function PyCallable_Check:Int( o:PyObject Ptr )
	Function PyObject_CallObject:PyObject Ptr( callable_object:PyObject Ptr, args:PyObject Ptr )
	Function PyObject_CallMethod:PyObject Ptr( o:PyObject Ptr, meth:CString, format:CString, par1:CString = Null, par2:CString = Null, par3:CString = Null, par4:CString = Null )
	 
	' Tuple Objects
	' https://docs.python.org/3/c-api/tuple.html#tuple-objects
	Function PyTuple_New:PyObject Ptr( len:Int )
	Function PyTuple_SetItem:Int( p:PyObject Ptr, pos:Int, o:PyObject Ptr )
	
	' Integer Objects
	' https://docs.python.org/3/c-api/long.html#integer-objects
	Function PyLong_FromLong:PyObject Ptr( v:Long )
	Function PyLong_AsLong:Long(obj:PyObject Ptr )
	
	' Exception Handling
	' https://docs.python.org/3/c-api/exceptions.html#exception-handling
	Function PyErr_Print()
	Function PyErr_Occurred:PyObject Ptr()
	
	' Parsing arguments and building values
	' https://docs.python.org/3/c-api/arg.html#parsing-arguments-and-building-values
	Function PyArg_ParseTuple:Int( args:PyObject Ptr, format:CString )
	
	' Module Objects
	' https://docs.python.org/3/c-api/module.html#module-objects
	Function PyModule_Create:PyObject Ptr( def:PyModuleDef Ptr )
	
	' Unicode Objects and Codecs
	' https://docs.python.org/3/c-api/unicode.html#unicode-objects-and-codecs
	Function PyUnicode_FromString:PyObject Ptr( str:CString )
	'Function PyUnicode_AsEncodedString:PyObject Ptr( unicode:PyObject Ptr, encoding:CString, errors:CString )
	Function PyBytes_AsString:CString( o:PyObject Ptr )
	
	' https://docs.python.org/3/c-api/module.html#initializing-c-modules
	Struct PyModuleDef
		
		Field m_base:PyModuleDef_Base ' Always PyModuleDef_HEAD_INIT ?
		Field m_name:libc.const_char_t Ptr
		Field m_doc:libc.const_char_t Ptr
		Field m_size:Py_ssize_t
		Field m_methods:PyMethodDef Ptr
'		Field m_slots:PyModuleDef_Slot Ptr
'		Field m_traverse:traverseproc
'		Field m_clear:inquiry
'		Field m_free:freefunc
	End
	
	Struct PyModuleDef_Base
		
'		Field m_init:PyObject(void)
'		Field m_index:Py_ssize_t
'		Field m_copy:PyObject
	End
	
	' https://docs.python.org/3/c-api/structures.html#c.PyMethodDef
	Struct PyMethodDef
		
		Field ml_name:libc.const_char_t Ptr
		Field ml_meth:PyCFunction
		Field ml_flags:Int
		Field ml_doc:libc.const_char_t Ptr
	End
	
'	Struct PyModuleDef_Slot
'		
'		Field slot:Int
'		Field value:Void Ptr
'	End
	
	' https://docs.python.org/3/c-api/structures.html#c.PyObject
	Struct PyObject
	End
	
	
	' https://docs.python.org/3/c-api/import.html#c._inittab
'	struct _inittab {
'	    const char *name;           /* ASCII encoded string */
'	    PyObject* (*initfunc)(void);
'	};
	
	' https://docs.python.org/3/c-api/import.html#c._frozen
'	struct _frozen {
'	    const char *name;
'	    const unsigned char *code;
'	    int size;
'	};
	
	' https://docs.python.org/3.4/c-api/veryhigh.html#c.PyCompilerFlags
'	struct PyCompilerFlags {
'	    int cf_flags;
'	}
Public