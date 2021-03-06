<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="gov.fnal.elab.datacatalog.query.*" %>
<%@ page import="gov.fnal.elab.datacatalog.*" %>
<%@ page import="gov.fnal.elab.util.*" %>
<%@ page import="gov.fnal.elab.*" %>
<%@ page import="java.util.*" %>

<%
	ResultSet rs = (ResultSet) request.getAttribute("searchResults");
    String message = (String) request.getAttribute("msg");
    if (message == null) {
    	message = "";
    }

	if (rs != null && !rs.isEmpty()) {
		out.write("<form method=\"get\" action=\"../plots/delete.jsp\">\n");
	    out.write("<table id=\"plots\">\n");
	    Map<String, ElabGroup> groups = new HashMap<String, ElabGroup>();
	    Iterator<CatalogEntry> i = rs.iterator();
	    while (i.hasNext()) {
	        out.write("<tr>\n");
	        for (int c = 0; c < 4 && i.hasNext(); c++) {
	            CatalogEntry e = i.next();
	            String groupName = (String) e.getTupleValue("group");
	            ElabGroup group = (ElabGroup) groups.get(groupName);
	            if (group == null) {
	            	try {
	            		group = elab.getUserManagementProvider().getGroup(groupName);
	            		groups.put(groupName, group);
	            	}
	            	catch (ElabException ex) {
	            	}
	            }  
	            request.setAttribute("e", e);
	            if (group != null) {
	            	String plotURL = group.getDirURL("plots");
	            	request.setAttribute("plotURL", plotURL);
	            }
	            %>
	            	<td class="plot-thumbnail">
	            		<a href="view.jsp?filename=${e.LFN}">
	            			<c:choose>
	            				<c:when test="${!empty e.tupleMap.thumbnailURL}">
		            				<img class="plot-thumbnail-image" src="${e.tupleMap.thumbnailURL}" alt="Thumbnail not found" /><br/>
		            			</c:when>
		            			<c:otherwise>
		            				<img class="plot-thumbnail-image" src="${plotURL}/${e.tupleMap.thumbnail}" alt="Thumbnail not found" /><br/>
		            			</c:otherwise>
		            		</c:choose>
		            	</a>
		            	<input type="checkbox" name="file" value="${e.LFN}" />${e.tupleMap.name}<br/>
	            		Group: ${e.tupleMap.group}<br/>
	            		Created: ${e.tupleMap.creationdate}<br/>
	            		<a href="../jsp/comments-add.jsp?fileName=${e.LFN}&t=plot">View/Add Comments</a><br/>
	            	</td>
	            <%
	        }
			out.write("</tr>\n");
	    }
	    out.write("</table>\n");
	    out.write("<input type=\"submit\" name=\"delete\" value=\"Delete selected plots\"/>");
   	    out.write("</form>\n");
	}
	else {
	    out.write("<h3>No results found</h3> " + message);
	}
%>