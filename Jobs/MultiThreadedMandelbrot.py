#!/usr/bin/python




import sys
sys.path.append("/home/lasg/")

from mpi4py import MPI
from PIL import Image
import random
import time

import os


max_iteration = 200
x_center = -1.0
y_center =  0.0
width = 12000
height = 12000
chunks = int(sys.argv[1])


chunk_width = width / chunks


comm = MPI.COMM_WORLD
rank = comm.Get_rank()

def mandelbrotchunk(chunk_width,height,chunk):

	im = Image.new("RGB", (chunk_width,height))
	for i in xrange(chunk_width*chunk,chunk_width*(chunk+1)):
	    

	    for j in xrange(height):
	
		x,y = ( x_center + 4.0*float(i-width/2)/width,
			  y_center + 4.0*float(j-width/2)/width
			)

		a,b = (0.0, 0.0)
		iteration = 0

		while (a**2 + b**2 <= 4.0 and iteration < max_iteration):
		    a,b = a**2 - b**2 + x, 2*a*b + y
		    iteration += 1
		if iteration == max_iteration:
		    color_value = 255
		else:
		    color_value = iteration*10 % 255
		ipixel = i - chunk_width*chunk		

		im.putpixel( (ipixel,j), (color_value, 120, 120))
	name = "%s.png" % chunk
	im.save("output/"+name, "PNG")



startpixel = chunk_width * rank
endpixel = startpixel + chunk_width

print "Hi, im core %s, im doing %s to %s" % (rank,startpixel,endpixel)
mandelbrotchunk(chunk_width,height,rank)
print "Farewell from core %s, data has been written to disk" % rank



