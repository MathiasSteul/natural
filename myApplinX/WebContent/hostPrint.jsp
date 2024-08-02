<%@ taglib  uri="com/sabratec/j2ee/framework/tags"  prefix="gx" %>
<% response.setContentType("application/x-java-jnlp-file"); %>
<%
	String attachment = "inline; filename=\"ApplinX_hostPrint_"
			+ System.currentTimeMillis() + ".jnlp\"";
	response.setHeader("Content-disposition", attachment);	
 %>


 <?xml version="1.0" encoding="utf-8"?>

 
<gx:jnlp  gx_context="contexts.GXInstantLogicContext">
    
 
 
 
 <!-- To add parameters the the hostPrint window , use the following format:
 	 gx:jnlp  gx_context="contexts.GXInstantLogicContext" param1=value1 param2=value2 etc. 
 	 Following are the paramaters that can be added:
 	 	parameter								default value					description
 	 	__________								_____________					___________________________________________________________________________________________________________________
 	 	
 	 	userid									hostPrint_session_id			user ID
 	 	
 	 	serverURL								applinx:server name:port		URL to Access ApplinX server
 	 	
 	 	application								Applicaition name				The application used in the session.
 	 	
 	 	password								""								session password
 	 	
 	 	description								""								Print description
 	 	 	 	
	 	device_name								""
	 									
	 	associate_device_name					""								The name of the display device (on the host) that the printer should connect to. Note: Applicable for 
																				Mainframes only. The host handles the linkage of printer session to the display device.
																		
		message_queue							""								The name of the queue where messages about printing are sent. Note: Applicable for AS400 only.
		
		message_lib								""								The name of the library where messages about printing are sent. Note: Applicable for AS400 only.
		
		initial_focus							false
		
		enable_presentation						true							Setting the value to true displays the graphic user interface of the applet. If it is false, the log of the applet 
																				can still be viewed via the browser Java console (default: true).
																		
		host_address							""								
							
	 	host_port								0
	 	
	 	auto_reconnect_number_of_tries 			0
	 	
	 	auto_reconnect_time_interval 			30000
	 	
		disconnect_previous_session 			false
				
		printer_device							""								Silent printing (without print dialog)
																				The value "default" indicates that for each user, the print job should be sent to the default printer on the machine.
																				The value "First Selected Printer" indicates that the print dialog pops up once, and then the printlet uses the chosen
																				printer device in all future print jobs in the current session and the printing is done silently.																		
																		
		bypass_gdi								false							Possible values are False (default), indicating that the printing layout is graphical or True, indicating that 
																				the printer will define the layout.
																		
		transparent_start_trigger 				""								Defines one or two characters used to identify the beginning of the transparent commands. optional, for 3270 LU3 print jobs only.
		
		transparent_end_trigger	  				""	 				            Defines one or two characters used to identify the end of the transparent commands.optional, for 3270 LU3 print jobs only. 
			
		output_file_name						""								Print to File parameter, output file name
		 
		append_to_file							false							Print to File parameter(value: true/false), Append the print to existing file.
		 
		printjob_separator_text					""								Print to File,  separtor text between print to the other.
		
		print_as_text							false							Print to File parameter(value: true/false), print as text.
		
		wait									-1								The time to wait for each job to end (default 1 minute).
		
		sleep									-1 								The time in between requests to determine the end of a print job.
		
		loglevel								normal							Advises the applet how much and what to write to the log. Values can be normal (default) or debug.
		
		lines_per_page							-1								Sets lines per page. Usually, set according to the host’s definition (default value equals 66 or if value is set 
																				to “0”). However, you can override this according to your requirements. Page is cut when it reaches the 
																				number of lines per page (only for 3270).
																				
		characters_per_line						-1								Sets characters per line. Usually, set according to the host’s definition (default value equals 80 or if value is 
																				set to “0”. However, you can override this according to your requirements. Line is cut when it reaches the 
																				number of characters per line (only for 3270).
																											
		exclude_last_page_if_empty				false							It is possible to define that when the last page of a print job is blank, this page will not be printed.
		
		do_not_print_siso_as_space				false							Determines whether to print Shift-In and Shift-Out as spaces. Possible values: true, false. (only for 3270).
		
		font_name								"Courier New"
		
		font_size								10
			
		font_bold								false
		
		font_italic								false
		
		LPI										NaN								CPI, LPI settings:		
		CPI										NaN								- Negative number == best-fit.
																				- 0 (zero) value  == set by the host (default)
																				- Positive number == manual fixed value, may be one of the following:
																				LPI: 4 , 5.3 , 6 , 6.3 , 8 , 8.5 , 9.6 , 12 , 24 , 48 
																				CPI: 5 , 10 , 12 , 13.33 , 15 , 17.14 , 20 , 26.66
																		 
		cpi_translation							""								CPI and Font values may be translated. 
		font_id_translation						""								Translation format:
																				CPI_original_value/Font_Id_value=CPI_new_value-Font_Style-Font_Name;
																				The Font_Style possible values are: Regular, Bold, Italic or Bold Italic.
																				Example: 4=6-Bold-Courier New;5.3=7-Regular-Arial; ...
																		
		left_margin								0								Set left margin for a page 
		
		top_margin								0								Set top margin for a page
		
		right_margin							0								Set right margin for a page
		
		bottom_margin							0								Set bottom margin for a page
		
		do_not_add_form_feed_at_end_of_job		false							By default, the value of this parameter is false, printing the blank page. By default at the end of a printing job, 
																				the Printlet sends the from feed command to the printer. To disable this option, set this parameter to TRUE.
																				Note: When this option is used, the "lines_per_page" option MUST also be set.																				
																																						
		orientation_type						use_host						Forces specific orientation: portrait or landscape (default: use_host (applies the host orientation 
																				definitions)). This option does not function in MSJVM.optional - possible values:"use_host","landscape","portrait"
																									
		change_font_size_by_chars_per_line 		false							Searches for the longest line on the page, checks if the characters in the line fit into the page dimensions. If 
																				negative, will change font accordingly. If minimal_font_size is empty, the applet will not reduce the font size 
																				(default: false). Ensure that you defined the characters_per_line parameter.
																		
		change_orientation_by_chars_per_line 	false	
		
		minimal_font_size						6								The minimum size of font is set by this parameter. Must be set in order for 
																				Change Font Size According to Page Size (change_font_size_by_chars_per_line) to work.	
		check_each_page_separately				false	
		
		best_fit_row_proportion					""								Percentage of font size, to use as best fit row proportion. Used in cases where a print job has a relatively 
																				small number of lines. The printlet will increase the proportion of the row gradually (so it still fits the 
																		 		page). Example value: 130%.
		
		window_minimized_on_start			   false							Minimize the printlet window when starting it as a webstart application
-->																		
</gx:jnlp>