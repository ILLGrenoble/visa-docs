(deployment_docker_compose)=
# Docker Compose Deployment

This section describes how to deploy the VISA platform using docker-compose.

## The VISA Applications

The VISA platform is composed of a number of different applications that are configured to work together:

- **VISA API Server**

  The main business logic and REST API for the VISA application. Management of remote desktops is also handled here.

- **VISA Web UI**

  The frontend UI based on the angular framework.

- **VISA Jupyter Proxy**

  An HTTP proxy to forward requests to the JupyterLab server running on the instances

- **VISA Accounts**

  The account authentication and attribute provider

- **VISA Security Groups (optional)**

  A micro-service to determine security groups required for each instance. This is to be implemented by each facility to cover site-specific firewall rules

As well as deploying the applications, a reverse proxy (such as NGINX or Apache) will be needed to set up the different routes to direct traffic to the different applications.

### Docker images

To simplify the deployment, Docker images are available of the latest releases. These can be pulled directly from [DockerHub](https://hub.docker.com/u/illgrenoble). 

Docker images can also be build directly from the source code (a Dockerfile can be found in each of the projects).

The following table shows the list of projects, the location of the source code and the location of the docker image.

|Application | Source code | Docker image |
|---|---|---|
| VISA API Server | [visa-api-server source](https://github.com/ILLGrenoble/visa-api-server) | [visa-api-server image](https://hub.docker.com/r/illgrenoble/visa-api-server) |
| VISA Web UI | [visa-web source](https://github.com/ILLGrenoble/visa-web) | [visa-web image](https://hub.docker.com/r/illgrenoble/visa-web) |
| VISA Jupyter Proxy | [visa-jupyter-proxy source](https://github.com/ILLGrenoble/visa-jupyter-proxy) | [visa-jupyter-proxy image](https://hub.docker.com/r/illgrenoble/visa-jupyter-proxy) |
| VISA Accounts | [visa-accounts source](https://github.com/ILLGrenoble/visa-accounts) | [visa-accounts image](https://hub.docker.com/r/illgrenoble/visa-accounts) |

Since the Security Groups micro-service needs to be developed at each site, the Docker image is not included in this list.

### VISA endpoints

Each application has a different endpoint that needs to be reverse proxied for the frontend to correctly access this different services. This list below shows these endpoints and to which application/URL they are proxied to.

| Endpoint  | Application | Application end point | Request Type | Notes |
|---|---|---|---|---|
| / | VISA Web UI | / | HTTP |
| /api | VISA API Service | /api | HTTP | REST API
| /graphql | VISA API Service | /graphql | HTTP | GraphQL endpoint
| /ws/vdi | VISA API Service (desktop service) | /socket.io | Web Socket | Different port to Visa REST API
| /jupyter | VISA Jupyter Proxy | / | HTTP |
| /jupyter | VISA Jupyter Proxy | / | Web Socket | If ```upgrade``` present in request


**Note** An additional endpoint (```/api/docs```) exists to serve the [user documentation](deploying_user_documentation). Details on how to integrate user documentation are given later.

## VISA Deploy and a skeleton ```docker-compose``` script

To simplify the deployment of the different containers and manage a reverse proxy to the different applications and enpoints, a container orchestrator is the most practical solution. This can be done by different means but for simplicity we recommend (and provide support for) [```docker-compose```](https://docs.docker.com/compose/).

To help you get started with deploying via docker-compose, we provide an example/skeleton deployment file and a simple shell script to help with deployment on the [VISA Deploy](https://github.com/ILLGrenoble/visa-deploy-scripts) project.

This project contains a standard ```docker-compose.yml``` file contains deployments for an NGINX reverse proxy, VISA Web, VISA API Server, VISA Accounts and VISA Jupyter Proxy with volume maps to pre-defined locations to files including:
 - SSL certificates
 - NGINX configuration file
 - The VISA Accounts attribute provider

When used with the [VISA PAM module](image_visa_pam) to allow for automatic login to the instance remote desktops, additional private and public keys need to be mounted to VISA API Server too.

The ```docker-compose.yml``` specifies a specific version of the VISA platform too. This can be modified by setting the ```VISA_VERSION``` environment variable before doing ```docker-compose``` or running the `deploy.sh` script.

The ```deploy.sh``` script is used to stop and start containers and ensure that the volume mounted files exist. The following parameters need to be set the first time you launch the script to allow `deploy.sh` to copy config files. After the first use, you can omit them. 

To fully restart the platform, use --restart to force recreation of all containers, and not just modified ones. This is required true if environment variables change.

```
deploy.sh [options]
Options and equivalent environment variables:"
  -e   or --envfile <path>         VISA_ENV_FILE          set the environment file location
  -n   or --nginx-conf <path>      VISA_NGINX_CONF        set the nginx configuration file location (optional)
  -sk  or --ssl-key <path>         VISA_SSL_KEY           set the SSL key location
  -sc  or --ssl-crt <path>         VISA_SSL_CRT           set the SSL certificate location
  -p   or --provider                                      set the account provider file location
  -r   or --restart                                       restart all the docker images
```

If using the VISA PAM module, this script can be modified to include the public and private key paths.

### Environment variables

A large number of [environment variables](deployment_environment_variables) exist to configure VISA. The `docker-compose.yml` file is set up to read these from a `.env` file. 

In general, the same deployment script can be used for different environments (development, staging and production): all that needs to change are the environment variables and config files.

### Configuring VISA Accounts

To fully deploy the VISA platform, you must have an [*Attribute Provider*](development_accounts_attribute_provider) for VISA Accounts. The attribute provider is used to provide site-specific details about the user and the account and can be used to send additional information to the instance in OpenStack. It is required to provide a unique ID of the user than can be used to associate the person to specific experiments at your facility too.

The attribute provider (a simple javascript file) needs to be mounted to the VISA Accounts application. The `docker-compose.yml` file expects it to be located in the *providers* folder of VISA Deploy. The `deploy.sh` script can be used to copy it to this location.

### Adding a VISA Security Group service

VISA allows for the addition of a micro-service to handle the logic of selecting [security groups](development_security_groups) for an instance. Ideally, to simplify the deployment, this micro-service should be dockerised and integrated into the same `docker-compose.yml` orchestration.

As well as modifying `docker-compose.yml`, [environment variables](deployment_environment_variables_web_services) need to be set to link VISA API Server to this service.


