# Installation instructions

## Homebrew

Installing via Homebrew with `brew install xwmx/taps/hosts` will also
install the completion scripts. The extra steps to install `hosts` completion
scripts outlined below are *not needed*.

A one-time setup might be needed to [enable completion for all Homebrew
programs](https://docs.brew.sh/Shell-Completion).

## npm

Installing via npm should install the completion scripts. If completion
isn't working, try the instructions below.

## Scripts

`hosts` includes scripts for installing and uninstalling completions.

- [install-completion.bash](../scripts/install-completion.bash)
- [uninstall-completion.bash](../scripts/uninstall-completion.bash)

These scripts will try to determine the completion installation
locations from your environment. If completion doesn't work, you might
need to try installing manually.

## Manual Installation

### bash

#### Linux

On a current Linux OS (in a non-minimal installation), bash completion should
be available.

Place the completion script in `/etc/bash_completion.d/`:

```bash
sudo curl -L https://raw.githubusercontent.com/xwmx/hosts/master/hosts-completion.bash -o /etc/bash_completion.d/hosts
```

#### macOS

If you aren't installing with homebrew, source the completion script in
`.bash_profile`:

```sh
if [[ -f /path/to/hosts-completion.bash ]]
then
  source /path/to/hosts-completion.bash
fi
```

### zsh

Place the completion script in your `/path/to/zsh/completion` (typically
`~/.zsh/completion/`):

```bash
$ mkdir -p ~/.zsh/completion
$ curl -L https://raw.githubusercontent.com/xwmx/hosts/master/hosts-completion.zsh > ~/.zsh/completion/_hosts
```
Include the directory in your `$fpath` by adding in `~/.zshrc`:

```bash
fpath=(~/.zsh/completion $fpath)
```

Make sure `compinit` is loaded or do it by adding in `~/.zshrc`:

```bash
autoload -Uz compinit && compinit -i
```

Then reload your shell:

```bash
exec $SHELL -l
```
