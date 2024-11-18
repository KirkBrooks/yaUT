/*  GroupObj class
 Created by: Kirk Brooks as Designer, Created: 11/18/24, 10:42:07
 ------------------
Class for managing a groupObj. 
This doesn't read or write from the content

  methodObj: {
   "name": <4D method name>,
   "description": "",
   "kind": "",
   "defaultPriority": 1-5  //  use this property for JSON file objects
  }
*/
property name : Text
property description : Text
property tags : Collection
property tests : Collection
property includeGroups : Collection

Class constructor($group : Variant)  //  name or groupObj
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
	
	//mark:  --- Tests
Function getTestNames : Collection
	return This.tests.extract("name")
	
Function addTest($name : Text; $priority : Integer)
	If (This.tests.query("name = :1"; $name).first()#Null)
		return 
	End if 
	This.tests.push({name: $name; priority: $priority || 1})
	
Function removeTest($name : Text)
	var $i : Integer
	$i:=This.tests.findIndex(Formula($1.value.name=$2); $name)
	If ($i=-1)
		return 
	End if 
	This.tests.remove($i)
	
	//mark:  --- Tags
Function addTag($tag : Text)
	If (This.tags.indexOf($tag)=-1)
		This.tags.push($tag)
	End if 
	
Function removeTag($tag : Text)
	If (This.tags.indexOf($tag)>-1)
		This.tags.remove(This.tags.indexOf($tag))
	End if 
	
	//mark:  --- Groups
Function addIncludedGroup($groupName : Text)
	If (This.includeGroups.indexOf($groupName)=-1)
		This.includeGroups.push($groupName)
	End if 
	
Function removeIncludedGroup($groupName : Text)
	If (This.includeGroups.indexOf($groupName)>-1)
		This.includeGroups.push(This.includeGroups.indexOf($groupName))
	End if 
	