<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="gov.fnal.elab.*" %>
<%@ page import="gov.fnal.elab.notifications.*" %>

<%
	boolean loggedIn = ElabGroup.isUserLoggedIn(session);
	request.setAttribute("loggedin", loggedIn);
	if (loggedIn) {
	    ElabGroup group = ElabGroup.getUser(session);
	    request.setAttribute("username", group.getName());
	}
%>
<div id="header-image">
	<img src="<%= "/elab/cosmic/graphics/blast.jpg" %>" alt="Cosmic Ray Blast" />
</div>
<div id="header-title">Cosmic Ray e-Lab</div>
<c:choose>
	<c:when test="${loggedin}">
		<div id="header-toolbar">
			<c:choose>
				<c:when test="${user.teacher}">
					<e:popup href="/elab/cosmic/teacher/forum/HelpDeskRequest.php" target="helpdesk" width="800" height="600"><img title="Helpdesk" src="../graphics/helpdesk.png" /></e:popup>
					<e:popup href="../jsp/showLogbookT.jsp" target="log" width="800" height="600"><img title="Logbook" src="../graphics/logbook.png" /></e:popup>
				</c:when>
				<c:otherwise>
					<e:popup href="../jsp/showLogbook.jsp" target="log" width="800" height="600"><img title="Logbook" src="../graphics/logbook.png" /></e:popup>
				</c:otherwise>
			</c:choose>
			<c:if test='${user.name != "guest" }'>					
				<%@ include file="../notifications/header-notifications.jsp" %>
			</c:if>
			<a id="username" href="../login/user-info.jsp"><span class="toolbar-text-link">${username}</span></a>
			<a href="../login/logout.jsp"><span id="logout" class="toolbar-text-link">Log out</span></a>
		</div>
		<span id="toolbar-error-text"></span>
		<c:set var="headerIncluded" value="true" scope="request"/>
		<% out.flush(); %>	
		<%@ include file="../analysis/async-update.jsp" %>
		<script language="JavaScript" type="text/javascript">
			//5 minutes
		    var checkUpdate = 5 * 1000
			registerUpdate("../include/toolbar-async.jsp", 
					function(data, error) {
						updateHeader(data, error, '${elab.name}');
					}, checkUpdate, checkUpdate);
		</script>
	</c:when>
</c:choose>