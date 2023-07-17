//%attributes = {}

var $test : Object


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
$test:=cs.UnitTest.new("1 is equal to 2").expect(1).not().toEqual(1)
$pass:=$test.pass  //  $pass = True
//SET TEXT TO PASTEBOARD($test.displayline)

/*  Using a constructor  */

$test:=cs.UnitTest  //  make the constructor

$result:="My Unit Test\n"  // a text variable to hold the results

$result+=$test.new("1 is equal to 1").expect(1).toEqual(1).displayline+"\n"
$result+=$test.new("1 is not equal to 5").expect(1).not().toEqual(5).displayline+"\n"
$result+=$test.new("1 is not null").expect(1).not().toBeNull().displayline+"\n"
$str:="This is a line of text"
$result+=$test.new("$str contains 'line of text'").expect($str).toMatch("line of text").displayline+"\n"

ALERT($result)


/* Writing to a collection */
$test:=cs.UnitTest  //  make the constructor

$result:=New collection()

$result.push($test.new("1 is equal to 1").expect(1).toEqual(1))
$result.push($test.new("1 is not equal to 5").expect(1).not().toEqual(5))
$result.push($test.new("1 is not null").expect(1).not().toBeNull())
$str:="This is a line of text"
$result.push($test.new("$str contains 'line of text'").expect($str).toMatch("line of text"))


