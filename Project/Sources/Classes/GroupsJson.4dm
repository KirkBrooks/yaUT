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
property content : Object
property validJson : Boolean
property jsonPath : Text

Class constructor
	If (isComponent)
		This.jsonPath:=Folder(fk resources folder; *).folder("yaUT").file("groups.json").path
	Else 
		This.jsonPath:=Folder(fk resources folder).folder("yaUT").file("demo_groups.json").path
	End if 
	This.getJsonContent()
	
	
	//mark:  --- getters
	
Function get testMethods : Object
	return This.validJson ? This.content.testMethods : {}
	
Function get testGroups : Object
	return This.validJson ? This.content.testGroups : {}
	
	//mark:  --- Functions
Function saveContent : cs.GroupsJson
	var $class : cs.JsonDocument
	$class:=cs.JsonDocument.new(This.jsonPath)
	$class.content:=This.content
	$class.writeObject()
	return This
	
Function getTest($methodName : Text) : Object
	// return the testMethod object or null
	return This.testMethods[$methodName]
	
Function getGroup($groupName : Text) : Object
	return This.testGroups[$groupName]
	
Function putTest($method : Variant) : cs.GroupsJson
	//  adds/updates goups.testMethods with $methodName
	// method is either a method name or a testObject
	// we don't udate 4D code here
	var $methodObj : Object
	var $methodName; $code : Text
	
	Case of 
		: (Value type($method)=Is object)
			$methodName:=$method.name
			
		: (Value type($method)=Is text)
			$methodName:=$method
			
		Else 
			return This
	End case 
	
	If ($methodName#"yaUT_@")
		$methodName:=Substring("yaUT_"+$methodName; 1; 31)
	End if 
	
	$methodObj:=This.getTest($methodName)  // may be null = not on list
	$code:=This.getTestCode($methodName)  //  may be empty = need to create method
	
	If (Value type($method)=Is object)
		// could be an update or new test
		If ($methodObj=Null)
			$methodObj:=This._testObject($methodName)
		End if 
		
		$methodObj:=This._updateObj($methodObj; $method)
		This.testMethods[$methodName]:=$methodObj
		This.saveContent()
	End if 
	
	If (Value type($method)=Is text) && ($methodObj=Null)
		// create new default 
		$methodObj:=This._testObject($methodName)
		This.testMethods[$methodName]:=$methodObj
		This.saveContent()
	End if 
	// create the method stub is there's nothing there alerady
	If ($code="")
		Util_createTestMethod($methodName; $methodObj)
	End if 
	
	return This
	
Function getTestCode($methodName : Text)->$code : Text
	ARRAY TEXT($aNames; 0)
	METHOD GET NAMES($aNames; $methodName; *)
	
	If ($methodName="") || ($code="")
		return ""
	End if 
	
	METHOD GET CODE($methodName; *)
	
Function putGroup($group : Variant) : cs.GroupsJson
	//  groups don't have 4D code
	var $groupObj : Object
	
	If (Value type($group)=Is object)
		//  create or update
		$groupName:=$group.name
		$groupObj:=This.testGroups[$groupName] || This._groupObject($groupName)
		
		$groupObj:=This._updateObj($groupObj; $group)
		Use (This.testGroups)
			This.testGroups[$groupName]:=$groupObj
		End use 
		
		This.saveContent()
		return This
	End if 
	
	
	If (Value type($group)=Is text) && (This.testGroups[$group]=Null)
		$groupObj:=This._groupObject($group)
		This.testGroups[$group]:=$groupObj
		This.saveContent()
		return This
	End if 
	
Function get4Dmethods : cs.GroupsJson
	//  update testMethods with any 4D methods not on the list
	// - do not remove any methods from testMethods
	ARRAY TEXT($aNames; 0)
	METHOD GET NAMES($aNames; "yaUT_@")
	
Function getJsonContent
	var $class : cs.JsonDocument
	$class:=cs.JsonDocument.new(This.jsonPath)
	
	Use (Storage.groupsJson)
		Storage.groupsJson.content:=OB Copy($class.content; ck shared)
		This.validJson:=(This.content#Null)
	End use 
	
	//mark:  --- private
Function _setTestGroup($groupName : Text; $groupObj : Object)
	Use (This.testGroups)
		This.testGroups[$groupName]:=$groupObj
	End use 
	
Function _setTestGroup
	
	
Function _updateObj($a : Object; $b : Object)
	// update $a values to $b
	var $key : Text
	
	For each ($key; $a)
		If ($b[$key]#Null)
			$a[$key]:=$b[$key]
		End if 
	End for each 
	
Function _testObject($methodName : Text) : Object
	//  basic object for testMethods
	return {name: $methodName; defaultPriority: 2; description: ""; kind: "smoke"}
	
Function _groupObject($groupName : Text) : Object
	return {name: $groupName; description: ""; tags: ""; tests: []; includeGroups: []}
	