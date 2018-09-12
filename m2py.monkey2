Namespace python

' More info at:
' https://docs.python.org/3.7/c-api/index.html

#Import "<std>"
#Import "<libc>"
Using std..
Using libc..

#Import "inc/glue"
#Import "inc/extensions"

#Import "Python-3.7.0\Include\Python.h"

#If __ARCH__="x86"
	#Import "Python-3.7.0\PCbuild\win32\python37.lib"
#Else
	#Import "Python-3.7.0\PCbuild\amd64\python37.lib"
#Endif

' https://docs.python.org/3.7/c-api/arg.html#parsing-arguments-and-building-values
Enum PyFormat
	
	Str
	Str_BytesLike
	Str_ReadOnly_BytesLike
	Str_None
	Str_BytesLike_None
	Str_ReadOnly_BytesLike_None
End

Function FormatStr_FromPyFormat:String( f:PyFormat )
	
	Select f
		Case PyFormat.Str Return "s"
		Case PyFormat.Str_BytesLike Return "s*"
		Case PyFormat.Str_ReadOnly_BytesLike Return "s#"
		Case PyFormat.Str_None Return "z"
		Case PyFormat.Str_BytesLike_None Return "z*"
		Case PyFormat.Str_ReadOnly_BytesLike_None Return "z#"
	End
	
	RuntimeError( "Uknown PyFormat #" + Int( f ) )
	
	Return Null
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
	Global PyOS_ReadlineFunctionPointer:libc.char_t Ptr( in:FILE Ptr, out:FILE Ptr, prompt:libc.const_char_t Ptr )
	'struct _node* PyParser_SimpleParseString(const char *str, int start)
	'struct _node* PyParser_SimpleParseStringFlags(const char *str, int start, int flags)
	'struct _node* PyParser_SimpleParseStringFlagsFilename(const char *str, const char *filename, int start, int flags)
	'struct _node* PyParser_SimpleParseFile(FILE *fp, const char *filename, int start)
	'struct _node* PyParser_SimpleParseFileFlags(FILE *fp, const char *filename, int start, int flags)
	Function PyRun_String:PyObject Ptr( str:CString, start:Int, globals:PyObject Ptr, locals:PyObject Ptr)
	Function PyRun_StringFlags:PyObject Ptr( str:Cstring, start:Int, globals:PyObject Ptr, locals:PyObject Ptr, flags:PyCompilerFlags )
	'PyObject* PyRun_File(FILE *fp, const char *filename, int start, PyObject *globals, PyObject *locals)
	'PyObject* PyRun_FileEx(FILE *fp, const char *filename, int start, PyObject *globals, PyObject *locals, int closeit)
	'PyObject* PyRun_FileFlags(FILE *fp, const char *filename, int start, PyObject *globals, PyObject *locals, PyCompilerFlags *flags)
	'PyObject* PyRun_FileExFlags(FILE *fp, const char *filename, int start, PyObject *globals, PyObject *locals, int closeit, PyCompilerFlags *flags)
	'PyObject* Py_CompileString(const char *str, const char *filename, int start)
	'PyObject* Py_CompileStringFlags(const char *str, const char *filename, int start, PyCompilerFlags *flags)
	'PyObject* Py_CompileStringObject(const char *str, PyObject *filename, int start, PyCompilerFlags *flags, int optimize)
	'PyObject* Py_CompileStringExFlags(const char *str, const char *filename, int start, PyCompilerFlags *flags, int optimize)
	'PyObject* PyEval_EvalCode(PyObject *co, PyObject *globals, PyObject *locals)
	'PyObject* PyEval_EvalCodeEx(PyObject *co, PyObject *globals, PyObject *locals, PyObject **args, int argcount, PyObject **kws, int kwcount, PyObject **defs, int defcount, PyObject *closure)
	'PyObject* PyEval_EvalFrame(PyFrameObject *f)
	'PyObject* PyEval_EvalFrameEx(PyFrameObject *f, int throwflag)
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
	Function PyObject_SetAttrString:Int( o:PyObject Ptr, attr_name:CString, v:PyObject Ptr )
	Function PyCallable_Check:Int( o:PyObject Ptr )
	Function PyObject_CallObject:PyObject Ptr( callable_object:PyObject Ptr, args:PyObject Ptr )
	Function PyObject_CallMethod:PyObject Ptr( obj:PyObject Ptr, name:CString, format:CString, arg1:Void Ptr = Null, arg2:Void Ptr = Null, arg3:Void Ptr = Null, arg4:Void Ptr = Null, arg5:Void Ptr = Null, arg6:Void Ptr = Null, arg7:Void Ptr = Null, arg8:Void Ptr = Null, arg9:Void Ptr = Null, arg10:Void Ptr = Null )
	
	' Common Object Structures
	' https://docs.python.org/3/c-api/structures.html#common-object-structures
	Function Py_TYPE:PyTypeObject Ptr( o:PyObject Ptr )
	
	' Type Objects
	' https://docs.python.org/3/c-api/type.html#type-objects
	Function PyType_Check:Int( o:PyObject Ptr )
	
	' Tuple Objects
	' https://docs.python.org/3/c-api/tuple.html#tuple-objects
	Function PyTuple_Check:Int( p:PyObject Ptr )
	Function PyTuple_New:PyObject Ptr( len:Int )
	Function PyTuple_SetItem:Int( p:PyObject Ptr, pos:Int, o:PyObject Ptr )
	
	' Boolean Objects
	' https://docs.python.org/3/c-api/bool.html#boolean-objects
	Function PyBool_Check:Int( o:PyObject Ptr )
	Function Py_False:PyObject Ptr()
	Function Py_True:PyObject Ptr()
	'Py_RETURN_FALSE
	'Py_RETURN_TRUE
	Function PyBool_FromLong:PyObject Ptr( v:Long )
	
	' Integer Objects
	' https://docs.python.org/3/c-api/long.html#integer-objects
	Function PyLong_Check:Int( p:PyObject Ptr )
	Function PyLong_FromLong:PyObject Ptr( v:Long )
	Function PyLong_AsLong:Long(obj:PyObject Ptr )
	
	' Floating Point Objects
	' https://docs.python.org/3/c-api/float.html#floating-point-objects
	Function PyFloat_Check:Int( p:PyObject Ptr )
	
	' Bytes Objects
	' https://docs.python.org/3/c-api/bytes.html#bytes-objects
	Function PyBytes_AsString:CString( o:PyObject Ptr )
	Function PyBytes_Check:Int( o:PyObject Ptr )
	Function PyBytes_FromString:PyObject Ptr( v:libc.const_char_t Ptr )
	
	' Byte Array Objects
	' https://docs.python.org/3/c-api/bytearray.html#byte-array-objects
	Function PyByteArray_Check:Int( o:PyObject Ptr )
	
	' Dictionary Objects
	' https://docs.python.org/3/c-api/dict.html#dictionary-objects
	Function PyDict_Check:Int( p:PyObject Ptr )
	
	' Set Objects
	' https://docs.python.org/3/c-api/set.html#set-objects
	Function PySet_Check:Int( p:PyObject Ptr )
	Function PyAnySet_Check:Int( p:PyObject Ptr )
	
	' Function Objects
	' https://docs.python.org/3/c-api/function.html#function-objects
	Function PyFunction_Check:Int( o:PyObject Ptr )
	
	' Instance Method Objects
	' https://docs.python.org/3/c-api/method.html#instance-method-objects
	Function PyInstanceMethod_Check:Int( o:PyObject Ptr )
	
	' Method Objects
	' https://docs.python.org/3/c-api/method.html#method-objects
	Function PyMethod_Check:Int( o:PyObject Ptr )
	
	' Cell Objects
	' https://docs.python.org/3/c-api/cell.html#cell-objects
	Function PyCell_Check:Int( ob:PyObject Ptr )
	
	' Code Objects
	' https://docs.python.org/3/c-api/code.html#code-objects
	Function PyCode_Check:Int( co:PyObject Ptr )
	
	' Iterator Objects
	' https://docs.python.org/3/c-api/iterator.html#iterator-objects
	Function PyCallIter_Check:Int( op:PyObject Ptr )
	
	' Slice Objects
	' https://docs.python.org/3/c-api/slice.html#slice-objects
	Function PySlice_Check:Int( ob:PyObject Ptr )
	
	' MemoryView objects
	' https://docs.python.org/3/c-api/memoryview.html#index-0
	Function PyMemoryView_Check:Int( obj:PyObject Ptr )
	
	' Weak Reference Objects
	' https://docs.python.org/3/c-api/weakref.html#weak-reference-objects
	Function PyWeakref_Check:Int( ob:PyObject Ptr )
	Function PyWeakref_CheckRef:Int( ob:PyObject Ptr )
	Function PyWeakref_CheckProxy:Int( ob:PyObject Ptr )
	
	' Capsules
	' https://docs.python.org/3/c-api/capsule.html#capsules
	Function PyCapsule_CheckExact:Int( p:PyObject Ptr )
	
	' Generator Objects
	' https://docs.python.org/3/c-api/gen.html#generator-objects
	Function PyGen_Check:Int( ob:PyObject Ptr )
	
	' Coroutine Objects
	' https://docs.python.org/3/c-api/coro.html#coroutine-objects
	Function PyCoro_CheckExact:Int( ob:PyObject Ptr )
	
	' File Objects (Complete)
	' https://docs.python.org/3.3/c-api/file.html#file-objects
	Function PyFile_FromFd( fd:Int, name:CString , mode:CString, buffering:Int, encoding:CString, errors:CString, newline:CString, closefd:Int )
	Function PyObject_AsFileDescriptor:Int( p:PyObject Ptr )
	Function PyFile_GetLine:PyObject Ptr( p:PyObject Ptr, n:Int )
	Function PyFile_WriteObject:Int( obj:PyObject Ptr, p:PyObject Ptr, flags:Int )
	Function PyFile_WriteString:Int( s:CString, p:PyObject Ptr )
	
	' Context Variables Objects
	' https://docs.python.org/3/c-api/contextvars.html#context-variables-objects
	' (Does not seem to work?)
