# Software installation

> **_NOTE_** This documentation is work in progress

The section provides information on suggested practices of integrating software into the virtual machine image.

## Software versioning

> **To be analysed** 

One of the aspects of FAIR data is to be able to reproduce results. To be able to reproduce results we need to have identical environments which means potentially having the same version of sofware.

It is therefore important to know which version of software is available in a VISA instance and to be able to know which versions were used in previous instances.

## Network installation

It is often useful to remove data analysis software from the virtual machine image. This allows us to:

- Update the sofware without creating and deploying a new image. 

  Updates will be seen more quickly on active instances too.

- Delegate the responsiblity for the data analysis software to another group.

  The group responsible for the VISA deployment isn't necessarily the same as that offering user support for data analysis.

- Improve the size and speed of creation of an image

  By making the image lighter the creation is simpler and can be done more easily

### Integration of network software into the menu system

Describes how software on a network drive is integrated into the virtual machine menu