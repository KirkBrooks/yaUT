//%attributes = {}
/* Purpose: covers the refactor for groups.json
 ------------------
UT_TestSuite_2 ()
 Created by: Kirk Brooks as Designer, Created: 10/19/24, 08:43:20
*/

#DECLARE->$testsRun : Collection
var $class : cs.UnitTest
var $test; $testObj; $testGroup; $methodObj; $obj; $groupObj : Object
var $a; $b : Variant
var $methodName; $groupName; $testJsonPath : Text
var $jsonDoc : cs.JsonDocument

$test:=cs.UnitTest
$testsRun:=[]

//  jsonDoc used for this test
$testJsonPath:=Folder(fk resources folder).folder("yaUT").file("test_groups.json").path
$jsonDoc:=cs.JsonDocument.new($testJsonPath)  // 
$jsonDoc.content:={version: "0.0"; lastUpdated: Timestamp; testMethods: {}; testGroups: {}}
$jsonDoc.writeObject()


//mark:  --- example unit tests
//$testsRun.push($test.new("1 is equal to 1").expect(1).toEqual(1))
//$testsRun.push($test.new("1 is not equal to 5").expect(1).not().toEqual(5))
//$testsRun.push($test.new("1 is not null").expect(1).not().toBeNull())
// insert a comment line
//$testsRun.push($test.new().insertComment("This is my comment "))        

//mark:  --- groups.json doc
var $groupsJson : cs.GroupsJson
$groupsJson:=cs.GroupsJson.new($testJsonPath)

$testsRun.push($test.new("An empty class should instantiate").expect($groupsJson).not().toBeNull())
$testsRun.push($test.new("An empty class is valid").expect($groupsJson.validJson).toEqual(True))
$testsRun.push($test.new("class.content should not be null").expect($groupsJson.content).not().toBeNull())
$testsRun.push($test.new("class.testMethods should not be null").expect($groupsJson.testMethods).not().toBeNull())
$testsRun.push($test.new("class.testMEthods should be Undefined").expectUndefined($groupsJson.testMEthods).toEqual(True))
$testsRun.push($test.new("class.testGroups should not be null").expect($groupsJson.testGroups).not().toBeNull())

//  add testMethod
$methodName:="testMethod"
UTIL_deleteMethod($methodName)  //  delete if it's already there
UTIL_deleteMethod("yaUT_"+$methodName)

$groupsJson.putTest($methodName)
$testsRun.push($test.new("class is valid").expect($groupsJson.validJson).toEqual(True))
$testsRun.push($test.new("methodCount = 1").expect($groupsJson.methodCount).toEqual(1))
$testsRun.push($test.new("groupCount = 0").expect($groupsJson.groupCount).toEqual(0))

$methodName:="yaUT_"+$methodName  //  name is changed by the class
$methodObj:=$groupsJson.getTest($methodName)
$testsRun.push($test.new("class.getMethod('"+$methodName+"') not to be null").expect($methodName).not().toBeNull())

// also creates the 4D method
$testsRun.push($test.new("4D Method is created").expect(UTIL_methodExists($methodName)).toEqual(True))

// add a group by name
$groupName:="group_A"
$groupsJson.putGroup($groupName)
$testsRun.push($test.new(".putGroup($groupName); class is valid").expect($groupsJson.validJson).toEqual(True))

$groupObj:=$groupsJson.testGroups[$groupName]
$testsRun.push($test.new("$groupsJson.testGroups[$groupName] not to be null").expect($groupObj).not().toBeNull())
$testsRun.push($test.new("methodCount = 1").expect($groupsJson.methodCount).toEqual(1))
$testsRun.push($test.new("groupCount = 1").expect($groupsJson.groupCount).toEqual(1))

// add a group by object
$groupName:="group_B"
$obj:=$groupsJson.groupObject($groupName)

$testsRun.push($test.new("default $obj not to be null").expect($obj).not().toBeNull())
$testsRun.push($test.new("$obj.name = '"+$groupName+"'").expect($obj.name).toEqual($groupName))
$testsRun.push($test.new("$obj.tags = []").expect(Value type($obj.tags)).toEqual(Is collection))
$testsRun.push($test.new("$obj.tests = []").expect(Value type($obj.tests)).toEqual(Is collection))
$testsRun.push($test.new("$obj.includeGroups = []").expect(Value type($obj.includeGroups)).toEqual(Is collection))

$obj.description:="group_b description"
$obj.tags:=["a"; "b"; "c"]

$groupsJson.putGroup($obj)
$testsRun.push($test.new(".putGroup($obj); class is valid").expect($groupsJson.validJson).toEqual(True))
$testsRun.push($test.new("$groupsJson.testGroups[$groupName] not to be null").expect($groupObj).not().toBeNull())
$testsRun.push($test.new("methodCount = 1").expect($groupsJson.methodCount).toEqual(1))
$testsRun.push($test.new("groupCount = 2").expect($groupsJson.groupCount).toEqual(2))


$groupObj.name:="group_B"
$groupObj.defaultPriority:=4
$groupObj.description:="xxxx"
$groupsJson.putGroup($groupObj)
$testsRun.push($test.new(".putGroup($groupObj); class is valid").expect($groupsJson.validJson).toEqual(True))
$testsRun.push($test.new("$groupsJson.testGroups[$groupName].description to be 'xxxx'").expect($groupsJson.testGroups[$groupName].description).toEqual("xxxx"))
$testsRun.push($test.new("methodCount = 1").expect($groupsJson.methodCount).toEqual(1))
$testsRun.push($test.new("groupCount = 2").expect($groupsJson.groupCount).toEqual(2))





//mark:  --- done
// ALERT(Current method name+": unit test complete\n\n"+($errors=0 ? "PASS" : "FAIL"))
