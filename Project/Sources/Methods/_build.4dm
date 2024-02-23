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
	
	// --------------------------------------------------------
	var $progress_id : Integer
	$progress_id:=Progress New
	Progress SET TITLE($progress_id; "Building..."; -1; "Compiling...")
	// --------------------------------------------------------
	
	$version:=cs._VersionMinder.new().setBuild().version  // increment the build number
	
	$target:=Folder(Structure file; fk platform path).parent.parent
	
	$buildApp:=$target.folder("Settings").file("buildApp.4DSettings")
	
	$status:=Compile project()
	
	If ($status.success=False)
		TRACE
	End if 
	
	Progress SET TITLE($progress_id; "Building..."; -1; "Build Application")
	
	BUILD APPLICATION($buildApp.platformPath)
	
	Progress SET TITLE($progress_id; "Building..."; -1; "Cleaning up...")
	
	//  now move the Macros file into the component
	$macros:=$target.folder("Macros v2")
	$target:=$target.parent.folder("YAUT_Build").folder("Components").folder("yaUT.4dbase")
	
	$macros.copyTo($target)
	
	// --------------------------------------------------------
	Progress QUIT($progress_id)
	// --------------------------------------------------------
	CONFIRM("Build version "+$version+" Done!"; "Show on Disk")
	
	If (Bool(OK))
		SHOW ON DISK($target.platformPath)
	End if 
	
Else 
	ALERT("Build canceled.")
End if 