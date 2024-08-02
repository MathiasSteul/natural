package contexts;

import java.util.HashMap;
import java.util.Map;

import org.w3c.dom.Element;

import com.sabratec.applinx.baseobject.*;
import com.sabratec.applinx.baseobject.table.GXITableRow;
import com.sabratec.applinx.framework.GXWebAppConfig;
import com.sabratec.applinx.framework.web.GXIScreenBasedWebEngine;
import com.sabratec.applinx.j2ee.framework.web.GXIHostPageContext;
import com.sabratec.applinx.j2ee.framework.web.GXScreenBasedJspContext;
import com.sabratec.applinx.j2ee.framework.web.events.*;

public class GXBasicContext extends GXScreenBasedJspContext
{
    /****************************************************************************************************************************
        ApplinX configuration is in config/gx_appConfig.xml
    *****************************************************************************************************************************/
    public void gx_initSessionConfig(){

        //GXWebAppConfig gx_appConfig = getGXAppConfig();

        // Optional variables for all the project pages, list of variables can be found in the documentation

        // for device name 
        //gx_appConfig.getSessionConfig().addVariable(GXBaseObjectConstants.GX_VAR_DEVICE_NAME, "<YOUR_DEVICE_NAME>");

        //For ApplinX session ID
        //gx_appConfig.getSessionConfig().setSessionId("<YOUR_SESSION_ID>");
    }
        
	public void gx_onInit(){
		super.gx_onInit();

		GXWebAppConfig gx_appConfig = getGXAppConfig();
		
		// customize gx_appConfig settings from code here

		GXIHostEvents userEvents = new UserFrameworkEvents();
		addHostListener(userEvents);
		
		//gx_appConfig.setHostKeysTagUserExit(new transforms.UserHostKeysTagTransform());
	}

	public void gx_preRender() {
		super.gx_preRender();
		// update tags in the template
		if (getGXSession() != null){
			try {
				getTagsAccesor().setTagContent("ScreenIDLbl",getGXSession().getScreen().getName());
			} catch (GXGeneralException ex) {
				gx_handleSessionError(ex);
			}
		}
	}

	public void gx_processHostKeyRequest(GXSendKeysRequest sendKeyRequest) throws GXGeneralException{
        // This function is activated from a browser pf key or when ENTER is pressed, or javascript:gx_SubmitKey(key)
        super.gx_processHostKeyRequest(sendKeyRequest);
    }
        
	// User exits for pop-ups manager
    public void gx_refreshWindow(){
		// Occurs when a pop-up window is closed.
		// Used to update the page in the main window.
		// By default (super.gx_refreshWindow()) , calls gx_handleHostReponse();

		super.gx_refreshWindow();
    }
    public void gx_closeWindow(){
        // occurs when a modal window is closed, in the modal window page.
        // Used for sending the appropriate pf key to the host, which closes the host window.

        super.gx_closeWindow();
        
        //gx_doCloseWindow("[pf3]");
    }
    // End of user exits for pop-up manager 

    
    // User exits for generated tables

    public void gx_changeTr(int RowIndex,Element tr,GXITableRow row){
        // Occurs every time a new table row (TR) with run-time data is created.
        // Allows you to customize the TR according to the current host row.

        // sample code : if a certain field contains dashes, hide the row
        /*
        if (row.getItemContent("<COLUMN_NAME>").indexOf("---") >= 0){
                tr.setAttribute("style","display:none");
        }
        */
    }

    public void gx_changeTd(int ColIndex,Element td,GXITableRow row){
        //Occurs every time a new table cell (TD) with run-time data is created.
        //Allows you to customize the table data TD according to the current host
        //row.

        // sample code : concat the table cell ItemNo from the host desc & qty fields
        /*            
        if (td.getAttribute("id").indexOf("ItemNo") >= 0){
            String desc = row.getItem("ItemDesc").getContent();
            String qty = row.getItem("Qty").getContent();
            td.getChildNodes().item(0).setNodeValue(desc + "-" + qty);
        }
        */             
    }
    public void gx_changeControl(int ColIndex,Element td,Element ctrl,GXITableRow row){
        // Occurs every time a new control inside a TD with run-time data is created.
        // Allows you to customize the controls according to the current host row.

        // sample code : hide the input field "ItemDesc" based on condition
        /*
        String ctrlId = ctrl.getAttribute("id"); 
        if (ctrlId != null && ctrlId.indexOf("ItemDesc") >= 0  ){ 
             ctrl.setAttribute("type", "hidden"); 
        } 
        */
    }
    
    
//    public Map<String, Map<Integer, Integer>> getColumnMappingPerResolution() {    															 	
// 		Map<String, Map<Integer, Integer>> columnsMappingPerResoluation = new HashMap<>();
//		
//		Map<Integer, Integer> lowResMapping = new HashMap<Integer, Integer>();
// 		lowResMapping.put(80, 10);
// 		lowResMapping.put(132, 8);
//
// 		Map<Integer, Integer> highResMapping = new HashMap<Integer, Integer> ();
// 		highResMapping.put(80, 21); 
// 		highResMapping.put(132, 17);
//
// 		columnsMappingPerResoluation.put(GXIScreenBasedWebEngine.LOW_RES_KEY, lowResMapping);
// 		columnsMappingPerResoluation.put(GXIScreenBasedWebEngine.HIGH_RES_KEY, highResMapping);
// 		
// 		return columnsMappingPerResoluation;
//	}
	// End of user exits for generated tables

}

