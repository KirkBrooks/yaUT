//%attributes = {}
/* Purpose: covers the refactor for groups.json
 ------------------
UT_TestSuite_2 ()
 Created by: Kirk Brooks as Designer, Created: 10/19/24, 08:43:20
*/

#DECLARE->$errors : Integer
var $class : cs.UnitTest
var $test : Object
var $a; $b : Variant

$test:=cs.UnitTest


//mark:  --- groups.json doc
var $groupsJson : cs.GroupsJson

$groupsJson:=cs.GroupsJson.new()
//  hijack the path to a test json.doc
$groupsJson.jsonPath:=Folder(fk resources folder).folder("yaUT").file("test_groups.json").path
$groupsJson.content:={version: "test"; lastUpdated: Timestamp; testMethods: {}; testGroups: {}}
$groupsJson.saveContent()



//mark:  --- done
ALERT(Current method name+": unit test complete\n\n"+($errors=0 ? "PASS" : "FAIL"))
