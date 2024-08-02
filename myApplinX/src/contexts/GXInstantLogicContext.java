package contexts;

import com.sabratec.applinx.presentation.GXRenderConfig;

public class GXInstantLogicContext extends GXDefaultLogicContext 
{

	public void gx_onInit(){

        super.gx_onInit();

        getGXAppConfig().setIsInstant(true);
        
    }
    
    public void gx_preRender(){
    	 
        super.gx_preRender();
        
        GXRenderConfig instantConfig = getGXAppConfig().getInstantConfig();

        // Instant configuration

        registerInstantTransforms();
    }

    public void registerInstantTransforms() 
    {
        GXRenderConfig instantConfig = getGXAppConfig().getInstantConfig();
        //instantConfig.addTagListener(new transforms.UserTagTransform1());
		//instantConfig.addCompletionListener(new transforms.UserCompletionTransform1());
        // add here more transform registrations
    }
    
}