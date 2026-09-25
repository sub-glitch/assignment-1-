# Linux System Administration Scripts

A collection of Bash scripts for performing basic Linux system administration and network checks.

## Scripts

* `system-info.sh` — Displays system information such as the current user, hostname, kernel version, uptime, working directory, memory, operating system, and CPU information.
* `disk-check.sh` — Checks disk usage against a user-defined threshold and returns an appropriate exit status.
* `network-check.sh` — Checks hostname resolution, basic network connectivity, network interfaces, and optionally TCP connectivity to a specified port.

All scripts append their output to `logs/logs.log`.

---

## Installation / Setup

### Requirements

The scripts are designed to run on a Linux environment with Bash.

The following commands/utilities are used by the scripts:

* Bash
* `date`
* `hostname`
* `whoami`
* `uname`
* `uptime`
* `pwd`
* `free`
* `lscpu`
* `df`
* `awk`
* `grep`
* `sed`
* `cut`
* `tr`
* `getent`
* `ping`
* `ip`
* `nc` (required when performing TCP port checks)

### Setup

Clone or copy the project into a Linux environment, then navigate to the project directory:

```bash
cd assignment-1
```

Create the logging directory if it does not already exist:

```bash
mkdir -p logs
```

Make the scripts executable:

```bash
chmod +x system-info.sh disk-check.sh network-check.sh
```

The scripts will automatically append output to:

```text
logs/logs.log
```

---

## Usage

### 1. System Information

Run:

```bash
./system-info.sh
```

The script displays information including:

* Current user
* Hostname
* Date
* Kernel release
* System uptime
* Current working directory
* Total memory
* Memory usage percentage
* Operating system
* CPU model
* Number of CPU cores

Example:

```text
====================
[DATE] System Information
====================

Current User: user
Hostname: machine
Date: ...
Kernel release: ...
Uptime: ...
Working Directory: ...
Memory Total: ... MB
Memory Usage: ... %
Operating System: ...
CPU Information: ... (... Cores)
```

---

### 2. Disk Usage Check

Run:

```bash
./disk-check.sh <threshold>
```

A directory can optionally be supplied:

```bash
./disk-check.sh <threshold> <path>
```

If no path is provided, the script checks `/`.

Example:

```bash
./disk-check.sh 80
```

Or:

```bash
./disk-check.sh 80 /home
```

The threshold must be an integer between `1` and `100`.

#### Exit codes

| Exit code | Meaning                                          |
| --------- | ------------------------------------------------ |
| `0`       | Disk usage is below the threshold                |
| `1`       | Disk usage has reached or exceeded the threshold |
| `2`       | Invalid threshold input                          |

---

### 3. Network Check

Run:

```bash
./network-check.sh <hostname-or-ip>
```

A TCP port can optionally be supplied:

```bash
./network-check.sh <hostname-or-ip> <port>
```

Example:

```bash
./network-check.sh google.com
```

With a port:

```bash
./network-check.sh google.com 443
```

The script performs:

* Hostname/IP resolution
* Basic connectivity testing using `ping`
* Network interface information using `ip -br addr`
* Optional TCP connectivity testing using `nc`

Valid TCP ports are between `1` and `65535`.

#### Exit codes

| Exit code | Meaning                                          |
| --------- | ------------------------------------------------ |
| `0`       | Checks completed successfully                    |
| `1`       | Host resolution or TCP connectivity check failed |
| `2`       | Invalid input                                    |

---

## Testing

The scripts can be tested using valid, invalid, and boundary inputs.

### System information

```bash
./system-info.sh
```

Verify that system information is displayed and that a log entry is added to:

```text
logs/logs.log
```

### Disk check

Test a normal threshold:

```bash
./disk-check.sh 80
```

Test the lower boundary:

```bash
./disk-check.sh 1
```

Test the upper boundary:

```bash
./disk-check.sh 100
```

Test invalid input:

```bash
./disk-check.sh 0
./disk-check.sh 101
./disk-check.sh abc
```

Check the exit status after a command:

```bash
echo $?
```

Test an optional directory:

```bash
./disk-check.sh 80 /home
```

### Network check

Test hostname resolution and connectivity:

```bash
./network-check.sh google.com
```

Test TCP connectivity:

```bash
./network-check.sh google.com 443
```

Test an invalid port:

```bash
./network-check.sh google.com 0
./network-check.sh google.com 65536
./network-check.sh google.com abc
```

Test a missing host:

```bash
./network-check.sh
```

Test an invalid hostname:

```bash
./network-check.sh definitely-not-a-real-host-123456
```

Check the exit status:

```bash
echo $?
```

### Log verification

After running the scripts, inspect the log file:

```bash
cat logs/logs.log
```

The log contains timestamps and descriptions of the operations performed by the scripts.

---

## Assumptions

* The scripts are intended to run in a Linux environment.
* Bash is available as `/bin/bash`.
* Standard Linux system utilities used by the scripts are installed and available in the system `PATH`.
* `nc` (Netcat) is available when TCP port checking is required.
* The user has permission to execute the scripts and create/write to the `logs` directory.
* Disk usage is checked using the filesystem associated with the supplied path.
* If no disk path is supplied, `/` is used.
* The network connectivity test uses ICMP through `ping`; a failed ping does not necessarily mean that the host is unreachable because some hosts or networks may block ICMP traffic.
* The optional TCP check tests whether a connection can be established to the specified host and port.

---

## Logging

Each script redirects its output through `tee` and appends it to:

```text
logs/logs.log
```

Log entries include a timestamp and identify the operation being performed.

Example:

```text
====================
[DATE] Disk Check
====================
```



