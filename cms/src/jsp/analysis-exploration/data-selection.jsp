<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ page errorPage="../include/errorpage.jsp" buffer="none" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>

<%@ include file="../data/jump.jspf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Data Selection - Detector Exploration Studies</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/data.css"/>
		<link rel="stylesheet" type="text/css" href="../css/one-column.css"/>
		<link rel="stylesheet" type="text/css" href="../css/analysis.css"/>
		<script type="text/javascript" src="../include/elab.js"></script>
		<link href="../include/jeegoocontext/skins/cm_blue/style.css" rel="Stylesheet" type="text/css" />
	</head>
	
	<body class="data" onload="initializeFromExpr();">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<%@ include file="../include/nav-rollover.jspf" %>
				</div>
			</div>
			<script type="text/javascript" src="../include/jeegoocontext/jquery.jeegoocontext.min.js"></script>	
			<div id="content">
<a class="help-icon" href="#" onclick="openPopup(event, 'help')">Help <img src="../graphics/help.png" /></a>
<h1>Data Selection - Detector Exploration Studies</h1>
<script>
	initlog();
	log("<span class='red'>dataset: ${param.dataset}</span>");
	log("<span class='red'>runs: ${param.runs}</span>");
	log("<span class='red'>expr: ${param.expr}</span>");
	log("<span class='red'>plots: ${param.plots}</span>");
	log("<span class='red'>commbine: ${param.combine}</span>");
</script>

<form action="../analysis-exploration/plot-params.jsp">
	<e:trinput type="hidden" name="dataset" id="dataset-input"/>
	<e:trinput type="hidden" name="plots"/>
	<e:trinput type="hidden" name="combine"/>
	<e:trinput type="hidden" name="analysisName" default="Detector Exploration Studies"/>
	<e:trinput type="hidden" name="analysis" default="exploration"/>
	<table border="0" id="main">
		<tr>
			<td>
				<div id="simple-form">
					<select id="simplified-triggers">
						<option value="none">Choose event type...</option>
						<option value="uu">Muons</option>
						<option value="ee">Electrons</option>
						<option value="uu or ee">Muons or Electrons</option>
						<option id="advanced" value="advanced">Advanced</option>	
					</select>
					<script>
						function updateTriggers(obj) {
							var expr = $('select option:selected').attr('value');
							if (expr == "advanced") {
								vSwitchShow("selected-events-panel");
								vSwitchShow("data-selection-panel");	
							}
							else if (expr == "none") {
								clearRunList();
								clearExpr();
								$("#plot-params-button").attr("disabled", true);
							}
							else {
								updateFromSimpleExpr(expr);
							}
						}

						updatingStarted = function() {
							log("Updating started");
							$("#plot-params-button").attr("disabled", true);
							spinnerOn(".wait-on-runs");
						}

						updatingDone = function() {
							log("Updating done");
							spinnerOff(".wait-on-runs");
						}

						exprInvalid = function() {
							$("#plot-params-button").attr("disabled", true);
						}
						
						$('#simplified-triggers').change(updateTriggers);
					</script>
				</div>
				
				<table id="step-buttons" border="0" width="100%">
					<tr>
						<td width="100%">
						</td>
						<td>
							<div class="wait-on-runs">
								<input id="plot-params-button" type="submit" value="Plot Selection &rarr;" />
							</div>
						</td>
					</tr>
				</table>
				
				<e:vswitch id="selected-events-panel" title="Run Selection" titleclass="panel-title">
					<e:visible image="../graphics/plus.png">
					</e:visible>
					<e:hidden image="../graphics/minus.png">
						<div class="wait-on-runs">
							<div id="runs-header">
								<input type="checkbox" id="select-all" checked="checked" onchange="selectAll();"/>All
								<e:trinput type="hidden" name="runs" id="runs-input" />
							</div>
							<div id="runlist">
							</div>
							<div id="totals">
							</div>
						</div>
					</e:hidden>
				</e:vswitch>
				<e:vswitch id="data-selection-panel" title="Advanced Data Selection" titleclass="panel-title">
					<e:visible image="../graphics/plus.png">
					</e:visible>
					<e:hidden image="../graphics/minus.png">
						<jsp:include page="../data/triggers.jsp">
							<jsp:param name="dataset" value="${param.dataset}"/>
						</jsp:include>
					</e:hidden>
				</e:vswitch>
				
			</td>
		</tr>
	</table>
</form>

<div id="help" class="help">
	<table>
		<tr>
			<td class="title">Data Selection Help<a href="#" onclick="closeHelp('help');"><img src="../graphics/close.png" /></a></td>
		</tr>
		<tr>
			<td class="content">
				<p>Need help with data selection? Try these links:</p>
				<ul>
<%-- 
					<li>
						<e:popup href="../library/ref-studies.jsp" target="tryit" width="520" height="600">Calibration Studies Background</e:popup>
					</li>
--%>

<li>
						<e:popup href="../video/demos-exploration.html?video=data-selection" target="tryit" width="800" height="800">Screencast Demo</e:popup>
 - how to select data.
					</li>
<%-- 
					<li>
						<a href="javascript:reference('cms data selection',450)">Milestone</a> associated with data selection.
					</li>
--%>
					<li><a href="javascript:showRefLink('../library/FAQ.jsp',700,700)">FAQs</a>
					</li>
				</ul>
			</td>
		</tr>
		<tr>
			<td align="right"><button name="close" onclick="closePopup('help');">Close</button></td>
		</tr>
	</table>
</div>

			</div>
			<!-- end content -->	
		
			<div id="footer">
			</div>
		</div>
		<!-- end container -->
	</body>
</html>
