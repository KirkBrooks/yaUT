//%attributes = {"shared":true}
/* Purpose: Runs a Group
 ------------------
Group_run ()
 Created by: Kirk Brooks as Designer, Created: 11/21/24, 07:29:33

This is the primary way to run a Group. 
The idea is for this to be an isolated space for executing the group

$groupObj is returned and can be viewed in the TestRunnger_2024 form

This method always gets the groupObj directly from the JSON.
$altPath allows you to specify a particular JSON document to load. 
 - Leave blank to use the default groups.json document
*/

#DECLARE($groupName : Text; $altPath : Text)->$groupObj : cs.GroupObj
var $api : cs.Groups_API

$groupName:="A"

$api:=cs.Groups_API.new($altPath)  // fresh instance of groups.json

If ($api=Null)
	return 
End if 

$groupObj:=$api.groups.query("name = :1"; $groupName).first()  // find the group

If ($groupObj=Null)
	return 
End if 

$groupObj.run()

