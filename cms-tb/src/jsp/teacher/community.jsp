<%@ include file="../include/elab.jsp" %>
<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title> CMS Test Beam e-Lab Teacher Community</title>
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
<h1>Community: Learn how to do CMS Test Beam studies in your classroom.</h1>   
<!-- transcluded from http://${elab.properties['elab.host']}/elab/cosmic/teacher/library/body.php?title=Cosmic_Rays_Teaching_Community" -->
<e:transclude
 url="http://${elab.properties['elab.host']}/elab/cms-tb/teacher/library/body.php?title=CMS_e-Lab_Teacher_Community"
     start="<!-- start content -->"
     end="<div class=\"printfooter\">"
/>

			</div>
			<!-- end content -->

			<div id="footer">

			</div>
		
		</div>
		<!-- end container -->
	</body>
</html>
