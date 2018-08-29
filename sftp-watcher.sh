#!/bin/bash
# 
# Source Directory
# Destination Host
# Destination Path
# 
OPTIND=1                # Reset in case getopts has been used previously in the shell.
VERBOSE=0               # Enable verbose output for logging.
SOURCE_DIR_PATH=""      # Root directory to "watch" for new files in.
DESTINATION_HOST=""     # Hostname of the destination SFTP server
DESTINATION_PATH=""     # Root directory to send files to on the destination.

#
# This function will display help information about this
# script with the -h argument is passed.
#
show_help() {

    echo "Daemon to watch local directory for changes and"
    echo "upload them via sftp."
    echo
    echo "Usage: `basename $0` [-v] -s <source_dir_path> -d <destination_host> -p <destination_path>"
    echo
}

#
# Parse options passed to this script.
#
while getopts "h?vf:" opt; do

    case "$opt" in

    h|\?)
        show_help
        exit 0
        ;;
    v)  VERBOSE=1
        ;;
    s)  SOURCE_DIR_PATH=$OPTARG
        ;;
    d)  DESTINATION_HOST=$OPTARG
        ;;
    p)  DESTINATION_PATH=$OPTARG
        ;;

    esac

done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

echo "verbose=$verbose, output_file='$output_file', Leftovers: $@"
