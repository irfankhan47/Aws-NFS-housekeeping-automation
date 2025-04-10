#!/bin/bash

# Move files older than 5 minutes
find /mnt/datacontrol -type f -mmin +5 -exec mv {} /mnt/archive/ \;

# Log the operation
echo "$(date): Moved files older than 5 minutes to archive" >> /var/log/ftphousekeep.log
