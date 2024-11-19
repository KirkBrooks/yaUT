/*  UI_2024 - form method
 Created by: Kirk Brooks as Designer, Created: 10/10/24, 09:15:31
 ------------------
Form.content = the Resources/yaUT/groups.json file

Form elements all reference content. Write content on changes.


*/

var $name; $objectName; $text; $method : Text
var $tests_LB; $groups_LB : cs.listbox
var $x; $y; $l; $t; $r; $b : Integer
var $file : 4D.File
var $obj : Object
var $API : cs.Groups_API

If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)
$tests_LB:=Form.tests_LB || cs.listbox.new("tests_LB")
$groups_LB:=Form.groups_LB || cs.listbox.new("groups_LB")
$API:=Form.API || cs.Groups_API.new()

//mark:  --- form actions
If (FORM Event.code=On Load)  //  catches all objects
	Form.API:=$API
	
	SET WINDOW TITLE("JSON configuration = "+$API.fileName; Current form window)
	
	$tests_LB.setSource($API.tests)
	$groups_LB.setSource($API.groups)
	
	Form.tests_LB:=$tests_LB
	Form.groups_LB:=$groups_LB
	
	Form.groupSubform:={group: Null}
End if 


//mark:  --- object actions
If ($objectName="test_searchStr") && (Form event code=On After Edit)
	// scalar list
	$text:=Get edited text
	Case of 
		: ($text="")
			$tests_LB.reset()
		Else 
			$tests_LB.data:=[]
			For each ($method; $tests_LB.source)
				If ($method=("@"+$text+"@"))
					$tests_LB.data.push($method)
				End if 
			End for each 
	End case 
	
End if 

If ($objectName="group_searchStr") && (Form event code=On After Edit)
	$text:=Get edited text
	Case of 
		: ($text="")
			$groups_LB.reset()
		Else 
			$groups_LB.data:=$groups_LB.source.query("name = :1"; "@"+$text+"@")
	End case 
	
End if 

If ($objectName="btn_addGroup")
	OBJECT GET COORDINATES(*; $objectName; $l; $t; $r; $b)
	$x:=$r-396
	$y:=98
	CONVERT COORDINATES($x; $y; XY Current form; XY Screen)
	$obj:=Group_enterNew($x; $y)
	
	If ($obj.accepted)
		OB REMOVE($obj; "accepted")
		$API.addGroup($obj)
		$groups_LB.setSource($API.groups)
		
	End if 
End if 

If ($objectName="btn_addTest")
	
	$x:=5
	$y:=98
	CONVERT COORDINATES($x; $y; XY Current form; XY Screen)
	$obj:=Test_enterNew($x; $y)
	
	If ($obj.accepted)
		$API.addTest($obj)
		$tests_LB.setSource($API.tests)
	End if 
End if 

If ($objectName="groups_LB")
	
	Case of 
		: (Form event code=On Begin Drag Over) && ($groups_LB.isSelected)
			SET TEXT TO PASTEBOARD(JSON Stringify($groups_LB.currentItem.toObject()))
			
		: (Form event code=On Double Clicked) && ($groups_LB.isSelected)
			Form.groupSubform.group:=$groups_LB.currentItem
			OBJECT SET SUBFORM(*; "groupSubform"; "group_detail")  // this causes the On load event to fire on the subform
			
	End case 
	
End if 

If ($objectName="tests_LB")
	Case of 
		: (Form event code=On Begin Drag Over) && ($tests_LB.isSelected)
			$obj:=$tests_LB.currentItem.toObject()
			$obj.kind:="testMethod"  //  overwrites the kind for this operation
			SET TEXT TO PASTEBOARD(JSON Stringify($obj))
			
		: (Form event code=On Double Clicked) && ($tests_LB.isSelected)
			METHOD OPEN PATH($tests_LB.currentItem.name; *)
			
	End case 
	
End if 

//mark:  --- update state and formats
If (Form.groupSubform.group=Null)
	OBJECT SET SUBFORM(*; "groupSubform"; "group_empty")
End if 