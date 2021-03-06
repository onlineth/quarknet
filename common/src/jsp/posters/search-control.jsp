<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ page import="gov.fnal.elab.util.ElabUtil" %>
<%@ page import="gov.fnal.elab.datacatalog.*" %>
<%@ page import="gov.fnal.elab.datacatalog.query.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<% 
SimpleDateFormat DATEFORMAT = new SimpleDateFormat("MM/dd/yyyy");
DATEFORMAT.setLenient(false);
String msg = (String) request.getAttribute("msg");
ResultSet rsTags = DataTools.retrieveTags(elab);
String[] availablePosterTags = rsTags.getLfnArray();
request.setAttribute("availablePosterTags", availablePosterTags);
%>

<script type="text/javascript">
$(function() {
	var calendarParam = {
			showOn: 'button', 
			buttonImage: '../graphics/calendar-blue.png',
			buttonImageOnly: true, 
			changeMonth: true,
			changeYear: true, 
			showButtonPanel: true,
			minDate: new Date(2000, 11-1, 30), // Earliest known date of data - probably should progamatically find. 
			maxDate: new Date() // Should not look later than today
	};
	$('.datepicker').datepicker(calendarParam);
	$("#data1").datepicker('option', 'buttonText', 'Choose start date.');
	$("#data2").datepicker('option', 'buttonText', 'Choose start date.');
	$('img.ui-datepicker-trigger').css('vertical-align', 'text-bottom'); 
});
</script>
<script>
	function checkNeedPosterTags(object) {
		if (object.value == "postertag") {
			$("#name")
		    .replaceWith('<select id="name" name="value">' +
		          	'<option></option>' +
					'<c:forEach items="${availablePosterTags}" var="availablePosterTags">' +
					'	<option name="${availablePosterTags}" value="${availablePosterTags}">${availablePosterTags}</option>' +
					'</c:forEach>' +			
		          	'</select>');
		} else {
			$("#name")
		    .replaceWith('<input name="value" id="name" size="40" maxlength="40" value="${param.value}">');			
		}
	}
</script>

