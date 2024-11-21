/*  _displayLine class
 Created by: Kirk Brooks as Designer, Created: 11/20/24, 16:52:29
 ------------------
 Description: private class for building the display line
string for various locations. 

*/

property _description : Text
property _error : Text
property pass : Boolean
property isBreak : Boolean

Class constructor($input : Variant; $pass : Boolean)
	
	If (Value type($input)=Is text)
		This._description:=$input
		This.pass:=Bool($pass)
		return 
	End if 
	
	If (OB Instance of($input; cs.TestMethod))
		This.pass:=$input.pass
		This._error:=""
		
		Case of 
			: (Not($input.isRun))
				This._description:="   - not run"
				This.isBreak:=True
				
			: ($input.isErr)
				This._description:=""
				This._error:=" : "+String($input._error)
				
			: ($input.pass)
				This._description:=" # tests: "+String($input.countTests)
				
			Else 
				This._description:=" # pass: "+String($input.countPass)+", # fail: "+String($input.countFail)
		End case 
		return 
		
	End if 
	
	This._description:=$input.description || ""
	This.pass:=Bool($input.pass)
	This._error:=$input._error || $input.error || ""
	This.isBreak:=(Value type($input._expectValueKind)=Is text) && ($input._expectValueKind="break")
	
	
Function get displayline : Text
	//  return line of text suitable for display in a listbox or text field
	Case of 
		: (This.isBreak)
			return This._description
			
		: (This._error#"")
			return "  ⚠️ "+This._description+": "+String(This._error)
			
		: (This.pass)
			return "  ✅   "+This._description
			
		Else 
			return "  ❌   "+This._description
	End case 