'	Function PyContext_CheckExact:Int( o:PyObject Ptr )
'	Function PyContextVar_CheckExact:Int( o:PyObject Ptr )
'	Function PyContextToken_CheckExact:Int( o:PyObject Ptr )
	
	' DateTime Objects
	' https://docs.python.org/3/c-api/datetime.html#datetime-objects
'	Function PyDate_Check:Int( ob:PyObject Ptr )
'	Function PyDate_CheckExact:Int( ob:PyObject Ptr )
'	Function PyDateTime_Check:Int( ob:PyObject Ptr )
'	Function PyDateTime_CheckExact:Int( ob:PyObject Ptr )
'	Function PyTime_Check:Int( ob:PyObject Ptr )
'	Function PyTime_CheckExact:Int( ob:PyObject Ptr )
'	Function PyDelta_Check:Int( ob:PyObject Ptr )
'	Function PyDelta_CheckExact:Int( ob:PyObject Ptr )
'	Function PyTZInfo_Check:Int( ob:PyObject Ptr )
'	Function PyTZInfo_CheckExact:Int( ob:PyObject Ptr )
	
	' Exception Handling
	' https://docs.python.org/3/c-api/exceptions.html#exception-handling
	Global PyExc_BaseException:PyObject Ptr
	Global PyExc_Exception:PyObject Ptr
	Global PyExc_ArithmeticError:PyObject Ptr
	Global PyExc_AssertionError:PyObject Ptr
	Global PyExc_AttributeError:PyObject Ptr
	Global PyExc_BlockingIOError:PyObject Ptr
	Global PyExc_BrokenPipeError:PyObject Ptr
	Global PyExc_BufferError:PyObject Ptr
	Global PyExc_ChildProcessError:PyObject Ptr
	Global PyExc_ConnectionAbortedError:PyObject Ptr
	Global PyExc_ConnectionError:PyObject Ptr
	Global PyExc_ConnectionRefusedError:PyObject Ptr
	Global PyExc_ConnectionResetError:PyObject Ptr
	Global PyExc_EOFError:PyObject Ptr
	Global PyExc_FileExistsError:PyObject Ptr
	Global PyExc_FileNotFoundError:PyObject Ptr
	Global PyExc_FloatingPointError:PyObject Ptr
	Global PyExc_GeneratorExit:PyObject Ptr
	Global PyExc_ImportError:PyObject Ptr
	Global PyExc_IndentationError:PyObject Ptr
	Global PyExc_IndexError:PyObject Ptr
	Global PyExc_InterruptedError:PyObject Ptr
	Global PyExc_IsADirectoryError:PyObject Ptr
	Global PyExc_KeyError:PyObject Ptr
	Global PyExc_KeyboardInterrupt:PyObject Ptr
	Global PyExc_LookupError:PyObject Ptr
	Global PyExc_MemoryError:PyObject Ptr
	Global PyExc_ModuleNotFoundError:PyObject Ptr
	Global PyExc_NameError:PyObject Ptr
	Global PyExc_NotADirectoryError:PyObject Ptr
	Global PyExc_NotImplementedError:PyObject Ptr
	Global PyExc_OSError:PyObject Ptr
	Global PyExc_OverflowError:PyObject Ptr
	Global PyExc_PermissionError:PyObject Ptr
	Global PyExc_ProcessLookupError:PyObject Ptr
	Global PyExc_RecursionError:PyObject Ptr
	Global PyExc_ReferenceError:PyObject Ptr
	Global PyExc_RuntimeError:PyObject Ptr
	Global PyExc_StopAsyncIteration:PyObject Ptr
	Global PyExc_StopIteration:PyObject Ptr
	Global PyExc_SyntaxError:PyObject Ptr
	Global PyExc_SystemError:PyObject Ptr
	Global PyExc_SystemExit:PyObject Ptr
	Global PyExc_TabError:PyObject Ptr
	Global PyExc_TimeoutError:PyObject Ptr
	Global PyExc_TypeError:PyObject Ptr
	Global PyExc_UnboundLocalError:PyObject Ptr
	Global PyExc_UnicodeDecodeError:PyObject Ptr
	Global PyExc_UnicodeEncodeError:PyObject Ptr
	Global PyExc_UnicodeError:PyObject Ptr
	Global PyExc_UnicodeTranslateError:PyObject Ptr
	Global PyExc_ValueError:PyObject Ptr
	Global PyExc_ZeroDivisionError:PyObject Ptr

	Function PyErr_Print()
	Function PyErr_Occurred:PyObject Ptr()
	Function PyErr_SetFromErrno:PyObject Ptr( type:PyObject Ptr )
	
	' Parsing arguments and building values
	' https://docs.python.org/3/c-api/arg.html#parsing-arguments-and-building-values
	Function PyArg_ParseTuple:Int( args:PyObject Ptr, format:CString, arg1:Void Ptr = Null, arg2:Void Ptr = Null, arg3:Void Ptr = Null, arg4:Void Ptr = Null, arg5:Void Ptr = Null, arg6:Void Ptr = Null, arg7:Void Ptr = Null, arg8:Void Ptr = Null, arg9:Void Ptr = Null, arg10:Void Ptr = Null )
	
	' Module Objects
	' https://docs.python.org/3/c-api/module.html#module-objects
	Function PyModule_Check:Int( p:PyObject Ptr )
	Function PyModule_Create:PyObject Ptr( def:PyModuleDef Ptr )
	Function PyModule_GetDict:PyObject Ptr( module:PyObject Ptr )
	Function PyModule_GetDef:PyModuleDef Ptr( module:PyObject Ptr )
	
	' Unicode Objects and Codecs
	' https://docs.python.org/3/c-api/unicode.html#unicode-objects-and-codecs
	Function PyUnicode_Check:Int( o:PyObject Ptr )
	Function PyUnicode_FromString:PyObject Ptr( str:CString )
	Function PyUnicode_AsEncodedString:PyObject Ptr( unicode:PyObject Ptr, encoding:CString = "UTF-8", errors:CString = "strict" )
	
	' List Objects
	' https://docs.python.org/3/c-api/list.html#list-objects
	Function PyList_Check:Int( p: PyObject Ptr )
	
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
	
	' https://docs.python.org/3/c-api/structures.html#c.PyMemberDef
	Struct PyMemberDef
		
		Field name:CString ' name of the member
		Field type:Int ' the type of the member in the C struct
		Field offset:Py_ssize_t ' the offset in bytes that the member is located on the type’s object struct
		Field flags:Int ' flag bits indicating if the field should be read-only or writable
		Field doc:CString ' points to the contents of the docstring
	End
	
	' https://docs.python.org/3/c-api/type.html#c.PyTypeObject
	Struct PyTypeObject
		
