#!/bin/bash
VERBOSE=0                   # Enable verbose output for logging.
SOURCE_DIR_PATH=""          # Root directory to "watch" for new files in.
SFTP_USER=""                # Username of the SFTP server to login with.
DESTINATION_HOST=""         # Hostname of the destination SFTP server
DESTINATION_PORT=22         # Port of sftp server.
DESTINATION_PATH=""         # Root directory to send files to on the destination.
TEMPORARY_DIR_PATH="./tmp"  # Temporary directory used to drop failed copies into.

#
# This function will display help information about this
# script with the -h argument is passed.
#
show_help() {

    echo "Daemon to watch local directory for changes and"
    echo "upload them via sftp."
    echo
    echo "Usage: `basename $0` [-v] -s <source_dir_path> -u <sftp_username> -h <destination_host> -p <destination_path> -t <temporary_path>"
    echo

}

#
# Helper function
#
function get_date() {

    date '+%Y-%m-%d %H:%M:%S'

}

#
# Parse options passed to this script.
#
while getopts ":s:u:h:P:p:t:v:" opt; do

  case $opt in

    v) VERBOSE=1                    ;;
    s) SOURCE_DIR_PATH=$OPTARG      ;;
    u) SFTP_USER=$OPTARG            ;;
    h) DESTINATION_HOST=$OPTARG     ;;
    P) DESTINATION_PORT=$OPTARG     ;;
    p) DESTINATION_PATH=$OPTARG     ;;
    t) TEMPORARY_DIR_PATH=$OPTARG   ;;

    \?) echo "Invalid option: -$OPTARG" >&2
      ;;

  esac

done

if [ $VERBOSE -eq 1 ]; then

    echo "*** START DATE...........: $(get_date)"
    echo "*** SOURCE_DIR_PATH......: $SOURCE_DIR_PATH"
    echo "*** SFTP_USER............: $SFTP_USER"
    echo "*** DESTINATION_HOST.....: $DESTINATION_HOST"
    echo "*** DESTINATION_PORT.....: $DESTINATION_PORT"
    echo "*** DESTINATION_PATH.....: $DESTINATION_PATH"
    echo "*** TEMPORARY_DIR_PATH...: $TEMPORARY_DIR_PATH"

fi

cd $SOURCE_DIR_PATH

#
# Start "main" endless loop which sleeps for 1 second after each iteration.
#
while true; do

    #
    # Use find command to find any existing files under $SOURCE_DIR_PATH.
    #
    for f in `find . -type file`; do

        #
        # Perform sftp command.
        #
        echo put $f $DESTINATION_PATH | sftp -P $DESTINATION_PORT $SFTP_USER@$DESTINATION_HOST:$DESTINATION_PATH

        #
        # Check to see if sftp copy command exited successfuly.
        #
        if [ $? -eq 0 ]; then

            echo $(get_date) [COPYING] $f [TO] $SFTP_USER@$DESTINATION_HOST:$DESTINATION_PORT:$DESTINATION_PATH = SUCCESS

        #
        # sftp command failed
        #
        else

            echo $(get_date) [COPYING] $f [TO] $SFTP_USER@$DESTINATION_HOST:$DESTINATION_PORT:$DESTINATION_PATH = FAIL

        fi

    #
    # End of "for" loop
    #
    done

    #
    # Sleep for 1 second to prevent hammering the server.
    #
    sleep 1

#
# End of "main" loop
#
done