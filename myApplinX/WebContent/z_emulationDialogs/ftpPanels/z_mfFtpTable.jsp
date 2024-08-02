				<gx:span id="MFTableVisible" >
					<table width="100%" align="left" cellpadding="0" border="0">
						<tr>
							<td  align="left" class="pt2" width="500" colspan="4">Mainframe</td>
						</tr>
					
						<TR>	
							<TD class="tt"  align="left">MF data type</TD>
							<TD width="120"><select class="ti" id="MF_DataType" name="MF_DataType" >
								<option value="A" selected>ASCII</option>
								<option value="E">EBCDIC</option>
								<option value="I">IMAGE</option>
								<option value="U 2 B">UNICODE 2 B</option>
								<option value="U 2 L">UNICODE 2 L</option>
							</select></TD>
							<td width="120px">&nbsp</td>
						
						</TR>
						
						<tr>
							<TD class="tt" width="120">Record format</TD>
							<td width="120"><SELECT class="ti" id="MF_Recordform"
								name="MF_Recordform" >
								<OPTION value="" selected></OPTION>
								<OPTION value="FB">Fixed</OPTION>
								<OPTION value="VB">Variable</OPTION>
								<OPTION value=" ">Undefined</OPTION>
							</SELECT></td>
							<td>&nbsp</td>
							<td>&nbsp</td>
						</TR>
						
						<tr>
							<TD class="tt" width="120">LRECL</TD>
							<TD><gx:input id="textLrecl" type="text" ></gx:input></TD>
							<td>&nbsp</td>
						</TR>
						
						<tr>
							<TD class="tt" width="120">Block size</TD>
							<TD><gx:input id="textBlock" type="text"></gx:input></TD>
							<td>&nbsp</td>
						</tr>
						<tr>	 
							<TD class="tt">Primary</TD>
							<TD><gx:input id="primary" type="text"></gx:input></TD>
							<td>&nbsp</td>
						</tr>
						<tr>	
							<TD class="tt">Secondary</TD>
							<TD><gx:input id="secondary" type="text"></gx:input></TD>
							<td>&nbsp</td>
						</TR>
					</TABLE>
			</gx:span>