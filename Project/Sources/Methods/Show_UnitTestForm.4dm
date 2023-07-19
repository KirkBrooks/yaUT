//%attributes = {}
/* Purpose: open a form to display a collection of unit tests
 ------------------
Show_UnitTestForm ()
 Created by: Kirk as Designer

Form will open in a worker process named 'unitTestForm'

*/
#DECLARE($testCollection : Collection)
var $window : Integer
var $formData : Object

//  is the window open?
If (Num(Storage.unitTest.window)#0) && (Window process(Storage.unitTest.window)#0)
	var $l; $t; $r; $b : Integer
	GET WINDOW RECT($l; $t; $r; $b; Storage.unitTest.window)
	SET WINDOW RECT($l; $t; $r; $b; Storage.unitTest.window)  //  hacky way to bring a window to the front
	CALL FORM(Storage.unitTest.window; "Update_UnitTestForm"; $testCollection)
	return 
End if 

If (Process number("unitTestForm")#Current process)
	// if the worker hasn't been started do it now
	CALL WORKER("unitTestForm"; "Show_UnitTestForm"; $testCollection)
	return 
End if 

//mark:  --- this part runs in the worker
// open a new window and display the testCollection
$window:=Open form window("unitTest_form"; Plain form window)

Use (Storage)
	Storage.unitTest:=New shared object("window"; $window)
End use 

$formData:=New object("testCollection"; $testCollection)
DIALOG("unitTest_form"; $formData)

