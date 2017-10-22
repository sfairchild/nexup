#!/usr/bin/python

# import picamera
import RPi.GPIO as GPIO
import sys
from time import sleep

# camera = picamera.PiCamera()
# camera.resolution = (540, 405)
# camera.rotation = 90
# camera.brightness = 70
# camera.image_effect = 'none'

GPIO.setmode(GPIO.BOARD)
GPIO.setup(03, GPIO.OUT)
pwm=GPIO.PWM(03, 50)
pwm.start(0)
def SetAngle(angle):
  duty = angle / 18 + 2
  GPIO.output(03, True)
  pwm.ChangeDutyCycle(duty)
  sleep(1)
  GPIO.output(03, False)
  pwm.ChangeDutyCycle(0)

SetAngle(int(sys.argv[1]))
# camera.capture('public/images/stills/' + sys.argv[2])
pwm.stop()
GPIO.cleanup()

