#!/usr/bin/python

import picamera
from time import sleep
import time
import RPi.GPIO as GPIO
from os import system
import os
import sys

########################
#
# Behaviour Variables
#
########################
num_frame = 4       # Number of frames in Gif
gif_delay = 15      # Frame delay [ms]

########################
#
# Camera
#
########################
camera = picamera.PiCamera()
camera.resolution = (540, 405)
camera.rotation = 0
# camera.brightness = 70
camera.image_effect = 'none'
# camera.zoom = (sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])

try:
      print('Gif capture Started')
      for i in range(num_frame + 5):
          time.sleep(.25)
          camera.capture('{0:04d}.jpg'.format(i))

      print('Gif capture done')

      ### PROCESSING GIF ###
      for i in range(num_frame - 2):
          source = str(num_frame - i + 5) + ".jpg"
          source = source.zfill(8)
                        
      filename = '/home/pi/app/public/images/gifs/' + sys.argv[1]
      graphicsmagick = "gm convert -delay " + str(gif_delay * 3) + " " + "*.jpg " + filename
      os.system(graphicsmagick)
      os.system("rm ./*.jpg") # cleanup source images
      os.system("cd public/ && ls -tp | grep -v '/$' | tail -n +100 | xargs -I {} rm -- {} && cd ..") # cleanup source images
except:
    GPIO.cleanup()
