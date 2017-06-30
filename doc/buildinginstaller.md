Building installer {#buildinginstaller}
===============
[TOC]

# CI builds # {#ci-build}

Our GitLab CI is set up to generate Milo Code DB
[online documentation](https://qtdocs.milosolutions.com/milo-code-db/main/) and 
the installers for Windows and Linux automatically for each new commit.

You can see the available installers [here](https://seafile.milosolutions.com/#group/4/lib/abc2c8d4-7551-49f6-9f67-6d4e271c0cd1).

# Creating an installer manually # {#manually-build}

This repository can easily be compiled into an installer using:

  ~~~
  ./scripts/build_unix.sh $(which doxygen) <QtIfwInstallationDir>/bin/binarycreator
  ~~~

or (on Windows)

  ~~~
  scripts\build_windows.bat "C:\Program Files\doxygen\bin\doxygen.exe" <QtIfwInstallationDir>\bin\binarycreator.exe
  ~~~

QtIFW is included in standard Qt installers from Qt Project (qt.io/downloads). Alternatively, you can compile QtIFW from source - but that is not necessary and will take you much more time.

Doxygen: on Windows, download and install the installer from http://www.stack.nl/~dimitri/doxygen/download.html
On Linux, doxygen is usually available from your package manager, so do something like

~~~
sudo apt install doxygen
~~~

Deploy script is also available (Linux) - it will build the project and upload the installer to Seafile, all in one go. Very convenient and recommended. 

In the future, there is a plan to fully migrate to GitLabCI, making installer builds completely automatic. It is not possible in current version of GitLab.
