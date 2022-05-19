(deployment_environment_variables)= 
# Environment variables

The VISA platform is highly configurable through an array of environment variables. This section describes all the environment variables for the different applications and offers suggested values.

(deployment_environment_variables_api_server)= 
## VISA API Server

### Server

| Environment variable | Default | Description |
|---|---|---|
| VISA_SERVER_HOST |  localhost |  The hostname on which the REST API HTTP server is listening on |
| VISA_SERVER_PORT | 8080  | The port on which to run the REST API HTTP server  |
| VISA_CORS_ORIGIN |  * | Sets the CORS origin of the HTTP server  |
| VISA_ROOT_URL |   | The root URL of the application, used for user notifications |
| VISA_GRAPHQL_TRACING_ENABLED | false  | Allows debugging of GraphQL requests |


### Database

| Environment variable | Default | Description |
|---|---|---|
| VISA_DATABASE_USERNAME |   | The VISA database username  |
| VISA_DATABASE_PASSWORD |   | The VISA database password  |
| VISA_DATABASE_URL |   |  The full URL of the VISA database |

### Logging

| Environment variable | Default | Description |
|---|---|---|
| VISA_LOGGING_LEVEL |  INFO |  The application logging level |
| VISA_LOGGING_TIMEZONE |  CET | The timezone for the formatting the time in the application log  |

(deployment_environment_variables_email_appender)=
#### Email appender

The email appender is used only for error logs, to allow for quick notification of errors that occur on a production server.

| Environment variable | Default | Description |
|---|---|---|
| VISA_LOGGING_EMAIL_APPENDER_HOST |   | The host of the SMTP server for logging via email   |
| VISA_LOGGING_EMAIL_APPENDER_PORT | 25  |  The port of the SMTP server |
| VISA_LOGGING_EMAIL_APPENDER_SSL |  false | Use of SSL with the SMTP server  |
| VISA_LOGGING_EMAIL_APPENDER_TLS |  false | Use of TLS with the SMTP server |
| VISA_LOGGING_EMAIL_APPENDER_RECIPIENT_ADDRESS |   |  Address to send log emails to (a developer account for example)  |
| VISA_LOGGING_EMAIL_APPENDER_FROM_ADDRESS |   |  Address to use as the sender of the log emails |
| VISA_LOGGING_EMAIL_SUBJECT |  | Subject (prefix) to use for log emails |

#### File appender

| Environment variable | Default | Description |
|---|---|---|
| VISA_LOGGING_FILE_THRESHOLD |  INFO | The logging level for the file |
| VISA_LOGGING_FILE_MAX_FILE_SIZE |  100MB |  Maximum log file size |
| VISA_LOGGING_FILE_DIRECTORY |   |  The directory of where the log file is stored  |
| VISA_LOGGING_FILE_FORMAT |  | The format of the log messages, eg "%d{yyyy-MM-dd HH:mm:ss.SSS,CET} %-5level [%-40.40logger{10}] - %msg%n" |
| VISA_LOGGING_FILE_ARCHIVED_FILE_COUNT | 1  | The number of archive files to keep  |

#### Syslog

| Environment variable | Default | Description |
|---|---|---|
| VISA_LOGGING_SYSLOG_HOST |   | The Syslog host  |
| VISA_LOGGING_SYSLOG_PORT | 514  | The Syslog port  |
| VISA_LOGGING_SYSLOG_FACILITY | local0  |  The Syslog facility|
| VISA_LOGGING_SYSLOG_THRESHOLD | INFO  |  The Syslog logging level |
| VISA_LOGGING_SYSLOG_FORMAT |   |  The Syslog log format |

(deployment_environment_variables_web_services)=
### VISA web services

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_SERVICE_CLIENT_URL |   | The [VISA Accounts](development_accounts_service) authentication URL eg http://accounts:8089/api/authenticate |
| VISA_SECURITY_GROUP_SERVICE_CLIENT_ENABLED | false  | Enables the use of the [VISA Security Group](development_security_groups) micro-service. This micro service provides site logic to determine the security groups for an instance.  |
| VISA_SECURITY_GROUP_SERVICE_CLIENT_URL |   |  The VISA Security Group Service URL eg http://security-groups:8090/api/securitygroups |
| VISA_SECURITY_GROUP_SERVICE_CLIENT_AUTH_TOKEN |   |  The authentication token to send to the Security Group service |

