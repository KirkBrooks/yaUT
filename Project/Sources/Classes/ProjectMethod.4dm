/*  ProjectMethod class
 Created by: Kirk Brooks as Designer, Created: 10/19/24, 10:22:49
 ------------------
Class for working with a project method file
Uses a combination of file operations and 4D method manipulations

Writing method code is done on the file level. 
This will commit the changes even when a method is open in the method editor.

The code is not saved in the class. It's accessed from disk for any operations. 

When called from a component will access projects in the HOST.
*/
property name : Text
property _file : 4D.File

Class constructor($methodName : Text)
	$methodName:=Substring($methodName; 1; 31)
	This.name:=$methodName
	$methodName+=".4dm"
	
	If (This._isComponent())
		This._file:=Folder(fk database folder; *).folder("Project/Sources/Methods").file($methodName)
	Else 
		This._file:=Folder(fk database folder).folder("Project/Sources/Methods").file($methodName)
	End if 
	
	//mark:  --- getters
Function get exists : Boolean
	return Bool(This._file.exists)
	
	//mark:  --- attributes
Function getAttributes->$attributes : Object
	If (Not(This.exists))
		return {}
	End if 
	
	METHOD GET ATTRIBUTES(This.name; $attributes; *)
	
Function setAttributes($attributes : Object)
	If (Not(This.exists)) || ($attributes=Null)
		return 
	End if 
	
	METHOD SET ATTRIBUTES(This.name; $attributes; *)
	
Function getPreemptive : Text
	return String(This.getAttributes().preemptive)
	
Function setPreemptive($text : Text)
	This._setAttribute("preemptive"; $text)
	
Function getShared : Boolean
	return Bool(This.getAttributes().shared)
	
Function setShared($bool : Boolean)
	This._setAttribute("shared"; $bool)
	
Function getExeOnSrvr : Boolean
	return Bool(This.getAttributes().executeOnServer)
	
Function setExeOnSrvr($bool : Boolean)
	This._setAttribute("executeOnServer"; $bool)
	
Function getPublishedWeb : Boolean
	return Bool(This.getAttributes().publishedWeb)
	
Function setPublishedWeb($bool : Boolean)
	This._setAttribute("publishedWeb"; $bool)
	
	//mark:  --- functions
Function openEditor()
	If (This.exists)
		METHOD OPEN PATH(This.name; *)
	End if 
	
Function showOnDisk()
	If (This.exists)
		SHOW ON DISK(This._file.platformPath)
	End if 
	
Function getCode() : Text
	If (Not(This.exists))
		return ""
	End if 
	
	return This._file.getText()
	
Function setCode($code : Text)
	//  this will create the method if it doesn't exist already
	If (This._file=Null)
		return 
	End if 
	This._file.setText($code)
	RELOAD PROJECT  // will update code if method editor is open
	
Function copyTo($folder : 4D.Folder) : Boolean
	// copies the method to the destination folder
	var $copiedFile : 4D.File
	
	If (Not(This.exists)) || ($folder=Null) || (Not($folder.exists))
		return False
	End if 
	
	$copiedFile:=This._file.copyTo($folder)
	return ($copiedFile#Null) && ($copiedFile.exists)
	
	//mark:  --- Private
Function _setAttribute($attr : Text; $value)
	var $attributes : Object
	If (Not(This.exists)) && ($attr#"") && ($value#Null)
		return 
	End if 
	
	$attributes:=This.getAttributes()
	$attributes[$attr]:=$value
	This.setAttributes($attributes)
	
Function _isComponent : Boolean
	return (Structure file#Structure file(*))