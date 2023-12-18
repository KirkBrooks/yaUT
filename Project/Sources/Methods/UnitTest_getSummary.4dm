//%attributes = {}
/* Purpose: return the unit test as a collection for display in a detail form
 ------------------
UnitTest_getSummary ()
 Created by: Kirk as Designer, Created: 12/17/23, 18:09:49
*/

#DECLARE($test : Object)->$col : Collection

var $property : Text
$col:=[]

For each ($property; ["description"; "pass"; "matcher"; "error"; "isErr"; "_expectValue"; "_expectValueKind"; "_expectFormula"; "_testValue"; "_testValueKind"; "_testFormula"; "ms"])
	$col.push({key: $property; value: ($test[$property]#Null ? String($test[$property]) : "")})
End for each 