//%attributes = {}
/* Purpose: called by Show_UnitTestForm to update the displayed collection
 ------------------
Update_UnitTestForm ()
 Created by: Kirk as Designer, Created: 07/19/23, 09:42:53
*/

//  runs in the context of the form...
#DECLARE($testCollection : Collection)

Form.testCollection:=$testCollection
Form.test_LB.setSource($testCollection)
Form.test_LB.redraw()
Form.filter:="All"