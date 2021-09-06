(image_visa_patch)=
# VISA Patch System

> **_NOTE_** This documentation is work in progress

## Description

The VISA Patch System was put into place to allow us to apply new patches to VISA instance after a simple reboot and to address the need of urgent and frequent corrections during a reactor cycle, without having to fully re-build an image every time.

As part of the [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html) package, when the instances are created, VISA uses a mechanism called [User-Data](https://cloudinit.readthedocs.io/en/latest/topics/format.html#user-data-script) which allows us to execute a script on first boot. This script is associated with a VISA Image and is configured in the *boot command* of the [Images admin interface](admin_image_management).

This script downloads an up-to-date script (or scripts) that should be executed when the instance starts, before a user has connected to it.

On instance creation, VISA also pushes the instance owner name (otherwise unknown at boot) into cloud-init metadata, stored in `/run/cloud-init/instance-data.json` on the instance.

This allows us, for example, to create a local home an environment for the user.

## Example project

> An example project is being developed and will be integrated soon
