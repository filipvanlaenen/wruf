INSTALLATION INSTRUCTIONS

Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

These are the installation instructions for WRUF.

1. INSTALLATION

1.1 UBUNTU

* Install Ruby.
* Unpack the bundle file, e.g. using the following command:
	tar -xzf wruf-<version-number>.tar.gz
* Navigate into the root directory of the unpacked bundle, e.g. using the following command:
	cd wruf-<version-number>
* Install the package by running the install.sh script with root privileges, e.g. by doing:
	sudo ./install.sh
  Notice that it will try to install the gem log4r if it isn't installed yet.
	
2. CONFIGURATION

* Try to run WRUF using the following command:
	wruf start