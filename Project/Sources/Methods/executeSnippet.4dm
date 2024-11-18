//%attributes = {}
/* Purpose: place this method at the top of a sandbox method
you use to work out code ideas. 

It will get the code of the method and start a worker
which will build a menu where each item is a //mark- line

When you select a line the code from the mark till the next mark or 
the end of the page will be executed. 
 ------------------
_executeSnippet ()
 Created by: Kirk as Designer, Created: 01/23/24, 21:56:55

MenuBuilder
*/
var $method; $code; $menu; $choice; $script : Text
var $iCol; $lines; $marks : Collection
var $start; $end; $i; $declare : Integer
var $f : 4D.Function
var $subMenus : Collection

$method:=Get call chain[1].name

METHOD GET CODE($method; $code)

$lines:=Split string($code; "\r"; sk ignore empty strings+sk trim spaces).slice(1)  // slice off the top line reserved by 4D

$i:=$lines.indexOf(Current method name+"@")
If ($i>-1)
	$lines.remove($i)  //  prevent recursion
End if 

//mark:  --- any vars declared at top?
$f:=Formula($1.value="//mark:@")

$start:=$lines.findIndex($f)
If ($start>-1)
	$code:=$lines.slice(0; $start).join("\n")
	$code+="\n"
	$lines:=$lines.slice($start)
Else 
	$code:=""
End if 

//mark:  --- find marks
$start:=0
$icol:=[]

Repeat 
	$i:=$lines.findIndex($start; $f)
	
	If ($i>-1)
		$icol.push($i)
		$start:=$i+1
	End if 
Until ($i=-1)

If ($icol.length=0)
	return 
End if 

//mark:  --- do the menu
var $class : cs.MenuBuilder

$class:=cs.MenuBuilder.new()
$menu:=""

For ($i; 0; $icol.length-1)
	
	$start:=$icol[$i]
	If ($i=($icol.length-1))
		$end:=$lines.length
	Else 
		$end:=$icol[$i+1]
	End if 
	
	$itemText:=Substring($lines[$start]; 8)
	$tag:=Tools.str_extractTag($itemText)
	
	Case of 
		: ($tag="</@")  //  close this submenu
			$menu:=""
			continue
			
		: ($tag="<@")  // new submenu
			$menu:=$tag
			$class.appendMenu(""; $tag)
	End case 
	
	$class.appendItem($itemText; {parameter: String($start)+";"+String($end)}; $menu)
	
End for 

$choice:=Dynamic pop up menu($class.getRef())
$class.releaseAll()

If ($choice="")
	ABORT
End if 

//mark:  --- run the code
$icol:=Split string($choice; ";")
$code+=$lines.slice(Num($icol[0]); Num($icol[1])).join("\n")

// add Trace if there isn't one already
If (Not(Match regex("TRACE"; $code; 1)))
	$code+="\n\nTRACE"
End if 

$script:="<!--#4DCODE "+$code+"-->"
PROCESS 4D TAGS($script; $script)
ABORT
