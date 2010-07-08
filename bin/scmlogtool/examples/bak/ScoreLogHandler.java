/**
 * $Id$
 * $Date$
 * $Author$
 * $Revision$
 */
//package edu.umich.eecs.ai.scmanalysis.scoreparser;

import se.sics.tasim.logtool.LogHandler;
import se.sics.tasim.logtool.LogReader;
import se.sics.tasim.visualizer.util.SimulationParser;
import se.sics.tasim.visualizer.info.SimulationInfo;
import se.sics.isl.util.IllegalConfigurationException;

import java.io.IOException;
import java.text.ParseException;

/**
 * @author Patrick Jordan
 */
public class ScoreLogHandler extends LogHandler {

        /**
         * Get the scores from the SICS log file.
         *
         * @param reader the log reader              q
         * @throws se.sics.isl.util.IllegalConfigurationException
         * @throws java.io.IOException
         * @throws java.text.ParseException
         */
        protected void start(LogReader reader) throws IllegalConfigurationException, IOException, ParseException {
            SimulationParser sp = new SimulationParser(this, reader);

            sp.start();
            SimulationInfo simInfo = new SimulationInfo(sp);

            int[] agentScores = new int[simInfo.getManufacturerCount()];
            String[] agentNames = new String[simInfo.getManufacturerCount()];

            for (int i = 0, n = simInfo.getManufacturerCount(), d = simInfo.getNumberOfDays(); i < n; i++) {
                agentNames[i] = simInfo.getManufacturer(i).getName();
                agentScores[i] = simInfo.getManufacturer(i).getAccountBalance(d - 1);
            }

            ScoreParser.getInstance().sendScores(agentScores, agentNames);
        }
}
