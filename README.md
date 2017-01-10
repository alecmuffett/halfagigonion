# Rough Outline

Warning: some commands in these scripts are from my environment, i will fix that later.

- `00*.sh` - shared by master and workers, common code
- `01*.sh` - run on workers, to do with backend onion services
- `02*.sh` - run on master, to do with onionbalance
- other files - general purpose / interactive tools

# Filesystem Layout

- all this lives in `$HOME/master.d`, on the master
- the `master-push.sh` script clones `master.d` to `worker.d` on the workers
- workers and master alike all use `$HOME/tmp` for local storage
- master also replicates `$HOME/tmp` from workers to `remote.d`

# Commands for CHARGEN (for load-testing)

- using OSX, netcat & TorBrowserBundle
  - `nc -X 5 -x localhost:9150 $onion 19`
    - nb: this will abort if you try to background it, because it tries to read from stdin
      - OSX lacks the `-d` option to `nc` which addresses this
    - probably easiest to run this command 2/more times in separate tabs/terminals
- using Linux & a default Tor SOCKS port
  - `nc -d -X 5 -x localhost:9050 $onion 19`
    - use port 9150 if reusing a `TorBrowserBundle` SOCKS instance

# Commands for HTTP (for debugging, not for load-testing)

- using TorBrowserBundle
  - `curl --proxy socks5h://localhost:9150 http://$onion/`
- using Tor default SOCKS port
  - `curl --proxy socks5h://localhost:9050 http://$onion/`
