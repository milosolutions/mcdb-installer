# Intro 

Milo Code Database is the place where we keep all useful pieces of code: snippets, working modules, templates. The repository is organised into a Qt Installer Framework project. MCDB is a great way to skip all the mundane and boring code
you have to write for each new project - here you get all the initial project code prepared and ready for further development.

If you need some mobule for an existing project, see \ref subprojects. That page also contains links to online documentation.

If you are creating a new project, you are encouraged to check our MCDB installers. See the following section for more details.

# Documentation branding 

Information how to apply Milo branding to doxygen docs is available in \ref docbranding.

# Prebuilt installers 

You can find prebuilt installers of Milo Code Database on our [Seafile](https://seafile.milosolutions.com/#group/4/lib/abc2c8d4-7551-49f6-9f67-6d4e271c0cd1). You need to be logged in to see the contents.

The installer is the quickest way to create a new project: will all necessary boilerplate code in place. The .pro file, doxygen, logger, build helpers, CI scripts, config classes... everything you choose to install (the process is customizable) will be extracted to a single place - all that is left for you is to
open it up in Qt Creator and start coding the interesting bits!

# Requirements for new modules 

Each separate piece of technology we share should be kept in a separate git repository, and imported to DB using git submodule add. Milo Code Database is only acting as a "home" to them all. 

All code has to be properly licensed, documented, contain readme and doxygen docs. A global doxygen file is planned, too (to create common documentation for all subprojects).

More information about adding new modules is available in \ref repositoryguide

# License

This project is licensed under the MIT License - see the LICENSE-MiloCodeDB.txt file for details

# Further reading

Checkout instructions are contained in \ref repositoryguide This document also contains
hints on how to efficiently (and correctly) use this meta-repository and all
submodules.

Subproject documentation is listed in \ref subprojects

Instructions for building MCDB installer are listed in \ref buildinginstaller
