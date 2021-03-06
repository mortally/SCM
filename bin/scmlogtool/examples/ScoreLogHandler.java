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

import se.sics.tasim.visualizer.info.Manufacturer;
import se.sics.tasim.visualizer.info.Factory;
import se.sics.tasim.visualizer.info.ComponentNegotiation;
import se.sics.tasim.visualizer.info.PCType;


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

//			Manufacturer[] mfs = new Menufacturer[simInfo.getManufacturerCount()];
/*
			int numDays = simInfo.getNumberOfDays();
			PCType[] pcs = sp.getPCTypes();
			int numPCTypes = pcs.length;
			boolean simTainted = false;
			int startDay = 0, endDay = 0;
			
            for (int i = 0, n = simInfo.getManufacturerCount(); i < n; i++) {

				Manufacturer mf = simInfo.getManufacturer(i);
            	Factory fac = mf.getFactory();

				int inactiveDays = 0;
				
            	for (int j = 1; j < numDays; j++) {

					ComponentNegotiation[] cn = simInfo.getComponentNegotiation(j - 1, mf);
					boolean isInactive = true;
 					if ( (cn == null || cn.length == 0) && fac.getUtilization(j - 1) == 0.0)
 					{
 						
 						for (int k = 0; k < numPCTypes; k++) {
 						
 								if (fac.getPCHolding(k, j - 1) != fac.getPCHolding(k, j))
 								{
 									isInactive = false;
 								}
 								
 						}
 					}
 					else isInactive = false;
 					
 					if (isInactive)
 					{
 						if (inactiveDays == 0 && !simTainted) startDay = j - 1;
 						inactiveDays++;
 						if (inactiveDays == 6) 
 						{
 							if (!simTainted) endDay = j - 1;
 							simTainted = true;
 						}
 					}
 					else inactiveDays = 0;
 					
				}
				
            }

            if (simTainted) ScoreParser.getInstance().printSimTainted(startDay, endDay);*/    
        }
}
