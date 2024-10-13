/*  CommaList class($input: variant)
 Created by: Kirk Brooks as Designer, Created: 10/03/24, 13:41:23
 ------------------
for managing a comma delimited list

*/
property list : Collection
property delim : Text
property uniqueOnly : Boolean
property ignoreEmpty : Integer

Class constructor($input; $unique : Boolean; $delim : Text)  //  text, collection
	This.delim:=$delim || ","  //  item delimiter
	This.uniqueOnly:=Count parameters>1 ? $unique : False
	This.ignoreEmpty:=sk ignore empty strings
	This.list:=[]
	
	If (Value type($input)=Is text)
		This._updateList([$input])
		return 
	End if 
	
	If (Value type($input)=Is collection)
		This._updateList($input)
		return 
	End if 
	
	//mark:  --- functions
Function addItem($text : Text) : cs.CommaList
	This._updateList(This._splitString($text))
	return This
	
Function addItems($items : Variant; $delim : Text) : cs.CommaList
	// items can be text string or collection
	This.delim:=$delim || This.delim
	
	If (Value type($items)=Is text)
		This._updateList(This._splitString($items))
		return This
	End if 
	
	If (Value type($items)=Is collection)
		This._updateList($items)
		return This
	End if 
	
	return This
	
Function dropItem($item : Text) : cs.CommaList
	var $i : Integer
	
	$i:=This.list.indexOf($item)
	If ($i>-1)
		This.list.remove($i)
	End if 
	
Function getList : Text
	// return the delimited text string
	return This.list.join(This.delim+" ")
	
Function chooseByMenu->$menu_result : Text
	//  choose a list item by menu
	var $menu; $item : Text
	
	$menu:=Create menu
	For each ($item; This.list)
		APPEND MENU ITEM($menu; $item; *)
		SET MENU ITEM PARAMETER($menu; -1; $item)
	End for each 
	
	$menu_result:=Dynamic pop up menu($menu)
	RELEASE MENU($menu)
	
Function hasItem($item : Text; $caseInsensitive : Boolean) : Boolean
	var $option : Integer
	$option:=$caseInsensitive ? sk case insensitive : sk strict
	return (Value type(This.list.find(Formula(Compare strings($1.value; $2; $option)=0); $item))#Is undefined)
	
	//mark:  --- private
Function _updateList($split : Collection)
	var $item : Text
	
	If ($split=Null) || ($split.length=0)
		return 
	End if 
	
	If (This.uniqueOnly)
		For each ($item; $split)
			If (This.list.indexOf($item)=-1)
				This.list.push($item)
			End if 
		End for each 
		
		return 
	End if 
	
	// don't care about unique
	This.list.combine($split)
	
Function _splitString($text : Text) : Collection
	//  single place to do it
	return Split string($text; This.delim; sk trim spaces+This.ignoreEmpty)