<%@ taglib uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>
<html>
	<head>
		<style>
		<!--
		.menulink{
			text-align: left;
		}
		
		
		.menulink a{
			color:black;
			font-weight:bold;
			font-family:arial;
			font-size:12px;
			width:100%;
			height:100%;
			background-color: transparent;
			text-decoration: none;
			padding-bottom:5px;
			padding-top:5px;
			padding-left: 5px;
		}
		
		.menulink a:hover{
			color:black;
			background-color: #ECECEB;
		}
		-->
		</style>
		<gx:placeholder id="CssPlaceHolder">
			<link href="css/styles_instant.css" rel="STYLESHEET" TYPE="text/css"><!--  for design time -->
		</gx:placeholder>
		
	</head>
	<body>
	<gx:form>
				<table width="1250" height="100%" bgcolor="" align="center" border="0" cellspacing="3" cellpadding="0">
					<tr height="25px">
						<td colSpan="2" valign="top">
							<!-- Page Header -->
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td valign="top" style="font-family:DaxCondensed-Regular;padding-top:15px;padding-left:20px;background-image: url(images/Head.jpg);height:150;background-position: top left;color:white">
										<div style="font-size: 36px;font-weight: bold"><img src="images/BusinesTxt.gif"></div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr valign=top>
						<td height="100%" width="100px" valign="top">

							<table cellpadding="0" cellspacing="2" border="0" style="border:solid 2px #DBDBDB" height="100%">
							    <tr>
							        <td valign="top" style="background-image: url(images/TopBG.jpg);background-repeat: repeat-x;background-position: top left;" height="20">
							        	&nbsp;
							        </td>
							    </tr>
							    <tr>
							        <td valign="top">
							            <table id="beforeEmpty" class="BeforeMain_Menu" bgcolor="white" width="120" height="100%" border="0" cellpadding="0" cellspacing="0">
							                <tr>
							                    <td>&nbsp;</td>
							                    <td>
							                    	<table width=100% height=100% cellspacing=0 cellpadding=0 border=0>
													<tr>
														<td class="menulink" align=center valign=top>
															<a style="color:#114773;text-decoration:none;" href="logoff.jsp" target="_top">Logoff</a>
														</td>
													</tr>
													<tr>
														<td class="menulink" align=center valign=top>
															<a style="color:#114773;text-decoration:none;" href="#" onclick="location.href=location.href;" onMouseOver="window.status='Reload page';return true;" onMouseOut="window.status='';return true;">Refresh</a>
														</td>
													</tr>
													<tr>
														<td class="menulink" align=center valign=top>
															<a style="color:#114773;text-decoration:none;" href="#" onclick="gx_openConfig('z_admin/z_editConfig.jsp');">Edit configuration</a>
														</td>
													</tr>
													<tr id="gx_changeDirectionTrigger" style="display: none;">
														<td class="menulink" align=center valign=top>
															<a style="color:#114773;text-decoration:none;" href="#" onclick="gx_changeScreenDirection();">Change Direction</a>
														</td>
													</tr>
													<tr>
														<td class="menulink" align=center valign=top>
															<a style="color:#114773; text-decoration:none;;" href="#" onClick="return SubmitCustomKey();" onMouseOver="window.status='Other...';return true;" onMouseOut="window.status='';return true;">
														Other...</a>
														</td>
													</tr>
												</table>
							                    </td>
							                </tr>
										</table>
							     	</td>
								</tr>
							<tr>
								<td height="100%" valign="bottom"><img src="images/powered.jpg" ></td>
							</tr>
							 </table>
							<!-- Before Main Pane -->
						</td>
						<td width=80%>
							<gx:placeholder id="GXPagePlaceHolder">Design time page content</gx:placeholder>							
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="default">
								<center>
									
									<div id="errormsg" class="errorMsgStyle"></div>
									<table width="100%" align="right" border="0" cellpadding="1" cellspacing="0">
										<tr>
											<td align="center" style="font-family:DaxCondensed-Regular;padding-top:15px;padding-left:20px;background-image: url(images/Foot.jpg);height:32;background-position: top left;color:white">
													<gx:span id="ScreenIDLbl">Screen name:</gx:span>
											</td>
										</tr>
									</table>
								</center>
							</div>
						</td>
					</tr>
				</table>
			</gx:form>
		</body>
</html>
 