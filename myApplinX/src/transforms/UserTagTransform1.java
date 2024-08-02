package transforms;

import com.sabratec.applinx.presentation.tags.*;
import com.sabratec.applinx.presentation.event.*;

/**
 *  
 * This class is receiving an event on the creation of each type of tag
 * such as: "onNewTextField", "onNewLabel", "onNewButton", etc. It should be used for tag
 * level manipulations, such as changing the content and attributes, adding icons, etc. 
 * 
 */
public class UserTagTransform1 extends GXTagListener{

	private static final long serialVersionUID = 1L;
	
	public void onNewLabel(GXRenderEvent event, GXILabelTag label) {
        // Add here code that handles label fields (host protected fields).
        // Use event parameter to access the screen tag model and the host screen.
	}
	public void onNewTextField(GXRenderEvent event,GXITextFieldTag textField) {
        // Add here code that handles text fields (host unprotected fields).
        // Use event parameter to access the screen tag model and the host screen.
	}

	public void onNewButton(GXRenderEvent event, GXIButtonTag button) {
        // Add here code that handles instant buttons (host keys for example).
        // Use event parameter to access the screen tag model and the host screen.
	}
	public void onNewLink(GXRenderEvent event, GXILinkTag link) {
        // Add here code that handles links (host keys for example).
        // Use event parameter to access the screen tag model and the host screen.
	}
	
	public void onNewCheckbox(GXRenderEvent event, GXICheckboxTag checkbox) {
        // Add here code that handles instant checkboxes (As defined in ApplinX composer).
        // Use event parameter to access the screen tag model and the host screen.
	}
	public void onNewCombobox(GXRenderEvent event, GXIComboboxTag combox) {
        // Add here code that handles instant combo-boxes (As defined in ApplinX composer).
        // Use event parameter to access the screen tag model and the host screen.
	}
	public void onNewRadioButtonGroup(GXRenderEvent event,GXIRadioButtonGroupTag radioGroup) {
        // Add here code that handles instant radio buttons (As defined in ApplinX composer).
        // Use event parameter to access the screen tag model and the host screen.
	}

	public void onNewTable(GXRenderEvent event, GXITableTag table) {
        // Add here code that handles tables (As defined in ApplinX composer).
        // Use event parameter to access the screen tag model and the host screen.
	}
	public void onNewTableRow(GXRenderEvent event,GXITableRowTag tableRow) {
        // Add here code that handles table rows (as children of onNewTableRow).
        // Use event parameter to access the screen tag model and the host screen.
	}
	public void onNewTableCell(GXRenderEvent event,GXITableCellTag tableCell) {
        // Add here code that handles table cells (as children of onNewTableRow).
        // Use event parameter to access the screen tag model and the host screen.
	}

}
