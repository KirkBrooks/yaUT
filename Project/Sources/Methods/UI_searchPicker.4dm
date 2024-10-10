//%attributes = {}
/* Purpose: 
 ------------------
UI_searchPicker ()
 Created by: Kirk Brooks as Designer, Created: 10/10/24, 09:27:10
*/
#DECLARE($searchStr : Text; $target : Text)
ARRAY TEXT($aNames; 0)
var $methods : Collection

//mark:  --- testPicker listbox
If ($target="testPicker")
	METHOD GET NAMES($aNames; "yaUT_@"; *)
	ARRAY BOOLEAN($aChecked; Size of array($aNames))
	
	$methods:=[]
	ARRAY TO COLLECTION($methods; $aNames; "method"; $aChecked; "checked")
	
	If ($searchStr#"")
		$methods:=$methods.query("method = :1"; "@"+$searchStr+"@")
	End if 
	
	Form.tests_LB.setSource($methods)
	return 
End if 


If ($target="groupPicker")
	METHOD GET NAMES($aNames; "yaUC_@"; *)
	ARRAY BOOLEAN($aChecked; Size of array($aNames))
	
	$methods:=[]
	ARRAY TO COLLECTION($methods; $aNames; "method"; $aChecked; "checked")
	
	If ($searchStr#"")
		$methods:=$methods.query("method = :1"; "@"+$searchStr+"@")
	End if 
	
	Form.groups_LB.setSource($methods)
	return 
End if 
