//%attributes = {}
executeSnippet()


//mark:  --- new Groups_API class
var $class : cs.Groups_API

$class:=cs.Groups_API.new()
$class.groups[0]._save()

//mark:  --- long long
var $x; $p1; $p2; $p3 : Real
$x:=1.844674407371e+19

$p1:=Formula from string("0x2B7E151628AED2A5").call()

