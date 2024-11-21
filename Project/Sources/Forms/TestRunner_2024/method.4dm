/*  TestRunner_2024 - form method
 Created by: Kirk Brooks as Designer, Created: 11/20/24, 16:34:20
 ------------------
Form.testGroup = Test group that is run
Form.results   = Form.textGroup._results  an object of test methods run

*/

var $objectName : Text

If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)

//mark:  --- form actions
If (FORM Event.code=On Load)  //  catches all objects
	
	
	
End if 

//mark:  --- object actions

//mark:  --- update state and formats

