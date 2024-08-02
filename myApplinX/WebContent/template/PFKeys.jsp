<%@ taglib uri="com/sabratec/j2ee/framework/tags" prefix="gx"%>
 <table cellspacing="5" align="center" >
	<tr valign="bottom" style="height: 300px">
		<td><gx:hostKeys vertical="true" keyType="template"
				cellspacing="0" cellpadding="5">
				<input type="button" class="pfKeyButton"
					onclick="gx_SubmitKey('$(ACTION)')" value="$(CAPTION)" />
			</gx:hostKeys></td>
	</tr>
	<tr height="40px">
	</tr>
	<tr>
		<td style = "padding-left:5px"><input type="button" class="pfKeyButton" id="enter"
			onclick="gx_SubmitKey('[enter]')" value="Enter" /></td>
	</tr>	
</table> 
