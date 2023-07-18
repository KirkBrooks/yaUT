//%attributes = {}
/* Purpose: ironically can't use UnitTest class to test itself
 ------------------
UT_TestSuite ()
 Created by: Kirk as Designer, Created: 05/29/23, 10:11:24
*/

var $class : cs.UnitTest
var $test : Object
var $a; $b : Variant

$test:=cs.UnitTest

//mark:  --- 
$class:=$test.new()
ASSERT($class#Null; "An empty class should instantiate")
ASSERT(Not($class.pass); "Empty class fails by default")
ASSERT($class.isErr; "A description is required")
ASSERT($class.displayline="⚠️@"; "The displayLine should indicate an error")

$class.not()
ASSERT(Not($class.pass); "testing .not() should not run because of existing error")

$class:=$test.new(" not works is there is no error").not()
ASSERT($class.pass; "testing .not() should invert ._result")

$class:=$test.new("test without expect()").expect()
ASSERT($class._expectValue=Null)
ASSERT($class._expectValueKind="undef")
ASSERT($class.isErr; $class.error)
ASSERT($class.error#"")
ASSERT($class.displayline="⚠️@"; "The displayLine should indicate an error")

$class:=$test.new("1 = 1").expect(1)
ASSERT($class._expectValue=1)
ASSERT($class._expectValueKind="number")
ASSERT(Not($class.isErr); "Description and expectedValue are both defined.")
ASSERT($class.error="")
ASSERT($class.displayline="❌@"; "The displayLine should indicate no pass")  // because there is no matcher

$class:=$test.new("2 + 2 = 4").expect(Formula(2+2))
ASSERT($class._expectValue=4)
ASSERT(Not($class.pass); "Test should not pass because there is no matcher")
ASSERT($class._expectValueKind="number")
ASSERT(Not($class.isErr); "Description and expectedValue are both defined.")

$class:=$test.new("2 + 2 = 4").expect(Formula(SumParams); 3; 1)
ASSERT($class._expectValue=4)
ASSERT(Not($class.pass); "Test should not pass because there is no matcher")
ASSERT($class._expectValueKind="number")
ASSERT(Not($class.isErr); "Description and expectedValue are both defined.")

//mark:  --- Testing matchers
$class:=$test.new("2 + 2 = 4").expect(Formula(SumParams); 3; 1).not().toBeNull()
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue=4)
ASSERT($class._expectValueKind="number")

//mark:  --- toEqual()
/*  toEqual(<formula, value>; <params to formula>)
sets _testValue
_testValue must be the same kind as _expectedValue

value:   an object, collection or scalar value
formula: evaluates to _testValue
*/
// scalar values
$class:=$test.new("1 = 1").expect(1).toEqual(1)
ASSERT($class._expectValue=1)
ASSERT($class._expectValueKind="number")
ASSERT(Not($class.isErr); "Description and expectedValue are both defined.")
ASSERT($class.pass; "Test should pass")
ASSERT($class._formula=Null; "_formula should be null - scalar value")

$class:=$test.new("1 = 1").expect(1).toEqual(Formula(1))
ASSERT($class._expectValue=1)
ASSERT($class._expectValueKind="number")
ASSERT(Not($class.isErr); "Description and expectedValue are both defined.")
ASSERT($class.pass; "Test should pass")
ASSERT($class._testFormula#Null; "_expectFormula should not be null")

$class:=$test.new("2 + 2 = 4").expect(4).toEqual(4)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue=4)
ASSERT($class._expectValueKind="number")

$class:=$test.new("2 + 2 = 4").expect(4).not().toEqual(400)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue=4)
ASSERT($class._expectValueKind="number")

// formulas
$class:=$test.new("2 + 2 = 4").expect(Formula(SumParams); 3; 1).toEqual(4)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue=4)
ASSERT($class._expectValueKind="number")

$class:=$test.new("2 + 2 = 4").expect(4).toEqual(Formula(SumParams); 3; 1)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue=4)
ASSERT($class._expectValueKind="number")

// objects
$a:=New object("x"; "adsfasdf"; "y"; 1231)
$b:=New object("x"; "adsfasdf"; "y"; 1231)  //  $a and $b are equal but different references

