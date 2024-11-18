/*  GroupsJson class
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 10:16:22
 ------------------
Subclass of JsonDocument
API for editing the groups.json file and data. 

What we do here is:
- manage editing the groups definitions
- sync the testMethods in the JSON with actual 4D test methods
- verify the resulting JSON validates 

$methodObj is element of This.content.testMethods. 
It is defined in the json file and should have a 4D method

ex: "yaUT_TestUserRegistration": {
      "name": "yaUT_TestUserRegistration",
      "description": "Verifies that a new user can successfully register",  //  syncs with 4D method comments
      "kind": "functional",  
      "defaultPriority": 1
     }

Hierarchy 
 - $methodObj exists & $code=""  // create the method with $methodObj comments
 - $methodObj null & $code=""    // create the method AND $methodObj: $method comments
 - $methodObj null & $code#""    // create $methodObj w/ comments from $code
 - $methodObj exists & $code#""  // sync comments - if editing $methodObj udpate code; if editing 4D method update $methodObj commenets

*/
property content : Object
property jsonPath; fileName : Text
property _schema; _validation : Object

Class constructor($path : Text)
	This.fileName:="undefined"
	
	Case of 
		: ($path#"")  //  use this one if defined
			This.jsonPath:=$path
		: (isComponent)  // always use the one on the Host when a component
			This.jsonPath:=Folder(fk resources folder; *).folder("yaUT").file("groups.json").path
		Else   // development
			This.jsonPath:=Folder(fk resources folder).folder("yaUT").file("demo_groups.json").path
	End case 
	
	This.getJsonContent()
	
	
	//mark:  --- getters
Function get validJson : Boolean
	If (This._validation=Null)
		return False
	Else 
		return Bool(This._validation.success)
	End if 
	
Function get testMethods : Object
	return This.content.testMethods
	
Function get testGroups : Object
	return This.content.testGroups
	
Function get methodCount : Integer
	return OB Keys(This.testMethods).length
	
Function get groupCount : Integer
	return OB Keys(This.testGroups).length
	
	
	//mark:  --- Functions
Function saveContent : cs.GroupsJson
	var $class : cs.JsonDocument
	$class:=cs.JsonDocument.new(This.jsonPath)
	$class.content:=This.content
	$class.writeObject()
	return This
	
Function getJsonContent
	// get the content from the jsonPath document
	var $class : cs.JsonDocument
	$class:=cs.JsonDocument.new(This.jsonPath)
	This.content:=$class.content
	This.fileName:=$class.fullName
	This._validateJson()
	
	//  TESTS
Function testObject($methodName : Text) : Object
	//  basic object for testMethods
	return {name: $methodName; defaultPriority: 2; description: ""; kind: "smoke"}
	
Function getTest($methodName : Text) : Object
	// return the testMethod object or null
	return This.testMethods[$methodName] || Null
	
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
			$methodObj:=This.testObject($methodName)
		End if 
		
		This._UpdateObj($methodObj; $method)
		This.testMethods[$methodName]:=$methodObj
		This.saveContent()
	End if 
	
	If (Value type($method)=Is text) && ($methodObj=Null)
		// create new default 
		$methodObj:=This.testObject($methodName)
		This.testMethods[$methodName]:=$methodObj
		This.saveContent()
	End if 
	// create the method stub is there's nothing there alerady
	If ($code="")
		Util_createTestMethod($methodObj)
	End if 
	
	return This
	
	//  GROUPS
Function groupObject($groupName : Text) : Object
	return {name: $groupName; description: ""; tags: []; tests: []; includeGroups: []}
	
Function getGroup($groupName : Text) : Object
	return This.testGroups[$groupName]
	
Function putGroup($group : Variant) : cs.GroupsJson
	//  groups don't have 4D code
	var $groupObj : Object
	var $groupName : Text
	
	If (Value type($group)=Is object)
		//  create or update
		$groupName:=$group.name
		$groupObj:=This.testGroups[$groupName] || This.groupObject($groupName)
		
		This._UpdateObj($groupObj; $group)
		Use (This.testGroups)
			This.testGroups[$groupName]:=$groupObj
		End use 
		
		This.saveContent()
		return This
	End if 
	
	If (Value type($group)=Is text) && (This.testGroups[$group]=Null)
		// $group is group name
		$groupObj:=This.groupObject($group)
		This.testGroups[$group]:=$groupObj
		This.saveContent()
		return This
	End if 
	
	
Function getGroupTests($groupName : Text) : Collection
	return This._getGroupCol("includeGroups")
	
Function putGroupTests($groupName : Text; $tests : Collection) : cs.GroupsJson
	// $tests may be empty but not null
	This._putGroupCol($groupName; "tests"; $tests)
	return This
	
Function getGroupIncludes($groupName : Text) : Collection
	return This._getGroupCol("includeGroups")
	
Function putGroupIncludes($groupName : Text; $includeGroups : Collection) : cs.GroupsJson
	This._putGroupCol($groupName; "tests"; $includeGroups)
	return This
	
	//  4D METHOD
Function getTestCode($methodName : Text)->$code : Text
	return cs.ProjectMethod.new($methodName).getCode()
	
Function putTestCode($methodName : Text; $code : Text) : cs.ProjectMethod
	return cs.ProjectMethod.new($methodName).setCode($code)
	
Function get4Dmethods : cs.GroupsJson
	//  update testMethods with any 4D methods not on the list
	// - do not remove any methods from testMethods
	ARRAY TEXT($aNames; 0)
	METHOD GET NAMES($aNames; "yaUT_@")
	
	
	
Function updateTestComments($methodObj : Object) : cs.GroupsJson
	//  the method must follow conventions, see:  Util_createTestMethodCode
	// $methodObj: {name: ""; description: ""; defaultPriority: 0; kind: ""}  
	
	
	
	//mark:  --- private
Function _setTestGroup($groupName : Text; $groupObj : Object)
	Use (This.testGroups)
		This.testGroups[$groupName]:=$groupObj
	End use 
	
Function _UpdateObj($a : Object; $b : Object)
	// update $a values to match $b
	var $key : Text
	
	For each ($key; $a)
		If ($b[$key]#Null)
			$a[$key]:=$b[$key]
		End if 
	End for each 
	
Function _putGroupCol($groupName : Text; $attribute : Text; $col : Collection)
	//  handle updating group tests and includeGroups collections
	var $obj : Object
	$obj:=This.getGroup($groupName)
	
	If ($obj#Null) && (Value type($col)=Is collection)
		$obj[$attribute]:=$col
		This.saveContent()
	End if 
	
Function _getGroupCol($groupName : Text; $attribute : Text) : Collection
	var $obj : Object
	$obj:=This.getGroup($groupName)
	
	Case of 
		: ($obj=Null)
			return []
		: ($obj[$attribute]=Null)
			return []
		Else 
			return $obj[$attribute]
	End case 
	
Function _validateJson
	//
	var $file : 4D.File
	
	If (This.content=Null)
		This._validation:={success: False; errors: [{message: "No content"}]}
		return 
	End if 
	
	If (This._schema=Null)
		$file:=Folder(fk resources folder).folder("yaUT").file("groupsSchema.json")
		If ($file.exists)
			This._schema:=JSON Parse($file.getText())
		Else 
			This._schema:={}
		End if 
	End if 
	
	This._validation:=JSON Validate(This.content; This._schema)
	