# 🩺 System Health Report Generator (Shell Script)

This script generates a comprehensive **System Health Report** in both **plain text** (`.log`) and **HTML** (`.html`) format. It collects CPU, memory, disk, uptime, process, and system info in a visually modern report.

---

## 🧰 Tech Stack Used

| Component       | Technology Used | Contribution |
|----------------|------------------|--------------|
| Core Logic     | Bash Scripting   | 70%          |
| Data Extraction| `ps`, `df`, `uptime`, `top`, `hostname`, `grep`, `awk` | 20% |
| UI (HTML/CSS)  | HTML5 + CSS3     | 10%          |

---

## 🌟 Features

- 🖥️ Detects OS name, uptime, IP address
- 💾 Monitors disk usage, available space, and % used
- ⚙️ Fetches user/system CPU usage and idle percentage
- 🧠 Lists top 5 memory-consuming processes
- 🔥 Lists top 5 CPU-consuming processes
- 📄 Creates:
  - A structured `.log` file
  - A modern, responsive HTML report
- 🧑‍💻 Includes metadata (timestamp + author)

---

## 🏁 How It Works

1. Collects real-time data using Linux utilities.
2. Logs plain-text summary to a `.log` file.
3. Dynamically injects system stats and top processes into a styled HTML report.
4. Adds author and generation timestamp.

---

## 📂 Output Files

- `system_health_report_<timestamp>.log` — human-readable text summary
- `system_health_report_<timestamp>.html` — modern web-based report

---

## 🧩 Future Enhancements (Ideas)

- ⏰ Add cron job support for scheduled reports
- 📧 Email the HTML report to admin
- 📊 Visual charts using JavaScript (Chart.js, D3)
- 🌐 Auto-serve the HTML on a local web server
- 🔒 Include permission warnings or root check

---

## 👨‍💻 Author

- **Pratik Pandey**
- 📅 Script written on: `8th July 2025`

---
