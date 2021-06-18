(deployment_environment_variables)= 
# Environment variables

The VISA platform is highly configurable through an array of environment variables. This section describes all the environment variables for the different applications and offers suggested values.

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
| VISA_LOGGING_SYSLOG_HOST |   |   |
| VISA_LOGGING_SYSLOG_PORT | 514  |   |
| VISA_LOGGING_SYSLOG_FACILITY | local0  |   |
| VISA_LOGGING_SYSLOG_THRESHOLD | INFO  |   |
| VISA_LOGGING_SYSLOG_FORMAT |   |   |

### VISA web services

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_SERVICE_CLIENT_URL |   |   |
| VISA_SECURITY_GROUP_SERVICE_CLIENT_ENABLED | false  |   |
| VISA_SECURITY_GROUP_SERVICE_CLIENT_URL |   |   |
| VISA_SECURITY_GROUP_SERVICE_CLIENT_AUTH_TOKEN |   |   |

### OpenStack cloud provider

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLOUD_IDENTITY_ENDPOINT |   |   |
| VISA_CLOUD_COMPUTE_ENDPOINT |   |   |
| VISA_CLOUD_IMAGE_ENDPOINT |   |   |
| VISA_CLOUD_APPLICATION_ID |   |   |
| VISA_CLOUD_APPLICATION_SECRET |   |   |
| VISA_CLOUD_ADDRESS_PROVIDER |   |   |
| VISA_CLOUD_ADDRESS_PROVIDER_UUID |   |   |
| VISA_CLOUD_SERVER_NAME_PREFIX |   |   |

### Remote Desktop (virtual desktop infrastructure VDI)

| Environment variable | Default | Description |
|---|---|---|
| VISA_VDI_ENABLED |  true |   |
| VISA_VDI_HOST | localhost  |   |
| VISA_VDI_PORT | 8087  |   |
| VISA_VDI_CORS_ORIGIN |   |   |
| VISA_VDI_PING_TIMEOUT | 15000  |   |
| VISA_VDI_PING_INTERVAL | 3000  |   |
| VISA_VDI_REDIS_ENABLED |  false |   |
| VISA_VDI_REDIS_URL |   |   |
| VISA_VDI_REDIS_PASSWORD |   |   |
| VISA_VDI_REDIS_DATABASE |  0 |   |
| VISA_VDI_OWNER_DISCONNECTION_POLICY | DISCONNECT_ALL  |   |
| VISA_VDI_CLEANUP_SESSIONS_ON_STARTUP | false  |   |
| VISA_VDI_SIGNATURE_PRIVATE_KEY_PATH |   |   |
| VISA_VDI_SIGNATURE_PUBLIC_KEY_PATH |   |   |
| VISA_VDI_GUACD_PARAMETER_PROTOCOL |  rdp |   |
| VISA_VDI_GUACD_PARAMETER_IGNORE_CERT | true  |   |
| VISA_VDI_GUACD_PARAMETER_PORT | 3389  |   |

### Scheduler

| Environment variable | Default | Description |
|---|---|---|
| VISA_SCHEDULER_ENABLED |  true |   |
| VISA_SCHEDULER_TASK_MANAGER_NUMBER_THREADS |  5 |   |

### Instance lifetime management

| Environment variable | Default | Description |
|---|---|---|
| VISA_INSTANCE_USER_MAX_LIFETIME_DURATION_HOURS | 336  |   |
| VISA_INSTANCE_STAFF_MAX_LIFETIME_DURATION_HOURS | 1440  |   |
| VISA_INSTANCE_USER_MAX_INACTIVITY_DURATION_HOURS | 96  |   |
| VISA_INSTANCE_STAFF_MAX_INACTIVITY_DURATION_HOURS | 192  |   |

### User notifications

| Environment variable | Default | Description |
|---|---|---|
| VISA_NOTIFICATION_EMAIL_ADAPTER_ENABLED | false  |   |
| VISA_NOTIFICATION_EMAIL_ADAPTER_HOST |   |   |
| VISA_NOTIFICATION_EMAIL_ADAPTER_PORT |   |   |
| VISA_NOTIFICATION_EMAIL_ADAPTER_FROM_EMAIL_ADDRESS |   |   |
| VISA_NOTIFICATION_EMAIL_ADAPTER_BCC_EMAIL_ADDRESS | null  |   |
| VISA_NOTIFICATION_EMAIL_ADAPTER_ADMIN_EMAIL_ADDRESS |   |   |
| VISA_NOTIFICATION_EMAIL_ADAPTER_TEMPLATES_DIRECTORY | emails/templates/  |   |

### Client configuration

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLIENT_CONFIG_CONTACT_EMAIL | null  |   |

#### Login

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLIENT_CONFIG_LOGIN_REALM |   |   |
| VISA_CLIENT_CONFIG_LOGIN_URL |   |   |
| VISA_CLIENT_CONFIG_LOGIN_CLIENT_ID |   |   |

#### Analytics

The analytics environment variables are associated to the use of a Matamo analytics server

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLIENT_CONFIG_ANALYTICS_ENABLED | false  |   |
| VISA_CLIENT_CONFIG_ANALYTICS_SITE_ID |   |   |

#### Desktop

| Environment variable | Default | Description |
|---|---|---|
| VISA_CLIENT_CONFIG_DESKTOP_ALLOWED_CLIPBOARD_URL_HOSTS | []  |   |
| VISA_CLIENT_CONFIG_DESKTOP_KEYBOARD_LAYOUTS | []  |   |



## VISA Accounts

### Server

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_SERVER_PORT |  4000 | The port on which to run the server  |
| VISA_ACCOUNTS_SERVER_HOST | localhost  | The hostname on which the server is listening on  |

### IDP

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_IDP |   |  URL to the OpenID discovery endpoint (eg https://server.com/.well-known/openid-configuration) |
| VISA_ACCOUNTS_CLIENT_ID |   | The Client ID as configured by the OpenID provider  |

### Attribute provider

| Environment variable | Default | Description |
|---|---|---|
| VISA_ACCOUNTS_ATTRIBUTE_PROVIDER |   |  Absolute or relative path to the attribute provider  |

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

## VISA Jupyter Proxy

### Server

| Environment variable | Default | Description |
|---|---|---|
| VISA_JUPYTER_PROXY_SERVER_PORT | 8088  | The port on which to run the server  |
| VISA_JUPYTER_PROXY_SERVER_HOST | localhost  |  The hostname on which the server is listening on |
| VISA_JUPYTER_PROXY_CACHE_REFRESH_TIME_S | 60  | Refresh time for cache entries (cahed IP address of instances)  |
| VISA_JUPYTER_PROXY_STORAGE_DIR | data  |  local data storage directory |

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

### Jupyter

| Environment variable | Default | Description |
|---|---|---|
| VISA_JUPYTER_PROXY_JUPYTER_PORT | 8888  |  Port of the Jupyter Notebook server on the instance |

### VISA API

| Environment variable | Default | Description |
|---|---|---|
| VISA_JUPYTER_PROXY_API_HOST | localhost  | Host of the VISA API Server REST API |
| VISA_JUPYTER_PROXY_API_PORT |  8086 |  Port of the VISA API Server REST API |

