#!/usr/bin/python

import os
import sys

#Argv[1] = profile base directory
#Argv[2] = simulation id
#Argv[3] = simulation size
def main(argv):
    profile_path = argv[1]
    botdirs = os.listdir(argv[1])

    if len(botdirs) == 0:
        sys.stderr.write("No directories to process in: '" + argv[1] + "'.\n")

    host_ = "aifa.eecs.umich.edu"
    port_ = "3000"
    username_ = "asleep"
    pwrd_ = "password"
    sim_id = argv[2]

    count = 0
    for sim_path in botdirs:
        if sim_path == ".svn":
            continue
        if sim_path == ".DS_Store":
            continue
        #For each simulation directory
        game_log_path = os.path.join(profile_path,sim_path,"combined-history.xml")
        #print game_log_path
        if os.path.exists(game_log_path):
            os.system("sh submit-log "+host_+" "+port_+" "+username_+" "+pwrd_+" "+sim_id+" "+game_log_path)
            count = count + 1
        else:
            print sim_path+" does not have combined-history.xml"

    print count








if __name__ == "__main__":
    main(sys.argv)
