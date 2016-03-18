# ml-docker
Simple Dockerfile based scripts to build docker images for running or developing with MarkLogic

Required: a MarkLogic RPM which you can obtain from www.marklogic.com
Optional: a Java JDK, preferably Oracle JDK  1.860 or newer.
Both must exist in the root director.

Optional: two scripts exists to 'pull' these files during the build.  They are meant to be augmented and
are only called if apprprate rpms are not found.
The getjava.sh script will pull a java 1.8_60 JDK from oracle.
The getml.sh script will simply remind you to obtain a MarkLogic rpm

Usage:

 ./build.sh  [mlbuild|oscore|mlrun]  tag
 
 This builds one of 3 varients
 
 * mlbuild - A full featured build environment including the MarkLogic pyton Management tools
 * oscore  - a base fedora21 image that can be used to build up the other images in layers
 * mlrun - a minimal runtime image bawed on oscore + marklogic.rpm
 * 
 
