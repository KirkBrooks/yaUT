//%attributes = {}
/* Purpose: will create a new log file and file handler
 ------------------
yaUT__startLogWorker ()
 Created by: Kirk as Designer, Created: 12/18/23, 11:02:29
*/

If (Storage.yaUT=Null)
	return 
End if 

If (Storage.yaUT.logResults)
	return   //  already have a log open
End if 

//mark:  --- 
var $file : 4D.File
var fileHandle : 4D.FileHandle
var $fileName; $text : Text

$fileName:=Replace string("yaut_"+String(Current date; ISO date; Current time)+".txt"; ":"; "-")  // can't have colons in the file path
$file:=Folder(Folder(fk logs folder).platformPath; fk platform path).file($fileName)  //  Folder(Folder ...  trick to convert the path to system path

$text:="Unit Test Log: "+File(Structure file; fk platform path).path+"\n"
$text+="Machine: "+Current method name()+";  User: "+Current user()+"\n"
$text+=("="*40)+"\n"
$file.setText($text)

fileHandle:=$file.open("append")

Use (Storage.yaUT)
	Storage.yaUT.logResults:=True
	Storage.yaUT.logPath:=$file.path
End use 
