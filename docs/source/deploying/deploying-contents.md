# Deploying

```{toctree}
---
maxdepth: 1
---
deploying-authentication.md
deploying-database.md
deploying-env-vars.md
deploying-docker-compose.md
deploying-initial-tests.md
deploying-load-balancing.md
deploying-user-documentation.md
deploying-monitoring.md
```

This section describes how to deploy the VISA platform.

VISA is composed of a number of dockerised applications that are configured to work together. Orchestration of the docker containers can be done in multiple ways however we outline here the simplest way using docker-compose.

The VISA Applications are as follows:
- **VISA API Server**

  The main business logic and REST API for the VISA application. Management of remote desktops is also handled here.

- **VISA Web UI**

  The frontend UI based on the angular framework.

- **VISA Jupyter Proxy**

  An HTTP proxy to forward requests to the JupyterLab server running on the instances

- **VISA Accounts**

  The account authentication and attribute provider

- **VISA Security Groups (optional)**

  A micro-service to determine security groups required for each instance. This is to be implemented by each facility to cover site-specific firewall rules.

