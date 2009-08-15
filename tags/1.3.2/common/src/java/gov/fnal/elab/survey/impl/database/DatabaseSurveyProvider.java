package gov.fnal.elab.survey.impl.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Savepoint;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import com.mallardsoft.tuple.*;

import gov.fnal.elab.Elab;
import gov.fnal.elab.ElabGroup;
import gov.fnal.elab.ElabProvider;
import gov.fnal.elab.ElabStudent;
import gov.fnal.elab.survey.ElabSurvey;
import gov.fnal.elab.survey.ElabSurveyProvider;
import gov.fnal.elab.survey.ElabSurveyQuestion;
import gov.fnal.elab.survey.ElabSurveyQuestionAnswer;
import gov.fnal.elab.util.DatabaseConnectionManager;
import gov.fnal.elab.util.ElabException;

public class DatabaseSurveyProvider implements ElabSurveyProvider, ElabProvider {
	
	private Elab elab;
	private Map<Integer, ElabSurvey> tests; 
	
	public DatabaseSurveyProvider()  {
		tests = new HashMap<Integer, ElabSurvey>();
	}
	
	public void setElab(Elab elab) {
        this.elab = elab;
    }

	public ElabSurveyQuestion getSurveyQuestion(int surveyId, int questionId, int responseId) throws ElabException {
		Connection con = null; 
		ElabSurveyQuestion esq = null; 
		try { 
			con = DatabaseConnectionManager.getConnection(elab.getProperties());
			PreparedStatement queryQuestion = con.prepareStatement(
					"SELECT q.id AS \"question_id\", m.question_no, q.question_text, q.answer_id, r.response_no, r.id, r.response_text " +
					"FROM \"newSurvey\".questions AS q " +
					"LEFT OUTER JOIN \"newSurvey\".responses AS r ON r.question_id = q.id " +
					"LEFT OUTER JOIN \"newSurvey\".map_questions_tests AS m ON (q.id = m.question_id) " +
					"WHERE q.id = ? AND m.test_id = ?" +
					"ORDER BY r.response_no ASC;");
			queryQuestion.setInt(1, questionId);
			queryQuestion.setInt(2, surveyId);
			
			ResultSet rs = queryQuestion.executeQuery();
			while (rs.next()) {
				int thisQuestionId = rs.getInt("question_id");
				int thisQuestionNo = rs.getInt("question_no");
				String thisQuestionText = rs.getString("question_text");
				int thisQuestionCorrectAnswerId = rs.getInt("answer_id");
				int thisAnswerId = rs.getInt("id");
				int thisResponseNo = rs.getInt("response_no");
				String thisAnswerText = rs.getString("response_text");
				
				if (esq == null) {
					esq = new ElabSurveyQuestion(thisQuestionId, thisQuestionNo, thisQuestionText);
				}
				
				// Create an answer
				ElabSurveyQuestionAnswer currentAnswer = new ElabSurveyQuestionAnswer(thisAnswerId, thisAnswerText, thisResponseNo);
				
				// Add the answer into the current question
				esq.addAnswer(currentAnswer);
				
				// If this is the correct answer, set it. 
				if (thisAnswerId == thisQuestionCorrectAnswerId) {
					esq.setCorrectAnswer(currentAnswer);
				}
				
				// If this is the given answer, set it. 
				if (thisAnswerId == responseId) {
					esq.setGivenAnswer(responseId);
				}
			}
		}
		catch (Exception e) {
			throw new ElabException(e);
		}
		finally {
			DatabaseConnectionManager.close(con);
		}
		
		return esq;
	}
			
	
	public ElabSurvey getSurvey(int surveyId) throws ElabException {
		synchronized (this.tests) {
            if (this.tests.containsKey(new Integer(surveyId))) {
                return this.tests.get(new Integer(surveyId));
            }
        }		
		
		ElabSurvey survey = null;
		Connection con = null; 
		try {
			con = DatabaseConnectionManager.getConnection(this.elab.getProperties());
			PreparedStatement querySurvey = con.prepareStatement(
					"SELECT * FROM \"newSurvey\".tests WHERE id = ?;");
			querySurvey.setInt(1, surveyId);
			ResultSet rs1 = querySurvey.executeQuery();
			if (rs1.next()) {
				survey = new ElabSurvey(rs1.getString("description"), rs1.getInt("id"));
				
				PreparedStatement ps = con.prepareStatement(
						"SELECT q.id AS \"question_id\", m.question_no, q.question_text, q.answer_id, r.response_no, r.id, r.response_text " +
						"FROM \"newSurvey\".questions AS q " + 
						"LEFT OUTER JOIN \"newSurvey\".responses AS r ON (q.id = r.question_id) " +
						"LEFT OUTER JOIN \"newSurvey\".map_questions_tests AS m ON (q.id = m.question_id) " +
						"WHERE m.test_id = ? " +
						"ORDER BY m.question_no ASC, r.response_no ASC;");
						
				ps.setInt(1, surveyId);
				ResultSet rs = ps.executeQuery();
				
				ElabSurveyQuestion currentQuestion = null; 
				while (rs.next()) {
					int thisQuestionId = rs.getInt("question_id");
					int thisQuestionNo = rs.getInt("question_no");
					String thisQuestionText = rs.getString("question_text");
					int thisQuestionCorrectAnswerId = rs.getInt("answer_id");
					int thisResponseNo = rs.getInt("response_no");
					int thisAnswerId = rs.getInt("id");
					String thisAnswerText = rs.getString("response_text");
					
					// If ID changes or this is the first row (null question), make a new question
					if ((currentQuestion == null) || (currentQuestion.getId() != thisQuestionId)) {
						if (currentQuestion != null) {
							survey.addQuestion(currentQuestion);
						}
						currentQuestion = new ElabSurveyQuestion(thisQuestionId, thisQuestionNo, thisQuestionText);
					}
					
					// Create an answer
					ElabSurveyQuestionAnswer currentAnswer = new ElabSurveyQuestionAnswer(thisAnswerId, thisAnswerText, thisResponseNo);
					
					// Add the answer into the current question
					currentQuestion.addAnswer(currentAnswer);
					
					// If this is the correct answer, set it. 
					if (thisAnswerId == thisQuestionCorrectAnswerId) {
						currentQuestion.setCorrectAnswer(currentAnswer);
					}
				}
				if (currentQuestion != null) {
					survey.addQuestion(currentQuestion);
				}
			}
		}
		catch (Exception e) {
			throw new ElabException(e);
		}
		finally {
			DatabaseConnectionManager.close(con);
		}
		
		synchronized(this.tests) {
			this.tests.put(new Integer(surveyId), survey);
		}
		
		return survey; 
		
	}
	
