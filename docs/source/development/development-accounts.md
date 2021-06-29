(development_accounts_service)=
# Accounts Service

## Description

The main objective of VISA Accounts is to authenticate a user using OpenID Connect and return an Account object (with related attributes such as username, home path, etc) and the connected user (userId, name, etc).

Access to this micro service is from the VISA API Server. VISA passes the OpenID Connect token (JWT) and VISA Accounts provides the necessary mechanism to contact the SSO, validate the token and return user and account information.

## Account Attributes and Cloud-Init

Account attributes are details concering the user and the account of the connected person (eg user name, email, username, home path, etc). Some are common across VISA (ie the user details) but a number can be site specific (eg home path, UID, GID, etc): these attributes are called *account parameters*.

The Account Parameters are stored in a dictionary (key - value) and sent automatically to a user's instance as part of the Cloud-Init metadata. These can then be used during the boot process of the instance if any confiuration within the VM is needed.

## Obtaining account attributes

As mentioned previously, certain Account Attributes can be site-specific so we leave this open for deployment at each facility. SSOs (eg Keycloak) can provide these in many cases but we need to make the design open to add institute-specific modules to obtain account details.

Different providers are necessary to obtain the account attributes as this can depend on site-specific infrastructure. For example we can have

- account attributes passed with the authentication token (eg using keycloak)
- LDAP
- DB
- web service

An internal API written in JavaScript is therefore used to have an abstraction of the provider methods. An environment variable allows for the path to the concrete implementation of the attribute-provider API to be specified at runtime (Docker volume mounts can also be used to link a container to the provider file on the host machine).

(development_accounts_attribute_provider)=
## Developing and integrating an attribute provider

To integrate and attribute provider for a facility, a simple JavaScript file has to be linked to the application (specified using an environmnet variable). The interface of this javascript files is as follows:

```javascript
getUserId(userInfo): string;
getUsername(userInfo): string;
getFirstname(userInfo): string;
getLastname(userInfo): string;
getEmail(userInfo): string;
getAccountParameters(userInfo): Object;
```

### The User ID

The User ID is an essential element returned by the attribute provider. This ID has to be unique for a user and it is required to be able to link the authenticated user to the facility User Office data (ie proposals or experiments) and user roles (injected separately in the ETL process of VISA).

The UserId is a string type to allow any identifier type from facility sites. This may be the same as the account username but it could also be a database primary key.

### The UserInfo object

The userInfo object is a wrapper to the [UserInfo Response](https://openid.net/specs/openid-connect-core-1_0.html#UserInfo) provided by OpenID Connect and provides a single method (```get(claim)```) to obtain claims returned by the SSO. In implementing the attribute provider this can be used as follows:

```javascript
getUserId(userInfo) {
  return userInfo.get('user_id_claim');
}
```

### Account Parameters

The *getAccountParameters* method is expected to return an object with parameters as properties. These parameters are passed to the OpenStack instance on creation using the Cloud-Init mechanism and therefore are accessible during the boot process.

### Example Attribute Provider

An [example attribute provider](https://github.com/ILLGrenoble/visa-accounts/blob/main/accountAttributeProviders/simple-keycloak-provider.js) is included in the VISA Account Github project:

```javascript
const getUserId = function (userInfo) {
  return userInfo.get('the_userid_claim')
}
 
const getAccountParameters = function (userInfo) {
  return {
    'homePath', userInfo.get('the_home_directory_claim')
  }
}
 
module.exports = {
  getUserId: getUserId,
  getAccountParameters: getAccountParameters
};
```

### Implementation

Not all attributes may come directly from OpenID Connect as mentioned previously, so connections to other databases or LDAP may be required for the full implementation.

A [default attribute provider](https://github.com/ILLGrenoble/visa-accounts/blob/main/src/models/attribute-provider.model.ts) is included in VISA Accounts to take standard claims from the UserInfo Response. As such not all of the methods outlined above necessarily need to be implemented. The following table shows which methods can be optionally implemented and what are the default values used by the service:

| Method       | Value | Implementation | Default OIDC claim |
|--------------|----------------|----------------|--------------------|
| ```getUserId```    | Mandatory      | Mandatory      |                    |
| ```getUsername```  | Mandatory      | Optional       | ```preferred_username``` |
| ```getFirstname``` | Mandatory      | Optional       | ```given_name```         |
| ```getLastname```  | Mandatory      | Optional       | ```family_name```        |
| ```getEmail```     | Mandatory      | Optional       | ```email```              |
| ```getAccountParameters```     | Optional      | Optional       |               |

## Testing

To test the attribute provider a local version of VISA Accounts, the VISA API Server and VISA Web UI need to be run. The easiest way to do this is to use docker-compose to run the containerised version of VISA API Server and VISA Web and to use the ```VISA_ACCOUNTS_SERVICE_CLIENT_URL``` environment variable to point to the local development version. Your implementation of the attribute provider can be linked to the container using a volume mount. VISA API Server also needs to be configured with both the SSO endpoint and the loval VISA Accounts endpoint.

You can find more information about docker-compose in the [deploying](deployment_docker_compose) section.

To build and run any of the VISA applications locally you can find more information on the [Development environment](development_environment) section.

### Environment variables

The following environment variables are used to configure VISA Accounts and can be placed in a dotenv file:

| Environment variable | Default value | Usage |
| ---- | ---- | ---- |
| VISA_ACCOUNTS_SERVER_PORT | 4000 | The port on which to run the server |
| VISA_ACCOUNTS_SERVER_HOST | localhost | The hostname on which the server is listening on |
| VISA_ACCOUNTS_IDP | | URL to the OpenID discovery endpoint (eg https://server.com/.well-known/openid-configuration) |
| VISA_ACCOUNTS_CLIENT_ID | | The Client ID as configured by the OpenID provider
| VISA_ACCOUNTS_ATTRIBUTE_PROVIDER | | Absolute or relative path to the attribute provider |
| VISA_ACCOUNTS_LOG_LEVEL | 'info' | Application logging level |
| VISA_ACCOUNTS_LOG_TIMEZONE |  | The timezone for the formatting the time in the application log |
| VISA_ACCOUNTS_LOG_SYSLOG_HOST |  | The syslog host (optional) |
| VISA_ACCOUNTS_LOG_SYSLOG_PORT |  | The syslog port (optional) |
| VISA_ACCOUNTS_LOG_SYSLOG_APP_NAME |  | The syslog application name (optional) |

You can find more information in the deployment section about the [full configuration](deployment_environment_variables) of VISA.

