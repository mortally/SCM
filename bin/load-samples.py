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

    count = 3
    for sim_path in botdirs:
        if sim_path == ".svn":
            continue
        if sim_path == ".DS_Store":
            continue
        #For each simulation directory
        game_log_path = os.path.join(profile_path,sim_path,"combined-history.xml")
        #print game_log_path
        if os.path.exists(game_log_path):
            if(count < 10):
                os.system("cp "+game_log_path+" /home/deepmaize/deploy/shared/samples/0000/000"+count)
            else:
                os.system("cp "+game_log_path+" /home/deepmaize/deploy/shared/samples/0000/00"+count)
            count = count + 1





if __name__ == "__main__":
    main(sys.argv)
