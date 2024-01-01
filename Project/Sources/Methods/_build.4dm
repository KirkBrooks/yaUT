//%attributes = {}
/* Purpose: 
 ------------------
_build ()
 Created by: Kirk as Designer, Created: 01/01/24, 13:45:34
*/

var $status : Object
var $marcros; $target : 4D.Folder
var $buildApp : 4D.File

$target:=Folder(Structure file; fk platform path).parent.parent

$buildApp:=$target.folder("Settings").file("buildApp.4DSettings")

$status:=Compile project()

If ($status.success=False)
	TRACE
End if 

BUILD APPLICATION($buildApp.platformPath)

//  now move the Macros file into the component
$marcros:=$target.folder("Macros v2")
$target:=$target.parent.folder("YAUT_Build").folder("Components").folder("yaUT.4dbase")

$marcros.copyTo($target)

ALERT("Done")