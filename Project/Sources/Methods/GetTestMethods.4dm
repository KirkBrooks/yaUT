//%attributes = {}
/* Purpose: return collection of unit test methods
 ------------------
GetTestMethods ()
 Created by: Kirk as Designer, Created: 11/14/23, 17:04:43
*/

#DECLARE()->$col : Collection
ARRAY TEXT($aPaths; 0)
var $i : Integer

METHOD GET PATHS(Path project method; $aPaths; *)
SORT ARRAY($aPaths; >)
$col:=[]
ARRAY TO COLLECTION($col; $aPaths)
$col:=$col.filter(Formula($1.value="_ut_@"))

For ($i; 0; $col.length-1)
	$col[$i]:={method: $col[$i]; selected: True}
End for 

