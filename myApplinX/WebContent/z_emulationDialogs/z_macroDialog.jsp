<%@ page extends="com.sabratec.j2ee.framework.web.GXJspServlet"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="com/sabratec/j2ee/framework/tags" prefix="gx"%>

<gx:html gx_context="com.sabratec.applinx.j2ee.framework.web.macros.GXMacroDialogImpl">
<HEAD>
<title>ApplinX Macro Creator</title>
<script src="../z_resourceReader.jsp?res=z_emulationDialogs/z_macros.js"></script>
</HEAD>
<body onload="window.focus();document.getElementById('UserMacroList').focus();window.setTimeout('window.focus()',1500);">

<gx:form id="macroDialog">
	<gx:input id="RemoveMacroBtn" type="button" style="DISPLAY:none" onserverclick="RemoveMacroBtn_ServerClick" />
	<gx:input id="playMacroAction" type="button" style="DISPLAY:none" onclick="if (!z_validateMacroRun()) return false;"
		onserverclick="playMacroBtn_ServerClick" />
	<TABLE id="Table1" style="WIDTH: 328px; HEIGHT: 100%;" cellSpacing="1" cellPadding="1" width="328" border="0">
		<TR>
			<TD style="HEIGHT: 33px">
				<TABLE id="Table2" cellSpacing="1" cellPadding="1" width="168" border="0"
					style="BORDER-RIGHT: thin solid; BORDER-TOP: thin solid; BORDER-LEFT: thin solid; WIDTH: 168px; BORDER-BOTTOM: thin solid; HEIGHT: 27px">
					<TR>
						<TD style="WIDTH: 48px">
							<img id=playMacroBtn src="../z_resourceReader.jsp?res=z_emulationDialogs/images/pathplay.gif" title="Play" border="0" 
							onclick="document.getElementById('playMacroAction').click();" style="cursor: hand" />
						</TD>
						<TD style="WIDTH: 43px">
							<gx:img id="OpenNameBtn" onclick="z_showNamePanel();" src="../z_resourceReader.jsp?res=z_emulationDialogs/images/pathrec.gif"
							title="Record" style="CURSOR:hand" />
						</TD>
						<TD style="WIDTH: 43px">
							<gx:img id="ViewBtn" onclick="z_openMacroView('z_macroView.jsp');" src="../z_resourceReader.jsp?res=z_emulationDialogs/images/path_edit.gif"
							title="View" style="CURSOR:hand" />
						</TD>
						<TD style="WIDTH: 35px">
							<gx:a id="stopMacroBtn" onserverclick="stopMacroBtn_ServerClick">
								<img src="../z_resourceReader.jsp?res=z_emulationDialogs/images/pathstop.gif"
									title="Stop" style="CURSOR: hand" border="0" />
							</gx:a>	
						</TD>
						<TD>
							<IMG onclick="z_removeMacro();" src="../z_resourceReader.jsp?res=z_emulationDialogs/images/remove.gif" title="Remove" style="CURSOR: hand" />
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>
				<P>Existing Macros:</P>
				<P>
					<gx:select id="UserMacroList" size="3" style="WIDTH: 144px" attributes="onkeyup='z_checkControlKeys(event);'" />
				</P>
			</TD>
		</TR>
		<TR>
			<TD>
				<BR />
				<div id="MacroNamePanel" style="VISIBILITY: hidden">
					<P>Macro Name : 
						<gx:input id="MacroName" type="text" size="14" onkeydown="z_clearError()" onkeypress="z_checkEnter(event);" />
						<br>
						<gx:input id="SimulateHost" type="checkbox" /> Simulate host delays
					</P>
					<P>&nbsp;&nbsp;
						<gx:input id="RecMacroBtn" type="button" value=" OK " onclick="if (!z_validateMacroName()) return false;" onserverclick="RecMacroBtn_ServerClick" />
						&nbsp;&nbsp;&nbsp;
						<input id="cancelBtn" onclick="z_cancelRecord();" type="button" value="Cancel" />
					</P>
				</DIV>
				<BR />
			</TD>
		</TR>
		<tr>
			<td>
				<gx:div id="errorMsg" style="color:red"></gx:div>
			</td>
		</tr>
		<tr>
			<td>
				<gx:div id="closeDiv" align="right"> 
				        <gx:input type="button" id="Close" onclick="z_closeMacro();" value="Close"/> 
				</gx:div>  
			</td>
		</tr>
	</TABLE>
</gx:form>

</body>

</gx:html>