//  the two objects are equalwhen they have the same properties and values
$class:=$test.new("equal objects are not the same object").expect($a).toEqual($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

$class:=$test.new("equal objects are not the same object").expect($a).toEqual($a)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

$b:=New object("y"; 1231; "x"; "adsfasdf"; "q"; False)
$class:=$test.new("unequal objects ").expect($a).not().toEqual($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

// collections
$a:=New collection(1; 2; 3; "a"; "b")
$b:=$a

$class:=$test.new("equal objects are not the same object").expect($a).toEqual($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

$b:=New collection(1; 2; 3; "a"; "b"; "c")
$class:=$test.new("equal objects are not the same object").expect($a).not().toEqual($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

// order matters in collections - not just value
$b:=New collection("b"; 1; 2; 3; "a")
$class:=$test.new("equal objects are not the same object").expect($a).not().toEqual($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

var $col : Collection
$col:=New collection(1; 2; 3; 4; 5)
$class:=$test.new("Reverse collection").expect($col.reverse()).toEqual(Formula(ReverseCollection); $col)


// error conditions
$class:=$test.new("2 + 2 = 4").expect("4").toEqual(4)
ASSERT($class.isErr; $class.error)
ASSERT(Not($class.pass); "Test should not pass")

$class:=$test.new("2 + 2 = 4").expect(4).toEqual("4")
ASSERT($class.isErr; $class.error)
ASSERT(Not($class.pass); "Test should not pass")

$class:=$test.new("2 + 2 = 4").expect(4).toEqual()
ASSERT($class.isErr; $class.error)
ASSERT(Not($class.pass); "Test should not pass")

$class:=$test.new("2 + 2 = 4").expect().toEqual(4)
ASSERT($class.isErr; $class.error)
ASSERT(Not($class.pass); "Test should not pass")

//mark:  --- toBe()  matches specific instances of objects and collections
/*  .toBe() depends on the type of expectedValue and the parameters
expectedValue is scalar:  uses toEqual()
expectedValue is object, entity or collection and $1 is:
formula:  evaluate the formula and compare to exptectedValue
object:   compare properties of $1 to expectedValue object
*/
// scalar - values
$class:=$test.new("2 + 2 = 4").expect(4).toBe(4)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

// try some formulas 
$class:=$test.new("2 + 3 = 5").expect(5).toBe(Formula(SumParams); 1; 3; 1)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue=5)
ASSERT($class._expectValueKind="number")

$class:=$test.new("2 + 3 = 5").expect(Formula(SumParams); 1; 3; 1).toBe(5)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue=5)
ASSERT($class._expectValueKind="number")

$class:=$test.new("2 + 3 = 5").expect(Formula(SumParams); 1; 3; 1).not().toBe(6)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue=5)
ASSERT($class._expectValueKind="number")

//  objects
$a:=New object("x"; "adsfasdf"; "y"; 1231)
$b:=New object("x"; "adsfasdf"; "y"; 1231)  //  $a and $b are equal but different references

$class:=$test.new("An object 'is' itself").expect($a).toBe($a)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue.y=1231)
ASSERT($class._expectValueKind="object")

$class:=$test.new("equal objects are not the same object").expect($a).not().toBe($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValue.y=1231)
ASSERT($class._expectValueKind="object")

$b:=$a
$class:=$test.new("unless $b is set to $a").expect($a).toBe($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

//  collections
$a:=New collection(1; 2; 3; "a"; "b")
$b:=$a

$class:=$test.new("An object 'is' itself").expect($a).toBe($a)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

$class:=$test.new("2 references to the same collection").expect($a).toBe($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

$a[3]:="z"
$class:=$test.new("changing a reflects in b").expect($a).toBe($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

$b:=New collection(1; 2; 3; "a"; "b")
$class:=$test.new("a nd b are now equal but different references").expect($a).not().toBe($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

//mark:  --- toMatch()   - runs a regex pattern on the expectedValue
$class:=$test.new("'foo bar' contains 'foo'").expect("foo bar").not().toBeNull()
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")

$a:="foo bar"
$b:="foo"
$class:=$test.new("'foo bar' contains 'foo'").expect($a).toMatch($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValueKind="text")

$a:=1234
$b:="foo"
$class:=$test.new("'foo bar' contains 'foo'").expect($a).toMatch($b)
ASSERT($class.isErr; $class.error)
ASSERT(Not($class.pass); "Test should fail")

$a:="foo bar"
$b:=123
$class:=$test.new("'foo bar' contains 'foo'").expect($a).toMatch($b)
ASSERT($class.isErr; $class.error)
ASSERT(Not($class.pass); "Test should fail")

$a:=123
$b:="foo bar"
$class:=$test.new("'foo bar' contains 'foo'").expect($a).toMatch($b)
ASSERT($class.isErr; $class.error)
ASSERT(Not($class.pass); "Test should fail")

//mark:  --- toContain()  - test if expectedValue contains properties and values of testValue
/* when expected value is an object:
  - if $1 is an object test expectedValue is an object too
          and expectedValue contains the same properties and values as $1
 when expected value is a collection: 
  - if count parameters = 1 use expectedValue.indexOf
  - if count parameters = 2 use expectedValue.query($1+" = :1"; $2)

otherwise - data type mismatch
*/
// objects
$a:=New object("x"; "adsfasdf"; "y"; 1231)

$class:=$test.new("$a contains properties of $a ").expect($a).toContain($a)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValueKind="object")

$b:=New object("x"; "adsfasdf"; "y"; 1231; "q"; True)

$class:=$test.new("$b contains properties of $a ").expect($b).toContain($a)
ASSERT(Not($class.isErr); $class.error)
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValueKind="object")

$class:=$test.new("$a does not contain all properties of $b ").expect($a).not().toContain($b)
ASSERT(Not($class.isErr); "Should not be an error")
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValueKind="object")

// add a collection to $a and a reference to it to $b
$a:=New object("x"; "adsfasdf"; "y"; 1231)
$b:=New object("x"; "adsfasdf"; "y"; 1231; "q"; True)
$a.collection:=New collection(1; 2; 3; 4)
$b.collection:=$a.collection

$class:=$test.new("$b contains properties of $a ").expect($b).toContain($a)
ASSERT(Not($class.isErr); $class.error)
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValueKind="object")


$b.collection:=New collection(1; 2; 3)

$class:=$test.new("$b contains properties of $a ").expect($b).not().toContain($a)
ASSERT(Not($class.isErr); $class.error)
ASSERT($class.pass; "Test should pass")
ASSERT($class._expectValueKind="object")


//mark:  --- dones
ALERT(Current method name+": unit test complete")