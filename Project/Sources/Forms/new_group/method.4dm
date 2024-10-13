/*  new_group - form method
 Created by: Kirk Brooks as Designer, Created: 10/12/24, 18:44:19
 ------------------
*/
var $objectName : Text

If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)

//mark:  --- object actions
If (FORM Event.code=On Load)  //  catches all objects
	// make sure this conforms to whatever we are using for the group definition
	Form.name:=""
	Form.description:=""
	Form.tags:=""
	Form.tests:=[]
	Form.includeGroups:=[]
End if 

//mark:  --- object actions
If ($objectName="trap_enter")
	If (Form.name#"")
		ACCEPT
	End if 
End if 

//mark:  --- update state and formats

OBJECT SET ENABLED(*; "btn_accept"; Form.name#"")
