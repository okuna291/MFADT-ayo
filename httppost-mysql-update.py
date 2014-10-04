#!/usr/bin/python
import urllib
import urllib2
import time
import random

import MySQLdb as mdb
con = mdb.connect('localhost', '##', '##', '##'); # commented out passwords
# stream https://data.sparkfun.com/streams/jqwVKxlQgYTa9om26GjL



while True:
	data = {}
	fname = raw_input("Enter your First Name:   ")# input from user
	lname = raw_input("Enter your Last Name:   ")# input from user
	xval=random.randint(1, 255)
	yval=random.randint(1, 255)
	zval=random.randint(1, 255)
	row=random.randint(1, 10)

	data['device'] = "Python"
	data['xval'] = xval
	data['yval'] = yval
	data['zval'] = zval
	data['fname'] = fname
	data['lname'] = lname
	data['row'] = row
	with con:
    		cur = con.cursor() # connect to database update
    		cur.execute("UPDATE Artifacts SET Name = %s, Last = %s,xVal = %s,yVal = %s,zVal = %s WHERE Id = %s", 
        	(fname, lname,xval,yval,zval,row))
        	print "Number of rows updated:",  cur.rowcount

	
	
	prikey ='##' # commented out passwords
	FEEDID =''
	FEEDID='jqwVKxlQgYTa9om26GjL'
	url_values = urllib.urlencode(data)
	print url_values  # The order may differ. 
#name=Somebody+Here&language=Python&location=Northampton
	url = 'http://data.sparkfun.com/input/'
	full_url = url + FEEDID + "?private_key="+prikey+"&"+ url_values
	data = urllib2.urlopen(full_url) # send data to stream

	time.sleep(10)

