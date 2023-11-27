#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
# Global variables
MLMMJ_ROOT="/var/spool/mlmmj"
TABLES_DIR="$MLMMJ_ROOT/tables"
TRANSPORT_FILE="$TABLES_DIR/transport"
VIRTUAL_FILE="$TABLES_DIR/virtual"
symlink_dir="$MLMMJ_ROOT/$domain"

transport_entry="$app@localhost.mlmmj       mlmmj:$app"
virtual_entry="$list_name@$domain    $app@localhost.mlmmj"

CRON_DIR="/etc/cron.d/mlmmj"
cron_file="$CRON_DIR/$app.cron"
MLMMJRECEIVE="/usr/local/bin/mlmmj-receive"
MLMMJMAINTD="/usr/local/bin/mlmmj-maintd"

installed_version=""
REQUIRED_VERSION=$(cat ../mlmmj_version)

MLMMJ_SHARE="/usr/local/share/mlmmj"
lang_dir="$MLMMJ_SHARE/text.skel/$language"

#=================================================
# PERSONAL HELPERS
#=================================================
install_update_mlmmj() {
    local required_version=$1

    if command -v mlmmj-list >/dev/null 2>&1; then
        installed_version=$(mlmmj-list -V | cut -d ' ' -f3)
        ynh_script_progression --message="mlmmj is already installed with version: $installed_version"

        if [ "$required_version" != "$installed_version" ]; then
            ynh_script_progression --message="Updating mlmmj to the required version $required_version;"
        fi
    else
        ynh_script_progression --message="mlmmj is not installed, proceeding with installation;"
    fi

    if [ "$required_version" != "$installed_version" ]; then
        ynh_script_progression --message="Installing necessary packages"
        ynh_install_app_dependencies autoconf make gcc pkg-config libatf-dev
        ynh_script_progression --message="Downloading and installing mlmmj release"
        ynh_setup_source --dest_dir="mlmmj-latest" || ynh_die "Failed to download mlmmj"
        pushd mlmmj-latest
        autoreconf -i && ./configure && make && sudo make install || ynh_die "Failed to install mlmmj binaries"
        popd
        ynh_secure_remove "mlmmj-latest"
    fi
}
#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
