//%attributes = {}
/* Purpose: 
 ------------------
_test_commaList ()
 Created by: Kirk Brooks as Designer, Created: 10/03/24, 15:24:01
*/

var $class : cs.CommaList
var $ok : Boolean

$class:=cs.CommaList.new(["application/json"; "text/html"; "c"])

$class.addItem("application/stuff")

//$item:=$class.chooseByMenu()

$ok:=$class.hasItem("a@")
$ok:=$class.hasItem("c")
$ok:=$class.hasItem("C"; True)
$ok:=$class.hasItem("z")
$ok:=$class.hasItem("stuff")

var $item; $listStr : Text
$class.dropItem($item)
$listStr:=$class.getList()

