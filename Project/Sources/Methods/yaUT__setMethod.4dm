//%attributes = {}
/* Purpose: 
 ------------------
yaUT__setMethod ()
 Created by: Kirk as Designer, Created: 12/18/23, 10:47:33
*/
#DECLARE($method : Text)

If (Storage.yaUT#Null)
	Use (Storage.yaUT)
		Storage.yaUT.currentMethod:=$method
	End use 
End if 