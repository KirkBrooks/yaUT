/*  GroupsJson class
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 10:16:22
 ------------------
Subclass of JsonDocument
Singleton class for managing the groups.json file and data

Hierarchy 
 - $methodObj exists & $code=""  // create the method with $methodObj comments
 - $methodObj null & $code=""  // create the method AND $methodObj: $method comments
 - $methodObj null & $code#""  // create $methodObj comments from $code
 - $methodObj exists & $code#""  // 
*/
Class extends JsonDocument

Class constructor
	If (isComponent)
		Super(Folder(fk resources folder; *).folder("yaUT").file("groups.json").path)
	Else 
		Super(Folder(fk resources folder).folder("yaUT").file("demo_groups.json").path)
	End if 
	
	//mark:  --- Functions
Function saveContent : cs.GroupsJson
	This.writeObject()
	return This
	
Function getTest($methodName : Text) : Object
	// return the testMethod object or null
	return This.content.testMethods[$methodName]
	
Function putTest($methodName : Text; $options : Object) : cs.GroupsJson
	//  adds/updates goups.testMethods with $methodName
	var $methodObj : Object
	var $code : Text
	$methodObj:=This.getTest($methodName)
	$code:=This.getTestCode($methodName)
	
	Case of 
		: ()  // 
	End case 
	
	return This
	
Function getTestCode($methodName : Text)->$code : Text
	ARRAY TEXT($aNames; 0)
	METHOD GET NAMES($aNames; $methodName; *)
	
	If ($methodName="") || ($code="")
		return ""
	End if 
	
	METHOD GET CODE($methodName; *)
	