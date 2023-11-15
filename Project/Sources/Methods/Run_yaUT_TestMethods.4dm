//%attributes = {"shared":true}
/* Purpose: run selected test methods
 ------------------
Run_yaUT_TestMethods ()
 Created by: Kirk as Designer, Created: 11/14/23, 17:26:09

$results is a collection where each element is
{display: 'text to display'; class: }
*/

#DECLARE($testMethods : Collection)->$results : Collection
var $thisTest : Collection
var $test : Variant
var $obj : Object
var $methodValidation : Integer

$results:=[]

If ($testMethods.length=0)
	return 
End if 

For each ($obj; $testMethods)
	
	If (Not($obj.selected))
		continue
	End if 
	
	$methodValidation:=Validate_testMethod($obj.method)
	
	If ($methodValidation=0) || (($methodValidation=2) & Is compiled mode)
		//  no method  or we can't update it
		continue
	End if 
	
	If ($methodValidation=2)  //  update method attribute
		METHOD SET ATTRIBUTE($obj.method; Attribute shared; True)
	End if 
	
	EXECUTE METHOD($obj.method; $thisTest)
	
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