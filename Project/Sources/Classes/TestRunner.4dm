/*  TestRunner class
 Created by: Kirk Brooks as Designer, Created: 10/14/24, 07:08:15
 ------------------
Manage assembling a list of tests and groups
Run the list of tests
Support reporting, analysis and logging 

list:   {
   kind: <test|group>;
   name: <>;
   groups: [];
   tests: []; 
   pass: <bool>;
   message: "" }

ADDING LIST ITEMS
When kind=group:
   lookup the group definition in the json.doc



*/
property list : Collection  //  list of tests and groups
property _groupJson : cs.GroupsJson
property _content : Object

Class constructor
	This.list:=[]
	This._groupJson:=cs.GroupsJson.new()
	
	
	//mark:  --- managing the list
Function addListItem($name : Text; $kind : Text) : cs.TestRunner
	// when a group is added look it up in the jsonDoc
	// 
	var $listItem : Object
	$listItem:=This._listItem()
	
	Case of 
		: ($kind="test")
			//todo: add test to verify method exists
			//todo: add test to veify method is shared
			$listItem.kind:="test"
			$listItem.name:=$name
			$listItem.method:=cs.TestMethod.new($name)  //  .isSelected = True by default
			$listItem.message:="Not run"
			This._list.push($listItem)
			
		: ($kind="group") && (This._content[$name]=Null)  //  group is not defined
			$listItem.kind:="error"
			$listItem.name:=$name
			$listItem.message:="This is not a defined test group."
			
		: ($kind="group")
			$listItem.kind:="group"
			$listItem.name:=$name
			$listItem.message:="Not run"
			$listItem.tests:=This._content[$name].tests
			$listItem.groups:=This._content[$name].includeGroups
			This._list.push($listItem)
	End case 
	
	return This
	
	//mark:  --- running the tests
Function runList()
	var $listItem : Object
	var $testsRun : Collection
	
	For each ($listItem; This.list)
		$listItem.pass:=False
		
		Case of 
			: ($listItem.kind="error")  //  skip
				
			: ($listItem.kind="test")
				$listItem.method.run()
				$listItem.message:=$listItem.method.displayline
				
		End case 
		
	End for each 
	
	
	
	//mark:  --- private
Function _listItem : Object  // empty list itme
	return {name: ""; kind: ""; groups: []; tests: []; pass: False; message: ""; results: []}
	