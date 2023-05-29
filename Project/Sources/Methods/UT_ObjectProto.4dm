//%attributes = {}
/* Purpose: 
 ------------------
UT_ObjectProto ()
 Created by: Kirk as Designer, Created: 05/27/23, 14:54:34
*/

var $class : cs.ObjectProto
var $obj; $properties : Object

$class:=cs.ObjectProto.new()

//  StrIsInteger
ASSERT($class._strIsInteger("1234"); "1234 is a string of intergers!")
ASSERT(Not($class._strIsInteger("12.34")); "12.34 is not a string of intergers - reals not supported")
ASSERT(Not($class._strIsInteger()); "Should return false for no parameters")

// get value by object coll
var $house : Object
$house:=New object(\
"bath"; True; \
"bedrooms"; 4; \
"kitchen"; New object(\
"amenities"; New collection("oven"; "stove"; "washer"); \
"area"; 20; \
"wallColor"; "white"; \
"nice.oven"; True); \
"livingroom"; New object(\
"amenities"; New collection(\
New object("couch"; New collection(\
New collection("large"; New object("dimensions"; New collection(20; 20))); \
New collection("small"; New object("dimensions"; New collection(10; 10))\
))))); \
"ceiling.height"; 2)

ASSERT($class.getObjectValueByColl($house; New collection("kitchen"; "amenities"; 0))="oven"; "Should find the 'oven' value.")
ASSERT($class.getObjectValueByColl($house; New collection("kitche"; "amenities"; 0))=Null; "Should return null - bad path value.")
ASSERT($class.getObjectValueByColl($house; New collection(2))=Null; "Should return null - bad path value.")
ASSERT($class.getObjectValueByColl($house; New collection("kitchen"; "amenities"; 4))=Null; "Should return null - bad path value.")

ASSERT($class.getObjectValueByPath($house; "kitchen.amenities[0]")="oven"; "Should find the 'oven' value by path.")

$obj:=New object()
$properties:=New object("a"; 123; "b"; New object("text"; "abscde"; "number"; 213165478))
$class.defineProperties($obj; $properties)
ASSERT($obj.a=123)
ASSERT($obj.b.text="abscde")

$properties:=New object("a"; 687; "b"; New object("text"; "new text"; "number"; 0))
$class.defineProperties($obj; $properties)
ASSERT($obj.a=687)
ASSERT($obj.b.text="new text")




