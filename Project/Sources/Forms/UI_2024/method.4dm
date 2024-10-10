/*  UI_2024 - form method
 Created by: Kirk Brooks as Designer, Created: 10/10/24, 09:15:31
 ------------------
*/

var $objectName : Text
var $tests_LB; $groups_LB : cs.listbox

If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)
$tests_LB:=Form.tests_LB || cs.listbox.new("tests_LB")
$groups_LB:=Form.groups_LB || cs.listbox.new("groups_LB")

//mark:  --- object actions
If (FORM Event.code=On Load)  //  catches all objects
	Form.SearchPicker:=""
	
	Form.tests_LB:=$tests_LB
	Form.groups_LB:=$groups_LB
	
	UI_searchPicker(""; "testPicker")
	UI_searchPicker(""; "gropuPicker")
End if 

If ($objectName="SearchPicker")
	
	
	
End if 





//mark:  --- update state and formats

