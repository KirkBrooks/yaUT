//%attributes = {}
/* Purpose: allows creating and editing a test method object
 ------------------
Test_enterNew ()
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 08:48:10

Allows editing the test method object properties: priority and kind
Will create the method if it doesn't already exist
Udpates the groups.json file
*/
#DECLARE($x : Integer; $y : Integer)->$formData : Object
var $window : Integer

$formData:={}

$window:=Open form window("new_test"; Modal form dialog box; $x; $y)
DIALOG("new_test"; $formData)
CLOSE WINDOW($window)

$formData.accepted:=ok=1







