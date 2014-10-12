#!/usr/bin/python
# Importing the module
import urllib2
import random
from SimpleCV import *
import time
import pygame
import csv

pygame.mixer.init()


while True:
	
	url = 'http://data.sparkfun.com/output/jqwVKxlQgYTa9om26GjL.cvs'
	#url = 'http://data.sparkfun.com/output/yAnZOd1KQ6IzNRMr6jM1.cvs'
	response = urllib2.urlopen(url)
	cr = csv.reader(response)
	# Setup an empty list


	#parsed_data = []
	fields = cr.next()
    # Skip over the first line of the file for the headers
	#print "l"
	ramp=[]
	sin=[]
	square=[]

	
	for row in cr:
    	#parsed_data.append(dict(zip(fields, row)))
    		ramp.append(int(row[1]))
    	#print row[1]
    		sin.append(float(row[2]))
    		square.append(int(row[3]))
	print ramp[0]
	print sin[0]
	print square[0]
	playtime=random.randint(1, 10)
	print playtime

	if ramp[0]>100:
		fi=6

	if ramp[0]>200:
		fi=5

	if ramp[0]>300:
		fi=4

	if ramp[0]>400:
		fi=3

	if ramp[0]>500:
		fi=2

	if ramp[0]>600:
		fi=1
	r=abs(sin[0])
	#r=abs(random.random())
	#print `r`
	pygame.mixer.music.set_volume(r)
	#print` abs(random.random())`
	#pygame.mixer.music.set_volume(abs(sin[0]))
	pygame.mixer.music.load(`fi`+".wav")
	pygame.mixer.music.play()	

	#while pygame.mixer.music.get_busy() == True:
		#continue
	time.sleep(square[0])



