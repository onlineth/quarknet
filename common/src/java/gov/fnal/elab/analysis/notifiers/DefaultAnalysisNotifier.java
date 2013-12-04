/*
 * Created on Feb 27, 2010
 */
package gov.fnal.elab.analysis.notifiers;

import gov.fnal.elab.*;
import gov.fnal.elab.Elab;
import gov.fnal.elab.ElabFactory;
import gov.fnal.elab.analysis.AnalysisNotifier;
import gov.fnal.elab.analysis.AnalysisRun;
import gov.fnal.elab.analysis.AnalysisRunListener;
import gov.fnal.elab.notifications.ElabNotificationsProvider;
import gov.fnal.elab.notifications.Notification;
import gov.fnal.elab.util.ElabException;
import java.util.*;
import gov.fnal.elab.usermanagement.*;
import gov.fnal.elab.usermanagement.impl.*;

public class DefaultAnalysisNotifier implements AnalysisRunListener, AnalysisNotifier {
    private AnalysisRun run;

    public void setRun(AnalysisRun run) {
        this.run = run;
    }

    public void runStatusChanged(int status) {
        if (status == AnalysisRun.STATUS_FAILED || status == AnalysisRun.STATUS_COMPLETED) {
            boolean failed = AnalysisRun.STATUS_FAILED == status;
            Elab elab = run.getAnalysis().getElab();
            ElabNotificationsProvider np = ElabFactory.getNotificationsProvider(elab);
            Notification n = new Notification();
            n.setCreatorGroupId(run.getAnalysis().getUser().getId());
            String s = failed ? "failed" : "completed";
            n.setMessage("<a href=\"../analysis/status.jsp?id=" + run.getId() + "\">" + run.getAnalysis().getName() + "</a> " + s);
        	GregorianCalendar gc = new GregorianCalendar();
        	//EPeronja-have to check how long we want this to stay until it expires
        	gc.add(Calendar.DAY_OF_MONTH, 2);
        	n.setExpirationDate(gc.getTimeInMillis());
            try {
        	    List<ElabGroup> groupsToNotify = new ArrayList();
        	    groupsToNotify.add(run.getAnalysis().getUser());
                List<Integer> projectIds = new ArrayList<Integer>();
                projectIds.add(elab.getId());
                np.addNotification(groupsToNotify, projectIds, n);
                run.setAttribute("notification-id", n.getId());
            }
            catch (ElabException e) {
                System.err.println("Failed to send notification");
                e.printStackTrace();
            }
        }
    }
}
