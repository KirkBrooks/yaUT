//%attributes = {}

var $class : cs.TestMethod
var $file : 4D.File

$class:=cs.TestMethod.new("yaUT_example_1").run()

$file:=Folder(fk desktop folder).file("testlog.txt")
$class.writeToLog($file.open("write"))
SHOW ON DISK($file.platformPath)


