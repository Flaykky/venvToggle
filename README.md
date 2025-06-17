## venv-toggle.sh Documentation

This document provides detailed installation instructions, configuration options, and usage examples for the `venv-toggle.sh` script. The script allows you to toggle a Python virtual environment (venv) on and off, check its status, and control logging verbosity and language.

---

### Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Usage](#usage)

   * [Toggling the Virtual Environment](#toggling-the-virtual-environment)
   * [Checking Status](#checking-status)
5. [Logging and Localization](#logging-and-localization)
6. [Examples](#examples)
7. [Troubleshooting](#troubleshooting)
8. [License](#license)

---

## Prerequisites

Before using the script, ensure you have:

* **Bash** (tested with Bash v4+)
* **Python 3** installed on your system
* **`python3-venv` package** (for creating virtual environments)

To install the `python3-venv` package on Debian/Ubuntu:

```bash
sudo apt update
sudo apt install python3-venv
```

---

## Installation

1. **Download or create the script file**:

   ```bash
   cat << 'EOF' > ~/venv-toggle.sh
   #!/bin/bash

   # === CONFIGURATION ===
   LANG_MODE="ru"       # "ru" or "eng"
   LOG_LEVEL=2            # 0 = no logs, 1 = essential, 2 = verbose

   # === TRANSLATIONS ===
   log_msg() {
       local level=$1
       local msg_ru=$2
       local msg_en=$3

       if [ "$LOG_LEVEL" -ge "$level" ]; then
           if [ "$LANG_MODE" = "ru" ]; then
               echo "$msg_ru"
           else
               echo "$msg_en"
           fi
       fi
   }

   # === FUNCTIONS ===

   venv_path="./venv"
   is_venv_active() {
       [[ "$VIRTUAL_ENV" != "" ]]
   }

   create_venv() {
       log_msg 2 "[создание venv через python3 -m venv...]" "[creating venv with python3 -m venv...]"
       python3 -m venv "$venv_path"
   }

   activate_venv() {
       log_msg 2 "[активация venv...]" "[activating venv...]"
       source "$venv_path/bin/activate"
       log_msg 1 "[Done! venv activated]" "[Done! venv activated]"
   }

   deactivate_venv() {
       log_msg 1 "[Deactivating venv...]" "[Deactivating venv...]"
       deactivate
       log_msg 1 "[Done! venv deactivated]" "[Done! venv deactivated]"
   }

   # === COMMANDS ===

   if [[ "$1" == "status" ]]; then
       if is_venv_active; then
           log_msg 1 "[venv is active]" "[venv is active]"
       else
           log_msg 1 "[venv is inactive]" "[venv is inactive]"
       fi
       return
   fi

   log_msg 1 "[Toggling venv...]" "[Toggling venv...]"

   if is_venv_active; then
       deactivate_venv
   else
       if [ ! -d "$venv_path" ]; then
           create_venv
       fi
       activate_venv
   fi
   EOF
   ```

2. **Make the script executable**:

   ```bash
   chmod +x ~/venv-toggle.sh
   ```

3. **Add an alias** to your shell configuration (`~/.bashrc`, `~/.zshrc`, etc.):

   ```bash
   alias venv="source ~/venv-toggle.sh"
   ```

4. **Reload your shell** or open a new terminal:

   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

---

## Configuration

You can customize the script by editing the following variables at the top of `venv-toggle.sh`:

| Variable    | Description                         | Values        |
| ----------- | ----------------------------------- | ------------- |
| `LANG_MODE` | Sets the language for log messages. | `ru`, `eng`   |
| `LOG_LEVEL` | Controls verbosity of logging.      | `0`, `1`, `2` |

* **`LOG_LEVEL=0`**: No log messages.
* **`LOG_LEVEL=1`**: Only essential messages (e.g., toggling, activation, deactivation).
* **`LOG_LEVEL=2`**: Full debug log (creation, activation steps).

---

## Usage

### Toggling the Virtual Environment

Run the following command in your project directory:

```bash
venv
```

* If the venv **does not exist**, it will be created and activated.
* If the venv **exists but is inactive**, it will be activated.
* If the venv **is active**, it will be deactivated.

### Checking Status

To check whether the venv is currently active or inactive:

```bash
venv status
```

This will print a message indicating the current state.

---

## Logging and Localization

The script supports two languages for log messages:

* **Russian** (`ru`)
* **English** (`eng`)

And three verbosity levels:

* **0** – Logging disabled
* **1** – Essential messages only
* **2** – Full debug output

Example: To switch to English and minimal logging, set:

```bash
LANG_MODE="eng"
LOG_LEVEL=1
```

---

## Examples

```bash
# Initial toggle: create and activate venv
$ venv
[Toggling venv...]
[creating venv with python3 -m venv...]
[activating venv...]
[Done! venv activated]

# Check status
$ venv status
[venv is active]

# Toggle off
$ venv
[Deactivating venv...]
[Done! venv deactivated]
```

---

## Troubleshooting

* **`command not found: venv`**: Ensure you added the alias to your shell config and reloaded it.
* **Permission denied**: Make sure `venv-toggle.sh` is executable (`chmod +x`).
* **`python3: command not found`**: Install Python 3 or adjust the script to use your Python path.

---

## License

Distributed under the MIT License. See [LICENSE](LICENSE) file for details.

