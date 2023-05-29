/*  TestElement class
 Created by: Kirk as Designer, Created: 05/27/23, 08:08:55
 ------------------
*/
Class extends ObjectProto

Class constructor($test : Text; $formula)
	Super()
	This._test:=$test
	This._formula:=$formula
	This._formulaResult:=Null
	This._id:=Lowercase(Substring(Generate UUID; 14; 6))
	
	
	
	
	//mark:  --- computed attributes
Function get isClass : Boolean
	return Value type(This._formula)=Is object && OB Instance of(This._formula; 4D.Class)
	
Function get isEntity : Boolean
	return Value type(This._formula)=Is object && OB Instance of(This._formula; 4D.Entity)
	
Function get isEntitySelection : Boolean
	return Value type(This._formula)=Is object && OB Instance of(This._formula; 4D.EntitySelection)
	
Function get isFormula : Boolean
	return Value type(This._formula)=Is object && OB Instance of(This._formula; 4D.Function)
	
Function get isUndefined : Boolean
	return Value type(This._formula)=Is undefined
	
Function get id : Text
	return This._id
	
Function get name : Text
	return This._test
	
	//mark:  --- expect
Function expect() : cs.TestElement
	var $parmas : Collection
	$parmas:=Copy parameters(1)
	
	If (This.isClass)  //  requires some parameters, assumes first param is function
		Case of 
			: (Count parameters=0)
			: ($parmas.length=1)
				This._formulaResult:=This._formula[$parmas[0]]
		End case 
	End if 
	
	
	Case of 
		: (Count parameters=0)
			This._formulaResult:=(This._formula#Null) ? This._formula.call() : This._formulaResult
			
		: (This._formula=Null)  // parameters but no formula
			This._formulaResult:=$parmas[0]
			
		: (Value type($parmas[0])=Is text) && ($parmas[0][[1]]=".")
			// 
			
		Else 
			This._formulaResult:=This._formula.apply(Null; $parmas)
	End case 
	
	return This
	
	//mark:  --- matchers
Function toBe($expectedValue : Variant) : Boolean
	return This.compare($expectedValue; This._formulaResult; True)
	
Function notToBe($expectedValue : Variant) : Boolean
	return Not(This.toBe($expectedValue))
	
Function toBeTruthy() : Boolean
	//  check the formulaResult for Truthyness
	
	Case of 
		: (This._formulaResult=Null)
			return False
			
		: (Value type(This._formulaResult)=Is object) && (OB Is empty(This._formulaResult))
			return False
			
		: (Value type(This._formulaResult)=Is collection) && (This._formulaResult.length=0)
			return False
			
		: (Value type(This._formulaResult)=Is date) && (This._formulaResult=!00-00-00!)
			return False
			
		: (String(This._formulaResult)="") || (String(This._formulaResult)="0")
			return False
			
		Else 
			return True
	End case 
	
Function toBeFalsy() : Boolean
	return Not(This.toBeTruthy())
	
Function toEqual() : Boolean
	
Function toHaveLength($len : Integer) : Boolean
	//  collections and strings
	Case of 
		: (Value type(This._formulaResult)=Is text)
			return Length(This._formulaResult)>=$len
		: (Value type(This._formulaResult)=Is collection)
			return This._formulaResult.length>=$len
	End case 
	
Function toHaveProperty($path : Variant; $value : Variant) : Boolean
	// true if the path exists in the formulaResult
	// $path is a dot-notation path or an collection of properties
	// If value is passed the value of the path is compared to $value and TRUE if the match
	
	var $result : Variant
	
	Case of 
		: (Value type($path)=Is text)
			$result:=This.getObjectValueByPath(This._formulaResult; $path)
		: (Value type($path)=Is text)
			$result:=This.getObjectValueByColl(This._formulaResult; $path)
	End case 
	
	If (Count parameters=2)
		return This.compare($value; $result)
	Else 
		return $result#Null
	End if 
	
Function toContain($item : Variant) : Boolean
	//  Use .toContain when you want to check that an item is in an array. 
	If (Value type(This._formulaResult)=Is collection)
		return This._formulaResult.indexOf($item)>0
	End if 
	
Function toBeGreaterThan($number : Real) : Boolean
	If (Value type(This._formulaResult)=Is real)
		return This._formulaResult>$number
	End if 
	
Function toBeLessThan($number : Real) : Boolean
	If (Value type(This._formulaResult)=Is real)
		return This._formulaResult<$number
	End if 
	
Function toMatch($pattern : Text) : Boolean
	// Use .toMatch to check that a string matches a regular expression.
	If (Value type(This._formulaResult)#Is text)
		return 
	End if 
	
	return Match regex($pattern; This._formulaResult; 1)
	
	//mark:  --- other functions
Function getFormulaResult : Variant
	return This._formulaResult