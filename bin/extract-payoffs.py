#!/usr/bin/python
"""
   Extract the payoff from a history file given on the command line.
   Basically this just reads all of the attributes of type "agent" and
   returns the sum of the "netProfit" attribute.
"""
import sys
import xml.parsers.expat

class PayoffExtractor:
   def __init__(self, filename):
      self.file_ = filename
      self.payoff_ = [0.0, 0.0, 0.0]
	

   def startElement(self, name, attrs):
      if name == "agent":
        if attrs['name'][-1] == '1': 
          self.payoff_[0] += float(attrs['netProfit'])
        if attrs['name'][-1] == '2':
          self.payoff_[1] += float(attrs['netProfit'])
        if attrs['name'][-1] == '3':
	      self.payoff_[2] += float(attrs['netProfit'])

   def getPayoff(self):
      parser = xml.parsers.expat.ParserCreate()
      parser.StartElementHandler = self.startElement
      f = open(self.file_, "r") 
      try:
         parser.ParseFile(f)
      finally:
         f.close();
      return self.payoff_

def main():
   file = sys.argv[1]
   ex = PayoffExtractor(file)
   payoffs = ex.getPayoff()
   
   print "0" + ": " + str(payoffs[0])
   print "1" + ": " + str(payoffs[1])
   print "2" + ": " + str(payoffs[2])

if __name__ == "__main__":
   main();
