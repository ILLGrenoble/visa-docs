(image_visa_pam)=
# VISA PAM

VISA PAM (Pluggable Authentication Module) was developed to allow a user to automatically connect to a Remote Desktop in VISA without having to authenticate every time. The user is already authenticated within the VISA platform (using OpenID Connect) and as such, for security purposes, it is unneccessary for them to re-authenticate every time they wish to access a VISA resource.

The source code and documentation can be found in the [visa-pam GitHub repository](https://github.com/ILLGrenoble/visa-pam).

## Description

VISA PAM authenticates a user connecting to an instance through VISA by [verifying an RSA signed token](https://medium.com/@bn121rajesh/rsa-sign-and-verify-using-openssl-behind-the-scene-bf3cac0aade2) generated uniquely for each connection. 

The token is generated by VISA when the user requests access to the remote desktop of the instance. Rather than the password of the user being sent to the XRDP connection, VISA sends a token containing a digital signature generated using a private SSL key. The VISA PAM module intercepts the authentication request and validates the signature of the token using the public SSL key that has been installed on the instance. If both the signature and token payload are valid then the user is connected.

### Use case

It is assumed that the user is known to the system and has already been authenticated by VISA using OpenID Connect. We wish to facilitate the access to the instances (namely remote desktop) and avoid having the user log in separately every time they wish to connect.

VISA PAM allows us to authenticate user access to the instances automatically and securely.

## Token creation and signing

The token generated by VISA contains a payload and the base64 encoded RSA signature of the hash of the payload. The token is simple text containing the payload and signature separated by a semi-colon.

The payload contains the username of the user wishing to connect to the VISA instance and the unix epoch time (in seconds) at which the connection was made (separated by a comma).

For example, the token will look something like:

```
joebloggs,1565099241;AgEtY6SJwXpgw8wE7AlByXnsROw0u7b8ozpV44w98Q4C4WLy+RDYsGicrHGC3v6Mdrm4atlY4T/7TG7bcp0SXw==
```

This token is sent as the password of the user (*joebloggs* in this example) when connecting to the remote desktop of the instance.

The code that generates the signature is part of the [VISA API Server and Remote Desktop](https://github.com/ILLGrenoble/visa-api-server) project. 

You can find the code that generates the signature [here](https://github.com/ILLGrenoble/visa-api-server/blob/main/visa-remote-desktop/src/main/java/eu/ill/visa/vdi/services/SignatureService.java).

## Token validation

VISA PAM intercepts an authentication request and will decode the password (containing the token) to obtain the payload and signature. From the public key (stored as a file on the instance) the signature is decrypted to obtain the hash of the payload. 

The OpenSSL library then generates a hash for the token payload and compares this to the signed hash.

If both hashes are identical VISA PAM accepts that the payload has been digitally signed by VISA.

Having verified the signature, the token payload is validated: 

- it compares the username in the payload to that of the username used for log-in
- it ensures that the token has not expired by using the timestamp included in the payload (the expiration time is configurable)

If both of these are valid then the user is successfully authenticated.

## Installation

The following instructions have been tested and validated to work on an Ubuntu (18.04+) distribution.

### Package dependencies

```
apt install libpam-dev libcurl4-gnutls-dev libssl-dev check build-essential
```

### Generating keys

```
openssl genrsa -out private.pem 512    
openssl rsa -in private.pem -pubout -out public.pem
```

Both private an public signature keys need to be accessible and [configured in the VISA API Server](deployment_environment_variables_vdi).

> NOTE Currently the public key has to be included in the [virtual machine image creation](image_creation). It is planned that he public key will integrated into an instance using [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html) data and stored as a file using the [patch process](image_visa_patch).

### Make

```
cmake .
make
make install
```

The built module is found in the `/lib/x86_64-linux-gnu/security/` folder.

### Time synchronisation

Please make sure the time is sychronised for both the server (signature generation) and clients (signature validation) to ensure you do not run into any issues validating the signature.

### Configuration and installation of the module

The configuration for the VISA PAM module requires two parameters: 

 - the path to the public key that will be used to verify the signature
 - the number of seconds the signature is valid until

For example:

```
auth    [success=2 default=ignore]      pam_visa.so /etc/visa/public.pem 60
```

At the ILL, we only apply the *visa_pam* module to xrdp-sesman ([XRDP session manager](https://linux.die.net/man/8/xrdp-sesman)) for XRDP remote desktop sessions.

Here is an example of the `/etc/pam.d/xrdp-sesman` configuration example that we use to get you started:

```
root@visa-instance-5829:/etc/visa# cat /etc/pam.d/xrdp-sesman 
# here are the per-package modules (the "Primary" block)
auth    [success=2 default=ignore]      pam_visa.so /etc/visa/public.pem 60
# here's the fallback if no module succeeds
auth    requisite            pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
auth    required            pam_permit.so
# and here are more per-package modules (the "Additional" block)
auth    optional            pam_cap.so
##%PAM-1.0

session       required   pam_env.so readenv=1 envfile=/etc/environment
session       required   pam_env.so readenv=1 envfile=/etc/default/locale

@include common-account
@include common-session
@include common-password
```
