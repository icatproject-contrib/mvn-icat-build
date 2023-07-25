Build environment for ICAT components
=====================================

This repository provides an environment to build `ICAT`_ components
locally.  It consists of two Docker containers:

+ one container provides a database backend running MariaDB,

+ one container running a Payara application server to deploy ICAT
  components and to run a Maven build environment interactively.

ICAT components may depend on each other, you may need to have some
components deployed in the Payara server in order to build and test
other components.  For instance, `ids.server`_ depends on
`icat.server`_, you need to have icat.server deployed in order to run
the integration tests for ids.server.  icat.server in turn depends on
some authentication plugins and on `icat.lucene`_.

This build environment provides working directories for most ICAT
components that are preconfigured and ready to be deployed in the
Payara server.  The configuration for these components is maintained
in a separate Git repository `icat-config`_.  The provided Makefile
cares to check this repository out and to download the corresponding
release distributions.

Quickstart
~~~~~~~~~~

Prerequisite: you need to have Docker and docker-compose installed and
the Docker daemon running.  You need to have ``sudo`` permission to
run docker commands.

1. Clone the Git repository and change to the working directory::

     $ git clone git@github.com:icatproject-contrib/mvn-icat-build.git
     $ cd mvn-icat-build

2. Run::

     $ make install

   This will clone the (appropriate branch of the) icat-config
   repository into ``build/apps`` and download the corresponding
   release distributions of ICAT components.  Furthermore, it creates
   an empty directory ``build/src``, needed below.

3. Run::

     $ make build

   to download Docker images and build them locally.

4. Run::

     $ make up

   to launch the MariaDB and the Payara container.

5. Check out the sources of the ICAT component you want to work on
   into ``build/src``.  If, for instance, you want to build
   icat.server at version 5.0.1, you may run::

     $ pushd build/src
     $ git clone git@github.com:icatproject/icat.server.git
     $ cd icat.server
     $ git checkout v5.0.1
     $ popd

6. Run::

     $ make run

   to start an interactive shell inside the Payara container.

7. Deploy ICAT components that you need to have running in the Payara
   container as a prerequisite of the build.  If, for instance, you
   want to build icat.server at version 5.0.1, you may run::

     $ (cd apps/authn.simple && ./setup install)
     $ (cd apps/authn.db && ./setup install)
     $ (cd apps/icat.lucene && ./setup install)

   Note that you don't need to configure these components to the build
   environment, as the appropriate configuration files are already
   present, thanks to using the icat-config repository.

8. If your build needs a certain set of standard test username and
   password combinations to be setup in the authn.db authenticator,
   you may create them using::

     $ add-test-accounts.sh
   
9. Run the Maven build::

     $ cd src/icat.server
     $ mvn install

   Note that there are still plenty of things that may go wrong here,
   depending on the sources you are trying to build.  For instance,
   you may need to tweak the configuration files provided by test
   suite of the ICAT component you are trying to build (have a look
   into ``src/test/install`` in the working directory of the sources)
   or need to create some directories that the test suite assumes to
   be present.  This is out of the control of this build environment
   and goes beyond this Quickstart guide.

Java and Payara version
~~~~~~~~~~~~~~~~~~~~~~~

This build environment provides Java 8 and Payara 4.1.  Admittedly,
this is rather old.  But some ICAT components still need Java 8 to
build.


Copyright and License
~~~~~~~~~~~~~~~~~~~~~

Copyright 2023 the ICAT project

Licensed under the `Apache License`_, Version 2.0 (the "License"); you
may not use this file except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.  See the License for the specific language governing
permissions and limitations under the License.


.. _ICAT: https://icatproject.org/
.. _ids.server: https://github.com/icatproject/ids.server
.. _icat.server: https://github.com/icatproject/icat.server
.. _icat.lucene: https://github.com/icatproject/icat.lucene
.. _icat-config: https://github.com/icatproject-contrib/icat-config
.. _Apache License: https://www.apache.org/licenses/LICENSE-2.0
