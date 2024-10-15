/*  TestTypes class
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 08:15:06
 ------------------
For managing testType related lists

*/
property _list : Collection
property isOK : Boolean

Class constructor
	var $file : 4D.File
	This.isOK:=False
	
	$file:=Folder(fk resources folder).file("defaults.json")
	If (Not($file.exists))
		ALERT("The 'defaults.json' file can not be found.\n\nThe component may not behave as expected.")
		return 
	End if 
	
	$obj:=JSON Parse($file.getText())
	If ($obj=Null) || ($obj.testTypes=Null)
		ALERT("The 'defaults.json' file is damaged.\n\nRestore from a backup and try again.")
		return 
	End if 
	
	This._list:=$obj.testTypes
	This.isOK:=True
	
Function get kindList : Collection
	If (Not(This.isOK))
		return []
	End if 
	
	return This._list.extract("kind")
	
	//mark:  --- 
Function chooseByMenu : Text
	var $menu; $menu_result_t : Text
	var $obj : Object
	
	If (This.isOK=False)
		return ""
	End if 
	$menu:=Create menu
	
	For each ($obj; This._list)
		$str:=$obj.kind+": "+$obj.description
		APPEND MENU ITEM($menu; $str; *)
		SET MENU ITEM PARAMETER($menu; -1; $obj.kind)
	End for each 
	
	APPEND MENU ITEM($menu; "---")  // line
	
	// ---- display the menu, get the result
	$menu_result_t:=Dynamic pop up menu($menu)
	RELEASE MENU($menu)
	// ----
	return Lowercase($menu_result_t)
	
Function getList : Collection
	If (Not(This.isOK))
		return []
	End if 
	
	return This._list