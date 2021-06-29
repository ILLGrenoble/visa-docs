(deploying_monitoring)=
# Monitoring

Once deployed and running in a production environment, it is useful to know if the system is running smoothly or if users are having problems. There are a number of ways that can help in this.

## Admin dashboard

The [Dashboard UI](admin_dashboard) in the Admin area of VISA gives an overall view of the real-time usage of VISA.

Amongst other, the Dashboard give a quick view of 
- The number of instances
- The number of sessions
- The number of recently-active sessions
- Latest instances
- Latest active users 

More information on Remote Desktop usage can be found in the [Sessions UI](admin_sessions) of VISA too.

## Email notifications

VISA can be [configured](deployment_environment_variables_user_notification) with an admin email address which will notify the admin every time a new instance is created.

Emails can also be sent whenever a error occurs in the VISA API Server by [configuring the email adapter](deployment_environment_variables_email_appender). The error and stack trace are stored in the log to help with debugging a problem. The email also notified very quickly an admin when a system problem is occurring.

## Application logs

The application logs provide a rich source of information on usage of VISA. The easiest way to access the logs is to go to the deployment directory where the `docker-compose` file is. Running the following command will show the logs for the whole VISA platform

```bash
docker-compose logs -f
```

