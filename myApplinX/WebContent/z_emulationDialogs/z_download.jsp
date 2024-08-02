<%@ taglib uri="com/sabratec/j2ee/framework/tags" prefix="gx"%>
<gx:html
	gx_context="com.sabratec.applinx.j2ee.framework.web.ftp.GXFtpDownloadDialogContext">
<HEAD>
<title>Applinx FTP Download</title>
<LINK href="../z_resourceReader.jsp?res=z_emulationDialogs/z_ftp.css" type="text/css" rel="stylesheet">
<script language="javascript" src="../z_resourceReader.jsp?res=z_emulationDialogs/z_Ftp.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_constants.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_engine.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_keyboardMapping.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_browserUtil.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_log.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_stringUtil.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_event.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_jsfuncs.js"></script>
</HEAD>

<body>
<gx:form id="Form1">
	<table width="95%" align="center" cellspacing="0" cellpadding="2" border="0">
		<TBODY>
			<tr>
				<td align="left" width=462>
					<table width="500" align="left" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td align="center" class="pt" width="200">File Download</td>
							
						</TR>
					</table>
				</td>		
			</TR>
			<tr>
				<td align="left" width=500>
					<%@ include file="ftpPanels/z_mainFtpTable.jsp" %>
					
					
					
					
					
					
				</td>
			
				
			</TR>
			<tr>
				<td align="left" width=500>
					<%@ include file="ftpPanels/z_mfFtpTable.jsp" %>
				</td>		
			</TR>
			<tr>
				<td align="left" width=462>
					<%@ include file="ftpPanels/z_as400FtpTable.jsp" %>
				</td>
			</TR> 
			<tr>
				<td align="left" width=462>
					<%@ include file="ftpPanels/z_additionalCommand.jsp" %>
				</td>
			</TR>
			<tr>
				<td align="left" width=462>
					<%@ include file="ftpPanels/z_ftpConvert.jsp" %>
				</td>
			</TR>
			<tr>
					<td class="pt2" >&nbsp</td><td>&nbsp</td>
			</TR>
			
			<tr>
				<td align="center">
					<gx:input id="btnDownload" onclick="if (!z_validateDownload()) return false; " onserverclick="btnDownload_ServerClick" 
							type="button" value="Download"  size="110"></gx:input>
						&nbsp; <gx:input id="button1" onclick="javascript:location.href='../z_resourceReader.jsp?res=z_emulationDialogs/z_ftpIndex.htm'" value="Back"
							type="button" ></gx:input>
					</td>
				</tr>	
				
				<tr>
					<td align="center" height="163" >
						<img src="../z_resourceReader.jsp?res=images/madewith.gif" border="0">
					</td>
				</tr>
			</table>
		</gx:form>
		 <%@ include file="../template/screenLocker.htm" %> 
	</body>
</gx:html>



