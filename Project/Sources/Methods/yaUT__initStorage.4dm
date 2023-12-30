//%attributes = {}
/* Purpose: 
 ------------------
yaUT__initStorage ()
 Created by: Kirk as Designer, Created: 12/18/23, 10:46:58
*/
#DECLARE($options : Object)
var $obj : Object

KILL WORKER("yaUT_logger")  //  if it's currently running kill it

$obj:={}
$obj.results:=[]
$obj.currentMethod:=""
$obj.context:=$options.context || ""

/*  when logResults is set to true
create a new log and write the path
start the 'yaUT_logger' worker
*/
$obj.logResults:=False
$obj.logPath:=""


$obj.showDialog:=Bool($options.showDialog)

$obj.list:=$options.list || []

Use (Storage)
	Storage.yaUT:=OB Copy($obj; ck shared)
End use 

//mark:  --- must initialize Storage before starting the worker
If (Bool($options.logResults))
	CALL WORKER("yaUT_logger"; "yaUT__startLogWorker")
End if 