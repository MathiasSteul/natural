<%@ page contentType="text/html; charset=utf-8" %>
<%@ page extends="com.sabratec.j2ee.framework.web.GXJspServlet"%>
<%@ taglib  uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>
<gx:page gx_context="contexts.GXInstantLogicContext">
	<gx:template file="/template.jsp">
	   <gx:content placeholderid="CssPlaceHolder"> 
			<link href="css/styles_instant.css" rel="STYLESHEET" TYPE="text/css">
	   </gx:content>
	   <gx:content placeholderid="GXPagePlaceHolder"> 
			<gx:instantRenderer/>
	   </gx:content>
	</gx:template>
</gx:page>

