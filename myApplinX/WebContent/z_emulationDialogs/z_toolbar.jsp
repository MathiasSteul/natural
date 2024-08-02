<link href="z_emulationDialogs/z_toolbar.css" rel="STYLESHEET"
	TYPE="text/css">
<table id="emulationToolbar" width="100%" cellspacing="0"
	cellpadding="0" border="0"
	style="font-family: Tahoma; font-size: 12px; font-weight: bold; color: white; padding: 0;">
	<tr
		style="background-color: #666666; height: 40px; border-spacing: 0px;">
		<td colSpan="2" valign="top">
			<table cellpadding="0" cellspacing="0"
				style="border-spacing: 0; width: 100%">
				<tr>
					<td width="10%" align="left" valign="top"
						style="padding-left: 50px; padding-right: 15px; padding-top: 3px; padding-bottom: 0;"><input type="image"
						src="z_resourceReader.jsp?res=images/toolbar/img_BlueFlagSAG_100x36.png" onclick="return false;"/></td>
					<td align="left" valign="bottom"
						style="Color: white; font-size: 22px; padding-top: 12px; font-family: Trebuchet MS; padding-bottom: 3px;">ApplinX
						Web Emulation</td>
				</tr>
			</table>
		</td>

		<td align="right">
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td colSpan="2" align="right" valign="middle" style="height: 30px;">
						<table cellspacing="0" cellpadding="0">
							<tr>
								<td
									style="Color: white; font-size: 12px; font-family: Trebuchet MS"
									nowrap="nowrap">&nbsp;&nbsp;<B>Size:</B>&nbsp;
								</td>
								<td valign="middle" style="width: 20px">
									<div id="gx_font_size_tag" class="fontSizeTag"></div>
									<div id="fontSizes" class="fontSizeTableStyle"
										style="display: none">

										<table>
											<tr>
												<td onmouseover="this.className='rowOver';"
													onmouseout="this.className='';"
													onclick="gx_changeFontSize(0);">Default</td>
											</tr>
											<tr>
												<td onmouseover="this.className='rowOver';"
													onmouseout="this.className='';"
													onclick="gx_changeFontSize(10);">10</td>
											</tr>
											<tr>
												<td onmouseover="this.className='rowOver';"
													onmouseout="this.className='';"
													onclick="gx_changeFontSize(12);">12</td>
											</tr>
											<tr>
												<td onmouseover="this.className='rowOver';"
													onmouseout="this.className='';"
													onclick="gx_changeFontSize(14);">14</td>
											</tr>
											<tr>
												<td onmouseover="this.className='rowOver';"
													onmouseout="this.className='';"
													onclick="gx_changeFontSize(16);">16</td>
											</tr>
											<tr>
												<td onmouseover="this.className='rowOver';"
													onmouseout="this.className='';"
													onclick="gx_changeFontSize(18);">18</td>
											</tr>
											<tr>
												<td onmouseover="this.className='rowOver';"
													onmouseout="this.className='';"
													onclick="gx_changeFontSize(20);">20</td>
											</tr>
											<tr>
												<td onmouseover="this.className='rowOver';"
													onmouseout="this.className='';"
													onclick="gx_changeFontSize(22);">22</td>
											</tr>
											<tr>
												<td onmouseover="this.className='rowOver';"
													onmouseout="this.className='';"
													onclick="gx_changeFontSize(24);">24</td>
											</tr>										
										</table>
									</div>
								<td valign="bottom"
									style="height: 20px; width: 17px; padding: 10; outline: none"><input
									type="image"
									src="z_resourceReader.jsp?res=images/toolbar/emulation/dropDown_Arrow_original.png"
									onclick="gx_showHideFonts(); GXToolBarUtil.updateImageOnMouseOut(this); return false;"
									onmouseover="GXToolBarUtil.updateImageOnMouseOver(this);"
									onmouseout="GXToolBarUtil.updateImageOnMouseOut(this);"
									alt="Select different font size"
									title="Select different font size" /></td>

							</tr>
						</table>
					</td>

					<td colSpan="2" align="right" valign="middle" style="height: 30px;">
						<table cellspacing="0" cellpadding="0">
							<tr>
								<td
									style="Color: white; font-size: 12px; font-family: Trebuchet MS"
									nowrap="nowrap"><b>Style:</b>&nbsp;</td>
								<td valign="middle" style="width: 20px">
									<div id="gx_css_name" class="cssNameTag"></div>
									<div id="styles" class="cssTableStyle" style="display: none">
										<table id="CssTbl" width="100%"></table>
									</div>
								<td valign="bottom"
									style="height: 20px; width: 11px; padding: 10; outline: none;"><input
									type="image"
									src="z_resourceReader.jsp?res=images/toolbar/emulation/dropDown_Arrow_original.png"
									onclick="gx_showHideStyles(); GXToolBarUtil.updateImageOnMouseOut(this); return false;"
									onmouseover="GXToolBarUtil.updateImageOnMouseOver(this);"
									onmouseout="GXToolBarUtil.updateImageOnMouseOut(this);"
									alt="Select different style sheet"
									title="Select different style sheet" /></td>

							</tr>
						</table>
					</td>
					<td align="right" id="gx_changeDirectionTrigger"
						style="display: none"><input type="image"
						src="z_resourceReader.jsp?res=images/toolbar/emulation/screen_RTL_24_original.png"
						onclick="GXToolBarUtil.updateImageOnMouseClick(this);gx_changeScreenDirection(); return false;"
						onmouseover="GXToolBarUtil.updateImageOnMouseOver(this);"
						onmouseout="GXToolBarUtil.updateImageOnMouseOut(this);"
						id="changeDirection" title="Change direction"
						rtl_Hover="toolbar/emulation/screen_RTL_24_hover.png"
						ltr_Hover="toolbar/emulation/screen_LTR_24_hover.png"
						ltr_Basic="toolbar/emulation/screen_LTR_24_original.png"
						rtl_Basic="toolbar/emulation/screen_RTL_24_original.png"/></td>
					<td align="right" style="padding-left: 20"><input type="image"
						src="z_resourceReader.jsp?res=images/toolbar/emulation/refresh_24_original.png"
						onclick="gx_SubmitKey(''); GXToolBarUtil.updateImageOnMouseOut(this); return false;"
						onmouseover="GXToolBarUtil.updateImageOnMouseOver(this);window.status='Reload page';return true;"
						onmouseout="GXToolBarUtil.updateImageOnMouseOut(this);window.status='';return true;"
						width="24" height="24" id="refresh page" title="Refresh Page" /></td>

					<td align="right" style="padding-left: 20"><jsp:include
							page="/z_emulationDialogs/z_macroPanel2.jsp" flush="true" /></td>

					<td align="right" style="padding-left: 20"><input type="image"
						src="z_resourceReader.jsp?res=images/toolbar/emulation/copy_original.png"
						onclick="window.open('z_emulationDialogs/z_copyRect.jsp','copy','resizable=yes,status=yes,toolbar=no,scrollbars=yes,top=0,left=0,width=900,height=600'); GXToolBarUtil.updateImageOnMouseOut(this); return false;"
						onmouseover="GXToolBarUtil.updateImageOnMouseOver(this);"
						onmouseout="GXToolBarUtil.updateImageOnMouseOut(this);" width="24"
						height="24" title="Copy text from host screen" /></td>

					<td align="right" style="padding-left: 20"><input type="image"
						src="z_resourceReader.jsp?res=images/toolbar/emulation/ftp_original.png"
						onclick="gx_openFtpDialog('jsp'); GXToolBarUtil.updateImageOnMouseOut(this); return false;"
						onmouseover="GXToolBarUtil.updateImageOnMouseOver(this);"
						onmouseout="GXToolBarUtil.updateImageOnMouseOut(this);" width="24"
						height="24" title="FTP - file transfer" /></td>

					<td align="right" style="padding-left: 20"><input type="image"
						src="z_resourceReader.jsp?res=images/toolbar/emulation/printer_original.png"
						onclick="gx_showPrinter();  GXToolBarUtil.updateImageOnMouseOut(this); return false;"
						onmouseover="GXToolBarUtil.updateImageOnMouseOver(this);"
						onmouseout="GXToolBarUtil.updateImageOnMouseOut(this);" width="24"
						height="24" title="Host Print" /></td>

					<td align="right" style="padding-left: 20"><input type="image"
						src="z_resourceReader.jsp?res=images/toolbar/emulation/camera_original.png"
						onclick="gx_printScreen(); GXToolBarUtil.updateImageOnMouseOut(this); return false;"
						onmouseover="GXToolBarUtil.updateImageOnMouseOver(this);"
						onmouseout="GXToolBarUtil.updateImageOnMouseOut(this);" width="24"
						height="24" title="Print host screen snapshot" /></td>

		
					<td align="right" style="padding-left: 20;"><img alt=""
						src="z_resourceReader.jsp?res=images/toolbar/emulation/exit_24_original.png"
						height="24" width="24" id="logoff"
						onclick="return GXToolBarUtil.logOffOnClick(this);"
						onmouseover="GXToolBarUtil.updateImageOnMouseOver(this);"
						onmouseout="GXToolBarUtil.updateImageOnMouseOut(this);"
						title="Logoff" /></td>
				</tr>
			</table>
		</td>


		<td style="height: 40px; width: 20px;" />
	</tr>
</table>