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
property _groups; _tests : Collection  // collections of the classes for each object

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
	
	//mark:  --- JSON content
Function saveContent : cs.GroupsJson
	var $class : cs.JsonDocument
	$class:=cs.JsonDocument.new(This.jsonPath)
	$class.content:=This.content
	$class.writeObject()
	return This
	
Function _updateContent
	// update content with _groups and _tests
	
Function getJsonContent
	// get the content from the jsonPath document
	var $class : cs.JsonDocument
	$class:=cs.JsonDocument.new(This.jsonPath)
	This.content:=$class.content
	This.fileName:=$class.fullName
	This._populateGroups()
	This._populateTests()
	This._validateJson()
	
	//mark:  --- GROUPS
Function _populateGroups
	//  updates this._groups with current this.content
	var $groupName : Text
	This._groups:=[]
	For each ($groupName; This.content.testGroups)  // tesstGroups is an OBJECT
		This._groups.push(cs.GroupObj.new(This.content.testGroups[$groupName]; This.content))
	End for each 
	
	//mark:  --- TESTS
Function _populateTests
	var $methodName : Text
	This._tests:=[]
	For each ($methodName; This.content.testMethods)  // testMethods is an OBJECT
		This._tests.push(cs.TestMethodObj.new(This.content.testMethods[$methodName]; This.content))
	End for each 
	
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
	