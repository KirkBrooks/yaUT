//%attributes = {}
/* Purpose: called by macros to setup a new yaUT method
 ------------------
Macro_newTestMethod ()
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 18:17:27
*/
#DECLARE($methodName : Text)
var $code : Text

$code:=Util_createTestMethodCode({name: $methodName})

SET MACRO PARAMETER(Full method text; $code)
