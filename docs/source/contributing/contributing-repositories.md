# Source repositories

A number of different source repositories go into the VISA platform and are published as Open Source. These are available on the [ILL GitHub organisation](https://github.com/ILLGrenoble).

Details of each repository is given below.

|Application | Source code | Language | Description |
|---|---|---|---|
| VISA API Server | [visa-api-server source](https://github.com/ILLGrenoble/visa-api-server) | Java | The main business logic and REST API for the VISA application. Management of remote desktops is also handled here. |
| VISA Web UI | [visa-web source](https://github.com/ILLGrenoble/visa-web) | TypeScript |The frontend UI based on the angular framework |
| VISA Jupyter Proxy | [visa-jupyter-proxy source](https://github.com/ILLGrenoble/visa-jupyter-proxy) | TypeScript | An HTTP proxy to forward requests to the JupyterLab server running on the instances |
| VISA Accounts | [visa-accounts source](https://github.com/ILLGrenoble/visa-accounts) | TypeScript | The account authentication and attribute provider |
| VISA DB ETL Py | [visa-db-etl-py source](https://github.com/ILLGrenoble/visa-db-etl-py) | Python | A Python library to be used to load data into the VISA database |
| VISA PAM | [visa-pam source](https://github.com/ILLGrenoble/visa-pam) | C | The VISA Pluggable Authentication Module (PAM) used to authenticate access to Remote Desktops |
