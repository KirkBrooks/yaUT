//%attributes = {}
/* Purpose: builds the method code and returns it as text
 ------------------
Util_createTestMethodCode ()
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 18:12:27
*/

#DECLARE($methodName : Text; $options : Object)->$code : Text
var $codeCol : Collection
var $test : Object

$codeCol:=[]
$codeCol.push("//%attributes = {\"shared\":true}")
$codeCol.push("// "+$methodName)
//mark:  --- comment section
$codeCol.push("// created at: "+Timestamp+"  by: "+Current user)
$codeCol.push("// Kind: "+String($options.kind))
$codeCol.push("// Priority: "+String($options.priority))
$codeCol.push("/* Description:")
$codeCol.push(String($options.description))
$codeCol.push("*/")

//mark:  --- declaration
$codeCol.push("#DECLARE->$testsRun : Collection")
$codeCol.push("var $test : Object")
$codeCol.push("  //  make the constructor")
If (isComponent)
	$codeCol.push("$test:=cs.yaUT.UnitTest")
Else 
	$codeCol.push("$test:=cs.UnitTest")
End if 
$codeCol.push("")
$codeCol.push("$testsRun:=[] // init the collection")
$codeCol.push("//mark:  --- example tests")
$codeCol.push("// $testsRun.push($test.new().insertBreakText(\"*  \"+Current method name))")
$codeCol.push("// $testsRun.push($test.new(\"1 is equal to 1\").expect(1).toEqual(1))")
$codeCol.push("// $testsRun.push($test.new(\"1 is not equal to 5\").expect(1).not().toEqual(5))")
$codeCol.push("// $testsRun.push($test.new(\"1 is not null\").expect(1).not().toBeNull())")
$codeCol.push("// $testsRun.push($test.new().insertBreakText(\"This is a break line\"))")
$codeCol.push("")
$codeCol.push("//mark:  --- unit tests")

//mark:  --- append tests
If ($options.tests#Null)
	
	For each ($test; $options.tests)
		If (String($test.section)#"")
			$codeCol.push("\n//mark:-  "+$test.section)
		End if 
		
		If ($test.code#Null)
			For each ($code; $test.code)
				$codeCol.push($code)
			End for each 
		End if 
		
	End for each 
End if 

//mark:  --- create method
$code:=$codeCol.join("\n")
// SET TEXT TO PASTEBOARD($code)
