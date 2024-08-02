<%@page import="com.sabratec.applinx.common.copyright.GXCopyright"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page extends="com.sabratec.j2ee.framework.web.GXJspServlet"%>
<%@ taglib  uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>

<gx:html gx_context="contexts.GXBasicContext">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
	<HEAD>
		<script src="z_resourceReader.jsp?res=definedHost.js"></script>
		<script src="z_resourceReader.jsp?res=z_inc/z_jsfuncs.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/dojo.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/modernizr.js"></script>
		<script src="js/userExits.js"></script>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_featuresDetect.js"></script>
		<script type="text/javascript">
		function connect(){
			if ((typeof host != 'undefined') &&( host != null && host.requireAuth == true)){ 
				document.location = "hostLogin.jsp";				
			} else {
				document.location = "gxfirstpage.jsp";				 
			}

		}
	
		</script>
		<link rel="icon" type="image/x-icon" href="favicon.ico"/>
	</HEAD>
	<BODY bgcolor="#ffffff">
	<gx:form>
		<center> 
			<br> 
			<br>
			<table border="0" cellspacing="0" cellpadding="0" style="color:white;font-size:12px;font-family:'Avenir LT W01_95 Black1475556', Arial;width:510px;height:320px;background-repeat: no-repeat" background="z_resourceReader.jsp?res=images/applinx-splash-96.png">
				<tr><td style="height:170px" colspan="3">&nbsp;</td></tr>
				<tr>
					<td width="40" rowspan="3" valign="top">&nbsp;</td>
					<td width="110">Version:</td>
					<td width="360"><gx:span id="ApplinX_version" /></td>
				</tr>
				<tr>
					<td>Server address:</td>
					<td><gx:span id="serverURL">applinx://localhost:2323</gx:span></td>
				</tr>
				<tr>
					<td>Application name:</td>
					<td><gx:span id="applicationName">First Application</gx:span></td>
				</tr>
				<tr>
					<td style="padding-right:40px;padding-top:10px;padding-bottom:5px;" valign="top" align="right" colspan="3">
						<a href="#" style="color:white;font-weight: bold;" onclick="connect();" title="Connect to ApplinX application">Connect</a>
						&nbsp;&nbsp;
						<a href="#" style="color:white;font-weight: bold;"  onclick="gx_openConfig('z_admin/z_editConfig.jsp');" title="Edit ApplinX Framework configuration">Configuration</a>
					</td>
				</tr>
				<%
				String str = GXCopyright.getCopyright().replaceAll("<br>", "");
				String copyright = new StringBuilder(str).insert(str.length()-77, "<br>").toString();
				%>
				<tr><td width="40" rowspan="3" valign="top">&nbsp;</td><td style="padding-bottom:10px;color:white;font-family:'Avenir LT W01_95 Black1475556', Arial;font-weight:normal;font-size:9px;" colspan="3"><%=copyright%></td></tr>
			</table>
		</center>
		<br>
		<br>
		<br>
		<br>
		<br>
		<center>
		</center>
		</gx:form>
	</BODY>
</gx:html>