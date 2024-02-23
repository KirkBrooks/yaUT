//%attributes = {"shared":true}
/* Purpose: This method will 
- run all yaUT_ tests
- log the results
- return true if they all pass
 ------------------
yaUT_FullTest ()
 Created by: Kirk as Designer, Created: 12/15/23, 14:54:01

This will run all all yaUT_ ... methods, combine the results
and display them

*/
#DECLARE($logFile : 4D.File) : Boolean
var $fullTest : cs.FullTest

$fullTest:=cs.FullTest.new().getTestMethods().run().logResults($logFile)

return $fullTest.pass


