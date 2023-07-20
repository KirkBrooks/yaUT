//%attributes = {}

var $test : Object
var $pass : Boolean
var $resultText; $str : Text




/* Writing to a collection */
$test:=cs.UnitTest  //  make the constructor

var $testCol : Collection
$testCol:=New collection()

$testCol.push($test.new("1 is equal to 1").expect(1).toEqual(1))
$testCol.push($test.new("1 is not equal to 5").expect(1).not().toEqual(5))
$testCol.push($test.new("1 is not null").expect(1).not().toBeNull())
$str:="This is a line of text"
$testCol.push($test.new("$str contains 'line of text'").expect($str).toMatch("l[\\w ]+text"))
$testCol.push($test.new("$str contains 'line of text'").expect($str).toMatch(123))

Show_UnitTestForm($testCol)


/*  Basic   
// instantiate the class and enter the description 
$test:=cs.UnitTest.new("1 is equal to 1")
// set the expected value
$test.expect(1)
// chose a 'matcher' to evaluate and compare to the expected value
$test.toBe(1)
// and check the result
$pass:=$test.pass  //  $pass = True
ALERT($test.displayline)
*/

/* The same code using chaining */
$test:=cs.UnitTest  //  $test is a constructor

$pass:=$test.new("1+2+1 = 4").expect(Formula(1+2+1)).toEqual(4).pass
// the same test using a method
$pass:=$test.new("1+2+1 = 4").expect(Formula(SumParams); 1; 2; 1).toEqual(4).pass



$test:=cs.UnitTest.new("1 is equal to 1").expect(1).not().toEqual(1)
$pass:=$test.pass  //  $pass = True
//SET TEXT TO PASTEBOARD($test.displayline)

/*  Using a constructor  */

$test:=cs.UnitTest  //  make the constructor

$resultText:="My Unit Test\n"  // a text variable to hold the results

$resultText+=$test.new("1 is equal to 1").expect(1).toEqual(1).displayline+"\n"
$resultText+=$test.new("1 is equal to 1").expect(1).toEqual(2).displayline+"\n"
$resultText+=$test.new("1 is equal to 1").expect(1).toEqual(Current date).displayline+"\n"
$resultText+=$test.new("1 is not equal to 5").expect(1).not().toEqual(5).displayline+"\n"
$resultText+=$test.new("1 is not null").expect(1).not().toBeNull().displayline+"\n"
$str:="This is a line of text"
$resultText+=$test.new("$str contains 'line of text'").expect($str).toMatch("line of text").displayline+"\n"

ALERT($resultText)


