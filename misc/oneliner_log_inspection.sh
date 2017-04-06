# rapid CLI oneliner log inspection for a given serevice
# Lookig for keywords "fail", "error", "unable".

for i in $(ls /var/log/horizon/*); do echo "========"; echo "======== log file : $i"; echo "========"; tail $i | egrep -i fail ; done




