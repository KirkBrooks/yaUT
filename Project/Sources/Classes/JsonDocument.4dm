/*  JsonDocument class
 Created by: Kirk Brooks as Designer, Created: 10/12/24, 16:21:29
 ------------------
 For reading/writing to a JSON file

*/
property file : 4D.File
property content : Object

Class constructor($path : Text)
	This.file:=File($path)
	
Function get exists : Boolean
	return Bool(This.file.exists)
	
Function getObject() : Object
	If (Not(This.exists)) || (This.file.isFile=False)
		return Null
	End if 
	
	return JSON Parse(This.file.getText())
	
Function writeObject($content : Object)
	If (This.file=Null) || (This.file.isFile=False)
		return 
	End if 
	
	This.file.setText(JSON Stringify($content; *))
	