	public void RecordCompletion(int surveyId, int studentId, String type, List<Integer> answers) throws ElabException {
		
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		
		Savepoint svpt = null; 
		Connection con = null;
		
		try {
			ResultSet rs = null; 
			con = DatabaseConnectionManager.getConnection(elab.getProperties());
			
			// Set rollback point in case the transaction fails. 
			con.setAutoCommit(false);
			svpt = con.setSavepoint();
			
			// TODO: Insert a new completion for the student
			// Need student ID, test ID, time, type
			PreparedStatement insertCompletion = con.prepareStatement(
					"INSERT INTO \"newSurvey\".completions " +
					"(test_id, time, student_id, type) " +
					"VALUES (?, ?, ?, ?);");
			insertCompletion.setInt(1, surveyId);
			insertCompletion.setTimestamp(2, ts); 
			insertCompletion.setInt(3, studentId);
			insertCompletion.setString(4, type);
			insertCompletion.executeUpdate(); 
			
			// TODO: Get lastval() for for the generated completion ID 
			int completionId = -1;
			PreparedStatement queryCompletionId = con.prepareStatement("SELECT lastval(); ");
			rs = queryCompletionId.executeQuery(); 
			if (rs.next()) {
				completionId = rs.getInt(1);
			}
			else {
				throw new SQLException("No data back from the prepared statement");
			}
			
			// TODO: Insert all the answers
			// Need response ID, completion ID; 
			for (Integer answer : answers) {
				PreparedStatement insertAnswer = con.prepareStatement(
						"INSERT INTO \"newSurvey\".answers " +
						"(response_id, completion_id) " +
						"VALUES (?, ?); ");
				insertAnswer.setInt(1, answer.intValue());
				insertAnswer.setInt(2, completionId);
				insertAnswer.executeUpdate();
			}
			
			// Commit the transaction. 
			con.commit();
			con.setAutoCommit(true);
		}
		catch (Exception e) {
			try {
				if (con != null) {
					con.rollback(svpt);
					con.setAutoCommit(true);
				}
			}
			catch (SQLException ex) {
				throw new ElabException(ex);
			}
			finally {
				DatabaseConnectionManager.close(con);
			}
			throw new ElabException(e);
		}
		finally {
			DatabaseConnectionManager.close(con);
		}
	}
	
