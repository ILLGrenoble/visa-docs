(development_environment)=
# Development environment

The following sections describe how to build and run locally each application of the VISA platform. 

To debug the applications we would recommend running the applications in an IDE such as IntelliJ IDEA or VSCode.

## VISA API Server

To build and run locally the VISA API Server please follow the following commands.

1. Clone the repository from [ILLGrenoble](https://github.com/ILLGrenoble) or a forked project

   ```bash
   git clone https://github.com/ILLGrenoble/visa-api-server.git
   ```

2. Build the project using Maven 

   ```bash
   cd visa-api-server
   mvn package
   ```

3. Run the application

   ```bash
   java -jar visa-app/target/visa-app.jar server visa-app/configuration.yml
   ```

   You must set up a number of [environment variables](deployment_environment_variables_api_server) for the VISA API Server to run correctly. It is usually more convenient to put these into a `.env` file. The following script will allow you to read these variables from `.env` and launch the server in the same environment:

   ```bash
   #!/bin/bash

   export $(egrep -v '^#' .env | xargs)
   java -jar visa-app/target/visa-app.jar server visa-app/configuration.yml
   ```

## VISA Web

The following commands will build and launch the VISA Web UI:

1. Clone the repository from [ILLGrenoble](https://github.com/ILLGrenoble) or a forked project

   ```bash
   git clone https://github.com/ILLGrenoble/visa-web.git
   ```

2. Install the dependencies using NPM

   ```bash
   cd visa-web
   npm install
   ```

3. Build and run the application using a development server

   ```bash
   npm start
   ```

   The development version of VISA Web will attempt to connect to a backend on localhost.

## VISA Jupyter Proxy

The following commands will build and launch the VISA Jupyter Proxy:

1. Clone the repository from [ILLGrenoble](https://github.com/ILLGrenoble) or a forked project

   ```bash
   git clone https://github.com/ILLGrenoble/visa-jupyter-proxy.git
   ```

2. Install the dependencies

   ```bash
   cd visa-jupyter-proxy
   npm install
   ```

3. Build and run the Node.js application

   ```bash
   npm run start
   ```

   You must set up a number of [environment variables](deployment_environment_variables_jupyter_proxy) for the VISA Jupyter Proxy. These can be read automatically from a `.env` file.

## VISA Accounts 

The following commands will build and launch VISA Accounts:

1. Clone the repository from [ILLGrenoble](https://github.com/ILLGrenoble) or a forked project

   ```bash
   git clone https://github.com/ILLGrenoble/visa-accounts.git
   ```

2. Install the dependencies

   ```bash
   cd visa-accounts
   npm install
   ```

3. Build and run the Node.js application

   ```bash
   npm run start
   ```
   You must set up a number of [environment variables](deployment_environment_variables_accounts) for VISA Accounts. These can be read automatically from a `.env` file.
   
   You will also have to provider an [*attribute provider*](development_accounts_attribute_provider) to obtain account attributes. A dummy one is available for testing in the [VISA Accounts repository](https://github.com/ILLGrenoble/visa-accounts/tree/main/accountAttributeProviders).

 

