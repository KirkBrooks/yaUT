//%attributes = {}
// yaUT_demo
var $test : Object
var $str : Text
var $showResult : Boolean

$test:=cs.UnitTest  //  make the constructor

$showResult:=False
If ($showResult)
	yaUT__initStorage({logResults: True; showDialog: True})
End if 

//mark:  --- create the individal tests
$test.new().insertBreakText("*  "+Current method name)

$test.new("1 is equal to 1").expect(1).toEqual(1)
$test.new("1 is not equal to 5").expect(1).not().toEqual(5)
$test.new("1 is not null").expect(1).not().toBeNull()

$test.new().insertBreakText("This is a break line")

$str:="This is a line of text"
$test.new("$str contains 'line of text'").expect($str).toMatch("l[\\w ]+text")
$test.new("$str contains 'line of text'").expect($str).toMatch(123)

If ($showResult)
	ALERT(yaUT__getDisplayText)
	yaUT__clearStorage
End if 
