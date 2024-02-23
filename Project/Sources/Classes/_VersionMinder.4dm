/*  VersionMinder class
 Created by: Kirk as Designer, Created: 01/02/24, 11:09:11
 ------------------
Version: <major>.<minor>.<patch> <build>

*/
Class constructor
	This._major:=0
	This._minor:=0
	This._patch:=0
	This._build:=0
	This._readMethod()
	
	//mark:  --- getters
Function get version : Text
	return String(This._major)+"."+String(This._minor)+"."+String(This._patch)+" "+String(This._build; "00000")
	
Function get Major : Integer
	return This._major
	
Function get Minor : Integer
	return This._minor
	
Function get Patch : Integer
	return This._patch
	
Function get Build : Integer
	return This._build
	
	//mark:  --- functions
Function setMajor($value : Integer) : cs._VersionMinder
	This._updateValue("_major"; Count parameters=1 ? $value : This._major+1)
	return This
	
Function setMinor($value : Integer) : cs._VersionMinder
	This._updateValue("_minor"; Count parameters=1 ? $value : This._minor+1)
	return This
	
Function setPatch($value : Integer) : cs._VersionMinder
	This._updateValue("_patch"; Count parameters=1 ? $value : This._patch+1)
	return This
	
Function setBuild($value : Integer) : cs._VersionMinder
	This._updateValue("_build"; Count parameters=1 ? $value : This._build+1)
	return This
	
	//mark:  --- private
Function _updateValue($what : Text; $value : Integer)
	If (Is compiled mode)
		return   // no fooling around
	End if 
	This[$what]:=$value
	This._updateMethod()
	
Function _readMethod
	var $version; $build; $errMethod : Text
	var $col : Collection
	
	$errMethod:=Method called on error
	ON ERR CALL("Err_ignore")
	EXECUTE METHOD("thisVersion"; $version)
	ON ERR CALL($errMethod)
	
	If (Bool(OK))  //  parse the version method
		$build:=Substring($version; Position(" "; $version))
		$col:=Split string(Substring($version; 1; Position(" "; $version)); "."; sk ignore empty strings+sk trim spaces)
		
		This._major:=Num($col[0])
		This._minor:=Num($col[1])
		This._patch:=Num($col[2])
		This._build:=Num($build)
		
	End if 
	
Function _updateMethod()
	var $code : Text
	If (Is compiled mode)
		return   // no fooling around
	End if 
	
	$code:="#DECLARE : Text \n // "+Timestamp+"\n // user: "+Current user()+"\n"
	$code+="return \""+This.version+"\"\n"
	
	METHOD SET CODE("thisVersion"; $code)