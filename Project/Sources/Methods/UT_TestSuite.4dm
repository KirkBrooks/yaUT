//%attributes = {}
/* Purpose: 
 ------------------
UT_TestSuite ()
 Created by: Kirk as Designer, Created: 05/29/23, 10:11:24
*/

var $suite : cs.TestSuite
var $testid : Text
var $formData : Object


$suite:=cs.TestSuite.new("Suite Demo")

$testid:=$suite.appendTest("2)  return name should be exactly as submitted "; Formula(methodWithMultipleInputs))
$suite.appendArg($testid; "toBe"; "Kirk"; "a"; "Kirk"; "b"; "1234")
// $suite.run()



/*  A 'test' is usually for a specfic method. 
This example adds a test of myMethod and the 'name' of the test says what it does
The function retunrs a testId. You will use this to add arguments. 
*/
$testid:=$suite.appendTest("Return name should be exactly as submitted "; Formula(myMethod))

/*  now that you've got a test you need to add some arguments. The test won't run without
at least 1 argument - but the arguments can be null. 

.appendArg parameters:
  - testId
  - input

*/
$suite.appendArg($testid; "notToBe"; "Kirk"; New object("name"; "kirk"))
$suite.appendArg($testid; "toBe"; "Kirk"; New object("name"; "Kirk"))
$suite.appendArg($testid; "notToBe"; "Kirk"; New object("name"; "Mary"))
$suite.appendArg($testid; "toBe"; "Mary"; New object("name"; "Mary"))

$testid:=$suite.appendTest("2)  return name should be exactly as submitted "; Formula(myMethod))
$suite.appendArg($testid; "notToBe"; "Kirk"; New object("name"; "Kirk"))
$suite.appendArg($testid; "toBe"; "Kirk"; New object("name"; "Kirk"))
$suite.appendArg($testid; "notToBe"; "Kirk"; New object("name"; "Mary"))
$suite.appendArg($testid; "toBe"; "Mary"; New object("name"; "Mary"))


$suite.run()

$formData:=New object("suite"; $suite)
DIALOG("DisplaySuiteResults"; $formData)








