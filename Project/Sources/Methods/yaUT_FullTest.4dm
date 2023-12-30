//%attributes = {}
/* Purpose: This method will run all yaUT_ test in the database
 ------------------
yaUT_FullTest ()
 Created by: Kirk as Designer, Created: 12/15/23, 14:54:01

This will run all all yaUT_ ... methods, combine the results
and display them

*/

//var $testMethod : cs.TestMethod
//$testMethod:=cs.TestMethod.new("yaUT_example_xx")
//$testMethod:=cs.TestMethod.new("yaUT_example_1")
//$testMethod:=cs.TestMethod.new("yaUT_example_1").run()
//$testMethod:=cs.TestMethod.new("yaUT_example_1").run().displayAlert()

var $fullTest : cs.FullTest

$fullTest:=cs.FullTest.new().getTestMethods().run()

