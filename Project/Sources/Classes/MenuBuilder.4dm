/*  MenuBuilder class
 Created by: Kirk Brooks as Designer, Created: 11/11/24, 10:14:09
 ------------------
 Description:

*/
property _menus : Object

Class constructor($name : Text)
	This._menus:={}
	This.name:=$name || "Main"

Function getRef($name : Text) : Text
	return This._menus[$name] || This._menus[This.name]

	//mark:  --- menu items
Function appendLine($menuName : Text) : cs.MenuBuilder
	//  append divider line for visual clarity
	APPEND MENU ITEM(This._newMenu($menuName); "(-")
	return This

Function appendItem($title : Text; $options : Object; $menuName : Text) : cs.MenuBuilder
	// $menuName will default This.name or create new one
	var $menu : Text
	$menu:=This._newMenu($menuName)

	APPEND MENU ITEM($menu; $title; *)

	If ($options.parameter#Null)
		SET MENU ITEM PARAMETER($menu; -1; $options.parameter)
	End if

	If ($options.setMark#Null)
		SET MENU ITEM MARK($menu; -1; $options.setMark)
	End if

	If ($options.iconPath#Null)
		SET MENU ITEM ICON($menu; -1; $options.iconPath)
	End if

	If ($options.method#Null)
		SET MENU ITEM METHOD($menu; -1; $options.method)
	End if

	If ($options.style#Null)
		SET MENU ITEM STYLE($menu; -1; $options.style)
	End if

	// $options.shortcut is either:
	// text:  Letter of keyboard shortcut or Character code of keyboard shortcut
	// object: {key: ""; mods: 0 }
	//  https://developer.4d.com/docs/commands/set-menu-item-shortcut
	var $key : Text
	var $mods : Integer

	Case of
		: (Value type($options.shortcut)=Is null)

		: (Value type($options.shortcut)=Is text)
			$key:=$options.shortcut
			SET MENU ITEM SHORTCUT($menu; -1; Num($key))

		: (Value type($options.shortcut)=Is object)
			$key:=$options.shortcut.key
			$mods:=$options.shortcut.mods
			SET MENU ITEM SHORTCUT($menu; -1; $key; $mods)

	End case

	return This

Function appendMenu($parentMenuName : Text; $childMenuName : Text; $childMenuRef) : cs.MenuBuilder
	//  append the child to the parent
	var $parent; $child : Text

	$parent:=This._newMenu($parentMenuName)
	$child:=$childMenuRef || This._newMenu($childMenuName)
	APPEND MENU ITEM($parent; $childMenuName; $child; *)
	return This

Function releaseMenu($menuName) : cs.MenuBuilder
	If (This._menus[$menuName]#Null)
		RELEASE MENU($menuName)
		OB REMOVE(This._menus; $menuName)
	End if
	return This

Function releaseAll()
	var $menuName : Text

	For each ($menuName; This._menus)
		RELEASE MENU($menuName)
		OB REMOVE(This._menus; $menuName)
	End for each

	//mark:  --- private
Function _newMenu($name : Text) : Text
	$name:=$name || This.name
	This._menus[$name]:=This._menus[$name] || Create menu
	return This._menus[$name]
