(deploying_initial_test)=
# Initial tests as admin

With the [authentication](deployment_authentication), [database](deploying_database) and the [VISA applications deployed](deployment_docker_compose) and [configured](deployment_environment_variables), you can make some initial tests before [integrating all the user and facility data](development_etl) required for production deployment. 

If you log into VISA you should find that a user has been added to the `users` table of the database. Assuming you want the admin features (required at least to add images and flavours) you need to give yourself the correct roles.

The [database initialisation](deploying_database_initialisation) page provides some fixtures to add to the database, including the user roles. We recommend you give yourself the *ADMIN*, *STAFF* and *IT_SUPPORT* roles to see the full functionality of the VISA. To do this you need to run the following SQL (replacing *{your_user_id}* with your ID from the users table):

```sql
insert into user_role (user_id, role_id) values ({your_user_id}, (select id from role where name = 'ADMIN'));
insert into user_role (user_id, role_id) values ({your_user_id}, (select id from role where name = 'STAFF'));
insert into user_role (user_id, role_id) values ({your_user_id}, (select id from role where name = 'IT_SUPPORT'));
```

Having done this you will see in VISA that you have access to the *Support* and *Admin* sections.

