//----------------------------------------------------------------------
//This code is developed as part of the Java CoG Kit project
//The terms of the license can be found at http://www.cogkit.org/license
//This message may not be removed or altered.
//----------------------------------------------------------------------

/*
 * Created on Mar 22, 2007
 */
package gov.fnal.elab.datacatalog.query;

public class GreaterThan extends QueryLeaf {
    public GreaterThan(String key, Object value) {
        super(QueryElement.TYPES.GT, key, value);   
    }
}