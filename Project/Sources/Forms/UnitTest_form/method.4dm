/* form method
There's not much to do on the form method - the listbox is essential just displaying
the contents of the testCollection
*/

var $objectName; $queryStr; $property; $filter; $menu : Text
var $test_LB; $detail_LB : cs.listbox
var $collection : Collection
var $i : Integer

If (Form=Null)
	return 
End if 

$test_LB:=(Form.test_LB=Null) ? cs.listbox.new("test_LB") : Form.test_LB
$detail_LB:=(Form.detail_LB=Null) ? cs.listbox.new("detail_LB") : Form.detail_LB
$objectName:=String(FORM Event.objectName)

//mark:  --- object actions
Case of 
	: (Form event code=On Load)
		
		// the listboxes
		Form.test_LB:=$test_LB
		$test_LB.setSource(Form.testCollection)
		
		Form.detail_LB:=$detail_LB  //  you don't need to load any data into the listbox to initialize it
		Form.filter:="All"
		
	: (Form event code=On Close Box)
		CANCEL
		CALL WORKER(Current process; Formula(CLOSE WINDOW(Storage.unitTest.window)))
		
	: ($objectName="btn_filter")
		$menu:=Create menu()
		
		APPEND MENU ITEM($menu; "All")
		SET MENU ITEM PARAMETER($menu; -1; "All")
		APPEND MENU ITEM($menu; "Failing")
		SET MENU ITEM PARAMETER($menu; -1; "Failing")
		APPEND MENU ITEM($menu; "Errors")
		SET MENU ITEM PARAMETER($menu; -1; "Errors")
		
		$filter:=Dynamic pop up menu($menu)
		RELEASE MENU($menu)
		
		Case of 
			: ($filter="All")
				Form.filter:=$filter
				$test_LB.reset()
			: ($filter="Fail@")
				Form.filter:=$filter
				$test_LB.data:=$test_LB.source.query("pass = :1 AND isErr = :2"; False; True)
			: ($filter="Err@")
				Form.filter:=$filter
				$test_LB.data:=$test_LB.source.query("isErr = :1"; True)
		End case 
		$test_LB.redraw()
		
	: ($objectName="test_LB")  //  manage the user actions on the listbox
		Case of 
			: (Form event code=On Selection Change) && ($test_LB.isSelected)  //  put the selected.test into the detail listbox
				//  convert the object or entity into collection
				$collection:=New collection()
				For each ($property; OB Keys($test_LB.currentItem))
					$collection.push(New object("key"; $property; "value"; $test_LB.currentItem[$property]))
				End for each 
				
				$detail_LB.setSource($collection)
		End case 
		
		
		
End case 

//mark:  --- update state, formats, etc.
// update a text variable showing the displayed state of the listbox
OBJECT SET VALUE("test_LB_state"; $test_LB.get_shortDesc())
// but we could use it for the window title too
SET WINDOW TITLE("Unit Test: "+$test_LB.get_shortDesc())
//  hide the detail listbox if there is no selected.test
OBJECT SET VISIBLE(*; "detail_LB"; $test_LB.isSelected)
