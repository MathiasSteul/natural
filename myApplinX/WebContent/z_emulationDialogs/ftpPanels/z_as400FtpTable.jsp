<gx:span id="AS400_Table" >
					<table cellspacing="0" cellpadding="0" width="100%">
						<tr>
							<td colspan="2" align="left" class="pt2">AS/400</td>
						</TR>
						<tr>
							<td class="tt" width="175">Data type</td>
							<td><SELECT id="AS400_DataType" name="AS400_DataType" class="ti">
								<OPTION value="a" selected>ASCII</OPTION>
								<OPTION value="e">EBCDIC</OPTION>
								<OPTION value="i">IMAGE</OPTION>
								<OPTION value="b">DBCS_EBCDIC</OPTION>
								<OPTION value="f">EBCS_EBCDIC</OPTION>
								<OPTION value="c">CCSID</OPTION>
							</SELECT></td>
						</TR>
						<tr>
							<td class="tt">Data structure</td>
							<td><SELECT class="ti" id="DataStructure" name="DataStructure">
								<OPTION value="" selected></OPTION>
								<OPTION value="f">File</OPTION>
								<OPTION value="r">Record</OPTION>
							</SELECT></td>
						</TR>
						<tr>
							<td class="tt">Mode</td>
							<td><SELECT class="ti" id="AS400_Mode" name="AS400_Mode">
								<OPTION value="" selected></OPTION>
								<OPTION value="s">Stream</OPTION>
								<OPTION value="b">Block</OPTION>
							</SELECT></td>
						</TR>
					</table>
				</gx:span>