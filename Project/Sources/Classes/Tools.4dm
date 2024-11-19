/*  Tools singleton class
 Created by: Kirk Brooks as Designer, Created: 11/10/24, 20:02:32
 ------------------


*/
Class constructor
	This.rgPattern:="[^a-zA-Z0-9\\s]"
	
	//mark:  --- String functions
Function str_toCapitalCase($textIn : Text; $joinChar : Text) : Text
	var $words : Collection
	
	If ($textIn="")
		return ""
	End if 
	
	$joinChar:=Count parameters=2 ? $joinChar : " "
	$textIn:=Lowercase($textIn; *)
	$textIn:=Replace string($textIn; "_"; " ")
	$words:=Split string($textIn; " "; sk ignore empty strings+sk trim spaces)
	$words:=$words.map(Formula(Uppercase($1.value[[1]])+Substring($1.value; 2)))
	return $words.join($joinChar)
	
Function str_toCamelCase($textIn : Text) : Text
	
	If ($textIn="")
		return ""
	End if 
	
	$textIn:=This.str_replace(Lowercase($textIn); This.rgPattern; " ")
	$textIn:=This.str_toCapitalCase($textIn; "")
	return Lowercase($textIn[[1]])+Substring($textIn; 2)
	
Function str_toKebabCase($textIn : Text) : Text
	If ($textIn="")
		return ""
	End if 
	$textIn:=This.str_replace(Lowercase($textIn); This.rgPattern; " ")
	return Replace string($textIn; " "; "-")
	
Function str_toSnakeCase($textIn : Text) : Text
	If ($textIn="")
		return ""
	End if 
	$textIn:=This.str_replace(Lowercase($textIn); This.rgPattern; " ")
	return Replace string($textIn; " "; "_")
	
Function str_toModuleCase($textIn : Text)->$textOut : Text
	// MOD_withCamelCase
	var $words : Collection
	
	If ($textIn="")
		return ""
	End if 
	
	$textIn:=This.str_replace(Lowercase($textIn); This.rgPattern; " ")
	$textOut:=Uppercase(This.str_chomp(->$textIn; " "))+"_"  // the module
	$textOut+=This.str_toCamelCase($textIn)
	
Function str_chomp($ptr : Pointer; $delim : Text)->$chompText : Text
	// 'chomps' off the string from start to $delim and returns it
	var $pos : Integer
	If ($ptr=Null)
		return ""
	End if 
	
	$pos:=Position($delim; $ptr->; *)
	$chompText:=Substring($ptr->; 1; $pos-1)
	$ptr->:=Substring($ptr->; $pos+1)
	
Function str_extractTag($textIn : Text)->$tag : Text
	// will extract a tag defined as <tag or </tag to the first >
	// includes attributes
	var $pos; $len : Integer
	
	$pos:=Position("<"; $textIn)
	$len:=Position(">"; $textIn; $pos)-$pos
	
	If ($textIn="") || ($pos=0) || ($len=0)
		return ""
	End if 
	$len+=1  // get the closing >
	return Substring($textIn; $pos; $len)
	
	//mark:  --- regex funtions
Function str_extract($textIn : Text; $pattern : Text; $start : Integer) : Text
	// find match to pattern
	var $pos; $len; $count : Integer
	
	If ($textIn="") || ($pattern="")
		return $textIn
	End if 
	
	$start:=Num($start<=0) ? 1 : $start
	
	If (Match regex($pattern; $textIn; $start; $pos; $len))
		return Substring($textIn; $pos; $len)
	End if 
	
Function str_replace($textIn : Text; $pattern : Text; $newstr : Text; $howMany : Integer; $start : Integer) : Text
	// regex find and replace
	var $pos; $len; $count : Integer
	
	If ($textIn="") || ($pattern="")
		return $textIn
	End if 
	
	$start:=Num($start<=0) ? 1 : $start
	$howMany:=$howMany || MAXLONG
	
	While (Match regex($pattern; $textIn; $start; $pos; $len)) && ($count<$howMany)
		$textIn:=Delete string($textIn; $pos; $len)
		$textIn:=Insert string($textIn; $newstr; $pos)
		
		$count+=1
	End while 
	
	return $textIn
	
	//mark:  --- windows
Function windowInfo($windowRef : Integer)->$obj : Object
	var $l; $t; $r; $b : Integer
	
	$windowRef:=$windowRef || Frontmost window
	
	$obj:={}
	$obj.ref:=$windowRef
	$obj.title:=Get window title($windowRef)
	GET WINDOW RECT($l; $t; $r; $b; $windowRef)
	$obj.coords:={l: $l; t: $t; r: $r; b: $b; width: $r-$l; height: $b-$t}
	$obj.kind:=Window kind($windowRef)
	$obj.pid:=Window process($windowRef)
	// $obj.pName:=Process name($obj.pid)
	
Function getWindowList : Collection
	// return collection of window refs w/ process info
	var $col : Collection
	var $i : Integer
	ARRAY LONGINT($aWindows; 0)
	
	WINDOW LIST($aWindows)
	$col:=[]
	For ($i; 1; Size of array($aWindows))
		$col.push(This.windowInfo($aWindows{$i}))
	End for 
	return $col
	
	//mark:  --- date functions
