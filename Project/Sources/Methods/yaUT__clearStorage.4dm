//%attributes = {}
/* Purpose: 
 ------------------
yaUT__clearStorage ()
 Created by: Kirk as Designer, Created: 12/18/23, 10:47:33
*/

If (Storage.yaUT#Null)
	
	Use (Storage)
		OB REMOVE(Storage; "yaUT")
	End use 
End if 