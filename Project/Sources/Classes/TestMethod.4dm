/*  TestMethod class
 Created by: Kirk as Designer, Created: 12/30/23, 08:34:43
 ------------------
Facade class for a unit test. 
$methodName is a unit test method in the database

*/

Class constructor($methodName : Text)
	This._error:=""
	This._methodName:=$methodName
	This._results:=[]  //  collection of UnitTest classes run by the method
	This._pass:=False
	This._countTests:=0
	This._countPass:=0
	This._countFail:=0
	This._countErr:=0
	This.selected:=True
	This.isRun:=False
	This._ms:=0
	This._validateMethod($methodName)
	
	//mark:  --- getters
Function get name : Text
	return This._methodName
	
Function get label : Text
	return This._methodName+(Not(This._isValid) ? " ⚠️" : "")
	
Function get pass : Boolean
	return Bool(This._pass)
	
Function get isErr : Boolean
	return Bool(This._error#"")
	
Function get error : Text
	return This._error
	
Function get displayline : Text
	//  return line of text suitable for display in a listbox or text field
	Case of 
		: (Not(This.isRun))
			return "   - not run"
			
		: (This.isErr)
			return "⚠️ : "+String(This._error)
			
		: (This.pass)
			return "✅  # tests: "+String(This.countTests)
			
		Else 
			return "❌  # pass: "+String(This.countPass)+", # fail: "+String(This.countFail)
	End case 
	
Function get isValid : Boolean
	return This._isValid
	
Function get countTests : Integer
	return This._countTests
	
Function get countPass : Integer
	return This._countPass
	
Function get countFail : Integer
	return This._countFail
	
Function get countErr : Integer
	return This._countErr
	
Function get ms : Integer
	return This._ms
	
	//mark:  --- run it
Function run : cs.TestMethod
	
	If (Not(This.selected))
		return This
	End if 
	
	If (Not(This.isValid))
		This._error:="This is not a valid method"
		return This
	End if 
	
	var $thisTest : Collection
	error:=0
	This._ms:=Milliseconds*-1
	
	This._countTests:=0
	This._countPass:=0
	This._countFail:=0
	This._countErr:=0
	
	ON ERR CALL("Err_ignore")
	EXECUTE METHOD(This._methodName; $thisTest)
	ON ERR CALL("")
	
	This._ms+=Milliseconds
	
	If ($thisTest=Null)
		This._error:="No results were returned by this method."
		If (error#0)
			This._error+="\nThere was a 4D error: ["+String(error)+"] "+error method
		End if 
		This._results:=[]
		This.isRun:=True
		This._pass:=False
		This._countErr:=1
		return This
	End if 
	
	If (error#0)
		This._error:="There was a 4D error: ["+String(error)+"] "+error method
	End if 
	This._results:=$thisTest
	This.isRun:=True
	This._countErr:=$thisTest.query("isErr = :1"; True).length
	$thisTest:=$thisTest.query("isComment = Null")
	This._countTests:=$thisTest.length
	This._countPass:=$thisTest.query("pass = :1"; True).length
	This._countFail:=This._countTests-This._countPass
	This._pass:=This._countFail=0
	
	return This
	
Function getResults : Collection
	return This._results.extract("displayline")
	
Function getFullResults : Collection
	return This._results
	
Function displayAlert
	// displays the results in an Alert dialog
	var $message : Text
	$message:=Current method name+"\n\n"
	$message+=This.getResults().join("\n")
	ALERT($message)
	
Function writeToLog($fHandle : 4D.FileHandle)
	var $testObj : Object
	
	If ($fHandle=Null)
		return 
	End if 
	
	$fHandle.writeLine(This.displayline)
	If (This.isErr)
		$fHandle.writeLine("  Error: "+This.error)
	End if 
	$fHandle.writeLine("pass: "+String(This.pass))
	$fHandle.writeLine("  # tests: "+String(This.countTests))
	$fHandle.writeLine("  # pass: "+String(This.countPass))
	$fHandle.writeLine("  # fail: "+String(This.countFail))
	
	For each ($testObj; This._results)
		$fHandle.writeLine("    "+$testObj.displayline)
	End for each 
	
	//mark:  --- private
Function _validateMethod
/* validate the method name exists
If running as component the test method may not be shared
in which case if the database is uncompiled we change the
attribute to shared.
But it doesn't have to be shared to get the code
*/
	var $shared : Boolean
	var $path : Text
	ARRAY TEXT($aMethods; 0)
	
	METHOD GET PATHS(Path project method; $aMethods; *)
	
	If (Find in array($aMethods; This.name)=-1)
		This._error:="*** The method '"+This.name+"' is not in the database."
		This._isValid:=False
		return 
	End if 
	
	$shared:=METHOD Get attribute(This.name; Attribute shared; *)
	
	If (Not(This._isComponent()))
		This._isValid:=True
		return 
	End if 
	
	If (Not($shared)) && (Not(Is compiled mode))
		//  attempt to change the attribute on the method
		METHOD SET ATTRIBUTE(This.name; Attribute shared; True; *)
		
		This._isValid:=METHOD Get attribute(This.name; Attribute shared; *)
		This._error:=Not(This._isValid) ? "*** The method '"+This.name+"' is not shared and can not be run." : ""
		return 
	End if 
	This._isValid:=True
	return 
	
Function _isComponent : Boolean
	return Bool(Compare strings(Structure file; Structure file(*))#0)
	