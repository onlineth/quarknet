<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page errorPage="../include/errorpage.jsp" buffer="none" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="gov.fnal.elab.datacatalog.impl.vds.*" %>
<%@ page import="gov.fnal.elab.datacatalog.*" %>
<%@ page import="gov.fnal.elab.datacatalog.query.*" %>
<%@ page import="gov.fnal.elab.*" %>
<%@ page import="gov.fnal.elab.cosmic.bless.*" %>   

<%

String file = request.getParameter("file");
if (StringUtils.isBlank(file)) {
    throw new ElabJspException("Missing file name.");
}

VDSCatalogEntry entry = (VDSCatalogEntry) elab.getDataCatalogProvider().getEntry(file);
if (entry == null) {
    throw new ElabJspException("No information about " + file + " found.");
}
//EPeronja-07/22/2013 558: Cosmic Bless Charts - Requests from fellows workshop 10 July 2013
String comments = (String) entry.getTupleValue("comments");
String commentsLink = "";
if (comments != null && !comments.equals("")) {
    commentsLink = "<a href=\"../jsp/comments-add.jsp?fileName="+entry.getLFN() +
    			   "\"><img src=\"../graphics/balloon_talk_blue.gif\"/></a>";
} else {
	comments = "No comments";
    commentsLink = "<a href=\"../jsp/comments-add.jsp?fileName="+entry.getLFN() +
			   "\"><img src=\"../graphics/balloon_talk_empty.gif\"/></a>";
}
entry.sort(); 
request.setAttribute("e", entry);

//EPeronja-01/24/2013: Bug472- find out if the user has ownership over the data
boolean owner = false;
String groupOwner = (String) entry.getTupleValue("group");
if (groupOwner != null) {
	if (groupOwner.equals(user.getName())) {
		owner = true;
	}
}
request.setAttribute("owner", owner);
String benchmark = (String) entry.getTupleValue("benchmarkreference");

//EPeronja-02/04/2013: Bug472- format registers
BlessRegister br0 = new BlessRegister((String) entry.getTupleValue("ConReg0"));
request.setAttribute("CR0", br0.getRegisterValue());

