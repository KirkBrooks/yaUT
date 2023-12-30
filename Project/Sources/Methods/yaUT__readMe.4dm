//%attributes = {}
/*  yaUT__    (note this is a double underscore)
These methods manage the Storage object used by yaUT



*/

yaUT__initStorage({logResults: True})

yaUT__writeToLog("This is a test log message.")

SHOW ON DISK(Convert path POSIX to system(Storage.yaUT.logPath))

