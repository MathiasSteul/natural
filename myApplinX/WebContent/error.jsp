<%@ taglib uri="com/sabratec/j2ee/framework/tags" prefix="gx"%>
<gx:html gx_context="contexts.error">
<head>
<title>error</title>
</head>
<body>
	<gx:form>
		<div align="center" style="padding: 60px;">
			<div
				style="font-family: arial, verdana; width: 650px; color: 333333;">
				<div align="center"
					style="font-weight: bold; font-size: 16pt; background-color: #0899CC; color: white; padding: 5px">
					Error in Application
					<gx:span id="AppName" />
				</div>
				<div style="border: 2px solid #0899CC; padding: 20px">
					<div align="left" style="font-size: 15pt; color: #AF2227;" id="Div1">
						<gx:b id="errorMsg" style="font-weight: normal"/>
					</div>	
						<div align="left" style="font-size: 11pt;" id="Div2">
						<gx:b id="stackTrace" style="font-weight: normal"/>
					</div>											
					<img src="z_resourceReader.jsp?res=images/broken_link.png" align="right" width="100px" height="100px" style="padding: 15px">
					<div align="left" style="font-size: 12pt;">
						<br> Error Code:
						<gx:b id="errorCode" style="color:#AF2227;font-weight: normal;" />
						<br> <br>
						<p>
							<a href="gxfirstpage.jsp" style="color: #0899CC;">Try Again</a>
							or <a href="logoff.jsp" target="_top" style="color: #0899CC;">Logoff</a>
						</p>
						<br>
						<div style="font-size: 11pt;">
							If the problem persists contact your System Administrator <br>
							or check both ApplinX web application and Server logs.
						</div>
					</div>
				</div>
			</div>
		</div>
	</gx:form>
</body>
</gx:html>
