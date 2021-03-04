# redesigned-eureka
Red-Team VM setup with docker/ansible/YAML
## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

[Azure Web Diagram](Diagrams/Azure_web_diagram.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbok file may be used to install only certain pieces of it, such as Filebeat.

 [Elk playbook](Ansible/ansible_playbook-elk.yml)

This document contains the following details:
- Description of the Topologu
- Access Policies
- ELK Configuration
 - Beats in Use
 - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting inbound access to the network. Load balancers will help ensure the processing of inbound traffic will be shared across our vulnerable web servers. The Access controls will ensure that only authorized users will be able to connect to said web servers.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the VMs filesystems (via filebeat) and system stats such as CPU usage (via metricbeat).


The configuration details of each machine may be found below.

| Name       | Function   | IP Address | Operating System |
|------------|------------|------------|------------------|
| Jump Box   | Gateway    | 10.0.0.4   | Linux            |
| Web-1      | Web server | 10.0.0.7   | Linux            |
| Web-2      | Web server | 10.0.0.9   | Linux            |
| DVWA-VM2   | Redundancy | 10.0.0.11  | Linux            |
| Elk-Server | Monitoring | 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the jump box machine can accept connections from the Internet.

Machines within the network can only be accessed by each other. Web-1, Web-2 and DVWA-VM2 send traffic to the Elk server.

A summary of the access policies in place can be found in the table below.

| Name       | Publicly Accessible | IP Address  |
|------------|---------------------|-------------|
| Jump Box   | Yes                 | **.**.*.*** |
| Web-1      | No                  | 10.0.0.0/16 |
| Web-2      | No                  | 10.0.0.0/16 |
| DVWA-VM2   | No                  | 10.0.0.0/16 |
| Elk-Server | No                  | 10.1.0.0/16 |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because we can scale the infrastructure as needed and be up and running in minutes.

The playbook implements the following tasks:
- Download and install docker.io, python3 and docker python module.
- Increase the available virtual memory and set use.
- Download and launch a docker elk container.

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.
	

[Successful Elk Docker ps output](Ansible/elk_docker_ps.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
 - Web-1, 10.0.0.7
 - Web-2, 10.0.0.9
 - DVWA-VM2 (redundancy), 10.0.0.11

We have installed the following Beats on these machines:
 - Filebeat
 - Metricbeat

These Beats allow us to collect the following information from each machine:
 - Filebeat: Filebeat detects changes to the filesystem. Specifically, we use it to collect Apache logs.
 - Metricbeat: Metricbeat detects changes in system metrics, such as CPU usage. We use it to detect SSH login attempts, failed sudo escalations, and CPU/RAM statistics.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the [Elk playbook](Ansible/ansible_playbook-elk.yml) file to the Ansible Control Node.

```/etc/ansible/ansible_playbook-elk.yml```
- Update the hosts file to include the new VM and elk group. (Note: python 3 needs to be specified for the ansible interpreter.)
```
 # /etc/ansible/hosts
 [webservers]
 10.0.0.7 ansible_python_interpreter=/usr/bin/python3
 10.0.0.9 ansible_python_interpreter=/usr/bin/python3
 10.0.0.11 ansible_python_interpreter=/usr/bin/python3

 [elk]
 10.1.0.4 ansible_python_interpreter=/usr/bin/python3
```
- Run the playbook.

```ansible-playbook /etc/ansible/ansible_playbook-elk.yml```
- SSH into the Elk VM and run ```sudo docker ps``` to verify the playbook executed properly and that the container is running.
- In a browser, go to <http://your.ELK-VM.External.IP:5601/app/kibana>. If installation was successful, you shold see Add Data to Kibana web page.

Next we will install filebeat and metricbeat on the Elk server.

- SSH into the jumpbox VM with the Ansible Control Node.
- Copy [filebeat-config.yml](Ansible/filebeat-config.yml) and [metricbeat-confg.yml](Ansible/metricbeat-config.yml) into the ```/etc/ansible/files/``` directory.

```curl https://raw.githubusercontent.com/unclescrewtape/redesigned-eureka/main/Ansible/filebeat-config.yml > /etc/ansible/files/filebeat-config.yml```

```curl https://raw.githubusercontent.com/unclescrewtape/redesigned-eureka/main/Ansible/metricbeat-config.yml > /etc/ansible/files/metricbeat-config.yml```

- In both config files you must input your elk server ip address. 
	- Search for ```output.elsaticsearch``` and change ```hosts``` to 10.1.0.4:9200
	- Search for ```setup.kibana``` and change ```host``` to 10.1.0.4:5601

- Copy [filebeat-playbook.yml](Ansible/filebeat-playbook.yml) and [metricbeat-playbook.yml](Ansible/metricbeat-playbook.yml) into the /etc/ansible/roles/ directory

```curl https://raw.githubusercontent.com/unclescrewtape/redesigned-eureka/main/Ansible/filebeat-playbook.yml > /etc/ansible/roles/```

```curl https://raw.githubusercontent.com/unclescrewtape/redesigned-eureka/main/Ansible/metricbeat-playbook.yml > /etc/ansible/roles/```

- Run each playbook in turn.

```ansible-playbook /etc/ansible/roles/filebeat-playbook.yml```

```ansible-playbook /etc/ansible/roles/metricbeat-playbook.yml```

- Reboot Elk vm for changes to take effect.
- Once the Elk server is back up and running, go to http://your.ELK-VM.External.IP:5601/app/kibana. In the left hand menu bar click on “Logs” or “Metrics” to view data.
