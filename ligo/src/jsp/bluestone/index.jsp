<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=8" >
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Super-Bluestone</title>
		<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="../include/excanvas.min.js"></script><![endif]-->
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/data.css"/>
		<link rel="stylesheet" type="text/css" href="../css/two-column.css"/>
		<script type="text/javascript" src="../include/elab.js"></script>

		<style type="text/css">
			span.dataName {
				font-size: x-small;
			}
			span.rotate-text-left {
				position: absolute;
				width: 0px;
				-webkit-transform: rotate(-90deg); 
				-moz-transform: rotate(-90deg);	
				filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
			}
			td#yAxisLabeltd {
				width: 20px;
			}
		</style>
	</head>
    
    <body id="super-bluestone" class="data">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<%@ include file="../include/nav-rollover.jspf" %>
				</div>
			</div>
			
			<div id="content">
				<noscript><b>This page requires Javascript</b><br /><br /></noscript>
				<%-- Scripts need to be loaded after nav-rollover since that is where the js pages live --%>
				<script language="javascript" type="text/javascript" src="../include/jquery/flot/jquery.flot.min.js"></script>				
				<script language="javascript" type="text/javascript" src="../include/jquery/flot/jquery.flot.min.js"></script>
			    <script language="javascript" type="text/javascript" src="../include/jquery/flot/jquery.flot.selection.min.js"></script>
			    <script src="general.js" type="text/javascript"></script> <%-- General common stuff --%>
			    <script src="advanced.js" type="text/javascript"></script> <%-- Advanced Mode --%>
				
				<div style="text-align:right">Need help? Try the <e:popup href="../library/ref-analysis.jsp" target="help" width="450" height="600" toolbar="true">Practice Plots</e:popup> or watch a <e:popup href="../video/intro-bluestone.html" target="tryit" width="800" height="659">Video</e:popup>.</div>
				<br />
				
				<table id="plot-table">
					<tr>
						<td>
							Start Time<br/>
							<input readonly type="text" name="xmin" id="xmin" size="15" class="datepicker"></input>
						</td>
						<td class="right-aligned">
							End Time<br/>
							<input readonly type="text" name="xmax" id="xmax" size="15" class="datepicker"></input>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<table id="plot">
									<tr>
									  <td id="yAxisLabeltd"><span id="yAxisLabel">&nbsp;</span></td>
									</tr>
								<tr>
									<td width="850">
										<div id="resizablecontainer" style="margin-bottom: 10px; margin-right: 10px;" >
											<div id="chart" style="width:100%; height:250px; text-align: left;"></div>
										</div>
									</td>
								</tr>
								<tr>
									<td align="center"><span id="xAxisLabel">Date/Time (GMT)</span></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<%-- <button id="plotButtonTop" class="plotButton" value="Plot">Plot</button> --%>
				<img src="../graphics/spinner-small.gif" id="busySpinner" style="visibility: hidden"></img>
				<table class="toolbox">
					<tr>
						<th>X Axis</th>
						<td class="toolbox-content">
							<button title="Zoom to selection" id="buttonZoom" disabled>Zoom to selection</button>
							<button title="Zoom all the way out" id="buttonZoomOut" disabled>Zoom all the way out</button>
						</td>
					</tr>
					<tr>
						<th>Y Axis</th>
						<td class="toolbox-content">
							<input type="checkbox" name="log" value="y-axis" id="logYcheckbox" class="logCheckbox" />Log Scale
							<span class="toolbox-separator"></span>
							<span class="toolbox-label">Range:</span>
							<input type="text" size="10" id="yRangeMin" disabled="true"/> - <input type="text" size="10" id="yRangeMax" disabled="true"/> 
							<input type="checkbox" name="yAutoRange" id="yAutoRangeCheckbox" checked="true"/>Auto
						</td>
					</tr>
				</table>
				
				
				
					
					<%-- Temporarily disabled while I figure out how to properly resize the bar - pxn
					<div id="slider"></div>
					--%>
								
				<br />
				
				<%-- <input class="commandLine" type="text" size="100" style="width:300px;"></input> 
				<input class="parseCommandLine" type="button" value="Execute Command"></input>
				<input class="fetchData" type="button" value="Get Test Data!"></input>  --%>
				
				<%-- Super basic demo mode stuff for testing / showing-off
				
				<div id="channel_list">
					<select name="channel" id="channelSelector"> 
						<option value="placeholder">Select a channel: </option>
						<option value="L0:PEM-LVEA_SEISX.mean">Livingston X-Axis Vault Seismometer</option>
						<option value="L0:PEM-LVEA_SEISY.mean">Livingston Y-Axis Vault Seismometer</option>
						<option value="L0:PEM-LVEA_SEISZ.mean">Livingston Z-Axis Vault Seismometer</option>
						<option value="H0:PEM-LVEA_SEISX.mean">Hanford X-Axis Vault Seismometer</option>
						<option value="H0:PEM-LVEA_SEISY.mean">Hanford Y-Axis Vault Seismometer</option>
						<option value="H0:PEM-LVEA_SEISZ.mean">Hanford Z-Axis Vault Seismometer</option>
					</select>
					<input id="parseDropDown" type="button" value="Plot"></input>
				</div>
				
				--%>
				
				<%-- Advanced Mode --%>				
				<h2>Data Selection<a href="#" onclick="javascript:glossary('data_selection',500);return false;" style="text-decoration: none;"><sup>?</sup></a></h2>				
				<div id="channel-list-advanced">
					<table id="channelTable" class="toolbox">
						<thead>
							<tr class="toolbox-row">
								<th>Add/Remove</th>
								<th>Site<a href="#" onclick="javascript:glossary('data_channel_source',500);return false;" style="text-decoration: none;"><sup>?</sup></a></th>
								<th>Subsystem<a href="#" onclick="javascript:glossary('data_channel_subsystem',500);return false;" style="text-decoration: none;"><sup>?</sup></a></th>												
								<th>Station<a href="#" onclick="javascript:glossary('data_channel_station',500);return false;" style="text-decoration: none;"><sup>?</sup></a></th>												
								<th>Sensor<a href="#" onclick="javascript:glossary('data_channel_sensor',500);return false;" style="text-decoration: none;"><sup>?</sup></a></th>												
								<th>Sampling<a href="#" onclick="javascript:glossary('data_channel_sampling',500);return false;" style="text-decoration: none;"><sup>?</sup></a></th>												
								<th>Data Filename</th>
							</tr>
						</thead>
						<tbody>
							<tr id="row_0" class="toolbox-row">
								<td>
									<button id="removeRow_0" class="removeRow"><img src="../graphics/minus.png"/></button>
								</td>
								<td>
									<select name="site" id="site_0" class="site">
										<option value="H0">H0</option>
										<option value="L0">L0</option>
									</select>
								</td>
								<td>
									<select name="subsystem" id="subsystem_0" class="subsystem">
										<option value="DMT-BRMS_PEM_">DMT</option>
										<option value="PEM-">PEM</option>
										<option value="GDS-">GDS</option>
									</select>
								</td>
								<td>
									<select name="station" id="station_0" class="station"></select>
								</td>
								<td>
									<select name="sensor" id="sensor_0" class="sensor"></select>
								</td>
								<td>
									<select name="sampling" id="sampling_0" class="sampling"></select>
								</td>
								<td>
									<span id="dataName_0" class="dataName"></span>
								</td>
							</tr>
							<tr>
								<td colspan="7">
									<button id="addNewRow" value="Add Data Row"><img src="../graphics/plus.png"/></button>
								</td>
							</tr>
						</tbody>
					</table>
					
				</div>
				<table>
					<tr>
						<td><button id="plotButtonBottom" class="plotButton" value="Plot">Plot</button></td>
						<td><div id="messages" name="messages"></div></td>
					</tr>
				</table>
				<% if (!user.isGuest())  { %>
				<h2>Data Export</h2>
				
				<table class="toolbox">
					<tr>
						<td class="toolbox-content">
							<input id="savePlotToDisk" type="button" value="Save Plot"></input>
							<input id="exportData" type="button" value="Export Data Points"></input>
						</td>
						<td class="toolbox-content">
							<a href="#" target="_new" id="savedPlotLink" style="display: none;">View saved plot (popup)</a>
						</td>
					</tr>
				</table>
				
				<div id="save-dialog" class="dialog-window">
					<div class="dialog-title">
						Save Plot
					</div>
					<div class="dialog-contents">
						<label for="userPlotTitle">Plot title:</label>
						<input id="userPlotTitle" name="title" type="text" maxlength="200" size="30"></input>
						<br/>
						<img src="../graphics/spinner-small.gif" style="visibility: hidden;" id="busySpinnerSmall"></img>
					</div>
					<div class="dialog-buttons">
						<input id="savePlotToDiskCancel" type="button" value="Cancel"></input>
						<input id="savePlotToDiskCommit" type="button" value="Save" disabled="true"></input>
					</div>
				</div>
			<% } %>
			</div>

			<div id="footer">
				<%@ include file="../include/nav-footer.jsp" %>
			</div>
		</div>
	</body>

</html>
