package contexts;

import java.io.IOException;


public class error extends GXBasicContext
{
	public void gx_onLoad(){

		super.gx_onLoad();
		
		//customizeErrorHanding();
	} 
	
	public void gx_onInit(){
		super.gx_onInit();
		
	}
	
	/*
	public void customizeErrorHanding(){
		// Get Error details from the Request object
		String msg = getRequest().getParameter("err");
		String code = getRequest().getParameter("errCode");
		
		// Get user locale language
		String lang = getRequest().getLocale().getLanguage();
		
		//Replace default message with translation according to locale language
		if (msg.equals("User is not connected")){
			if (lang.equals("de"))  // If German
				getTagsAccesor().setTagContent("errorMsg", "Benutzer ist nicht angeschlossen");

		}
	}
	*/
	
}