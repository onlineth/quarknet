<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ page errorPage="../include/errorpage.jsp" buffer="none" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/upload-login-required.jsp" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="gov.fnal.elab.datacatalog.*" %>
<%@ page import="gov.fnal.elab.datacatalog.query.*" %>
<%@ page import="gov.fnal.elab.usermanagement.*" %>
<%@ page import="gov.fnal.elab.usermanagement.impl.*" %>
<%@ page import="gov.fnal.elab.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.lang.*" %>
<%@ page import="org.apache.commons.io.*" %>
<%@ page import="be.telio.mediastore.ui.upload.*" %>
<%@ page import="gov.fnal.elab.upload.*" %>
<%@ page import="gov.fnal.elab.cosmic.beans.Geometries" %>
<%@ page import="gov.fnal.elab.cosmic.beans.GeoEntryBean" %>
<%@ page import="gov.fnal.elab.cosmic.Geometry" %>


<%--
Re: the upload progress stuff

/* Licence:
*   Use this however/wherever you like, just don't blame me if it breaks anything.
*
* Credit:
*   If you're nice, you'll leave this bit:
*
*   Class by Pierre-Alexandre Losson -- http://www.telio.be/blog
*   email : plosson@users.sourceforge.net
*/
--%>

<%
	ElabUserManagementProvider p = elab.getUserManagementProvider();
	CosmicElabUserManagementProvider cp = null;
	if (p instanceof CosmicElabUserManagementProvider) {
		cp = (CosmicElabUserManagementProvider) p;
	}
	else {
		throw new ElabJspException("The user management provider does not support management of DAQ IDs. " + 
			"Either this e-Lab does not use DAQs or it was improperly configured.");
	}    
	Collection ids = cp.getDetectorIds(user);
    if(ids == null || ids.size() == 0) {
        throw new ElabJspException("Your group does not have any detector IDs associated with it. "
                + "This is done when your group is first created.");
    }
    request.setAttribute("detectorIDs", ids);

	String lfn="";              //lfn on the USERS home computer
	String fn = "";             //filename without slashes
	String ds = "";
	String detectorId = "";             //detector id
	String comments = "";       //optional comments on raw data file
	String dataDir = elab.getProperties().getDataDir();
	request.setAttribute("datadir", dataDir);
	int channels[] = new int[4];
	
	File tempRepo = new File(dataDir + "/temp"); 
	int sizeThreshold = 0; 

	List splits = new ArrayList();  //for both the split name and the channel validity information

	if (ServletFileUpload.isMultipartContent(request)) {
	    //BEGIN upload_progress_stuff
	    UploadListener listener = new UploadListener(request, 0);

	    // Create a factory for disk-based file items
	    FileItemFactory factory = new NewLineConvertingMonitoredDiskFileItemFactory(
	    		sizeThreshold, tempRepo, listener); 

    	// Create a new file upload handler
	    ServletFileUpload upload = new ServletFileUpload(factory);
    	//END upload_progress_stuff
    	
		List<DiskFileItem> fileItems = upload.parseRequest(request); 
    	
    	for (DiskFileItem fi : fileItems) { 
    		if (fi.isFormField()) {
    			String name = fi.getFieldName();
    			String content = fi.getString();
    			if ("detector".equals(name)) {
    				if (StringUtils.isBlank(content)) {
    					throw new ElabJspException("You must enter a detector number for this data.");
    				}
    				else {
    					detectorId = content;
    				}
    			}
    			else if ("comment".equals(name)) {
    				if (StringUtils.isNotBlank(content)) {
    					comments = content; 
    				}
    			}
    		}
    	}
    	
		if (StringUtils.isBlank(request.getParameter("detector"))) {
			throw new ElabJspException("You must enter a detector number for this data.");
		}
		else { 
			detectorId = request.getParameter("detector");
		}
		if (StringUtils.isNotBlank(request.getParameter("comments"))) {
			comments = request.getParameter("comments"); 
		}		
		
		for (DiskFileItem fi : fileItems) {
			if (!fi.isFormField()) {
				lfn = fi.getName();
				if (StringUtils.isBlank(lfn)) {
                	throw new ElabJspException("Missing file.");
    	        }
	            //fn is the filename without slashes (which lfn has)    	       
	            fn = FilenameUtils.getName(lfn);
				if (fi.getSize() == 0) {
				    throw new ElabJspException("Your file is zero-length. You must upload a file which has some data.");
				}
                //new algorithm for filenaming:
   	            //name the raw file id.yyyy.mmdd.index.raw and save the original name in metadata
       	        //index starts at 0 and increments when there are collisions with other filenames
                Date now = new Date();
                DateFormat df = new SimpleDateFormat("yyyy.MMdd");
                String fnow = df.format(now);
				//even newer algorithm: use File.createTempFile!
				File f = File.createTempFile(detectorId + "." + fnow + ".", ".raw", 
				        new File(dataDir));
               	String rawName = f.getName();

               	// write the file from memory or relocate it on disk.
               	if (fi.isInMemory()) {
               		fi.write(f);
               	}
               	else {
               		fi.getStoreLocation().renameTo(f);
               	}
       	        out.println("<!-- " + rawName + " added to Catalog -->");
       	        request.setAttribute("in", f.getAbsolutePath());
       	        request.setAttribute("detectorid", detectorId);
       	        request.setAttribute("comments", comments);

				%>
					<e:analysis name="processUpload" type="I2U2.Cosmic::ProcessUpload" impl="generic">
						<e:trdefault name="in" value="${in}"/>
						<e:trdefault name="datadir" value="${datadir}"/>
						<e:trdefault name="detectorid" value="${detectorid}"/>
						<e:trdefault name="comments" value="${comments}"/>
						
						<jsp:include page="../analysis/start.jsp?continuation=../data/upload-results.jsp&notifier=upload">
							<jsp:param name="provider" value="shell"/>
						</jsp:include>
					</e:analysis>
				<%
			} //'twas a file
		} //while through the file
	} //end "if form has a file to upload"
	else {
		%>
		
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Upload Raw Data</title>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/upload.css"/>
		<link rel="stylesheet" type="text/css" href="../css/two-column.css"/>
		<script type="text/javascript" src="../include/upload.js"></script>
        <script type="text/javascript" src="../../dwr/interface/UploadMonitor.js"></script>
        <script type="text/javascript" src="../../dwr/engine.js"></script>
        <script type="text/javascript" src="../../dwr/util.js"></script>
	</head>
	
	<body id="search_default" class="data">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<%@ include file="../include/nav-rollover.jspf" %>
				</div>
			</div>
			
			<div id="content">

<h1>Upload raw data collected by your cosmic ray detector.</h1>



<ul>
	<li>Select the <strong>detector</strong> associated with the data you are uploading.</li>
	<li>Click <strong>Choose File/Browse</strong> to locate the data file on your computer.</li>
	<li>Click <strong>Upload</strong> to upload the file.</li>
</ul>

<form name="uploadform" id="upload-form" method="post" enctype="multipart/form-data" onSubmit="startProgress()">
    <!-- file, detector, and upload table -->	
    <div class="redborder">
<strong>Please <em>do not</em> upload files larger than 2 GB in size. You'll have to split them up into smaller pieces. Questions? See the <a href="../library/FAQ.jsp">FAQ</a> </strong>
</div>
	<p>
		<u>Choose <label for="detector">detector</label></u><br />	
		<c:forEach items="${detectorIDs}" var="d">
			<input type="radio" name="detector" value="${d}" />${d}
		</c:forEach>
    </p>
	<p>
		<label for="ds">Raw Data File:</label>
		<input id="uf2" name="ds" type="file" size="15"/>
	</p>
    <p>
		<label for="comments">Optional comments on raw data:</label>
	</p>
	<p>
        <textarea id="uf3" name="comments" rows="8" cols="50"></textarea>
    </p>
    <div id="button-line">
    	<!-- grr. somebody fix css -->
    	<table border="0">
    		<tr>
    			<td>
					<input name="load" type="submit" value="Upload" id="uploadbutton"/>
				</td>
				<td>
					<div id="progressBar" style="display: none">
						<div id="theMeter">

							<div id="progressBarBox">
								<div id="progressBarBoxContent"></div>
								<div id="progressBarText"></div>
							</div>
						</div>
						
					</div>
				</td>
			</tr>
		</table>
		<div id="uploadwarning" class="redborder">
			<strong><em>Don't navigate away from this page</em></strong> until we've started analyzing your file!
		</div>
	</div>
</form>

	<%
	}
%>

			</div>
			<!-- end content -->	
		
			<div id="footer">
			</div>
		</div>
		<!-- end container -->
	</body>
</html>
