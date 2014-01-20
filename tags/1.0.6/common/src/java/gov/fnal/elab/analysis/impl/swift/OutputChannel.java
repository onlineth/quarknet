//----------------------------------------------------------------------
//This code is developed as part of the Java CoG Kit project
//The terms of the license can be found at http://www.cogkit.org/license
//This message may not be removed or altered.
//----------------------------------------------------------------------

/*
 * Created on Oct 2, 2006
 */
package gov.fnal.elab.analysis.impl.swift;

import java.util.StringTokenizer;

import org.globus.cog.karajan.arguments.AbstractWriteOnlyVariableArguments;

public class OutputChannel extends AbstractWriteOnlyVariableArguments {
	private StringBuffer sb;
	private int patternCounter;
	private String pattern;
	private String prefix;

	public OutputChannel(String prefix) {
		sb = new StringBuffer();
		this.prefix = prefix;
	}

	public void setPattern(String pattern) {
		this.pattern = pattern;
	}

	public synchronized void append(Object value) {
		String str = String.valueOf(value);
		if (pattern != null) {
			int last = -1;
			while (true) {
				last = str.indexOf(pattern, last + 1);
				if (last == -1) {
					break;
				}
				patternCounter++;
			}
		}
		StringTokenizer st = new StringTokenizer(str, "\n\r");
		while (st.hasMoreTokens()) {
		    System.out.println(prefix + ": " + st.nextToken());
		}
		sb.append(str);
	}

	public boolean isCommutative() {
		return true;
	}

	public String toString() {
		return sb.toString();
	}

	public int getPatternCounter() {
		return patternCounter;
	}
}