//%attributes = {}
/*  UnitTestMethods__readMe ()

1)  unit test method must begin with 'yaut_' followed by descriptive name 
2)  _ut_ methods return a collection

The return collection contains Unit test classes or text
The text will be used to create headers for the classes that follow

*/

// yaut_demo
#DECLARE->$testCol : Collection
var $test : Object
var $str : Text

$testCol:=[Substring(Current method name; 5)]  //  first line is always the method name
$test:=yaUTtest()  //  make the constructor
//mark:  --- create the individal tests
$testCol.push($test.new("1 is equal to 1").expect(1).toEqual(1))
$testCol.push($test.new("1 is not equal to 5").expect(1).not().toEqual(5))
$testCol.push($test.new("1 is not null").expect(1).not().toBeNull())
$testCol.push("This is a break line")
$str:="This is a line of text"
$testCol.push($test.new("$str contains 'line of text'").expect($str).toMatch("l[\\w ]+text"))
$testCol.push($test.new("$str contains 'line of text'").expect($str).toMatch(123))

