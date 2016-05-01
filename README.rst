Kodi Backend
============

Kodi Backend is an easy-to-set-up backend for serving a Kodi library (msql) and its media files (samba). Kodi Backend is designed to work as a centralized server to support Kodi clients (using the client-server model found in Plex).

With Kodi Backend, you can have one always-on server which keeps a centralized kodi library and serves all of your media for simplified streaming. Kodi Backend uses Docker containers to provide a portable, easy-to-set-up solution.

Dependencies
------------

- Docker: `installation instructions <https://docs.docker.com/engine/installation/>`_
- Docker Compose (requires Python, is optional if you already know what you are doing): :code:`pip  install docker-compose`


Installation
------------

To install Kodi Backend, simply:

.. code-block:: bash

    $ git clone https://github.com/srwareham/kodi-backend.git
    $ cd kodi-backend; docker-compose build

Usage
-----


Starting the Backend
####################

Once inside the kodi-backend source code folder on your server, starting the service is as simple as:

.. code-block:: bash

     $ docker-compose up -d
     Creating network "kodibackend_default" with the default driver
     Creating kodibackend_samba-server_1
     Creating kodibackend_kodi-mysql-server_1

After running the above, Kodi Backend will be running with the following host ports open:

- Samba File Sharing: 137, 138, 139, 445
- MySQL Database: 3306

Client Connection to the Backend
################################

To use your newly setup backend, each kodi client in your network needs one file added to its `userdata <http://kodi.wiki/view/Userdata>`_ folder: `advancedsettings.xml <http://kodi.wiki/view/Advancedsettings.xml>`_

advancedsettings.xml
^^^^^^^^^^^^^^^^^^^^
Your advancedsettings.xml will take the following form (with SERVER_IP_ADDRESS replaced with the local IP address of the server you are running Kodi Backend on)

.. code-block:: xml

    <advancedsettings>
        <videodatabase>
          <type>mysql</type>
          <host>SERVER_IP_ADDRESS</host>
          <name>kodi_video</name>
          <user>kodi</user>
          <pass>kodi</pass>
        </videodatabase>
        <musicdatabase>
          <type>mysql</type>
          <host>SERVER_IP_ADDRESS</host>
          <name>kodi_music</name>
          <user>kodi</user>
          <pass>kodi</pass>
        </musicdatabase>
      <videolibrary>
        <importwatchedstate>true</importwatchedstate>
        <importresumepoint>true</importresumepoint>
      </videolibrary>
    </advancedsettings>



Adding Media Sources Using the Kodi GUI
#######################################

If this is the first kodi client you are setting up, you will need to manually configure your Kodi client to connect to the samba share (the library database syncing has already been taken care of by advancedsettings.xml). The steps to do so are as follows (from the home screen of the default Confluence skin):


1. Navigate to Videos --> Files --> Add videos --> Browse --> Add network location
2. Leave the Network Protocol as "Windows network (SMB) and enter the following

 - Server name: SERVER_IP_ADDRESS
 - Shared folder: media
 - Username: root
 - Password: password

3. Press OK and then navigate to the directory you wish to add; press OK again and select your desired scraper (if any).
4. A popup will appear asking you if you would like to update your library, click yes.
5. Repeat steps 1-4 for each video folder you would like added to your library; follow a parallel logic for adding any audio folders.
6. That's it! You're done!

Note:

- Currently, Kodi Backend only supports the username "root" and is preconfigured with password "password" for hosting a samba file share--allowing the username to be flexible is on the road map for enhancements.
- If you are feeling adventurous, it *should* be possible to automate the provisioning process for each Kodi client by copying 3 properly-formatted files into your userdata folder: advancedsettings.xml, passwords.xml, sources.xml.

Features
--------

- Quickly and portably set up a centralized server that can host a file server and a mysql server for hosting media files and libraries for any number of Kodi clients

- Easily backup the mysql database which holds your Kodi library.

 - :code:`docker run --rm -it -v kodibackend_kodi-mysql-data:/var/lib/msql -v $(pwd):/backup ubuntu bash -c "tar czvf /backup/msql.tar.gz /var/lib/msql && chown $(id -u):$(id -g)` will create a tar.gz file backing up all of your library metadata

- Portability: If you want to setup a new server, you simply need to take a backup of your old database, install docker and Kodi Backend on your new server, and copy the contents of your backup to your new server.


Road Map
--------

1. Allow usernames and passwords to be Kodi-Backend-wide configurable in centralized location
2. Add instructions for loading a mysql database backup
3. Add add helper scripts to create the necessary userdata configuration files in the hopes of needing zero gui configurations
4. (?) Link in a headless Kodi container used to automatically update the library
5. Bifurcate documentation between initial setup and subsequent device additions


Credits
-------

- Logic for powering Kodi Backend: Sean Wareham
- Odds and ends needed to dockerize everything: `<stackoverflow.com>`_