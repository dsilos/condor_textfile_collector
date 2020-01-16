#!/bin/sh
#
# Generate condor metrics through node exporter file collector
# For more info: https://github.com/dsilos/grid_scripts/
#
# Add this line to your crontab (crontab -e)
# */5 * * * * /scripts/condor_node_exporter.sh ce01

CE=$1

# Check $CE
if [ -z "$CE" ]
then
      echo "\$CE, is empty"
      echo "./condor_exporter.sh <CE>"
else

# Condor queue metrics
docker exec -i $CE.cat.cbpf.br condor_ce_q -tot \
-format "# TYPE condor_queue_removed counter\ncondor_queue_removed{ce=\"$CE\"} %d\n" removed \
-format "# TYPE condor_queue_idle counter\ncondor_queue_idle{ce=\"$CE\"} %d\n" idle \
-format "# TYPE condor_queue_running counter\ncondor_queue_running{ce=\"$CE\"} %d\n" running \
-format "# TYPE condor_queue_held counter\ncondor_queue_held{ce=\"$CE\"} %d\n" held \
-format "# TYPE condor_queue_suspended counter\ncondor_queue_suspended{ce=\"$CE\"} %d" suspended \
 > /var/lib/node_exporter/textfile_collector/condor.queue.prom.$$
mv /var/lib/node_exporter/textfile_collector/condor.queue.prom.$$ /var/lib/node_exporter/textfile_collector/condor.queue.prom

# Condor Status metrics
docker exec -i $CE.cat.cbpf.br condor_status -tot \
|sed '$!d' \
|awk '{print "# TYPE condor_status_machines counter\ncondor_status_machines{ce=ceinfo} " $2 "\n# TYPE condor_status_claimed counter\ncondor_status_claimed{ce=ceinfo} " $4 "\n# TYPE condor_status_unclaimed counter\ncondor_status_unclaimed{ce=ceinfo} " $5}' \
> /var/lib/node_exporter/textfile_collector/condor.status.prom.$$
sed -i "s/ceinfo/\"$CE\"/g" /var/lib/node_exporter/textfile_collector/condor.status.prom.$$
mv /var/lib/node_exporter/textfile_collector/condor.status.prom.$$ /var/lib/node_exporter/textfile_collector/condor.status.prom