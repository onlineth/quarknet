/*
 * Created on Jun 29, 2007
 */
package gov.fnal.elab.test;

import java.util.ArrayList;
import java.util.List;

public class ElabTestQuestion {
    private String text, id;
    private List answers;
    private ElabTestQuestionAnswer correctAnswer, givenAnswer;
    private int index;
    
    public ElabTestQuestion() {
        answers = new ArrayList();
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
    
    public List getAnswers() {
        return answers;
    }
    
    public void addAnswer(ElabTestQuestionAnswer answer) {
        if (answer.getIndex() == 0) {
            answer.setIndex(answers.size() + 1);
        }
        answers.add(answer);
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public ElabTestQuestionAnswer getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(ElabTestQuestionAnswer correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public ElabTestQuestionAnswer getGivenAnswer() {
        return givenAnswer;
    }

    public void setGivenAnswer(ElabTestQuestionAnswer givenAnswer) {
        this.givenAnswer = givenAnswer;
    }    
    
    public boolean isCorrectAnswerGiven() {
        if (correctAnswer == null) {
            return false;
        }
        else {
            return correctAnswer.equals(givenAnswer);
        }
    }
}
