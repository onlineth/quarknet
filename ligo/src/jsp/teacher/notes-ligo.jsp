<%@ include file="../include/elab.jsp" %>
<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title> LIGO e-Lab Notes</title>
		<link rel="stylesheet" type="text/css" href="../../cosmic/css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../../cosmic/css/teacher.css"/>
		<link rel="stylesheet" type="text/css" href="../css/teacher.css"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	</head>

	<body id="community">
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
<h1>Classroom Notes: Learn studies you can do with LIGO data in your classroom.</h1>   
 
<e:transclude
 url="http://${elab.properties['elab.host']}/cosmic/library/body.php?title=LIGO_Classroom_Notes"
     start="<!-- start content -->"
     end="<div class=\"printfooter\">"
/>
			</div>
			<!-- end content -->

			<div id="footer">

			</div>
		
		</div>
		<!-- end page container -->
	</body>
</html>
