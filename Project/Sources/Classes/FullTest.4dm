/*  FullTest class
 Created by: Kirk as Designer, Created: 12/30/23, 08:05:35
 ------------------
√ Manages collecting test methods from the database
√ Running a collection of test methods
Logging results
Display results in Browser or 4D Form

*/

Class constructor
	This._ms:=0
	This._error:=""
	
	This._timestamp:=Timestamp
	This._methodPrefix:="yaUT_"
	This._testMethods:=[]
	This._pass:=False
	This._countTests:=0
	This._countPass:=0
	This._countFail:=0
	This._countErr:=0
	
	//mark:  --- getters
Function get pass : Boolean
	return This._pass
	
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
	
	//mark:  --- functions
Function getTestMethods($methodPrefix : Text) : cs.FullTest
/*  Creates a list of unit test method. Methods are identified by the 
methodPrefix. If run from a component looks in the Host for methods. 
The method should return a collection of test classes.
*/
	ARRAY TEXT($aPaths; 0)
	var $i : Integer
	var $col : Collection
	
	This._methodPrefix:=$methodPrefix="" ? This._methodPrefix : $methodPrefix
	$methodPrefix:=This._methodPrefix+"@"
	
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
	This._pass:=True
	This._countTests:=0
	This._countPass:=0
	This._countFail:=0
	This._countErr:=0
	
	For each ($testObj; This._testMethods)
		$testObj.run()
		This._pass:=This._pass && ($testObj.pass)
		This._countTests+=$testObj.countTests
		This._countPass+=$testObj.countPass
		This._countFail+=$testObj.countFail
		This._countErr+=$testObj._countErr
		
	End for each 
	
	This._ms+=Milliseconds
	
	return This
	
	
	
	