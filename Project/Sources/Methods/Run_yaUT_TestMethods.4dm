//%attributes = {"shared":true}
/* Purpose: run selected test methods
 ------------------
Run_yaUT_TestMethods ()
 Created by: Kirk as Designer, Created: 11/14/23, 17:26:09

$results is a collection where each element is
{display: 'text to display'; class: }
*/

#DECLARE($testMethods : Collection)->$results : Collection
var $thisTest : Variant
var $test : Variant
var $obj : Object
var $methodValidation : Integer
var $err : Text

$results:=[]

If ($testMethods.length=0)
	return 
End if 

For each ($obj; $testMethods)
	
	If (Not($obj.selected))
		continue
	End if 
	
	$methodValidation:=Validate_testMethod($obj.method)
	
	If ($methodValidation=0)
		$err:="*** The method '"+$obj.method+"' is not in the database."
		$results.push({displayline: $err})
		continue
	End if 
	
	If ($methodValidation=2)
		$err:="*** The method '"+$obj.method+"' is not shared and can not be run."
		$results.push({displayline: $err})
		continue
	End if 
	
	CLEAR VARIABLE($thisTest)
	error:=0
	
	ON ERR CALL("Err_ignore")
	EXECUTE METHOD($obj.method; $thisTest)
	ON ERR CALL("")
	
	If (Value type($thisTest)#Is collection) || ($thisTest.length=0)
		$results.push({displayline: "-- No collection returned --"})
		continue
	End if 
	
	For each ($test; $thisTest)  //  $test will be text or a class
		If (Value type($test)=Is text)
			$results.push({displayline: $test})
			continue
		End if 
		
		If (Value type($test)=Is object)
			$results.push($test)
			continue
		End if 
		
	End for each 
	
End for each 