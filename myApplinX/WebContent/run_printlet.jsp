<%@page import="contexts.run_printlet"%>
<html>
	<!--
	See printer applet documentation for parameters documentation.
	
	DO NOT CHANGE: the "code" attribute of the appelt tag.
	-->
	<head>
		
		<title>ApplinX Printlet</title>
		<script src="z_resourceReader.jsp?res=z_jsengine/z_browserUtil.js"></script>
		<script type="text/javascript">
		function init(){
			if ( GXBrowserUtil.isEdge() || GXBrowserUtil.isChrome()){
				document.getElementById("msg").style.display="inline";
				document.getElementById("hide").style.display = "none";
				document.getElementById("refresh").style.display = "none";
			}
			else{
				document.getElementById("msg").style.display = "none";
				document.getElementById("hide").style.display = "inline";
				document.getElementById("refresh").style.display = "inline";
			}		
		}
		</script>
	</head>
<body onload="init()">
    <a id="msg" style="display:none;">The Printlet component is not supported for Microsoft Edge and Chrome Browsers</a>
    <a id="hide" style="display:none;" href="javascript:parent.gx_hidePrinter();"><img border="0" src="z_resourceReader.jsp?res=images/hidePrinter.gif"></a> &nbsp;&nbsp; 
    <a id="refresh" style="display:none;"href="javascript:location.href=location.href"><img border="0" src="z_resourceReader.jsp?res=images/refreshPrinter.gif"></a>
	<applet
		code="com.sabratec.applinx.client.printlet.GXPrintlet.class"  
		archive="z_lib/gxprintlet.jar"   
		name="GXPrintlet"
		width="100%"
		height="100%" id="printer_Applet"> 
		<param name="cabbase" value="z_lib/GXPrintlet.cab"> 

		<!-- ==================== Connection parameters ==================== -->
		<param name="userid" value="Printlet_<%=session.getId()%>">
		<param name="password" value="">                          <!-- optional -->
		<param name="description" value="">                       <!-- optional -->
		<param name="serverURL" value="applinx://<%=request.getServerName()%>:2323">
		<param name="application" value="app_print">
		<param name="device_name" value="<%//=new run_printlet().getDevice() %>">                    
		<param name="associate_device_name" value="">             <!-- optional, only for 3270-->
		<param name="message_queue" value="">                     <!-- optional, only for 5250-->
		<param name="message_lib" value="">                       <!-- optional, only for 5250-->
		<param name="initial_focus" value="false">                <!-- by default don't set focus on the printlet applet-->
		<param name="enable_presentation" value="true">      <!-- optional - applet displays log in the browser -->
		<!--param name="host_address" value=""-->				  <!-- optional -->
		
		<!--param name="host_port" value=""-->					  <!-- optional -->
		<!--param name="auto_reconnect_number_of_tries" value=""-->  <!-- optional -->
		<!--param name="auto_reconnect_time_interval" value=""--> <!-- optional, in milliseconds -->
		<!--param name="disconnect_previous_session" value=""-->  <!-- optional -->
		
		<!-- ============== Silent printing (without print dialog) =========== -->
		<!-- 
			The value "<default>" indicates that for each user, the print job should be sent to the default printer on the machine.
			The value "<First Selected Printer>" indicates that the print dialog pops up once, and then the printlet uses the chosen
			printer device in all future print jobs in the current session and the printing is done silently.
		-->
		<!--param name="printer_device" value=""-->               <!-- optional -->

		<!-- ============== Transparent ====================================== -->
		<!-- param name="bypass_gdi" value=""--> <!-- optional true/false, used to make the frontend printer determine the layout of the print job. -->
		<!-- 
			optional, for 3270 LU3 print jobs only. 
			setting textual triggers to identify transparent sequences in the printed data. 
		--> 
		<!-- param name="transparent_start_trigger" value=""--> 
		<!-- param name="transparent_end_trigger" value=""-->

		<!-- ============== Print to File ==================================== -->
		<!--param name="output_file_name" value=""-->
		<!--param name="append_to_file" value=""-->  <!-- value: true/false -->
		<!--param name="printjob_separator_text" value=""-->
		<!--param name="print_as_text" value=""-->   <!-- value: true/false -->

		<!-- =============== Print data retrieval parameters =============== -->
		<!--param name="wait" value=""-->                         <!-- optional -->
		<!--param name="sleep" value=""-->                        <!-- optional -->
		
		<!-- ===================== Applet parameters ======================= -->
		<!--param name="loglevel" value="debug"-->                <!-- optional -->
		<param name="enable_presentation" value="true">      <!-- optional - applet displays log in the browser -->
		
		<!-- ===================== Buffers analysis parameters ================= -->
		
		<!-- 
			The page ends when the number of lines reaches the value of "lines_per_page".
			Every line ends if the number of characters reaches the value of "characters_per_page".
		-->

		<!--param name="lines_per_page" value=""-->               <!-- optional - only for 3270 -->
		<!--param name="characters_per_line" value=""-->          <!-- optional - only for 3270 -->
		<!--param name="exclude_last_page_if_empty" value=""-->   <!-- optional -->
		
		<!--  
  			By default print Shift In/Shift out as space (0x20)   
  		-->  
  		<!--param name="do_not_print_siso_as_space" value=""-->   <!-- optional - only for 3270 -->  
		
		
		<!-- ===================== Print parameters ======================== -->
		
		<!--param name="font_name" value=""-->                    <!-- optional -->
		<!--param name="font_size" value=""-->					  <!-- optional -->
		<!--param name="font_bold" value=""-->					  <!-- optional true / false -->
		<!--param name="font_italic" value=""-->				  <!-- optional true / false -->
			
		<!-- 
			CPI, LPI settings:
			- Negative number ==> best-fit.
			- 0 (zero) value  ==> set by the host (default)
			- Positive number ==> manual fixed value, may be one of the following:
				LPI: 4 , 5.3 , 6 , 6.3 , 8 , 8.5 , 9.6 , 12 , 24 , 48 
				CPI: 5 , 10 , 12 , 13.33 , 15 , 17.14 , 20 , 26.66 
		-->
		
		<!--param name="LPI" value=""-->						 <!-- optional -->
		<!--param name="CPI" value=""-->	                     <!-- optional -->

		<!--param name="cpi_translation" value=""-->             <!-- optional -->
		<!--param name="font_id_translation" value=""-->         <!-- optional -->			
		
		<!-- 
			CPI and Font values may be translated. 
			Translation format:
			CPI_original_value/Font_Id_value=CPI_new_value-Font_Style-Font_Name;
			The Font_Style possible values are: Regular, Bold, Italic or Bold Italic.
			Example: 4=6-Bold-Courier New;5.3=7-Regular-Arial; ...
		-->

		<!--param name="left_margin" value=""-->                 <!-- optional -->
		<!--param name="top_margin" value=""-->                  <!-- optional -->

		<!--
			Collect several print jobs till the page is full.
			Note: When this option is used, the "lines_per_page" option MUST also be set.
		-->
		<!--param name="do_not_add_form_feed_at_end_of_job" value="true"-->		<!--  optional -->

		<!-- ============ Dynamic font size and orientation according to characters per line ====== -->

		<!--param name="orientation_type" value="true"--> <!-- optional - possible values:"use_host","landscape","portrait". by default: "use_host" -->

		<!--param name="change_font_size_by_chars_per_line" value="true"--> <!-- optional - by default: false -->
		<!--param name="change_orientation_by_chars_per_line" value="true"--> <!-- optional - by default: false -->
		<!--param name="minimal_font_size" value=""--> <!-- optional -->
		
		<!--param name="check_each_page_separately" value="true"--> <!-- optional -->
		<!--param name="right_margin" value=""-->                 <!-- optional -->
		<!--param name="bottom_margin" value=""-->                 <!-- optional -->
		<!--param name="best_fit_row_proportion" value=""-->                 <!-- optional, percentage of font size to be used as row proportion, for exmaple 130% -->

	</applet>
</body>
</html>