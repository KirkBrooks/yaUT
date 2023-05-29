/*  DisplaySuiteResults - form method
 Created by: Kirk as Designer, Created: 05/29/23, 11:42:28
 ------------------
*/

var $ui_msg; $objectName_t : Text

If (Form#Null)
	$objectName_t:=String(FORM Event.objectName)
	
	Case of 
		: (Form event code=On Load)  //  catches all objects
			
			ARRAY BOOLEAN($aVisible; 0)
			ARRAY POINTER($aColVars; 0)
			ARRAY POINTER($aHeaderVars; 0)
			ARRAY POINTER($aStyles; 0)
			ARRAY TEXT($aColNames; 0)
			ARRAY TEXT($aHeaderNames; 0)
			
			LISTBOX GET ARRAYS(*; "suite_LB"; $aColNames; $aHeaderNames; $aColVars; $aHeaderVars; $aVisible; $aStyles)
			TestSuite_to_arrays(Form.suite; ->$aColVars)
			
		: (Form event code=On Clicked)
		: (Form event code=On Selection Change)
	End case 
	
	//Form.UI_message($ui_msg)
End if 
