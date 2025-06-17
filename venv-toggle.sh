#!/bin/bash

# === CONFIGURATION ===
LANG_MODE="eng"       # "ru" или "eng"
LOG_LEVEL=2          # 0 = без логов, 1 = важно, 2 = максимум

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
    log_msg 1 "[Готово! venv активирован]" "[Done! venv activated]"
}

deactivate_venv() {
    log_msg 1 "[Отключение venv...]" "[Deactivating venv...]"
    deactivate
    log_msg 1 "[Готово! venv выключен]" "[Done! venv deactivated]"
}

# === COMMANDS ===

if [[ "$1" == "status" ]]; then
    if is_venv_active; then
        log_msg 1 "[venv включён]" "[venv is active]"
    else
        log_msg 1 "[venv выключен]" "[venv is inactive]"
    fi
    return
fi

log_msg 1 "[Переключение venv...]" "[Toggling venv...]"

if is_venv_active; then
    deactivate_venv
else
    if [ ! -d "$venv_path" ]; then
        create_venv
    fi
    activate_venv
fi
