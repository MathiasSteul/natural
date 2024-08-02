// Copyright (c) 2001-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA
function globalOnLoad(gx_event){
	// use win.<SOMETHING> to access the page tags
	// for example: win.document.GX_form
	var win = gx_event.window;

	// activate page scope function if exits
	activateIfExists(gx_event,gx_event.window.pageOnLoad);
	
	// activate page scope user's script if exits (for internal usage, used by 'addCommand()' server-side function)
	activateIfExists(gx_event,gx_event.window.gx_pageCommandOnLoad);
	
	// register the page user exists once the page is loaded
	gx_engine.registerEvent(GXEventType.KEYDOWN,globalOnKeyDown);
	gx_engine.registerEvent(GXEventType.KEYPRESS,globalOnKeyPress);
	gx_engine.registerEvent(GXEventType.KEYUP,globalOnKeyUp);
	gx_engine.attachInputTagsEvent(GXEventType.FOCUS,globalInputOnFocus);
	gx_engine.attachInputTagsEvent(GXEventType.BLUR,globalInputOnBlur);
}

function labelFocus(element){ 
	element.style.backgroundColor = "lightblue";
}

function labelBlur(element){
	element.style.backgroundColor = "";
}

function globalInputOnFocus(theEvent){
	// gx_event is a cross browser object
	var gx_event = GXBrowserUtil.getGXEvent(theEvent);

	// define the look & feel of a input on focus
	//gx_event.element.style.backgroundColor = "lightblue";
}

function globalInputOnBlur(theEvent){
	// gx_event is a cross browser object
	var gx_event = GXBrowserUtil.getGXEvent(theEvent);

	// roll back the look & feel of a input on blur
	gx_event.element.style.backgroundColor = "";
}

function globalOnKeyDown(gx_event){
	// use win.<SOMETHING> to access the page tags
	// for example: win.document.GX_form
	var win = gx_event.window;
	
	// activate page scope function if exits
	activateIfExists(gx_event,gx_event.window.pageOnKeyDown);

	//gx_event.cancel(); // for cancel the event
}

function globalOnKeyPress(gx_event){
	
//	if (gx_emulator.isCursorModeOvertype(gx_event)) {
//		gx_engine.applyOvertypeCursorMode(gx_event);
//	}
	
	// use win.<SOMETHING> to access the page tags
	// for example: win.document.GX_form
	var win = gx_event.window;
	
	// activate page scope function if exits
	activateIfExists(gx_event,gx_event.window.pageOnKeyPress);

	//gx_event.cancel(); // for cancel the event
}

function globalOnKeyUp(gx_event){
	// use win.<SOMETHING> to access the page tags
	// for example: win.document.GX_form
	var win = gx_event.window;
	
	// activate page scope function if exits
	activateIfExists(gx_event,gx_event.window.pageOnKeyUp);

	//gx_event.cancel(); // for cancel the event
}

function globalOnFocus(gx_event){
	// use win.<SOMETHING> to access the page tags
	// for example: win.document.GX_form
	var win = gx_event.window;
	
	// activate page scope function if exits
	activateIfExists(gx_event,gx_event.window.pageOnFocus);
}

function activateIfExists(gx_event,functionElement){
	if (functionElement){
		functionElement(gx_event);
	}
}

// Used in down-up arrow navigation... metric is given ix pixels
function thresholdForPreferNavigationInScreenDirection(){
	return 2;
}

// Used in arrow navigation... metric is given ix pixels, 
// Define the vertical threshold for which elements will be considered in the same row
function thresholdForMatchElementsRow(){
	return 2;
}

//function initCursorMode(gx_event) { // possible mode: GXCursorMode.INSERT, GXCursorMode.OVERTYPE
//	gx_event.cursorMode = GXCursorMode.OVERTYPE;
//}


//sample code to show how to set a size for the calendar dialog
//@lang - web application language (some language can affect the size of the dialog)  
//function getCalendarSize (lang) {
//	return "width=600,height=600";
//}

//function initNavigationModeOnGeneratedPage(gx_event) {
//	gx_event.navigationMode = GXNavigationMode.NATIVE_BROWSER;
//}

/*
 
// sample code  of to check if modal window is supported.

function gx_IsSupportingModalWindow(){
	var ua = navigator.userAgent;
	if (ua){
		return !(( ua.indexOf("iPad")>-1) 
				|| (ua.indexOf("iPhone")>-1)
				|| (ua.indexOf("Mobile")>-1)
				|| (ua.indexOf("Android")>-1));
	}
	return true;
}
*/
if (typeof gx_engine !== 'undefined'){
	// register the file once
	gx_engine.registerEvent(GXEventType.INIT,globalOnLoad);
}
