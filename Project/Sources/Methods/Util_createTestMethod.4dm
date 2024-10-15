//%attributes = {}
/* Purpose: a method to create a yaUT_ test method 
Teturns True if method exists or is created
This will create a basic stem
 ------------------
Util_createTestMethod ()
 Created by: Kirk Brooks as Designer, Created: 10/14/24, 16:22:27

$options: {
  description: 
  tests:[]  //  will be inserted in order
   {
     section: ""  //  inserted with as 'mark//:- ' <your text>
     code: []  //  lines to be inserted for this test
   }
}

*/

#DECLARE($methodName : Text; $options : Object) : Boolean
ARRAY TEXT($aNames; 0)
var $codeCol : Collection
var $test : Object
var $code : Text

If ($methodName="")
	return False
End if 

If ($methodName#"yaUT_@")
	$methodName:=Substring("yaUT_"+$methodName; 1; 31)
End if 

METHOD GET NAMES($aNames; $methodName)
If (Size of array($aNames)>0)
	return True  //  because the method exists
End if 

$codeCol:=[]
$codeCol.push("//%attributes = {\"shared\":true}")
$codeCol.push("// "+$methodName)

//mark:  --- comment section
$codeCol.push("/*    created at: "+Timestamp+"  by: "+Current user)
$codeCol.push(String($options.description))
If (String($options.kind)#"")
	$codeCol.push("kind: "+String($options.kind))
End if 
If (String($options.priority)#"")
	$codeCol.push("priority: "+String($options.priority))
End if 
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
METHOD SET CODE($methodName; $code; *)
yaUTFolders("moveTestMethods")
return True
