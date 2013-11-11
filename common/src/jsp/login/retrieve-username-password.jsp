<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/elab.jsp" %>
<%@ page import="gov.fnal.elab.ElabGroup" %>
<%@ page import="gov.fnal.elab.*" %>
<%@ page import="gov.fnal.elab.usermanagement.*" %>
<%@ page import="gov.fnal.elab.usermanagement.impl.*" %>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaImpl" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaResponse" %>

<%
String userid = request.getParameter("userid");
String email = request.getParameter("email");
String message = "", to = "", subject = "", user_name = "", temp_password = "";
String emailBody = "";
String submit = request.getParameter("submitButton");
String pageMessage = "";
boolean sendEmail = false;
boolean continueRequest = false;
String recaptcha_public_key = elab.getProperty("recaptcha_public_key");
String recaptcha_private_key = elab.getProperty("recaptcha_private_key");

//if this is a submit we want to check the reCaptcha
if (submit != null && !submit.equals("")) {
	String remoteAddr = request.getRemoteAddr();
	ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
	reCaptcha.setPrivateKey(recaptcha_private_key);
	String challenge = request.getParameter("recaptcha_challenge_field");
	String uresponse = request.getParameter("recaptcha_response_field");
	try {
		ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);
		if (reCaptchaResponse.isValid()) {
			  continueRequest = true;
			} else {
			  continueRequest = false;
			  message = "The reCaptcha you entered is not right. Please try again.<br />";
			}

	} catch (Exception ex) {
	  	continueRequest = false;
		message = ex.toString() + "<br />";
	}	
}
//if they want to reset password
if ("Reset Password".equals(submit) && continueRequest) {
	if (userid != null && !userid.equals("")) {
		//test if the username entered is a teacher...
		String userRole = elab.getUserManagementProvider().getUserRole(userid);
		String userEmail = elab.getUserManagementProvider().getEmail(userid);
		//if the entered email address exists
		if (userEmail != null && !userEmail.equals("")) {
			String common_message = "Once you login:\n"+
			   		   				"-Go to the Registration page\n"+
					   				"-Select \'Update your research groups including passwords\' \n"+
			   		   				"-Choose your username from the dropdown and show info \n"+
					   				"-Enter your new password and save \n"+
					   				"Please do not reply to this message. Replies to this message go to an unmonitored mailbox.\n" +
			   		   				"If you have any questions, send an e-mail to e-labs@fnal.gov.";
			//check user role
			if (userRole.equals("teacher")) {
				//go ahead and reset password
				temp_password = elab.getUserManagementProvider().resetPassword(userid);
			   	user_name = userid;
				to = userEmail;
				subject = "Your password has been reset";
			    emailBody = "Temporary password for user: " +user_name + " " + "is: "+temp_password+".\n"+
				   		    "Please, login and set a new password.\n\n" +
			    			common_message;
				pageMessage = "A temporary password has been sent to the e-mail address associated with this account.<br />";
			} else {
			   	user_name = userid;
				to = userEmail;
				subject = "Reset password attempt";
			    emailBody = "User: " +user_name + " has attempted to change his/her password.\n"+
				   		   "We were unable to do this because the role is: "+userRole+".\n\n" +
						   "You can reset the password of this user.\n"+
						   common_message;
				pageMessage = "We sent an email to your teacher regarding your attempt to reset your password.<br />";
				
			}
			sendEmail = true;
		} else {
			message = "Either there is no e-mail associated with the username you entered or the username does not have the role of \'teacher\'.<br /> "+
					  "We cannot reset the password at the moment.<br />";
		}
	} else {
		if (userid != null && !userid.equals("")) {
			message = "Username is blank.<br />";
		}
	}
}//end of checking password reset

//if they just want to retrieve username
if ("Retrieve Username".equals(submit) && continueRequest) {
   	if (email != null && !email.equals("")) {
   		String[] user = elab.getUserManagementProvider().getUsernameFromEmail(email);
		if (user != null) {
			user_name = "\n";
			for (int i = 0; i < user.length; i++) {
				user_name = user[i] + "\n";				
			}
		    to = email;
			subject = "Your username";
		    emailBody = "Username(s) associated with your e-mail address: " +user_name + " " +
					   "Please do not reply to this message. Replies to this message go to an unmonitored mailbox.\n" +
			   		   "If you have any questions, send an e-mail to e-labs@fnal.gov.";
			pageMessage = "Your information has been sent to the e-mail you provided.<br />"; 
			sendEmail = true;
		} else {
			message = "There are no usernames associated with this e-mail address.<br />";
		}
    } else {
    	if (email != null && !email.equals("")) {
	    	message = "Email address is blank.<br />";
    	}
    }
}//end of checking retrieve username
	
if (sendEmail) {
   	String result = elab.getUserManagementProvider().sendEmail(to, subject, emailBody);
	if (result != null && result.equals("")) {
	   	message = pageMessage;
	} else {
		message = "Error: unable to send message. " + result + "<br />";
	}	
}
message = message + 
	  "Questions? Please contact <a href=\'mailto:e-labs@fnal.gov\'>e-labs@fnal.gov</a>.<br />" +
	  "<a href=\'../teacher/index.jsp\'>Log in</a>";
request.setAttribute("message", message);
request.setAttribute("recaptcha_public_key", recaptcha_public_key);
request.setAttribute("recaptcha_private_key", recaptcha_private_key);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Login to ${elab.properties.formalName}</title>
	<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
	<link rel="stylesheet" type="text/css" href="../css/login.css"/>
	<script>
	 	window.onload = function() {
			$("retrieve-username-password-form").Show();
		}
	 	var RecaptchaOptions = {
	 		    theme : 'blackglass'
	 	};
	</script>
</head>

<body id="retrieve-username-password" >
	<!-- entire page container -->
	<div id="container">
		<div id="top">
			<div id="header">
				<%@ include file="../include/header.jsp" %>
				<div id="nav">
					<!-- no nav here -->
				</div>
			</div>
		</div>
		
		<div id="content">
	<p>${message}</p>
	
	<form id="retrieve-username-password-form" method="post">	
	<h1>Please fill out the username to reset your password or the email address to retrieve your username.</h1>		
	<ul>
		<li>This tool is for resetting the passwords of teachers.</li>
		<li>To change or reset the passwords associated with student research groups, log in and go to the Registration page.</li>
	</ul>
		<table border="0" id="main">
			<tr>
				<td>Prove you are not a robot first: </td>
			</tr>
		 	<tr><td><div id="recaptcha" align="center">
			<%
				ReCaptcha c = ReCaptchaFactory.newReCaptcha(recaptcha_public_key, recaptcha_private_key, false);
				out.println(c.createRecaptchaHtml(null, null));			
			%>
			</div>
			</td></tr>
			<tr>
				<td><br />Username: <input type="text" name="userid" id="userid"></input> <input type="submit" name="submitButton" value="Reset Password" /></td>
			</tr>
			<tr>
				<td><br />OR</td>
			</tr>			
			<tr>
				<td><br />E-mail address: <input type="text" name="email" id="email"></input> <input type="submit" name="submitButton" value="Retrieve Username" /></td>
			</tr>		
		</table>
	</form>

			</div>
			<!-- end content -->	
		
			<div id="footer">
			</div>
		</div>
		<!-- end container -->
	</body>
</html>
