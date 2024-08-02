<%@ page extends="com.sabratec.j2ee.framework.web.GXJspServlet"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib  uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>
<gx:html gx_context="com.sabratec.applinx.j2ee.framework.web.ndt.GXNdtDownloadContext">

	<head>
		<script>
		downloadImg = new Image();
		downloadImg.src="../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/download_dark.gif";
		cancelImg = new Image();
		cancelImg.src="../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/cancel_dark.gif";
		</script>
	    <style>
		BODY
		{
			font-family: Arial;
		}
	    </style>
	</head>

    <body>
    	<gx:form>
			<%@include file="/template/screenLocker.htm"%>
			<table align="center" width="100%">
				<tr>
					<td>
						<img src="../z_resourceReader.jsp?res=z_emulationDialogs/images/download.gif"/>
						<div style="font-size:18pt;">The host requires that you download a Natural file.</div>
						<br><br>
						Enter file name (required): <gx:input id="GX_ndtFileName" size="20" maxlength="20"/>
						<br><br>
						<gx:input id="downloadBtnServer" type="button" style="display:none" onserverclick="gx_performDownload"/>
						<gx:a id="downloadBtn" onmouseover="downloadImg.src='../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/download_dark.gif';" onmouseout="downloadImg.src='../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/download_light.gif';">
							<img name="downloadImg" src="../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/download_light.gif" title="Download" border="0"/></gx:a>
						<gx:a id="cancelBtn" onserverclick="gx_cancelDownload" 
						onmouseover="cancelImg.src='../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/cancel_dark.gif';" onmouseout="cancelImg.src='../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/cancel_light.gif';">
							<img name="cancelImg" src="../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/cancel_light.gif" title="Cancel" border="0"/></gx:a>
						<br><br>
						<gx:span id="errorMsg" style="color:red;font-size:14pt;"/>
						
					</td>
				</tr>
			</table>
			<script>
			parent.gx_engine.registerEvent(parent.GXEventType.LOAD,parent.GXNdtDownloadDialog.init);
			</script>
    	</gx:form>
    </body>
</gx:html>
