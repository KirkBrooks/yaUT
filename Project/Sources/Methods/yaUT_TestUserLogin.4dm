//%attributes = {"shared":true}
// yaUT_TestUserLogin
/*    created at: 2024-10-15T00:29:46.577Z  by: Designer
This is a demo method for development testing


kind: demo
priority: 1
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

//mark:-  This is what a section header looks like
$testsRun.push($test.new().insertBreakText("*  "+Current method name))
$testsRun.push($test.new("1 is equal to 1").expect(1).toEqual(1))
$testsRun.push($test.new("1 is not equal to 5").expect(1).not().toEqual(5))
$testsRun.push($test.new("1 is not null").expect(1).not().toBeNull())
$testsRun.push($test.new().insertBreakText("This is a break line"))
var $str : Text
$str:="This is a line of text"
$testsRun.push($test.new("$str contains 'line of text'").expect($str).toMatch("l[\\w ]+text"))
$testsRun.push($test.new("$str contains 'line of text'").expect($str).toMatch(123))