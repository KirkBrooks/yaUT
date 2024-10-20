//%attributes = {}
/* Purpose: test is a project method exists
by default it checks locally; $onHost=True for host db
 ------------------
UTIL_methodExists ()
 Created by: Kirk Brooks as Designer, Created: 10/19/24, 10:11:57
*/
#DECLARE($methodName : Text; $onHost : Boolean) : Boolean
ARRAY TEXT($aNames; 0)

If (Bool($onHost))
	METHOD GET NAMES($aNames; $methodName; *)
Else 
	METHOD GET NAMES($aNames; $methodName)
End if 

return Size of array($aNames)>0