(deployment_environment_variables_openstack)=
### OpenStack cloud provider

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLOUD_IDENTITY_ENDPOINT |   | The OpenStack identity endpoint  |
| VISA_CLOUD_COMPUTE_ENDPOINT |   |  The OpenStack compute endpoint |
| VISA_CLOUD_IMAGE_ENDPOINT |   |  The OpenStack image endpoint |
| VISA_CLOUD_NETWORK_ENDPOINT |   |  The OpenStack network endpoint |
| VISA_CLOUD_APPLICATION_ID |   |  The application ID to authorise VISA API Server to use the OpenStack API |
| VISA_CLOUD_APPLICATION_SECRET |   |  The application secret to authorise VISA API Server to use the OpenStack API |
| VISA_CLOUD_ADDRESS_PROVIDER |   |  The address provider name for instances in OpenStack |
| VISA_CLOUD_ADDRESS_PROVIDER_UUID |   |  The address privider UURD for instances in OpenStack |
| VISA_CLOUD_SERVER_NAME_PREFIX |   |  The prefix used for all instances created by VISA in OpenStack |

(deployment_environment_variables_vdi)= 
### Remote Desktop (virtual desktop infrastructure VDI)

| Environment variable | Default | Description |
|---|---|---|
| VISA_VDI_ENABLED |  true | Enables the remote desktops in VISA  |
| VISA_VDI_HOST | localhost  |  The hostname on which the Remote Desktop HTTP server is listening on |
| VISA_VDI_PORT | 8087  |  The port on which to run the Remote Desktop HTTP server |
| VISA_VDI_CORS_ORIGIN |   |  The CORS origin of the Remote Desktop HTTP server |
| VISA_VDI_PING_TIMEOUT | 15000  |  A simple message is sent regularly between VISA and each front-end client using a remote desktop to ensure that the connection is still active. This environment variable sets the timeout for having a response to a ping message between the API Server and the client UI: the connection is closed to the instance if this time is exceeded.  |
| VISA_VDI_PING_INTERVAL | 3000  |  The interval for sending ping messages to the client UI |
| VISA_VDI_REDIS_ENABLED |  false |  Enables a Redis pub-sub server (this is required for load balancing, to enable messaging between the applications) |
| VISA_VDI_REDIS_URL |   |  The URL of the Redis server (required for load balancing) |
| VISA_VDI_REDIS_PASSWORD |   | The password for the Redis server (required for load balancing)  |
| VISA_VDI_REDIS_DATABASE |  0 |  the database ID of the Redis server (required for load balancing) |
| VISA_VDI_OWNER_DISCONNECTION_POLICY | DISCONNECT_ALL  |  Determines the policy of how to handle shared connections when the owner disconnects. Possible values are DISCONNECT_ALL (disconnecting shared connections) and LOCK_ROOM (to keep connections open but disable all interactions) |
| VISA_VDI_CLEANUP_SESSIONS_ON_STARTUP | false  | As an admin option, desktop sessions can be cleaned when starting the server (if any are left open in the database). If load-balancing, only one server should do this.  |
| VISA_VDI_SIGNATURE_PRIVATE_KEY_PATH |   | The path to the private key used for the VISA PAM module to encrypt connection details to a remote desktop  |
| VISA_VDI_SIGNATURE_PUBLIC_KEY_PATH |   |  The path to the public key used by the VISA PAM module |
| VISA_VDI_GUACD_PARAMETER_PROTOCOL |  rdp | A guacamole parameter specifying the remote desktop protocol  |
| VISA_VDI_GUACD_PARAMETER_IGNORE_CERT | true  | A guacamole parameter to ignore the RDP certificate on the remote server  |
| VISA_VDI_GUACD_PARAMETER_PORT | 3389  | The port used for the RDP protocol  |

### Scheduler

| Environment variable | Default | Description |
|---|---|---|
| VISA_SCHEDULER_ENABLED |  true | The scheduler of VISA is used to update the instance states, run instance commands (start, stop, reboot, etc), perform lifetime management, etc. This option enables the schedule. In a load-balanced enviroment you must ensure that only one server has an active scheduler. |
| VISA_SCHEDULER_TASK_MANAGER_NUMBER_THREADS |  5 |  This specified the number of threads to use to run instance commands. Note that for a specific instance, only one command is run at a time. |

### Instance lifetime management

