//%attributes = {}
/* Purpose: 
 ------------------
Priority_chooseByMenu ()
 Created by: Kirk Brooks as Designer, Created: 10/15/24, 07:13:31
*/
#DECLARE : Integer
var $menu; $menu_result_t : Text

$menu:=Create menu

APPEND MENU ITEM($menu; "1: Critical (must run every time)"; *)
SET MENU ITEM PARAMETER($menu; -1; "1")

APPEND MENU ITEM($menu; "2: High (should run in most cases)"; *)
SET MENU ITEM PARAMETER($menu; -1; "2")

APPEND MENU ITEM($menu; "3: Medium (run when time allows)"; *)
SET MENU ITEM PARAMETER($menu; -1; "3")

APPEND MENU ITEM($menu; "4: Low (run in full regression suites)"; *)
SET MENU ITEM PARAMETER($menu; -1; "0")


// ---- display the menu, get the result
$menu_result_t:=Dynamic pop up menu($menu)
RELEASE MENU($menu)
// ----

return Num($menu_result_t)