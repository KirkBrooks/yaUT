/*  TestMethodObj class
 Created by: Kirk Brooks as Designer, Created: 11/18/24, 11:07:15
 ------------------
Class for managing a methodObj. 

  methodObj: {
   "name": <4D method name>,
   "description": "",
   "kind": "",
   "defaultPriority": 1-5  //  use this property for JSON file objects
*/
property name : Text
property description : Text
property kind : Text
property defaultPriority : Integer
property _content : Object

Class constructor($method : Variant; $content : Object)  //  name or methodObj
	Case of 
		: (Value type($method)=Is text)
			This.name:=$method
			This.description:=""
			This.kind:=""
			This.defaultPriority:=1
			
		: (Value type($method)=Is object)
			This.name:=$method.name
			This.description:=String($method.description)
			This.kind:=String($method.kind)
			This.defaultPriority:=Num($method.defaultPriority)
			
		Else 
			ALERT(Current method name+":  bad input")
	End case 
	
	This._content:=$content || {}
	If (This._content.testMethods=Null)
		This._content.testMethods:={}
	End if 
	
	//mark:  --- Functions
Function updateContent
	// content.testMethods is an object
	This._content.testMethods[This.name]:={\
		name: This.name; \
		description: This.description; \
		defaultPriority: This.defaultPriority; \
		kind: This.kind}
	
Function setPriorityMenu
	// popup menu to set priority
	This.defaultPriority:=Pop up menu("1;2;3;4;5")
	This.updateContent()
	