| Environment variable | Default | Description |
|---|---|---|
| VISA_INSTANCE_USER_MAX_LIFETIME_DURATION_HOURS | 336  | Sets the maximum lifetime, specified in hours, of instances for *normal* users.  |
| VISA_INSTANCE_STAFF_MAX_LIFETIME_DURATION_HOURS | 1440  |  Sets the maximum lifetime, specified in hours, of instances for *staff* users. |
| VISA_INSTANCE_USER_MAX_INACTIVITY_DURATION_HOURS | 96  |  Sets the maximum time of inactivity of an instance before it is deleted, specified in hours, for *normal* users. |
| VISA_INSTANCE_STAFF_MAX_INACTIVITY_DURATION_HOURS | 192  |  Sets the maximum time of inactivity of an instance before it is deleted, specified in hours, for *staff* users. |

(deployment_environment_variables_user_notification)= 
### User notifications

| Environment variable | Default | Description |
|---|---|---|
| VISA_NOTIFICATION_EMAIL_ADAPTER_ENABLED | false  | Users are notified by email when their instance will be deleted (24 hours before) or when then they have been added as a member of someone else's instance. This environment variable enables this mechanism.  |
| VISA_NOTIFICATION_EMAIL_ADAPTER_HOST |   |  Specifies the SMTP host for sending notification emails |
| VISA_NOTIFICATION_EMAIL_ADAPTER_PORT |   |  Specified the port of the SMTP server sending notification emails |
| VISA_NOTIFICATION_EMAIL_ADAPTER_FROM_EMAIL_ADDRESS |   |  The address of the sender of emails to users |
| VISA_NOTIFICATION_EMAIL_ADAPTER_BCC_EMAIL_ADDRESS | null  |  Optionally allows a BCC of the email to be sent to another address (a development account for example) |
| VISA_NOTIFICATION_EMAIL_ADAPTER_ADMIN_EMAIL_ADDRESS |   |  An admin email address can be set to allow for the notification when instances are created.  |
| VISA_NOTIFICATION_EMAIL_ADAPTER_TEMPLATES_DIRECTORY | emails/templates/  |  To allow for the customisation of emails, the templates provided by VISA can be modified. This environment variable sets the location of the email templates. |

### Client configuration

The VISA API server has an endpoint that allows a client to obtain configuration values (included VISA version number, IDP settings, analytics, etc).

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLIENT_CONFIG_CONTACT_EMAIL | null  | This sets the VISA contact email that is visible on a number of pages in the frontend  |

