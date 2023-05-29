/*  TestSuite class
 Created by: Kirk as Designer, Created: 05/29/23, 09:57:54
 ------------------
 Description: 

*/

Class constructor
	
	This._suite:=New collection()
	
	//mark:- computed attributes
	
	
	//mark:- public functions
Function appendTest($name : Text; $formula) : Text
	var $class : cs.TestElement
	$class:=cs.TestElement.new($name; $formula)
	
	This._suite.push(New object("test"; $class; "args"; New collection; "results"; New collection()))
	return $class.id
	
Function appendArg($id : Text; $input; $matcher : Text; $matcherValue)
	var $test : Object
	
	$test:=This._getTest($id)
	This._doReturn($test=Null)
	$test.args.push(Copy parameters(2))
	
Function run
	var $suiteTest : Object
	
	For each ($suiteTest; This._suite)
		This._evalSuiteTest($suiteTest)
	End for each 
	
Function getsuite : Collection
	return This._suite
	
	//mark:- private functions
Function _evalSuiteTest($suiteTest : Object)
	var $test : cs.TestElement
	var $args; $results : Collection
	var $ok : Boolean
	var $result : Object
	
	$test:=$suiteTest.test
	$suiteTest.results:=New collection()
	$results:=$suiteTest.results
	
	For each ($args; $suiteTest.args)
		$result:=New object()
		$result.pass:=This._runTest($test; $args)
		$result.input:=This._renderToText($args[0])
		$result.formulaResult:=$test.getFormulaResult()
		$result.testValue:=This._renderToText($args[2])
		$results.push($result)
	End for each 
	
	
Function _runTest($test : cs.TestElement; $args : Collection) : Boolean
	return $test.expect($args[0])[$args[1]]($args[2])
	
Function _renderToText($value) : Text
	//  describe the input variable as something we can display as text
	
	Case of 
		: (Value type($value)=Is null)
			return "null"
			
		: (Value type($value)=Is undefined)
			return "undefined"
			
		: (Value type($value)=Is text)
			return $value
			
		: (Value type($value)=Is real) || \
			(Value type($value)=Is longint) || \
			(Value type($value)=Is date) || \
			(Value type($value)=Is boolean)
			return String($value)
			
		: (Value type($value)=Is picture)
			return "picture"
			
		: (Value type($value)=Is object) || (Value type($value)=Is collection)
			return Substring(JSON Stringify($value); 1; 200)
		Else 
			return "other input"
	End case 
	
Function _doReturn($bool : Boolean; $value) : Variant
	If (Not($bool))
		return $value
	End if 
	
Function _getTest($id : Text) : Object
	// find a test by id
	var $found : Collection
	$found:=This._suite.query("test.id = :1"; $id)
	return ($found.length>0) ? $found[0] : Null
	