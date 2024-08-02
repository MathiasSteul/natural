<%@ page contentType="text/html; charset=utf-8" %>
<%@ page extends="com.sabratec.j2ee.framework.web.GXJspServlet"%>
<%@ taglib  uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>

<gx:page gx_context="com.sabratec.applinx.j2ee.framework.web.GXHostLoginContext">
	<gx:template file="/template.jsp">
	   <gx:content placeholderid="CssPlaceHolder"> 
			<link href="css/styles_generated_relative.css" rel="STYLESHEET" TYPE="text/css">
	   </gx:content>
	   <gx:content placeholderid="GXPagePlaceHolder"> 
			<div style="align:center;position:absolute">
			<table width="100%" height="100%">
				<tr height="30%"><td>&nbsp;</td></tr>
				<tr valign="top">
					<td>
				   		<table>
				   			<tr>
				   				<td>User:</td>
				   				<td><gx:input type="text" id="GXUser" style="width:100px"/></td>
				   			</tr>
				   			<tr>
				   				<td>Password:</td>
				   				<td><gx:input type="password" id="GXPassword" style="width:100px"/></td>
				   			</tr>
				   			<tr>
				   				<td>New Password:</td>
				   				<td><gx:input type="password" id="GXNewPassword" style="width:100px"/></td>
				   			</tr>
				   			<tr id="GXConfirmArea" style="visibility: hidden">
				   				<td>Confirm Password:</td>
				   				<td><gx:input type="password" id="GXConfirmPassword" style="width:100px"/></td>
				   			</tr>
				   			<tr>
				   				<td colspan="2"><gx:input type="button" id="GXLoginBtn" value="Login"/></td>
				   			</tr>				   			
				   		</table>
					</td>
				</tr>
			</table>
			<gx:span id="GXErrorMessage" style="color:red;width:400px">&nbsp;</gx:span>
			</div>
	   </gx:content>
	</gx:template>
</gx:page>
