//%attributes = {}
/* Purpose: 
 ------------------
Macro_insertPriority ()
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 18:26:58
*/
var $n : Integer
$n:=Priority_chooseByMenu()
SET MACRO PARAMETER(Highlighted method text; String($n))