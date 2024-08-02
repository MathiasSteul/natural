package transforms;

import com.sabratec.applinx.baseobject.GXIScreen;
import com.sabratec.applinx.framework.web.hostkeys.GXHostKeysTagUserExit;
import com.sabratec.applinx.presentation.tags.*;

public class UserHostKeysTagTransform extends GXHostKeysTagUserExit{

	
	public void onHostKeysComplete(GXITableTag hostKeysTableTag, GXIScreen screen) {
	
		super.onHostKeysComplete(hostKeysTableTag, screen);

		/*
		// add link
		addLink("Host help","gx_SubmitKey('[pf1]')");

		//get all tags
		GXITag[] tags = getHostKeysTags();
		
		for (GXITag tag : tags) {
			if (tag instanceof GXILinkTag){ // or GXIButtonTag or GXHtmlString (for type="template")
				GXILinkTag link = (GXILinkTag) tag;

				// change tag text
				if (link.getText().indexOf("Prev") >= 0){
					link.setText("Previous");
				}
				
				//remove tag
				if (link.getText().indexOf("Pagedn") >= 0){
					removeTag(link);
				}
			}
		}
		*/
		
	}
}
