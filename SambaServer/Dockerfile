# Dockerfile to start a samba server to serve host files. Note docker run *MUST* be run with -t and ports exposed.

# Example build
# docker build -t samba-server .

# Example debug run with an interactive terminal
# docker run --rm -it -v $HOME:/Share -p 137:137 -p 138:138 -p 139:139 -p 445:445 samba-server

# Example run to start the container / service as daemon
# docker run --name samba-server -t -d -v $HOME:/Share -p 137:137 -p 138:138 -p 139:139 -p 445:445 samba-server

FROM ubuntu

MAINTAINER srwareham

# Expose is mostly for documentation purposes, still need to bind each port to host (e.g., using docker run -p 137:137)
EXPOSE 137 138 139 445

# The username and password used to access samba shares.
# These are what you will want to enter in your passwords.xml on all clients that you would like to connect to this file server
# Note: for the time being, the username must be root. This is because the samba username must be an existing linux user
# The base image only has a root user, but the roadmap includes creating a user at container buildtime or at runtime --tbd.
ENV USERNAME=root
ENV PASSWORD=password

RUN apt-get update && apt-get install -yq samba

# Defines the samba share. Specifically, states that the samba serve expects to serve files mounted to /Share
# This is the directory which a host file should mount to (e.g., docker run -v HOST_DIRECTORY_WITH_MEDIA:/Share)
ADD smb.conf /etc/samba/

# Creates the user if necessary and sets its samba password.
# Note: additional user support is not yet implemented.
# At the time being, the only username that is supported is root so the user creation part will always gracefully fail. See above discussion.
RUN useradd -m $USERNAME || echo $PASSWORD | tee - | smbpasswd -a $USERNAME && smbd restart

# Start the samba application in foreground mode as required by docker.
# Note: for this to work, this image *MUST* be invoked with a pseudo tty  (e.g., docker run -t)
ENTRYPOINT ["smbd", "--foreground", "--log-stdout"]
