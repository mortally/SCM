#!/bin/bash

java -classpath ".:lib/scmlogtool.jar" se.sics.tasim.logtool.Main -handler tests.MessageAggregatorHander -log.consoleLevel 6 -file $@ 
