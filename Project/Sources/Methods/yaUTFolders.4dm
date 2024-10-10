//%attributes = {}
/* Purpose: 
 ------------------
yaUTFolders ()
 Created by: Kirk Brooks as Designer, Created: 10/10/24, 11:30:24

Organize yaUT methods into a folder hierarchy:

yaUT
| yaUT methods
|- <method>
| yaUC groups
|- <group>

To use this: 
start by calling checkFolders

*/
#DECLARE($action : Text; $options : Object) : Variant
var $file : 4D.File
var $obj : Object
var $text; $key : Text

Case of 
	: ($action="checkFolders")
		//  create/verify the folders exist
		$obj:=yaUTFolders("getFolderJson")
		
		If ($obj=Null)
			return 
		End if 
		
		//  every folder is a key
		For each ($key; ["yaUT"; "yaUT methods"; "yaUC groups"])
			If ($obj[$key]=Null)
				$obj[$key]:={}
			End if 
		End for each 
		
		//  each folder has a list of content collections: 
		//  groups = other folders, methods, forms, classes ...
		If ($obj.yaUT.groups=Null)
			$obj.yaUT.groups:=[]
		End if 
		
		For each ($key; ["yaUT methods"; "yaUC groups"])
			If ($obj.yaUT.groups.indexOf($key)=-1)
				$obj.yaUT.groups.push($key)
			End if 
		End for each 
		
		$obj:=yaUTFolders("writeFolderJson"; $obj)
		
		
	: ($action="getFolderJson")
		$file:=File(Structure file; fk platform path; *).parent.folder("Sources").file("folders.json")
		$text:=$file.getText()
		return $text="{@" ? JSON Parse($text) : ""
		
	: ($action="writeFolderJson")
		If ($options=Null)
			return 
		End if 
		
		$text:=JSON Stringify($options; *)
		
		If ($text="")
			return 
		End if 
		
		$file:=File(Structure file; fk platform path; *).parent.folder("Sources").file("folders.json")
		$file.setText($text)
		RELOAD PROJECT  //  <-  this is crucial, without it the changes are overwritten by 4D
		
		return 
		
		
		
		
End case 
