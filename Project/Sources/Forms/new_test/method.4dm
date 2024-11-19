/*  new_test - form method
 Created by: Kirk Brooks as Designer, Created: 10/12/24, 18:44:19
 ------------------
This checks the method name:
 - begins with yaUT_ 
 - 31 or fewer chars
Does not check if it exists
*/
var $objectName : Text
var $obj : Object

If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)

//mark:  --- form actions
If (FORM Event.code=On Load)  //  catches all objects
	// make sure this conforms to whatever we are using for the group definition
	Form.name:=""
	Form.description:=""
	Form.kind:=""
	Form.defaultPriority:=1
End if 

//mark:  --- object actions
If ($objectName="trap_enter")
	If (Form.name#"")
		ACCEPT
	End if 
End if 

If ($objectName="btn_kind") && (Form event code=On Clicked)
	Form.kind:=testTypes.chooseByMenu()
End if 

If ($objectName="btn_priority") && (Form event code=On Clicked)
	Form.priority:=Priority_chooseByMenu()
End if 

If ($objectName="name")
	If (Form.name#"yaUT_@")
		Form.name:=Substring("yaUT_"+Form.name; 1; 31)
	End if 
	
End if 

//mark:  --- update state and formats

OBJECT SET ENABLED(*; "btn_accept"; (Form.name#""))
