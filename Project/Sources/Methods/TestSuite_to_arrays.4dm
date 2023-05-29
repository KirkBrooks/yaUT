//%attributes = {}
/* Purpose: 
 ------------------
TestSuite_to_arrays ()
 Created by: Kirk as Designer, Created: 05/29/23, 12:08:48
✅ = char(9989)
❌ = char(10060)

$aColVars is pointer array where each element is pointer to the array for the listbox

*/

#DECLARE($suite : cs.TestSuite; $aColVars : Pointer)
var $testName; $mark : Text
var $len; $i; $index : Integer
var $suiteObject : Object

ARRAY TEXT($aName; 0)
ARRAY TEXT($aPass; 0)
ARRAY TEXT($aResult; 0)
ARRAY TEXT($aMatcher; 0)
ARRAY TEXT($aTestValue; 0)
ARRAY TEXT($aInput; 0)

For each ($suiteObject; $suite.getsuite())
	$testName:=$suiteObject.test.name
	
	$len:=$suiteObject.args.length
	ASSERT($len=$suiteObject.results.length)
	
	For ($i; 1; $len)
		$index:=$i-1
		$mark:=$suiteObject.results[$index].pass ? Char(9989) : Char(10060)
		APPEND TO ARRAY($aName; $testName)
		APPEND TO ARRAY($aPass; $mark)
		APPEND TO ARRAY($aResult; $suiteObject.results[$index].formulaResult)
		APPEND TO ARRAY($aMatcher; $suiteObject.args[$index][1])
		APPEND TO ARRAY($aTestValue; $suiteObject.args[$index][2])
		APPEND TO ARRAY($aInput; $suiteObject.results[$index].input)
	End for 
	
End for each 

//  this must match the column order on the listbox!!
COPY ARRAY($aName; $aColVars->{1}->)
COPY ARRAY($aPass; $aColVars->{2}->)
COPY ARRAY($aResult; $aColVars->{3}->)
COPY ARRAY($aMatcher; $aColVars->{4}->)
COPY ARRAY($aTestValue; $aColVars->{5}->)
COPY ARRAY($aInput; $aColVars->{6}->)
