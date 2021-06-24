#!/bin/bash

#
# System check for vbox
#

ExitError=0

function WriteToSysLog() {
  logger -s -i $@
  echo $@ >&2
}

function CheckService() {
    (systemctl status $1 >/dev/null || systemctl restart $1) || WriteToSysLog Syscheck-Error: Service $1 not restarted
}

function CheckMountPoints() {
    (findmnt $1 > /dev/null || mount $1) || WriteToSysLog Syscheck-Error: Mount $1 not found and cannot be mounted.
}

function CheckVM() {
    count=9
    (virsh domstate $1 | grep running) && return || (virsh start $1)
    while [ $count -ne 0 ] ; do
        sleep 10
        (virsh domstate $1 | grep running) && return || let count=count-1
    done
    (virsh domstate $1 | grep running) || WriteToSysLog Syscheck-Error: Guest $1 not running
}

# Check if pause-check has been left "on"                                       
function CheckPause() {                                                         
    local l_CheckFiles=$1                                                       
    local l_ModifiedTime=$2                                                     
    if  $(test -a $l_CheckFiles) ; then                                         
       if [[ $(find $l_CheckFiles -mmin +$l_ModifiedTime | wc -l) > 0 ]] ; then 
         (echo -e "To:mark@tonneson.home\nSubject: Pause-Checks older than $l_ModifiedTime minutes\n" ; hostname ; find $l_CheckFiles -mmin +$l_ModifiedTime) | /usr/sbin/sendmail -t
       fi                                                                       
    fi                                                                          
}                                                                               

# Mountpoints
for mnt in /home /opt/vbox/config /opt/vbox/media /opt/vbox/machines /opt/vbox/nvme /opt/vbox/raid /mnt/freenas/general /mnt/freenas/vmstorage ; do
    CheckMountPoints $mnt
done
                                                                                
# Services
#for svc in chronyd cockpit crond nut-driver nut-monitor nut-server sshd ; do
for svc in chronyd cockpit crond httpd sshd virt-who ; do
    CheckService $svc
done

# Check to Pause All
PauseAllChecks="False"
if [ -f /root/pause-check-all ]; then
    PauseAllChecks="True"
fi

# if pause-check-vbox has been there too long                                   
# $1 = files, wildcards ok                                                      
# $2 = time in minutes, 1440 = 1d                                               
CheckPause /root/pause-check-* 1440  

# Satellite
if [ ! -f /root/pause-check-satellite -a $PauseAllChecks != "True" ]; then
#    (foreman-maintain service status || (foreman-maintain service stop; foreman-maintain service start)) || WriteToSysLog Syscheck-Error: Satellite not running properly
#    foreman-maintain health check
    CheckVM rhel7-sat6
fi

# Satellite Capsule
if [ ! -f /root/pause-check-capsule -a $PauseAllChecks != "True"  ]; then
    CheckVM rhel7-capsule
fi

# Satellite Clients
if [ ! -f /root/pause-check-capsule -a $PauseAllChecks != "True" ]; then
  for srv in rhel6-chicago rhel6-dev rhel6-clone-tokyo rhel7-mumbai rhel7-prod rhel7-qa rhel7-sandiego rhel8-dev rhel8-prod rhel8-qa; do
      CheckVM $srv
  done
fi

# KVM
if [ ! -f /root/pause-check-kvm -a $PauseAllChecks != "True" ]; then
   CheckService libvirtd
fi

# IdM
if [ ! -f /root/pause-check-idm -a $PauseAllChecks != "True" ]; then
#   for srv in rhel7-idm rhel7-idm-replica rhel7-idm-ad ; do
   for srv in rhel7-idm-ad ; do
       CheckVM $srv
   done
fi

# RHV
if [ ! -f /root/pause-check-rhv -a $PauseAllChecks != "True" ]; then
   for srv in rhel8-rhvm rhvh1 rhvh2 rhvh3 rhvh4 rhvh5 ; do
       CheckVM $srv
   done
fi

# Tower
if [ ! -f /root/pause-check-tower -a $PauseAllChecks != "True" ]; then
    CheckVM rhel8-ansibletower
fi
