<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/elab.jsp" %>
<%@ page import="gov.fnal.elab.ElabGroup" %>

<%
String prevPage = request.getParameter("prevPage");
if(prevPage == null) {
	prevPage = elab.getProperties().getLoggedInHomePage();
}
ElabGroup user = (ElabGroup) request.getAttribute("user");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="java.net.URLDecoder"%><html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Login to ${elab.properties.formalName}</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/login.css"/>
	</head>
	
	<body id="login">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<div id="nav">
						<!-- no nav here -->
					</div>
				</div>
			</div>
			
			<div id="content">
				
<h1>Please change your password!</h1>

<table border="0" id="main">
	<tr>
		<td>
			<div id="left">
			</div>
		</td>
		<td>
			<div id="center">
				<p>We're adding great new futures to our eLabs but to access these new features you'll need to change your
				password. It should be at least six characters long. </p>
				
				<p><a href="/elab/cosmic/teacher/update-groups.jsp?submit=Show+Group+Info&chooseGroup=<%=user.getName()%>">Click here to change your password</a>.</p>
				
				<p><a href="<%=URLDecoder.decode(prevPage)%>">Click here to continue on into the eLab.</a></p>
			</div>
		</td>
		<td>
			<div id="right">
			</div>
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