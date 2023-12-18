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
var $obj; $yaUT : Object
var $methodValidation : Integer
var $err : Text

$results:=[]

If ($testMethods.length=0)
	return 
End if 

$yaUT:=cs.UnitTest.new().initStorage()

For each ($obj; $testMethods)
	
	If (Not($obj.selected))
		continue
	End if 
	
	$methodValidation:=Validate_testMethod($obj.method)
	
	If ($methodValidation=0)
		$yaUT.insertStorageline("*** The method '"+$obj.method+"' is not in the database.")
		continue
	End if 
	
	If ($methodValidation=2)
		$yaUT.insertStorageline("*** The method '"+$obj.method+"' is not shared and can not be run.")
		continue
	End if 
	
	CLEAR VARIABLE($thisTest)
	error:=0
	
	ON ERR CALL("Err_ignore")
	EXECUTE METHOD($obj.method; $thisTest)
	ON ERR CALL("")
	
End for each 

return Storage.yaUT
