/*  JsonDocument class
 Created by: Kirk Brooks as Designer, Created: 10/12/24, 16:21:29
 ------------------
 API for reading/writing to a JSON file

*/
property file : 4D.File
property content : Object

Class constructor($path : Text)
	This.file:=File($path)
	This.content:=This.getObject()
	
Function get exists : Boolean
	return Bool(This.file.exists)
	
Function get name : Text
	return This.file=Null ? "" : This.file.name
	
Function get fullName : Text
	return This.file=Null ? "" : This.file.fullName
	
Function get path($option : Integer) : Text
	If ($option=fk posix path)
		return This.file=Null ? "" : This.file.path
	Else 
		return This.file=Null ? "" : This.file.platformPath
	End if 
	
Function getObject() : Object
	If (Not(This.exists)) || (This.file.isFile=False)
		return Null
	End if 
	
	return JSON Parse(This.file.getText())
	
Function writeObject($content : Object)
	// will write this.content 
	If (This.file=Null) || (This.file.isFile=False)
		return 
	End if 
	
	If ($content=Null)
		$content:=This.content
	End if 
	
	This.file.setText(JSON Stringify($content; *))
	