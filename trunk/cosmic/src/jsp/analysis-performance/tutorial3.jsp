<html>
<head>
	<title>Teacher Counter Performance Study</title>
    
    <!-- include css style file -->
    <%@ include file="include/style.css" %>
    <!-- header/navigation -->
    <%
    //be sure to set this before including the navbar
    String headerType = "Library";
    %>
    <%@ include file="include/navbar_common.jsp" %>
    
	<p>

	<font color="#0a5ca6" size=+3><b> Detector Performance Study</b></font>
	<p>
	
		<center>
			<table width=650>
				<tr>
					<td valign=top>
						This study aims to understand the quality of the collected data. One tool for this is a histogram of the number of events with a particular length of Time over Threshold (ToT).<p>

						In a very loose sense, ToT is a measure of the amount of energy deposited in the <a HREF="javascript:glossary('scintillator',350)">scintillator</a> for a given <a HREF="javascript:glossary('muon',100)">muon </a>passage. There is a correlation between the<a HREF="javascript:glossary('pulse_width',350)"> width of the pulse</a> in time and the height of the pulse. A well calibrated<a HREF="javascript:glossary('counter',350)"> counter</a> shows a good Gaussian distribution of ToT.<p>

						This particular graph shows a very noisy counter with a large peak centered at 3 ns. This peak is so large that the Gaussian that may be centered near 8 ns is obscured.
					</td>
				
					<td valign=top>
						<img src="graphics/Ballard3.gif" alt="">
					</td>
				</tr>
			
				<tr>
					<td align=right>
						Go back to the <a href="search.jsp?t=split&amp;f=analyze&amp;s=performance">analysis</a>
					</td>
					
					<td>
						&nbsp
					</td>
				</tr>
			</table>
		</center>			
	</body>
</html>
