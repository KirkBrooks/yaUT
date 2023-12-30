//%attributes = {}
/* Purpose: pushs a result onto Storage
 ------------------
yaUT__pushResult ()
 Created by: Kirk as Designer, Created: 12/18/23, 10:47:33
*/
#DECLARE($obj : Object)

If (Storage.yaUT#Null) && ($obj#Null)
	
	Use (Storage.yaUT)
		Storage.yaUT.results.push(OB Copy($obj; ck shared; Storage.yaUT))
	End use 
	
	// also push to log?
	If (Storage.yaUT.logResults)
		yaUT__writeToLog($obj.displayline)
	End if 
End if 