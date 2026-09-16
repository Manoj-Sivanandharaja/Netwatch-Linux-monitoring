# NetWatch - Linux System & Network Monitoring

NetWatch is a Linux-based system monitoring and network monitoring tool developed using Bash Shell Scripting and MySQL.

It collects system resource information, network connectivity details, and listening port information, then stores the monitoring results in a MySQL database for historical tracking.

---

## 🚀 Features

- CPU usage monitoring
- Memory usage monitoring
- Disk usage monitoring
- System hostname and user information
- System uptime monitoring
- Network interface detection
- IP address monitoring
- Default gateway detection
- Gateway connectivity checking
- Packet loss monitoring
- Network latency measurement
- Internet connectivity checking
- DNS resolution checking
- TCP listening port monitoring
- UDP listening port monitoring
- MySQL-based data storage
- Automated execution using Cron
- Modular Bash scripts
- Git/GitHub version control

---

## 🏗️ Architecture

```text
                    NETWATCH
                       │
                       ▼
              Master Controller
                netwatch.sh
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
       System        Network        Port
      Monitor        Monitor       Monitor
          │            │            │
          ▼            ▼            ▼
      CPU/RAM       IP/Gateway     TCP/UDP
       Disk         Latency         Ports
          │            │            │
          └────────────┼────────────┘
                       ▼
                    MySQL
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
    system_metrics network_metrics port_events

🛠️ Technologies Used

Technology	Purpose
Linux	Operating system and system-level monitoring
Bash	Automation and monitoring scripts
MySQL	Storing monitoring data
Cron	Scheduled monitoring
Git	Version control
GitHub	Source code management

📁 Project Structure

netwatch/
│
├── config/
│   ├── db.conf
│   └── db.conf.example
│
├── docs/
│
├── logs/
│   └── cron.log
│
├── reports/
│
├── screenshots/
│
├── scripts/
│   ├── system_monitor.sh
│   ├── network_monitor.sh
│   └── port_monitor.sh
│
├── sql/
│   └── schema.sql
│
├── netwatch.sh
├── README.md
└── .gitignore

⚙️ Monitoring Modules

1. System Monitoring

The system monitoring module collects:

Hostname
Current user
System uptime
CPU usage
Memory usage
Disk usage

The collected information is stored in the system_metrics MySQL table.

2. Network Monitoring

The network monitoring module checks:

Active network interface
IP address
Default gateway
Gateway reachability
Packet loss
Network latency
Internet connectivity
DNS resolution

The collected information is stored in the network_metrics MySQL table.

3. Port Monitoring

The port monitoring module detects listening:

TCP ports
UDP ports

The detected port information is stored in the port_events MySQL table.

Example ports detected during testing:

22
53
631
3306
5432
8080
33060

🗄️ Database Design

NetWatch uses MySQL to maintain historical monitoring records.

system_metrics

Stores system resource information.

id
cpu_usage
memory_usage
disk_usage
recorded_at
network_metrics

Stores network monitoring information.

id
interface_name
ip_address
latency_ms
recorded_at
port_events

Stores listening port information.

id
protocol
port
status
recorded_at

⏰ Cron Automation

NetWatch can be executed automatically using Linux Cron.

Example Cron configuration:

*/5 * * * * /home/manoj/netwatch/netwatch.sh >> /home/manoj/netwatch/logs/cron.log 2>&1

This executes the NetWatch monitoring system every 5 minutes and stores the output in:

logs/cron.log

▶️ Manual Execution

Navigate to the project directory:

cd ~/netwatch

Run the complete monitoring system:

./netwatch.sh

Individual monitoring modules can also be executed:

./scripts/system_monitor.sh
./scripts/network_monitor.sh
./scripts/port_monitor.sh
🔐 Configuration

Database configuration is maintained separately from the source code.

Example configuration:

DB_USER="netwatch"
DB_PASSWORD="YOUR_MYSQL_PASSWORD"
DB_NAME="netwatch"

The actual database configuration file should not be committed to GitHub.

It is excluded using .gitignore.

📊 Sample Monitoring Output

================================
       NETWATCH SYSTEM MONITOR
================================

Hostname       : Linux-System
User           : user
Uptime         : up 53 minutes

---------- MEMORY ----------
Memory Usage   : 44.08%

---------- DISK ----------
Disk Usage     : 20%

---------- CPU ----------
CPU Usage      : 2.66%

---------- DATABASE ----------
Database       : RECORD SAVED
Network Monitoring
================================
      NETWATCH NETWORK MONITOR
================================

Interface      : wlan0
IP Address     : 192.168.x.x/24
Gateway        : 192.168.x.x

---------- CONNECTIVITY ----------
Gateway        : REACHABLE
Packet Loss    : 0%
Latency        : 15 ms
Internet       : CONNECTED
DNS Resolution : WORKING

Database       : RECORD SAVED
Port Monitoring
================================
       NETWATCH PORT MONITOR
================================

------ LISTENING TCP PORTS ------

TCP Port       : 22
TCP Port       : 3306
TCP Port       : 8080

------ LISTENING UDP PORTS ------

No UDP listening ports found

Database       : PORT DATA SAVED

🧪 Testing

The project was tested by:

Executing each monitoring script individually.
Executing the complete NetWatch controller.
Verifying Cron execution.
Checking generated logs.
Verifying MySQL database records.
Confirming system metrics were stored.
Confirming network metrics were stored.
Confirming port monitoring records were stored.

Example database verification:

SELECT * FROM system_metrics;

SELECT * FROM network_metrics;

SELECT * FROM port_events;

📈 Database Verification

During testing, monitoring records were successfully stored in MySQL.

Example:

system_metrics  : monitoring records stored
network_metrics : monitoring records stored
port_events     : port monitoring records stored

🎯 Project Objectives

The main objectives of NetWatch are:

Automate Linux system monitoring.
Monitor network health.
Detect listening network ports.
Store monitoring information for historical analysis.
Reduce manual system administration tasks.
Demonstrate Linux administration and automation skills.

💡 Skills Demonstrated

This project demonstrates practical knowledge of:

Linux administration
Bash scripting
Shell commands
Process and system monitoring
Networking fundamentals
TCP/IP concepts
DNS
Network troubleshooting
MySQL
SQL queries
Cron jobs
Linux file permissions
Configuration management
Git
GitHub
Automation

🔮 Future Enhancements

Possible future improvements include:

Web-based monitoring dashboard
Real-time monitoring
Email alerts
Telegram/WhatsApp notifications
CPU and memory threshold alerts
Historical graphs
Log analysis
Docker deployment
REST API integration
Cloud deployment
Prometheus and Grafana integration

👨‍💻 Author

Manoj S

B.Tech Information Technology

GitHub:
https://github.com/Manoj-Sivanandharaja

📜 License

This project is created for educational and portfolio purposes.
