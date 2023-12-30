//%attributes = {}
/* Purpose: returns a text of results
 ------------------
yaUT__getDisplayText ()
 Created by: Kirk as Designer, Created: 12/18/23, 11:52:59
*/

#DECLARE : Text

//  return a text block of displayLine
If (Storage.yaUT=Null) || (Storage.yaUT.results=Null)
	return "Unit Test collection is not initialized"
End if 

return Storage.yaUT.results.extract("displayline").join("\n")
