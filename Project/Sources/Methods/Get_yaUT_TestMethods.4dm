//%attributes = {"shared":true}
/* Purpose: return collection of unit test methods
yaUT unit test methods must begin with 'yaut_' 
 ------------------
Get_yaUT_TestMethods ()
 Created by: Kirk as Designer, Created: 11/14/23, 17:04:43
*/

#DECLARE($methodPrefix : Text)->$col : Collection
ARRAY TEXT($aPaths; 0)
var $i : Integer

$methodPrefix:=$methodPrefix="" ? "yaut_" : $methodPrefix

METHOD GET PATHS(Path project method; $aPaths; *)
SORT ARRAY($aPaths; >)
$col:=[]

For ($i; 1; Size of array($aPaths))
	If ($aPaths{$i}="yaut_@") && ($aPaths{$i}#"yaUT_FullTest")
		$col.push({method: $aPaths{$i}; selected: True})
	End if 
End for 

