//%attributes = {}
/* Purpose: run selected test methods
 ------------------
RunTestMethods ()
 Created by: Kirk as Designer, Created: 11/14/23, 17:26:09

$results is a collection where each element is
{display: 'text to display'; class: }
*/

#DECLARE($testMethods : Collection)->$results : Collection
var $thisTest : Collection
var $test : Variant
var $obj : Object

$results:=[]

If ($testMethods.length=0)
	return 
End if 

For each ($obj; $testMethods)
	
	If (Not($obj.selected))
		continue
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