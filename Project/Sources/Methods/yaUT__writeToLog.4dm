//%attributes = {}
/* Purpose: calls the yaUT logger and writes the text
 ------------------
yaUT__writeToLog ()
 Created by: Kirk as Designer, Created: 12/18/23, 11:15:25
*/
#DECLARE($message : Text)
var fileHandle : 4D.FileHandle

If (Current process name="yaUT_logger")
	
	If (fileHandle#Null) && (fileHandle.file.exists)
		fileHandle.writeLine($message)  //  .writeLine adds the line delimiter
	End if 
	
Else 
	CALL WORKER("yaUT_logger"; Current method name; $message)
End if 