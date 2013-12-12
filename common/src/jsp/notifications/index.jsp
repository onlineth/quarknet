<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="gov.fnal.elab.*" %>
<%@ page import="gov.fnal.elab.notifications.*" %>
<%@ page import="java.util.*" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>
<%
	{
		ElabNotificationsProvider np = ElabFactory.getNotificationsProvider((Elab) session.getAttribute("elab"));
		List<Notification> n = np.getNotifications(user, ElabNotificationsProvider.MAX_COUNT, true);
		request.setAttribute("isAdmin", user.isAdmin());
		request.setAttribute("notification", n);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>${elab.properties.formalName} e-Lab Home</title>
		<link rel="stylesheet" type="text/css" href="../../cosmic/css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../../cosmic/css/teacher.css"/>
		<script type="text/javascript" src="../include/notifications.js"></script>
		<script type="text/javascript" src="../include/jquery/js/jquery-1.4.3.min.js"></script>	
		<script type="text/javascript" src="../include/jquery/js/jquery.tablesorter.min.js"></script>
		<link type="text/css" rel="stylesheet" href="../include/jquery/css/blue/style.css" />
		<script type="text/javascript">
	
		$(document).ready(function() { 
			$.tablesorter.addParser({
				id: "notDate", 
				is: function(s) { return false; },
				format: function(s) { 
					return $.tablesorter.formatFloat(new Date(s + " 00:00").getTime()); 
				    },
				type: "numeric"
			});
			$("#notifications-table-detailed").tablesorter({sortList: [[4,0]]}, {headers: {0:{sorter:'notDate'}, 5:{sorter:false}}});
		}); 
		</script>

	</head>
	
	<body id="notifications" class="home">
		<!-- entire page container -->
		<div id="container">
			<div id="top">
				<div id="header">
					<%@ include file="../include/header.jsp" %>
					<div id="nav">
						<%@ include file="../include/nav-teacher.jsp" %>
					</div>
				</div>
			</div>
			
			<div id="content">
<h1>Notifications</h1>
<fmt:timeZone value="UTC">
	<table border="0" cellspacing="2" id="notifications-table-detailed">
		<thead>
			<tr>
				<th>Time</th><th>Expires</th><th>Sender</th><th>Message</th><th>Status</th><th>Remove</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${!empty notification}">
					<c:forEach var="n" items="${notification}">
						<tr id="next${n.id}">
							<td width="22%"><fmt:formatDate type="both" value="${n.timeAsDate}"/></td>
							<td width="22%"><fmt:formatDate type="both" value="${n.expirationAsDate}"/></td>
							<td>${n.sender}</td>
							<td>${n.message}</td>
															<td><div id="status${n.id}">
									<c:choose>
										<c:when test="${n.deleted == true}">
											Deleted
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${n.read == true }">
													Read
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${n.read == false }">
															<a href="javascript:markAsRead('status', ${n.id})">Mark as Read</a>
														</c:when>
														<c:otherwise>
															N/A
														</c:otherwise>
													</c:choose>
												</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose>								
								</div>
							</td>
							<td style="text-align: center;">
								<c:choose>
									<c:when test="${isAdmin == true}">
										<a href="javascript:removeNotification('next', ${n.id}, '${elab.name}')"><img src="../graphics/notification-remove.png" /></a>
									</c:when>  
									<c:otherwise>
										<a href="javascript:markAsDeleted('next', ${n.id}, '${elab.name}')"><img src="../graphics/notification-remove.png" /></a>
									</c:otherwise>
								</c:choose>
							</td>
						
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr><td>There are no notifications</td></tr>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>
</fmt:timeZone>

			</div>
			<!-- end content -->	
		
			<div id="footer">
			</div>
		</div>
		<!-- end container -->
	</body>
</html>