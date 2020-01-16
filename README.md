Solution to expose HTCondor metrics through node_exporter

**ATENTION !!!**
In this case specific case, HTCondor-ce runs inside of [HTCondor-CE Container](https://github.com/simple-framework/simple_htcondor_ce).

If your HTCondor resides on the host machine, you need to modify [condor_textfile_collector.sh](./condor_node_exporter.sh) and remove "docker exec".

## Installation instructions

*Run installation script*
```
wget -O - https://raw.githubusercontent.com/ejr004/condor_textfile_collector/master/node_exporter_install.sh | bash
```


*Add this line to your crontab*
```
crontab -e

*/5 * * * * /scripts/condor_node_exporter.sh <your-container-ce>
```


*Firewall rules (just in case)*
```
firewall-cmd --zone=public --add-port=9090/tcp --permanent
```
And you are ready to go !


# Files

### node_exporter_install.sh
Installs node exporter v0.18.1 and setup textfile collector directory on host machine.

### condor_textfile_collector.sh
Generate condor-ce metrics for node exporter file collector




# References:
 - https://github.com/simple-framework
 - https://htcondor.readthedocs.io/en/v8_9_3/man-pages/condor_q.html
 - https://htcondor.readthedocs.io/en/v8_9_3/man-pages/condor_status.html
 - https://github.com/prometheus-community/node-exporter-textfile-collector-scripts
 - https://grafana.com/grafana/dashboards