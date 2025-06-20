Log Analyzer & Archiver with ELK Stack
🚀 Overview
This project implements a complete, end-to-end centralized logging and archiving solution using the ELK Stack (Elasticsearch, Logstash, Kibana) deployed via Docker. It's designed to collect system logs in real-time, provide a web interface for searching and visualizing the data, and automatically archive old logs to save disk space.

This system is a foundational project for anyone in DevOps, SRE, or backend development, demonstrating a practical approach to log management.

✨ Features
Centralized Logging: Collects logs from specified files into one central location.

Real-Time Processing: Logs are shipped, processed, and indexed in near real-time.

Powerful Search: Utilizes Elasticsearch for fast, full-text search capabilities.

Data Visualization: Uses Kibana to create dashboards and visualize log data with charts and graphs.

Automated Archiving: A daily cron job automatically backs up and compresses old log indices.

Automated Cleanup: Old indices are automatically deleted from the live database after a successful backup to manage disk space.

Containerized Deployment: The entire ELK stack runs in isolated containers using Docker Compose for easy setup and management.

🛠️ Tech Stack
Orchestration: Docker & Docker Compose

Log Storage & Search: Elasticsearch

Log Processing & Routing: Logstash

Visualization & Dashboarding: Kibana

Log Shipper/Agent: Filebeat

Automation: Bash Scripting & Cron

Backup Tool: elasticdump

🏗️ Project Architecture
The data flows through the system in a simple, linear pipeline:

Filebeat: Runs on the host machine, actively watches the target log file (/var/log/syslog), and sends any new lines to Logstash.

Logstash: Receives the raw log data from Filebeat, processes it, and forwards it to Elasticsearch. It also creates a new, date-stamped index for each day's logs.

Elasticsearch: Receives the structured data from Logstash, indexes it, and stores it, making it instantly searchable.

Kibana: Connects to Elasticsearch, allowing users to search, explore, and create visualizations and dashboards from the indexed data via a web UI.

Cron Job & Archiver Script: An external script runs on a daily schedule to back up old indices from Elasticsearch and then delete them.

[ Log File ] -> [ Filebeat ] -> [ Logstash ] -> [ Elasticsearch ] <-> [ Kibana ]
      ^                                                                   |
      |                                                                   |
      +----------------------- [ Archiver Script (cron) ] ---------------+

⚙️ Setup and Installation
Prerequisites
A Linux-based system (tested on Ubuntu)

Docker and Docker Compose installed.

Git installed.

Node.js and npm (for elasticdump).

1. Clone the Repository
git clone [https://github.com/YourUsername/log-analyzer-project.git](https://github.com/YourUsername/log-analyzer-project.git)
cd log-analyzer-project

2. Launch the ELK Stack
Start the entire ELK stack in the background. Docker will download the required images, which may take a few minutes.

docker-compose up -d

Verify all containers are running with docker ps. You should see elasticsearch, logstash, and kibana with a status of Up.

3. Configure and Run Filebeat
This project requires Filebeat to be installed on the host machine to ship logs to the Docker stack.

Install Filebeat on your host system (sudo apt-get install filebeat).

Copy the example configuration to the correct location:

sudo cp filebeat.yml.example /etc/filebeat/filebeat.yml

Enable and start the Filebeat service:

sudo systemctl enable filebeat
sudo systemctl start filebeat

Check its status with sudo systemctl status filebeat.

4. Set Up the Archiver
Install the elasticdump utility globally:

sudo npm install -g elasticdump

Open the archiver.sh script and ensure the ARCHIVE_DIR path is correct for your system.

Schedule the daily cron job by editing your crontab:

crontab -e

Add the following line to the file, making sure to use the absolute path to the script.

# Run the archiver every day at 3:00 AM
0 3 * * * /path/to/your/project/archiver.sh >> /path/to/your/archives/archiver_cron.log 2>&1

📊 Usage
Access Kibana: Open your web browser and navigate to http://localhost:5601.

Create a Data View:

Go to Stack Management > Kibana > Data Views.

Click Create data view.

Use filebeat-* as the name and index pattern.

Select @timestamp as the timestamp field.

Save the data view.

Explore Logs:

Navigate to the Discover tab from the main menu.

You can now search and filter through your logs in real-time.

