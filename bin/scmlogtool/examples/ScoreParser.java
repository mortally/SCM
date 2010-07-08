/**
 * $Id$
 * $Date$
 * $Author$
 * $Revision$
 */
//package edu.umich.eecs.ai.scmanalysis.scoreparser;

import se.sics.tasim.logtool.LogManager;
import se.sics.isl.util.IllegalConfigurationException;
import se.sics.isl.util.ArgumentManager;

import java.io.*;
import java.util.zip.GZIPInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * The score parser gets the manufacturers scores form the game log.
 *
 * @author Patrick Jordan
 */
public class ScoreParser {
    private static ScoreParser instance = new ScoreParser();
    /**
     * The file to load.
     */
    private String filename;

    public static ScoreParser getInstance() {
        return instance;
    }


    private ScoreParser() {
    }

    public String getFilename() {
        return filename;
    }

    public static void setInstance(ScoreParser instance) {
        ScoreParser.instance = instance;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public void start() {

        String[] args = new String[]{"-handler", ScoreLogHandler.class.getName(), "-file", filename};
        ArgumentManager config = new ArgumentManager("LogManager", args);
        config.addOption("config", "configfile", "set the config file to use");
        config.addOption("file", "datafile", "set the game data file to use");
        config.addOption("games", "games", "set the games as 1-2,5,7");
        config.addOption("excludes", "games", "set the games to exclude as 1-2,5,7")
                ;
        config.addOption("server", "host", "set the server for the games");
        config.addOption("handler",
                "loghandler", "set the game data handler to use");
        config.addOption("showGUI", "true", "set if GUI should be used when supported");
        config.addOption("xml", "show the game data as XML");
        config.addOption("game.directory", "directory",
                "the local game directory");
        config.addOption("game.directory.gameTree", "false",
                "set if each game has its own directory");
        config.addOption("game.directory.serverTree", "true",
                "set if each server has its own directory with games");
        config.addOption("verbose", "set for verbose output");
        config.addOption("log.consoleLevel", "level",
                "set the console log level");
        config.addOption("version", "show the version");

        config.addHelp("h", "show this help message");
        config.addHelp("help");
        config.validateArguments();

        if (config.hasArgument("version")) {
            System.out.println("LogManager version " + LogManager.VERSION);
            System.exit(0);
        }

        // No more need for argument handling.  Lets free the memory
        config.finishArguments();

        try {
            new LogManager(config);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (IllegalConfigurationException e) {
            e.printStackTrace();
        }
    }

    /**
     * @param agentScores
     */
    public void sendScores(int[] agentScores, String[] agentNames) {
        for(int i = 0; i < agentScores.length; i++) {
            System.out.println("AGENT|"+agentNames[i]+"|"+agentScores[i]);
        }
    }

    public void printSimTainted(int start, int end) {
    	System.out.println("Tainted simulation: between day " + start + " and day " + end);
    }

    /**
     * Get a data stream that is correctly assigned to zip/normal.
     *
     * @param filename the filename
     * @return the data stream
     * @throws IOException
     */
    private static InputStream getDataStream(String filename) throws IOException {
        if (filename.endsWith(".gz")) {
            return new GZIPInputStream(new FileInputStream(filename));
        } else {
            return new FileInputStream(filename);
        }
    }
}
