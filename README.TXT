> -----------------------------------------

This script contains the old PostgreSQL 9.3 binaries extracted from an Ubuntu Server
14.04. These binaries are required to run the "pg_upgrade" binary from the newer
PostgreSQL 9.4 (it must be installed on the destination server).

The idea of this script is to allow the user to update PostgreSQL data in a new environment
without having to install an old version of it or when this is not possible, or even
when the export("pg_dump")/importing("pg_restore") data failed.

This script also synthesizes several solutions found to avoid problems with the use
of the "pg_upgrade" binary.

You can adapt, adjust and improve this script to your needs.

< -----------------------------------------

Thanks!
By Questor
