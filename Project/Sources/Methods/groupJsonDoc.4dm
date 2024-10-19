//%attributes = {}
/* Purpose: 
 ------------------
groupJsonDoc ()
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 18:45:59
*/

#DECLARE($reload : Boolean) : cs.GroupsJson
var $class : cs.GroupsJson

If ($reload) || (Storage.groupsJson=Null)
	Use (Storage)
		Storage.groupsJson:=OB Copy(cs.GroupsJson.new(); ck shared)
	End use 
End if 

return Storage.groupsJson