#! /bin/bash

dir=/home/vagrant/ansible/subtasks
ext=JPG

#Create DB 
sudo mysql -uroot -p1234 -e "drop database testdb1";
sudo mysql -uroot -p1234 -e "create database testdb1";
#Populate DB

chmod a+r $dir/*.$ext
mysql -uroot -p1234 testdb1  <<eot
drop table if exists t1;
create table t1 (name varchar(128), path varchar(128)); 


INSERT INTO t1(name,path) 
VALUES('BenC1.JPG','/home/vagrant/ansible/dbdata/BenC1.JPG');
INSERT INTO t1(name,path) 
VALUES('BenC1.JPG','/home/vagrant/ansible/dbdata/BenC1.JPG');
eot
#ls -1 $dir/*.$ext | perl -e 'print "insert into t1(name,data) values ".join(",",map {chop;$f="\"".$_."\""; "($f,load_file($f))"} <>);' | mysql -uroot -p1234 testdb1