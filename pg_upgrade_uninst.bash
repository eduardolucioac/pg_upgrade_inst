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
# NOTE: Removes old PostgreSQL resources. By Questor

rm -vrf "$PG_OLD_USR_LIB_PG_FLD/$PG_OLD_VER_FLD"
rm -vrf "$PG_OLD_USR_SHARE_PG_FLD/$PG_OLD_VER_FLD"

# < -----------------------------------------

# > -----------------------------------------
# NOTE: Removes old PostgreSQL configurations from data folder. By Questor

rm -vf "$PG_OLD_DATA/postgresql.conf"

# < -----------------------------------------

exit 0
