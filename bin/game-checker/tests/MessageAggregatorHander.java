/**
 * $Id$
 * $Date$
 * $Author$
 * $Revision$
 */
package tests;

import se.sics.tasim.logtool.LogReader;
import se.sics.tasim.logtool.ParticipantInfo;
import se.sics.tasim.logtool.LogHandler;
import se.sics.tasim.tac05.Parser;
import se.sics.tasim.props.RFQBundle;
import se.sics.isl.util.IllegalConfigurationException;
import se.sics.isl.transport.Transportable;

import java.io.IOException;
import java.text.ParseException;

/**
 * @author Patrick Jordan
 */
public class MessageAggregatorHander extends LogHandler{

    protected void start(LogReader reader) throws IllegalConfigurationException, IOException, ParseException {
        MessageAggregatorParser parser = new MessageAggregatorParser(reader);
        parser.start();
        parser.stop();

        parser.reportCounts();
    }

    public static class MessageAggregatorParser extends Parser {
        ParticipantInfo[] participants;
        int[][][] counts;
        int[] dayswithoutMessage;
        boolean[] receivedMessage;

        int currentDay;

        protected void nextDay(int date, long serverTime) {
            for(int i = 0; i < participants.length;i++) {
                if(!receivedMessage[i])
                    dayswithoutMessage[i]++;
                receivedMessage[i] = false;
            }

            currentDay = date;
        }
        public MessageAggregatorParser(LogReader reader) {
            super(reader);
            participants = reader.getParticipants();
            dayswithoutMessage = new int[participants.length];
            receivedMessage = new boolean[participants.length];
            counts = new int[participants.length][participants.length][2];

        }

        protected void message(int sender, int receiver, Transportable content) {
            if(participants[sender].getRole()==MANUFACTURER) {
                if(participants[receiver].getRole()==SUPPLIER) {
                    if(content instanceof RFQBundle)
                        counts[sender][participants[receiver].getRole()][0]++;
                    else
                        counts[sender][participants[receiver].getRole()][1]++;
                } else if(participants[receiver].getRole()==CUSTOMER) {
                    counts[sender][participants[receiver].getRole()][0]++;
                } else {
                    counts[sender][participants[receiver].getRole()][0]++;
                }

                receivedMessage[sender] = true;
            }
        }

        protected void reportCounts() {
            for(int i = 0; i < counts.length; i++) {
                if(participants[i].getRole()==MANUFACTURER) {
                    StringBuilder builder = new StringBuilder(50);
                    builder.append(participants[i].getName());
                    builder.append(' ').append(counts[i][1][0]);
                    builder.append(' ').append(counts[i][1][1]);
                    builder.append(' ').append(counts[i][2][0]);
                    builder.append(' ').append(counts[i][3][0]);
                    builder.append(' ').append(dayswithoutMessage[i]);

                    System.out.println(builder.toString());
                }
            }
        }
    }


}
