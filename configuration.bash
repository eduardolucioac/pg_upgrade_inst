#!/bin/bash

# > -----------------------------------------
# NOTE: Configurations section (see README.TXT). By Questor

# NOTE: It doesn't have to be the same folder defined in the "data_directory" attribute
# of the older PostgreSQL version "postgresql.conf" file. This folder MUST BE A COPY
# of the existing folder in the old PostgreSQL version environment. By Questor
PG_OLD_DATA="/backup/data_old"

PG_OLD_USR_LIB_PG_FLD="/usr/lib/postgresql"
PG_OLD_USR_SHARE_PG_FLD="/usr/share/postgresql"
PG_OLD_VER_FLD="9.3"
PG_OLD_SSL_KEY_GRP="ssl-cert"

# NOTE: It MUST NOT BE the same folder defined in the "data_directory" attribute
# of the newer PostgreSQL version "postgresql.conf" file. It will be created by the
# "script" in the location defined here. By Questor
PG_NEW_DATA="/dados/sinj-db/data_new"

PG_NEW_USR_LIB_PG_FLD="/usr/lib/postgresql"
PG_NEW_VER_FLD="9.4"
PG_NEW_SVC_START_CMD="systemctl start postgresql"
PG_NEW_SVC_STOP_CMD="systemctl stop postgresql"

# NOTE: It must be the same as the older PostgreSQL version data. By Questor
PG_NEW_INITDB_E="UTF-8"
PG_NEW_INITDB_LOCAL="pt_BR.UTF-8"

DISTRO_SHARED_LIB_FLD="/lib/x86_64-linux-gnu"

# NOTE: This command is used to add the language defined in the "DISTRO_SHARED_LIB_FLD"
# parameter to your distribution. By Questor
LOCALE_GEN_CMD="locale-gen $PG_NEW_INITDB_LOCAL"

# < -----------------------------------------
