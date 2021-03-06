<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/elab.jsp" %>
<%@ include file="../login/teacher-login-required.jsp" %>
<%@ page import="gov.fnal.elab.*" %>
<%@ page import="gov.fnal.elab.usermanagement.*" %>
<%@ page import="gov.fnal.elab.usermanagement.impl.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">		
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Register Students</title>
		<link rel="stylesheet" type="text/css" href="../../cosmic/css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../../cosmic/css/teacher.css"/>
		<link rel="stylesheet" type="text/css" href="../css/style2.css"/>
		<link rel="stylesheet" type="text/css" href="../css/teacher.css"/>
		<script type="text/javascript" src="../include/elab.js"></script>
        <script type="text/javascript" src="../include/util-functions.js"></script>
        <script type="text/javascript" src="../include/clear-default-text.js"></script>
		<script type="text/javascript" src="../include/register-students.js"></script>
	</head>
	
	<body id="register-students" class="teacher">
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

<%
	Integer newSurveyId = null; 
	boolean teacherInStudy = "yes".equalsIgnoreCase(request.getParameter("eval"));
	TreeMap<String, Integer> teacherGroups = new TreeMap<String, Integer>();
	
	// Only for teachers in our study. 
	if (teacherInStudy) {
		%> <i>You have agreed to enter our study</i><% 
		
		// Set teacher's database flag so we know he or she is in the survey.
		if (user.isStudy() == false) {
			elab.getUserManagementProvider().setTeacherInStudy(user, newSurveyId); 
			user.setStudy(true);
			// set this in the database. 
		}
	}
	
	// New survey/test handler is active by default. --> No, it is not! 
	//if (user.getNewSurveyId() == null) { 
		try {
			newSurveyId = Integer.parseInt(elab.getProperty(elab.getName() + ".newsurvey"));
		
		}
		catch(NumberFormatException nfe) {
			newSurveyId = null; 
		}
		finally {
			user.setNewSurveyId(newSurveyId);
		}
