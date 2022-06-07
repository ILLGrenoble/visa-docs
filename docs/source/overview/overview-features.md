# Features

VISA provides remote data analysis services giving access to experimental data, analysis software, compute infrastructure and expert-user support (IT and Scientific).

One primary objective of VISA is to make access as simple as possible to these services using a web browser. VISA provides easy and flexible machine management. Having created a virtual machine, or *instance*, a user can use the Remote Desktop as if they were sitting in front a data treatement workstation at the host institute. With the increased use of Jupyter Notebooks to perform scripted and reproducible data analysis, VISA also embeds JuptyerLab wihthin the instance, directly accessible from the same platform interface.

Another primary objective is to make scientific collaborations more efficient. By sharing Remote Desktops in real time, scientists can work together on the same data analysis. Real-time support from IT staff and instrument scientists is also possible by sharing instances with them.

As a consequence of the Covid-19 pandemic, travel between countries has been extremely limited and home working has become more common. To maintain the scientific activities within the ILL, VISA also provides access to NOMAD (the Instrument Control Software) and the security features of VISA have been adapted to ensure access to sensitive instrument control zones is highly restrictive, yet transparent to users that need it.

A full list of features provided by VISA is as follows:

- **Creation and deletion of linux virtual machines**

  Users can choose from pre-defined *flavours* (CPU and RAM) and have access to pre-installed/configured scientific and instrument control software via the Remote Desktop and also the JupyterLab environment.

- **Sharing machines with other users**
  
  Scientific collaborations are possible through real-time sharing of Remote Desktops

- **Centralised authentication**

  OpenID Connect is used as the authentication protocol of VISA. Keycloak is commonly used for the SSO/AAI

- **Machine lifetime management**
  
  Instances are by default automatically deleted after 14/60 days or 4/8 days or inactivity (visitor/staff). These values are configured at each site. 24 hours before an instance is deleted, the user is notified by email.

- **Smart firewall rules**

  Access to internal infrastructure at each site is highly configurable and can be dependent on user role or the experiments associated to the instance

- **Quotas based on user role**

  Staff and Visitors are given different quotas (instance Credits) allowing them to have different number of instances running in parallel.

- **Scientific and technical support roles**

  To allow for a variety of functional roles within a facility, users can have different support roles giving them access to relevant instances. These are *Instrument Scientist*, *Instrument Control* and *IT Staff*.

- **Admin and scientific support interfaces**

  A number of interfaces have been developed to facilitate the monitoring of VISA usage and to more easily give support to users.

- **Detailed user documentation**

  User documentation is integrated into the VISA platform. This can be adaptated at each site to cover a variety of use cases.



