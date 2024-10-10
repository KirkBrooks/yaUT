/*  yaUC_Method class
 Created by: Kirk Brooks as Designer, Created: 10/10/24, 10:30:29
 ------------------
 This class will manage a yaUC group method.
The method does not need to exist. If it doesn't it will be created.

Not worrying about deleting a method. There are plenty of ways to do that. 

*/
property _codeLines : Collection
property _methodName : Text
property _stamp : Real

Class constructor($method : Text)
	If ($method="")
		return 
	End if 
	
	This._methodName:=$method="yaUT_@" ? $method : "yaUT_"+$method
	This._getCode()
	
	
	//mark:  --- getters
Function get ok : Boolean
	return This._methodName#""
	
Function get name : Text
	return This._methodName
	
Function get exists : Boolean
	return This._methodExists(This._methodName)
	
	
	//mark:  --- Functions
Function addMethod($method : Text)
	var $i : Integer
	
	// find the return line
	$i:=This._codeLines.indexOf("return $testsRun")
	
	If ($i=-1) || (Not(This.ok))
		return 
	End if 
	
	
	
	//mark:  --- private
Function _methodExists($methodName : Text) : Boolean
	ARRAY TEXT($aNames; 0)
	METHOD GET NAMES($aNames; $methodName)
	return Size of array($aNames)>0
	
Function _getCode
	var $code : Text
	METHOD GET CODE(This._methodName; $code; *)
	
	If ($code="")
		This._setDefaultCode()
		This._setCode()
	End if 
	
Function _setCode
	// write _codeLines to the method
	var $code : Text
	If (Not(This.ok))
		return 
	End if 
	
	$code:=This._codeLines.join("\n")
	METHOD SET CODE(This._methodName; $code; *)
	RELOAD PROJECT
	
	
Function _setDefaultCode
	This._codeLines:=[]
	This._codeLines.push("//%attributes = {\"shared\":true,\"folder\":\"yaUC groups\",\"lang\":\"en\"} comment added and reserved by 4D.")
	This._codeLines.push("/*  "+This._methodName)
	This._codeLines.push("  Created: "+Timestamp+"  by "+Current user)
	This._codeLines.push("  your comments here")
	This._codeLines.push("*/")
	This._codeLines.push("#DECLARE($priorTests : Collection)->$testsRun : Collection")
	This._codeLines.push("//---")
	This._codeLines.push(" //mark:  --- Combined Methods")
	This._codeLines.push("$testsRun:=$priorTests=Null ? [] : [].combine($priorTests)")
	This._codeLines.push("")
	This._codeLines.push("return $testsRun")
	