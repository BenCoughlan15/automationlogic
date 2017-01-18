#!/usr/bin/env bash
# returns 0 if everything is successful, 1 if there is a problem
if [ `curl -s 10.0.15.21:80 | grep  -c -i "hello"` != 1 ]
then
 echo Problem with node: application1 '10.0.15.22'
 exit 2
fi
if [ `curl -s 10.0.15.22:80 | grep  -c -i "hello"` != 1 ]
then
 echo Problem with node: application1 '10.0.15.22'
 exit 2
fi
if [ `curl -s 10.0.15.11:80 | grep  -c -i "hello"` != 1 ]
then
 echo Problem with node: loadbalancer  `10.0.15.11`
 exit 2
fi
echo Services on application1/2 and loadbalancer appear to be running properly.
exit 0