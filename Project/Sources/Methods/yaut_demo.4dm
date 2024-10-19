//%attributes = {"shared":true}
// yaUT_demo
#DECLARE->$col : Collection
var $test : Object
var $str : Text
$str:=String(Current date; ISO date; Current time)
$test:=cs.UnitTest  //  make the constructor
$col:=[]
//mark:  --- create the individal tests
$col.push($test.new().insertBreakText("*  "+Current method name))
$col.push($test.new("1 is equal to 1").expect(1).toEqual(1))
$col.push($test.new("1 is not equal to 5").expect(1).not().toEqual(5))
$col.push($test.new("1 is not null").expect(1).not().toBeNull())
$col.push($test.new().insertBreakText("This is a break line"))
$str:="This is a line of text"
$col.push($test.new("$str contains 'line of text'").expect($str).toMatch("l[\\w ]+text"))
$col.push($test.new("$str contains 'line of text'").expect($str).toMatch(123))
