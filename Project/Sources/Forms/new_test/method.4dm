/*  new_test - form method
 Created by: Kirk Brooks as Designer, Created: 10/12/24, 18:44:19
 ------------------
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
		Form.name:="yaUT_"+Form.name
	End if 
	
	$obj:=cs.GroupsJson.new().testMethods
	
	If ($obj[Form.name]#Null)
		ALERT("There is already a test with that name.")
		Form.name:=""
	End if 
	
End if 



//mark:  --- update state and formats

OBJECT SET ENABLED(*; "btn_accept"; (Form.name#""))
