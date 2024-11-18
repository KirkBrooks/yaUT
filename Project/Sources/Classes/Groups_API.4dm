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

Class constructor
	
	
	//mark:  --- GROUPS
Function addGroup($groupObj : Object) : cs.Groups_API
	// 