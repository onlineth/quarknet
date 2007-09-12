<%@ page isErrorPage="true" %>
<%@ include file="../include/elab.jsp" %>
<%@ page import="gov.fnal.elab.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Error Page</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
	</head>
	
	<body id="error-page" class="error">
		<h1>An error has occurred during your request</h1>

		<table border="0" id="main">
			<tr>
				<% if (exception instanceof ElabJspException) { %>
					<span class="error"><%= exception.getMessage() %></span>
				<% } else { %>
					<td id="center">
						<h2>Request URL:</h2>
						<pre><%= request.getRequestURL() %></pre>
						<h2>Query String:</h2>
						<pre><%= request.getQueryString() %></pre>
						<h2>User:</h2>
						<% ElabGroup user = ElabGroup.getUser(session); %>
						<pre><%= user %></pre>
						<% if (exception != null) { %>
							<h2>Exception</h2>
							<pre><%= exception.toString() %></pre>
							<h2>Stack trace:</h2>
							<pre><% exception.printStackTrace(new java.io.PrintWriter(out)); %></pre>
							<% 
								if(exception instanceof JspException) {
								    Throwable root = ((JspException) exception).getRootCause();
								    if (root != null) {
									    %> <h2>Root cause:</h2>
									       <pre> <%
										root.printStackTrace(new java.io.PrintWriter(out));
									    %> </pre> <%
								    }
								}
						} %>
					</td>
				<% } %>
			</tr>
		</table>

	</body>
</html>