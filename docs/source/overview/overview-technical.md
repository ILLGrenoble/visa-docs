# Technical Specifications

## Cloud virtualisation

The virtual machines created by VISA are built on an OpenStack Cloud instrastructure [^1]. OpenStack provides a simple HTTP REST API allowing VISA to manage instances efficiently. A user who requests a new instance will be in general be able to access the instance within a minute of the request being submitted.

## Remote Desktops

Apache Guacamole via XRDP is used to provider the Remote Desktop functionality. This has proved efficient and stable over long periods. 

The ILL is currently in the process of developping an equivalent protocol that should improve the latency due to the remote connection.

## Source code

The source code for VISA is publicly available on [GitHub](https://github.com/ILLGrenoble). 

The main VISA REST API and Remote Desktop connections are managed by a Java application based on the Dropwizard framework.

HTTP requests are proxied to the JupyterLab server running on each instance using a Node.JS HTTP proxy.

The VISA user interface is a single page web applicaiton built using Angular 10.

## Database

A number of different relational databases can be used for the persistence needs of VISA (we recommend however using PostgreSQL).

A Redis server must also be deployed if load balancing is to be used.

### ETL (database extraction, transform and load)

VISA requires data to be injected into the database from each facility. A number of tables contain information related to the instruments, scientific users, proposals and experiments need to be reguraly updated. Support is provided to each site to develop these ETLs, however the maintenance of these processes is the responsibility of the site in question.

## Authentication

Authentication is provided using OpenID Connect. Each site most provide a small amount of code to perform the connection their own SSO.

## Deployment

The full VISA platform is provided as Docker containers. Docker Compose is used as the principal orchestration mechanism.

## Load Balancing

VISA can be fully load balanced on a number of servers by using a simple round-robin reverse proxy in front of them. 

As mentioned above, to fully enable load balancing, a Redis server must be available and configured with VISA.


[^1]: Support is only provided to OpenStack however virtualisation should be possible using other cloud infrastructures. VISA allows for an HTTP middleware to be used to communicate with other facility infrastructures however no support can be provided, nor guarantee that other infrastructures will work seamlessly with new versions of VISA.