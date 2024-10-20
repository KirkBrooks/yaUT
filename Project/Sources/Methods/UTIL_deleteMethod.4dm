//%attributes = {}
/* Purpose: deletes a method
 ------------------
UTIL_deleteMethod ()
 Created by: Kirk Brooks as Designer, Created: 10/19/24, 13:55:27
*/

#DECLARE($methodName : Text; $onHost : Boolean)
var $file : 4D.File

If ($onHost)
	$file:=Folder(fk database folder; *).folder("Project/Sources/Methods").file($methodName+".4dm")
Else 
	$file:=Folder(fk database folder).folder("Project/Sources/Methods").file($methodName+".4dm")
End if 

If (Not($file.exists))
	return 
End if 

$file.delete()
RELOAD PROJECT
