<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="gov.fnal.elab.datacatalog.*" %>
<%@ page import="gov.fnal.elab.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.codec.net.URLCodec" %>

<script type="text/javascript">
function sendImage(url, link)
{
    var count = parseInt(opener.document.log.count.value);
    opener.document.log.log_text.value += "(--Image " + count + "--)";
    opener.document.log.count.value = (count + 1)+"";
    opener.document.log.img_src.value += "<a href=\"" + link + "\" target=\"_blank\">";
    opener.document.log.img_src.value += "<img height=\"100\" width=\"100\" src=\"";
    opener.document.log.img_src.value += url;
    opener.document.log.img_src.value += "\" border=\"0\"></a>\t";
    self.close();
    opener.focus();
    return false;
};
function sendLink(url, link)
{
	var count = parseInt(opener.document.log.count.value);
    opener.document.log.log_text.value += "(--Image " + count + "--)";
    opener.document.log.count.value = (count + 1)+"";
    opener.document.log.img_src.value += "<a href=\"" + link + "\" target=\"_blank\">";
    //opener.document.log.img_src.value += "View plot: " + title;
    //opener.document.log.img_src.value += "</a>,";
    //EPeronja-04/08/2013: Fixed bug with the logbook. This problem was showing only in CMS
    opener.document.log.img_src.value += "<img height=\"100\" width=\"100\" src=\"";
    opener.document.log.img_src.value += url;
    opener.document.log.img_src.value += "\" border=\"0\"></a>\t";
    self.close();
    opener.focus();
    return false;
};
</script>   

<%
	ResultSet rs = (ResultSet) request.getAttribute("searchResults");
    String message = (String) request.getAttribute("msg");
	if (rs != null && !rs.isEmpty()) {
	    out.write("<table id=\"plots\">\n");
	    Map groups = new HashMap();
	    Iterator i = rs.iterator();
	    while (i.hasNext()) {
	        out.write("<tr>\n");
	        for (int c = 0; c < 4 && i.hasNext(); c++) {
	            CatalogEntry e = (CatalogEntry) i.next();
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
	            //EPeronja-04/08/2013: Added the encoding the the fileName because the name got crippled
	            //					   from showLogbookT.jsp to view-common.jsp.
	            URLCodec urlCodec = new URLCodec();
	            String fileName = urlCodec.encode(e.getLFN()); 
	            request.setAttribute("fileName", fileName);
	            
	            if (group != null) {
					String plotURL = group.getDirURL("plots");
	            	request.setAttribute("plotURL", plotURL);
	            }
	            %>
	            	<td class="plot-thumbnail">
	            		
		            		<c:choose>
	            				<c:when test="${!empty e.tupleMap.thumbnailURL}">
	            					<a href="#" onClick="return sendLink('${e.tupleMap.thumbnailURL}', '../plots/view.jsp?filename=<%=fileName%>');">
		            					<img class="plot-thumbnail-image" src="${e.tupleMap.thumbnailURL}" alt="Thumbnail not found" /><br/>
		            				</a>
		            			</c:when>
		            			<c:otherwise>
		            				<a href="#" onClick="return sendImage('${plotURL}/${e.LFN}', '../plots/view.jsp?filename=<%=fileName%>');">
		            					<img class="plot-thumbnail-image" src="${plotURL}/${e.tupleMap.thumbnail}" alt="Thumbnail not found" /><br/>
	            					</a>
		            			</c:otherwise>
		            		</c:choose>
		            	
		            	${e.tupleMap.name}<br/>
	            		Group: ${e.tupleMap.group}<br/>
	            		Created: ${e.tupleMap.creationdate}<br/>
  			            <% if (!user.isGuest()) { %>
	            			<a href="../jsp/comments-add.jsp?fileName=${e.LFN}&t=plot">View/Add Comments</a><br/>
	            		<% } %>
	            	</td>
	            <%
	        }
			out.write("</tr>\n");
	    }
	    out.write("</table>\n");
	}
	else {
		if (message == null) {
			message = "";
		}
	    out.write("<h3>No results found</h3> " + message);
	}
%>