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
ARRAY TO COLLECTION($col; $aPaths)

$methodPrefix+="@"
$col:=$col.filter(Formula($1.value=$methodPrefix))

For ($i; 0; $col.length-1)
	$col[$i]:={method: $col[$i]; selected: True}
End for 

