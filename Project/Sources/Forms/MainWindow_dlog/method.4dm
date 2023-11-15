/*  MainWindow_dlog - form method
 Created by: Kirk as Designer, Created: 11/14/23, 17:01:19
 ------------------
*/

var $ui_msg; $objectName : Text
var $methods_LB; $results_LB; $detail_LB : cs.listbox
var $updateShowFailing : Boolean
var $obj : Object

If (Form=Null)
	return 
End if 

$objectName:=String(FORM Event.objectName)
$methods_LB:=Form.methods_LB=Null ? cs.listbox.new("methods_LB") : Form.methods_LB
$results_LB:=Form.results_LB=Null ? cs.listbox.new("results_LB") : Form.results_LB
$detail_LB:=Form.detail_LB=Null ? cs.listbox.new("detail_LB") : Form.detail_LB

//mark:  --- object actions
Case of 
	: (FORM Event.code=On Close Box)
		CANCEL
		
	: (FORM Event.code=On Load)  //  catches all objects
		Form.methods_LB:=$methods_LB.setSource(GetTestMethods)
		Form.results_LB:=$results_LB
		Form.detail_LB:=$detail_LB
		Form.showFailing:=False
		
	: ($objectName="btn_run")
		$results_LB.setSource(RunTestMethods($methods_LB.data))
		$updateShowFailing:=True  //  update
		
	: ($objectName="btn_refresh")
		$methods_LB.setSource(GetTestMethods)
		
	: ($objectName="showFailing")
		$updateShowFailing:=True  //  update
		
	: ($objectName="results_LB")
		Case of 
			: (Form event code=On Selection Change)
				
				If ($results_LB.isSelected) && (OB Instance of($results_LB.currentItem; cs.UnitTest))
					$detail_LB.setSource($results_LB.currentItem.getSummary())
				End if 
				
		End case 
End case 

//mark:  --- update state and formats
If ($updateShowFailing) && (Form.showFailing)
	// show the text and failing tests
	$results_LB.data:=[]
	For each ($obj; $results_LB.source)
		If (Not(Bool($obj.pass)))
			$results_LB.data.push($obj)
		End if 
	End for each 
End if 

If ($updateShowFailing) && (Not(Form.showFailing))
	$results_LB.data:=$results_LB.source
End if 