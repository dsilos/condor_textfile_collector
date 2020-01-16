## Installation

*Run installation script*
```
https://raw.githubusercontent.com/ejr004/condor_textfile_collector/master/node_exporter_install.sh | bash
```

*Add this line to your crontab (crontab -e)*
```
# */5 * * * * /scripts/condor_node_exporter.sh ce01
```

*Firewall rules (just in case)*
```
firewall-cmd --zone=public --add-port=9090/tcp --permanent
```
And it's done !

### node_exporter_install.sh
Installs node exporter v0.18.1 and setup textfile collector directory on host machine.

### condor_textfile_collector.sh

Generate condor-ce metrics for node exporter file collector to consume

In this case, condor-ce runs inside SIMPLE GRID container.

If you plan to use this script to collect metrics on the host machine, you need to modify this script (remove "docker exec")

## References:
 https://github.com/simple-framework
 https://htcondor.readthedocs.io/en/v8_9_3/man-pages/condor_q.html
 https://htcondor.readthedocs.io/en/v8_9_3/man-pages/condor_status.html
 https://github.com/prometheus-community/node-exporter-textfile-collector-scripts
 https://grafana.com/grafana/dashboards