#!/usr/bin/env bash
# simplicity-sshwrap.sh

/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "/var/www/simplicity.io/.ssh/id_deploy" $1 $2