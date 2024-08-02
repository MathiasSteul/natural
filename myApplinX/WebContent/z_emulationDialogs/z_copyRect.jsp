<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib  uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>
<gx:html  gx_context="com.sabratec.applinx.j2ee.framework.web.GXScreenBasedJspContext">

<style>
* { -moz-user-select: none; }
.copyTextCss
{
            font-family:Courier New;
            font-size:18px;
            white-space:pre;
}
body 
{
			margin:0px;
            cursor: default;
            unselectable:on;
            -moz-user-select: none;
}
.menuItem {font-family:sans-serif;font-size:10pt;width:100px;background-Color:menu;color:black}
.highlightItem {font-family:sans-serif;font-size:10pt;width:100px;background-Color:highlight;color:white}
.clickableSpan {padding:4;width:500;background-Color:blue;color:white;border:5px gray solid}


</style>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_constants.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_engine.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_keyboardMapping.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_browserUtil.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_log.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_stringUtil.js"></script>
<script language="javascript" src="../z_resourceReader.jsp?res=z_jsengine/z_event.js"></script>
<script src="../z_resourceReader.jsp?res=z_emulationDialogs/z_copyRect.js"></script>
<body oncontextmenu="return false;" onkeydown="clickMenu();return captureCopy(event);" onmousedown="clickMenu();return startRectangle(event);" onmouseout="onMouseOut(event);" onmouseup="onMouseUp(event);" ondrag="return cancelEvent(event);" onmousemove="return redrawRectangle(event);" onselectstart="return cancelEvent(event);" style="margin: 0px;">
<div id="dummyTextData"></div>
<div id="rect" class="highlightItem"  style="position:absolute;Z-INDEX: 103; overflow:hidden;">
	<gx:div id="textData"  style="LEFT: 0px;POSITION: absolute; TOP: 0px;" />
</div>
<br>
<div id="msg"><b>* Mark a rectangle with your mouse, and type CTRL+C to copy to the clipboard.</b></div>
<div id="menu1" onclick="clickMenu()" onmouseover="switchMenu(event);" onmouseout="switchMenu(event);" style="z-index:110;position:absolute;display:none;width:100px;background-Color:menu; border: outset 1px gray">
	<div class="menuItem" id="mnuRed" onmousedown="captureCopy(event);">&nbsp;Copy</div>
 </div>
<script>
	var element = document.getElementById('dummyTextData');
	element.innerHTML = document.getElementById('textData').innerHTML;
	element.onmousedown = function(event) {
		if (element.setCapture) {
			element.setCapture();
		}

		document.onmouseup = function() {
			if (element.releaseCapture) {
				element.releaseCapture();
			}

			document.onmousemove = null;
		};
	};

	element.unselectable = "on";
	element.onselectstart = function() {
		return false
	};
	if (element.style.userSelect) {
		element.style.userSelect = "none";
	}
	if (element.style.MozUserSelect) {
		element.style.MozUserSelect = "none";
	}
</script>

</body>

</gx:html>