%>
   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Blessing Charts</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/data.css"/>
		<link rel="stylesheet" type="text/css" href="../css/one-column.css"/>
		<script type="text/javascript" src="../include/elab.js"></script>

		<title>Data Blessing</title>
	</head>
	<body class="upload" style="text-align: center;">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<%@ include file="../include/nav-rollover.jspf" %>
				</div>
			</div>
			
			<div id="content">
				<script type="text/javascript" src="../include/jquery/flot/jquery.flot.js"></script>
				<script type="text/javascript" src="../include/jquery/flot/jquery.flot.errorbars.js"></script>
				<script type="text/javascript" src="../include/jquery/flot/jquery.flot.axislabels.js"></script>
				<script type="text/javascript" src="../include/jquery/flot/jquery.flot.symbol.js"></script>
				<script type="text/javascript" src="../include/excanvas.min.js"></script>
				<script type="text/javascript" src="../include/canvas2image.js"></script>
				<script type="text/javascript" src="../include/base64.js"></script>
				<script type="text/javascript" src="blessing.js"></script>
				<script type="text/javascript">
				$(document).ready(function() {
					$.ajax({
						url: "get-data.jsp?file=<%= file %>&benchmark=<%=benchmark %>",
						processData: false,
						dataType: "json",
						type: "GET",
						success: onDataLoad1
					});
				}); 
				
				function popUpClosed() {
					window.location.reload();
				}
				</script>
				<h1>Data Blessing: Want to use this data?  Look at these charts to determine data quality.</h1>
				<div style="text-align: center; font-size: small;"><strong>Data Blessing Test for ${param.file} -
				<%= entry.getTupleValue("school") %>, <%= entry.getTupleValue("city") %>, <%= entry.getTupleValue("state") %> -
				<fmt:formatDate value="${e.tupleMap.startdate}" pattern="dd MMM yyyy"/>				
				</strong></div><br />
				<div style="text-align: center;">
					<a href="../data/view.jsp?filename=${param.file}">Show Data</a> |
					<a href="../data/view-metadata.jsp?filename=${param.file}">Show metadata</a> |
					<c:if test="${e.tupleMap.detectorid != null}">
						<a href="../geometry/view.jsp?filename=${param.file}">Show Geometry</a> |
					</c:if>
					<a href="../data/download?filename=${param.file}.bless&elab=${elab.name}&type=split">Download Bless File</a> |
					<e:popup href="../references/Reference_bless_data.html" target="DataBlessing" width="900" height="800">Interpreting the blessing plots</e:popup>
				</div>
				<h2>Control Register</h2>
				<table width="100%">
				    <tr><td width="20px">CR0: </td><td width="100px"><strong><%= entry.getTupleValue("ConReg0") != null? entry.getTupleValue("ConReg0") : "Unknown" %></strong></td>
				    	<td rowspan="2" ><%= commentsLink %> <%= entry.getTupleValue("comments") %></td></tr>
				    <tr><td width="20px"> </td><td width="100px"><strong>${CR0}</strong></td></tr>
				</table>
				<div style="text-align: center;"><strong>Owners of data files can bless data based on their interpretation of these charts</strong></p></div>
				<% //if (owner) { %>							
				<table witdh="100%"  style="border: 1px solid black;">
					<tr><td style="text-align: center;">Look at these charts and bless your data if it is of high quality </td>
						<td> 
							<td style="text-align: right;">
							 	<form name="blessForm" action="blessdata.jsp" method="post" target="blessWindow" onsubmit="window.open('',this.target,'width=300,height=100,top=200,left=500 resizable=1');" align="center"> 
									<input type="hidden" name="blessed" value="${e.tupleMap.blessed}"/>
									<input type="hidden" name="filename" value="${param.file}"></input>
									<c:choose>
									  	<c:when test="${e.tupleMap.blessed == true}">
											<input type="submit" name="submitbless" id="submitbless" value="Unbless" />
										</c:when>
										<c:otherwise>
											<input type="submit" name="submitbless" id="submitbless" value="Bless" />
										</c:otherwise>
									</c:choose>	
								</form>
							</td>
						</td>
					</tr>
				</table><br /> 
				<% //} %>						
				<div id="xAxesControl">
					<table id="xAxesControlTable">
						<tr>
							<td>Custom X-axes scale: </td>
							<td style="background-color: lightGray">Min X: <input type="text" id="minX" /><input type="button" value="Set" id="minXButton" onclick='javascript:redrawPlotX(minX.value, "min");' /></td>
							<td style="background-color: lightGray">Max X: <input type="text" id="maxX" /><input type="button" value="Set" id="maxXButton" onclick='javascript:redrawPlotX(maxX.value, "max");' /></td>
							<td style="background-color: lightGray"><input type="button" value="Reset" id="resetXButton" onclick='javascript:resetPlotX("minX","maxX");' /></td>
						</tr>
					</table>
				</div>
				<h2>Rates</h2>
				<!-- control added to change axes values -->
				<jsp:include page="chartcontrols.jsp">
					<jsp:param name="chartName" value="channel" />
				</jsp:include>

				<div id="channels" style="background-color:#FFFFFF">
					<div id="channelChart" style="width:750px; height:250px; text-align: left;"></div>
					<div id="channelChartLegend" style="width: 750px"></div>
				</div>
				<!-- EPeronja-07/31/2013 570-Bless Charts: add option to save them as plots -->
				<div style="text-align:center; width: 100%;">
					Filename <input type="text" name="channelChartName" id="channelChartName" value=""></input><input type="button" name="save" onclick='return saveChart(onOffPlot, "channelChartName", "channelMsg");' value="Save Channel Chart"></input>     
					<div id="channelMsg"></div>   
				</div>
									
				<h2>Trigger Rate</h2>
				<!-- control added to change axes values -->
				<jsp:include page="chartcontrols.jsp">
					<jsp:param name="chartName" value="trigger" />
				</jsp:include>				
				<div id ="triggerChart" style="width:750px; height:250px; text-align: left;"></div>
				<div style="text-align:center; width: 100%;">
					Filename <input type="text" name="triggerChartName" id="triggerChartName" value=""></input><input type="button" name="save" onclick='return saveChart(trigPlot, "triggerChartName", "triggerMsg");' value="Save Trigger Chart"></input>     
					<div id="triggerMsg"></div>   
				</div>
	
				<h2>Visible GPS Satellites</h2>
				<!-- control added to change axes values -->
				<jsp:include page="chartcontrols.jsp">
					<jsp:param name="chartName" value="satellite" />
				</jsp:include>				
				<div id="satChart" style="width:750px; height:250px; text-align: left;"></div>
				<div style="text-align:center; width: 100%;">
					Filename <input type="text" name="satChartName" id="satChartName" value=""></input><input type="button" name="save" onclick='return saveChart(satPlot, "satChartName", "satMsg");' value="Save Satellite Chart"></input>     
					<div id="satMsg"></div>   
				</div>

				<h2>Voltage</h2>
				<jsp:include page="chartcontrols.jsp">
					<jsp:param name="chartName" value="voltage" />
				</jsp:include>			
				<div id="voltChart" style="width:750px; height:250px; text-align: left;"></div>
				<div style="text-align:center; width: 100%;">
					Filename <input type="text" name="voltChartName" id="voltChartName" value=""></input><input type="button" name="save" onclick='return saveChart(voltPlot, "voltChartName", "voltMsg");' value="Save Voltage Chart"></input>     
					<div id="voltMsg"></div>   
				</div>

				<h2>Temperature</h2>
				<!-- control added to change axes values -->
				<jsp:include page="chartcontrols.jsp">
					<jsp:param name="chartName" value="temperature" />
				</jsp:include>					
				<div id="tempChart" style="width:750px; height:250px; text-align: left;"></div>
				<div style="text-align:center; width: 100%;">
					Filename <input type="text" name="tempChartName" id="tempChartName" value=""></input><input type="button" name="save" onclick='return saveChart(tempPlot, "tempChartName", "tempMsg");' value="Save Temperature Chart"></input>     
					<div id="tempMsg"></div>   
				</div>
				
				<h2>Barometric Pressure</h2>
				<!-- control added to change axes values -->
				<jsp:include page="chartcontrols.jsp">
					<jsp:param name="chartName" value="pressure" />
				</jsp:include>				
				<div id="pressureChart" style="width:750px; height:250px; text-align: left;"></div>
				<div style="text-align:center; width: 100%;">
					Filename <input type="text" name="pressChartName" id="pressChartName" value=""></input><input type="button" name="save" onclick='return saveChart(pressPlot, "pressChartName", "pressMsg");' value="Save Pressure Chart"></input>     
					<div id="pressMsg"></div>   
				</div>				
		 	</div>
		</div>
	</body>
</html>