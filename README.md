# Bacon Number

### Overview

**Bacon Number** will calculate the number of hops and the path needed to transverse from a given starting Wikiepedia topic to Wikiepedia's entry for *Kevin Bacon*

`bacon_number` builds a tree fanning out from the starting topic, it builds the tree in a breadth first manner. It will stop once it reaches Kevin Bacon's page.


### Usage

There are some dependancies, so make sure to run bundler first

	bundle install
	
Next ponder your choice of goal topic. A good one is *Apollo Lunar Module*

	ruby bacon_number.rb for 'Apollo Lunar Module'
	
This should return the message:

	BACON NUMBER IS: 2
	Found Path: Apollo Lunar Module -> Apollo 13 (film) -> Kevin Bacon
	
Check the **HELP** message for information about options

	ruby bacon_number.rb help for
	
You can increase the number of threads `bacon_number` uses, the default is 70 which seems to be a good choice on my development system. CPU stays busy and net requests stay saturated without too many context switches. 

If you do not find your bacon number you can try to increase your max search depth, default is 3.
