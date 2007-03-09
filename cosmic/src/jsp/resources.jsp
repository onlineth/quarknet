
<%@ page import="java.util.*" %>
<HTML>
<HEAD>
<TITLE>Resources</TITLE>
<%@ include file="include/javascript.jsp" %>

<!-- include css style file -->
<%@ include file="include/style.css" %>

<!-- header/navigation -->
<%
//be sure to set this before including the navbar
String headerType = "Library";
%>
<%@ include file="include/navbar_common.jsp" %>
<BR>
<TABLE WIDTH=794 CELLPADDING=4>
<TR><TD class="library_header">
Looking for information? Check out the online resources or contact someone.
</TD></TR>
</TABLE>
<P>
<TABLE WIDTH=786>
<TR>
    <TD VALIGN=TOP> <TABLE CELLPADDING=0 CELLSPACING=0 BGCOLOR=CCFFFF VALIGN=TOP>
        <TR>
          <TD WIDTH=388> <img src="graphics/tab_tutorials.gif"> <font size=-1 face=arial> 
            <P STYLE="margin-left: 10px"> <A HREF="javascript:openPopup('tryit_performance.html','TryIt',520,600)">Step-by-Step 
              Instructions</A> and <A HREF="dpstutorial.jsp" class="table">Performance 
              Study Background</A> - Understand how to do and interpret the output 
              of the Performance Study. 
            <P STYLE="margin-left: 10px"> <A HREF="javascript:openPopup('tryit_lifetime.html','TryIt',520,600)">Step-by-Step 
              Instructions</A> and  <A HREF="ltimetutorial.jsp" class="table">Lifetime 
              Study Background</A> - Discover how to read a Lifetime Study graph. 
            <P STYLE="margin-left: 10px"> <A HREF="javascript:openPopup('tryit_flux.html','TryIt',520,600)">Step-by-Step 
              Instructions</A> and <A HREF="fluxtutorial.jsp" class="table">Flux 
              Study Background</A> - Learn how to understand the results of a Flux 
              Study. 
            <P STYLE="margin-left: 10px"><A HREF="javascript:openPopup('tryit_shower.html','TryIt',520,600)">Step-by-Step 
              Instructions</A> and  <A HREF="eshtutorial.jsp" class="table">Shower 
              Study Tutorial</a> - Discover how to tell if you have seen a shower. 
<%
            if(session.getAttribute("role").equals("upload")){
%>
            <P STYLE="margin-left: 10px"><A HREF="geoInstructions.jsp">Updating Geometry Tutorial</A> - Learn how to properly 
              input the layout of your detector.
<%
            }
%>
            <P>&nbsp; </font></td>
        </tr>
      </table> 
      <br>
      <TABLE  CELLPADDING=0 CELLSPACING=0 BGCOLOR=CCFFFF VALIGN=TOP>
<TR><TD WIDTH=388>
<IMG SRC="graphics/tab_online.gif">

<FONT FACE=ARIAL size=-1>

<P STYLE="margin-left: 10px">
<B>Student-Friendly Sites</B>

<P STYLE="margin-left: 20px">
<A HREF="http://hires.phys.columbia.edu/papers/CosmicExtremes.pdf" class="table">Cosmic Extremes</A> - Excellent cosmic ray overview available to print (pdf file)
<P STYLE="margin-left: 10px">

<P STYLE="margin-left: 20px">
<A HREF="http://www2.slac.stanford.edu/vvc/cosmic_rays.html" class="table">Cosmic Rays</A> - SLAC's cosmic ray site
<P STYLE="margin-left: 10px">

<P STYLE="margin-left: 20px">
<A HREF="http://www.auger.org/" class="table">Pierre Auger Observatory</A> - Background and Q&A about cosmic rays

