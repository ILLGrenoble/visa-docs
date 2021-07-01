(image_creation)=
# Image creation

> **_NOTE_** This documentation is work in progress

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

> An example project is being developed and will be integrated soon

Details are given here on how to build the example image

### Installation

#### Dependencies for building the images:

On Ubuntu 18.04:
```
sudo apt install qemu qemu-kvm libvirt-bin bridge-utils virt-manager git-lfs python3-venv python3-pip
```

On Debian 10:
```
sudo apt install qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager git-lfs python3-venv python3-pip
```

Add your user to the following groups:

```
usermod -a -G libvirt $(whoami)
usermod -a -G kvm $(whoami)
```

**After setting these user groups the machine must be rebooted**

Install OpenStack client

```
sudo pip3 install python-openstackclient
```

and then add connection environment variables to $HOME/.profile:

```
export OS_PROJECT_DOMAIN_NAME=default
export OS_USERNAME={OPENSTACK_USERNAME}
export OS_PASSWORD={OPENSTACK_PASSWORD}
export OS_TENANT_NAME="VISA Development"
export OS_AUTH_URL=https://{your.osserver.host}:5000/v3
export OS_USER_DOMAIN_NAME=default
export OS_REGION_NAME="RegionOne"
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3
```

#### Virtual environment

Create a virtual environment (inside the cloned folder):

```
python3 -m venv .venv 
```

Activate the virtual environment

```
source .venv/bin/activate
```

Install packer:

```
sudo wget -O packer.zip https://releases.hashicorp.com/packer/1.6.5/packer_1.6.4_linux_amd64.zip 
sudo mv packer /usr/local/bin/packer
```

Install packme: 

```bash
pip3 install packme
```

### Building the images

> If there are environment variables that need to be declared, then packme will tell you what to define before it can continue with the build.

The following environment variables need to be set
- user_password: The password of the user in the VM to be generated
- root_password: The password of the root user in the generated VM
- headless: true/false depending on whether the UI is required during the build process (helps with debugging)


```bash
packme --templates-base-dir templates --debug -l --input config.yml -c -r 
```

The built images are stored in `templates/{template-name}/builds`

If you want the build to be headless (no gui) then set the environment variable `headless=true`.

### Converting from qcow to raw

There is a script inside `bin` called `convert-to-raw`. This script will take a `template` as an argument. It will convert that templates qemu image into a raw image.

Example: 

```bash
cd templates/visa-example-image/builds
qemu-img convert -f qcow2 -O raw visa-example-image-qemu visa-example-image.img
```

### Upload an image to openstack

Using the openstack CLI we can upload an image to openstack.

Example openstack script for setting up the environment:

> More information can be found on the [OpenStack documentation](https://docs.openstack.org/mitaka/install-guide-obs/keystone-openrc.html).

```bash
export OS_USERNAME={your-os-admin}
export OS_PROJECT_DOMAIN_NAME=default

echo "Please enter your OpenStack Password for project $OS_PROJECT_NAME as user $OS_USERNAME: "
read -sr OS_PASSWORD_INPUT

export OS_PASSWORD=$OS_PASSWORD_INPUT
export OS_PROJECT_NAME="VISA Development"
export OS_AUTH_URL=http://{your.osserver.host}:5000/v3
export OS_USER_DOMAIN_NAME=default
export OS_REGION_NAME="RegionOne"
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3
```
Source the above script before executing the command below to upload to openstack

Upload to openstack: 

This example will upload the image to the `VISA Development` project. If the `project` argument is ommitted then it will use the default value that is defined in your openrc file. It specified a disk size of 40GB using the raw image format.

```bash
openstack image create visa-apps-{version) \
--public --project "VISA Development" --min-disk 40 --disk-format raw \
--file templates/visa-example-image/builds/visa-example-image-raw
```


