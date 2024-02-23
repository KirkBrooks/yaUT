/*  FullTest class
 Created by: Kirk as Designer, Created: 12/30/23, 08:05:35
 ------------------
√ Manages collecting test methods from the database
√ Running a collection of test methods
Logging results
Display results in Browser or 4D Form

*/

Class constructor($ident : Text)
	This.ident:=$ident  //  optional string for identifying a Full Test
	This._ms:=0
	This._error:=""
	
	This._timestamp:=String(Current date; ISO date; Current time)
	This.methodPrefix:="yaUT_"
	This._testMethods:=[]
	This._pass:=False
	This._isRun:=False
	This._countTests:=0
	This._countPass:=0
	This._countFail:=0
	This._countErr:=0
	
	//mark:  --- getters
Function get pass : Boolean
	return This._pass
	
Function get isRun : Boolean
	return This._isRun
	
Function get ms : Integer
	return This._ms
	
Function get isErr : Boolean
	return Bool(This._error#"")
	
Function get error : Text
	return This._error
	
Function get countTests : Integer
	return This._countTests
	
Function get countPass : Integer
	return This._countPass
	
Function get countFail : Integer
	return This._countFail
	
Function get countErr : Integer
	return This._countErr
	
Function get logPath : Text
	return This._logPath#Null ? This._logPath : ""
	
	//mark:  --- functions
Function getTestMethods($methodPrefix : Text) : cs.FullTest
/*  Creates a list of unit test method. Methods are identified by the 
methodPrefix. If run from a component looks in the Host for methods. 
The method should return a collection of test classes.
*/
	ARRAY TEXT($aPaths; 0)
	var $i : Integer
	var $col : Collection
	
	This.methodPrefix:=$methodPrefix="" ? This.methodPrefix : $methodPrefix
	$methodPrefix:=This.methodPrefix+"@"
	
	METHOD GET PATHS(Path project method; $aPaths; *)
	SORT ARRAY($aPaths; >)
	$col:=[]
	
	//  put each test method into the TestMethod class
	For ($i; 1; Size of array($aPaths))
		Case of 
			: ($aPaths{$i}="yaUT__@") || ($aPaths{$i}="yaUT_FullTest")
				//  reserved names
			: ($aPaths{$i}=$methodPrefix)
				$col.push(cs.TestMethod.new($aPaths{$i}))
		End case 
	End for 
	
	This._testMethods:=$col
	return This
	
Function run() : cs.FullTest
	var $testObj : cs.TestMethod
	
	This._ms:=Milliseconds*-1
	This._isRun:=True
	This._pass:=True
	This._countTests:=0
	This._countPass:=0
	This._countFail:=0
	This._countErr:=0
	
	For each ($testObj; This._testMethods)
		$testObj.run()  //  only runs if .selected is true
		This._pass:=This._pass && ($testObj.pass)
		This._countTests+=$testObj.countTests
		This._countPass+=$testObj.countPass
		This._countFail+=$testObj.countFail
		This._countErr+=$testObj._countErr
		
	End for each 
	
	This._ms+=Milliseconds
	
	return This
	
Function logResults($file : 4D.File) : cs.FullTest
	// write the results to $file
	// default is to use timestamp in Logs folder
	var $fHandle : 4D.FileHandle
	var $testObj : cs.TestMethod
	
	$file:=$file || This._defaultLogFile()
	This._logPath:=$file.platformPath
	
	$fHandle:=$file.open("append")
	
	$fHandle.writeLine("Unit Test Log: "+File(Structure file; fk platform path).path)
	$fHandle.writeLine("Machine: "+Current machine)
	$fHandle.writeLine("User: "+Current user)
	$fHandle.writeLine("Elapsed: "+String(This.ms/1000; "###,###,###,##0.00")+" secs")
	$fHandle.writeLine("Compiled: "+String(Is compiled mode))
	$fHandle.writeLine("Mode: "+String(Application type))
	$fHandle:=Null
	
	For each ($testObj; This._testMethods)
		$testObj.writeToLog($file.path)
	End for each 
	
	return This
	
Function testMethods : Collection
	return This._testMethods
	
Function getFullResults->$results : Collection
	// return a collection of all results
	var $testObj : cs.TestMethod
	
	$results:=[]
	For each ($testObj; This._testMethods)
		$results.combine($testObj.getFullResults())
	End for each 
	
Function selectAll : cs.FullTest
	This._setMethodSelect("@"; True)
	return This
	
Function deSelectAll : cs.FullTest
	This._setMethodSelect("@"; False)
	return This
	
Function selectMethod($methodName : Text) : cs.FullTest
	This._setMethodSelect($methodName; True)
	return This
	
Function deSelectMethod($methodName : Text) : cs.FullTest
	This._setMethodSelect($methodName; False)
	return This
	
	//mark:  ---  private
Function _defaultLogFile : 4D.File
	//  default is in Logs/yaut/<file>
	var $fileName; $text : Text
	$fileName:="yaut_"+Replace string(This._timestamp; ":"; "-")+".txt"  // can't have colons in the file path
	return Folder(Folder(fk logs folder; *).platformPath; fk platform path).folder("yaut").file($fileName)  //  Folder(Folder ...  trick to convert the path to system path
	
Function _setMethodSelect($methodName : Text; $bool : Boolean)
	// ok to include @
	var $testObj : Object
	For each ($testObj; This._testMethods.query("name = :1"; $methodName))
		$testObj.selected:=$bool
	End for each 