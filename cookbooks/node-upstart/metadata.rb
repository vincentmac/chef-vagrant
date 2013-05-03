name             'node-upstart'
maintainer       'Simplicity.io'
maintainer_email 'vincent@simplicity.io'
license          'All rights reserved'
description      'Installs/Configures node-upstart'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "nodejs"
depends "nginx"
# depends "application"