<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>

<%@ page import="gov.fnal.elab.util.ElabUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>e-Lab Site Index</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/site-index.css"/>
		<link rel="stylesheet" type="text/css" href="../css/one-column.css"/>
	</head>
		
	<body id="site-index" class="siteindex">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<div id="nav">
						<%@ include file="../include/nav.jsp" %>
						<div id="subnav">
							<%@ include file="../include/nav-site-index.jsp" %>
						</div>
					</div>
				</div>
			</div>

			<div id="content">

<h1>Lost? You can go to any of the pages on this site from this list.</h1>


<table border="0" id="main">
	<tr>
		<th><a href="../home">Home</a></th>
		<th><a href="../library">Library</a></th>
		<th><a href="../data/upload.jsp">Upload</a></th>
		<th><a href="../data">Data</a></th>
		<th><a href="../posters">Posters</a></th>
		<th><a href="../assessment">Assessment</a></th>
	</tr>
	<tr>
		<td>
			<ul>
				<li><a href="../home/first.jsp" >The Big Picture</a></li>
				<li><a href="../home/first-web.jsp" >The Website</a></li>
			</ul>
		</td>
		<td>
			<ul>
				<li>
					<a href="milestones_map.jsp">Study Guide</a> and 
					<a href="milestones.jsp"><strong>text version</strong></a>
					<ul>
						<li><a href="showReferences.jsp?t=reference&amp;f=peruse">View Resources for Study Guide</a></li>
						<li><a href="showReferences.jsp?t=glossary&amp;f=peruse">View Glossary</a></li>
					</ul>
				</li>
				<li><a href="resources.jsp" >Resources</a></li>
				<li>
					Online Links
					<ul>
						<li>
							Contacts
							<ul>
								<li><a href="students.jsp">Students</a></li>
							</ul>
						</li>
						<li>
							Tutorials
							<ul>
								<li><a href="dpstutorial.jsp">Performance Study Background</a></li>
								<li><a href="tryit_performance.jsp">Step-by-Step Instructions: Performance</a></li>
								<li><a href="ltimetutorial.jsp">Lifetime Study Background</a></li>
								<li><a href="tryit_performance.jsp">Step-by-Step Instructions: Lifetime</a></li>
								<li><a href="fluxtutorial.jsp">Flux Study Background</a></li>
								<li><a href="tryit_performance.jsp">Step-by-Step Instructions: Flux</a></li>
								<li><a href="eshtutorial.jsp">Shower Study Tutorial</a></li>
								<li><a href="tryit_shower.jsp">Step-by-Step Instructions: Shower</a></li>
								<li><a href="geoInstructions.jsp">Updating Geometry Tutorial</a></li>
							</ul>
						</li>
						<li>
							Animations
							<ul>
								<li><a href="flash/daq_only_standalone.html" >Classroom Cosmic Ray Detector</a></li>
								<li><a href="flash/daq_portal_rays.html" >Sending Data to Grid Portal</a></li>
								<li><a href="flash/analysis.html" >Analysis</a></li>
								<li><a href="flash/collaboration.html" >Collaboration</a></li>
								<li><a href="flash/SC2003.html" >Loop</a></li>
								<li><a href="flash/griphyn-animate_sc2003.html" >CMS vs. QuarkNet</a></li>
								<li><a href="flash/DAQII.html" >DAQII</a></li>
							</ul>
						</li>
					</ul>
				</li>
			</ul>
		</td>
		<td>
			<ul>
				<li><a href="upload.jsp">Upload Data</a></li>
				<li><a href="geo.jsp">Upload Geometry</a></li>
			</ul>
		</td>
		<td>
			<ul>
				<li>
					<strong>Analysis</strong>
					<ul>
						<li><a href="../analysis-performance">Performance Study</a></li>
						<li><a href="../analysis-lifetime">Lifetime Study</a></li>
						<li><a href="../analysis-flux">Flux Study</a></li>
						<li><a href="../analysis-shower">Shower  Study</a></li>
					</ul>
				</li>
				<li>
					<strong>View</strong>
					<ul>
						<li><a href="../analysis-show-data">Data Files</a></li>
						<li><a href="../plots/search.jsp">Plots</a></li>
						<li><a href="../posters/search.jsp">Posters</a></li>
					</ul>
				</li>
				<li>
					<strong>Delete</strong>
					<ul>
						<li><a href="search.jsp?t=split&amp;f=delete">Data Files</a></li>
						<li><a href="search.jsp?t=plot&amp;f=delete">Plots</a></li>
						<li><a href="search.jsp?t=poster&amp;f=delete">Posters</a></li>
					</ul>
				</li>
				<li>
					<a href="../plots/my-plots.jsp">View My Plots</a>
				</li>
			</ul>
		</td>
		<td>
			<ul>
				<li><a href="makePoster.jsp">New Poster</a></li>
				<li><a href="editPosters.jsp">Edit Posters</a></li>
				<li><a href="search.jsp?t=poster&amp;f=view">View Posters</a></li>
				<li><a href="search.jsp?t=poster&amp;f=delete">Delete Posters</a></li>
				<li><a href="../plots/my-plots.jsp">View My Plots</a></li>
			</ul>
		</td>
		<td>
		</td>
	</tr>
</table>


			</div>
<!-- end content -->	

			<div id="footer"> </div>
		</div>
		<!-- end container -->
</body>
</html>
