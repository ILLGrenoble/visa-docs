# Development

```{toctree}
---
maxdepth: 1
---
development-accounts.md
development-security-groups.md
development-etl.md
development-emails.md
development-cloud-provider.md
```

To fully install VISA some site-specific development will be necessary including linking VISA to your authentication provider, importing data from your facility into the VISA database, customising user emails and defining the logic necessary for instance firewalls (OpenStack Security Groups).

As much as possible has been done to make the development process at each site as minimal as possible. Much of the integration of VISA can be done through configuration process, but since VISA is linked to the infrastructure and integrated into the scientific aspects of an institute, some development work is unavoidable. 

A quick description of the software development is as follows:

- **VISA Accounts Attribute Provider**

  VISA Accounts is responsible for authenticating a user with the faciliy's SSO using OpenID Connect. Connecting the the SSO is done via a configuration (environment variable) but data is required about the user that can vary on facility infrastructure and on the local SSO configuration.
  
  VISA needs to be able to be able to identify a user through a unique ID that can later be associated to proposals or experiments from the facility's user office database. Access to the unique ID can vary from site to site.

  There may also be certain attributes associated to the user that are pertinent when creating virtual machines (UID, GID, home path, etc). These too need to be specified by each site and added manually to the user data returned by this service.

- **VISA Security Groups (optional)**

  The development of a VISA Security Groups micro service is needed when site-specific business logic needs to specified to determine security groups to be associated to individual instances.

  VISA contains *role-based* business logic (ie security groups linked to specific user roles) but there may be more complex algorithms needed (eg depending on the experiments that are associated to an instance).

  A single endpoint needs to be coded if a site wishes to provide this additional logic.

- **VISA Database ETL**

  VISA has an independent database that initially does not contain any user information (user details and roles) or user office data (instruments, proposals, experiments, teams). Rather than obtain this information via  a web service, it is simpler to inject the data from an independent process (this also allows for a improved application security).

  A process needs to be developed by each facility that collects relevant data from the local data source, transforms it into a common VISA format, and injects it into the VISA database.

- **Emailing**

  VISA notifies users via email, for example when their instances are going to be deleted or if they have been given access to someone else's instance. An email template is used for these purposes and can be customised by each facility to make them more relevant (ie add the facility name or an IT contact email address).

- **Alternative Cloud Provider**

  For sites that do not intend to have OpenStack installed, we provide a means of connecting to alternative cloud providers. We do not guarantee full functionality of VISA as only OpenStack is fully supported.

