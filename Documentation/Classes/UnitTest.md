<!-- Type your summary here -->
## UnitTest Class

Light-weight unit testing for 4D. 

### Install

Simply add the class to a project. 

There is no UI for the class itself. The **ObjectProto** class is required also. 

### Tests

There are three steps required to set up a test:

1) Instantiate the class with the description of what the test does
2) Enter the expected result of the test
3) Choose a ‘matcher’ function to evaluate an input and set the result

They must be done in order.

```4D
// instantiate the class and enter the description 
$test:=cs.UnitTest.new("1 is equal to 1")
// set the expected value
$test.expect(1)
// chose a 'matcher' to evaluate and compare to the expected value
$test.toBe(1)
// and check the result
$pass:=$test.pass  //  $pass = True
ALERT($test.displayline)
```

This can be condensed by chaining the class functions. The above code is equivalent to:

```
$test:=cs.UnitTest.new("1 is equal to 1").expect(1).toBe(1)
$pass:=$test.pass  //  $pass = True
ALERT($test.displayline)
```

Make a class for each test and evaluate it once. 

The `.displayLine` property is an easy way to see the results of a test. 

- ✅   1 is equal to 1  (0 ms)    
- ❌   1 is equal to 2  (0 ms)
- Err 1 is not equal to 2: Incompatible data type - only scalar values and formulas supported.

These are the three types of display you may see. Each is a text string and may be displayed in an alert. 

Generally you will be creating a lot of tests to be run at one time. A nice way to handle creating a lot of classes is with a constructor variable:

```
$test:=cs.UnitTest  //  make the constructor
$class:=$test.new("my new class instance")
```

Combined with chaining I can describe a test and capture the result all in one line. Try it:

```
$test:=cs.UnitTest  //  make the constructor

$result:="My Unit Test\n"  // a text variable to hold the results

$result+=$test.new("1 is equal to 1").expect(1).toEqual(1).displayline+"\n"
$result+=$test.new("1 is not equal to 5").expect(1).notToEqual(5).displayline+"\n"
$result+=$test.new("1 is not null").expect(1).notToBeNull().displayline+"\n"
$str:="This is a line of text"
$result+=$test.new("$str contains 'line of text'").expect($str).toMatch("line of text").displayline+"\n"

ALERT($result)
```

If you wanted to have the results of each test for deeper analysis you could push them onto a collection instead: 

```
$test:=cs.UnitTest  //  make the constructor

$result:=New collection()

$result.push($test.new("1 is equal to 1").expect(1).toEqual(1))
$result.push($test.new("1 is not equal to 5").expect(1).notToEqual(5))
$result.push($test.new("1 is not null").expect(1).notToBeNull())
$str:="This is a line of text"
$result.push($test.new("$str contains 'line of text'").expect($str).toMatch("line of text"))
```

### Using Formulas for test values

Some matcher functions can take a 4D https://developer.4d.com/docs/API/FunctionClass/ “Formula” as an input. There are several benefits this provides. Chief among them is the ability to call Project methods and evaluate the results. 

### **Properties and Functions**

| Property          | Return Type | Descripton                                                   |
| ----------------- | ----------- | ------------------------------------------------------------ |
| pass              | Boolean     | True when the test passes                                    |
| isErr             | Boolean     | True if there is an error                                    |
| errorText         | Text        |                                                              |
| description       | Text        |                                                              |
| expectedValue     | Variant     |                                                              |
| expectedValueKind | Text        | number, date, text, bool, object, collection, null, undef, other |
| testValue         | Variant     |                                                              |
| displayline       | Text        | Returns a text suitable for display in a listbox or text field based on the state of the object.<br />Ex:  ✅   get_item() should be null  (0 ms) |

| Function Name   | Parameters                                   | Return Type | Description                                                  |
| --------------- | -------------------------------------------- | ----------- | ------------------------------------------------------------ |
| Constructor     | `$description: Text`                         | cs.UnitTest | Initializes the object and sets the description.             |
| expect          | `$valueIn: Variant`                          | cs.UnitTest | The expected value.                                          |
|        **Matchers**                                                                   ||||
| toEqual         | `$input: Variant`                            | cs.UnitTest | Checks if input is equal to an expected value.<br />Input may be a **Formula** that evaluates to the expected value.<br />Otherwise it is a scalar value and must be the same data kind as expected value. |
| notToEqual      | `$input: Variant`            | cs.UnitTest | Checks if an input is not equal to an expected value.        |
| toBe            | `$input:Variant`                             | cs.UnitTest | Checks if an input is the same as the expected value depending on its type.<br />Input may be a **Formula** that evaluates to the expected value.<br />If dealing with an object or collection checks to see if this is they are the same _reference_ - that is, the same object and not simply the same values. Use `.toEqual()` or `.toContain()` to check values. |
| toMatch         | `$pattern: Text`                             | cs.UnitTest | Checks if a regular expression pattern matches the expected value.<br />Expected value must be text. |
| notToMatch      | `$pattern: Text`      | cs.UnitTest | Checks if a formula does not match the expected value.       |
| toContain       | `$input`                                  | cs.UnitTest | If the expected value is an object or entity checks to see if it contains  all the values in the input object.<br />Input may be a **Formula** that evaluates to an object or entity. |
| notToContain    | `$input`                               | cs.UnitTest | Checks if the expected value, when it is an object, does not contain all the values in the input object. |
| toBeNull        | None                                         | cs.UnitTest | Checks if the expected value is null.                        |
| notToBeNull     | None                                         | cs.UnitTest | Checks if the expected value is not null.                    |
| scalarToContain | `$input: Variant (scalar values)` | cs.UnitTest | If the expected value is a scalar collection checks to see if expected value contains input. |

