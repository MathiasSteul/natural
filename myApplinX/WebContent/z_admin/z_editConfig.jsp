<%@ page extends="com.sabratec.j2ee.framework.web.GXJspServlet"%>
<%@ taglib uri="com/sabratec/j2ee/framework/tags" prefix="gx"%>
<gx:html
	gx_context="com.sabratec.applinx.j2ee.framework.web.GXAppConfigDialogContext">
<head>
<title>ApplinX Framework Configuration</title>
<link href="../z_resourceReader.jsp?res=z_admin/z_admin.css"
	rel="STYLESHEET" TYPE="text/css">
<script src="../z_resourceReader.jsp?res=z_admin/z_admin.js"></script>
<script src="../z_resourceReader.jsp?res=z_jsengine/z_constants.js"></script>
<script src="../z_resourceReader.jsp?res=z_jsengine/z_engine.js"></script>
<script src="../z_resourceReader.jsp?res=z_jsengine/z_keyboardMapping.js"></script>
<script src="../z_resourceReader.jsp?res=z_jsengine/z_browserUtil.js"></script>
<script src="../z_resourceReader.jsp?res=z_jsengine/z_stringUtil.js"></script>
<script src="../z_resourceReader.jsp?res=z_jsengine/z_log.js"></script>
<script src="../z_resourceReader.jsp?res=z_jsengine/z_event.js"></script>
<script src="../z_resourceReader.jsp?res=z_jsengine/z_jsfuncs.js"></script>
<script src="../z_resourceReader.jsp?res=z_jsengine/z_changeIcon.js"></script>
</head>
<body onload="updateAppNameJsp();handleTree();registerOnEditorDirtyListener();GXToolBarUtil.init();">
	<gx:form>

		<%@include file="z_header.htm"%>
		<%@include file="../template/screenLocker.htm"%>
		<img src="../z_resourceReader.jsp?res=z_admin/images/up.gif"
			style="display: none" />
				
		<table border="0" cellpadding="0" cellspacing="0" height="45%" width="100%">			
			<tr align="center">
				<td  valign = "top" align="left" width="9%"/>
				<td  valign = "top" align="left" width="40%">
					<table border="0" cellpadding="2" cellspacing="1">
						<tr>
							<td colspan="3" height="25"></td>
						</tr>
						<tr  align="left">
							<td rowspan="1">
								<gx:span  id="ErrorMessage" style="width: 300px" cssClass="error" /> 
							</td>
						</tr>
						<tr align="left">
							<td colspan="3" rowspan="1"><input type="button"
								value="Expand All" style="width: 100px" onclick="flipTree(this);" />
								&nbsp; <gx:input type="button" id="Save" value="Save"
									onclick="saveClicked()" onserverclick="save" />
								&nbsp;&nbsp;&nbsp; <input type="button" value="Close"
								onclick="opener.parent.location.reload(); if (window != null && window != undefined) {window.close();}" />&nbsp;&nbsp;&nbsp;
							</td>
						</tr>

					</table>			
					<table border="0" cellpadding="2" cellspacing="1">

							<tr>
								<td colspan="3" rowspan="1"><a href="#"
									onclick="flipView('FileConfigImg','FileConfig');"
									class="moreLink">Click here for configuration details<img
										id="FileConfigImg"
										src="../z_resourceReader.jsp?res=z_admin/images/down.gif"
										border="0" /></a></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>
									<table id="FileConfig" style="display: none;" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td colspan="2"><br /> <b>You are about to edit the
													following configuration folder(s):</b><br /> <gx:span
													id="FolderName" style="font-size:12px"></gx:span> <br /> <br />
											</td>
										</tr>
										<tr>
											<td colspan="2">Browse to edit another configuration
												file (in config/gx_appConfig.xml):<br /> 
												<input
													id="fileBrowse" type="file" size="40" 
													onkeypress="fileNameKeyPressed();"
													onchange="fileNameChanged(this);" /> 
												<gx:input
													style="display:none" id="fileNameHidden" type="text"
													size="40" /> &nbsp;&nbsp;<gx:input type="button"
													id="loadBtn" onserverclick="loadFile" style="display:none"
													value="Load" /> <br /> <br /> 
											</td>
										</tr>
									</table>
								</td>
							</tr>

 					        <tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/collapse_table.gif"
									id="SessionConfigLink"
									onclick="flipView('SessionConfigLink','SessionConfig');" /> <b>Session</b>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="SessionConfig" border="0" cellpadding="2"
										cellspacing="1">
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXConfig.html#setServerURL(java.lang.String)')">Server
													URL:</a></td>
											<td><gx:input id="appConfig_SessionConfig_ServerURL"
													maxlength="50" size="25"
													attributes="onchange='updateAppNameJsp()'"></gx:input></td>
											<td><gx:input type="hidden" id="appConfig_Version" /></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXConfig.html#setApplicationName(java.lang.String)')">Application
													name:</a></td>
											<td><gx:select id="ApplicationNameList">
													<option value="">-Choose-</option>
												</gx:select> <gx:input id="appConfig_SessionConfig_ApplicationName"
													type="text" maxlength="50" size="25" /></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXConfig.html#setSessionId(java.lang.String)')">Session
													ID:</a></td>
											<td><gx:select id="appConfig_SessionConfig_SessionId"
													style="width:150px">
													<option value="$(IP)">IP Address</option>
													<option value="$(SESSION_ID)">Web Session ID</option>
												</gx:select></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXConfig.html#setPassword(java.lang.String)')">Password:</a></td>
											<td><gx:select id="appConfig_SessionConfig_Password"
													style="width:150px">
													<option value="">None</option>
													<option value="$(IP)">IP Address</option>
													<option value="$(SESSION_ID)">Web Session ID</option>
													<option value="">Other (set from code)</option>
												</gx:select></td>
										</tr>
										<tr>
											<td colspan="2"><img alt="exapnd"
												src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
												id="SessionConfigMoreLink"
												onclick="flipView('SessionConfigMoreLink','SessionConfigMore');" />
												Additional...</td>
										</tr>
										<tr>
											<td colspan="2">
												<table id="SessionConfigMore" style="display: none">
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/GXConfig.html#setDescription(java.lang.String)')">Description:</a></td>
														<td><gx:input
																id="appConfig_SessionConfig_Description" maxlength="20"
																size="20" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/GXConfig.html#setServiceName(java.lang.String)')">Connection
																pool:</a></td>
														<td><gx:input
																id="appConfig_SessionConfig_ServiceName" maxlength="20"
																size="20" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/GXConfig.html#setHostUserName(java.lang.String)')">Host
																user name:</a></td>
														<td><gx:input
																id="appConfig_SessionConfig_HostUserName" maxlength="20"
																size="20" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/GXConfig.html#setHostPassword(java.lang.String)')">Host
																password:</a></td>
														<td><gx:input
																id="appConfig_SessionConfig_HostPassword" maxlength="20"
																size="20" type="password" /></td>
													</tr>
													<tr>
														<td colspan="2"><gx:checkbox
																id="appConfig_SessionConfig_ShowIntermediateScreen" />
															<a href="#" class="help1"
															onclick="showHelp('framework/GXConfig.html#setShowIntermediateScreen(boolean)')">Show
																Intermediate screens </a></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="InstantConfigLink"
									onclick="flipView('InstantConfigLink','InstantConfig');">
									<b>Instant</b></td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="InstantConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/GXRenderConfig.html#setFontSize(int)')">Font
													size</a></td>
											<td><gx:select id="appConfig_InstantConfig_FontSize"
													style="width: 160px">
													<option value="0">Dynamic by resolution</option>
													<option value="10">10px</option>													
													<option value="12">12px</option>													
													<option value="14">14px</option>													
													<option value="16">16px</option>
													<option value="18">18px</option>													
													<option value="20">20px</option>
													<option value="22">22px</option>
													<option value="24">24px</option>
												</gx:select></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/GXRenderConfig.html#setFontFamily(java.lang.String)')">Font
													family</a></td>
											<td><gx:input id="appConfig_InstantConfig_FontFamily"
													size="20" /></td>
										</tr>																	
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXEmulationTransformConfig.html#setColorMode(int)')">
													Color mode </a></td>
											<td><gx:select
													id="appConfig_InstantConfig_EmulationConfig_ColorMode"
													style="width: 180px">
													<option value="0">Background &amp; foreground</option>
													<option value="1">None</option>
													<option value="2">Background only</option>
												</gx:select></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXHostKeysTransformConfig.html#setRenderingType(int)')">Host
													keys Transformation</a></td>
											<td><gx:select
													id="appConfig_InstantConfig_HostKeysConfig_RenderingType"
													style="width: 160px">
													<option value="0">Links</option>
													<option value="1">Buttons</option>
													<option value="2">None</option>
												</gx:select></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/GXRenderConfig.html#setRowSpacingPrecentageFactor(int)')">Row
													spacing</a></td>
											<td><gx:input
													id="appConfig_InstantConfig_RowSpacingPrecentageFactor"
													size="2" /> %</td>
										</tr>
										<tr>													
											<td><gx:checkbox
													id="appConfig_InstantConfig_PaintRowHeightInReversedVideo" />
												<a href="#" class="help1"
												onclick="showHelp('presentation/GXRenderConfig.html#setPaintAllColumnHeight(boolean)')">Optimize reversed video representation (solid window borders)</a></td>		
													
										</tr>			
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_InstantConfig_RenderTagsFromRightToLeft" />
												<a href="#" class="help1"
												onclick="showHelp('presentation/GXRenderConfig.html#setRenderTagsFromRightToLeft(boolean)')">Render
													tags from right</a></td>
										</tr>
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_InstantConfig_EmulationConfig_RenderEmulationAttributes" />
												<a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXEmulationTransformConfig.html#setRenderEmulationAttributes(boolean)')">Reflect
													emulation behavior</a></td>
										</tr>
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_InstantConfig_TableConfig_Enabled" /> <a
												href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXTransformConfig.html#setEnabled(boolean)')">
													Enable displaying tables</a></td>
										</tr>
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_InstantConfig_WindowFrameConfig_Enabled" />
												<a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXTransformConfig.html#setEnabled(boolean)')">
													Enable displaying graphical window frame</a></td>
										</tr>
										<tr>
											<td><input id="IsRenderArea" name="IsRenderArea"
												type="checkbox" onclick="flipElementDisplay('RenderArea')" />
												<a href="#" class="help1"
												onclick="showHelp('presentation/GXRenderConfig.html#setRenderArea(com.sabratec.util.GXRectangle)')">Define
													render area</a></td>
										</tr>
										<tr>
											<td colspan="2">
												<table id="RenderArea" style="display: none" cellpadding=""
													cellspacing="0">
													<tr>
														<td>Start row:</td>
														<td><gx:input
																id="appConfig_InstantConfig_RenderArea_StartRow"
																style="width:20px" maxlength="3" /></td>
														<td>Start column:</td>
														<td><gx:input
																id="appConfig_InstantConfig_RenderArea_StartColumn"
																style="width:20px" maxlength="3" /></td>
													</tr>
													<tr>
														<td>End row:</td>
														<td><gx:input
																id="appConfig_InstantConfig_RenderArea_EndRow"
																style="width:20px" maxlength="3" /></td>
														<td>End column:</td>
														<td><gx:input
																id="appConfig_InstantConfig_RenderArea_EndColumn"
																style="width:20px" maxlength="3" /></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="GeneralConfigLink"
									onclick="flipView('GeneralConfigLink','GeneralConfig');">
									<b>General</b></td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="GeneralConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td><gx:checkbox id="appConfig_UseFolders"
													onclick="flipElementDisplay('VirtualDirArea');" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXAppConfig.html#setUseFolders(boolean)')">
													Use folders</a> &nbsp; <gx:span id="VirtualDirArea">
													<a href="#" class="help1"
														onclick="showHelp('framework/GXWebAppConfig.html#setVirtualDir(java.lang.String)')">
														Virtual directory: </a>
													<gx:input id="appConfig_VirtualDir" maxlength="20"
														size="20" />
												</gx:span></td>
										</tr>
										<tr>
											<td><gx:checkbox id="appConfig_ScreenLocker"
													checkedValue="template/screenLocker.htm" uncheckedValue="" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXWebAppConfig.html#setScreenLocker(java.lang.String)')">
													Use screen locker</a></td>
										</tr>
										<tr>
											<td><gx:checkbox
													id="appConfig_TableBuildConfig_AlternateColors" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/tables/GXTableBuildConfig.html#setAlternateColors(boolean)')">Alternate
													row colors</a></td>
										</tr>
										<tr>
											<td><gx:checkbox id="appConfig_UseFramesForSubmit" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXWebAppConfig.html#setUseFramesForSubmit(boolean)')">Prevent
													page refresh effect</a></td>
										</tr>
										<tr>
											<td><gx:checkbox
													id="clientConfig_WebEmulatorConfig_CheckHostScreenUpdate" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/web/jsengine/GXWebEmulatorConfig.html#setCheckHostScreenUpdate(boolean)')">
													Perform background check for host screen changes</a></td>
										</tr>							
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="LogoffConfigLink"
									onclick="flipView('LogoffConfigLink','LogoffConfig');"> <b>Logoff</b>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="LogoffConfig" style="display: none;" border="0"
										cellpadding="2" cellspacing="0">
										<!--tr>
							<td colspan="2"><gx:checkbox
								id="clientConfig_EngineConfig_LogoffOnBrowserClose" /> <a
								href="#" class="help1"
								onclick="showHelp('framework/web/jsengine/GXEngineConfig.html#setLogoffOnBrowserClose(boolean)')">
							Disconnect host session when browser is closed</a></td>
						</tr-->
										<tr>
											<td colspan="2"><gx:checkbox
													id="clientConfig_EngineConfig_PromptOnBrowserClose"
													onclick="flipDisable('clientConfig_EngineConfig_LogoffMessage');" />
												<a href="#" class="help1"
												onclick="showHelp('framework/web/jsengine/GXEngineConfig.html#setPromptOnBrowserClose(boolean)')">
													Request confirmation to disconnect when browser is been closed [for IE only]</a></td>
										</tr>
										<tr>
											<td colspan="2">
												<table cellpadding="0" cellspacing="0" style="width: 100%;">
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXEngineConfig.html#setLogoffMessage(java.lang.String)');">
																&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Display the following
																confirmation message: </a></td>
													</tr>
													<tr>
														<td>&nbsp;&nbsp;&nbsp;&nbsp; <gx:input
																id="clientConfig_EngineConfig_LogoffMessage" size="60"
																maxlength="120" />
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_PromptBeforeSessionTimeOut" /> <a href="#"
												class="help1"
												onclick="showHelp('framework/GXWebAppConfig.html#setPromptBeforeSessionTimeOut(boolean)');">
													Prompt user before session time-out (1 minute)</a></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXWebAppConfig.html#setTerminationPath(java.lang.String)');">
													Termination path:</a></td>
											<td><gx:input id="appConfig_TerminationPath" size="30"
													maxlength="30" /></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="GenerateConfigLink"
									onclick="flipView('GenerateConfigLink','GenerateConfig');">
									<b>Generated pages</b></td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="GenerateConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td><gx:checkbox id="appConfig_ReflectHostProtected"
													onclick="flipElementDisplay('DynamicDisableCssClassArea');" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXAppConfig.html#setReflectHostProtected(boolean)')">
													Reflect host protected </a> &nbsp;&nbsp; <gx:span
													id="DynamicDisableCssClassArea">
													<a href="#" class="help1"
														onclick="showHelp('framework/GXWebAppConfig.html#setDynamicDisableCssClass(java.lang.String)')">
														Dynamically disable CSS: </a>
													<gx:input id="appConfig_DynamicDisableCssClass"
														maxlength="30" size="10" />
												</gx:span></td>
										</tr>
										<tr>
											<td><gx:checkbox id="appConfig_ReflectFGColors" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXAppConfig.html#setReflectFGColors(boolean)')">
													Reflect foreground colors</a></td>
										</tr>
										<tr>
											<td><gx:checkbox id="appConfig_ReflectBGColors" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXAppConfig.html#setReflectBGColors(boolean)')">
													Reflect background colors</a></td>
										</tr>
										<tr>
											<td><gx:checkbox id="appConfig_ReflectMaxlength" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXAppConfig.html#setReflectMaxlength(boolean)')">
													Reflect maximum field length</a></td>
										</tr>
										<tr>
											<td><gx:checkbox
													id="appConfig_ReflectEmulationBehaviour" /></td>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXAppConfig.html#setReflectEmulationBehaviour(boolean)')">
													Reflect emulation behavior</a></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="WindowConfigLink"
									onclick="flipView('WindowConfigLink','WindowConfig');"> <b>Window</b>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="WindowConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_UseModalWindows"
													onclick="flipElementDisplay('WindowArea')" /> <a href="#"
												class="help1"
												onclick="showHelp('framework/GXAppConfig.html#setUseModalWindows(boolean)')">
													Enable modal windows (for supported browsers only, not supported on mobile devices)</a></td>
										</tr>
										<tr>
											<td>
												<table id="WindowArea" style="display: none">
													<tr>
														<td colspan="2">
															<table cellpadding="0" cellspacing="0"
																style="width: 100%;" border="0">
																<tr>
																	<td style="width: 15px;">&nbsp;</td>
																	<td><gx:radioButtonList
																			id="clientConfig_WindowConfig_OpenWindowCenter"
																			horizontal="false"
																			attributes="onclick='showHideWindowConfigSpecifics();'">
																			<gx:radioButton value="true">
																				<a href="#" class="help1"
																					onclick="showHelp('framework/web/jsengine/GXWindowConfig.html#setOpenWindowCenter(boolean)')">
																					&nbsp;&nbsp;Set window position to center </a>
																			</gx:radioButton>
																			<gx:radioButton value="false">
																				<a href="#" class="help1"
																					onclick="showHelp('framework/web/jsengine/GXWindowConfig.html#setOpenWindowCenter(boolean)')">
																					&nbsp;&nbsp;Set window specific position </a>
																			</gx:radioButton>
																		</gx:radioButtonList></td>
																</tr>
															</table>
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<table id="windowConfigSpecifics" cellpadding="0"
																cellspacing="5" style="display: none;" border="0">
																<tr>
																	<td style="width: 33px;">&nbsp;</td>
																	<td><a href="#" class="help1"
																		onclick="showHelp('framework/web/jsengine/GXWindowConfig.html#setDefaultOpenedWindowTop(int)')">
																			Opened window top (px): </a></td>
																	<td><gx:input
																			id="clientConfig_WindowConfig_DefaultOpenedWindowTop"
																			maxlength="3" size="5" /></td>
																</tr>
																<tr>
																	<td>&nbsp;</td>
																	<td><a href="#" class="help1"
																		onclick="showHelp('framework/web/jsengine/GXWindowConfig.html#setDefaultOpenedWindowLeft(int)')">
																			Opened window left (px): </a></td>
																	<td><gx:input
																			id="clientConfig_WindowConfig_DefaultOpenedWindowLeft"
																			maxlength="3" size="5" /></td>
																</tr>
															</table>
														</td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXWindowConfig.html#setOpenedWindowAttributes(java.lang.String)')">
																Opened window attributes:</a></td>
														<td><gx:input
																id="clientConfig_WindowConfig_OpenedWindowAttributes"
																maxlength="100" size="40" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXWindowConfig.html#setPopupCloseSentKey(java.lang.String)')">
																Host key to send when the window is closed: </a></td>
														<td><gx:input
																id="clientConfig_WindowConfig_PopupCloseSentKey"
																maxlength="10" size="10" /></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="EmulationConfigLink"
									onclick="flipView('EmulationConfigLink','EmulationConfig');">
									<b>Emulation</b></td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="EmulationConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td colspan="2"><gx:checkbox
													id="clientConfig_WebEmulatorConfig_SupportTypeAhead_v2" /> <a
												href="#" class="help1"
												onclick="showHelp('framework/web/jsengine/GXWebEmulatorConfig.html#setSupportTypeAheadV2(boolean)')">
													Support type ahead (All browsers)</a></td>
										</tr>
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_SupportDupAndFieldMark" /> <a href="#"
												class="help1"
												onclick="showHelp('framework/GXAppConfig.html#setSupportDupAndFieldMark(boolean)')">
													Support Dup and FieldMark host keys</a></td>
										</tr>
										<tr>
											<td colspan="2"><gx:checkbox
													id="clientConfig_WebEmulatorConfig_LoadPrinter" /> <a
												href="#" class="help1"
												onclick="showHelp('framework/web/jsengine/GXWebEmulatorConfig.html#setLoadPrinter(boolean)')">
													Load printer applet within internal frame</a></td>
										</tr>
										<tr>
											<td colspan="2">
												<table cellpadding="2" cellspacing="0" border="1">
													<tr>
														<td align="left"><b>&nbsp;&nbsp;Definition</b></td>
														<td nowrap="nowrap"><b
															title="Uncheck for instant pages only">Instant
																&nbsp;&nbsp; Generated</b></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setUseKeyboardPfKeys(boolean)')">
																Use keyboard PF keys</a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_UseKeyboardPfKeys"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_UseKeyboardPfKeys');" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_UseKeyboardPfKeys" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setTabOnInputsOnly(boolean)')">
																Tab on input fields only</a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_TabOnInputsOnly"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_TabOnInputsOnly');" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_TabOnInputsOnly" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setAutoSkipAllFields(boolean)')">
																Automatic skip for all input fields</a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_AutoSkipAllFields"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_AutoSkipAllFields');" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_AutoSkipAllFields" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setBlockNumericFields(boolean)')">
																Block illegal characters in host numeric fields</a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_BlockNumericFields"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_BlockNumericFields');" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_BlockNumericFields" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setSelectFieldOnFocus(boolean)')">
																Select content when focus on input field</a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_SelectFieldOnFocus"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_SelectFieldOnFocus');" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_SelectFieldOnFocus" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setBlinkingCaret(boolean)')">
																Show blinking caret</a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_BlinkingCaret"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_BlinkingCaret');" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_BlinkingCaret" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setShowBlinkingFields(boolean)')">
																Show host blinking fields </a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_ShowBlinkingFields"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_ShowBlinkingFields');" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_ShowBlinkingFields"
																style="display: none;" />
														</td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setCaretAtEndOfField(boolean)')">
																Place caret at end of field</a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_CaretAtEndOfField"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_CaretAtEndOfField');" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_CaretAtEndOfField" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setEmulationPasteBehavior(boolean)')">
																Use paste behavior as in terminal emulators</a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_EmulationPasteBehavior"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_EmulationPasteBehavior',1);" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_EmulationPasteBehavior" /></td>
													</tr>
													<tr>
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setDoubleClickActionKey(java.lang.String)')">
																Send [enter] key on Double click</a></td>
														<td align="left">&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_DoubleClickActionKey"
																onclick="flipCheckBox('clientConfig_WebEmulatorConfig_DoubleClickActionKey');" />
															&nbsp;&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_WebEmulatorConfig_DoubleClickActionKey" /></td>
													</tr>
													<tr style="display: none;">
														<td><a href="#" class="help1"
															onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setHandleMenuSelection(boolean)')">
																Support menu screen option click </a></td>
														<td align="left">&nbsp;&nbsp;&nbsp; <gx:checkbox
																id="clientConfig_InstantEmulatorConfig_HandleMenuSelection" />
														</td>
													</tr>
													<tr>
														<td>
															<table cellpadding="2" cellspacing="0" border="0">
																<tr>
																	<td><a href="#" class="help1"
																		onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setUseArrows(int)')">
																			Arrow keys navigation: </a></td>
																	<td><gx:select
																			id="clientConfig_InstantEmulatorConfig_UseArrows"
																			onchange="updateCheckboxFromCombo('__IsAllAppUseArrows',this);">
																			<option value="0">None</option>
																			<option value="1">Input fields</option>
																			<option value="2">All screen</option>
																		</gx:select></td>
																</tr>
																<tr>
																	<td><a href="#" class="help1"
																		onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setLabelFocus(int)')">
																			Label focus style: </a></td>
																	<td><gx:select
																			id="clientConfig_InstantEmulatorConfig_LabelFocus"
																			onchange="updateCheckboxFromCombo('__IsAllAppLabelFocus',this);">
																			<option value="0">Do not change</option>
																			<option value="1">Underline</option>
																			<option value="2">Bold</option>
																		</gx:select></td>
																</tr>
																<tr>
																	<td nowrap="nowrap"><a href="#" class="help1"
																		onclick="showHelp('framework/web/jsengine/GXInstantEmulatorConfig.html#setColorSets(java.lang.String)')">
																			Color set (separate by comma): </a></td>
																	<td><gx:input
																			id="clientConfig_InstantEmulatorConfig_ColorSets"
																			maxlength="100" size="30" /></td>
																</tr>
															</table>
														</td>
														<td>
															<table cellpadding="0" cellspacing="0" border="0"
																style="vertical-align: top;" width="100%" height="100%">
																<tr>
																	<td style="padding-left: 20px;"><gx:checkbox
																			id="IsAllAppUseArrows_instant" /></td>
																	<td><gx:checkbox id="IsAllAppUseArrows" /></td>
																	<td style="width: 35px;">&nbsp;</td>
																</tr>
																<tr>
																	<td style="padding-left: 20px;"><gx:checkbox
																			id="IsAllAppLabelFocus_instant" /></td>
																	<td><gx:checkbox id="IsAllAppLabelFocus" /></td>
																	<td>&nbsp;</td>
																</tr>
																<tr>
																	<td colspan="3" style="height: 30px;">&nbsp;</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="NdtConfigLink"
									onclick="flipView('NdtConfigLink','NdtConfig');"> <b>Natural
										upload/download</b></td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="NdtConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_NaturalDataTransferConfig_AutomaticDownload" />
												<a href="#" class="help1"
												onclick="showHelp('framework/web/ndt/GXNdtConfig.html#setAutomaticDownload(boolean)')">
													Automatically start download</a></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/web/ndt/GXNdtConfig.html#setDefaultExtension(java.lang.String)')">
													Default file extension:</a></td>
											<td><gx:select
													id="appConfig_NaturalDataTransferConfig_DefaultExtension">
													<option value="txt">Text file</option>
													<option value="csv">CSV file</option>
												</gx:select></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="LogConfigLink"
									onclick="flipView('LogConfigLink','LogConfig');"> <b><a
										href="#" class="help1"
										onclick="showHelp('framework/config/doc/GXLogNode.html')">Log</a></b>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="LogConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/config/doc/GXLogNode.html#FileName')">
													File name (relative):</a></td>
											<td><gx:input id="LogFile" maxlength="30" size="30" /></td>
										</tr>
										<tr>
											<td><gx:checkbox id="LogAppend" /> <a href="#"
												class="help1"
												onclick="showHelp('framework/config/doc/GXLogNode.html#AppendFile')">
													Append to existing file</a></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/config/doc/GXLogNode.html#LogLevel')">
													Log level:</a></td>
											<td><gx:select id="LogLevel">
													<option value="info">Normal</option>
													<option value="warn">Warnings</option>
													<option value="error">Errors only</option>
													<option value="debug">Debug</option>
												</gx:select></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/config/doc/GXLogNode.html#LogHistory')">
													Log history:</a></td>
											<td><gx:input id="MaxBackupIndex" maxlength="3" size="3" /></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/config/doc/GXLogNode.html#maxFileSize')">
													Max. file size:</a></td>
											<td><gx:input id="MaxFileSize" maxlength="10" size="10" />
												bytes</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="PerformanceConfigLink"
									onclick="flipView('PerformanceConfigLink','PerformanceConfig');">
									<b><a href="#" class="help1"
										onclick="showHelp('framework/config/doc/GXPerformanceMonitorNode.html')">Performance
											monitor</a></b></td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="PerformanceConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_WritePerformanceLog"
													onclick="flipElementDisplay('PerformanceLogArea')" /> <a
												href="#" class="help1"
												onclick="showHelp('framework/GXWebAppConfig.html#setWritePerformanceLog(boolean)')">
													Enable performance monitoring</a></td>
										</tr>
										<tr>
											<td>
												<table id="PerformanceLogArea" style="display: none">
													<tr>
														<td colspan="2"><a href="#" class="help1"
															onclick="showHelp('framework/config/doc/GXPerformanceMonitorNode.html#FileName')">
																File name (relative):</a> <gx:input id="PerformanceLogFile"
																maxlength="30" size="30" /></td>
													</tr>
													<tr>
														<td colspan="2"><input type="checkbox"
															id="PerformanceLogPerUser"
															onclick="changePeformanceFileName()" /> <a href="#"
															class="help1"
															onclick="showHelp('framework/config/doc/GXPerformanceMonitorNode.html#PerSessionID')">
																Write performance log per session ID</a></td>
													</tr>
													<tr>
														<td colspan="2">
															<table border="0">
																<tr>
																	<td valign="top"><gx:radioButtonList
																			id="PerformanceLogUsersSetting" horizontal="false"
																			attributes="onclick='showHideMonitoredSessions();'">
																			<gx:radioButton value="all">
																				<a href="#" class="help1"
																					onclick="showHelp('framework/config/doc/GXPerformanceMonitorNode.html#TraceSessions')">
																					&nbsp;&nbsp;Trace all sessions</a>
																			</gx:radioButton>
																			<gx:radioButton value="part" checked="true">
																				<a href="#" class="help1"
																					onclick="showHelp('framework/config/doc/GXPerformanceMonitorNode.html#TraceSessions')">
																					&nbsp;&nbsp;Trace specific sessions</a>
																			</gx:radioButton>
																		</gx:radioButtonList></td>
																</tr>
															</table>
														</td>
													</tr>
													<tr>
														<td><span id="PerformanceUsersArea"
															style="display: none"> <a href="#" class="help1"
																onclick="showHelp('framework/config/doc/GXPerformanceMonitorNode.html#TraceSessionsIDs')">
																	Monitored sessions ID (seperate by comma):</a> <gx:input
																	id="PerformanceUsers" size="50" />
														</span></td>
													</tr>
													<tr>
														<td colspan="2">
															<table border="0">
																<tr>
																	<td valign="top" id="WriteFlatArea"><gx:radioButtonList
																			id="WriteFlat" horizontal="false">
																			<gx:radioButton value="true">
																				<a href="#" class="help1"
																					onclick="showHelp('framework/config/doc/GXPerformanceMonitorNode.html#ShortLongDescription')">
																					&nbsp;&nbsp;Short description</a>
																			</gx:radioButton>
																			<gx:radioButton value="true">
																				<a href="#" class="help1"
																					onclick="showHelp('framework/config/doc/GXPerformanceMonitorNode.html#ShortLongDescription')">
																					&nbsp;&nbsp;Detailed description</a>
																			</gx:radioButton>
																		</gx:radioButtonList></td>
																</tr>
															</table>
														</td>
													</tr>

												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="MacroConfigLink"
									onclick="flipView('MacroConfigLink','MacroConfig');"> <b><a
										href="#" class="help1"
										onclick="showHelp('framework/emulation/macros/GXMacroConfig.html')">Macro</a></b>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="MacroConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/emulation/macros/GXMacroConfig.html#setUserName(java.lang.String)')">
													User name:</a></td>
											<td><gx:select id="appConfig_MacroConfig_UserName">
													<option value="$(IP)">IP Address</option>
													<option value="$(COOKIE)">Cookie based</option>
													<option value="">Other (set from code)</option>
												</gx:select></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/emulation/macros/GXMacroConfig.html#setMacrosFolder(java.lang.String)')">
													Macros folder(relative):</a></td>
											<td><gx:input id="appConfig_MacroConfig_MacrosFolder"
													size="30" maxlength="50" /></td>
										</tr>
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_MacroConfig_EncryptData"
													onclick="flipMacroEncryption();" /> <a href="#"
												class="help1"
												onclick="showHelp('framework/emulation/macros/GXMacroConfig.html#setEncryptData(boolean)')">
													Encrypt macro file </a></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="SsoConfigLink"
									onclick="flipView('SsoConfigLink','SsoConfig');"> <b><a
										href="#" class="help1"
										onclick="showHelp('framework/sso/GXSSOConfig.html')">Single
											SignOn</a></b></td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="SsoConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td colspan="2"><gx:checkbox
													id="appConfig_SingleSignOnConfig_Enabled"
													onclick="flipElementDisplay('SsoArea')" /> <a href="#"
												class="help1"
												onclick="showHelp('framework/sso/GXSSOConfig.html#setEnabled(boolean)')">
													Enable Single SignOn</a></td>
										</tr>
										<tr>
											<td>
												<table id="SsoArea" style="display: none">
													<tr>
														<td colspan="2"><a href="#" class="help1"
															onclick="showHelp('framework/sso/GXSSOConfig.html#setSignOnScreenRecognizer(com.sabratec.applinx.framework.sso.GXISignOnScreenRecognizer)')">
																Recognition:</a></td>
													</tr>
													<tr>
														<td>
															<table>
																<tr>
																	<td>&nbsp;&nbsp;</td>
																	<td>
																		<table>
																			<tr>
																				<td><a href="#" class="help1"
																					onclick="showHelp('framework/sso/GXSSOConfig.html#setSignOnScreenRecognizer(com.sabratec.applinx.framework.sso.GXISignOnScreenRecognizer)')">
																						SignOn screen recognition:</a></td>
																				<td><gx:select attributes="align='left'"
																						id="signOnScreenRecognizer"
																						onchange="checkSignOnScreenByNameArea();">
																						<option
																							value="com.sabratec.applinx.framework.sso.GXSignOnScreenByNameRecognizer">By
																							name</option>
																						<option
																							value="com.sabratec.applinx.framework.sso.GXSignOnScreenAutomaticRecognizer">Automatic</option>
																						<option value="">Other (Set from code)</option>
																					</gx:select></td>
																			</tr>
																			<tr>
																				<td colspan="2">
																					<table id="GXSignOnScreenByNameRecognizerArea"
																						border="0">
																						<tr>
																							<td><a href="#" class="help1"
																								onclick="showHelp('framework/sso/GXSignOnScreenByNameRecognizer.html#setScreenName(java.lang.String)')">
																									Screen name:</a> <gx:input id="SSO_ScreenName"
																									maxlength="20" size="20" /></td>
																						</tr>
																						<tr>
																							<td><gx:checkbox id="DefineAppFieldsName"
																									onclick="flipElementDisplay('SignOnScreenByNameFieldsArea');" />
																								Define application field names</td>
																						</tr>
																						<tr>
																							<td>
																								<table id="SignOnScreenByNameFieldsArea">
																									<tr>
																										<td><a href="#" class="help1"
																											onclick="showHelp('framework/sso/GXSignOnScreenByNameRecognizer.html#setUserNameFieldName(java.lang.String)')">
																												User field name:</a></td>
																										<td><gx:input id="SSO_UserNameFieldName"
																												maxlength="20" size="20" /></td>
																									</tr>
																									<tr>
																										<td><a href="#" class="help1"
																											onclick="showHelp('framework/sso/GXSignOnScreenByNameRecognizer.html#setPasswordFieldName(java.lang.String)')">
																												Password field name:</a></td>
																										<td><gx:input id="SSO_PasswordFieldName"
																												maxlength="20" size="20" /></td>
																									</tr>
																								</table>
																							</td>
																						</tr>
																					</table>
																				</td>
																			</tr>
																		</table>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
													<tr>
														<td colspan="2"><a href="#" class="help1"
															onclick="showHelp('framework/sso/GXSSOConfig.html#setUserPasswordRetriever(com.sabratec.applinx.framework.sso.GXIUserPasswordRetriever)')">
																User/Password retrieving:</a></td>
													</tr>
													<tr>
														<td>
															<table>
																<tr>
																	<td>&nbsp;&nbsp;</td>
																	<td>
																		<table>
																			<tr>
																				<td><a href="#" class="help1"
																					onclick="showHelp('framework/sso/GXSSOConfig.html#setUserPasswordRetriever(com.sabratec.applinx.framework.sso.GXIUserPasswordRetriever)')">
																						Source:</a></td>
																				<td><gx:select id="userPasswordRetriever"
																						onchange="checkHttpParametersArea();">
																						<option
																							value="com.sabratec.applinx.framework.web.sso.GXHttpRequestUserPasswordRetriever">From
																							http request</option>
																						<option
																							value="com.sabratec.applinx.framework.web.sso.GXHttpSessionUserPasswordRetriever">From
																							http session</option>
																						<option value="">Other (Set from code)</option>
																					</gx:select></td>
																			</tr>
																			<tr>
																				<td colspan="2">
																					<table id="HttpParametersArea">
																						<tr>
																							<td><a href="#" class="help1"
																								onclick="showHelp('framework/web/sso/GXAbsractHttpUserPasswordRetriever.html#setUserParameterName(java.lang.String)')">User
																									parameter name:</a></td>
																							<td><gx:input id="SSO_UserParameterName"
																									maxlength="20" size="20" /></td>
																						</tr>
																						<tr>
																							<td><a href="#" class="help1"
																								onclick="showHelp('framework/web/sso/GXAbsractHttpUserPasswordRetriever.html#setPasswordParameterName(java.lang.String)')">Password
																									parameter name:</a></td>
																							<td><gx:input id="SSO_PasswordParameterName"
																									maxlength="20" size="20" /></td>
																						</tr>
																					</table>
																				</td>
																			</tr>
																		</table>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
													<tr>
														<td colspan="2"><a href="#" class="help1"
															onclick="showHelp('framework/sso/GXSSOConfig.html#setSsoExecuter(com.sabratec.applinx.framework.sso.GXISSOExecuter)')">
																SignOn execution:</a></td>
													</tr>
													<tr>
														<td>
															<table>
																<tr>
																	<td>&nbsp;&nbsp;</td>
																	<td>
																		<table>
																			<tr>
																				<td><a href="#" class="help1"
																					onclick="showHelp('framework/sso/GXSSOConfig.html#setSsoExecuter(com.sabratec.applinx.framework.sso.GXISSOExecuter)')">
																						Type:</a></td>
																				<td><gx:select id="ssoExecuter"
																						onchange="checkSsoExecuteArea();">
																						<option
																							value="com.sabratec.applinx.framework.sso.GXSSOSendKeysExecuter">Using
																							action key</option>
																						<option
																							value="com.sabratec.applinx.framework.sso.GXSSOPathExecuter">Using
																							path execution</option>
																						<option value="">Other (Set from code)</option>
																					</gx:select></td>
																			</tr>
																			<tr>
																				<td colspan="2">
																					<table>
																						<tr id="SsoSendKeysArea">
																							<td><a href="#" class="help1"
																								onclick="showHelp('framework/sso/GXSSOSendKeysExecuter.html#setActionKey(java.lang.String)')">Action
																									key:</a></td>
																							<td><gx:input id="SSO_ActionKey"
																									maxlength="20" size="20" /></td>
																						</tr>
																						<tr id="SsoPathNameArea">
																							<td><a href="#" class="help1"
																								onclick="showHelp('framework/sso/GXSSOPathExecuter.html#setPathName(java.lang.String)')">Path
																									name:</a></td>
																							<td><gx:input id="SSO_PathName"
																									maxlength="20" size="20" /></td>
																						</tr>
																					</table>
																				</td>
																			</tr>
																		</table>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>

									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="FtpConfigLink"
									onclick="flipView('FtpConfigLink','FtpConfig');"> <b><a
										href="#" class="help1"
										onclick="showHelp('framework/emulation/ftp/dialog/GXFtpConfig.html')">Ftp</a></b>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="FtpConfig" style="display: none" border="0"
										cellpadding="2" cellspacing="1" width="100%">
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/emulation/ftp/dialog/GXFtpConfig.html#setHostType(java.lang.String)')">
													Host type</a></td>
											<td><gx:select id="appConfig_FtpConfig_HostType"
													onchange="flipFtpAddress();">
													<option value="999">By ApplinX</option>
													<option value="1">Mainframe</option>
													<option value="2">AS/400</option>
													<option value="0">Other</option>
												</gx:select></td>
										</tr>
										<tr id="hostAddressArea">
											<td><a href="#" class="help1"
												onclick="showHelp('framework/emulation/ftp/dialog/GXFtpConfig.html#setHostAddress(java.lang.String)')">
													Host address</a></td>
											<td><gx:input id="appConfig_FtpConfig_HostAddress"
													maxlength="20" size="20" /></td>
										</tr>
									</table>
								</td>
							</tr>

							<tr>
								<td colspan="2"><img alt="exapnd"
									src="../z_resourceReader.jsp?res=z_admin/images/expand_table.gif"
									id="CssClassesLink"
									onclick="flipView('CssClassesLink','CssClasses');"> <b>CSS
										classes</b></td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="CssClasses" style="display: none" border="0"
										cellpadding="2" cellspacing="1">
										<tr>
											<td><b>Instant only</b></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXWindowFrameTransformConfig.html#setWindowFrameCssClass(java.lang.String)')">
													Window frame CSS class</a></td>
											<td><gx:input
													id="appConfig_InstantConfig_WindowFrameConfig_WindowFrameCssClass"
													maxlength="20" size="20" /></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXHostKeysTransformConfig.html#setHostKeyCss(java.lang.String)')">
													Host keys CSS class</a></td>
											<td><gx:input
													id="appConfig_InstantConfig_HostKeysConfig_HostKeyCss"
													maxlength="20" size="20" /></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXTableTransformConfig.html#setTableCssClass(java.lang.String)')">
													Table CSS class</a></td>
											<td><gx:input
													id="appConfig_InstantConfig_TableConfig_TableCssClass"
													maxlength="20" size="20" /></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXTableTransformConfig.html#setTableAlternating1CssClass(java.lang.String)')">
													Table odd rows CSS class</a></td>
											<td><gx:input
													id="appConfig_InstantConfig_TableConfig_TableAlternating1CssClass"
													maxlength="20" size="20" /></td>
										</tr>
										<tr>
											<td><gx:checkbox
													id="appConfig_InstantConfig_EmulationConfig_RenderIntensifiedCss" />
												<a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXEmulationTransformConfig.html#setRenderIntensifiedCss(boolean)')">
													Render intensified CSS class</a></td>
										</tr>
										<tr>
											<td><gx:checkbox
													id="appConfig_InstantConfig_EmulationConfig_RenderAppFieldCss" />
												<a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXEmulationTransformConfig.html#setRenderAppFieldCss(boolean)')">
													Render application field CSS class</a></td>
										</tr>
										<tr>
											<td><b>Generated &amp; instant</b></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('presentation/transforms/GXTableTransformConfig.html#setTableAlternating2CssClass(java.lang.String)')">
													Table even rows CSS class</a></td>
											<td><gx:input
													id="appConfig_InstantConfig_TableConfig_TableAlternating2CssClass" /></td>
										</tr>
										<tr>
											<td><a href="#" class="help1"
												onclick="showHelp('framework/GXWebAppConfig.html#setExternalCssRequestParamName(java.lang.String)')">
													External CSS file parameter name</a></td>
											<td><gx:input id="appConfig_ExternalCssRequestParamName" /></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>
				</td>
				<td style="height: 100%; width: 40%" valign="top" align="left">
				<div class="gx_scroll_wrapper">
				<iframe 
						name="help" width="100%" height="100%"
						src="../z_resourceReader.jsp?res=z_admin/z_message.htm"
						frameborder="0"></iframe></div></td>
			</tr>
		</table>
	</gx:form>
</body>
</gx:html>
