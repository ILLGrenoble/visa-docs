(deploying-upgrade-from-version-2-to-3)=
# Upgrading VISA from Version 2.X to 3.X

[18/11/2024]

In 2024 VISA was redevelopped to run using the Quarkus framework (migrating from Dropwizard). While attempting to maintain backward compatibility with the previous version of VISA some minor changes to the deployment are necessary when doing the upgrade.

## Environment variable changes

#### File Logging

The following changes are needed if you want to specifically save the application log in a file. 

 - `VISA_LOGGING_FILE_ENABLED`
 
   **New.** You can now explicitly activate/deactivate the file logging. By default it is activated.

 - `VISA_LOGGING_FILE_MAX_FILE_SIZE`
 
   **Updated.** Format has changed from (eg) `100MB` to `100M`

 - `VISA_LOGGING_FILE_FORMAT`

   **Updated.** The format pattern has changed. See the [Quarkus documentation](https://quarkus.io/guides/logging#logging-format) for full details. An example of the changes is shown below.

   Old format: `%d{yyyy-MM-dd HH:mm:ss.SSS,CET} %-5level [%-40.40logger{10}] - %msg%n`

   New format: `%d{yyyy-MM-dd HH:mm:ss.SSS} %-5p [%-40.40c{3.}] - %s%e%n`

#### Syslog configuration

The following changes are needed for syslog setup. 

 - `VISA_LOGGING_SYSLOG_ENABLED`
 
   **New.** You can now explicitly activate/deactivate the syslog logging. By default it is activated.

 - `VISA_LOGGING_SYSLOG_HOST`
 
   **Deprecated.** See `VISA_LOGGING_SYSLOG_ENDPOINT` for the replacement.

 - `VISA_LOGGING_SYSLOG_PORT`
 
   **Deprecated.** See `VISA_LOGGING_SYSLOG_ENDPOINT` for the replacement.

 - `VISA_LOGGING_SYSLOG_ENDPOINT`

   **New.** To configure the syslog server you now need to specify both the host and the port together, eg `mysyslog.server.org:514`

 - `VISA_LOGGING_SYSLOG_APP_NAME`

   **New.** You must specify the application name as registered by syslog.

 - `VISA_LOGGING_SYSLOG_TYPE`

   **New.** Defines the syslog protocol. Defaults to `rfc3164` but can also be `rfc5424`.

 - `VISA_LOGGING_SYSLOG_FACILTY`

   **Updated.** The syslog facilty values have chanegd. For example `local0` becomes `local-use-0`. See the [Quarkus documentation](https://quarkus.io/guides/logging#quarkus-core_quarkus-log-handler-syslog-syslog-handlers-facility) for more details. 

#### Email notification of errors

VISA provides the capability of sending emails (to the dev team for example) when errors occur.

 - `VISA_LOGGING_EMAIL_APPENDER_ENABLED`
 
   **New.** You can now explicitly activate/deactivate the email notifications. By default they are deactivated.

 - `VISA_LOGGING_EMAIL_SUBJECT`
 
   **Updated.** Previously each individual error produced an email and the error was used injected into the `VISA_LOGGING_EMAIL_SUBJECT` template. Now the `VISA_LOGGING_EMAIL_SUBJECT` is simply a prefix to an email subject. For example `[VISA]: An error occurred %logger{20} - %msg` is now simply `[VISA]: Error report`

#### General

- `VISA_LOGGING_TIMEZONE`

  Previously it was possible to set a logging timezone for all loggers. This is no longer possible and must be set in individual log formats.

## Reverse proxy changes

A couple of changes have been made to the backend endpoints, namely for GraphQL and websockets. If you use reverse proxy (eg Nginx) to redirect trafic arriving on certain endpoints then you will need to update your configuration. Below we give examples of the new configuration for Nginx.

### GraphQL

Previously GraphQL calls arrived to the `/graphql` endpoint. With Quarkus this has had to be changed to `/api/graphql`. As such you no longer need to explicitly manage this (as it should already be managed by a `/api` configuration). If you have an entry such as 

```
    location /graphql {
      proxy_pass       http://api:8086/graphql;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
    }
``` 

you can now delete this.

### Websockets

Previously Socket.io was used for remote desktop communication. Now a standard websocket is used and with Quarkus the endpoint is now with a base path of `/api/ws`. In fact 2 principal websockets are opened with this base path. Unlike Socket.io, no rewrite rule is needed either.

The websockets managed by the api-server are now configured with the following Nginx configuration:

```
    # New websocket connections configuration
    location /api/ws {
          proxy_pass http://api:8086/api/ws;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_http_version 1.1;
          proxy_redirect off;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $http_host;
    }
```

Previous configs on the old endpoint, such as 

```
    # Old socket.io connections configuration
    location /ws/vdi {
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_http_version 1.1;
          proxy_redirect off;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $http_host;
          proxy_pass http://api:8087/socket.io;
    }
```

can be deleted.

### Websocket server port

Note that there is another difference for the api-server websockets: they are now exposed on the port `8086`, the same as the api-server REST API. 

You no longer need to explicity expose the legacy port `8087`.

## Docker Container Registry

The new Docker containers for VISA are now available on the GitHub Container Register (ghcr.io):

 - visa-api-server: [ghcr.io/illgrenoble/visa-api-server](https://github.com/illgrenoble/visa-api-server/pkgs/container/visa-api-server)
 - visa-web: [ghcr.io/illgrenoble/visa-web](https://github.com/illgrenoble/visa-api-server/pkgs/container/visa-web)
 - visa-accounts: [ghcr.io/illgrenoble/visa-accounts](https://github.com/illgrenoble/visa-api-server/pkgs/container/visa-accounts)
 - visa-jupyter-proxy: [ghcr.io/illgrenoble/visa-jupyter-proxy](https://github.com/illgrenoble/visa-api-server/pkgs/container/visa-jupyter-proxy)

 [Dockerhub](https://registry.hub.docker.com/u/illgrenoble) currently still has the same Docker images but will be deprecated shortly and more recent versions of VISA images may not be available.

## Upgrade procedure

The upgrade of VISA has no non-reversable impacts on the database so rolling back to 2.X versions is simple. We do however recommend saving copies of the environment variable files and any Ngix (or equivalent) configuration files.

Once modifications (outlined above) to the environment variables and Nginx congifuration files are done then the process of updating the docker image versions is trivial.

## Version Rollback

To revert to the 2.X version, please replace your copied environment variables file and Nginx configuration and change to the latest 2.X version of VISA. 

Database changes to the 3.X version are trivial and do not impact the 2.X version.



