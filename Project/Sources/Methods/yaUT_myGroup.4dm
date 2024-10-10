//%attributes = {"shared":true,"folder":"yaUC groups","lang":"en"}
/*  yaUT_myGroup
  Created: 2024-10-10T19:10:00.583Z  by Designer
  your comments here
*/
#DECLARE($priorTests : Collection)->$testsRun : Collection
//---
//mark:  --- Combined Methods
$testsRun:=$priorTests=Null ? [] : [].combine($priorTests)

return $testsRun