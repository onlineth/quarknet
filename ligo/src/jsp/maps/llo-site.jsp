<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>
<%@ page import="gov.fnal.elab.util.ElabUtil" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>LIGO Livingston Site</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/info.css"/>
		<link rel="stylesheet" type="text/css" href="../css/two-column.css"/>
	</head>
		
	<body id="lho-site" class="info">
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
		<td id="left">
			<%@ include file="../include/left-alt.jsp" %>
		</td>
		<td id="center">
			<h1>LIGO Livingston Observatory (LLO) Site Map</h1>
			
			<%@ include file="../include/nav-maps.jsp" %>
			
			<p align="center">
				<img src="../graphics/llo-site.jpg" alt="Bird's Eye View of LLO" 
					width="595" height="562" border="1" />
				<br />
				LIGO Hanford's seismometers are located in the five buildings along the beam line plus the vault.
			</p>
		</td>
	</tr>
</table>


			</div>
			<!-- end content -->	
		
			<div id="footer">
				<%@ include file="../include/nav-footer.jsp" %>
			</div>
		</div>
		<!-- end container -->
	</body>
</html>
