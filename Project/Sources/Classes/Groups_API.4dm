/*  Groups_API class
 Created by: Kirk Brooks as Designer, Created: 11/18/24, 10:28:46
 ------------------
This class is an API for groups.json, which defines the 
Groups of test methods. 

This API provides: 
- Managing Groups.
   Groups may contain a list of test methods as well as other Groups
   Groups can be run and logged
   The idea is to be able to create groups of tests for specific modules

- Test Methods
   The api syncs the 4D test methods with the Json. This allows you to 
   create test methods form the Groups form with or without the test code. 
   The idea being you can design a test group then build out the methods for it

- Sync comments, priority and test kind
   These attributes can be set in the form and will update the 4D method code

DEFS
  groupObj:  {
   "name": <groupName>,   //  required and must be unique
   "description": "",
   "tags": ["",""],
   "tests": [ {name: <method name>; priority: 1-5}, ...],
   "includeGroups": [<groupName>]  //  
   }

  methodObj: {
   "name": <4D method name>,
   "description": "",
   "kind": "",
   "defaultPriority": 1-5
  }
*/

property content : Object
property jsonPath; fileName : Text
property _schema; _validation : Object
property groups; tests : Collection  // collections of the classes for each object

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
	
	
	
	//mark:  --- JSON content
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
	
	If ($class.exists=False)
		// need to define a new, empty one using this name
		$class.writeObject({version: "2.2"; \
			lastUpdated: Timestamp; \
			validated: True; \
			testMethods: {}; \
			testGroups: {}})
		
		ALERT($class.fullName+" was not found. A new file has been created.")
		TRACE
	End if 
	
	This.content:=$class.content
	This.fileName:=$class.fullName
	This._populateGroups()
	This._populateTests()
	This._validateJson()
	
	//mark:  --- GROUPS
	// to execute a group use the Group_run method
Function _populateGroups
	//  updates this.groups with current this.content
	var $groupName : Text
	This.groups:=[]
	For each ($groupName; This.content.testGroups)  // testGroups is an OBJECT
		This.groups.push(cs.GroupObj.new(This.content.testGroups[$groupName]; This))
	End for each 
	
Function addGroup($group : Variant)
	var $obj : Object
	$obj:=This._groupObj($group)
	
	If (This.content.testGroups[$obj.name]=Null)
		This.content.testGroups[$obj.name]:=cs.GroupObj.new($obj).toObject()  // handles the tags
		This.saveContent()
		This._populateGroups()
	End if 
	
Function removeGroup($group : Variant)
	var $obj : Object
	$obj:=This._groupObj($group)
	If ($obj=Null) || (This.content.testGroups[$obj.name]=Null)
		return 
	End if 
	
	OB REMOVE(This.content.testGroups; $obj.name)
	This.saveContent()
	This._populateGroups()
	
Function _groupObj($group : Variant)->$obj : Object
	Case of 
		: (Value type($group)=Is text)
			$obj:={name: $group}
		: (Value type($group)=Is object) && (OB Instance of($group; cs.GroupObj))
			$obj:=$group.toObject()
		: (Value type($group)=Is object)
			$obj:=$group
		Else 
			return 
	End case 
	
	
	//mark:  --- TESTS
Function _populateTests
	var $methodName : Text
	This.tests:=[]
	For each ($methodName; This.content.testMethods)  // testMethods is an OBJECT
		This.tests.push(cs.TestMethodObj.new(This.content.testMethods[$methodName]; This))
	End for each 
	
Function addTest($method)
/* sort of a big deal
We have to check that it's a valid name, then 
make sure it's in the JSON and there is a 4D method for it
*/
	var $testObj : cs.TestMethodObj
	
	// does it exist in the Content?
	$testObj:=cs.TestMethodObj.new($method; This)  //  adds and updates content if it's not there
	
	This._populateTests()
	
Function sync4Dmethods
/*  audit the list of methods in the JSON with
methods in 4D. 
*/
	var $i : Integer
	var $methodName : Text
	
	ARRAY TEXT($aNames; 0)
	METHOD GET NAMES($aNames; "yaUT_@"; *)
	
	For ($i; 1; Size of array($aNames))
		$methodName:=$aNames{$i}
		
		If (This.tests[$methodName]=Null)
			
		End if 
	End for 
	
	//mark:  --- reporting and UI
	
	
	
	//mark:  --- private
Function _validateJson
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
	
Function 