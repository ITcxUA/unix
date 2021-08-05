#Examples (TL;DR)
#Initialize a backup repository in the specified local directory:
restic init --repo path/to/repository
#Backup a directory to the repository:
restic --repo path/to/repository backup path/to/directory
#Show backup snapshots currently stored in the repository:
restic --repo path/to/repository snapshots
#Restore a specific backup snapshot to a target directory:
restic --repo path/to/repository restore latest|snapshot_id --target path/to/target
#Restore a specific path from a specific backup to a target directory:
restic --repo path/to/repository restore snapshot_id --target path/to/target --include path/to/restore
#Clean up the repository and keep only the most recent snapshot of each unique backup:
restic forget --keep-last 1 --prune
tldr.sh

#Synopsis
restic [flags]

#Description
restic is a backup program which allows saving multiple revisions of files and directories in an encrypted repository stored on different backends.

#Options
--cacert=[]
file to load root certificates from (default: use system certificates)

--cache-dir=""
set the cache directory. (default: use system default cache directory)

--cleanup-cache[=false]
auto remove old cache directories

-h,  --help[=false]
help for restic

--json[=false]
set output mode to JSON for commands that support it

--key-hint=""
key ID of key to try decrypting first (default: $RESTIC_KEY_HINT)

--limit-download=0
limits downloads to a maximum rate in KiB/s. (default: unlimited)

--limit-upload=0
limits uploads to a maximum rate in KiB/s. (default: unlimited)

--no-cache[=false]
do not use a local cache

--no-lock[=false]
do not lock the repository, this allows some operations on read-only repositories

-o,  --option=[]
set extended option (key=value, can be specified multiple times)

--password-command=""
shell command to obtain the repository password from (default: $RESTIC_PASSWORD_COMMAND)

-p,  --password-file=""
file to read the repository password from (default: $RESTIC_PASSWORD_FILE)

-q,  --quiet[=false]
do not output comprehensive progress report

-r,  --repo=""
repository to backup to or restore from (default: $RESTIC_REPOSITORY)

--repository-file=""
file to read the repository location from (default: $RESTIC_REPOSITORY_FILE)

--tls-client-cert=""
path to a file containing PEM encoded TLS client certificate and private key

-v,  --verbose[=0]
be verbose (specify multiple times or a level using --verbose=n, max level/times is 3)
