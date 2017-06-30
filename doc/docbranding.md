Documentation branding {#docbranding}
===

Milo Code DB uses custom branding for doxygen documentation. It is recommended
to use it in your projects, too. This guide will help you get started.

1. Add the following lines to your . **gitignore**:
~~~
doc/html/
~~~
2. Copy Milo branding files for doxygen into **doc/branding**
~~~
milo-doxygen.css
milo-doxy-footer.html
milo-doxygen.scss
milo-doxy-header.html
milo.js
~~~
3. Put any images you have into **doc/img** folder.
4. Update your doxygen config. Add these lines:
~~~
HTML_OUTPUT = html/
HTML_FILE_EXTENSION = .html
HTML_HEADER = doc/branding/milo-doxy-header.html
HTML_FOOTER = doc/branding/milo-doxy-footer.html
HTML_EXTRA_STYLESHEET= doc/branding/milo-doxygen.css
HTML_EXTRA_FILES = doc/branding/milo.js
IMAGE_PATH = doc/img/
~~~

**Newprojecttemplate module already contains all these elements, so if you copy
it, or use Milo Code DB installer, then you don't need to do anything to set up
doc branding.**
