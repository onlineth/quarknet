<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ include file="common.jsp" %>
<html>
    <head>
        <title>Show Students</title>
    </head>
    <body>
        <center>

<!-- creates variables ResultSet rs and Statement s to use: -->
<%@ include file="include/jdbc_userdb.jsp" %>
<%
           //groupName defined in common.jsp
      // type=pre for getting students who need to take presurvey; type=post for getting students who need to take postsurvey (posttest)
      String prePost = request.getParameter("type"); 
if (prePost == null || prePost.equals("") ) {prePost="pre";}
      String ID="";
     String query="select id from research_group where name=\'"+groupName+"\';";
     rs = s.executeQuery(query);
     if (rs.next()){
       ID=rs.getString("id");}
       
       if (ID.equals("")) {%> Problem with ID for group <%=groupName%><BR><% return;}
%>


    		<p>
    		<table width=700 cellpadding=4>
				<tr>
            		<td bgcolor="#0a5ca6"> 
                		<font color=ffffff>
                    		<b>
                        		Students in research group <%=groupName%> need to take the <%=prePost%>test.
                    		</b>
                		</font> 
            		</td>
        		</tr> 
    		</table>
    		<p>

     <%
     query="select student.name as name,student.id as id,survey." + prePost + "survey as tooktest from student,research_group_student,research_group_project,survey where research_group_student.research_group_id="+ ID + " AND research_group_project.research_group_id="+ ID +" AND research_group_student.student_id=student.id AND survey.student_id=student.id AND survey.project_id=1;";
     rs = s.executeQuery(query);
%>
    <table width="400">
    <tr><th align="left">Student</th></td></tr>
<%   while(rs.next()){
       String name=rs.getString("name");
       String studentID=rs.getString("id");
       boolean tooktest= (rs.getString("tooktest").equals("t"));
    %>
	<tr><td><%=name%> <% if (!tooktest) {
	%>
	- <A HREF="presurvey.jsp?student_id=<%=studentID%>&type=<%=prePost%>">Go take <%=prePost%>test</A>
    <%
    }
    else
    {
    %>
    - completed <%=prePost%>test.
    <%
    }
    %>
    </td></tr>
    <%
     } //while
     %>
  </table>
</body>
<%
if (s != null)
    s.close();
if (conn != null)
    conn.close();
%>
</html>
  
