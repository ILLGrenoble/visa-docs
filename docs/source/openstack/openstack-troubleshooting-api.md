(openstack_troubleshooting_api)=

# Troubleshooting Openstack API

This document describes how to test that your OpenStack API is responding correctly to requests.

The following HTTP request examples uses [httpie](https://httpie.io/) to perform the requests to the API endpoints.

We will need to export some variables before we can send requests to the _authentication_ and _compute_ APIs.

| Name                  | Description                                                                                                                                                                                                                                                                                                   | Example value                     |   |   |
|-----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|---|---|
| OS_IDENTITIY_ENDPOINT | The [endpoint](https://docs.openstack.org/api-ref/identity/v3/index.html) to authenticate to openstack.  This is normally running on port 5000. If you are using HTTPS, then please ensure you have a valid certificate. VISA API Server will throw an error if the certificate is invalid (i.e. self-signed) | http://openstack.example.com:5000 |   |   |
| OS_COMPUTE_ENDPOINT   | The endpoint for issue [compute](https://docs.openstack.org/api-ref/compute/) requests to openstack. This is normally running on port 8774. If you are using HTTPS, then please ensure you have a valid certificate. VISA API Server will throw an error if the certificate is invalid (i.e. self-signed)     | http://openstack.example.com:8774 |   |   |
| OS_APPLICATION_ID     | Please see [here](openstack_application_credentials) for documentation about application credentials                                                                                                                                                               | N/A                               |   |   |
| OS_APPLICATION_SECRET | Please see [here](openstack_application_credentials) for documentation about application credentials               


## Authenticating to Openstack

Using the exported variables, we can now test the authentication to openstack. Please see [here](https://docs.openstack.org/api-ref/identity/v3/index.html?expanded=token-authentication-with-explicit-unscoped-authorization-detail#token-authentication-with-explicit-unscoped-authorization) for documentation about the endpoint we are calling.

```bash
http -v --header POST $OS_IDENTITY_ENDPOINT/v3/auth/tokens auth:='{"identity":{"methods":["application_credential"],"application_credential":{"id":"'"$OS_APPLICATION_ID"'","secret":"'"$OS_APPLICATION_SECRET"'"}}}'
```

You will get a *201 Created* response if the authentication was successful. If it wasn't successful then please check your openstack configuration.

>Remove the `--header` option if you want to see the full response instead of just the headers.

An example response:

```
{
    "token": {
        "methods": [
            "token"
        ],
        "expires_at": "2015-11-05T22:00:11.000000Z",
        "user": {
            "domain": {
                "id": "default",
                "name": "Default"
            },
            "id": "10a2e6e717a245d9acad3e5f97aeca3d",
            "name": "admin",
            "password_expires_at": null
        },
        "audit_ids": [
            "mAjXQhiYRyKwkB4qygdLVg"
        ],
        "issued_at": "2015-11-05T21:00:33.819948Z"
    }
}
```

Example headers:

```
HTTP/1.1 201 CREATED
Connection: close
Content-Length: 6141
Content-Security-Policy: default-src 'self' https: wss:;
Content-Type: application/json
Date: Wed, 22 Sep 2021 08:23:48 GMT
Server: nginx/1.14.0 (Ubuntu)
Vary: X-Auth-Token
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-Subject-Token: a_super_long_token
X-XSS-Protection: 1; mode=block
x-openstack-request-id: req-af187d54-8ee6-4625-9675-4kahcjaja
````

To get the authentication token, the header we want is called `X-Subject-Token`. This token has a lifetime as defined in the `expires_at` attribute in the response and it will be used for performing requests to the Compute API.


## Testing the Compute API

Export the token and called it `OS_SUBJECT_TOKEN`

Fetch a list of instances:

```
http -v GET $OS_COMPUTE_ENDPOINT/v2/servers/detail X-Auth-Token:$OS_AUTH_TOKEN
```

Fetch a list of flavours:

```
http -v GET $OS_COMPUTE_ENDPOINT/v2/flavors/detail X-Auth-Token:$OS_AUTH_TOKEN
```


