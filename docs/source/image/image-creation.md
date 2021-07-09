(image_creation)=
# Image creation

The automated build of the virtual machine image at the ILL is done principally using [Packer](https://www.packer.io/). This is a very useful tool to script the creation of a virtual machine image which can be done for multiple platforms and formats (including QEMU, docker, OpenStack, VirtualBox, etc).

The process is simple to integrate into a *CI/CD* system and automatically upload images to OpenStack using the [OpenStack CLI](https://docs.openstack.org/newton/user-guide/common/cli-install-openstack-command-line-clients.html).

We use a pre-processing library called [packme](https://pypi.org/project/packme/) to generate the *json* manifest files used by Packer from simplified *yaml*. This also alows us to more easily build images from inherited components.

## Image requirements

Below we describe the creation of an example image. Image content and creation is the responsibility of each site and as such anything can be included in the image.

However to enable Remote Desktops and JuptyerLab within VISA there are certain requirements:

- [Guacamole Server](https://github.com/apache/guacamole-server) has to be installed in the image
 
- [JupyterLab](https://jupyterlab.readthedocs.io/en/stable/getting_started/installation.html) has be be installed and configured.

### Guacamole Server

To install Guacamole Server, the following script can be used during the image creation process:

```bash

# Put this into separate file
cd /tmp 

wget https://github.com/apache/guacamole-server/archive/1.2.0.tar.gz

tar -xvvf 1.2.0.tar.gz

cd guacamole-server-1.2.0/

autoreconf -fi

./configure --with-init-dir=/etc/init.d --with-rdp

make

make install

ldconfig

systemctl enable guacd
```

This is included as part of the example project desribed below.

### JupyterLab

There are different ways of installing JupyterLab in the image (conda, python virtual environment, docker, ...). 

The example project below, based on the ILL's integration of JupyterLab uses a python virtual environment. Details of how this is done is described [here](image_jupyter).

## Example image

An example project on building an image using packer templates is [available on GitHub](https://github.com/ILLGrenoble/visa-image-template-example).

This project has been provided to give an example of how to build and image and integrate it into VISA with OpenStack and can be extended to provide a production image.

### Features

The virtual machine image created by these templates is a very simple data analysis machine used for demonstration purposes. The main features  demonstrated are as follows:

- Guacamole/XRDP installation
- Automatic connection to remote desktops (XRDP) using the VISA PAM module
- Custom application installation
- JupyterLab integration using conda environments
- Custom background and welcom message
- Power management modifications

For a production environment you will probably need to look at
- Integration to LDAP or other authentication systems
- Access to network home directories
- Access to scientific data
- Adding more data analysis applications 
- Configuration of NTP servers

### Installation

#### Dependencies for building the images:

On Ubuntu 18.04:
```
sudo apt install qemu qemu-kvm libvirt-bin bridge-utils virt-manager python3-venv python3-pip
```

On Debian 10:
```
sudo apt install qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager python3-venv python3-pip
```

Add your user to the following groups:

```
sudo usermod -a -G libvirt $(whoami)
sudo usermod -a -G kvm $(whoami)
```

**After setting these user groups the machine must be rebooted**

### Building the images

A script to build the image can be found at `build-image.sh` that uses the [packme](https://pypi.org/project/packme/) to build the packer configuration files. 

The script requires some parameters to be set to build the image for your system:

```
build-image.sh [options]

Options and equivalent environment variables:
  -pp or --pam-public <path>            VISA_PAM_PUBLIC_KEY      set the PAM module public key location
  -rp or --root-password <password>     VISA_ROOT_PASSWORD       set the root password for the VM
  -hp or --http-proxy <URL>             VISA_HTTP_PROXY          set the HTTP proxy URL
  -np or --no-proxy <no proxy hosts>    VISA_NO_PROXY_HOSTS      set the HTTP no proxy hosts
  -nh or --not-headless                                          set build process not to be headless (for debugging)
```

You must specify a path to the VISA PAM public key and a root password. The proxy settings are optional.

Run the script to build the image, eg:

```bash
./build-image.sh -pp {/root/to/visa/public/key} -rp {root_password}
```

The built images are stored in `templates/{template-name}/builds`

#### Headless mode

When running in *headless* mode you will not see the system installation process happening within the VM. You can however still connect to the VM during the installation to see what is happening using VNC. Looking at the log messages you will see something like :

```
    qemu: The VM will be run headless, without a GUI. If you want to
    qemu: view the screen of the VM, connect via VNC without a password to
    qemu: vnc://127.0.0.1:5991
```

Using a VNC client you can connect to this address and examine a running installation.

#### System requirements

To build this example image, the process requires 4GB of memory and 1 CPU.

For production images you may find that you require more memory and CPUS. We would typically recomment 8GB and at least 2 CPUs.

The process also requires a lot of writing to the hard disk. To improve the build time we would recommend using an SSD.

### Upload an image to openstack

Using the openstack cli we can upload an image to openstack. 

#### Install OpenStack client

```
pip3 install python-openstackclient
```

> More information can be found here: https://docs.openstack.org/mitaka/install-guide-obs/keystone-openrc.html

A number of environment variables need to be set first:

```bash
export OS_PROJECT_DOMAIN_NAME=default
export OS_USERNAME={OPENSTACK_USERNAME}
export OS_PASSWORD={OPENSTACK_PASSWORD}
export OS_TENANT_NAME={OPENSTACK_PROJECT}
export OS_AUTH_URL=https://{the.os.cloud.host}:5000/v3
export OS_USER_DOMAIN_NAME=default
export OS_REGION_NAME="RegionOne"
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3
```

#### Upload to openstack: 

This example will upload the image to the `VISA Production` project. If the `project` argument is ommitted then it will use the default value that is defined in your openrc file. 

```bash
openstack image create visa-example --public --min-disk 10 --disk-format qcow2 --file visa-apps-qemu.iso
```

### VISA Integration

The authentication is done automatically using the [VISA PAM module](https://github.com/ILLGrenoble/visa-pam), however the user (owner of the instance) needs to be added in the VM when it starts up. This can be done using *cloud-init*.

Add this script to the boot command part of the Image in the [VISA Admin UI](https://visa.readthedocs.io/en/latest/admin/admin-images.html):

```bash
#!/bin/bash

# Get the owner login from cloud-init
owner=$(cloud-init query ds.meta_data.meta.owner)

# Create the user with a random password
useradd -m -U -p $(date +%s | sha256sum | base64 | head -c 32) -s /bin/bash ${owner}
```

This creates a user with the same username as the owner, and creates a random password (the password isn't needed since VISA PAM is used).



