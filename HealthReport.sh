#!/bin/bash
#Author:- Pratik Pandey
#Date: 8th July 2025


REPORT_FILE="system_health_report_$(date +%Y%m%d_%H%M%S).log"
OUTPUT_HTML_FILE="system_health_report_$(date +%Y%m%d_%H%M%S).html"

#Variables

date=$(date '+%Y-%m-%d %H:%M:%S')

os_name=$(grep ^PRETTY_NAME /etc/os-release | cut -d '=' -f2 | tr -d '"')
uptime=$(uptime -p)

disk_size=$(df -h / | tail -1 | awk '{print $2}')
available=$(df -h / | tail -1 | awk '{print $4}')
percentage_used=$(df -h / | tail -1 | awk '{print $5}')

cpu_line=$(top -bn1 | grep "Cpu(s)")
cpu_usage_apps=$(echo "$cpu_line" | awk '{print $2}')   # user %
system_cpu_usage=$(echo "$cpu_line" | awk '{print $4}') # system %
idle_cpu=$(echo "$cpu_line" | awk '{print $7}' | cut -d',' -f2)       # idle %

root_process=$(ps -U root -u root | tail -n +2 | wc -l)
running_process=$(ps -e | wc -l)

memory_consuming_process=$(ps -aefo uid,pid,ppid,cmd,%mem --sort=-%mem | head -n 6)
cpu_consuming_process=$(ps -aefo uid,pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6)

ip_addr=$(hostname -i)


######################################### INSERT In LOG File ########################################################

# Header
{
  echo "#####################################"
  echo "     SYSTEM HEALTH CHECK REPORT"
  echo "     Generated on : $(date '+%Y-%m-%d %H:%M:%S')"
  echo "#####################################"
  echo ""
} >> "$REPORT_FILE"

# OS Name
echo "OS NAME: ${os_name}" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
# Uptime
echo "UPTIME: ${uptime}" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "IP ADDRESS: ${ip_addr}" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Disk Usage
{
  echo "DISK USAGE:"
  echo "  Total Size of Disk: ${disk_size}"
  echo "  Available Size:     ${available}"
  echo "  Percentage Used:    ${percentage_used}"
  echo ""
} >> "$REPORT_FILE"

# CPU Usage
{
  echo "CPU USAGE:"
  echo "  User CPU Usage (Apps):     ${cpu_usage_apps}"
  echo "  System CPU Usage (Kernel): ${system_cpu_usage}"
  echo "  Idle (Free CPU%):          ${idle_cpu}"
  echo ""
} >> "$REPORT_FILE"

echo "TOTAL NUMBER OF PROCESS RUNNING: ${running_process}" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Total number of root processes running
echo "Total NUMBER OF ROOT PROCESS RUNNING: ${root_process}" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Top 5 MEMORY CONSUMING PROCESS: " >> "${REPORT_FILE}"
echo "${memory_consuming_process}" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Top 5 CPU CONSUMING PROCESS: " >> "${REPORT_FILE}"
echo "${cpu_consuming_process}" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Footer
{
  echo "#####################################"
  echo "            END OF REPORT"
  echo "#####################################"
  echo ""
} >> "$REPORT_FILE"






#################################### INSERT In HTML FILE ###########################################################

cat <<EOF > ${OUTPUT_HTML_FILE}
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>System Health Report</title>
  <style>
   body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background: #f0f2f5;
  margin: 0;
  padding: 40px 20px;
  color: #333;
}

h1 {
  text-align: center;
  font-size: 2.5rem;
  margin-bottom: 10px;
  color: #222;
}

h2 {
  text-align: center;
  font-size: 1.5rem;
  margin: 30px 0 20px;
  font-weight: 500;
  color: #444;
  position: relative;
}

h2::after {
  content: '';
  display: block;
  height: 2px;
  width: 60px;
  background-color: #007acc;
  margin: 10px auto 0;
  border-radius: 1px;
}

table {
  margin: 30px auto;
  border-collapse: collapse;
  width: 95%;
  background: #ffffff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
  transition: box-shadow 0.3s ease;
}

