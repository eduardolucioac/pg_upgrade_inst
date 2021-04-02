#!/bin/bash

# > -----------------------------------------
# NOTE: Run that script with bash even if the user use sh/dash or any sh like
# interpreter. This way it correctly works with either...
# "sh ./my_script.bash" or "bash ./my_script.bash" or "./my_script.bash".
# By Questor

if [ -z "$BASH_VERSION" ]
then
    exec bash "$0" "$@"
fi

# < -----------------------------------------

# NOTE: Avoid problems with relative paths. By Questor
SCRIPTDIR_V="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $SCRIPTDIR_V/ez_i.bash

# > -----------------------------------------
# NOTE: Loads the configuration section. By Questor

. $SCRIPTDIR_V/configuration.bash

# < -----------------------------------------

cd "$SCRIPTDIR_V"

# > -----------------------------------------
# NOTE: To create a folder with necessary write permissions to execute the "pg_upgrade".
# By Questor

# NOTE: Getting the parent of a directory in Bash. By Questor
# [Ref.: https://stackoverflow.com/a/8426110/3223785 ]
PG_UPG_EXEC_FLD="$(dirname $SCRIPTDIR_V)/pg_upg_exec_fld"

# NOTE: Remove old operation logs if exists. By Questor
rm -vrf "$PG_UPG_EXEC_FLD"

mkdir "$PG_UPG_EXEC_FLD"
chown -R postgres "$PG_UPG_EXEC_FLD"
chown -R :postgres "$PG_UPG_EXEC_FLD"
chmod -R 700 "$PG_UPG_EXEC_FLD"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Records the time the operation started. By Questor

echo " >>>> BEGIN! - $(date -Ins) " | tee -a "$PG_UPG_EXEC_FLD/pg_upgrade_general.log"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Copy old PostgreSQL resources. By Questor

mkdir -vp "$PG_OLD_USR_LIB_PG_FLD"
cp -var "$SCRIPTDIR_V/pg_mcn_root$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD" \
    "$PG_OLD_USR_LIB_PG_FLD/"

chown -R postgres "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD"
chown -R :postgres "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD"
chmod -R 700 "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD"

mkdir -vp "$PG_OLD_USR_SHARE_PG_FLD"
cp -var "$SCRIPTDIR_V/pg_mcn_root$PG_OLD_USR_SHARE_PG_FLD/$PG_OLD_VER_FLD" \
    "$PG_OLD_USR_SHARE_PG_FLD/"

chown -R postgres "$PG_OLD_USR_SHARE_PG_FLD/$PG_OLD_VER_FLD"
chown -R :postgres "$PG_OLD_USR_SHARE_PG_FLD/$PG_OLD_VER_FLD"
chmod -R 700 "$PG_OLD_USR_SHARE_PG_FLD/$PG_OLD_VER_FLD"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Adjuste some old PostgreSQL configurations ("postgresql.conf"). By Questor

f_ez_sed \
    "<PG_OLD_DATA>" \
    "$PG_OLD_DATA" \
    "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/postgresql/$PG_OLD_VER_FLD/main/postgresql.conf"

f_ez_sed \
    "<PG_OLD_USR_LIB_PG_FLD>" \
    "$PG_OLD_USR_LIB_PG_FLD" \
    "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/postgresql/$PG_OLD_VER_FLD/main/postgresql.conf" \
    1

f_ez_sed \
    "<PG_OLD_VER_FLD>" \
    "$PG_OLD_VER_FLD" \
    "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/postgresql/$PG_OLD_VER_FLD/main/postgresql.conf" \
    1

# NOTE: Copy adjusted "postgresql.conf" to old data folder since it is required by
# "pg_upgrade" command. By Questor
\cp -var \
    "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/postgresql/$PG_OLD_VER_FLD/main/postgresql.conf" \
    "$PG_OLD_DATA/"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Gives proper permissions to some files and folders. By Questor

chown root "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/ssl/certs/ssl-cert-snakeoil.pem"
chown :root "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/ssl/certs/ssl-cert-snakeoil.pem"
chmod 644 "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/ssl/certs/ssl-cert-snakeoil.pem"

chown root "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/ssl/private/ssl-cert-snakeoil.key"
eval "chown :$PG_OLD_SSL_KEY_GRP \"$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/ssl/private/ssl-cert-snakeoil.key\""
chmod 640 "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/ssl/private/ssl-cert-snakeoil.key"

chown -R postgres "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/var/run/postgresql"
chown -R :postgres "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/var/run/postgresql"
chmod -R 2775 "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/var/run/postgresql"

