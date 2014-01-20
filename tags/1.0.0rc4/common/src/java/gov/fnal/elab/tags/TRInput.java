//----------------------------------------------------------------------
//This code is developed as part of the Java CoG Kit project
//The terms of the license can be found at http://www.cogkit.org/license
//This message may not be removed or altered.
//----------------------------------------------------------------------

/*
 * Created on Mar 21, 2007
 */
package gov.fnal.elab.tags;


import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;

public class TRInput extends TRControl {
    public int doEndTag() throws JspException {
        return EVAL_PAGE;
    }

    public int doStartTag() throws JspException {
        JspWriter out = pageContext.getOut();
        try {
            Object value = getValue();
            if ("hidden".equals(getAttribute("type"))) {
                if (value instanceof Collection) {
                    Iterator i = ((Collection) value).iterator();
                    while (i.hasNext()) {
                        writeOne(out, i.next());
                        out.write('\n');
                    }
                    commitToAnalysis(new ArrayList((Collection) value));
                }
                else if (value != null) {
                    writeOne(out, value);
                    commitToAnalysis(value);
                }
            }
            else {
                writeOne(out, value);
                commitToAnalysis(value);
            }
        }
        catch (IOException e) {
            throw new JspException(e);
        }
        return EVAL_BODY_INCLUDE;
    }

    protected void writeOne(JspWriter out, Object value) throws IOException {
        out.write("<input");
        writeAttribute(out, "name", getName());
        if (value != null) {
            writeAttribute(out, "value", value);
        }
        if (!"hidden".equals(getAttribute("type"))) {
            writeDynamicLabelUpdater(out);
        }
        writeAttributes(out);
        out.write("/>");
        if (pageContext.getRequest().getParameter(TRSubmit.CONTROL_NAME) != null
                && !isAnalysisParameterValid() && getOnError() != null) {
            out.write("<span class=\"param-error\">");
            out.write(getOnError());
            out.write("</span>");
        }
    }
}