'	    PyObject_VAR_HEAD
		Field tp_name:CString ' For printing, in format "<module>.<name>" */
'	    Py_ssize_t tp_basicsize, tp_itemsize; /* For allocation */
'
'	    /* Methods to implement standard operations */
'
'	    destructor tp_dealloc;
'	    printfunc tp_print;
'	    getattrfunc tp_getattr;
'	    setattrfunc tp_setattr;
'	    PyAsyncMethods *tp_as_async; /* formerly known as tp_compare (Python 2)
'	                                    or tp_reserved (Python 3) */
'	    reprfunc tp_repr;
'
'	    /* Method suites for standard classes */
'
'	    PyNumberMethods *tp_as_number;
'	    PySequenceMethods *tp_as_sequence;
'	    PyMappingMethods *tp_as_mapping;
'
'	    /* More standard operations (here for binary compatibility) */
'
'	    hashfunc tp_hash;
'	    ternaryfunc tp_call;
'	    reprfunc tp_str;
'	    getattrofunc tp_getattro;
'	    setattrofunc tp_setattro;
'
'	    /* Functions to access object as input/output buffer */
'	    PyBufferProcs *tp_as_buffer;
'
'	    /* Flags to define presence of optional/expanded features */
'	    unsigned long tp_flags;
'
'	    const char *tp_doc; /* Documentation string */
'
'	    /* call function for all accessible objects */
'	    traverseproc tp_traverse;
'
'	    /* delete references to contained objects */
'	    inquiry tp_clear;
'
'	    /* rich comparisons */
'	    richcmpfunc tp_richcompare;
'
'	    /* weak reference enabler */
'	    Py_ssize_t tp_weaklistoffset;
'
'	    /* Iterators */
'	    getiterfunc tp_iter;
'	    iternextfunc tp_iternext;
'
'	    /* Attribute descriptor and subclassing stuff */
		Field tp_methods:PyMethodDef Ptr
		Field tp_members:PyMemberDef Ptr
'	    struct PyGetSetDef *tp_getset;
'	    struct _typeobject *tp_base;
		Field tp_dict:PyObject Ptr
'	    descrgetfunc tp_descr_get;
'	    descrsetfunc tp_descr_set;
'	    Py_ssize_t tp_dictoffset;
'	    initproc tp_init;
'	    allocfunc tp_alloc;
'	    newfunc tp_new;
'	    freefunc tp_free; /* Low-level free-memory routine */
'	    inquiry tp_is_gc; /* For PyObject_IS_GC */
'	    PyObject *tp_bases;
'	    PyObject *tp_mro; /* method resolution order */
'	    PyObject *tp_cache;
		Field tp_subclasses:PyObject Ptr
		Field tp_weaklist:PyObject Ptr
'	    destructor tp_del;
'
'	    /* Type attribute cache version tag. Added in version 2.6 */
'	    unsigned int tp_version_tag;
'
'	    destructor tp_finalize;
	End
	
	' https://docs.python.org/3/c-api/veryhigh.html#c.PyCompilerFlags
	Struct PyCompilerFlags
		
		Field cf_flags:Int
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
Public