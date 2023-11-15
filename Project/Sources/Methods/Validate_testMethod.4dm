//%attributes = {}
/* Purpose: validate the method name exists
0 = no method; 1 = available to run; 2 = on Host, not shared
 ------------------
Validate_testMethod ()
 Created by: Kirk as Designer, Created: 11/15/23, 11:29:27

If running as component the test method may not be shared
But it doesn't have to be shared to get the code
*/

#DECLARE($method : Text) : Integer
ARRAY TEXT($aPath; 0)
var $attrib : Object
var $path : Text

$path:=METHOD Get path(Path project method; $method; *)

If ($path="")
	return 0  //  method does not exist
End if 

METHOD GET ATTRIBUTES($path; $attrib)

Case of 
	: (Not(isComponent))
		return 1
		
	: (Not($attrib.shared)) && (Not(Is compiled mode))
		METHOD SET ATTRIBUTE($method; Attribute shared; True)
		return 1
		
	: (Not($attrib.shared))
		return 2
		
	Else 
		return 1
End case 