table:hover {
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

th, td {
  border-bottom: 1px solid #eaeaea;
  padding: 16px 20px;
  text-align: left;
}

th {
  background-color: #1a1a1a;
  color: #fff;
  font-weight: 600;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}

td {
  color: #555;
  font-size: 0.95rem;
}

tr:nth-child(even) {
  background-color: #f8f9fa;
}

tr:hover {
  background-color: #e6f2ff;
  transition: background-color 0.2s ease-in-out;
}
caption {
      caption-side: bottom;
      padding: 10px;
      font-size: 14px;
      color: #777;
    }

  </style>
</head>
<body>
  <h1>System Health Report</h1>
  <table>
    <thead>
      <tr>
        <th>Metric</th>
        <th>Value</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>OS</td>
        <td>${os_name}</td>
      </tr>
      <tr>
        <td>Uptime</td>
        <td>${uptime}</td>
      </tr>
      <tr>
        <td>IP Address</td>
        <td>${ip_addr}</td>
      </tr>
    </tbody>
  </table>
<h2>Disk Usage</h2>
 <table>
    <thead>
      <tr>
        <th>Metric</th>
        <th>Value</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Total Size of Disk</td>
        <td>${disk_size}</td>
      </tr>
      <tr>
        <td>Available Size</td>
        <td>${available}</td>
      </tr>
      <tr>
        <td>Used</td>
        <td>${percentage_used}</td>
      </tr>
    </tbody>
  </table>
<h2>CPU Usage</h2>
 <table>
    <thead>
      <tr>
        <th>Metric</th>
        <th>Value</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>User CPU Usage (Apps)</td>
        <td>${cpu_usage_apps}</td>
      </tr>
      <tr>
        <td>System CPU Usage (Kernel)</td>
        <td>${system_cpu_usage}</td>
      </tr>
      <tr>
        <td>Idle (Free CPU%)</td>
        <td>${idle_cpu}</td>
      </tr>
      <tr>
        <td>Total Number of Process Running</td>
        <td>${root_process}</td>
      </tr>
      <tr>
        <td>Total Number of Root Process Running</td>
        <td>${running_process}</td>
      </tr>
    </tbody>
  </table>
<h2>Top 5 Memory Consuming Process</h2>
 <table>
    <thead>
      <tr>
        <th>UID</th>
        <th>PID</th>
	<th>PPID</th>
 	<th>CMD</th>
 	<th>%MEM</th>
      </tr>
    </thead>
EOF

#Skip Header
ps -aefo uid,pid,ppid,cmd,%mem --sort=-%mem | head -n 6 | tail -n +2 | while read -r uid pid ppid cmd mem; do

cat <<EOF >> ${OUTPUT_HTML_FILE}
<tr>
	<td>$uid</td>
	<td>$pid</td>
	<td>$ppid</td>
	<td>$cmd</td>
	<td>$mem</td>

</tr>
EOF
done

cat <<EOF >> ${OUTPUT_HTML_FILE}
</table>
<h2>Top 5 CPU Consuming Process</h2>
<table>
    <thead>
      <tr>
        <th>UID</th>
        <th>PID</th>
        <th>PPID</th>
        <th>CMD</th>
        <th>%MEM</th>
      </tr>
    </thead>
EOF

#Skip Header
ps -aefo uid,pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6 | tail -n +2 | while read -r uid pid ppid cmd cpu; do

cat <<EOF >> ${OUTPUT_HTML_FILE}
<tr>
        <td>$uid</td>
        <td>$pid</td>
        <td>$ppid</td>
        <td>$cmd</td>
        <td>$cpu</td>

</tr>
EOF
done

cat <<EOF >> ${OUTPUT_HTML_FILE}
</table>
<caption>
	Report Generated On: ${date}<br>
  	Script written by: Pratik Pandey
</caption>
</body>
</html>
EOF

echo "Process report saves as: "
echo "${REPORT_FILE}"
echo "${OUTPUT_HTML_FILE}"




