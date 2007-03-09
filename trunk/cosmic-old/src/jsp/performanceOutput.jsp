<%@ page buffer="1000kb" %>
<%@ page import="org.griphyn.vdl.toolkit.VizDAX" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.batik.transcoder.image.PNGTranscoder" %>
<%@ page import="org.apache.batik.transcoder.TranscoderInput" %>
<%@ page import="org.apache.batik.transcoder.TranscoderOutput" %>
<%@ page import="gov.fnal.elab.vds.*" %>
<%@ page import="gov.fnal.elab.cosmic.beans.*" %>
<%@ page import="gov.fnal.elab.util.*" %>
<%@ page import="gov.fnal.elab.beans.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="common.jsp" %>
<%@ include file="include/javascript.jsp" %>

<html>
<head>
<title>Performance Study Analysis Results</title>
<!-- header/navigation -->
<%
//be sure to set this before including the navbar
String headerType = "Data";
%>
<%@ include file="include/navbar_common.jsp" %>
<body>

<jsp:useBean id="performance" scope="session" class="gov.fnal.elab.cosmic.beans.PerformanceBean" />
<%
//replace new lines from any text boxes with "\n"
String caption = performance.getPlot_caption();
caption = caption.replaceAll("\r\n?", "\\\\n");
performance.setPlot_caption(caption);
%>

<%

ElabTransformation et = new ElabTransformation("Quarknet.Cosmic::PerformanceStudy");

runDir = runDir.substring(0, runDir.length()-1);    //FIXME: runDir has a trailing / on it
et.generateOutputDir(runDir);
et.createDV(performance);

//Setup outputDir name
String fullOutputDir = et.getOutputDir();
String outputDir = fullOutputDir.substring(fullOutputDir.lastIndexOf("/") + 1);

java.util.List nulllist = et.getNullKeys();
if(!nulllist.isEmpty()){
    out.println("There are still keys in the Transformation which must be defined:<br>\n");
    for(Iterator i = nulllist.iterator(); i.hasNext(); ){
        String ss = (String)i.next();
        out.println("null keys: " + ss + "<br>");
    }
    out.println("<br><br>bailing out!");
    return;
}


//run the actual shell scripts
try{
    et.run();
} catch(ElabShellException e){
%>

    <!-- TODO: remove sometime or another... -->
    <!-- fullOutputDir: <%=et.getOutputDir()%> -->

    <p align="center">
    <%=e.getMessage().replaceAll("\\n", "\n<br>")%>
    </p>
    <p align="center">
    Please <a href="performance.jsp?plot_size=<%=request.getParameter("plot_size")%>&submit=Change">change</a> your parameters.
<%
    return;
}
et.dump();
et.close();



String plotName = performance.getDVValue("plot_outfile_image");
String plotURLName = runDirURL + outputDir + "/" + plotName;

// Convert svg image to png, also create a png thumbnail image


// BENC -- I think we need to ensure that we have finished the 
//         run by the time we reach here.
//         Perhaps the runTeraportReturn code doesn't block?


// We create a thumbnail and an image whose size is specified by the user.
String pixelHeight = request.getParameter("plot_size");
if (pixelHeight == null){
    pixelHeight = "500";
}
String thumbHeight = "150";


String pngPlotName = plotName.replaceAll(".svg", ".png");               //for metadata
String thumbPngPlotName = plotName.replaceAll(".svg", "_thm.png");      //for metadata
String fullSizeURL = runDirURL + outputDir + "/" + pngPlotName;         //for img src
String fullSizePath = fullOutputDir + "/" + pngPlotName;                //for svg2png
String thumbPath = fullOutputDir + "/" + thumbPngPlotName;              //for svg2png
//String thumbPathURL = runDirURL + outputDir + "/" + thumbPngPlotName;   //unused

svg2png(fullOutputDir + "/" + plotName, fullSizePath, thumbPath, pixelHeight, thumbHeight);

%>

<!-- TODO: remove sometime or another... -->
<!-- fullOutputDir: <%=et.getOutputDir()%> -->

<center>
<img src="<%=fullSizeURL%>">
</center>
<p align="center">
<a href="performance.jsp?plot_size=<%=pixelHeight%>&submit=Change">Change</a> your parameters.
</p>
<p align="center">
<b>OR</b>
</p>
<p align="center">To save this plot permanently, enter the new name you want.<br>
Then click <b>Save Plot</b>.<br>

<center>
<FORM name="SaveForm" ACTION="save.jsp"  method="post" target="saveWindow" onSubmit='return openPopup("",this.target,500,200);' align="center">
<%
    //Metadata section
    //there seems to be an unwritten rule to use lowercase for metadata...
    //pass any arguments to write as metadata in the "metadata" form variable as tuple strings
%>

<%
//set rawData variable before including common_metadata_to_save
java.util.List rawDataReference = performance.getRawData();
java.util.List rawData = new java.util.ArrayList(rawDataReference.size());
for(Iterator i=rawDataReference.iterator(); i.hasNext(); ){
    rawData.add(new String((String)i.next()));
}
%>

<%@ include file="include/common_metadata_to_save.jsp" %>

    <input type="hidden" name="beanName" value="performance">
    <input type="hidden" name="metadata" value="transformation string Quarknet.Cosmic::PerformanceStudyNoThresh" >
    <input type="hidden" name="metadata" value="study string performance" >
    <input type="hidden" name="metadata" value="type string plot" >
    <input type="hidden" name="metadata" value="bins int <%=performance.getFreq_binValue()%>" >
    <input type="hidden" name="metadata" value="channel string <%=performance.getSinglechannel_channel()%>" >

    <input type="hidden" name="metadata" value="title string <%=performance.getPlot_title()%>" >
    <input type="hidden" name="metadata" value="caption string <%=caption%>">

    <input type="hidden" name="outputDir" value="<%=outputDir%>" >
    <input type="hidden" name="pngFile" value="<%=pngPlotName%>" >
    <input type="hidden" name="pngThumb" value="<%=thumbPngPlotName%>" >
    <input type="text" name="permanentFile"  size="20" maxlength="30">.png
    <input type="hidden" name="fileType" value="png" >
    <input name="save" type="submit" value="Save Plot">
</form>

<br>
If you are confident in your detector for this day, then click <strong>Bless Data</strong>. 
    <FORM name="BlessForm" ACTION="bless.jsp"  method="post" target="blessWindow" onsubmit='return openPopup("",this.target,500,200);'>

    <%
    for(Iterator i=rawData.iterator(); i.hasNext(); ){
        String file = (String)i.next();
        out.println("<input type=hidden name=filename value=" + file + ">");
    }
    %>
    <input name="bless" type="submit" value="Bless Data">
    </form>
</center>

</body>
</html>
