#!/usr/bin/python
import urllib
import urllib2
import random
from SimpleCV import *
import time
cam = Camera(3, {"width":200, "height":50}) # change size to something managable
#cam.live()


while True:
    data = {}
    fname = "FACE" # replaced from user input
    lname = "EYES"
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

    prikey ='#'#commented out passcode
    FEEDID =''
    FEEDID='jqwVKxlQgYTa9om26GjL'
    url_values = urllib.urlencode(data)
    url = 'http://data.sparkfun.com/input/'
    full_url = url + FEEDID + "?private_key="+prikey+"&"+ url_values

    img = cam.getImage()
    #img.save('my-image.jpg')
    img2 = img.binarize()
    #img2.listHaarFeatures()
    img.findHaarFeatures('face.xml').draw(color=Color.YELLOW) #using haar feature to find face / draws box
    eyeson=img.findHaarFeatures('eye.xml')#using haar feature to find eyes 
    img.show()
    if eyeson: # if eyes found sends data to stream / prints in console
        data = urllib2.urlopen(full_url)
        print url_values
        print "yes"
        img2.show()
    