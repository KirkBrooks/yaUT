//%attributes = {}
/* Purpose: singleton of cs.TestTypes
 ------------------
testTypes ()
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 08:20:48
*/
#DECLARE : cs.TestTypes
var __testTypes : cs.TestTypes

If (__testTypes=Null)
	__testTypes:=cs.TestTypes.new()
End if 

return __testTypes