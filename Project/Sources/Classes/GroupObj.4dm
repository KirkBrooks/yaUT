/*  GroupObj class
 Created by: Kirk Brooks as Designer, Created: 11/18/24, 10:42:07
 ------------------
Class for managing a groupObj. 
This doesn't read or write from the content

  groupObj:  {
   "name": <groupName>,   //  required and must be unique
   "description": "",
   "tags": ["",""],
   "tests": [ {name: <method name>; priority: 1-5}, ...],
   "includeGroups": [<groupName>]  //  
   }
*/
property name : Text
property description : Text
property tags : Collection
property tests : Collection
property includeGroups : Collection
property _content : Object

Class constructor($group : Variant; $content : Object)  //  name or groupObj
	Case of 
		: (Value type($group)=Is text)
			This.name:=$group
			This.description:=""
			This.tags:=[]
			This.tests:=[]
			This.includeGroups:=[]
			
		: (Value type($group)=Is object)
			This.name:=$group.name
			This.description:=String($group.description)
			This.tags:=$group.tags || []
			This.tests:=$group.tests || []
			This.includeGroups:=$group.includeGroups || []
			
		Else 
			ALERT(Current method name+":  bad input")
	End case 
	
	This._content:=$content || {}
	If (This._content.testGroups=Null)
		This._content.testGroups:={}
	End if 
	
Function updateContent
	// content.testGroups is an object
	This._content.testGroups[This.name]:={\
		name: This.name; \
		description: This.description; \
		tags: This.tags; \
		tags: This.tests; \
		tags: This.includeGroups}
	
	//mark:  --- Tests
Function getTestNames : Collection
	return This.tests.extract("name")
	
Function addTest($name : Text; $priority : Integer)
	If (This.tests.query("name = :1"; $name).first()#Null)
		return 
	End if 
	This.tests.push({name: $name; priority: $priority || 1})
	This.updateContent()
	
Function removeTest($name : Text)
	var $i : Integer
	$i:=This.tests.findIndex(Formula($1.value.name=$2); $name)
	If ($i=-1)
		return 
	End if 
	This.tests.remove($i)
	This.updateContent()
	
	//mark:  --- Tags
Function addTag($tag : Text)
	If (This.tags.indexOf($tag)=-1)
		This.tags.push($tag)
		This.updateContent()
	End if 
	
Function removeTag($tag : Text)
	If (This.tags.indexOf($tag)>-1)
		This.tags.remove(This.tags.indexOf($tag))
		This.updateContent()
	End if 
	
	//mark:  --- Groups
Function addIncludedGroup($groupName : Text)
	If (This.includeGroups.indexOf($groupName)=-1)
		This.includeGroups.push($groupName)
		This.updateContent()
	End if 
	
Function removeIncludedGroup($groupName : Text)
	If (This.includeGroups.indexOf($groupName)>-1)
		This.includeGroups.push(This.includeGroups.indexOf($groupName))
		This.updateContent()
	End if 
	