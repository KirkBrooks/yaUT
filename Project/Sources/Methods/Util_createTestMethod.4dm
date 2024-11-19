//%attributes = {}
/* Purpose: a method to create a yaUT_ test method 
Teturns True if method exists or is created
This will create a basic stem
 ------------------
Util_createTestMethod ()
 Created by: Kirk Brooks as Designer, Created: 10/14/24, 16:22:27

$methodObject: {
  name: 
  description: 
  kind: 
  defaultPriority: 
  tests:[]  //  will be inserted in order
   {
     section: ""  //  inserted with as 'mark//:- ' <your text>
     code: []  //  lines to be inserted for this test
   }
}

*/

#DECLARE($methodObj : Object) : Boolean
ARRAY TEXT($aNames; 0)
var $test : Object
var $code; $methodName : Text


If ($methodObj=Null) || (String($methodObj.name)="")
	return False
End if 

$methodName:=String($methodObj.name)

If ($methodName#"yaUT_@")
	$methodName:="yaUT_"+$methodName
	$methodObj.name:=$methodName
End if 

$methodName:=Substring($methodName; 1; 31)  // 4D method name limit

METHOD GET NAMES($aNames; $methodName)
If (Size of array($aNames)>0)
	return True  //  because the method exists
End if 

$code:=Util_createTestMethodCode($methodObj)

METHOD SET CODE($methodName; $code; *)
return True
yaUTFolders("moveTestMethods")
