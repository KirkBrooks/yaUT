/*  TestMethodObj class
 Created by: Kirk Brooks as Designer, Created: 11/18/24, 11:07:15
 ------------------
Class for managing a methodObj. 
This doesn't read or write from the content

*/
property name : Text
property description : Text
property kind : Text
property defaultPriority : Integer

Class constructor($method : Variant)  //  name or methodObj
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
	
	//mark:  --- Functions
	