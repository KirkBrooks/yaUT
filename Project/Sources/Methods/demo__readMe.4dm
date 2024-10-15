//%attributes = {}
/* Purpose: 
 ------------------
demo__readMe ()
 Created by: Kirk Brooks as Designer, Created: 10/14/24, 11:38:16
*/

var $method; $code : Text
var $tests : Collection
var $jsonDoc : cs.JsonDocument
var $content; $options : Object

//mark:  --- demo method code
$tests:=[]
$tests.push("$testsRun.push($test.new().insertBreakText(\"*  \"+Current method name))")
$tests.push("$testsRun.push($test.new(\"1 is equal to 1\").expect(1).toEqual(1))")
$tests.push("$testsRun.push($test.new(\"1 is not equal to 5\").expect(1).not().toEqual(5))")
$tests.push("$testsRun.push($test.new(\"1 is not null\").expect(1).not().toBeNull())")
$tests.push("$testsRun.push($test.new().insertBreakText(\"This is a break line\"))")
$tests.push("var $str: Text")
$tests.push("$str:=\"This is a line of text\"")
$tests.push("$testsRun.push($test.new(\"$str contains 'line of text'\").expect($str).toMatch(\"l[\\w ]+text\"))")
$tests.push("$testsRun.push($test.new(\"$str contains 'line of text'\").expect($str).toMatch(123))")


$jsonDoc:=cs.JsonDocument.new(Folder(fk resources folder).folder("yaUT").file("demo_groups.json").path)
$content:=$jsonDoc.getObject()

ON ERR CALL("ERR_ignore")
For each ($method; $content.testMethods)
	
	METHOD GET CODE($method; $code)
	
	If ($code="")
		$options:={description: "This is a demo method for development testing\n\n"}
		$options.priority:=1
		$options.kind:="demo"
		$options.tests:=[]
		$options.tests.push({section: "This is what a section header looks like"; code: $tests})
		
		Util_createTestMethod($method; $options)
	End if 
	
End for each 

//yaUTFolders("checkFolders")
//yaUTFolders("moveTestMethods")