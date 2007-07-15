<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ page errorPage="../include/errorpage.jsp" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>
<%@ page import="gov.fnal.elab.datacatalog.*" %>
<%@ page import="gov.fnal.elab.analysis.*" %>
<%@ page import="gov.fnal.elab.util.*" %>
<%@ page import="gov.fnal.elab.cosmic.util.*" %>
	
<e:analysis name="analysis" type="Quarknet.Cosmic::FluxStudy">
	<%
		//these need to always be set-up
		//also, this piece of code is ugly
		String[] rawData = request.getParameterValues("rawData");
		if(rawData != null) {
			List thresholdData = AnalysisParameterTools.getThresholdFiles(rawData);
			List wd = new ArrayList();
			for (int i = 0; i < rawData.length; i++) {
			    wd.add(rawData[i] + ".wd");
			}
			String ids = AnalysisParameterTools.getDetectorIds(rawData);
			
			Collection channels = DataTools.getValidChannels(elab, rawData);
			ElabAnalysis a = (ElabAnalysis) request.getAttribute("analysis");

			//<trdefault> is equivalent to analysis.setParameterDefault()
			//It indicates that these parameters are NOT USER CONTROLLED and
			//should not be encoded in the param URLs for a subsequent run.
			%>
	        <e:trdefault name="thresholdAll" value="<%= thresholdData %>"/>
	        <e:trdefault name="wireDelayData" value="<%= wd %>"/>
			<e:trdefault name="detector" value="<%= ids %>"/>	  
			<e:trdefault name="singlechannelOut" value="singlechannelOut"/>
			<%
		}
	%>
	<e:trdefault name="plot_outfile_param" value="plot_param"/>
	<e:trdefault name="plot_outfile_image" value="plot.png"/>
	<e:trdefault name="plot_outfile_image_thumbnail" value="plot_thm.png"/>
	<e:trdefault name="plot_thumbnail_height" value="150"/>
	<e:trdefault name="plot_plot_type" value="1"/>
	<e:trdefault name="plot_xlabel" value="Time GMT (hours)"/>
	<e:trdefault name="plot_ylabel" value="Flux (events/m^2/60-seconds)"/>
	<e:trdefault name="flux_geoDir" value="${elab.properties['data.dir']}"/>
	<e:trdefault name="sort_sortKey1" value="2"/>
	<e:trdefault name="sort_sortKey2" value="3"/>
	
	<e:ifAnalysisIsOk>
		<jsp:include page="../analysis/start.jsp?continuation=../analysis-flux/output.jsp"/>
	</e:ifAnalysisIsOk>
	<e:ifAnalysisIsNotOk>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">		
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Choose flux parameters</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/data.css"/>
		<link rel="stylesheet" type="text/css" href="../css/one-column.css"/>
		<script type="text/javascript" src="../include/elab.js"/>
	</head>

	<body id="flux-study" class="data">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<div id="nav">
						<%@ include file="../include/nav.jsp" %>
						<div id="subnav">
							<%@ include file="../include/nav-data.jsp" %>
						</div>
					</div>
				</div>
			</div>
			
			<div id="content">

<c:choose>
	<c:when test="${param.rawData != null}">
		<h1>Calculate the flux for your data file. Rember, flux = particles / time / area</h1>
		<table border="0" id="main">
			<tr>
				<td id="center">
					<p>
						<a href="tutorial.jsp">Understand the graph</a>
					</p>
					
					<jsp:include page="../data/analyzing-list.jsp">
						<jsp:param name="f" value="${param.rawData}"/>
					</jsp:include>
					
					<p id="other-analyses">
						Analyze the same files in 
						<a href="../analysis-lifetime/analysis.jsp?rawData=${param.rawData}">lifetime</a>
						<a href="../analysis-shower/analysis.jsp?rawData=${param.rawData}">shower</a>
					</p>
					
				    <c:if test="${!(empty analysis.invalidParameters) && param.submit != null}">
				    	<h2>Invalid keys:</h2>
				        <ul class="errors">
				            <c:forEach var="f" items="${analysis.invalidParameters}">
				                <li><c:out value="${f}"/></li>
				            </c:forEach>
				        </ul>
				    </c:if>
				    
				    <%@ include file="controls.jsp" %>
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
