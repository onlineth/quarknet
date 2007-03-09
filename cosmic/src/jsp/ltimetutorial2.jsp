<html>
	<head>
		<title>
			Tutorial Lifetime Study
		</title>
		<%@ include file="include/javascript.jsp" %>

        <!-- include css style file -->
        <%@ include file="include/styletut.css" %>
        <!-- header/navigation -->
        <%
        //be sure to set this before including the navbar
        String headerType = "Library";
        %>
        <%@ include file="include/navbar_common.jsp" %>
		<p>

		<font color="#0a5ca6" size=+3>
			<b>
				Lifetime Study
			</b>
		</font>
<p>
			<center>
			
			<table width = 650 cellpadding =8>
				<tr>
					<td width = 321 valign=top>
		 				Cosmic ray <a HREF="javascript:glossary('muon',100)">muons</a> reach the detector with varying amounts of energy each depositing energy in the <a HREF="javascript:glossary('counter',350)">counter</a>. Some are trapped in the counter and eventually <a HREF="javascript:glossary('decay',350)">decay</a> into an electron, a neutrino and an anti-neutrino.
					</td>
					
					<td width = 321 valign=top>
					These three particles zoom away (to conserve the momentum of the stopped muon). The moving electron creates <a HREF="javascript:glossary('scintillation_light',100)">scintillation light</a> in the counter. Our <a HREF="javascript:glossary('photomultiplier_tube',100)">photomultiplier</a> (PMT) can see this light.
					</td>
				</tr>
				
				<tr>
					<td colspan=2 valign=top align = center>

<img src="graphics/decay.gif" alt="" width="508" height="220" align="middle">						
					</td>
				</tr>
				
				<tr>
					<td colspan =2>
							
					</td>
				</tr>
				
				<tr>
					<td width = 321 valign=top>
						Once the PMT "sees" the electron, we know the amount of time between the muon stopping and decaying. The node that asks "Any Decays" looks for a light signal from one counter (the incoming muon) and then waits. 
					</td>
					
					<td width = 321 valign = top>
						If we see more light within the same counter before the gate closes, we may have a decay! There is one unresolvable problem with this method. . .
					</td>
				</tr>
							
				<tr>
					<td colspan=2 align="right">
						Want to <a href="ltimetutorial3.jsp">know more?</a>
					</td>
				</tr>
			</table>
			<p>
		</center>
	</body>
</html>