	public boolean hasStudentTakenTest(int surveyId, int studentId, String type) throws ElabException {
		// TODO: Probably should have an enumerated type! 
		
		boolean taken = false; 
		Connection con = null;
		
		try {
			con = DatabaseConnectionManager.getConnection(elab.getProperties()); 
			
			PreparedStatement ps = con.prepareStatement(
					"SELECT id FROM \"newSurvey\".completions " +
					"WHERE student_id = ? AND test_id = ? AND type = ?;");
			ps.setInt(1, studentId);
			ps.setInt(2, surveyId); 
			ps.setString(3, type.toLowerCase());
			
			ResultSet rs = ps.executeQuery(); 
			
			if (rs.next()) {
				taken = true;
			}
		}
		catch (Exception e) {
			throw new ElabException(e); 
		}
		finally {
			DatabaseConnectionManager.close(con);
		}
		
		return taken; 
	}
	
	public int getTotalStudents(ElabGroup group) throws ElabException {
		Connection con = null; 
		int total = -1; 
		try { 
			con = DatabaseConnectionManager.getConnection(elab.getProperties());
			PreparedStatement ps = con.prepareStatement(
					"SELECT COUNT(rg.id) " +
					"FROM research_group AS rg " +
					"LEFT OUTER JOIN research_group_student AS rgs ON rg.id = rgs.research_group_id " +
					"LEFT OUTER JOIN research_group_project AS rgp ON rg.id = rgp.research_group_id " +
					"WHERE rg.id = ? AND rgp.project_id = ?;");
			ps.setInt(1, Integer.parseInt(group.getId()));
			ps.setInt(2, Integer.parseInt(elab.getId()));
			
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				total = rs.getInt(1);
			}
			else {
				total = 0; 
			}
		}
		catch (Exception e) {
			throw new ElabException(e);
		}
		finally {
			DatabaseConnectionManager.close(con);
		}
		return total;
	}

	public int getTotalTaken(String type, ElabGroup group) throws ElabException {
		Connection con = null;
		int surveyId = group.getNewSurveyId().intValue();
		int total = -1; 
		try {
			con = DatabaseConnectionManager.getConnection(elab.getProperties());			
			PreparedStatement ps = con.prepareStatement(
					"SELECT COUNT(student_id) " +
					"FROM \"newSurvey\".completions " +
					"WHERE test_id = ? AND type = ? AND student_id IN " +
					"(SELECT student.id FROM student, research_group_student, research_group_project " +
						"WHERE research_group_student.research_group_id = ? " +
						"AND research_group_project.research_group_id = ? " +
						"AND research_group_student.student_id = student.id); "); 
			ps.setInt(1, surveyId);
			ps.setString(2, type);
			ps.setInt(3, Integer.parseInt(group.getId()));
			ps.setInt(4, Integer.parseInt(group.getId()));
						
			ResultSet rs = ps.executeQuery(); 
			if (rs.next()) {
				total = rs.getInt(1);
			}
			else {
				total = 0; 
			}
			 
		}
		catch (Exception e) {
			throw new ElabException(e);
		}
		finally {
			DatabaseConnectionManager.close(con);
		}
		
		return total; 
		
	}

	public Map<ElabStudent, Boolean> getStudentSurveyStatus(String type, ElabGroup group) throws ElabException {
		Connection con = null; 
		Map<ElabStudent, Boolean> status = null;
		int surveyId;
		if (group.getNewSurveyId() != null) {
			surveyId = group.getNewSurveyId().intValue();
			try {
				con = DatabaseConnectionManager.getConnection(elab.getProperties());			
				ResultSet rs = null; 
				status = new HashMap<ElabStudent, Boolean>(); 

				for (Iterator<ElabStudent> i = group.getStudents().iterator(); i.hasNext(); ) {
					ElabStudent student = i.next();
					PreparedStatement ps = con.prepareStatement(
							"SELECT id FROM \"newSurvey\".completions " +
							"WHERE student_id = ? AND test_id = ? AND type = ?; ");
					ps.setInt(1, Integer.parseInt(student.getId()));
					ps.setInt(2, surveyId);
					ps.setString(3, type);
					
					rs = ps.executeQuery();
					if (rs.next()) {
						status.put(student, Boolean.valueOf(true));
					}
					else {
						status.put(student, Boolean.valueOf(false));
					}
				}
				 
			}
			catch (Exception e) {
				throw new ElabException(e);
			}
			finally {
				DatabaseConnectionManager.close(con);
			}
		}
		return status;
	}
	
	public Map<ElabGroup, Map<ElabStudent, List<ElabSurveyQuestion>>> getStudentResultsForTeacher(String type, ElabGroup group) throws ElabException {
		Connection con = null;
		Map<ElabStudent, List<ElabSurveyQuestion>> thisGroup = null; 
				
		Map<ElabGroup, Map<ElabStudent, List<ElabSurveyQuestion>>> results = null; 
		
		try {
			con = DatabaseConnectionManager.getConnection(elab.getProperties());
			results = new HashMap(); 
			for (Iterator<ElabGroup> g = group.getGroups().iterator(); g.hasNext(); ) {
				ElabGroup eg = g.next();
				if (eg.getNewSurveyId() == null) {
					continue; 
				}
				ElabSurvey survey = this.getSurvey(eg.getNewSurveyId().intValue());
				thisGroup = new HashMap(); 
				for (Iterator<ElabStudent> s = eg.getStudents().iterator(); s.hasNext(); ) {
					ElabStudent es = s.next();
					List<ElabSurveyQuestion> questions = new ArrayList<ElabSurveyQuestion>(); 
					for (Iterator<ElabSurveyQuestion> q = survey.getQuestionsById().iterator(); q.hasNext(); ) {
						ElabSurveyQuestion question = (ElabSurveyQuestion) q.next().clone();
						PreparedStatement ps = con.prepareStatement(
								"SELECT a.response_id AS \"ans_ptr\",  c.time " +
								"FROM \"newSurvey\".answers AS a " +
								"LEFT OUTER JOIN \"newSurvey\".responses AS r ON (a.response_id = r.id) " +
								"LEFT OUTER JOIN \"newSurvey\".questions AS q ON (r.question_id = q.id) " +
								"LEFT OUTER JOIN \"newSurvey\".completions AS c ON (c.id = a.completion_id) " +
								"LEFT OUTER JOIN \"newSurvey\".map_questions_tests AS m on (q.id = m.question_id) " +
								"WHERE c.student_id = ? AND c.type = ? AND q.id = ? "
								);
						ps.setInt(1, Integer.parseInt(es.getId()));
						ps.setString(2, type);
						ps.setInt(3, question.getId());
						
						ResultSet rs = ps.executeQuery(); 
						if (rs.next()) {
							// set given answer
							int givenAnswerId = rs.getInt("ans_ptr");
							Date answeredDate = rs.getDate("time");
							question.setAnsweredTime(answeredDate);
							question.setGivenAnswer(givenAnswerId);
							questions.add(question);
						}
						
					}
					java.util.Collections.sort(questions);
					thisGroup.put(es, questions);
				}
				results.put(eg, thisGroup);
			}
		}
		catch (Exception e) {
			throw new ElabException(e);
		}
		finally {
			DatabaseConnectionManager.close(con);
		}
	
		return results; 
	}

}