<B>Online Labs</B>
<P STYLE="margin-left: 20px">
<A HREF="http://outreach.physics.utah.edu/javalabs/java102/hess/index.htm" class="table">ASPIRE</A> - Investigations into the origin of cosmic rays
<P STYLE="margin-left: 10px">
<B>Professional Sites (Very Advanced)</B>
<P STYLE="margin-left: 20px">
<A HREF="http://ik1au1.fzk.de/~heck/corsika/" class="table">CORSIKA</A> - An air shower simulation program
<P STYLE="margin-left: 20px">
<A HREF="http://wwwasd.web.cern.ch/wwwasd/geant4/geant4.html" class="table">GEANT4</A> - A toolkit for simulating the passage of particles through matter
<P>
<P STYLE="margin-left: 20px">
<A HREF="http://scipp.ucsc.edu/milagro/Animations/AnimationIntro.html" class="table">Milagro Animations</A> - QuickTime movies of simulated HEP events. Most movies run under 5 megabytes and are about 15 seconds long.
<P STYLE="margin-left: 20px">
<A HREF="http://www.wired.com/wired/archive/12.04/grid.html?tw=wn_tophead_6" class="table"><P STYLE="margin-left: 20px">
<A HREF="http://gridcafe.web.cern.ch/gridcafe/" class="table">The Grid Cafe</A> - An introduction to the grid.
</A> - Wired Magazine discusses the grid and particle physics at CERN, Fermilab's sister laboratory in Geneva, Switzerland.
<P STYLE="margin-left: 20px">
<A HREF="http://www.wired.com/wired/archive/12.04/grid.html?tw=wn_tophead_6" class="table">The God Particle and the Grid.</A> - Wired Magazine discusses the grid and particle physics at CERN, Fermilab's sister laboratory in Geneva, Switzerland.

<P>&nbsp;
</TD></TR>
</TABLE> 


</TD>
<td width="8">&nbsp;</td>
<TD VALIGN=TOP>

<TABLE  CELLPADDING=0 CELLSPACING=0 BGCOLOR=CCFFFF VALIGN=TOP>
<TR><TD WIDTH=388>
<IMG SRC="graphics/tab_contacts.gif">

<FONT FACE=ARIAL size=-1>
<P STYLE="margin-left: 10px">
<B>Physicists</B></A>
<P STYLE="margin-left: 20px">
<a href="mailto:glass@fnal.gov" class="table">Henry Glass</a> - Fermilab / Auger<br>
<a href="mailto:barnett@lbl.gov" class="table">Michael Barnett</a> - Berkeley Lab<br>
<a href="mailto:jordant@fnal.gov" class="table">Tom Jordan</a> - University of Florida<br>
<a href="mailto:randal.c.ruchti.1@nd.edu" class="table">Randy Ruchti</a> - Notre Dame University<br>
<P STYLE="margin-left: 10px">
<A HREF="students.jsp" class="table"><B>Student Research Groups</B></A>
<P>&nbsp;
</TABLE>
<P>
<TABLE CELLPADDING=0 CELLSPACING=0 BGCOLOR=CCFFFF VALIGN=TOP>
<TR><TD WIDTH=388>
<img src="graphics/tab_animations.gif">

<P STYLE="margin-left: 10px">
<font size=-1 face=arial>
<P STYLE="margin-left: 10px">
<A HREF="flash/daq_only_standalone.html" class="table">Classroom Cosmic Ray Detector</A> - Equipment at each school to collect data.
<P STYLE="margin-left: 10px">
<A HREF="flash/daq_portal_rays.html" class="table">Send Data to Grid Portal</A> - Data collected at schools is sent to grid portal.
<P STYLE="margin-left: 10px">
<A HREF="flash/analysis.html" class="table">Analysis</A> - Counter Performance study activates grid portal.
<P STYLE="margin-left: 10px">
<A HREF="flash/collaboration.html" class="table">Collaboration</a> - How Students collaborate.
<P STYLE="margin-left: 10px">
<A HREF="flash/SC2003.html" class="table">Loop</A> - Loop through the previous three for presentation.
<P STYLE="margin-left: 10px">
<A HREF="flash/griphyn-animate_sc2003.html" class="table">QuarkNet vs.CMS</A> - Comparing use of Grid in QuarkNet with the CMS experiment 
<P STYLE="margin-left: 10px">
<A HREF="flash/DAQII.html" class="table">DAQII</A> - How the DAQII board works. <b>Has SOUND.</b>
<P>&nbsp;
</td></tr></table>
</td></tr></table>  

<hr>
</CENTER>
</BODY>
</HTML>


