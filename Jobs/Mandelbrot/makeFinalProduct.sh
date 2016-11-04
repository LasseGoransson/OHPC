#!/bin/bash
ls output/ | sort -n  | awk '{print "output/" $0}'  > list_prefixed.txt
convert +append $( cat list_prefixed.txt) output.png
rm list_prefixed.txt

#width=$( convert output.png -ping -format "%w" info: )
#height=$( convert output.png -ping -format "%h" info: )

#pixel=$(expr $width \* $height)

#pixel=$(expr $pixel / 1000000)
#echo $pixel

#convert output.png -fill white -box '#00770080' -gravity South -pointsize $(expr $width / 20)  -annotate +0+5 "$pixel MP" output.png
