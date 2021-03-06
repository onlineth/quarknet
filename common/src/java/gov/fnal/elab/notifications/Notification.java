/*
 * Created on Feb 26, 2010
 */
package gov.fnal.elab.notifications;

import edu.emory.mathcs.backport.java.util.Collections;
import gov.fnal.elab.ElabGroup;
import gov.fnal.elab.datacatalog.StructuredResultSet.Month;

import java.sql.Timestamp;
import java.util.*;

public class Notification implements Comparable<Notification>{
	public static enum MessageType {
		NORMAL(0),
		SYSTEM(1),
		SYSTEM_NORMAL(2);
		
		private static final Map<Integer, MessageType> reverse; 
		
		private final int dbCode; 
		
		static {
			reverse = new HashMap();
			for (MessageType mt : EnumSet.allOf(MessageType.class)) {
				reverse.put(mt.getDBCode(), mt);
			}
		}
		
		private MessageType(int dbCode) {
			this.dbCode = dbCode; 
		}
		
		public int getDBCode() {
			return dbCode; 
		}
		
		public static MessageType fromCode(int value) {
			MessageType ret = reverse.get(value);
			if (ret == null) {
				throw new IllegalArgumentException();
			}
			return ret; 
		}
	}
    
    private int id;
    private String message = "";
    private long creation = System.currentTimeMillis(), expiration; 
    private boolean read = false, deleted = false, broadcast = false;
    private MessageType type = MessageType.NORMAL;
    private int creatorGroupId;
    private String sender, addressee;
    
    public Notification() {
    }
    
    public Notification(int id, String message, int creatorGroupId, long creation, long expiration, int type,
            boolean read, boolean deleted) {
        this.id = id;
        this.message = message;
        this.creatorGroupId = creatorGroupId;
        this.read = read;
        this.type = MessageType.fromCode(type);
        this.creation = creation; 
        this.expiration = expiration; 
        this.deleted = deleted;
        this.sender = "";
        this.addressee = "";
    }
        
    public int compareTo(Notification n) {
    	return n.getTimeAsDate().compareTo(this.getTimeAsDate());
    }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }    
 
    public String getAddressee() {
        return addressee;
    }

    public void setAddressee(String addressee) {
        this.addressee = addressee;
    }    
    
    public int getCreatorGroupId() {
        return creatorGroupId;
    }

    public void setCreatorGroupId(int creatorGroupId) {
        this.creatorGroupId = creatorGroupId;
    }

    public long getCreationDate() {
        return creation;
    }

    public void setCreationDate(long creation) {
        this.creation = creation; 
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public boolean getBroadcast() {
        return broadcast;
    }

    public void setBroadcast(boolean broadcast) {
        this.broadcast = broadcast;
    } 
    
    public MessageType getType() {
        return type;
    }

    public void setType(MessageType type) {
        this.type = type;
    }

    public long getExpirationDate() {
        return expiration;
    }

    public void setExpirationDate(long expiration) {
        this.expiration = expiration;
    }
    
    public boolean isBroadcast() {
    	return broadcast; 
    }
    
    public Date getTimeAsDate() {
    	return new Date(creation);
    }
    
    public Date getExpirationAsDate() {
    	return new Date(expiration);
    }
    
    public boolean getDeleted() {
    	return deleted;
    }
    
    public void setDeleted(boolean deleted) {
    	this.deleted = deleted;
    }
    
}
