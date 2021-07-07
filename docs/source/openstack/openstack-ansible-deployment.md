# Administration

> **_NOTE_** This documentation is work in progress

## Description

This section describes the key elements of the process of deployment of OpenStack at the ILL.

Ansible is run from a dedicated server and the playbooks run from this machine are maintained in a GIT repository at the ILL.

The OpenStack doc is very well done and describes clearly the [deployment with Ansible](https://docs.openstack.org/project-deploy-guide/openstack-ansible/latest/).

## Deployment

The deployment of OpenStack with Ansible is carried out in 5 steps:

- Preparing the deployment host
- Preparation of target hosts
- Deployment configuration
- Running Ansible playbooks
- Checking that OpenStack is working properly

See [the OpenStack documentation](https://docs.openstack.org/project-deploy-guide/openstack-ansible/latest/overview.html) for more explanations as well as prerequisites and sizing recommendations.

In what follows, we will only focus on a few key points.

### Preparation of target hosts

For more details please refer to the [OpenStack documentation](https://docs.openstack.org/project-deploy-guide/openstack-ansible/latest/targethosts.html).

On the original target hosts, we have 6 physical interfaces, configured two by two in bonding (802.3ad aggregation). These machines are under Ubuntu 18.04 so the configuration of their interfaces is done in YAML in `/etc/netplan/50-cloud.init.yml`:

```yaml
network:
    bonds:
        bond0:
            interfaces:
            - eno1
            - eno2
            parameters:
                mode: 802.3ad
        bond1:
            interfaces:
            - eno3
            - eno4
            parameters:
                mode: 802.3ad
        bond2:
            interfaces:
            - enp101s0f0
            - enp101s0f1
            parameters:
                mode: 802.3ad
    ethernets:
        eno1: {}
        eno2: {}
        eno3: {}
        eno4: {}
        enp101s0f0: {}
        enp101s0f1: {}
    version: 2
    vlans:
        bond0.111:
            accept-ra: no
            id: 111
            link: bond0
        bond1.222:
            accept-ra: no
            id: 222
            link: bond1
        bond0.333:
            accept-ra: no
            id: 333
            link: bond0
    bridges:
        br-mgmt:
            interfaces:
              - bond0.111
            parameters:
                stp: false
                forward-delay: 0
            addresses: [ 192.168.1.1/24 ]
            gateway4: 192.168.1.254
            nameservers:
                addresses:
                - 99.99.99.1
                - 99.99.99.2
        br-storage:
            interfaces: [ bond0.333 ]
            parameters:
                stp: false
                forward-delay: 0
            addresses: [ 192.168.2.1/24 ]
        br-vxlan:
            interfaces: [ bond1.222 ]
            parameters:
                stp: false
                forward-delay: 0
            addresses: [ 192.168.3.1/24 ]
        br-vlan:
            interfaces: [ bond1 ]
            parameters:
                stp: false
                forward-delay: 0
```

We can see that we configure 3 bond interfaces (bond0, bond1 and bond2), 3 VLANs (111, 222 and 333) on these interfaces, and then 4 bridges (br-mgmt, br-storage, br-vxlan and br-vlan) in which we place our interfaces.

### Configure the deployment

For more details please refer to the [OpenStack documentation](https://docs.openstack.org/project-deploy-guide/openstack-ansible/latest/configure.html).


In `/etc/openstack_deploy/` one can find many examples of configurations (including in particular `openstack_user_config.yml.aio`, “aio” for *all in one*), as well as the configuration file actually used: `openstack_user_config.yml`.

In this file we find the following lines:

```yaml
cidr_networks:
   container: 192.168.1.0/24
   storage: 192.168.2.0/24
   tunnel: 192.168.3.0/24
 
used_ips:
   - "192.168.1.1,192.168.1.127"
   - "192.168.2.1,192.168.2.127"
   - "192.168.3.1,192.168.3.127"
   - "192.168.1.231,192.168.1.254"
   - "192.168.2.231,192.168.2.254"
   - "192.168.3.231,192.168.3.254"
```

We define here 3 networks:

- a management network (192.168.1.0/24)
- a network for storage (192.68.2.0/24)
- a network for network management (192.68.3.0/24)

We specify that at the beginning and at the end of these three networks, the following ranges of IPs are reserved for the physical machines. This prevents Ansible to select any of them when it assigns IPs to the containers:

- 192.168.2.1 to .127
- 192.168.3.1 to .127
- 192.168.1.1 to .127
- 192.168.2.231 to .254
- 192.168.3.231 to .254
- 192.168.1.231 to .254


In the following configuration we then define four *generic* interfaces to be created on different machines depending on the case:

- an interface to put in br-mgmt, for physical machines ("hosts") and LXCs ("all_containers")
- an interface to put in br-storage, for the LXCs concerned by the NFS ("glance_api", "cinder_api", "cinder_volume" and "nova_compute")
- an interface to put in br-vxlan, for the LXC "neutron_linuxbridge_agent"
- an interface to put in br-vlan, for the LXC "neutron_linuxbridge_agent"

We also define two IP addresses for the load-balancer on the controllers:
- *internal_lb_vip_address*, which will be used by internal services
- *external_lb_vip_address*, which will be the address of the external API and web interface

```yaml

global_overrides:
  internal_lb_vip_address: 192.168.1.231
  external_lb_vip_address: 192.168.1.232
  provider_networks:
    - network:
        group_binds:
          - all_containers
          - hosts
        type: "raw"
        container_bridge: "br-mgmt"
        container_interface: "eth1"
        container_type: "veth"
        ip_from_q: "container"
        is_container_address: true
    - network:
        group_binds:
          - glance_api
          - cinder_api
          - cinder_volume
          - nova_compute
        type: "raw"
        container_bridge: "br-storage"
        container_type: "veth"
        container_interface: "eth2"
        container_mtu: "9000"
        ip_from_q: "storage"
    - network:
        group_binds:
          - neutron_linuxbridge_agent
        container_bridge: "br-vxlan"
        container_type: "veth"
        container_interface: "eth10"
        container_mtu: "9000"
        ip_from_q: "tunnel"
        type: "vxlan"
        range: "1:1000"
        net_name: "vxlan"
    - network:
        group_binds:
          - neutron_linuxbridge_agent
        container_bridge: "br-vlan"
        container_type: "veth"
        container_interface: "eth11"
        host_bind_override: "bond1"
        type: "vlan"
        range: "444-446"
        net_name: "vlan"
```

In this example, 444-446 are three VLANs for three different OpenStack projects.

Then, the configuration file lists the physical machines on which to install the various components. For example:

```yaml
# Level: os-infra_hosts (required)
# List of target hosts on which to deploy the glance API, nova API, heat API,
# and horizon. Recommend three minimum target hosts for these services.
# Typically contains the same target hosts as 'shared-infra_hosts' level.
#
#   Level: <value> (required, string)
#   Hostname of a target host.
#
#     Option: ip (required, string)
#     IP address of this target host, typically the IP address assigned to
#     the management bridge.
#
os-infra_hosts:
  oshost1:
    ip: 192.168.1.1
  oshost2:
    ip: 192.168.1.2
# --------
#
# Level: compute_hosts (optional)
# List of target hosts on which to deploy the nova compute service. Recommend
# one minimum target host for this service. Typically contains target hosts
# that do not reside in other levels.
#
#   Level: <value> (required, string)
#   Hostname of a target host.
#
#     Option: ip (required, string)
#     IP address of this target host, typically the IP address assigned to
#     the management bridge.
#
compute_hosts:
  oshost3:
    ip: 192.168.1.3
  oshost4:
    ip: 192.168.1.4
  oshost5:
    ip: 192.168.1.5
  oshost6:
    ip: 192.168.1.6
  oshost7:
    ip: 192.168.1.7
  oshost8:
    ip: 192.168.1.8
  oshost9:
    ip: 192.168.1.9
  oshost10:
    ip: 192.168.1.10

```

### Start the deployment

Please refer to the [official OpenStack documentation](https://docs.openstack.org/project-deploy-guide/openstack-ansible/latest/run-playbooks.html) for full details.

The deployment itself is started with YAML files called "playbooks", located in `/opt/openstack-ansible/playbooks/`. In this directory, the important files are:

- setup-hosts.yml
- setup-infrastructure.yml
- setup-openstack.yml
- setup-everything.yml, which brings together the previous three

To launch a playbook, the command is:

```bash
openstack-ansible <playbook>.yml
```

### Verify OpenStack operation

Please refer to the [official OpenStack documentation](https://docs.openstack.org/project-deploy-guide/openstack-ansible/latest/verify-operation.html) for full details.

In addition to the LXCs containing the OpenStack components of the controller node, another LXC called "utility" allows you to have CLI access to configure or test openstack.

It is accessed as follows:


```bash
sudo lxc-ls
```
```bash
oshost1_cinder_api_container-b541fa78     oshost1_galera_container-7aa21563       
oshost1_glance_container-2ab6361e         oshost1_heat_api_container-c3f15be3     
oshost1_horizon_container-64fdb364        oshost1_keystone_container-0adc7a9f     
oshost1_memcached_container-17ca86dd      oshost1_neutron_server_container-a4a616a8
oshost1_nova_api_container-e449db65       oshost1_rabbit_mq_container-0fadd14e    
oshost1_repo_container-9f748971           oshost1_utility_container-6a15374c
```

We atttach to this container:

```bash
sudo lxc-attach -n oshost1_utility_container-6a15374c
```

We load the administrator credentials:

```bash
source /root/openrc
```

Then we can use the openstack commands:

```bash
openstack user list
```

```bash
+----------------------------------+--------------------+
| ID                               | Name               |
+----------------------------------+--------------------+
| b026324c6904b2a9cb4b88d6d61c81d1 | nova               |
| 26ab0db90d72e28ad0ba1e22ee510510 | visa-admin         |
| 6d7fce9fee471194aa8b5b6e47267f03 | stack_domain_admin |
| 48a24b70a0b376535542b996af517398 | cinder             |
| 1dcca23355272056f04fe8bf20edfce0 | root               |
| 9ae0ea9e3c9c6e1b9b6252c8395efdc1 | heat               |
| 84bc3da1b3e33a18e8d5e1bdd7a18d7a | neutron            |
| c30f7472766d25af1dc80b3ffc9a58c7 | placement          |
| 7c5aba41f53293b712fd86d08ed5b36e | admin              |
| 31d30eea8d0968d6458e0ad0027c9f80 | glance             |
+----------------------------------+--------------------+
``` 

More info on using OpenStack in CLI is available in the [OpenStack documentation](https://docs.openstack.org/openstack-ansible/latest/admin/openstack-firstrun.html).

### Administration using the OpenStack CLI

It is also possible to install the Openstack CLI tools on a remote machine and use these to connect to OpenStack. To do this, all you have to do is install the client in Python3 via pip:

```bash
apt install python3-dev python3-pip
pip3 install python-openstackclient
```

Then configure the credentials in the following manner:

```bash
export LC_ALL=C.UTF-8

# COMMON CINDER ENVS
export CINDER_ENDPOINT_TYPE=public

# COMMON NOVA ENVS
export NOVA_ENDPOINT_TYPE=public

# COMMON MANILA ENVS
export OS_MANILA_ENDPOINT_TYPE=public

# COMMON OPENSTACK ENVS
export OS_ENDPOINT_TYPE=public
export OS_INTERFACE=public
export OS_USERNAME=admin
export OS_PASSWORD='<replace by actual password>'
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_AUTH_TYPE=password
export OS_AUTH_URL=https://'<replace by OpenStack host address>':5000/v3
export OS_NO_CACHE=1
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_REGION_NAME=RegionOne

# For openstackclient
export OS_IDENTITY_API_VERSION=3
export OS_AUTH_VERSION=3
```



