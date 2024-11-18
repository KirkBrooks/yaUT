/*  ProjectTestMethod class
 Created by: Kirk Brooks as Designer, Created: 11/18/24, 09:57:02
 ------------------
API for managing 4D methods used you yaUT

*/
Class extends ProjectMethod



Class constructor($method : Variant)  // methodName or methodObject
	var $methodObj : Object
	
	Case of 
		: (Value type($method)=Is text)
			$methodObj:={name: $method}
		: (Value type($method)=Is object)
			$methodObj:=$method
		Else 
			ALERT("ProjectTestMethod requires method name or methodObject.")
			return 
	End case 
	
	Super($methodObj.name)
	
	If (This.exists=False)
		Util_createTestMethod
	End if 
	
	