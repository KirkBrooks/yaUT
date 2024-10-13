//%attributes = {}
/* Purpose: display input form for new Group
 ------------------
Group_enterNew ()
 Created by: Kirk Brooks as Designer, Created: 10/12/24, 18:55:35

The 'new_group' form sets up the data object
Make sure that conforms to whatever we are doing with the group 
definition

*/
#DECLARE($x : Integer; $y : Integer)->$formData : Object
var $window : Integer

$formData:={}

$window:=Open form window("new_group"; Modal form dialog box; $x; $y)
DIALOG("new_group"; $formData)
CLOSE WINDOW($window)

$formData.accepted:=ok=1
