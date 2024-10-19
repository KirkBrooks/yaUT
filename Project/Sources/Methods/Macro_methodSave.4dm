//%attributes = {}
/* Purpose: called by macros when a method is saved
only responds to yaUT_  methods
 ------------------
Macro_methodSave ()
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 17:35:58

RESPONDING TO USER EDITS ON yaUT_  METHODS

We want to sync the comments, priority and kind fields
with groups.json.


*/
#DECLARE($methodName : Text)
var $code : Text
var $codeCol : Collection

If (Not(Match regex("yaUT_(?!_)\\w+"; $methodName; 1)))
	return 
End if 

GET MACRO PARAMETER(Full method text; $code)

$codeCol:=Split string($code; "\n")

$obj:={name: $methodName}
$inDesc:=False
$description:=""

For each ($line; $codeCol)
	
	Case of 
		: ($inDesc) && ($line="*/")  //  end of comment
			$obj.description:=$description
			$inDesc:=False
			
		: ($line="/* Description@")  // start of description
			$inDesc:=True
			
		: ($line="// Kind:@")
			$obj.kind:=Substring($line; 9)
			
		: ($line="// Priority:@")
			$obj.defaultPriority:=Num($Line)
			
		: ($line="#DECLARE@")
			continue
	End case 
	
End for each 


TRACE