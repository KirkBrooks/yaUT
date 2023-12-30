//%attributes = {}
/* Purpose: 
 ------------------
yaUT__setContext ()
 Created by: Kirk as Designer, Created: 12/18/23, 10:47:33
*/
#DECLARE($context : Text)

If (Storage.yaUT#Null)
	Use (Storage.yaUT)
		Storage.yaUT.context:=$context
	End use 
End if 