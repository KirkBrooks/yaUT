//%attributes = {}


var $f : 4D.Function
$f:=Formula(myMethod($1))
$name:=$f.call(Null; New object("name"; "Kirk"))



$test:=cs.UnitTest.new("eval testing").expect("Kirk").toEqual($f; New object("name"; "Kirk"))


$test._eval(New collection($f; New object("name"; "Kirk")))


