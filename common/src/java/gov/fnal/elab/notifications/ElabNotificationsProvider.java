/*
 * Created on Feb 26, 2010
 */
package gov.fnal.elab.notifications;

import gov.fnal.elab.ElabGroup;
import gov.fnal.elab.ElabProviderHandled;
import gov.fnal.elab.util.ElabException;

import java.util.List;

public interface ElabNotificationsProvider extends ElabProviderHandled {
	public static final int MAX_COUNT = 100;
	
    long getUnreadNotificationsCount(ElabGroup group) throws ElabException;
    
    List<Notification> getNotifications(ElabGroup group, int max) throws ElabException;
    
    List<Notification> getNotifications(ElabGroup group, int max, boolean includeOld) throws ElabException;
    
    List<Notification> getSystemNotifications(int count) throws ElabException;

    List<Notification> getSystemNotifications() throws ElabException;    
    
    void addNotification(ElabGroup eg, Notification n) throws ElabException; 
    
    void addNotification(List<ElabGroup> groupList, List<Integer> projectList, Notification n) throws ElabException;
    
    public void addTeacherNotification(List<ElabGroup> groupList, Notification n) throws ElabException;

    public void addUserNotification(List<ElabGroup> groupList, Notification n) throws ElabException;
    
    public void addProjectNotification(List<Integer> projectList, Notification n) throws ElabException;
    
    void markAsRead(Notification notification)  throws ElabException;
    
    public void markAsRead(String notificationId)  throws ElabException;
    
    void markAsRead(ElabGroup user, int id) throws ElabException;
    
    void markAsDeleted(ElabGroup user, int id) throws ElabException;
    
    void removeNotification(ElabGroup admin, int id) throws ElabException;
    
    public Notification getNotificationById(int id) throws ElabException;

    public String getGroupName(int groupId) throws ElabException;

    public List<Notification> getExpiredNotifications() throws ElabException; 
    
    public List<Notification> getAutomatedTestNotifications() throws ElabException;
}
