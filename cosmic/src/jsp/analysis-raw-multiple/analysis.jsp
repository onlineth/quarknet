<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page errorPage="../include/errorpage.jsp" buffer="none" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="gov.fnal.elab.datacatalog.*" %>
<%@ page import="gov.fnal.elab.datacatalog.query.*" %>
<%@ page import="gov.fnal.elab.analysis.*" %>
<%@ page import="gov.fnal.elab.cosmic.util.*" %>
	
<%
	String[] lfn = request.getParameterValues("f");
	if (lfn == null) {
	   	throw new ElabJspException("No files specified");
	}
	List files = new ArrayList();
	List outfiles = new ArrayList();
	for (int i = 0; i < lfn.length; i++) {
	    String did = AnalysisParameterTools.getDetectorId(lfn[i]);
		File analyze = new File(new File(elab.getProperties().getDataDir(), did), lfn[i] + ".analyze");
		CatalogEntry entry = elab.getDataCatalogProvider().getEntry(analyze.getName());
	    if (!analyze.exists()) {
			files.add(lfn[i]);
			outfiles.add(analyze.getAbsolutePath());
	    }
	}
	if (files.isEmpty()) {
	    request.setAttribute("done", Boolean.TRUE);
	}
	else {
	    request.setAttribute("done", Boolean.FALSE);
	}
	request.setAttribute("files", files);
	request.setAttribute("outFiles", outfiles);
%>

<c:choose>
	<c:when test="${done}">
		<jsp:include page="output.jsp?f=${fn:join(outFiles, '&f=')}"/>
	</c:when>
	<c:otherwise>
		<e:analysis name="analysis" type="I2U2.Cosmic::RawAnalyzeStudy">
			<% ((ElabAnalysis) request.getAttribute("analysis")).setAttribute("f", lfn); %>
			<e:trinput type="hidden" name="gatewidth" default="100"/>
			<e:trdefault name="inFile" value="${files}"/>
			<e:trdefault name="outFile" value="${outFiles}"/>
			<e:ifAnalysisIsOk>
				<jsp:include page="../analysis/start.jsp?continuation=../analysis-raw-multiple/output.jsp&onError=../analysis-raw-multiple/analysis.jsp"/>
			</e:ifAnalysisIsOk>
			<e:ifAnalysisIsNotOk>
			
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">		
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Data file analysis error</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/data.css"/>
		<link rel="stylesheet" type="text/css" href="../css/one-column.css"/>
		<script type="text/javascript" src="../include/elab.js"></script>
	</head>
	
	<body id="raw-analysis-single" class="data">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<%@ include file="../include/nav-rollover.jspf" %>
				</div>
			</div>
			
			<div id="content">

<table border="0" id="main">
	<tr>
		<td id="center">
			<p>
				<span class="error">An error has occurred.</span>
			</p>
								
		    <c:if test="${!(empty analysis.invalidParameters)}">
		    	<h2>Invalid keys:</h2>
		        <ul class="errors">
		            <c:forEach var="f" items="${analysis.invalidParameters}">
		                <li><c:out value="${f}"/></li>
		            </c:forEach>
		        </ul>
		    </c:if>
		</td>
	</tr>
</table>

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
	</c:otherwise>
</c:choose>