(deployment_environment_variables_login)=
#### Login

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLIENT_CONFIG_LOGIN_ISSUER |   |  Specifies the IDP OpenID Connect login URL (eg for Keycloak https://my.keycloak/auth/realms/master) |
| VISA_CLIENT_CONFIG_LOGIN_CLIENT_ID |   |  Specifies the client ID for the login process |
| VISA_CLIENT_CONFIG_LOGIN_SCOPE | `openid offline_access` | The required scope for the authentication (unlikely to be different from the default |
| VISA_CLIENT_CONFIG_LOGIN_SHOW_DEBUG_INFORMATION | `false` |  Enables debug logging information on the client side (visa-web) |
| VISA_CLIENT_CONFIG_LOGIN_SESSION_CHECKS_ENABLED | `true` |  Checks the the current OpenID Connect IDP session is still active |

#### Analytics

The analytics environment variables are associated to the use of a [Matamo](https://matomo.org/) analytics server

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLIENT_CONFIG_ANALYTICS_ENABLED | false  |  Enables the use of a Matamo analytics server. |
| VISA_CLIENT_CONFIG_ANALYTICS_SITE_ID |   |  Specified the Site ID for VISA in the analytics server. |

#### Desktop

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLIENT_CONFIG_DESKTOP_ALLOWED_CLIPBOARD_URL_HOSTS | []  |  By specifying the contents of the clipboard of the remote desktop, a remote application can make VISA open a popup in the client browser to request the user to open another URL (for example to open an electronic logbook, data portal, chat window). To ensure that the URL is acceptiblen, VISA is configured with a list of accepted hosts.  |
| VISA_CLIENT_CONFIG_DESKTOP_KEYBOARD_LAYOUTS | []  |  Specifies the list of keyboard layouts that are proposed to a user, eg [{"layout":"en-gb-qwerty","name":"English (UK) keyboard","selected":true},{"layout":"fr-fr-azerty","name":"French keyboard (azerty)","selected":false}]  |


(deployment_environment_variables_accounts)= 
## VISA Accounts

### Server

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_SERVER_PORT |  4000 | The port on which to run the server  |
| VISA_ACCOUNTS_SERVER_HOST | localhost  | The hostname on which the server is listening on  |

### IDP

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_IDP |   |  URL to the OpenID discovery endpoint (eg https://my.idp.server/.well-known/openid-configuration) which will then be used to validate a token. This should be matched to the [login URL provided above](deployment_environment_variables_login) which is used to generate the token. |
| VISA_ACCOUNTS_CLIENT_ID |   | The Client ID as configured by the OpenID provider  |
| VISA_ACCOUNTS_IDP_USERINFO_SIGNED_RESPONSE_ALG | null | Allows you to set the encoding algorithm of the UserInfo Response (eg RS256) if enabled in the IDP |
| VISA_ACCOUNTS_IDP_TIMEOUT_MS | 2500 | Sets the HTTP request timeout (in milliseconds) to the IDP |
| VISA_ACCOUNTS_IDP_CACHE_EXPIRATION_S | 0 | Specifies the expiration in seconds of cached IDP responses. This allows you to reduce the number of calls to the IDP and returns the same response for a given token (UserInfo or error). By default the cache is not activated (a cache expiration of > 0s is required to activate the cache). |

### Attribute provider

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_ATTRIBUTE_PROVIDER |   |  The attribute provider is used to provide site-specific details about the user and the account and can be used to send additional information to the instance in OpenStack. You can find here details on [how to develop and integrate an attribute provider in](development_accounts_attribute_provider) VISA. this environment variable sets the absolute or relative path to the attribute provider. |

### Logging

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_LOG_LEVEL | info  |  Log level |
| VISA_ACCOUNTS_LOG_TIMEZONE |   | The timezone for the formatting the time in the application log  |

### Syslog

The syslog environment variables are optional: if none are set then log messages are not forwarded to a sys log server. When using the docker container, the ```TZ``` environment variable is required too to ensure that the container runs at the same timezone as the host, otherwise the syslog may not have the correct time.

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_LOG_SYSLOG_HOST |   | The Syslog host (optional) |
| VISA_ACCOUNTS_LOG_SYSLOG_PORT |   |  The Syslog port (optional) |
| VISA_ACCOUNTS_LOG_SYSLOG_APP_NAME |   |  Application name used by Syslog (optional) |

(deployment_environment_variables_jupyter_proxy)= 
## VISA Jupyter Proxy

### Server

| Environment variable | Default | Description |
|---|---|---|
| VISA_JUPYTER_PROXY_SERVER_PORT | 8088  | The port on which to run the server  |
| VISA_JUPYTER_PROXY_SERVER_HOST | localhost  |  The hostname on which the server is listening on |
| VISA_JUPYTER_PROXY_CACHE_REFRESH_TIME_S | 60  | Authorisation access and the IP address of instances are cached in the JupyterProxy to reduce the number of calls the to VISA API server. this environment variable sets how long a cached entry lasts for.  |
| VISA_JUPYTER_PROXY_STORAGE_DIR | data  |  The local data storage directory (used primarily for maintaining session details if the proxy needs to be restarted). |

### Logging

| Environment variable | Default | Description |
|---|---|---|
| VISA_JUPYTER_PROXY_LOG_LEVEL | info  | Log level  |
| VISA_JUPYTER_PROXY_LOG_TIMEZONE |   |  The timezone for the formatting the time in the application log |

### Syslog

The syslog environment variables are optional: if none are set then log messages are not forwarded to a sys log server. When using the docker container, the ```TZ``` environment variable is required too to ensure that the container runs at the same timezone as the host, otherwise the syslog may not have the correct time.

| Environment variable | Default | Description |
|---|---|---|
| VISA_JUPYTER_PROXY_LOG_SYSLOG_HOST |   |  The Syslog host (optional) |
| VISA_JUPYTER_PROXY_LOG_SYSLOG_PORT |   |  The Syslog port (optional) |
| VISA_JUPYTER_PROXY_LOG_SYSLOG_APP_NAME |   | Application name used by Syslog (optional) |

(deployment_environment_variables_jupyter_proxy_port)=
### Jupyter

| Environment variable | Default | Description |
|---|---|---|
| VISA_JUPYTER_PROXY_JUPYTER_PORT | 8888  |  The Jupyter Notebook Server, running on the instance, can be set up to run a specific port. This environmnet variable sets the oort of the Jupyter Notebook server (by default 8888). |

### VISA API

| Environment variable | Default | Description |
|---|---|---|
| VISA_JUPYTER_PROXY_API_HOST | localhost  | Host of the VISA API Server REST API, used to authenticate the request and obtain an IP address from the instance ID |
| VISA_JUPYTER_PROXY_API_PORT |  8086 |  Port of the VISA API Server REST API |

