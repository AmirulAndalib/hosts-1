[![Build Status](https://travis-ci.org/xwmx/hosts.svg?branch=master)](https://travis-ci.org/xwmx/hosts)

        __               __
       / /_  ____  _____/ /______
      / __ \/ __ \/ ___/ __/ ___/
     / / / / /_/ (__  ) /_(__  )
    /_/ /_/\____/____/\__/____/

# Hosts

`hosts` is a command line program for managing
[hosts file](https://en.wikipedia.org/wiki/Hosts_\(file\)) entries.

`hosts` works with existing hosts files and entries, making it easier to add,
remove, comment, and search hosts file entries using simple, memorable
commands.

`hosts` is designed to be lightweight, easy to use, and contained in a
single, portable script that can be `curl`ed into any environment.

## Installation

### Homebrew

To install with [Homebrew](http://brew.sh/):

```bash
brew install xwmx/taps/hosts
```

### npm

To install with [npm](https://www.npmjs.com/package/hosts.sh):

```bash
npm install --global hosts.sh
```

### bpkg

To install with [bpkg](https://github.com/bpkg/bpkg):

```bash
bpkg install xwmx/hosts
```

#### Make

To install with [Make](https://en.wikipedia.org/wiki/Make_(software)),
clone this repository, navigate to the clone's root directory, and run:

```bash
make install
```

### Manual

To install manually, simply add the `hosts` script to your `$PATH`. If
you already have a `~/bin` directory, you can use the following command:

```bash
curl -L https://raw.github.com/xwmx/hosts/master/hosts -o ~/bin/hosts && chmod +x ~/bin/hosts
```

A package for Arch users is also
[available in the AUR](https://aur.archlinux.org/packages/hosts/).

### Tab Completion

#### Tab Completion

Bash and Zsh tab completion is enabled when `hosts` is installed using
Homebrew, npm, bpkg, or Make. If you are installing `hosts` manually,
[completion can be enabled with a few commands](etc/README.md).

## Usage

### Listing Entries

`hosts` with no arguments lists the entries in the system's hosts file:

```bash
> hosts
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0     localhost
```

`hosts` called with a string or regular expression will search for entries
that match.

```bash
> hosts localhost
127.0.0.1   localhost
::1         localhost
fe80::1%lo0 localhost

> hosts '\d\d\d'
127.0.0.1         localhost
255.255.255.255   broadcasthost
```

### Adding Entries

To add an entry, use `hosts add`:

```bash
> hosts add 127.0.0.1 example.com
Added:
127.0.0.1 example.com
```

Run `hosts` or `hosts list` to see the new entry in the list:

```bash
> hosts
127.0.0.1         localhost
255.255.255.255   broadcasthost
::1               localhost
fe80::1%lo0       localhost
127.0.0.1         example.com
```

### Removing Entries

To remove an entry, use `hosts remove`, which can take an IP
address, domain, or regular expression:

```bash
> hosts remove example.com
Removing the following records:
127.0.0.1	example.com
Are you sure you want to proceed? [y/N] y
Removed:
127.0.0.1	example.com
```

### Blocking and Unblocking Domains

`hosts` provides easy commands for blocking and unblocking domains with IPv4
and IPv6 entries:

```bash
> hosts block example.com
Added:
127.0.0.1   example.com
Added:
fe80::1%lo0 example.com
Added:
::1         example.com

> hosts unblock example.com
Removed:
127.0.0.1   example.com
Removed:
fe80::1%lo0 example.com
Removed:
::1         example.com
```

### Enabling / Disabling Entries

Add entries are enabled by default. Disabiling an entry comments it out
so it has no effect, but remains in the hosts file ready to be enabled
again.

```bash
> hosts
127.0.0.1         localhost
255.255.255.255   broadcasthost
::1               localhost
fe80::1%lo0       localhost
127.0.0.1         example.com

> hosts disable example.com
Disabling:
127.0.0.1	example.com

> hosts
127.0.0.1         localhost
255.255.255.255   broadcasthost
::1               localhost
fe80::1%lo0       localhost

Disabled:
---------
127.0.0.1         example.com

> hosts enable example.com
Enabling:
127.0.0.1	example.com

> hosts
127.0.0.1         localhost
255.255.255.255   broadcasthost
::1               localhost
fe80::1%lo0       localhost
127.0.0.1         example.com
```

### Backups

Create backups of your hosts file with `hosts backups create`:

```bash
> hosts backups create
Backed up to /etc/hosts--backup-20200101000000
```

List your backups with `hosts backups`. If you have existing hosts file
backups, `hosts` will include them:

```bash
> hosts backups
hosts--backup-20200101000000
hosts.bak
```

`hosts backups compare` will open your hosts file with `diff`:

```bash
> hosts backups compare hosts--backup-20200101000000
--- /etc/hosts	2020-01-01 00:00:00.000000000
+++ /etc/hosts--backup-20200101000000	2020-01-01 00:00:00.000000000
@@ -8,3 +8,4 @@
 255.255.255.255  broadcasthost
 ::1              localhost
 fe80::1%lo0      localhost
+127.0.0.1        example.com
```

View a backup with `hosts backups show`:

```bash
> hosts backups show hosts--backup-20200101000000
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0     localhost
127.0.0.1       example.com
```

Restore a backup with `hosts backups restore`. Before a backup is
restored, a new one is created to avoid data loss:

```bash
> hosts backups restore hosts--backup-20200101000000
Backed up to /etc/hosts--backup-20200102000001
Restored from backup: hosts--backup-20200101000000
```

### Viewing and Editing `/etc/hosts` Directly

`hosts file` prints the raw contents of `/etc/hosts`:

```bash
> hosts file
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0     localhost
```

`hosts edit` opens `/etc/hosts` in your editor:

```bash
> hosts edit
```

### `--auto-sudo`

When the `--auto-sudo` flag is used, all write operations that require
`sudo` will automatically rerun the command using `sudo` when the current user
does not have write permissions for the hosts file.

To have this option always enabled, add the following line to your shell
configuration (`.bashrc`, `.zshrc`, or similar):

```bash
alias hosts="hosts --auto-sudo"
```

## Help

```text
Usage:
  hosts [<search string>]
  hosts add <ip> <hostname> [<comment>]
  hosts backups [create | (compare | delete | restore | show) <filename>]
  hosts block <hostname>...
  hosts disable (<ip> | <hostname> | <search string>)
  hosts disabled
  hosts edit
  hosts enable (<ip> | <hostname> | <search string>)
  hosts enabled
  hosts file
  hosts list [enabled | disabled | <search string>]
  hosts search <search string>
  hosts show (<ip> | <hostname> | <search string>)
  hosts remove (<ip> | <hostname> | <search string>) [--force]
  hosts unblock <hostname>...
  hosts --auto-sudo
  hosts -h | --help
  hosts --version

Options:
  --auto-sudo  Run write commands with `sudo` automatically.
  -h --help    Display this help information.
  --version    Display version information.

Help:
  hosts help [<command>]
```

For full usage, run:

```text
hosts help
```

For help with a particular command, try:

```text
hosts help <command name>
```

## Commands

### `hosts`

```text
Usage:
  hosts [<search string>]

Description:
  List the existing IP / hostname pairs, optionally limited to a specified
  state. When provided with a seach string, all matching enabled records will
  be printed.

  Alias for `hosts list`
```

### `hosts add`

```text
Usage:
  hosts add <ip> <hostname> [<comment>]

Description:
  Add a given IP address and hostname pair, along with an optional comment.
```

### `hosts backups`

```text
Usage:
  hosts backups
  hosts backups create
  hosts backups compare <filename>
  hosts backups delete  <filename>
  hosts backups restore <filename> [--skip-backup]
  hosts backups show    <filename>

Subcommands:
  backups           List available backups.
  backups create    Create a new backup of the hosts file.
  backups compare   Compare a backup file with the current hosts file.
  backups delete    Delete the specified backup.
  backups restore   Replace the contents of the hosts file with a
                    specified backup. The hosts file is automatically
                    backed up before being overwritten unless the
                    '--skip-backup' flag is specified.
  backups show      Show the contents of the specified backup file.

Description:
  Manage backups.
```

### `hosts block`

```text
Usage:
  hosts block <hostname>...

Description:
  Block one or more hostnames by adding new entries assigned to `127.0.0.1`
  for IPv4 and both `fe80::1%lo0` and `::1` for IPv6.
```

#### Blocklists

- [jmdugan/blocklists](https://github.com/jmdugan/blocklists)
- [notracking/hosts-blocklists](https://github.com/notracking/hosts-blocklists)

### `hosts commands`

```text
Usage:
  hosts commands [--raw]

Options:
  --raw  Display the command list without formatting.

Description:
  Display the list of available commands.
```

### `hosts disable`

```text
Usage:
  hosts disable (<ip> | <hostname> | <search string>)

Description:
  Disable one or more records based on a given ip address, hostname, or
  search string.
```

### `hosts disabled`

```text
Usage:
  hosts disabled

Description:
  List all disabled records. This is an alias for `hosts list disabled`.
```

### `hosts edit`

```text
Usage:
  hosts edit

Description:
  Open the /etc/hosts file in your $EDITOR.
```

### `hosts enable`

```text
Usage:
  hosts enable (<ip> | <hostname> | <search string>)

Description:
  Enable one or more disabled records based on a given ip address, hostname,
  or search string.
```

### `hosts enabled`

```text
Usage:
  hosts enabled

Description:
  List all enabled records. This is an alias for `hosts list enabled`.
```

### `hosts file`

```text
Usage:
  hosts file

Description:
  Print the entire contents of the /etc/hosts file.
```

### `hosts help`

```text
Usage:
  hosts help [<command>]

Description:
  Display help information for hosts or a specified command.
```

### `hosts list`

```text
Usage:
  hosts list [enabled | disabled | <search string>]

Description:
  List the existing IP / hostname pairs, optionally limited to a specified
  state. When provided with a seach string, all matching enabled records will
  be printed.
```

### `hosts remove`

```text
Usage:
  hosts remove (<ip> | <hostname> | <search string>) [--force]
  hosts remove <ip> <hostname>

Options:
  --force  Skip the confirmation prompt.

Description:
  Remove one or more records based on a given IP address, hostname, or search
  string. If an IP and hostname are both provided, only records matching the
  IP and hostname pair will be removed.
```

### `hosts search`

```text
Usage:
  hosts search <search string>

Description:
  Search entries for <search string>.
```

### `hosts show`

```text
Usage:
  hosts show (<ip> | <hostname> | <search string>)

Description:
  Print entries matching a given IP address, hostname, or search string.
```

### `hosts unblock`

```text
Usage:
  hosts unblock <hostname>...

Description:
  Unblock one or more hostnames by removing the entries from the hosts file.
```

### `hosts version`

```text
Usage:
  hosts (version | --version)

Description:
  Display the current program version.
```

## Tests

To run the test suite, install [Bats](https://github.com/sstephenson/bats) and
run `bats test` in the project root directory.

## Acknowledgements

- https://gist.github.com/nddrylliog/1368532
- https://gist.github.com/dfeyer/1369760
- https://github.com/macmade/host-manager

