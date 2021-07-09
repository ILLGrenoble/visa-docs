(deploying_database)=
# Database

VISA uses a relational database to store information about the compute instances (instances, images, flavours, sessions, members, experiments) and also for user and facility data.

The user and facility data is injected independently into VISA as described in the [ETL section](development_etl).

We recomend the use of a PostgreSQL server but the mapping should work on other relational database providers.

(deploying_database_initialisation)=
## Table initialisation

The VISA API Server, which maps the tables to objects in the application, automatically generates the tables, sequences and constraints. When specifying a schema of the database in the configuration of VISA, the schema must exist already in the database. Initial data is also loaded automatically into the *roles* and *protocols* tables.

The database schema can also be created manually using <a href="../_static/files/visa-db-init.sql">this database initialisation file</a>. You may want to do this if you wish to run the ETL process before starting up VISA for the first time.

If you wish to load the necessary fixtures data manually into the database before using visa (for example to run the ETL beforehand), you must use the <a href="../_static/files/visa-db-fixtures.sql">database fixtures file</a> provided here.

## Load balancing requirements

In all cases, we recommend installing the database on a separate server to the VISA deployment. This isn't an absolute necessity but can simplify the maintenance of the system.

However, when [load-balancing VISA](deployment_load_balancing) this becomes more important. As well as installing a database a Redis data store also has to be installed (used as a message broker) and it makes sense to combine the database and redis installation on the same server.