<div class="poster-search-control"> 
	<div class="search-quick-links">
		Quick Searches:&nbsp; 
		<e:quicksearch key="group" value="${user.name}"/>,
		<e:quicksearch key="teacher" value="<%= user.getTeacher() %>"/>,
		<e:quicksearch key="school" value="${user.school}"/>,
		<e:quicksearch key="city" value="${user.city}" />,
		<e:quicksearch key="state" value="${user.state}" />
	</div>
	
	<form name="search" method="get">
	<e:select name="key" valueList="title, group, teacher, school, city, state, year, postertag"
		labelList="Title, Group, Teacher, School, City, State/Country, Academic Year, Poster Tags"
		default="${param.key}" onChange="checkNeedPosterTags(this); "/>
	<c:choose>
		<c:when test='${param.key == "postertag" }'>
			<select id="name" name="value">
	          	<option></option>
				<c:forEach items="${availablePosterTags}" var="availablePosterTag">
					<c:choose>
						<c:when test="${availablePosterTag == param.value}">
							<option name="${availablePosterTag}" value="${availablePosterTag}" selected>${availablePosterTag}</option>
						</c:when>
						<c:otherwise>
							<option name="${availablePosterTag}" value="${availablePosterTag}">${availablePosterTag}</option>				
						</c:otherwise>
					</c:choose>
				</c:forEach>				
			</select>
		</c:when>
		<c:otherwise>
			<input name="value" id="name" size="40" maxlength="40" value="${param.value}" />
		</c:otherwise>
	</c:choose>			
	<input type="submit" name="submit" value="Search Data" />
		<e:vswitch>
			<e:visible image="../graphics/Tright.gif">
				Advanced Search 
			</e:visible>
			<e:hidden image="../graphics/Tdown.gif">
				Advanced Search
				<table class="form-controls" style="border: 1px dotted black; margin-left: auto; margin-right: auto; padding: 8px;">
				<tr><td>
					Please enter dates in MM/dd/yyyy format (e.g. <%= DATEFORMAT.format(new Date()) %>).<br />
					You may leave one or both date fields blank.<br />
					Date Range: &nbsp;&nbsp;&nbsp;From: 
					<e:trinput name="date1" id="date1" size="10" maxlength="15" class="datepicker" />
					to
					<e:trinput name="date2" id="date2" size="10" maxlength="15" class="datepicker" />
					
					</td></tr>
					<tr>
						<td>
							<input type="radio" name="status" value="all" checked="true" />All
					    	<input type="radio" name="status" value="published" />Published
					    	<input type="radio" name="status" value="unpublished" />Unpublished
						</td>
					</tr>
				</table>
			</e:hidden>
		</e:vswitch>
		<p>
			States include provinces and foreign countries. Use the 
			<e:popup href="../jsp/showStates.jsp" target="states" width="400" height="700">abbreviation</e:popup>
		</p>
	
		<%
			//variables used in metadata searches:
			String errors = ""; 
			String key = request.getParameter("key");
			if (StringUtils.isBlank(key)) key="name";
			
			String value = request.getParameter("value");
			value = StringUtils.trimToEmpty(value);
			
			String date1 = request.getParameter("date1");
			String date2 = request.getParameter("date2");
	
			boolean submit = request.getParameter("submit") != null;
				
			ResultSet searchResults = null;
			if (submit) {
				//EPeronja-06/12/2013: 63: Data search by state requires 2-letter state abbreviation
				String abbreviation = "";
				if (key.equals("state")) {
					abbreviation = DataTools.checkStateSearch(elab, value);
					if (!abbreviation.equals("")) {
						value = abbreviation;
					} else {
						msg = "<i>*"+value+" does not exist. Please enter a valid state abbreviation (ie: Florida, FLORIDA, fl, FL)</i>";
					}
				}
				
				And and = new And();
			    and.add(new Equals("project", elab.getName()));
			    and.add(new Equals("type", "poster"));
			    if (value.isEmpty()) {
			    	// do nothing
			    }
			    else if (!key.equals("year")) {
			    	// Automatically generate wildcard, make case-insensitive
			    	and.add(new ILike(key, "%" + value + "%"));
			    }
			    else {
			    	if (value.toUpperCase().startsWith("AY")) {
			    		and.add(new Equals(key, value.toUpperCase()));
			    	}
			    	else { 
			    		try {
			    			Integer.parseInt(value);
			    			and.add(new Equals(key, "AY" + value));
			    		}
			    		catch (NumberFormatException ex) {
			    			errors += "The system did not understand the academic year you typed in, please check what you typed. <br />";
			    		}
			    	}
			    }
				    
			//hmm. posters use "date" instead of "creationdate"
			// Probably should do this Cosmic-style 
		    if (StringUtils.isNotBlank(date1) || StringUtils.isNotBlank(date2)) {
				// In case someone makes their own search string and forgets the date type 
				
				try {
					Date startDate = null, endDate = null; 
					
					if (StringUtils.isNotBlank(date1)) {
						startDate = DATEFORMAT.parse(date1); 
					}
					if (StringUtils.isNotBlank(date2)) {
						endDate = DATEFORMAT.parse(date2);
						endDate.setHours(23); 
						endDate.setMinutes(59);
						endDate.setSeconds(59);
					}
				
					// Start date undefined, therefore less or equal to the end date just before midnight
					if (StringUtils.isBlank(date1)) {
						and.add(new LessOrEqual("date", endDate));
					}
					
					// End date undefined, therefore greater than or equal to the start date
					else if (StringUtils.isBlank(date2)) {
						and.add(new GreaterOrEqual("date", startDate));
					}
					// Date range 
					else {
						and.add(new Between("date", startDate, endDate));
					}
				}
				catch (Exception ex) {
					errors += "At least one of the dates you typed in was not understood. Please re-check the dates you typed in.";
				}
			}
		    //EPeronja-10/11/2013: Allow to search posters by status
		    String statusSearch = request.getParameter("status");
			if (statusSearch != null && !statusSearch.equals("all")) {
				and.add(new Equals("status", statusSearch));
			}
			
			searchResults = elab.getDataCatalogProvider().runQuery(and);
			request.setAttribute("searchResults", searchResults);
			request.setAttribute("msg", msg);	
			}
			
		%>
	</form>
	<div>${msg}</div>
</div>
