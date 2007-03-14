<%@ include file="include/elab.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>e-Lab Teacher Site Map</title>
		<%= elab.css("css/style2.css") %>
		<%= elab.css("css/teacher.css") %>
		<%= elab.css("css/two-column.css") %>
	</head>

	<body id="site-map">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="include/header.jsp" %>
				</div>
				<div id="nav">
					<%@ include file="include/nav_teacher.jsp" %>
				</div>
			</div>
			
			<div id="content">


<h1>Cosmic Site Map</h1>

<table border="0" id="main">
	<tr>
		<td>
			<div id="left">
				<h2>Teacher Pages</h2>
				<ul class="simple">
					<li><a href="teacher.jsp">Teacher Page</a></li>
					<li><a href="notes.jsp">Classroom Notes</a></li>
					<li><a href="strategy.jsp">Teaching Strategies</a></li>
					<li><a href="web_guide.jsp">Research Guidance</a></li>
					<li><a href="activities.jsp">Sample Classroom Activities</a></li>
					<li><a href="activities.jsp">Classroom Activities</a></li>
					<li><a href="strategy.jsp">Teaching Strategies</a></li>
					<li><a href="web_guide.jsp">Research Guidance</a></li>
					<li><a href="standards.jsp">Alignment with Standards</a></li>
					<li><a href="presurvey.jsp?type=pre&student_id=0">Pre</a>
					- and <a href="presurvey.jsp?type=post&student_id=0">Post</a> Tests.</li>
					<li>Student Results for <a href="surveyResults.jsp?type=pre">Pre</a>
					- and <a href="surveyResults.jsp?type=post">Post</a>- tests.</li>
					<li><a href="showTeachers.jsp">Show Student Test Results for all Teachers</a></li>
					<li><a href="registration.jsp">General Registration</a></li>
					<li><a href="registerStudents.jsp">Student Research Group Registration</a></li>
					<li><a href="updateGroups.jsp">Update Student Research Groups</a></li>
					<li><a href="site-map.jsp">Site Map</a></li>
				</ul>
				
			</div>
		</td>
		
		<td>
			<div id="center">
			</div>
		</td>
		<td>
			<div id="right">
				<h2>Student Pages</h2>
				<ul class="simple">
					<li><a href="<%= elab.page("home.jsp") %>">Home</a></li>
					<li><a href="site-index.jsp">Site Index</a></li>
				</ul>
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
