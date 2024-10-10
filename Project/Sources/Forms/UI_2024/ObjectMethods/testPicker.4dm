//Searchpicker sample code

Case of 
	: (Form event code=On Load)
		SearchPicker SET HELP TEXT("testPicker"; " yaUT method name")
		
	: (Form event code=On Data Change)
		//  changes after each keystroke
		
		
	: (Form event code=On Losing Focus)
		CALL FORM(Current form window; "UI_searchPicker"; Form.testPicker; "testPicker")
		
End case 
