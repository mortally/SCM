#!/bin/bash

java -classpath "/home/dong/Work/SCM/bin/scmlogtool/examples:/home/dong/Work/SCM/bin/scmlogtool/:..:." se.sics.tasim.logtool.Main -handler ScoreLogHandler $@
