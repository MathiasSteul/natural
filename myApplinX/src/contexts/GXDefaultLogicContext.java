package contexts;

import java.io.IOException;

import com.sabratec.util.GXLog;

public class GXDefaultLogicContext extends GXBasicContext 
{
	public void gx_onLoad(){

		super.gx_onLoad();

		try{
			gx_doFrameWorkLogic();	
		}catch(IOException err){
			GXLog.exception(this,err,err.getMessage());
		}

	}

	public void gx_onInit(){

		//GXWebAppConfig gx_appConfig = getGXAppConfig();
		//gx_appConfig.setScreenLocker("template//screenLocker.jsp");
		super.gx_onInit();
	}
	
}