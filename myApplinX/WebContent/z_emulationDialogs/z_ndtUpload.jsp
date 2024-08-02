<%@ taglib  uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>
<gx:html gx_context="com.sabratec.applinx.j2ee.framework.web.ndt.GXNdtUploadContext">

	<head>
		<script>
		uploadImg = new Image();
		uploadImg.src="../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/upload_dark.gif";
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
    <gx:form onsubmit="return false;">
		<%@include file="/template/screenLocker.htm"%>
		<table align="center" width="100%">
			<tr>
				<td>
					<img src="../z_resourceReader.jsp?res=z_emulationDialogs/images/upload.gif"/>
					<div id="captionStart" style="font-size:18pt">The host requires that you upload a Natural file.</div>
					<br>
					<div style="font-size:14pt">
						Please select a local file to upload: <gx:input id="gx_fileUpload" type="file" size="50"/>
					</div>
					<br><br>
					<gx:input id="uploadBtnServer" type="button" style="display:none" onclick="document.getElementById('GX_ndtFileName').value=document.getElementById('gx_fileUpload').value; if (document.getElementById('GX_ndtFileName').value == '') {alert('No file selected. Select a file to upload.'); return;}" onserverclick="gx_performUpload"/>
					<gx:a id="uploadBtn"  href="#" onclick="document.getElementById('uploadBtnServer').click();" 
						onmouseover="uploadImg.src='../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/upload_dark.gif';" onmouseout="uploadImg.src='../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/upload_light.gif';">
						<img name="uploadImg" src="../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/upload_light.gif" title="Upload" border="0" onmouseover/></gx:a>
					<gx:a id="cancelBtn" onserverclick="gx_cancelUpload" 
						onmouseover="cancelImg.src='../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/cancel_dark.gif';" onmouseout="cancelImg.src='../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/cancel_light.gif';">
						<img name="cancelImg" src="../z_resourceReader.jsp?res=z_emulationDialogs/images/ndt/cancel_light.gif" border="0"/></gx:a>
					<br><br>
					<gx:span id="errorMsg" style="color:red; font-size:14pt;"/>
				</td>
			</tr>
		</table>
		<script>
		parent.gx_engine.registerEvent(parent.GXEventType.LOAD,parent.GXNdtUploadDialog.init);
		</script>
    </gx:form>
    </body>
</gx:html>
