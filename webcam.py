import numpy as np
import cv2
# import subprocess
row = 512
col = 512

# Video source - can be camera index number given by 'ls /dev/video*
# or can be a video file, e.g. '~/Video.avi'
# cap = cv2.VideoCapture(0)

# while(True):
    # Capture frame-by-frame
#while(1):
# ret, frame = cap.read()
frame = cv2.imread('baboon.png');  
    # Our operations on the frame come here
gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Display the resulting frame
resized = cv2.resize(gray, (row, col), interpolation = cv2.INTER_AREA)

with open('baboon.txt', 'w') as file:
    for i in range(0, 512):
            for j in range(0, 512):
                file.write(str(resized[i,j]) + "\t")
                # print(a)
            file.write('\n') 

# resized.tofile("image512.txt", sep="\t", format='%d')
# test = subprocess.Popen(["./fft"], stdout=subprocess.PIPE)
# output = test.communicate()[0]
# print(str(output, 'utf-8'))
# print("========================")
# # cv2.imwrite('photo.png',resized)

# cap.release()
# cv2.destroyAllWindows()
