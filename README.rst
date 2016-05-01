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

Once inside the kodi-backend folder on your server, starting the service is as simple as:

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

To use your newly setup backend, each kodi client in your network simply needs two files added to its `userdata <http://kodi.wiki/view/Userdata>`_ folder: `advancedsettings.xml <http://kodi.wiki/view/Advancedsettings.xml>`_ and `passwords.xml <http://kodi.wiki/view/MySQL/Setting_up_Kodi>`_

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

(passwords.xml
^^^^^^^^^^^^^
Your passwords.xml will take the following form (with SERVER_IP_ADDRESS replaced with the local IP address of the server you are running Kodi Backend on and PATH_TO_MEDIA replaced with the path, on that server, that leads to your media files).

.. code-block:: xml

    <passwords>
        <path>
            <from pathversion="1">smb://SERVER_IP_ADDRESS/PATH_TO_MEDIA</from>
            <to pathversion="1">smb://root:password@SERVER_IP_ADDRESS/PATH_TO_MEDIA/</to>
        </path>
    </passwords>

Note: currently, Kodi Backend only supports the username "root" and is preconfigured with password "password" for hosting a samba file share--allowing the username to be flexible is on the road map for enhancements.


Using the Kodi GUI
##################

Instead of copying the passwords.xml file, it is additionally possible to manually add the samba share to your Kodi library. The steps to do so are as follows (from the home screen of the default Confluence skin):


1.) Navigate to Videos --> Files --> Add videos --> Browse --> Add network location

2.) Leave the Network Protocol as "Windows network (SMB) and enter the following

- Server name: SERVER_IP_ADDRESS
- Shared folder: media
- Username: root
- Password: password

3.) Press OK and then navigate to the directory you wish to add; press OK again and select your desired scraper (if any).
4.) A popup will appear asking you if you would like to update your library, click yes.



Features
--------

- Both bits and bytes are supported as file and speed units are supported (don't let your ISP pull the wool over your eyes there). Accordingly, Timeleft is case-sensitive in that it distinguishes between B and b (i.e., 1MB = 8 Mb; all other characters *should* be case independent).

- Speed units can take the format of B/s or Bps (e.g., both 1MBps and 1MB/s are accepted).

- Sizes prefixes ranging from bits all the way up to yottabytes (2\ :sup:`80` bytes) are currently supported.

- The output format only shows the largest unit necessary to display the time remaining (i.e., "0.0 minutes, 23.0 seconds" will never occur).











Alternatively, if you would like to install from source:

.. code-block:: bash

    $ pip install git+https://github.com/swareham/timeleft.git




Pip will automatically add the "timeleft" executable to your path and you will be ready to go!


Credits
-------

- Logic for powering Timeleft: Sean Wareham
- Template for pip / setuptools support: Kenneth Reitz and all of the developers of requests at https://github.com/kennethreitz/requests