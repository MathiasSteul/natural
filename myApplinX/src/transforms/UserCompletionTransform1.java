package transforms;

import com.sabratec.applinx.presentation.tags.*;
import com.sabratec.applinx.presentation.event.*;

/**
 * This class is receiving an "onComplete" event, 
 * which should be used for manipulating the entire tag model. 
 *
 */
public class UserCompletionTransform1 implements  GXICompletionListener{

	private static final long serialVersionUID = 1L;

    public void onComplete(GXRenderEvent event) {
        // Add here code that changes the entire screen tag model. 
        // Use event parameter to access the screen tag model and the host screen.
    }

}
