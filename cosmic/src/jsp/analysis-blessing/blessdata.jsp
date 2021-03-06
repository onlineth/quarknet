<%@ page import="gov.fnal.elab.datacatalog.impl.vds.*" %>
<%@ page import="gov.fnal.elab.datacatalog.*" %>
<%@ page import="gov.fnal.elab.datacatalog.query.*" %>
<%@ page import="gov.fnal.elab.*" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>

<!-- //EPeronja-02/02/2013: Bug472- pop up called by compare1.jsp to bless/unbless data -->
<script type="text/javascript">
	window.onunload = function() {
	    if (window.opener && !window.opener.closed) {
	        window.opener.popUpClosed();
	    }
	};
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>Blessing/Unblessing data...</title>
		<meta http-equiv=Content-Type content="text/html; charset=iso-8859-1">
	</head>
	<body style="background-color: lightGray;">
		<table width="100%" cellpadding="0" cellspacing="0" align="center">
			<%	
			String blessed = request.getParameter("blessed");
			boolean blessedIt = (blessed.equals("true") ? false: true);
			String filename = request.getParameter("filename");
			String newvalue = (blessed.equals("true") ? "unblessed": "blessed");
			
			DataCatalogProvider dcp = ElabFactory.getDataCatalogProvider(elab);
			CatalogEntry entry = dcp.getEntry(filename);
			entry.setTupleValue("blessed", blessedIt);
			dcp.insert(entry);

			%>
			<tr><td>You have successfully <%= newvalue %> your data.</td></tr>
		</table>			
		<a href=# onclick="window.close();">Close</A>
	</body>
</html>
