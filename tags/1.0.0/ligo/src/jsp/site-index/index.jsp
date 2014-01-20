<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>
<%@ page import="gov.fnal.elab.util.ElabUtil" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Site Help</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/site-index.css"/>
		<link rel="stylesheet" type="text/css" href="../css/one-column.css"/>
	</head>
		
	<body id="site-index" class="site-index">
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

<table border="0" id="main">
	<tr>
		<td id="left">
			<%@ include file="../include/left-alt.jsp" %>
		</td>
		<td id="center">
			<h2>Getting Started on the LIGO I2U2 E-Lab</h2>
			<p>
				<em>The E-Lab process</em> follows three basic steps. The E-Lab road map 
				that you'll see when you click 
				<a href="../library/milestones-map.jsp">Study Guide</a> (on the 
				<a href="../library">Library</a> submenu) shows you the steps.
			</p>
			<p>
				<em>Step 1: Get Started</em> Review and refresh some of your basic science 
				skills. Practice using <a href="http://tekoa.ligo-wa.caltech.edu/tla" 
				target="blank">Bluestone</a> to make graphs of real seismometer data.
			</p>
			<p>
				<em>Step 2: Figure It Out</em> Make your research question. Use Bluestone 
				to plot LIGO seismometer data. You will test and improve your ideas (your 
				hypothesis) by making more plots and by looking at other sources of data. 
				You will share your ideas with classmates and with your teacher. 
				Eventually your research will lead you to an answer to your research 
				question.  It's the scientific method at work!
			</p>
			<p>
				<em>Step 3: Tell Others</em> Build an online poster and use it to discuss 
				your research and your conclusions with your classmates and others.
			</p>
			<p>
				<em>Use</em><font class=content_text> the link menus to help you! The top 
				link menu provides guidance for accomplishing the E-Lab. The sidebar 
				links give you additional science resources, a Bluestone tutorial, a 
				Bluestone link and Discussion Site links.
			</p>
			<p>
				<em>Watch</em><font class=content_text> for little icons on the E-Lab 
				screens. Clicking on <img src="../graphics/ref.gif" /> will give you a 
				reference popup that will help with a milestone.  The logbook icon, 
				<img src="../graphics/logbook_pencil.gif" align="middle" />, will open 
				your electronic log book. The looking glass, 
				<img src="../graphics/logbook_view_comments_small.gif" align="middle" />, 
				lets you access teacher comments about your log entries.
			</p>
			<p>
				<em>The heart</em><font class=content_text> of the LIGO E-Lab is software
				 named <a href="http://tekoa.ligo-wa.caltech.edu/tla">Bluestone</a>. 
				 Bluestone lets you to select the LIGO data channels that you wish to 
				 view and lets you control the features of the plots that you make.
				 Bluestone mimics software that LIGO scientists and engineers use at the 
				 Observatory sites.  Your teacher will tell you how to log in.
			</p> 
			<p>
				<em>Another</em> key feature of the LIGO E-Lab is a 
				<a href="http://i2u2.spy-hill.net/">discussion room</a> Web site. Here you
				will find a <a href="http://i2u2.spy-hill.net/glossary/index.php/I2U2_Glossary">glossary</a>, 
				discussion rooms in which you can share research ideas with others and a 
				WIKI that contains research information. Your teacher will tell you how to 
				log in.
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