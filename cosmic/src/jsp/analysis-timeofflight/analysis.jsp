<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ page errorPage="../include/errorpage.jsp" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>
<%@ page import="gov.fnal.elab.datacatalog.*" %>
<%@ page import="gov.fnal.elab.analysis.*" %>
<%@ page import="gov.fnal.elab.util.*" %>
<%@ page import="gov.fnal.elab.cosmic.util.*" %>

<e:analysis name="analysis" type="I2U2.Cosmic::TimeOfFlight">
	<%
		ElabAnalysis analysis = (ElabAnalysis) request.getAttribute("analysis");
		Collection rawData = analysis.getParameterValues("rawData");
		if(rawData != null) {
			List thresholdData = AnalysisParameterTools.getThresholdFiles(elab, rawData);
			String ids = AnalysisParameterTools.getDetectorIds(rawData);
			List wd = AnalysisParameterTools.getWireDelayFiles(elab, rawData);
			List geo = AnalysisParameterTools.getGeometryFiles(elab, rawData);
			String cpldfreqs = AnalysisParameterTools.getCpldFrequencies(elab, rawData);
			String firmwareVersions = AnalysisParameterTools.getFirmwareVersions(elab, rawData);
			Collection validChannelsRequire = AnalysisParameterTools.getValidChannels(elab, rawData);
			Collection validChannelsVeto = AnalysisParameterTools.getValidChannels(elab, rawData);
			//make a new copy because we're going to mess with this one
			request.setAttribute("validChannelsRequire", new HashSet(validChannelsRequire));
			request.setAttribute("validChannelsVeto", new HashSet(validChannelsVeto));
			//only set up channels after a submit was pressed
			if (request.getParameter("submit") != null) {
				for (int i = 1; i <= 4; i++) {
					String channel = String.valueOf(i);
					if (request.getParameter("singleChannel_require"+channel) == null) {
						validChannelsRequire.remove(channel);
					}
					if (request.getParameter("singleChannel_veto"+channel) == null) {
						validChannelsVeto.remove(channel);
					}
				}
			} else {
				String channelsRequire = (String) analysis.getParameter("singleChannel_require");
				if (channelsRequire != null) {
					for (int i = 1; i <= 4; i++) {
						String channel = String.valueOf(i);
						if (channelsRequire.indexOf(channel) == -1) {
							validChannelsRequire.remove(channel);
						}
					}
				}
				String channelsVeto = (String) analysis.getParameter("singleChannel_veto");
				if (channelsVeto != null) {
					for (int i = 1; i <= 4; i++) {
						String channel = String.valueOf(i);
						if (channelsVeto.indexOf(channel) == -1) {
							validChannelsVeto.remove(channel);
						}
					}
				}
			}
			Collection cr = new TreeSet(validChannelsRequire);		
			String singleChannel_require = ElabUtil.join(cr, null, null, " ");
			Collection cv = new TreeSet(validChannelsVeto);		
			String singleChannel_veto = ElabUtil.join(cv, null, null, " ");

			%>
	        <e:trdefault name="thresholdAll" value="<%= thresholdData %>"/>
	        <e:trdefault name="wireDelayData" value="<%= wd %>"/>
			<e:trdefault name="detector" value="<%= ids %>"/>
			<e:trdefault name="geoDir" value="${elab.properties['data.dir']}"/>
			<e:trdefault name="geoFiles" value="<%= geo %>"/>
			<e:trdefault name="cpldfreqs" value="<%= cpldfreqs %>"/>
			<e:trdefault name="singleChannel_require" value="<%= singleChannel_require %>"/>
			<e:trdefault name="singleChannel_veto" value="<%= singleChannel_veto %>"/>
			<e:trdefault name="cpldfreqs" value="<%= cpldfreqs %>"/>
			<e:trdefault name="firmwares" value="<%= firmwareVersions %>" />
			<%
		}
	%>
	<e:trdefault name="eventCandidates" value="eventCandidates"/>
	<e:trdefault name="sort_sortKey1" value="2"/>
	<e:trdefault name="sort_sortKey2" value="3"/>
	
	<e:ifAnalysisIsOk>
		<jsp:include page="../analysis/start.jsp?continuation=../analysis-timeofflight/output.jsp&onError=../analysis-timeofflight/analysis.jsp"/>
	</e:ifAnalysisIsOk>
	<e:ifAnalysisIsNotOk>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">		
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Choose time of flight parameters</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/data.css"/>
		<link rel="stylesheet" type="text/css" href="../css/one-column.css"/>
		<script type="text/javascript" src="../include/elab.js"></script>
	</head>
	
	<body id="timeofflight-study" class="data">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<%@ include file="../include/nav-rollover.jspf" %>
				</div>
			</div>
			
			<div id="content">

<c:choose>
	<c:when test="${analysis.parameters.rawData != null}">
	<h1>Time of Flight study</h1>
	<hr>
		<table border="0" id="main">
			<tr>
				<td id="center">
					<jsp:include page="../data/analyzing-list.jsp"/>
					
					<p id="other-analyses">
						Analyze the same files in
						<e:link href="../analysis-performance/analysis.jsp" rawData="${analysis.parameters.rawData}">performance</e:link>
					</p>
					
				    <c:if test="${!(empty analysis.invalidParameters) && param.submit != null}">
				    	<h2>Invalid keys:</h2>
				        <ul class="errors">
				            <c:forEach var="f" items="${analysis.invalidParameters}">
				                <li><c:out value="${f}"/></li>
				            </c:forEach>
				        </ul>
				    </c:if>
				    <%
				    Integer num_files = (Integer) session.getAttribute("num_files");
				    Integer file_count = 0;
				    if (num_files != null) {
					    file_count = Integer.valueOf(num_files);
				    }
				    if (file_count > 0) {
					%>
					    <%@ include file="controls.jsp" %>
					<%
				    } else {
				    %>
				    	<p>There are no files available to run this analysis</p>
				    <%
				    }
					%>
				</td>
			</tr>
		</table>
	</c:when>
	<c:otherwise>
		<table border="0" id="main">
			<tr>
				<td id="center">
					<span class="error">No files selected!</span>
					<p>
						Please <a href="index.jsp">choose</a> at least one day to analyze.
					</p>
				</td>
			</tr>
		</table>
	</c:otherwise>
</c:choose>
			</div>
			<!-- end content -->	
	
			<div id="footer">

			</div>
		</div>
		<!-- end container -->
	</body>
</html>

	</e:ifAnalysisIsNotOk>
</e:analysis>
