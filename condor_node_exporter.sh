#!/bin/sh
#
# Generate condor queue metrics through node exporter file collector
# For more info: https://github.com/ejr004/condor_textfile_collector
#
# Add this line to your crontab (crontab -e)
# */5 * * * * /scripts/condor_node_exporter.sh <ce>

CE=$1
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

#Condor queue VO LHCB
docker exec -i $CE.cat.cbpf.br condor_ce_q -tot -constraint 'x509UserProxyVOName =?= "lhcb"' \
-format "# TYPE ncondor_queue_removed_lhcb counter\ncondor_queue_removed_lhcb{ce=\"$CE\"} %d\n" removed \
-format "# TYPE ncondor_queue_idle_lhcb counter\ncondor_queue_idle_lhcb{ce=\"$CE\"} %d\n" idle \
-format "# TYPE ncondor_queue_running_lhcb counter\ncondor_queue_running_lhcb{ce=\"$CE\"} %d\n" running \
-format "# TYPE ncondor_queue_held_lhcb counter\ncondor_queue_held_lhcb{ce=\"$CE\"} %d\n" held \
-format "# TYPE ncondor_queue_suspended_lhcb counter\ncondor_queue_suspended_lhcb{ce=\"$CE\"} %d" suspended \
 > /var/lib/node_exporter/textfile_collector/condor.queue_lhcb.prom.$$
mv /var/lib/node_exporter/textfile_collector/condor.queue_lhcb.prom.$$ /var/lib/node_exporter/textfile_collector/condor.queue_lhcb.prom

#Condor queue VO alice
docker exec -i $CE.cat.cbpf.br condor_ce_q -tot -constraint 'x509UserProxyVOName =?= "alice"' \
-format "# TYPE ncondor_queue_removed_alice counter\ncondor_queue_removed_alice{ce=\"$CE\"} %d\n" removed \
-format "# TYPE ncondor_queue_idle_alice counter\ncondor_queue_idle_alice{ce=\"$CE\"} %d\n" idle \
-format "# TYPE ncondor_queue_running_alice counter\ncondor_queue_running_alice{ce=\"$CE\"} %d\n" running \
-format "# TYPE ncondor_queue_held_alice counter\ncondor_queue_held_alice{ce=\"$CE\"} %d\n" held \
-format "# TYPE ncondor_queue_suspended_alice counter\ncondor_queue_suspended_alice{ce=\"$CE\"} %d" suspended \
 > /var/lib/node_exporter/textfile_collector/condor.queue_alice.prom.$$
mv /var/lib/node_exporter/textfile_collector/condor.queue_alice.prom.$$ /var/lib/node_exporter/textfile_collector/condor.queue_alice.prom

#Condor version value
docker exec -i $CE.cat.cbpf.br condor_version | cut -d" " -f2 | head -1 \
-format "# TYPE condor_version\ncondor_version{ce=\"$CE\"} %d\n" condor_version \
> /var/lib/node_exporter/textfile_collector/condor.version.prom.$$
mv /var/lib/node_exporter/textfile_collector/condor.version.prom.$$ /var/lib/node_exporter/textfile_collector/condor.version.prom