//	}
//	else {
//		newSurveyId = user.getNewSurveyId().intValue();
//	}
		
	String optionList = "<option value=\"discard\">Choose group</option>";
	for (Iterator ite = user.getGroups().iterator(); ite.hasNext();) {
		ElabGroup group = (ElabGroup) ite.next();
		//EPeronja-05/30/2013-Added this check to prevent mixing/matching older groups
		//         with new students. This was not well-thought and was breaking the code
		//		   in show-students.jsp trying to show 'new' and 'old' students.
		boolean existsInSurvey = elab.getTestProvider().getSurveyStudents(group);
		if (!existsInSurvey) {
			String name = group.getName();
			boolean insurvey = group.getSurvey();
			if (!name.equals(user.getName())) {
				if (group.getActive()) {
					if (insurvey) {
				    	optionList += "<option value=\"" + name + "\">" + name +"(in survey)</option>";
					} else {
				    	optionList += "<option value=\"" + name + "\">" + name +"</option>";						
					}
				}
		    	teacherGroups.put(name, group.getStudents().size());
		    }
		}
	}
	request.setAttribute("teacherGroups", teacherGroups);
	request.setAttribute("project", elab.getName());
	
	String submit = request.getParameter("submit");
	if (submit != null) {
	    try {
	        List students = new ArrayList();
	        List newGroups = new ArrayList();
	        
			for (int formNum = 0; formNum < 10; formNum++) {
				String last = request.getParameter("last" + formNum);
				String first = request.getParameter("first" + formNum);
				String resName = request.getParameter("res_name" + formNum);
				String resNameChoose = request.getParameter("res_name_choose" + formNum);
				String nameOption = request.getParameter("name_option" + formNum);
				String upload = request.getParameter("is_upload" + formNum);
				String survey = request.getParameter("is_survey" + formNum);
				
				boolean isNewGroup = true;
				
				boolean groupInSurvey = (StringUtils.containsIgnoreCase(survey, "yes") || 
						StringUtils.containsIgnoreCase(survey, "true"));
				
				if (resName == null || resName.equals("Group Name") || nameOption.equals("existing")) {
					resName = resNameChoose;
					isNewGroup = false;
				} else {
					resName = resName.replaceAll(" ", "_");
				}
				
				if (last == null || first == null || resName == null ||
					last.equals("") || first.equals("") || resName.equals("") ||
					last.equals("Last Name") || first.equals("First Name") || resName.equals("Group Name") || 
					resName.equals("discard")) {
					continue;
				}
				
				ElabStudent newUser = new ElabStudent();
				first = first.replaceAll(" ", "").toLowerCase();
				last = last.replaceAll(" ", "").toLowerCase();
				String studentName = first.substring(0, 1) + last.substring(0, (last.length() < 7 ? last.length() : 7));
				
				newUser.setName(studentName);

				ElabGroup group = new ElabGroup(elab);
				newUser.setGroup(group);
				group.setName(resName);
				group.setActive(true);
				if ("yes".equalsIgnoreCase(upload) || "true".equalsIgnoreCase(upload)) {
				    group.setRole(ElabUser.ROLE_UPLOAD);
				}
				
				if (StringUtils.equalsIgnoreCase(elab.getName(), "cosmic")) { // cosmic
					group.setSurvey(false); // old, deprecated handler is disabled
					group.setStudy(teacherInStudy);
					group.setNewSurvey(groupInSurvey);
					group.setNewSurveyId(newSurveyId);
				}
				else if (StringUtils.equalsIgnoreCase(elab.getName(), "ligo") ||
						 StringUtils.equalsIgnoreCase(elab.getName(), "cms") ||
						 StringUtils.equalsIgnoreCase(elab.getName(), "cms-tb")) {
					group.setSurvey(false);
					group.setStudy(false);
					group.setNewSurvey(groupInSurvey);
					group.setNewSurveyId(newSurveyId);
				}
				students.add(newUser);
				newGroups.add(Boolean.valueOf(isNewGroup));
			}
			List passwords = elab.getUserManagementProvider().addStudents(user, students, newGroups);
			List results = new ArrayList();
			Iterator i = students.iterator(), j = passwords.iterator();
			while (i.hasNext()) {
				String password = (String) j.next();
				ElabStudent u = (ElabStudent) i.next();
			    if (password != null) {
			        List l = new LinkedList();
			        l.add(u.getGroup().getName());
			        l.add(password);
			        results.add(l);
			    }
			}
			request.setAttribute("valid", true);
			request.setAttribute("results", results);
	    }
	    catch (Exception e) {
	   		e.printStackTrace();
	        request.setAttribute("valid", false);
	        request.setAttribute("error", e.getMessage());
	    }
		
		%>
			<c:choose>
				<c:when test="${valid}">
					<p class="success">Your student registration completed succesfully.</p>
					<c:if test="${not empty results}" >
						<p>
							The new groups we created for you (and their associated passwords) are listed below.
						</p>
						<p>
						    <!-- If one of the groups you requested already existed in our project, your group name was altered
						    slightly to ensure uniqueness. --> You may now use the File...Save feature in your browser to save
						    the information below.
						</p>
						<table border="0" id="registration-results">
							<tr>
								<th>Group Name</th>
								<th>Password</th>
							</tr>
							<c:forEach items="${results}" var="result">
								<tr>
									<td>${result[0]}</td>
									<td>${result[1]}</td>
								</tr>
							</c:forEach>
						</table>
					</c:if>
				</c:when>
				<c:otherwise>
					<p class="error">A problem occurred while registering with your students:</p>
					<p class="error">${error}</p>
				</c:otherwise>
			</c:choose>
		<%
	} //end of check for submit
	else {
		%>
			<ul>
				<li>
					Register new students below.  To register more students, click on the&nbsp; 
					<strong>+</strong> &nbsp;button.<br /><br />
				</li>
				<li>
					We will create new groups and their associated passwords for you.<br /><br />
				</li>
				<li>
					Groups created before Summer 2009 will not appear in the dropdown.<br /><br />
				</li>
	        	<c:choose>
	        		<c:when test='${project == "cosmic"}'>
						<li>
							Select &nbsp;<img src="../graphics/upload_registration.gif" valign="middle"/>&nbsp; if 
							you want to grant the new group upload permissions for your detectors.
						</li>
					</c:when>
				</c:choose>
				<li>
					Select &nbsp;<img src="../graphics/logbook_pencil.gif" valign="middle"/>&nbsp; 
					if you want the new group to take the pre-test.
				</li>
			</ul>
			<form name="register" method="post" 
				action="<%= elab.secure("teacher/register-students.jsp" + (teacherInStudy? "?eval=yes" : "")) %>"> 

			    <table cellpadding="0" cellspacing="0" border="0" align="center" width="800">
					<%
						for (int i = 0; i < 10; i++) {
							String visibility = "";
							String minusButton = "";
							if (i == 0) {
								visibility = "visibility:visible; display:;";
							}
							else {
								visibility = "visibility:hidden; display:none;";
							}
							if (i > 0) {
							    //holly matrimony!
								minusButton = "<input name=\"less_reg" + i + 
								"\" type=\"submit\" value=\"-\" onClick=\"this.form.first" + i + 
								".value='First Name'; this.form.last" + i + 
								".value='Last Name'; this.form.is_new" + i + 
								".value='Make New Group'; aLs('res_name_text" + i + 
								"').visibility = 'hidden'; aLs('res_name_text" + i + 
								"').display = 'none'; aLs('res_name_chooser" + i + 
								"').visibility = 'visible'; aLs('res_name_chooser" + i + 
								"').display = ''; HideShow(\'group_line" + i + 
								"\');HideShow(\'plus_line" + i + "\'); aLs('is_upload_box" + i + 
								"').visibility = 'hidden'; aLs('is_upload_box" + i + 
								"').display = 'none'; aLs('is_survey_box" + i + 
								"').visibility = 'hidden'; aLs('is_survey_box" + i + 
								"').display = 'none'; return false;\">";
							}
							String textChange = "var opts = this.form.res_name_choose" + i + ".options.length; ";
							for (int j = i+1; j < 9; j++) {
								textChange += "this.form.res_name_choose" + j + 
								".options[opts]=new Option(this.form.res_name" + i + 
								".value, this.form.res_name" + i + 
								".value); this.form.res_name_choose" + j + ".options[opts].selected = true;";
							}
								%>
<tr>
	<td align="left">
		<div id="group_line<%=i%>" style="<%=visibility%> border-left:3px solid #AAAAAA; padding-left:5px; padding-bottom:5px; padding-top:5px;">
        	<input type="text" name="first<%=i%>" size="14" maxlength="30" value="First Name" class="cleardefault"/>
			<input type="text" name="last<%=i%>" size="14" maxlength="30" value="Last Name" class="cleardefault"/>
			<input id="res_name_text<%=i%>" type="text" name="res_name<%=i%>" size="14" maxlength="30" value="Group Name" style="visibility:hidden; display:none;" onChange="checkNewGroup(this, <%=i%>);<%=textChange%>" class="cleardefault">
			<select id="res_name_chooser<%=i%>" class="chosenGroups" style="visibility:visible; display:;" name="res_name_choose<%=i%>" onChange="checkExistingGroup(this, <%=i%>);">
            	<%=optionList%>
			</select>
			<input type="hidden" name="name_option<%=i%>" id="name_option<%=i%>" value=""></input>
			<input type="submit" name="is_new<%=i%>" value="Make New Group" 
				onClick="HideShow('res_name_text<%=i%>'); HideShow('res_name_chooser<%=i%>');HideShow('is_upload_box<%=i%>');HideShow('is_survey_box<%=i%>'); if (this.form.is_new<%=i%>.value=='Make New Group') {this.form.res_name_chooser<%=i%>.options[0].selected=true; this.form.is_new<%=i%>.value='Choose group'; } else { this.form.res_name_text<%=i%>.value='Group Name'; this.form.is_new<%=i%>.value='Make New Group'; } return false;"/>
        </div>
    </td>
    <td align="left" valign="middle">
        <div id="is_upload_box<%=i%>" style="visibility:hidden; display:none;">
        	<c:choose>
        		<c:when test='${project == "cosmic"}'>
		            <input type="checkbox" name="is_upload<%=i%>" value="yes"/>
		            <img src="../graphics/upload_registration.gif" valign="middle"/>
		        </c:when>
		     </c:choose>
        </div>
    </td>
    <td align="left" valign="middle">
        <div id="is_survey_box<%=i%>" style="visibility:hidden; display:none;">
            <input type="checkbox" name="is_survey<%=i%>" value="yes" checked="true"/>
            <img src="../graphics/logbook_pencil.gif" valign="middle"/>
        </div>
    </td>
    <td align="right">
        <div id="plus_line<%=i%>" style="<%=visibility%> padding-right:5px;">
	        <%=minusButton%>
				<%
			        // Don't show the plus button on the last line.
			        if (i != 9) {
						%><input name="more_reg<%=i%>" type="submit" value="+" 
							onClick="HideShow('group_line<%=i+1%>');HideShow('plus_line<%=i+1%>');return false;"/><%
        			}
				%>
        </div>
    </td>
</tr>
								<%
						}//for i = 0..9
					%>
					<tr>
						<td colspan="2"><div id="messages"></div></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td align="right" colspan="4">
							<input type="submit" name="submit" value="I'm done" onclick="return checkEnteredData();"/>
						</td>
					</tr>
				</table>
				<c:choose>
					<c:when test="${not empty teacherGroups}">
					 	<c:forEach items="${teacherGroups}" var="teacherGroups">
					 		<input type="hidden" name="${teacherGroups.key}" id="tg_${teacherGroups.key}" class="existingGroups" value="${teacherGroups.value}"></input>
					 	</c:forEach>
					</c:when>
				</c:choose>
			</form>
		<%
	}//some else up there
%>

			</div>
			<!-- end content -->	
		
			<div id="footer">
			</div>
		</div>
		<!-- end container -->
	</body>
</html>

