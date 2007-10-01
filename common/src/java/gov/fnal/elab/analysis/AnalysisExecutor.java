/*
 * Created on Apr 18, 2007
 */
package gov.fnal.elab.analysis;

import gov.fnal.elab.Elab;

/**
 * This interface describes the functionality required by elabs from a analysis
 * execution engine.
 */
public interface AnalysisExecutor {
    /**
     * Starts an analysis and returns the run object associated with its
     * execution.
     * 
     * @param analysis
     *            The analysis to start *
     * @param elab
     *            The elab in which the analysis is being done
     * 
     * @param outputDir
     *            The run/output directory
     *            
     * @return The run object associated with the execution of the analysis.
     */
    AnalysisRun start(ElabAnalysis analysis, Elab elab, String runDir);
}