Function getTimeZone : Integer
	// Purpose: return the number of delta hours between this computer and GMT
	var $tLocal : Time
	$tLocal:=Time(Substring(Timestamp; 12; 8))  // local
	return Num(Time(Timestamp)-$tLocal)/(60*60)
	
Function dateFromString($string : Text) : Date
	var $year; $month; $day : Integer
	var $str : Text
	
	Case of 
		: (Match regex("\\d\\d\\d\\d-\\d\\d-\\d\\d"; $string; 1))
			$year:=Num(Substring($str; 1; 4))
			$month:=Num(Substring($str; 5; 2))
			$day:=Num(Substring($str; 7; 4))
			return Add to date(!00-00-00!; $year; $month; $day)
			
		Else 
			return Date($string)
			
	End case 
	
Function getMonthName($input) : Text
	var $i : Integer
	
	Case of 
		: (Value type($input)=Is longint)
			$i:=$input
			
		: (Value type($input)=Is date)
			$i:=Month of($input)
	End case 
	
	If ($i>=0) || ($i<13)
		return [""; "January"; "February"; "March"; "April"; "May"; "June"; "July"; "August"; "September"; "October"; "November"; "December"][$i]
	Else 
		return ""
	End if 
	
Function getMonthAbrv($input) : Text
	return Substring(This.getMonthName($input); 1; 3)
	
Function lastOfMonth($date : Date) : Date
	return Add to date(!00-00-00!; Year of($date); Month of($date)+1; 1)-1
	
Function firstOfMonth($date : Date) : Date
	return Add to date(!00-00-00!; Year of($date); Month of($date); 1)
	
Function getQuarter($date : Date) : Integer
	return [0; 1; 1; 1; 2; 2; 2; 3; 3; 3; 4; 4; 4][Month of($date)]
	
Function getFYquarter($date : Date; $fyStartQtr : Integer)->$fyQtr : Integer
	// $fyQtr is fy start quarter
	$fyQtr:=This.getQuarter($date)
	
	If ($fyStartQtr<2)
		return 
	End if 
	
	If ($fyQtr=$fyStartQtr)
		return 1
	End if 
	
	$fyQtr+=$fyStartQtr
	$fyQtr-=$fyQtr>4 ? ($fyStartQtr-1) : 0
	return 
	
Function lastOfQuarter($date : Date) : Date
	var $qtr : Integer
	$qtr:=This.getQuarter($date)
	return This.lastOfMonth(Add to date(!00-00-00!; Year of($date); [0; 3; 6; 9; 12][$qtr]; 1))
	
Function firstOfQuarter($date : Date) : Date
	var $qtr : Integer
	$qtr:=This.getQuarter($date)
	return Add to date(!00-00-00!; Year of($date); [0; 1; 4; 7; 10][$qtr]; 1)
	
Function firstOfYear($date : Date) : Date
	return Add to date(!00-00-00!; Year of($date); 1; 1)
	
Function lastOfYear($date : Date) : Date
	return Add to date(!00-00-00!; Year of($date); 12; 31)
	
Function weekNumberISO($inputDate : Date)->$result : Object
	// Calculate ISO week number for a given date
	// returns {year: 0; weekNum; 0; $startDate; !!; $endDate: !!}
	var $jan1; $jan4; $mondayOfJan4; $weekStart; $weekEnd; $prevYearDec31; $dec31 : Date
	var $dayDiff; $weekNum; $dayNum : Integer
	
	$jan1:=Add to date(!00-00-00!; Year of($inputDate); 1; 1)
	$jan4:=Add to date($jan1; 0; 0; 3)
	$dayNum:=Day number($jan4)
	$mondayOfJan4:=Add to date($jan4; 0; 0; -(($dayNum+5)%7+1)+1)
	
	$dayDiff:=$inputDate-$mondayOfJan4
	$weekNum:=($dayDiff\7)+1
	
	// Calculate week start (Monday) and end (Sunday)
	$dayNum:=Day number($inputDate)
	$weekStart:=Add to date($inputDate; 0; 0; -(($dayNum+5)%7+1)+1)
	$weekEnd:=Add to date($weekStart; 0; 0; 6)
	
	If ($dayDiff<0)
		// Instead of recursing, directly calculate last week of previous year
		$prevYearDec31:=Add to date($jan1; -1; 11; 31)
		$dayNum:=Day number($prevYearDec31)
		If ((($dayNum+5)%7+1)<=3)  // If Dec 31 is Mon/Tue/Wed
			$weekNum:=1
			// Year stays current year
		Else 
			$weekNum:=52+Num((($dayNum+5)%7+1)>3)  // 52 or 53 depending on weekday
			// Adjust year to previous year
			$result:=New object(\
				"year"; Year of($inputDate)-1; \
				"weekNum"; $weekNum; \
				"startDate"; $weekStart; \
				"endDate"; $weekEnd)
			return $result
		End if 
	End if 
	
	If ($weekNum>52)
		$dec31:=Add to date($jan1; 0; 11; 31)
		$dayNum:=Day number($dec31)
		If ((($dayNum+5)%7+1)<=3)  // If Dec 31 is Mon/Tue/Wed
			$weekNum:=1
		End if 
	End if 
	
	$result:=New object(\
		"year"; Year of($inputDate); \
		"weekNum"; $weekNum; \
		"startDate"; $weekStart; \
		"endDate"; $weekEnd)
	
	
	
	