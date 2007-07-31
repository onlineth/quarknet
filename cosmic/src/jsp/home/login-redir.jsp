<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/login-required.jsp" %>

<%
	
	if (user.isGuest()) {
		response.sendRedirect("../home/splash.html");
	}
	else if (user.isTeacher()) {
		response.sendRedirect(response.encodeRedirectURL("../teacher"));
    }
	else if (user.isFirstTime() || user.getSurvey()) {
		int countQuestions = elab.getTestProvider().getTest("pre").getQuestionCount();
        //check if all the students have taken the test. 
        int taken = elab.getTestProvider().getTotalTaken("pre", user);
        int students = user.getStudents().size();
                   
		if ((students > taken) && (countQuestions > 0)) {
			response.sendRedirect(response.encodeRedirectURL("../jsp/show-students.jsp"));
		}
		else {
			if (user.isFirstTime()) {
            	user.resetFirstTime();
				response.sendRedirect(response.encodeRedirectURL("../home/first.jsp"));
			}
			else {
			    response.sendRedirect(response.encodeRedirectURL("../home/"));
			}
        }
	}
	else {
	    response.sendRedirect("../home/first.jsp");
	}
%>