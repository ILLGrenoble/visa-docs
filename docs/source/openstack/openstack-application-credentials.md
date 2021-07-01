# VISA Application Configuration

This section provides details on configuration necessary for VISA to be able to manage instances in OpenStack.

## Application Credentials

For VISA to be able to manage instances using the OpenStack REST API, *Application Credentials* need to be created.

Under the *Indentity* menu of OpenStack, select *Application Credentials* and then *Create Application Credential*. This will start the process of creating and application credential for the currently selected project.

> You must ensure that the *roles* associated to the application credential only include the *member* role. An *admin* is able to perform operations on intances in other OpenStack namespaces so care has be taken here.

Once you have created the application credential you will need to [configure VISA](deployment_environment_variables_openstack) to use both the *ID* and *Secret* associated with it.

## Address Provider

VISA also has to be [configured with](deployment_environment_variables_openstack) an *Address Provider*. This can be found in the *Networks*  menu of the *Project* in OpenStack.

VISA requires both the name and UUID of the network of a given project (the project should be coherent with the *Application Credentials* obtained previously).