class UserFrameworkEvents extends GXAbstractHostEvents
{
	// In all the following functions,
	// use gx_context.getGXSession() , gx_context.getRequest() , etc... to access the framework objects

	public void gx_preConnect(GXIHostPageContext gx_context,GXPreConnectEvent event)throws GXGeneralException{
		// Occurs before gx_connect , gx_attach 
		// Use event.isNewSession() to know if the user is going to be attached to an existing session or connecting to a new one. 
		// Use event.getSessionConfig() to change the connect to ApplinX server parameters.
	}

	public void gx_postConnect(GXIHostPageContext gx_context,GXPostConnectEvent event)throws GXGeneralException{
            // Occurs after gx_connect , gx_attach 
            // Use event.isNewSession() to know if the user was attached to an existing session or connected to a new one.
/*		if (event.isNewSession()){
			gx_context.getGXSession().executePath("Logon");
		}
*/	}

	public void gx_screenSeqMismatch(GXIHostPageContext gx_context,GXScreenSeqMismatchEvent event)throws GXGeneralException{
		// Occurs if the form seq. screen number is different from the gx_session seq. screen number.
		// Use event.setSendToHost(true) to send the data to the host any way. 

		// For debugging purposes when comparing the form seq. screen number to the session seq. screen number:
			//gx_context.getLogger().errorLog(Integer.toString(gx_context.getGXSession().getSeqScreenNumber()));
	        //gx_context.getLogger().errorLog(Integer.toString(gx_context.getGXForm().get_SeqScreenNumber()));
	} 

	public void gx_preSendKey(GXIHostPageContext gx_context,GXPreSendKeyEvent event)throws GXGeneralException{
		// Occurs before gx_processHostKeyRequest(GXSendKeysRequest sendKeyRequest),
		// which is activated from a browser pf key or when ENTER is pressed, or javascript:gx_SubmitKey(key).
		// Use event.getSendKeysRequest to change the send key request to ApplinX server.
	}

	public void gx_postSendKey(GXIHostPageContext gx_context,GXPostSendKeyEvent event)throws GXGeneralException{
		// Occurs after gx_processHostKeyRequest(GXSendKeysRequest sendKeyRequest),
		// which is activated from a browser pf key or ENTER is pressed, or javascript:gx_SubmitKey(key).
	}

	public void gx_preFillForm(GXIHostPageContext gx_context)throws GXGeneralException{
		// Occurs before gx_fillForm() or gx_fillForm(GXScreensCollection screen)
	}

	public void gx_postFillForm(GXIHostPageContext gx_context)throws GXGeneralException{
			// Occurs after gx_fillForm() or gx_fillForm(GXScreensCollection screen)
	}

	public void gx_preSyncHostWithForm(GXIHostPageContext gx_context,GXPreSyncHostWithFormEvent event)throws GXGeneralException{
		// Occurs before gx_syncHostWithForm, used to add parameters to the map path.
	}

	public void gx_preOpenWin(GXIHostPageContext gx_context,GXPreOpenWinEvent event) throws GXGeneralException{
		// Occurs before a window is opened, use event.setOpenWin(false), to cancel opening the window,
		// or to change the window size.

                //	if (gx_context.getGXSession().getScreen().getName().equals("<SCREEN NAME>")){
                //          event.setOpenWin(false);
                //	}
	}

	public void gx_changeNextForm(GXIHostPageContext gx_context,GXChangeNextFormEvent event)throws GXGeneralException{
		// Occurs before loading the next page, by gx_handleHostResponse.
		// Use event.setNextForm("<PAGE NAME>"), for example logon.jsp , to change the next page.
	}
}
