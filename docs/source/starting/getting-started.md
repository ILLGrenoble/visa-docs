# Getting started

Getting VISA up and running requires a considerable amount of installation, development and configuration effort. Here we aim to provide a list of actions (documented here) that need to be done in order to get VISA fully functional.

- [Install OpenStack](openstack_contents)

  The first requirement is to get an OpenStack cluster up and running.

- [Create a virtual machine image](image_contents) 

  A scripted process should be developed to create a virtual machine image that will be managed by VISA and deployed in OpenStack. VISA will use this image to create instances that offer Remote Desktop and JupyterLab functionality.

- [Deploy a VISA database](deploying_database)

  A separate database server running Postgres is recommended to use with VISA.

- [Configure your SSO](deployment_authentication)

  We provide the example of using Keycloak to connect to VISA.

- [Develop a VISA DB ETL process](development_etl)

  Data will have to be extracted from you facility systems an integrated into VISA for users to have roles and select experiments.

- [Deploy the VISA Platform](deployment_docker_compose)

  At this stage it will not be functional, but it is recommended to get the VISA applications running using a `docker-compose` script that can be updated when services are added. 
  
- [Configure the VISA Platform](deployment_environment_variables)

  You will need to configure VISA correctly to connect to the database, OpenStack and link the different services

- [Write a VISA Accounts *attribute provider*](development_accounts_attribute_provider) and integrate this into the VISA deployment

  This will allow you to authenticate your users using your OpenID Connect SSO.

- Add [Images](admin_image_management), [Flavours](admin_flavour_management) and [Plans](admin_plan_management) to your VISA installation

  This will connect VISA to Images and Flavours in OpenStack an allow you to create instances using VISA.

At this point you should have a functional VISA platform. You can then concentrate on improving the installation. You can for example:

- [Add Security Group logic](development_security_groups)

  You can add a micro-service to provider fine-grained control over the firewalling of VISA instances.

- [Load-balance your deployment](deployment_load_balancing)

  To allow for peaks of usage VISA can be deployed on multiple servers.

- [Set up the user email template](development_emails)

  Customise the emails that are sent to your users. 

- [Write and integrate user documentation](deploying_user_documentation)

  Documentation can be added to VISA that is specific to your installation (and virtual machine image).