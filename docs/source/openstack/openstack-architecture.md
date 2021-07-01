# Architecture

> **_NOTE_** This documentation is work in progress


## Overview of OpenStack

OpenStack is a virtualisation and network orchestrator, organised into software modules, also called *components*, each dealing with a specific task such as
- virtualistaion/compute ("Nova")
- storage ("Cinder" or "Swift)
- network configuration ("Neutron")
- databases ("Trove")

A new version of OpenStack is released approximately every six months.

The components are executed by default in LXC containers in order to better isolate them, with the notable exceptions of the "compute" part of Nova because it takes care of virtualization, and of Cinder because it manages block volumes.

## OpenStack architecture at the ILL

At the ILL, OpenStack is currently deployed using Ansible on 10 nodes: 2 controller nodes and 8 compute nodes. 

The 2 controler nodes host various management components, including:
- the virtualization API ("Nova")
- the orchestration API ("Heat")
- the image management API ("Glance")
- identity management ("Keystone")
- the definition of the network ("Neutron")
- storage ("Cinder" with NFS)
- the dashboard web interface ("Horizon")
- a load-balancer ("HAproxy")

The 8 compute nodes are hypervisors ("Nova" with KVM / Qemu).

And in addition to these machines where Openstack deployment is automatic, we have:
- 1 deployment host

  This is the host from which Ansible will be configured and launched, as opposed to "target hosts" (the deployed machines).

- 2 dedicated switches





