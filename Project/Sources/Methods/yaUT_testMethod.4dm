//%attributes = {"shared":true}
// yaUT_testMethod
// created at: 2024-11-19T18:49:54.222Z  by: Designer
// Kind: smoke
// Priority: 2
/* Description:

*/
#DECLARE->$testsRun : Collection
var $test : Object
//  make the constructor
$test:=cs.UnitTest

$testsRun:=[]  // init the collection
//mark:  --- example tests
// $testsRun.push($test.new().insertBreakText("*  "+Current method name))
// $testsRun.push($test.new("1 is equal to 1").expect(1).toEqual(1))
// $testsRun.push($test.new("1 is not equal to 5").expect(1).not().toEqual(5))
// $testsRun.push($test.new("1 is not null").expect(1).not().toBeNull())
// $testsRun.push($test.new().insertBreakText("This is a break line"))

//mark:  --- unit tests