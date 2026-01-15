# Process & Chrome Recovery Script

## Overview

This project contains a Windows automation script created with ChatGPT help for internal use at our workplace, where **20+ locations** operate **Windows 11 PCs** running **Google Chrome** to access a **web-based application**.

The web application relies on a background process called **PSRV**, which is responsible for communication between the web app and **PC peripherals** such as:
- Printers
- Card readers
- Other connected devices

Occasionally, the PSRV process becomes unresponsive or stops working, causing some or all peripherals to fail.

---

## The Problem

When the issue occurs, the standard manual recovery procedure is:
1. Open **Task Manager**
2. End the **PSRV** process
3. Start the PSRV process again
4. Close **Google Chrome**
5. Clear Chrome’s cache
6. Restart Google Chrome

This process is repetitive, error-prone, and inconvenient for end users.

---

## The Solution

This script automates the entire recovery procedure into **a single click**.

### What the Script Does

1. **PSRV Process Handling**
   - Checks if the **PSRV** process is running
   - If running → terminates and restarts it
   - If not running → starts it

2. **Google Chrome Recovery**
   - Closes Google Chrome
   - Clears the logged-in user's Chrome cache
   - Restarts Google Chrome

3. **User Interface**
   - Displays a **blue modal “Processing” window** while tasks are running
   - The processing window **cannot be closed manually**
   - Once all tasks finish, the processing window closes automatically

4. **Result Summary**
   - A summary window appears after completion:
     - 🟢 **Green** → Success
     - 🔴 **Red** → Failure
   - Single **Close** button to exit the summary window

---

## User Experience

- One-click execution
- No technical interaction required
- No Task Manager access needed
- Clear visual feedback during and after execution

---

## Distribution

For a smooth end-user experience, the script is:
- Written as a PowerShell script
- Converted into a standalone **`.exe`** using **PS2EXE**

This allows the tool to be easily distributed and executed without exposing script logic to users.

---

## Intended Use

- Internal workplace support tool
- First-line recovery for PSRV / peripheral issues
- Reduces downtime and IT intervention

---

## Notes

- Designed for **Windows 11**
- Tested with **Google Chrome**
- Assumes PSRV is installed and accessible on the system

---

## Disclaimer

This tool is intended for internal use only.  
Modify and distribute according to your organization’s IT policies.
