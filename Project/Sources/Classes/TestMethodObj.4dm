/*  TestMethodObj class
 Created by: Kirk Brooks as Designer, Created: 11/18/24, 11:07:15
 ------------------
Class for managing a methodObj. 

  methodObj: {
   "name": <4D method name>,
   "description": "",
   "kind": "",
   "defaultPriority": 1-5  //  use this property for JSON file objects
*/
property name : Text
property description : Text
property kind : Text
property defaultPriority : Integer
property _content : Object
property _API : cs.Groups_API
property _4Dname : Text
property isRun : Boolean  //  see:  GroupObj.run
property runPass : Boolean
property runResults : Collection

Class constructor($method : Variant; $api : cs.Groups_API)  //  name or methodObj
	This._API:=$api
	This.isRun:=False
	This._content:=$api.content || {}
	If (This._content.testMethods=Null)
		This._content.testMethods:={}
	End if 
	
	Case of 
		: (Value type($method)=Is text)
			This.name:=$method
			This.description:=""
			This.kind:=""
			This.defaultPriority:=1
			
		: (Value type($method)=Is object)
			This.name:=$method.name
			This.description:=String($method.description)
			This.kind:=String($method.kind)
			This.defaultPriority:=Num($method.defaultPriority)
			
		Else 
			ALERT(Current method name+":  bad input")
	End case 
	
/*  because the names are case sensitive in the JSON but not
for 4D methods we first check if there is a 4D method and use
that capitalization. 
*/
	
	Case of 
		: (This.getMethodExists())\
			 && (Compare strings(This._4Dname; This.name)#0)\
			 && (This._content.testMethods[This.name]=Null)\
			 && (This._content.testMethods[This._4Dname]=Null)
			// the names are different but this name isn't in the Json
			//  use the 4D method name for the JSON
			This.name:=This._4Dname
			This._content.testMethods[This.name]:=This.toObject()
			This.updateContent()
			
		: (This.getMethodExists())\
			 && (Compare strings(This._4Dname; This.name)=0)\
			 && (This._content.testMethods[This.name]=Null)
			// the names match but this name isn't in the Json
			This._content.testMethods[This.name]:=This.toObject()
			This.updateContent()
			
		: (Not(This.getMethodExists()))
			// create it
			Util_createTestMethod(This.toObject())
			This._4Dname:=This.name
			
			If (This._content.testMethods[This.name]=Null)
				This._content.testMethods[This.name]:=This.toObject()
				This.updateContent()
			End if 
			
		Else 
			//todo: the method exists i 4D and the json but the json
			// has more than one capitalization...  
	End case 
	
	
	//mark:  --- Functions
Function run() : Boolean
	//  run the method
	var $results : Collection
	
	If (Not(This.isRun))
		EXECUTE METHOD(This.name; $results)
		
		This.isRun:=True
		This.runPass:=($results.query("pass = :1"; False).length=0)
		This.runResults:=$results
	End if 
	
	
Function updateContent
	// content.testMethods is an object
	This._content.testMethods[This.name]:=This.toObject()
	If (This._API#Null)
		This._API.saveContent()
	End if 
	
Function toObject : Object
	// return data in content form
	return {\
		name: This.name; \
		description: This.description; \
		defaultPriority: This.defaultPriority; \
		kind: This.kind}
	
Function setPriorityMenu
	// popup menu to set priority
	This.defaultPriority:=Priority_chooseByMenu
	This.updateContent()
	
Function getMethodExists : Boolean
	ARRAY TEXT($aNames; 0)
	METHOD GET NAMES($aNames; This.name)
	If (Size of array($aNames)=1)
		This._4Dname:=$aNames{1}
	Else 
		This._4Dname:=""
	End if 
	return This._4Dname#""
	
Function create4Dmethod($testCollection : Collection)
	var $obj : Object
	
	If (This.getMethodExists())
		return 
	End if 
	
	$obj:=This.toObject()
	$obj.tests:=$testCollection
	Util_createTestMethod($obj)
	
Function getMethodInfo
	//  updates this object to the description, kind and priority to what's in the method
	var $code; $description; $line : Text
	var $lines : Collection
	var $isDesc : Boolean
	
	METHOD GET CODE(This.name; $code; *)
	
	$lines:=Split string($code; "\r"; sk ignore empty strings+sk trim spaces)
	
	//  just loop through the lines
	For each ($line; $lines)
		
		Case of 
			: ($isDesc)
				// within or end of the description
				$isDesc:=$line#"*\\@"
				
				If ($isDesc)
					$description+="\n"+$line
				Else 
					This.description:=$description
				End if 
				
			: ($line="// Kind:@")
				This.kind:=Split string($line; ":"; sk trim spaces)[1]
			: ($line="// Priority:@")
				This.priority:=Num(Split string($line; ":"; sk trim spaces)[1])
			: ($line="/* Description:@")  //  start of the description
				$description:=Split string($line; ":"; sk trim spaces)[1]
		End case 
		
	End for each 
	
Function updateMethodInfo
	//  updates the 4D with to this the description, kind and priority
	