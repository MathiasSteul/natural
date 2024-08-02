<%@ page contentType="text/html; charset=utf-8" %>
<%@ page extends="com.sabratec.j2ee.framework.web.GXJspServlet"%>
<%@ taglib  uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>
<gx:html gx_context="contexts.GXInstantLogicContext">
	<head>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_engine.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_keyboardMapping.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_browserUtil.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_log.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_stringUtil.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_event.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_constants.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_changeIcon.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/dojo.js"></script>
		<link rel="stylesheet" type="text/css" href="css/instantWin.css">
		<link href="css/styles_instant.css" rel="STYLESHEET" TYPE="text/css">
	</head>
	<body>
		<gx:form>
			<div style="float: left; z-index: 0;">
				<gx:instantRenderer/>
			</div>
			<div id="gx_collapsingPFkeysPanel" style="z-index: 10;">
				<table style="border-collapse: 0px; border-spacing: 0px; ">
					<tr style="height: 100%; border-spacing: 0px;">
						<td></td>
						<td class="gx_collapsingPFkeysGreyCell">
							<jsp:include page="template/PFKeys.jsp"></jsp:include>
						</td>
					</tr>
					<tr style="height: 100%; border-spacing: 0px;">
						<td class="gx_collapsingPFkeysGreyCell" id="gx_collapsingPFkeysTab">
							<img alt="PF" id="gx_collapsingPFkeysImageButton"
								onmouseover="GXToolBarUtil.switchPanel();" src="z_resourceReader.jsp?res=images/double_arrows_left_24_white.png"
								collapsed_image="z_resourceReader.jsp?res=images/double_arrows_left_24_white.png" collapsed_width="24"
								expanded_image="z_resourceReader.jsp?res=images/double_arrows_right_24_white.png" expanded_width="174"
							 />
						</td>
						<td class="gx_collapsingPFkeysGreyCell"></td>
					</tr>
			</table>
		</div>
		</gx:form>
	</body>
</gx:html>

