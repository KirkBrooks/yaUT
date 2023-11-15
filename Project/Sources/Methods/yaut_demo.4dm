//%attributes = {}
// _ut_demo
#DECLARE->$testCol : Collection
var $test : Object
var $str : Text

$testCol:=[Current method name]  //  first line is always the method name
$test:=cs.UnitTest  //  make the constructor
//mark:  --- create the individal tests
$testCol.push($test.new("1 is equal to 1").expect(1).toEqual(1))
$testCol.push($test.new("1 is not equal to 5").expect(1).not().toEqual(5))
$testCol.push($test.new("1 is not null").expect(1).not().toBeNull())
$testCol.push("This is a break line")
$str:="This is a line of text"
$testCol.push($test.new("$str contains 'line of text'").expect($str).toMatch("l[\\w ]+text"))
$testCol.push($test.new("$str contains 'line of text'").expect($str).toMatch(123))
