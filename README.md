# Daemonized SFTP sync'er

### Running

```sh
Daemon to watch local directory for changes and
upload them via sftp.

Usage: sftp-watcher.sh [-v] -s <source_dir_path> -u <sftp_username> -h <destination_host> -P <destination_port> -p <destination_path> -t <temporary_path>
```

### Testing
Spin up a local sftp server using docker:

```sh
make docker/run
sftp -P 2222 foo@localhost
```

Stop docker server:
```sh
make docker/stop
```

## See Also
* SFTP Server: https://hub.docker.com/r/atmoz/sftp/