<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${user != null}">
	<link type="text/css" href="../css/nav-rollover.css" rel="Stylesheet" />
	<link type="text/css" href="../include/jquery/css/default/jquery-ui-1.7.custom.css" rel="Stylesheet" />	
	<script type="text/javascript" src="../include/jquery/js/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="../include/jquery/js/jquery-ui-1.7.custom.min.js"></script>

	<script type="text/javascript">
	$(document).ready(function() {
		$("#nav-home").mouseover(function(){ // Home
			$("#subnav").children().hide(); 
			$("#sub-home").show();
		});
		$("#nav-library").mouseover(function(){ // Library
			$("#subnav").children().hide();
			$("#sub-library").show(); 
		});
		$("#nav-data").mouseover(function(){ // Data
			$("#subnav").children().hide();
			$("#sub-data").show(); 
		});
		$("#nav-posters").mouseover(function(){ // Posters
			$("#subnav").children().hide();
			$("#sub-posters").show();
		});
		$("#nav-siteindex").mouseover(function(){ // Site Index
			$("#subnav").children().hide();
			$("#sub-siteindex").show();
		});
		$("#nav-assessment").mouseover(function(){ // Assessment
			$("#subnav").children().hide();
		});
	});
	</script>

	<div id="nav">
		<table>
			<tr>
				<td id="menu">
					<ul>
						<li><a href="../home" id="nav-home">Home</a></li>
						<li><a href="../library" id="nav-library">Library</a></li>
						<li><a href="../data" id="nav-data">Data</a></li>
						<li><a href="../posters" id="nav-posters">Posters</a></li>
						<li><a href="../site-index" id="nav-siteindex">Site Map</a></li>
						<li><a href="../assessment/index.jsp" id="nav-assessment">Assessment</a></li>
					</ul>
				</td>
			</tr>
			<tr>
				<td id="subnav">
					<ul id="sub-home">
						<li><a href="../home/cool-science.jsp">Cool Science</a></li>
						<li><a href="../site-index/site-map-anno.jsp">Explore!</a></li>
						<li><a href="../home/about-us.jsp">About Us</a></li>
					</ul>
					<ul id="sub-library">
						<li><a href="/library/kiwi.php/Category:LIGO">Glossary</a></li>
						<li><a href="../library/resources.jsp">Resources</a></li>
						<li><a href="../library/big-picture.jsp">Big Picture</a></li>
						<li><a href="../library/FAQ.jsp">FAQs</a></li>
						<li><a href="../library/site-tips.jsp">Site Tips</a></li>
					</ul>
					<ul id="sub-data">
						<li><a href="/ligo/tla/tutorial.php">Tutorial</a></li>
						<li><a href="/ligo/tla/">Bluestone</a></li>
						<li><a href="../plots/">Plots</a></li>
					</ul>
					<ul id="sub-posters"> 
						<li><a href="../posters/new.jsp">New Poster</a></li>
						<li><a href="../posters/edit.jsp">Edit Posters</a></li>
						<li><a href="../posters/view.jsp">View Posters</a></li>
						<li><a href="../posters/delete.jsp">Delete Poster</a></li>
						<c:choose>
							<c:when test="${user != null}">
								<li><a href="../plots?submit=true&key=group&value=${user.name}&uploaded=true">View Plots</a></li>
							</c:when>
							<c:otherwise>
								<li><a href="../plots">View Plots</a></li>
							</c:otherwise>
						</c:choose>
						<li><a href="../jsp/uploadImage.jsp">Upload Image</a></li>
					</ul>
					<ul id="sub-siteindex">
						<li><a href="../site-index/site-map-anno.jsp">Site Index</a></li>	
						<li><a href="../site-index/site-map-anno.jsp">Explore!</a></li>
					</ul>
				</td>
			</tr>
		</table>
	</div>
</c:if>