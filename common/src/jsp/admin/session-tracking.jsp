<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/admin-login-required.jsp" %>
<%@ page import="gov.fnal.elab.SessionListener" %>
<%@ page import="gov.fnal.elab.Pair" %>
<%@ page import="gov.fnal.elab.*" %>
<%@ page import="gov.fnal.elab.notifications.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.*"%>
<%
	int sessionCount = SessionListener.getTotalActiveSession();
	int userCount = 0;
	TreeMap<String, List<Pair>> activeSessions = SessionListener.getTotalSessionUsers();
	//now create the local TreeMap
	TreeMap<String, List<Pair>> sessionDetails = new TreeMap<String, List<Pair>>();
	
	for (Map.Entry<String, List<Pair>> entry : activeSessions.entrySet()) {
		String key = entry.getKey();
		List<Pair> value = (List<Pair>) entry.getValue();
		List<Pair> details = new ArrayList<Pair>();
		for (Pair p: value) {
			details.add(p);			
			if (p.getLeft().equals("session")) {
				HttpSession s = (HttpSession) p.getRight();
				ElabGroup eu = (ElabGroup) s.getAttribute("elab.user");
				Elab e = (Elab) s.getAttribute("elab");
				if (eu != null && e != null) {
					details.add(new Pair("username", eu.getName()));
					details.add(new Pair("school", eu.getSchool()));
					details.add(new Pair("role", eu.getRole()));
					details.add(new Pair("logged in to", e.getName()));
					userCount++;
				}
			}
		}
		sessionDetails.put(key, details);
	}

	request.setAttribute("sessionCount",sessionCount);
	request.setAttribute("userCount",userCount);
	request.setAttribute("sessionDetails",sessionDetails);	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">		
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Session Tracking</title>
		<link rel="stylesheet" type="text/css" href="../../cosmic/css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../../cosmic/css/teacher.css"/>
		<link rel="stylesheet" type="text/css" href="../css/teacher.css"/>
	</head>
	
	<body id="session-tracking" class="teacher">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<div id="nav">
						<%@ include file="../include/nav-teacher.jsp" %>
					</div>
				</div>
			</div>
			
			<div id="content">
				<h1>Session Tracking</h1>
				<h2>Total Active Sessions: ${sessionCount}</h2>
				<h2>Total Active User Sessions: ${userCount}</h2>
	    	   <table style="border: 1px solid black; cell-padding: 15px;">
	    	   		<tr>
	    	   			<th>Session Id</th>
	    	   			<th>Details</th>
	    	   		</tr>
	    	   		<c:forEach items="${sessionDetails}" var="sessionDetails">
	    	   			<tr>
	    	   				<td style="vertical-align: top; border: 1px dotted gray;">${sessionDetails.key }</td>
	    	   				<td style="vertical-align: top; border: 1px dotted gray;">
	    	   					<c:forEach items="${sessionDetails.value}" var="pair">
	    	   						<strong>${pair.left} : </strong>${pair.right } <br />
	    	   					</c:forEach>
	    	   				</td>
	    	   			</tr>
	    	   		</c:forEach>
	    	   </table>
			</div>
			<!-- end content -->	
		
			<div id="footer">
			</div>
		</div>
		<!-- end container -->
	</body>
</html>