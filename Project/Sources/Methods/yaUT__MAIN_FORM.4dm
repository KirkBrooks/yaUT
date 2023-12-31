//%attributes = {"shared":true}
/* Purpose: open a form to display a collection of unit tests
 ------------------
Show_UnitTestForm ()
 Created by: Kirk as Designer

Form will open in a worker process named 'unitTestForm'

*/

var $window : Integer

If (Process number("ut_mainDialog")#Current process)
	// if the worker hasn't been started do it now
	CALL WORKER("ut_mainDialog"; Current method name)
	
Else 
	//mark:  --- this part runs in the worker
	//  is the window open?
	If (Num(Storage.unitTest.window)#0) && (Window process(Storage.unitTest.window)#0)
		var $l; $t; $r; $b : Integer
		GET WINDOW RECT($l; $t; $r; $b; Storage.unitTest.window)
		SET WINDOW RECT($l; $t; $r; $b; Storage.unitTest.window)  //  hacky way to bring a window to the front
		return 
	End if 
	
	// open a new window and display the testCollection
	$window:=Open form window("mainWindow_dlog"; Plain form window)
	
	Use (Storage)
		Storage.unitTest:=New shared object("window"; $window)
	End use 
	
	DIALOG("mainWindow_dlog"; *)
End if 
