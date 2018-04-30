#!/bin/sh

source /opt/sybase/SYBASE.sh
${SYBASE}/${SYBASE_ASE}/install/RUN_SYB_INTEGRATION

isql -Usa -SSYB_INTEGRATION -PXXX <<INPUT
disk init name="data01", physname="/opt/sybase/data/data01.dat", size="1G"
go
disk init name="log01", physname="/opt/sybase/data/log01.dat",  size="200M"
go
create database integration on data01=500 log on log01=100
go
sp_addlogin "ciuser", "XXX", "tempdb"
go
use integration
go
sp_adduser "ciuser"
go
grant all to ciuser
go
INPUT