chown -R postgres "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/postgresql/$PG_OLD_VER_FLD/main"
chown -R :postgres "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/postgresql/$PG_OLD_VER_FLD/main"
chmod -R 700 "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/etc/postgresql/$PG_OLD_VER_FLD/main"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Adjusts "old_data" folder permissions. By Questor

# IMPORTANT: If you have problems like "permission denied" with this directory. I
# recommend you take a look at this thread: https://dba.stackexchange.com/a/287555/67304 .
# By Questor
chown -R postgres "$PG_OLD_DATA"
chown -R :postgres "$PG_OLD_DATA"
chmod -R 700 "$PG_OLD_DATA"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Generates a location configuration equal to that of old data. By Questor

eval "$LOCALE_GEN_CMD"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Prepares and initializes a new data folder. THIS DATA FOLDER CANNOT BE THE
# SAME USED AND CONFIGURED for consumption of the new version of PostgreSQL. This
# new data folder will be informed on "pg_upgrade" command. By Questor

echo " >>>> Prepares and initializes a new data folder. - $(date -Ins) " | tee -a "$PG_UPG_EXEC_FLD/pg_upgrade_general.log"

rm -vrf "$PG_NEW_DATA"
mkdir "$PG_NEW_DATA"
chown -R postgres "$PG_NEW_DATA"
chown -R :postgres "$PG_NEW_DATA"
chmod -R 700 "$PG_NEW_DATA"
eval "$PG_NEW_SVC_STOP_CMD"

cd "$PG_UPG_EXEC_FLD"

# [Ref.: https://titanwolf.org/Network/Articles/Article?AID=a9a6ec6b-6a80-4269-bbc9-75def0969748#gsc.tab=0 ]
eval "sudo -u postgres $PG_NEW_USR_LIB_PG_FLD/$PG_NEW_VER_FLD/bin/initdb -E $PG_NEW_INITDB_E \
    --local=$PG_NEW_INITDB_LOCAL -D $PG_NEW_DATA 2>&1 | tee -a \"$PG_UPG_EXEC_FLD/pg_upgrade_general.log\""

eval "$PG_NEW_SVC_START_CMD"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: These libraries are required for the older version of PostgreSQL. By Questor

ln -vs \
    "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/lib/x86_64-linux-gnu/libcrypto.so.1.0.0" \
    "$DISTRO_SHARED_LIB_FLD/libcrypto.so.1.0.0"
ln -vs \
    "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/_ALTER_ROOT/lib/x86_64-linux-gnu/libssl.so.1.0.0" \
    "$DISTRO_SHARED_LIB_FLD/libssl.so.1.0.0"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Modify the new data folder from the old one (convert the old one). By Questor

echo " >>>> Modify the new data folder from the old one (convert the old one). - $(date -Ins) " | tee -a "$PG_UPG_EXEC_FLD/pg_upgrade_general.log"

cd "$PG_UPG_EXEC_FLD"

# [Ref.: https://unix.stackexchange.com/a/639748/61742 ]
eval "sudo -u postgres $PG_NEW_USR_LIB_PG_FLD/$PG_NEW_VER_FLD/bin/pg_upgrade \
    -b $PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD/bin -B $PG_NEW_USR_LIB_PG_FLD/$PG_NEW_VER_FLD/bin \
    -d $PG_OLD_DATA -D $PG_NEW_DATA 2>&1 | tee -a \"$PG_UPG_EXEC_FLD/pg_upgrade_general.log\""

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Removes the libraries used by the old version of PostgreSQL since they are
# no longer needed. By Questor

rm -vf "$DISTRO_SHARED_LIB_FLD/libcrypto.so.1.0.0"
rm -vf "$DISTRO_SHARED_LIB_FLD/libssl.so.1.0.0"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Records the time the operation ended. By Questor

echo " >>>> END! - $(date -Ins) " | tee -a "$PG_UPG_EXEC_FLD/pg_upgrade_general.log"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Prints some cool information. By Questor

echo " 
>>>> ADICIONAL INFORMATION:

 . See 
    \"$PG_UPG_EXEC_FLD/pg_upgrade_general.log\", 
    \"$PG_UPG_EXEC_FLD/pg_upgrade_internal.log\", 
    \"$PG_UPG_EXEC_FLD/pg_upgrade_server.log\" and 
    \"$PG_UPG_EXEC_FLD/pg_upgrade_utility.log\"
    for operation log.

 * If the operation was successful...

 . Use \"pg_upgrade_uninst.bash\" to uninstall;
 . Use \"$PG_UPG_EXEC_FLD/analyze_new_cluster.sh\" and \"$PG_UPG_EXEC_FLD/delete_old_cluster.sh\" \
for adicional \"pg_upgrade\" stuff.
"

# < -----------------------------------------

exit 0
