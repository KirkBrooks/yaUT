/*  group_detail - form method
 Created by: Kirk Brooks as Designer, Created: 10/12/24, 11:33:00
 ------------------
Displays a group object. 
 form.group is cs.GroupObj
*/

var $objectName; $text : Text
var $tests_LB; $groups_LB : cs.listbox
var $l; $t; $r; $b; $x; $y : Integer
var $obj : Object
var $group : cs.GroupObj

If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)

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
End if 

If (Form event code=On Drop)  //  get the drop payload
	$text:=Get text from pasteboard
	
	If ($text="{@")
		Form.dropPayload:=JSON Parse($text)
	Else 
		Form.dropPayload:=Null
	End if 
End if 

If (Form event code=On Getting Focus)  // && (Form.deleteItem.name=$objectName)
	Form.deleteItem.visible:=False
End if 

If (Form event code=On Data Change)
	$group.updateContent()
End if 

//mark:  --- object actions
If ($objectName="btn_deleteItem")  //  delete a listbox item
	Case of 
		: (Form event code#On Clicked)  //  only run on clicked
			
		: (Form.deleteItem.name="tests_LB") && ($tests_LB.isSelected)  //  delete selected test(s)
			Form.group.tests.remove($tests_LB.index)
			Form._jsonDoc.writeObject(Form.content)
			
		: (Form.deleteItem.name="groups_LB") && ($groups_LB.isSelected)  //  delete selected test(s)
			Form.group.includeGroups.remove($groups_LB.index)
			Form._jsonDoc.writeObject(Form.content)
			
	End case 
End if 

If ($objectName="btn_deleteGroup") && (Form event code=On Clicked)
	OB REMOVE(Form.content.testGroups; Form.group.name)
	Form.group:=Null
	Form._jsonDoc.writeObject(Form.content)
	CALL FORM(Current form window; Formula(Form.groups_LB.setSource(OB Keys(Form.content.testGroups))))
End if 

If ($objectName="tests_LB")
	
	Case of 
		: (Form event code=On Drop) && (Form.dropPayload#Null) && (String(Form.dropPayload.kind)="testMethod")
			$group.addTest(Form.dropPayload.name; Form.dropPayload.defaultPriority)
			
			Form.dropPayload:=Null
			
		: ($tests_LB.isSelected) && ((Form event code=On Getting Focus) || (Form event code=On Selection Change))
			LISTBOX GET CELL COORDINATES(*; $objectName; 1; Form[$objectName].position; $l; $t; $r; $b)
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
			
		: ($tests_LB.isSelected) && ((Form event code=On Getting Focus) || (Form event code=On Selection Change))
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

