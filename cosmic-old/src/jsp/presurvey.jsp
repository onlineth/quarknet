<%@ page import="java.util.regex.*" %>
<%@ include file="common.jsp" %>
<html>
    <head>
        <title>Test</title>
    </head>
    <body>
        <center>

<%
//start jsp by defining submit
String submit =  request.getParameter("submit");
String student_id= request.getParameter("student_id");
String prePost = request.getParameter("type"); 
if (prePost == null || prePost.equals("") ) {prePost="pre";}
String testname= prePost+"test";
%>

<!-- creates variables ResultSet rs and Statement s to use: -->
<%@ include file="include/jdbc_userdb.jsp" %>

    		<p>
    		<table width=700 cellpadding=4>
				<tr>
            		<td bgcolor="#0a5ca6"> 
                		<font color=ffffff>
                    		<b>
                        		Answer the following questions and click <b>Record Answers</b> to take test <%=testname%>.
                    		</b>
                		</font> 
            		</td>
        		</tr> 
        		<tr><td><b><font color=#0a5ca6>Don't guess!!</FONT> "Do not know"</b> is a perfectly good answer. You will learn the answers to questions like these in your investigation.</td></tr>
     		</table>
    		<p>
<HR width="600">
<form name="form1" method="get" action="recordAnswers.jsp">
  <input type=hidden name=type value=<%=prePost%>>
  <input type=hidden name=student_id value=<%=student_id%>>
     <%
     int questionNo=1;
     rs = s.executeQuery("select question,question_no,id,response1,response2,response3,response4,response5 from question where question.project_id=1 AND question.test_name='"+testname+"' ORDER BY question.question_no;");
     while(rs.next()){
       String question=rs.getString("question");
       String questionId=rs.getString("id");
       String question_no=rs.getString("question_no");
       String response1=rs.getString("response1");
       String response2=rs.getString("response2");
       String response3=rs.getString("response3");
       String response4=rs.getString("response4");
       String response5=rs.getString("response5");
     %>
     <table width="600">
    <tr><th align="left"><%=questionNo%>) <%=question%><input type="hidden" name=questionId<%=questionNo%> value=<%=questionId%>></th></td></tr>
	<tr><td><input type="radio" name="response<%=questionNo%>" value="1"><%=response1%></td></tr>
    <td><input type="radio" name="response<%=questionNo%>" value="2"><%=response2%></td></tr>
    <% if (!response3.equals("")) {
     %>
     <td><input type="radio" name="response<%=questionNo%>" value="3"><%=response3%></td></tr>
     <%
     }
     if (!response4.equals("")) {
     %>
     <td><input type="radio" name="response<%=questionNo%>" value="4"><%=response4%></td></tr>
     <%
     }
     if (!response5.equals("")) {
     %>
     <td><input type="radio" name="response<%=questionNo%>" value="5"><%=response5%></td></tr>
     <%
     }
     %>
       </table><P><HR width="600">
   
     <% questionNo++;
     
     } //while
     %>
  <input type="hidden" name="count" value="<%=questionNo-1%>">   

  <p align="center"> 
    <input type="submit" name="Submit" value="Record Answers">
    <input type="reset" name="Submit2" value="Reset Answers">
  </p>
  </form>
</body>
<%
if (s != null)
    s.close();
if (conn != null)
    conn.close();
%>
</html>
  
