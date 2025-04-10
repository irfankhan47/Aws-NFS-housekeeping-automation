# 📁 NFS Housekeeping Automation using AWS EC2
This project simulates a real-time DevOps scenario where old files are archived from a shared directory using a housekeeping script. The task mirrors a production environment where such scripts are offloaded to reduce CPU usage on critical servers.

🧠 Scenario OverviewIn production, a file transfer server was experiencing high CPU load due to a housekeeping script that moved files older than 1 year. To avoid this performance hit, the solution was to run the script from a different server via NFS (Network File System), which accesses the shared data without directly using the file server's resources.
In this project:
I created an NFS server and a client server using AWS EC2 instances.
Shared data is hosted on the NFS server.
The housekeeping script runs on the client server and moves old files to an archive directory.
The script is scheduled using cron to run every 5 minutes.

# 🛠️ Tools & Technologies
- AWS EC2 (Ubuntu 22.04)
- NFS (Network File System)
- Bash Shell Scripting
- Crontab for automation

📦 Folder Structureproject-root/
- ├── ftphousekeep.sh         # Housekeeping script
- ├── setup-cron.md           # Cron job config example
- └── README.md               # This file⚙️

Step-by-Step Setup
1. Launch Two EC2 Instances Ubuntu 22.04 EC2 instances:

- One as the nfs-server
- One as the client-server
- Use the same security group for both.

2. Update Security Group Inbound Rules
- Allow SSH: Port 22
- Allow NFS: Port 2049 (Custom TCP)

4. On nfs-server: Install and Configure NFSsudo apt update

- sudo apt install nfs-kernel-server -y
Create Shared Folderssudo
- mkdir -p /nfs/datacontrol
- sudo mkdir -p /nfs/archive
- sudo chmod -R 777 /nfsExport the Foldersecho "/nfs *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
- sudo exportfs -a
- sudo systemctl restart nfs-kernel-server4. On client-server: Install and Mount NFSsudo apt update
- sudo apt install nfs-common -y

# Create mount points
- sudo mkdir -p /mnt/datacontrol
- sudo mkdir -p /mnt/archive
# Mount shared directories
- sudo mount <NFS_SERVER_PRIVATE_IP>:/nfs/datacontrol /mnt/datacontrol
- sudo mount <NFS_SERVER_PRIVATE_IP>:/nfs/archive /mnt/archive✅ Use ifconfig or AWS console to get the private IP of nfs-server.

5. Create the Housekeeping Script on client-serversudo nano /usr/local/bin/ftphousekeep.shPaste this:
- #!/bin/bash
- find /mnt/datacontrol -type f -mmin +5 -exec mv {} /mnt/archive/ \;
- echo "$(date): Moved files older than 5 minutes to archive" >> /var/log/ftphousekeep.logThen:
- sudo chmod +x /usr/local/bin/ftphousekeep.sh6. Schedule Script with Cron (Every 5 Minutes)crontab -eAdd this line:
- */5 * * * * /usr/local/bin/ftphousekeep.sh✅ This runs the script every 5 minutes automatically.

7. Test the SetupCreate a file for testing:
- touch /mnt/datacontrol/testfile.txt
- touch -d "10 minutes ago" /mnt/datacontrol/testfile.txt
Wait 5–6 minutes,
then check:
- ls /mnt/datacontrol         # Should not contain testfile.txt
- ls /mnt/archive             # Should now contain testfile.txt
View log:
- tail -n 1 /var/log/ftphousekeep.log

✅ Shows the latest log entry.
✅ OutcomeThis simulation demonstrates how to offload system-intensive housekeeping from critical servers by using shared storage and remote automation — just like in production environments.
👤 AuthorIrfan KhanDevOps & Cloud Engineer (Trained Fresher)GitHub: @irfankhan47
