# rapid CLI oneliner log inspection inside all log files
# Lookig for keywords "fail", "error", "unable", "warning".

for i in $(ls /var/log/*/*.log); do echo "=========="; echo $i; echo "========="; tail $i| egrep -i warning; done




