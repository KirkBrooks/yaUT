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

If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)
$tests_LB:=Form.tests_LB || cs.listbox.new("tests_LB")
$groups_LB:=Form.groups_LB || cs.listbox.new("groups_LB")

//mark:  --- form actions
If (FORM Event.code=On Load)  //  catches all objects
	$file:=Folder(fk resources folder; *).folder("yaUT").file("demo_groups.json")
	Form._jsonDoc:=cs.JsonDocument.new($file.path)
	Form.content:=Form._jsonDoc.getObject()
	
	$tests_LB.setSource(OB Keys(Form.content.testMethods))
	$groups_LB.setSource(OB Keys(Form.content.testGroups))
	
	Form.tests_LB:=$tests_LB
	Form.groups_LB:=$groups_LB
	
	
	Form.groupSubform:={_jsonDoc: Form._jsonDoc; content: Form.content; group: Null}
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
		
		// is this a unique group name?
		If (Form.content.testGroups[$obj.name]=Null)
			Form.content.testGroups[$obj.name]:=$obj
			Form._jsonDoc.writeObject(Form.content)  //  update the json file
			$groups_LB.setSource(OB Keys(Form.content.testGroups))
			
		End if 
	End if 
End if 

If ($objectName="btn_addTest")
	
	$x:=5
	$y:=98
	CONVERT COORDINATES($x; $y; XY Current form; XY Screen)
	$obj:=Group_enterNew($x; $y)
End if 

If ($objectName="groups_LB")
	
	Case of 
		: (Form event code=On Begin Drag Over) && ($groups_LB.isSelected)
			$text:=$groups_LB.get_item()
			$obj:={kind: "testGroup"; name: $text; properties: Form.content.testGroups[$text]}
			SET TEXT TO PASTEBOARD(JSON Stringify($obj))
			
		: (Form event code=On Double Clicked) && ($groups_LB.isSelected)
			$name:=$groups_LB.get_item()
			Form.groupSubform.group:=Form.content.testGroups[$name]
			
			OBJECT SET SUBFORM(*; "groupSubform"; "group_detail")  // this causes the On load event to fire on the subform
			
	End case 
	
End if 

If ($objectName="tests_LB")
	Case of 
		: (Form event code=On Begin Drag Over) && ($tests_LB.isSelected)
			$text:=$tests_LB.get_item()
			$obj:={kind: "testMethod"; name: $text; properties: Form.content.testMethods[$text]}
			SET TEXT TO PASTEBOARD(JSON Stringify($obj))
			
		: (Form event code=On Double Clicked) && ($tests_LB.isSelected)
			$text:=$tests_LB.get_item()
			// open the method
			METHOD OPEN PATH($text; *)
			
	End case 
	
End if 

//mark:  --- update state and formats
If (Form.groupSubform.group=Null)
	OBJECT SET SUBFORM(*; "groupSubform"; "group_empty")
End if 