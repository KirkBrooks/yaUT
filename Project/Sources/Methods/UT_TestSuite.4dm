//%attributes = {}
/* Purpose: 
 ------------------
UT_TestSuite ()
 Created by: Kirk as Designer, Created: 05/29/23, 10:11:24
*/

var $suite : cs.TestSuite
var $testid : Text
var $formData : Object

$suite:=cs.TestSuite.new()


$testid:=$suite.appendTest("return name should be exactly as submitted "; Formula(myMethod))
$suite.appendArg($testid; New object("name"; "kirk"); "notToBe"; "Kirk")
$suite.appendArg($testid; New object("name"; "Kirk"); "toBe"; "Kirk")
$suite.appendArg($testid; New object("name"; "Mary"); "notToBe"; "Kirk")
$suite.appendArg($testid; New object("name"; "Mary"); "toBe"; "Mary")

$testid:=$suite.appendTest("2)  return name should be exactly as submitted "; Formula(myMethod))
$suite.appendArg($testid; New object("name"; "Kirk"); "notToBe"; "Kirk")
$suite.appendArg($testid; New object("name"; "Kirk"); "toBe"; "Kirk")
$suite.appendArg($testid; New object("name"; "Mary"); "notToBe"; "Kirk")
$suite.appendArg($testid; New object("name"; "Mary"); "toBe"; "Mary")


$suite.run()

$formData:=New object("suite"; $suite)
DIALOG("DisplaySuiteResults"; $formData)








