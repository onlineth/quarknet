<%@ taglib prefix="e" uri="http://www.i2u2.org/jsp/elabtl" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="gov.fnal.elab.*" %>


<div id="header-image">
	<img src="../graphics/cms_poster_horizontal_final.jpg" alt="Header Image" />
</div>
<div id="header-image-teacher">
	<img src="../graphics/blast.jpg" alt="Teacher Header Image" />
</div>
<%
	if (ElabGroup.isUserLoggedIn(session)) {
		%>
			<div id="header-current-user">
				Logged in as group: 
					<a href="../login/user-info.jsp"><%= ElabGroup.getUser(session).getName() %></a>				
			</div>
			<div id="header-logout">
				<a href="../login/logout.jsp">Logout</a>
			</div>
			<div id="header-logbook">
				<c:choose>
					<c:when test="${user.teacher}">
						<e:popup href="../jsp/showLogbookT.jsp" target="log" width="800" height="600">My Logbook</e:popup>
					</c:when>
					<c:otherwise>
						<e:popup href="../jsp/showLogbook.jsp" target="log" width="800" height="600">My Logbook</e:popup>
					</c:otherwise>
				</c:choose>
			</div>
		<%
	}
	request.setAttribute("headerIncluded", Boolean.TRUE);
	out.flush();
%>
