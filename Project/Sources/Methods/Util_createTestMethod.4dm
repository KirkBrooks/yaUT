//%attributes = {}
/* Purpose: a method to create a yaUT_ test method 
Teturns True if method exists or is created
This will create a basic stem
 ------------------
Util_createTestMethod ()
 Created by: Kirk Brooks as Designer, Created: 10/14/24, 16:22:27

$options: {
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

#DECLARE($methodName : Text; $options : Object) : Boolean
ARRAY TEXT($aNames; 0)
var $test : Object
var $code : Text

If ($methodName="")
	return False
End if 

If ($methodName#"yaUT_@")
	$methodName:=Substring("yaUT_"+$methodName; 1; 31)
End if 

METHOD GET NAMES($aNames; $methodName)
If (Size of array($aNames)>0)
	return True  //  because the method exists
End if 

$code:=Util_createTestMethodCode($methodName; $options)

METHOD SET CODE($methodName; $code; *)
yaUTFolders("moveTestMethods")
return True
