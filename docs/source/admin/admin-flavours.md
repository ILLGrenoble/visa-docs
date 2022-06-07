(admin_flavour_management)=
# Flavour management

Management of Flavours is done using the Flavours admin page.

![](../_static/images/visa-admin-flavours.png)


The Flavours interface shows a list of Flavours that are available in VISA. The details of the Flavour includes:

- **ID** (automatically generated)
- **Name**

  The name of the image as shown in the instance creation page of VISA

- **Cloud Flavour**

  The name of the Cloud Flavour (associates the database Flavour to a Flavour in OpenStack)

- **Memory**

  Shows the memory that is available with the Flavour (this is taken directly from OpenStack)

- **CPU**

  Shows the vCPUs that are available with the Flavour (this is taken directly from OpenStack)

- **Credits**

  Shows the the number of Credits needed to create an instance with this Flavour. Each user has a limited number of Credits (normally decided by the role of that person).

- **Selected instruments**

  A Flavour can be restricted to specific instruments. For example a large Flavour that provides a high number of vCPUs and a large amaount of Memory can be limited to instruments that require this due to detector sizes. If not value is set then the Flavour is available to all instruments.

The Flavour can be updated and deleted. Please note that the database entry for the Flavour is only soft deleted so it can be recovered if necessary. Deleting a Flavour does not have any impact on running instances: this will only make the Flavour invisible to users and no changes are made to OpenStack.

A button to create a new Flavour is also available.

Both *update* and *create* UIs are the same

![](../_static/images/visa-admin-flavours-update.png)

As shown in the image, details of the Flavour can be modified. Having selected a Cloud Flavour, the Memory and CPU are automatically updated.