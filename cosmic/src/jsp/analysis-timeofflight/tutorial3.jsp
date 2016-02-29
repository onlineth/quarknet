<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ page errorPage="../include/errorpage.jsp" buffer="none" %>
<%@ include file="../include/elab.jsp" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Time of Flight study tutorial</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/data.css"/>
		<link rel="stylesheet" type="text/css" href="../css/one-column-wide.css"/>
		<script type="text/javascript" src="../include/elab.js"></script>
	</head>
	
	<body id="shower-tutorial" class="data, tutorial">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<%@ include file="../include/nav-rollover.jspf" %>
				</div>
			</div>
			
			<div id="content">

<p>
<center>
<p>
<p>	
	
	<table width="655">
		<tr>
							<td colspan = 3>
								<center>
									<font color="#0a5ca6" size=+3>
										<b>
	 										Muon Speed Using Time of Flight - Advanced Studies (3)
	 									</b>
	 								</font>
	 							</center>
	 						</td>
	 					</tr><tr>
 			<td colspan=3>
				
				<p>1.  Use time of flight to distinguish one-muon signals from two-muon background.<br>
				
				a.)  Set up the following configuration to measure muons coming in at an angle.   <br></br>
				<img src="../graphics/tryPerf/ToF_2_counters_14A.png"/> 
				<img src="../graphics/tryPerf/TOF_4-1_-650cm_14_all_4dec.png"/><br></br>
				
				b.)  Set up the configuration above with counter 2 between 1 and 4. <br></br>
				<img src="../graphics/tryPerf/ToF_3_counters_124A.png"/> 
				<img src="../graphics/tryPerf/TOF_4-1_-650cm_142_all_4dec.tiff"/><br></br>
				As you can see from the graph, the addition of counter 2 does not make much difference.  We hoped that the two-muon peak would
				be reduced, but we've also lost some one-muon events.  So, perhaps counter 2 was not well aligned.<br></br>
				
				c.)  Reverse the setup in b.) (reverse counters 1 and 4).   <br></br>
				<img src="../graphics/tryPerf/ToF_3_counters_421A.png"/> 
				<img src="../graphics/tryPerf/TOF_4-1_650cm_14_all_3dec.tiff"/><br></br>
				Notice that this graph is basically the mirror image of the graph in b.).<br></br>
				</p>
				
				
				<p>2.  The following series will use counter 2 in a different position.
				a.)  We shall start with a basic setup of just counters 1 and 4.   <br>
				<img src="../graphics/tryPerf/ToF_2_counters_14A.png"/> 
				<img src="../graphics/tryPerf/TOF_4-1_-630cm_14_16dec.tiff"/>
				
				<br></br>
				
				b.)  The following configuration will also measure muons coming in at an angle.  We include counter 2 (veto) below counter 4.  
				Note that the two-muon peak has been reduced.<br></br>
				<img src="../graphics/tryPerf/ToF_3_counters_14AVeto.png"/> 
				<img src="../graphics/tryPerf/TOF_4-1_-630cm_14v2_16dec.png"/><br></br>

				c.)  If we require all three counters, a single muon cannot satisfy the trigger.  
				We see that the two-muon peak is greatly enhanced.<br></br>
				<img src="../graphics/tryPerf/ToF_3_counters_14ARequired.png"/> 
				<img src="../graphics/tryPerf/TOF_4-1_-630cm_142_16dec.tiff"/>				
				</p>
				
				
			</td>
		</tr>
				
		<tr>
			<td width=5>&nbsp;</td>					
			<td valign="top" width=322>
				&nbsp<p>
				&nbsp<p>
				
			</td>
		</tr>
				
		<tr>
			<td colspan=3>
				<p align=center> Tutorial Pages: <a href="tutorial.jsp">1</a> <a href="tutorial2.jsp">2</a> <b>3</b> <a href="tutorial4.jsp">4</a> & <a href="index.jsp">Analysis</a></p>				
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

