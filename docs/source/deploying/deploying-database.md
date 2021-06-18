# Database

VISA uses a relational database to store information about the compute instances (instances, images, flavours, sessions, members, experiments) and also for user and facility data.

The user and facility data is injected independently into VISA as described in the [ETL section](development_etl).

We recomend the use of a PostgreSQL server but the mapping should work on other relational database providers.

# Table initialisation

The VISA API Server, which maps the tables to objects in the application, automatically generates the tables, sequences and constraints. When specifying a schema of the database in the configuration of VISA, the schema must exist already in the database. 

The database schema can also be created manually using <a href="../_static/files/visa-db-init.sql">this database initialisation file</a>. You may want to do this if you wish to run the ETL process before starting up VISA for the first time.

In both cases, the database has to have some data preloaded for the user roles and image protocols. The <a href="../_static/files/visa-db-fixtures.sql">database fixtures file</a> must be loaded.




