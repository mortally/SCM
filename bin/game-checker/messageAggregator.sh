#!/bin/bash

java -server -classpath "/home/dong/Work/SCM/bin/scmlogtool/examples:/home/dong/Work/SCM/bin/scmlogtool:/home/dong/Work/SCM/bin/game-checker/tests:/home/dong/Work/SCM/bin/game-checker" se.sics.tasim.logtool.Main -handler tests.MessageAggregatorHander -log.consoleLevel 6 -file $@ 2> /dev/null | grep "^[^(Processing)]"
