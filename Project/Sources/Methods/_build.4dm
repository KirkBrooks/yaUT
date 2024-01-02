//%attributes = {}
/* Purpose: 
 ------------------
_build ()
 Created by: Kirk as Designer, Created: 01/01/24, 13:45:34

VERSIONING
update thisVersion method with major, minor and patch numbers
the build number is updated here

*/

var $status : Object
var $macros; $target : 4D.Folder
var $buildApp : 4D.File
var $version : Text

If (UT_TestSuite=0)
	$version:=cs.VersionMinder.new().setBuild().version  // increment the build number
	
	$target:=Folder(Structure file; fk platform path).parent.parent
	
	$buildApp:=$target.folder("Settings").file("buildApp.4DSettings")
	
	$status:=Compile project()
	
	If ($status.success=False)
		TRACE
	End if 
	
	BUILD APPLICATION($buildApp.platformPath)
	
	//  now move the Macros file into the component
	$macros:=$target.folder("Macros v2")
	$target:=$target.parent.folder("YAUT_Build").folder("Components").folder("yaUT.4dbase")
	
	$macros.copyTo($target)
	
	ALERT("Build version "+$version+" Done")
	
Else 
	ALERT("Build canceled.")
End if 