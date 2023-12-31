/*  MainWindow_dlog - form method
 Created by: Kirk as Designer, Created: 11/14/23, 17:01:19
 ------------------
*/

var $ui_msg; $objectName : Text
var $methods_LB; $results_LB; $detail_LB : cs.listbox
var $updateShowFailing; $bool : Boolean
var $obj : Object
var $yaUT : cs.UnitTest

If (Form=Null)
	return 
End if 

If (FORM Event.code=On Close Box)
	CANCEL
	return 
End if 

$objectName:=String(FORM Event.objectName)
$methods_LB:=Form.methods_LB=Null ? cs.listbox.new("methods_LB") : Form.methods_LB
$results_LB:=Form.results_LB=Null ? cs.listbox.new("results_LB") : Form.results_LB
$detail_LB:=Form.detail_LB=Null ? cs.listbox.new("detail_LB") : Form.detail_LB

If (FORM Event.code=On Load)  //  catches all objects
	Form.FullTest:=cs.FullTest.new().getTestMethods()
	Form.methods_LB:=$methods_LB.setSource(Form.FullTest.testMethods())
	Form.results_LB:=$results_LB
	Form.detail_LB:=$detail_LB
	Form.showFailing:=False
	Form.methodPrefix:="yaut_"
	OBJECT SET HELP TIP(*; "methodPrefix"; "Test methods begin with this string.")
	
End if 

//mark:  --- form object 
If ($objectName="btn_run")
	Form.FullTest.run()
	$methods_LB.redraw()
	$updateShowFailing:=True  //  update
End if 

If ($objectName="btn_refresh")
	Form.methods_LB:=$methods_LB.setSource(Form.FullTest.getTestMethods(Form.methodPrefix).testMethods())
End if 

If ($objectName="btn_writeLog")
	Case of 
		: (Not(Form.FullTest.isRun))
			ALERT("Nothing to log yet.")
		Else 
			Form.FullTest.logResults()
			CONFIRM("Show on disk?")
			If (Bool(ok))
				SHOW ON DISK(Form.FullTest.logPath)
			End if 
	End case 
	Form.methods_LB:=$methods_LB.setSource(Form.FullTest.getTestMethods(Form.methodPrefix).testMethods())
End if 

If ($objectName="showFailing")
	$updateShowFailing:=True  //  update
End if 

If ($objectName="methods_LB")
	Case of 
		: (Form event code=On Clicked) && (OptionKey) && ($methods_LB.isSelected)
			$bool:=Not($methods_LB.currentItem.selected)
			
			For each ($obj; $methods_LB.data)
				$obj.selected:=$bool
			End for each 
			
		: (Form event code=On Selection Change) && ($methods_LB.isSelected)
			$results_LB.setSource($methods_LB.currentItem.getFullResults())
			
		: (Form event code=On Double Clicked) && ($methods_LB.isSelected)
			METHOD OPEN PATH($methods_LB.currentItem.name; *)
			
			
	End case 
End if 

//mark:  --- update state and formats
If (Not(Form.FullTest.isRun))
	OBJECT SET VISIBLE(*; "statusRect"; False)
Else 
	OBJECT SET VISIBLE(*; "statusRect"; True)
	OBJECT SET RGB COLORS(*; "statusRect"; Form.FullTest.pass ? "green" : "red"; "transparent")
	
End if 

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