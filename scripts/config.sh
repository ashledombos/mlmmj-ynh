#!/bin/bash

# -------------------------------------------------------------
# mlmmj config
# -------------------------------------------------------------

# Import YunoHost helpers
source /usr/share/yunohost/helpers
source _common.sh


ynh_abort_if_errors

# -------------------------------------------------------------
# Setters
# -------------------------------------------------------------

set__main_general_closedlist() {
    local closedlist_value=$(ynh_app_setting_get --app=$app --key=closedlist)
    local closedlist_file="$control_dir/closedlist"

    if [[ $closedlist_value == true ]]; then
        touch "$closedlist_file"
    else
        ynh_secure_remove "$closedlist_file"
    fi
}

set__main_general_moderated() {
    local closedlist_value=$(ynh_app_setting_get --app=$app --key=moderated)
    local moderated_file="$control_dir/moderated"
    if [[ $main_general_moderated == true ]]; then
        touch "$moderated_file"
    else
        ynh_secure_remove "$moderated_file"
    fi
}

# Execute the appropriate step
ynh_app_config_run $1
