//%attributes = {}
/* Purpose: returns the sum of the parameters
 ------------------
SumParams ()
*/
#DECLARE()->$sum : Real
var $value : Variant

For each ($value; Copy parameters)
	$sum+=(Value type($value)=Is real) ? $value : 0
End for each 
