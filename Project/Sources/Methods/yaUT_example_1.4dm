//%attributes = {}
/* Purpose: example method for a unit test 
 ------------------
yaUT_example_1 ()
 Created by: Kirk as Designer, Created: 12/30/23, 09:41:11
*/
#DECLARE->$testsRun : Collection  //  the method returns a collection of the tests run
var $test : Object

$test:=cs.UnitTest  //  this is the test constructor
$testsRun:=[]  //  collection of tests to run

//mark:  --- create unit tests

// I can use the test constructor to make a new test with .new()
// There's no need to keep the class object so I just push it directly
// onto the test collection
$testsRun.push($test.new("1 is equal to 1").expect(1).toEqual(1))
$testsRun.push($test.new("1 is not equal to 5").expect(1).not().toEqual(5))
$testsRun.push($test.new("1 is not null").expect(1).not().toBeNull())

// I can insert a comment line into the collection
$testsRun.push($test.new().insertComment("This is my comment "))

// creating some data to run test on
var $str : Text
$str:="This is a line of text"
$testsRun.push($test.new("$str contains 'line of text'").expect($str).toMatch("l[\\w ]+text"))
$testsRun.push($test.new("$str contains 'line of text'").expect($str).not().toMatch(123))

