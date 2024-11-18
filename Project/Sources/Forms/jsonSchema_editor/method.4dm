/*  jsonSchema_editor - form method
 Created by: Kirk Brooks as Designer, Created: 10/20/24, 14:32:21
 ------------------
*/

var $objectName : Text
var $doLoadFile : Boolean
var $groups : cs.GroupsJson
var $errors_LB : cs.listbox


If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)
$errors_LB:=Form.errors_LB || cs.listbox.new("errors_LB")


//mark:  --- form actions
If (FORM Event.code=On Load)  //  catches all objects
	Form.errors_LB:=$errors_LB
	$groups:=groupJsonDoc(True)
	
	Form.file:=cs.JsonDocument.new($groups.jsonPath)
	Form.content:={}
	Form.schema:=$groups._schema
	Form.validation:={success: False; errors: [{message: "No content"}]}
	$doLoadFile:=True
End if 

//mark:  --- object actions

//mark:  --- update state and formats

If ($doLoadFile)
	Form.content:=Form.file.content
	Form.validation:=JSON Validate(Form.content; Form.schema)
	$errors_LB.setSource(Form.validation.errors)
	
End if 