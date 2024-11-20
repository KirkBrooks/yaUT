/*  group_detail - form method
 Created by: Kirk Brooks as Designer, Created: 10/12/24, 11:33:00
 ------------------
Displays a group object. 
 form.group is cs.GroupObj

Form.deleteItem
This object controls the visibility and placement of the red X
BUTTON that appears next to the selected row of a listbox

*/

var $objectName; $text : Text
var $tests_LB; $groups_LB : cs.listbox
var $l; $t; $r; $b; $x; $y : Integer
var $obj : Object
var $col : Collection
var $group; $inclGroup : cs.GroupObj
var $testObj : cs.TestMethodObj
var $API : cs.Groups_API

If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)
$API:=Form.API
$group:=Form.group || cs.GroupObj.new(Form.group)
$tests_LB:=Form.tests_LB || cs.listbox.new("tests_LB")
$groups_LB:=Form.groups_LB || cs.listbox.new("groups_LB")

//mark:  --- form actions
If (FORM Event.code=On Load)  //  catches all objects
	Form.group:=$group
	
	Form.tests_LB:=$tests_LB
	Form.groups_LB:=$groups_LB
	
	$tests_LB.setSource(Form.group.tests)
	$groups_LB.setSource(Form.group.includeGroups)
	OBJECT SET VALUE("tags"; $group.tagsToString())
	
	Form.dropPayload:=Null
	Form.deleteItem:={name: ""; visible: False; x: 0; y: 0}
	
	OBJECT SET HELP TIP(*; "groups_LB"; "Drag other Test Groups here to add to this Group. ")
	OBJECT SET HELP TIP(*; "tests_LB"; "Drag Test Methods here to add to this Group. ")
	OBJECT SET HELP TIP(*; "btn_deleteItem"; "Click to remove selected item from the Group. ")
End if 

If (Form event code=On Drop)  //  get the drop payload
	$text:=Get text from pasteboard
	
	If ($text="{@")
		Form.dropPayload:=JSON Parse($text)
	Else 
		Form.dropPayload:=Null
	End if 
End if 

If (Form event code=On Getting Focus)  // hide the red X
	Form.deleteItem.visible:=False
End if 

If (Form event code=On Data Change)
	$group.updateContent()
End if 

If (Form event code=On Outside Call)
	TRACE
End if 

//mark:  --- object actions
If ($objectName="btn_run")
	TRACE
	$group.run()
End if 

If ($objectName="btn_deleteItem")  //  delete a listbox item
	Case of 
		: (Form event code#On Clicked)  //  only run on clicked
			
		: (Form.deleteItem.name="tests_LB") && ($tests_LB.isSelected)  //  delete selected test(s)
			For each ($testObj; $tests_LB.selectedItems)
				$group.removeTest($testObj.name)
			End for each 
			
			$tests_LB.redraw()
			
		: (Form.deleteItem.name="groups_LB") && ($groups_LB.isSelected)  //  delete selected test(s)
			For each ($inclGroup; $groups_LB.selectedItems)
				$group.removeIncludedGroup($inclGroup.name)
			End for each 
			
			$groups_LB.redraw()
	End case 
End if 

If ($objectName="btn_deleteGroup") && (Form event code=On Clicked)
	$API.removeGroup($group)
	// call form does not generate a form event on the target form
	CALL FORM(Current form window; Formula(Form.groupSubform:={group: Null}))
	CALL FORM(Current form window; Formula(OBJECT SET SUBFORM(*; "groupSubform"; "group_empty")))
	CALL FORM(Current form window; Formula(Form.groups_LB.setSource(Form.API.groups)))
End if 

If ($objectName="tests_LB")
	
	Case of 
		: (Form event code=On Drop) && (Form.dropPayload#Null) && (String(Form.dropPayload.kind)="testMethod") && (Form.dropPayload.tests.length>0)
			For each ($obj; Form.dropPayload.tests)
				$group.addTest($obj.name; $obj.defaultPriority)
			End for each 
			
			Form.dropPayload:=Null
			$tests_LB.redraw()
			
		: ($tests_LB.isSelected) && ((Form event code=On Getting Focus) || (Form event code=On Selection Change))
			LISTBOX GET CELL COORDINATES(*; $objectName; 2; Form[$objectName].position; $l; $t; $r; $b)
			Form.deleteItem.name:=$objectName
			Form.deleteItem.visible:=True
			Form.deleteItem.x:=$r+3
			Form.deleteItem.y:=$t
			
	End case 
	
End if 

If ($objectName="groups_LB")
	
	Case of 
		: (Form event code=On Drop) && (Form.dropPayload#Null) && (String(Form.dropPayload.name)#"")
			$group.addIncludedGroup(Form.dropPayload.name)
			
			Form.dropPayload:=Null
			
		: ($groups_LB.isSelected) && ((Form event code=On Getting Focus) || (Form event code=On Selection Change))
			LISTBOX GET CELL COORDINATES(*; $objectName; 1; Form[$objectName].position; $l; $t; $r; $b)
			Form.deleteItem.name:=$objectName
			Form.deleteItem.visible:=True
			Form.deleteItem.x:=$r+3
			Form.deleteItem.y:=$t
			
	End case 
	
	$groups_LB.redraw()
End if 

If ($objectName="tags") && (Form event code=On Data Change)
	$group.stringToTags(OBJECT Get value("tags"))
End if 

//mark:  --- update state and formats
//  the delete item button
OBJECT SET VISIBLE(*; "btn_deleteItem"; Bool(Form.deleteItem.visible))
If (Form.deleteItem.visible)
	$x:=Form.deleteItem.x
	$y:=Form.deleteItem.y
	OBJECT SET COORDINATES(*; "btn_deleteItem"; $x; $y; $x+20; $y+20)
End if 

