<%@ page extends="com.sabratec.j2ee.framework.web.GXJspServlet"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib  uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>
<gx:html gx_context="com.sabratec.applinx.j2ee.framework.web.macros.GXMacroViewContext">

  <HEAD>
	<title>ApplinX Macro Creator</title>
	<script src="z_resourceReader.jsp?res=z_emulationDialogs/z_macros.js"></script>
	</HEAD>

<body onload="window.focus();">
<gx:form id="macroDialog">


<img src="../z_resourceReader.jsp?res=z_emulationDialogs/images/pathmngr.gif"/> <font size="6">Macro : <gx:span id="macroName"></gx:span></font>
<br><br>
<gx:div id="macroSteps" style="position:relative; width:270; height:175; overflow-y: scroll; overflow-x: hidden; border-bottom:1px solid white;">
</gx:div>
<br>
<a href="javascript:history.back(1);">Back</a>
</gx:form>
</body>
</gx:html>
