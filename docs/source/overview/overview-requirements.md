# Requirements

Below is a list of requirements necessary to run VISA:

- **The fully deployed VISA application with a reverse proxy to manage the different end points**

  Assistance is given here with example *docker-compose* files to deploy the Docker containers. The application has to be properly configured too: a rich set of environment variables are available to customise VISA.

- **An OpenStack cloud infrastucture**

  the VISA application server must also have access via firewall rules to the OpenStack Controller REST API.

- **A deployed database**

  We recommend that a PostgreSQL server is deployed and access is provided to the VISA application server.

- **OpenID Connect SSO (eg Keycloak)**

  A minimal amount of development is also required to connect the SSO to the VISA backend.

- **A database ETL process**

  Data needs to be injected in the VISA database from a separate process at each site.

- **Security group configuration**

  The security groups need to be configured so that the VISA services in the instance (remote desktop, JupyterLab) can be access from the VISA application server

